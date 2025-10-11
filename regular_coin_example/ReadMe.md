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
