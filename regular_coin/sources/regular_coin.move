module regular_coin::regular_coin;


use sui::coin::Coin; // Gives you the Coin<T> type (the base structure that represents a token of type T).
use sui::coin_registry::{Self, CoinRegistry}; // Contains the functions and structures needed to create, register, and manage new coins on Sui.

const TOTAL_SUPPLY: u64 = 1000000000_000000000; // 1B supply if decimals == 9. However, note that the actual value of the decimal is stated below.


/* The type identifier of coin. The coin will have a type
tag of kind: `Coin<package_object::module::struct>`. Check the ReadMe for more info */
public struct MyCoin has key, store { // You actually do not need to explicitly add "store" if you already have "key". This is because, in Move, the "key" ability automatically implies "store" for all fields inside the struct. Check the ReadMe for more info
    id: UID // Unique on-chain object ID
}
// it is best practice to name the struct after the actual name of the coin or asset it represents. This improves code readability, maintainability, and clarity for anyone using or reviewing your code. Check out the readme for more details



#[allow(lint(self_transfer))] // This is an attribute that tells the Move compiler to ignore the warning that appears when an object is transferred to the same address that initiated the transaction. You'll see why below.

/// Here, a new currency is created without a OTW(One Time Witness (explained in the readme)) proof of uniqueness.
public fun new_currency(registry: &mut CoinRegistry, ctx: &mut TxContext): Coin<MyCoin> {
    let (mut currency, mut treasury_cap) = coin_registry::new_currency(
        registry,
        9, // This is where the actual decimal value is stated
        b"MYC".to_string(), // Symbol (Abbreviation) of your coin (e.g., SCA, NAVX, SUI) 
        b"MyCoin".to_string(), // Name of your coin
        b"Standard Unregulated Coin by Mello.sui".to_string(), // Description of your coin
        b"https://example.com/my_coin.png".to_string(), // Icon URL (The link to your logo, check the ReadMe for more info)
        ctx,
    );

    let total_supply = treasury_cap.mint(TOTAL_SUPPLY, ctx); // This line mints the initial supply of your coin (Check the ReadMe to understand HOW it works).
    currency.make_supply_burn_only(treasury_cap); // This line makes the coin's supply "burn-only" (Check the ReadMe to understand HOW it works).

    let metadata_cap = currency.finalize(ctx); // This line finalizes the creation of your coin
    
    /// Here, the recipient is the sender of the transaction. The linter would normally warn you, but the #[allow(lint(self_transfer))] suppresses that warning.
    transfer::public_transfer(metadata_cap, ctx.sender()); // This line transfers the MetadataCap object to the transaction sender. 
    
    total_supply
}