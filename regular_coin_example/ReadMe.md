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
