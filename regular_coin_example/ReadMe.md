# Creating a Regular Deflationary Coin on Sui (Move Tutorial) - Part 2: Publishing and Minting

>This guide shows you how to mint a deflationary coin on the Sui blockchain using Move. It mints the total supply, and keeps the ability to update your coin’s currency metadata (name, symbol, icon, and description) whenever you want. 
>
> You'll learn about PTBs, Sui's object model and Transaction flow, and how they (alongside other concepts) all come together to create a fungible token (coin).

---

## 🧠 Before You Begin

**Estimated Time to Completion:** 15-25 minutes  

**Prerequisites**
- Successfully Completed [Part 1]()
- A little curiosity, patience, and ☕  

---

## Understanding What’s Going On

I know you're probably wondering why your coin doesn't exist yet, well that's because all we did was run `sui move build`

What does that do? Just know that it basically compiles your code and checks for any errors

#### To actually create the coin, we need to do 2 key things:

1. Publish it
2. Call the function `new_currency`

---

So, here we are actually going to **"create"** the coin:

#### Before we continue:
- The name of the package in this example is `regular_coin_example`
- The name of the coin is `MelloCoin`
- The name of the struct is also `MelloCoin` (remember why)
- The name of the module is `regular_coin`
- Check out the source code [here]()

---

After building with `sui move build`, if you followed this guide correctly, there shouldn't be any errror, but if you see an error, go through your code to see if you made any mistake or typo

#### Your result should look like:

```bash
INCLUDING DEPENDENCY Bridge
INCLUDING DEPENDENCY SuiSystem
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING regular_coin_example
Total number of linter warnings suppressed: 1 (unique lints: 1)
```
[insert regular coin build.png]

---

Now that we have successfully built our package, the next step now is to publish our package to the sui network.

#### To do that:

**Run:** `sui client publish`

**Scroll to:** ```Object Changes```

#### It should look like this:

[insert sui client publish example.png]

---

### Now lets disect what happened:

#### 1. **Creation of the `UpgradeCap` Object**
First we can see that a new object was created, the `UpgradeCap`.

When you publish a package, Sui creates an `UpgradeCap` object.  

- **Purpose:** This object gives the publisher the ability to upgrade the package in the future.

- **Details you can inspect:**  
  - **ObjectID:** Unique identifier for the `UpgradeCap`.
  - **Owner:** The account that owns the capability.
  - **ObjectType:** Always `0x2::package::UpgradeCap` for this object.
  - **Version:** Tracks if the capability has changed.
  - **Digest:** Hash of the object’s state.

---

#### 2. **Mutation of the SUI Coin Object**

Secondly we can see that an object was mutated, `SUI`.

Publishing a package costs gas, which is paid in SUI. The SUI coin object in your wallet is mutated to reflect the deduction.

- **Details you can inspect:**  

  - **ObjectType:** `0x2::coin::Coin<0x2::sui::SUI>`
  - **Owner:** Your account.
  - **Version:** Increments after mutation.
  - **Digest:** New hash after the transaction.

---

#### 3. **Publishing the Package**

Lastly, we can see that an object was published, the Package (which was `regular_coin_example`), now exists on the sui network, on-chain (whenever you see/hear "on-chain", it basically means that whatever they're referring to now has an address that can be used to verify the authenticity of the action through an explorer, in Sui's case, they're indicating that the item is an object and can be verified through an ID ), and its module is also onchain.

- **Details you can inspect:**

  - **PackageID:** Unique identifier for the package.
  - **Version:** Starts at 1.
  - **Digest:** Hash of the package.
  - **Modules:** List of modules published (e.g., `regular_coin_example`).

---

#### **On-Chain Verification**

So now this basically means that i can pick out any of the IDs and **verify** who the **sender** or the **owner** of the **object** is, the **type of object** it is (is it a coin? is it a capability? is it a package? etc), the **version of the object** (has it been altered/upgraded?), and lastly the **transaction digest** (to dig deeper into the object)

---

Disecting what happened during a transaction is very crucial for beginners, because it will help you understand the Sui object model and transaction flow.

If you want to see these details for any object, you can use any Sui explorer or even the Sui CLI to inspect by object ID.

---



> **But how do i actually see the coin i created? At the moment, i can't see it, it's not in my wallet**.

When you run `sui client publish`, **you are only deploying your Move package** (the smart contract code).  
**This does NOT automatically create or mint any coins.**

To do that, we would have to `call` the function that creates or mints the coins.

But before that, for context, Devnet was reset at time i was making this guide, so i had to re-publish the package which gave me a different PackageID. For the rest of this guide, my new PackageID is `0x2d081f04e119f6a35e9a1e154513cf94be267845283b00c591c5344fb6e902eb`

### Now, there are two main ways to `call` the function:

#### 1. Using `sui client call`:

```bash
sui client call --package 0x2d081f04e119f6a35e9a1e154513cf94be267845283b00c591c5344fb6e902eb --module regular_coin --function new_currency --args @0xc
```

But because we are just returning an object (`total_supply`) inside a function (`new_currency`), we can't use this method. Using it would result to an error like:

``` bash
failure due to UnusedValueWithoutDrop
```

This is because Move is strict about resource management. 

Every value must be used, moved, stored, returned, or dropped (if it has the drop ability).

If you just “leave” something unused at the end of a function, Move panics with `UnusedValueWithoutDrop`.

But in our case, we **DID** return something, which was `total_supply`, so what could actually be the **real issue** here?

So, you see, by calling `new_currency`, we are trying to mint coins right? But ask yourself, **WHERE** are these coins going to? 

Exactly! So we need to somehow mint **AND** transfer the minted coins to our address, at the **same** time.

That can only be done with **PTBs**

You can try it to see for yourself :)

---

#### 2. Using PTBs (Programmable Transaction Blocks):

```bash
sui client ptb --move-call 0x2d081f04e119f6a35e9a1e154513cf94be267845283b00c591c5344fb6e902eb::regular_coin::new_currency @0xc --assign "total_supply" --transfer-objects "[total_supply]" @0x53e18124ca06bf820af
73d64254e852e2e0801ec1a44dd07b1c0ef39c6ab2707
```

A PTB (Programmable Transaction Block) in Sui is a way to **compose** and **execute multiple actions** (like Move calls, object transfers, coin splits, etc.) in a **single transaction**.

What can you do with PTBs?

- `Publish` Move packages
- Call Move functions (`move-call`)
- `Assign` results to variables
- `Transfer` objects
- `Split`/`Merge` coins
- `Create vectors` of Move values

**So, let's breakdown what happened in our PTB command step-by-step:**

```bash
sui client ptb \
  --move-call 0x2d081f04e119f6a35e9a1e154513cf94be267845283b00c591c5344fb6e902eb::regular_coin::new_currency @0xc \
  --assign "total_supply" \
  --transfer-objects "[total_supply]" @0x53e18124ca06bf820af73d64254e852e2e0801ec1a44dd07b1c0ef39c6ab2707
```

#### What each part does:

1. **`--move-call 0x2d08...::regular_coin::new_currency @0xc`**
   - This calls the `new_currency` function in the `regular_coin` module at the specified address(the **PackageID** of `regular_coin_example`).
   - `@0xc` is the argument passed to the function (which is the address of **`CoinRegistry`**).

2. **`--assign "total_supply"`**
   - The result of the `move-call` is assigned to a variable named `total_supply`.
   - This means whatever object or value that is returned by `new_currency` **will now be referenced as** `total_supply` in the next steps.

3. **`--transfer-objects "[total_supply]" @0x53e18124ca06bf820af73d64254e852e2e0801ec1a44dd07b1c0ef39c6ab2707`**
   - This transfers the object(s) in the list `[total_supply]` to the address `0x53e18124ca06bf820af73d64254e852e2e0801ec1a44dd07b1c0ef39c6ab2707`.
   - Here, the list contains only one value, which is the variable `total_supply` that we got earlier, and transfers it to "`0x53e18...707`" which is my address.

#### What happened in this transaction?
 
- We called a function to create a new currency.

- The result (which is an object (`total_supply`, in line 41) representing the total coins minted with the value that we set in line 7 (`TOTAL_SUPPLY`),  was assigned to `total_supply`).

- We then transferred this `total_supply` object to a specific address (Which is my address).

---
