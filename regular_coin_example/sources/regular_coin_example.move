// refer to the ReadME to understand how this code works.

module regular_coin_example::regular_coin;

use sui::coin::Coin;
use sui::coin_registry::{Self, CoinRegistry};

const TOTAL_SUPPLY: u64 = 1000000000_000000000;

public struct MelloCoin has key, store {
    id: UID 
}

#[allow(lint(self_transfer))]

public fun new_currency(registry: &mut CoinRegistry, ctx: &mut TxContext): Coin<MelloCoin> {
    let (mut currency, mut treasury_cap) = coin_registry::new_currency(
        registry,
        9,
        b"MLC".to_string(),
        b"MelloCoin".to_string(),
        b"Standard Unregulated Coin example by Mello.sui".to_string(),
        b"https://github.com/FavourEjiogu/Currency/blob/main/images/mypfp.png?raw=true".to_string(),
        ctx,
    );

    let total_supply = treasury_cap.mint(TOTAL_SUPPLY, ctx);
    currency.make_supply_burn_only(treasury_cap);

    let metadata_cap = currency.finalize(ctx); 
    
   
    transfer::public_transfer(metadata_cap, ctx.sender());
    
    total_supply
}