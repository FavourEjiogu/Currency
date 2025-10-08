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
