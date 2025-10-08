# Creating a Regular Deflationary Coin on Sui (Move Tutorial)

>This guide shows you how to create a deflationary coin on the Sui blockchain using Move. Upon initialization, it mints the total supply and gives up the TreasuryCap to make the supply deflationary (meaning no new coins can ever be minted, but existing ones can still be burned).
It also keeps the ability to update your coin’s currency metadata (name, symbol, icon, and description) whenever you want.
You’ll understand how decimals, type tags, and coin metadata all come together step by step.
---

## 🧠 Before You Begin

**Estimated Time to Completion:** 15-25 minutes  

**Prerequisites**
- Basic understanding of what Sui and Move are  
- The [Sui CLI](https://docs.sui.io/guides/developer/getting-started/sui-install) installed and configured  
- A GitHub account (optional, but useful for hosting your coin icon)  
- A little curiosity, patience, and ☕  

---

## ⚙️ Setup
### 🧩 Step 1: Create the package

If you don’t already have one, create a new package for your coin:

```
sui move new regular_coin

```

This command creates a folder structure like this:

```
regular_coin/
│
├── Move.toml
└── sources/
    └── regular_coin.move

```

### 🪙 Step 2: Populate the code

Paste the code from **[here](https://github.com/FavourEjiogu/Currency/blob/main/regular_coin/sources/regular_coin.move)** inside:

```
📂 regular_coin/sources/regular_coin.move
```

That’s where your actual Move code for this guide should live.

Once you’ve added the code, verify everything is fine by building your package:

```
sui move build
```

If no errors show up, you’re ready to go 🚀

The rest of this README explains how and why that code works, line by line, concept by concept.

---

## 🪙 Understanding What’s Going On

In line 7, i know you're probably wondering why theres way more than 9 zeros if the total supply is going to be just 1 billion. if you are, that means you are inquisitive just like me :)

You see in crypto, especially when in context of currency and currency creation, we have something called decimals, they are not exactly what you were taught in school (1.59, 2.87, etc) but not entirely different.

A decimal in crypto refers to the number of decimal places a cryptocurrency can be divided into. Unlike traditional fiat currencies, which typically use two decimal places (e.g., dollars and cents) where the smallest unit is usually 1/100 of the smallest note (e.g., 1 cent is 1/100 of 1$), most cryptocurrencies like Bitcoin (BTC) and Sui (SUI) are divisible down to 8 decimal places or more.

This high degree of divisibility is crucial for several reasons:

* **Microtransactions:** It allows for the valuation and transaction of tiny fractions of a cryptocurrency, making it suitable for small purchases and microtransactions.
* **Accessibility:** It ensures that transactions remain accessible regardless of the asset's value, even as the price appreciates significantly.
* **Precision:** It enables greater precision in transaction handling, particularly important for complex smart contract operations and gas fee calculations.

Now dont get me wrong, figures like 2.82 SUI still exist, but this is actually represented as 2.820000000 SUI (and ofcourse we know that the trailing zeros behind a decimal point doesn't matter)

This is because SUI supports up to 9 decimal places (because 1 SUI = 1,000,000,000 MIST).
This means you can see amounts like:
1.123456789 SUI in your wallet

It is generally considered best practice to create coins that follow the same decimal standard as the parent chain (in Sui’s case, 9 decimals), especially for tokens that are meant to be widely used, traded, or paired with SUI.

**Why Match the Decimal Standard?**

* User Experience: Consistency with SUI makes it easier for users to understand and compare values.
* Interoperability: DEXs, wallets, and other dApps expect 9 decimals for SUI and may assume the same for other coins, reducing the risk of display or calculation errors.
* Integration: Many DeFi protocols and infrastructure tools are optimized for the native decimal standard.

### So in our example:

If you write:

```move
const TOTAL_SUPPLY: u64 = 1000000000;
```

This means the value of `TOTAL_SUPPLY` is exactly **one billion** (1,000,000,000) with **no extra zeros** for decimal places.

#### What’s the difference?

* `const TOTAL_SUPPLY: u64 = 1000000000_000000000;`

  * Value: 1,000,000,000,000,000,000 (one quintillion)
  * If your coin uses 9 decimals, this represents **1 billion coins** (1,000,000,000.000000000 in human-readable form).
* `const TOTAL_SUPPLY: u64 = 1000000000;`

  * Value: 1,000,000,000 (one billion)
  * If your coin uses 9 decimals, this represents **one coin** (1.000000000 in human-readable form).

#### So now that means:

* The number you set for `TOTAL_SUPPLY` should match the number of coins you want to mint, including the number of decimals.
* If your coin has 9 decimals, and you want a total supply of "1,000,000,000.000000000" coins, you must use `1000000000_000000000` (1,000,000,000,000,000,000).
* If you use just `1000000000`, you are only minting "1.000000000" coins (if displayed with 9 decimals).

#### Summary:

The value should also include all the zeros for the decimal places.

---

#### One question i usually get asked frequently at developer workshops is:

> "Is the Underscore basically representation of a decimal point?"

The answer is **No**

**Please note that** (`_`) **does not** represent a decimal point. Instead, Sui Move uses an underscore (`_`) as a digit separator for readability, similar to how you might write `1,000,000` for one million. This is a common pattern in Move (and many other languages) to make large numbers easier to read.

#### So that means:

* `1000000000_000000000` is exactly the same as `1,000,000,000,000,000,000`.
* The underscore is ignored by the compiler; it’s just for humans.
* The underscore is just to improve readability.

#### For example:

```move
const TOTAL_SUPPLY: u64 = 1000000000_000000000; // 1B supply (if decimals == 9)
```

---

When you look up transaction data or a digest on Sui, you often see references to object types, especially for coins. For example, the comment you saw on line 10-11:

/* The type identifier of coin. The coin will have a type
tag of kind: `Coin<package_object::module::struct>`. */

**What does this mean?**

* **Type Tag**: In Sui, every object (including coins) has a type tag that uniquely identifies what kind of object it is. For coins, the type tag looks like `0x2::coin::Coin<package_object::module::struct>`.
* **Why does it matter?**

  * When you query transaction data or look up an object by its digest, you will see this type tag in the response.
  * This tag tells you exactly what kind of coin or object you are dealing with. For example, SUI itself is `0x2::coin::Coin<0x2::sui::SUI>`, but a custom coin would have its own type, like `Coin<0x123...::my_module::my_struct>`.
  * If you are building dApps, wallets, or explorers, you need to filter, display, or process objects based on their type tags.

**Use cases:**

* **Identifying Coins**: If you want to know if an object is a coin, you check its type tag.
* **Custom Coins**: If you create your own coin, it will have a unique type tag.
* **APIs and Queries**: When using Sui APIs (like GraphQL or RPC), you often filter or search for objects by their type tag.

**Summary:**
So basically, the type tag is how Sui (and you) know what kind of object or coin you are dealing with. It is essential for filtering, displaying, and interacting with coins and other objects on Sui.

**Should the struct be named after the coin?**

Yes, it is best practice to name the struct after the actual name of the coin or asset it represents.

**Why?**

* **Clarity:** When someone sees `struct MyCoin`, it’s immediately clear what the struct represents.
* **Consistency:** It matches the type tag, which will be `Coin<package::module::MyCoin>`, making it easier to reason about types and avoid confusion.
* **Ecosystem Standards:** The [Sui Move conventions](https://docs.sui.io/concepts/sui-move-concepts/conventions) recommend clear, descriptive names for structs, especially for key objects like coins.
* This improves code readability, maintainability, and clarity for anyone using or reviewing your code.

#### For example:

```move
public struct MyCoin has key, store {
    id: UID
}
```

This is a **good** practice.

**Does it matter technically?**

**Well, Technically:** No, the Move language and Sui do not require the struct name to match the coin’s branding or intended use. The type tag will always be `Coin<package::ModuleName::StructName>`, regardless of what you call `StructName`. However, using a descriptive name is **highly recommended** for the reasons above.

---
