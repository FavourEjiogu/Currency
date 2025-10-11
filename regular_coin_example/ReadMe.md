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
