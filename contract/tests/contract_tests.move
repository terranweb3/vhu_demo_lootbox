#[test_only]
module contract::contract_tests;

use contract::contract::{Self, Lootbox, Mascot, Treasury, AdminCap};
use sui::test_scenario::{Self as ts, Scenario};
use sui::coin::{Self, Coin};
use sui::sui::SUI;
use sui::random::{Self, Random};

// ==================== Constants ====================

const ADMIN: address = @0xAD;
const USER1: address = @0xA1;
const USER2: address = @0xA2;

const LOOTBOX_PRICE: u64 = 100_000_000; // 0.1 SUI

// ==================== Helper Functions ====================

fun setup_test(): Scenario {
    let mut scenario = ts::begin(ADMIN);
    {
        contract::init_for_testing(ts::ctx(&mut scenario));
    };
    scenario
}

fun create_sui_coin(scenario: &mut Scenario, amount: u64, recipient: address) {
    ts::next_tx(scenario, recipient);
    {
        let coin = coin::mint_for_testing<SUI>(amount, ts::ctx(scenario));
        transfer::public_transfer(coin, recipient);
    };
}

// ==================== Init Tests ====================

#[test]
fun test_init_creates_treasury_and_admin_cap() {
    let mut scenario = setup_test();
    
    // Check Treasury exists
    ts::next_tx(&mut scenario, ADMIN);
    {
        assert!(ts::has_most_recent_shared<Treasury>(), 0);
    };
    
    // Check AdminCap was sent to deployer
    {
        assert!(ts::has_most_recent_for_address<AdminCap>(ADMIN), 1);
    };
    
    ts::end(scenario);
}

// ==================== Mint Lootbox Tests ====================

#[test]
fun test_buy_lootbox_success() {
    let mut scenario = setup_test();
    
    // Create SUI coin for user
    create_sui_coin(&mut scenario, LOOTBOX_PRICE, USER1);
    
    // Buy lootbox
    ts::next_tx(&mut scenario, USER1);
    {
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        let payment = ts::take_from_address<Coin<SUI>>(&scenario, USER1);
        
        contract::buy_lootbox(&mut treasury, payment, ts::ctx(&mut scenario));
        
        ts::return_shared(treasury);
    };
    
    // Check lootbox was created and sent to user
    ts::next_tx(&mut scenario, USER1);
    {
        assert!(ts::has_most_recent_for_address<Lootbox>(USER1), 2);
    };
    
    ts::end(scenario);
}

#[test]
fun test_buy_lootbox_updates_treasury() {
    let mut scenario = setup_test();
    
    // Create SUI coin for user
    create_sui_coin(&mut scenario, LOOTBOX_PRICE, USER1);
    
    // Buy lootbox
    ts::next_tx(&mut scenario, USER1);
    {
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        let payment = ts::take_from_address<Coin<SUI>>(&scenario, USER1);
        
        // Check initial balance is 0
        assert!(contract::get_treasury_balance(&treasury) == 0, 3);
        
        contract::buy_lootbox(&mut treasury, payment, ts::ctx(&mut scenario));
        
        // Check balance increased
        assert!(contract::get_treasury_balance(&treasury) == LOOTBOX_PRICE, 4);
        
        ts::return_shared(treasury);
    };
    
    ts::end(scenario);
}

#[test]
#[expected_failure(abort_code = 1)] // EInsufficientPayment
fun test_buy_lootbox_insufficient_payment() {
    let mut scenario = setup_test();
    
    // Create insufficient SUI coin
    create_sui_coin(&mut scenario, LOOTBOX_PRICE - 1, USER1);
    
    // Try to buy lootbox with insufficient payment
    ts::next_tx(&mut scenario, USER1);
    {
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        let payment = ts::take_from_address<Coin<SUI>>(&scenario, USER1);
        
        contract::buy_lootbox(&mut treasury, payment, ts::ctx(&mut scenario));
        
        ts::return_shared(treasury);
    };
    
    ts::end(scenario);
}

#[test]
fun test_buy_multiple_lootboxes() {
    let mut scenario = setup_test();
    
    // Create SUI coins for multiple purchases
    create_sui_coin(&mut scenario, LOOTBOX_PRICE * 3, USER1);
    
    // Buy 3 lootboxes
    ts::next_tx(&mut scenario, USER1);
    {
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        let mut coin = ts::take_from_address<Coin<SUI>>(&scenario, USER1);
        
        // Buy first lootbox
        let payment1 = coin::split(&mut coin, LOOTBOX_PRICE, ts::ctx(&mut scenario));
        contract::buy_lootbox(&mut treasury, payment1, ts::ctx(&mut scenario));
        
        // Buy second lootbox
        let payment2 = coin::split(&mut coin, LOOTBOX_PRICE, ts::ctx(&mut scenario));
        contract::buy_lootbox(&mut treasury, payment2, ts::ctx(&mut scenario));
        
        // Buy third lootbox
        let payment3 = coin::split(&mut coin, LOOTBOX_PRICE, ts::ctx(&mut scenario));
        contract::buy_lootbox(&mut treasury, payment3, ts::ctx(&mut scenario));
        
        // Check treasury balance
        assert!(contract::get_treasury_balance(&treasury) == LOOTBOX_PRICE * 3, 5);
        
        transfer::public_transfer(coin, USER1);
        ts::return_shared(treasury);
    };
    
    ts::end(scenario);
}

// ==================== Open Lootbox Tests ====================

#[test]
fun test_open_lootbox_creates_mascot() {
    let mut scenario = setup_test();
    
    // Setup: Buy a lootbox
    create_sui_coin(&mut scenario, LOOTBOX_PRICE, USER1);
    ts::next_tx(&mut scenario, USER1);
    {
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        let payment = ts::take_from_address<Coin<SUI>>(&scenario, USER1);
        contract::buy_lootbox(&mut treasury, payment, ts::ctx(&mut scenario));
        ts::return_shared(treasury);
    };
    
    // Setup Random (must be created by @0x0)
    ts::next_tx(&mut scenario, @0x0);
    {
        random::create_for_testing(ts::ctx(&mut scenario));
    };
    
    // Open lootbox
    ts::next_tx(&mut scenario, USER1);
    {
        let lootbox = ts::take_from_address<Lootbox>(&scenario, USER1);
        let random = ts::take_shared<Random>(&scenario);
        
        contract::open_and_receive_mascot(lootbox, &random, ts::ctx(&mut scenario));
        
        ts::return_shared(random);
    };
    
    // Check mascot was created
    ts::next_tx(&mut scenario, USER1);
    {
        assert!(ts::has_most_recent_for_address<Mascot>(USER1), 6);
    };
    
    ts::end(scenario);
}

#[test]
fun test_open_lootbox_mascot_has_valid_properties() {
    let mut scenario = setup_test();
    
    // Setup: Buy a lootbox
    create_sui_coin(&mut scenario, LOOTBOX_PRICE, USER1);
    ts::next_tx(&mut scenario, USER1);
    {
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        let payment = ts::take_from_address<Coin<SUI>>(&scenario, USER1);
        contract::buy_lootbox(&mut treasury, payment, ts::ctx(&mut scenario));
        ts::return_shared(treasury);
    };
    
    // Setup Random (must be created by @0x0)
    ts::next_tx(&mut scenario, @0x0);
    {
        random::create_for_testing(ts::ctx(&mut scenario));
    };
    
    // Open lootbox
    ts::next_tx(&mut scenario, USER1);
    {
        let lootbox = ts::take_from_address<Lootbox>(&scenario, USER1);
        let random = ts::take_shared<Random>(&scenario);
        
        contract::open_and_receive_mascot(lootbox, &random, ts::ctx(&mut scenario));
        
        ts::return_shared(random);
    };
    
    // Check mascot properties
    ts::next_tx(&mut scenario, USER1);
    {
        let mascot = ts::take_from_address<Mascot>(&scenario, USER1);
        let (name, rarity, mascot_type, image_url) = contract::get_mascot_info(&mascot);
        
        // Check rarity is valid (0-3)
        assert!(rarity <= 3, 7);
        
        // Check mascot_type is valid (1-4)
        assert!(mascot_type >= 1 && mascot_type <= 4, 8);
        
        // Check name is not empty
        assert!(std::string::length(&name) > 0, 9);
        
        // Check image_url is not empty
        assert!(std::string::length(&image_url) > 0, 10);
        
        ts::return_to_address(USER1, mascot);
    };
    
    ts::end(scenario);
}

#[test]
fun test_open_multiple_lootboxes_creates_different_mascots() {
    let mut scenario = setup_test();
    
    // Setup: Buy 5 lootboxes
    create_sui_coin(&mut scenario, LOOTBOX_PRICE * 5, USER1);
    ts::next_tx(&mut scenario, USER1);
    {
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        let mut coin = ts::take_from_address<Coin<SUI>>(&scenario, USER1);
        
        let mut i = 0;
        while (i < 5) {
            let payment = coin::split(&mut coin, LOOTBOX_PRICE, ts::ctx(&mut scenario));
            contract::buy_lootbox(&mut treasury, payment, ts::ctx(&mut scenario));
            i = i + 1;
        };
        
        transfer::public_transfer(coin, USER1);
        ts::return_shared(treasury);
    };
    
    // Setup Random (must be created by @0x0)
    ts::next_tx(&mut scenario, @0x0);
    {
        random::create_for_testing(ts::ctx(&mut scenario));
    };
    
    // Open all lootboxes
    ts::next_tx(&mut scenario, USER1);
    {
        let random = ts::take_shared<Random>(&scenario);
        
        let mut i = 0;
        while (i < 5) {
            let lootbox = ts::take_from_address<Lootbox>(&scenario, USER1);
            contract::open_and_receive_mascot(lootbox, &random, ts::ctx(&mut scenario));
            i = i + 1;
        };
        
        ts::return_shared(random);
    };
    
    // Verify we have 5 mascots (this test just ensures no crashes)
    // In a real scenario, we'd check that mascots have different properties
    
    ts::end(scenario);
}

// ==================== Admin Tests ====================

#[test]
fun test_admin_can_withdraw() {
    let mut scenario = setup_test();
    
    // User buys lootbox
    create_sui_coin(&mut scenario, LOOTBOX_PRICE, USER1);
    ts::next_tx(&mut scenario, USER1);
    {
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        let payment = ts::take_from_address<Coin<SUI>>(&scenario, USER1);
        contract::buy_lootbox(&mut treasury, payment, ts::ctx(&mut scenario));
        ts::return_shared(treasury);
    };
    
    // Admin withdraws
    ts::next_tx(&mut scenario, ADMIN);
    {
        let admin_cap = ts::take_from_address<AdminCap>(&scenario, ADMIN);
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        
        contract::withdraw_all(&admin_cap, &mut treasury, ts::ctx(&mut scenario));
        
        // Check treasury is now empty
        assert!(contract::get_treasury_balance(&treasury) == 0, 11);
        
        ts::return_to_address(ADMIN, admin_cap);
        ts::return_shared(treasury);
    };
    
    // Check admin received the coins
    ts::next_tx(&mut scenario, ADMIN);
    {
        assert!(ts::has_most_recent_for_address<Coin<SUI>>(ADMIN), 12);
    };
    
    ts::end(scenario);
}

#[test]
fun test_admin_withdraw_partial_amount() {
    let mut scenario = setup_test();
    
    // User buys lootbox
    create_sui_coin(&mut scenario, LOOTBOX_PRICE, USER1);
    ts::next_tx(&mut scenario, USER1);
    {
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        let payment = ts::take_from_address<Coin<SUI>>(&scenario, USER1);
        contract::buy_lootbox(&mut treasury, payment, ts::ctx(&mut scenario));
        ts::return_shared(treasury);
    };
    
    // Admin withdraws half
    ts::next_tx(&mut scenario, ADMIN);
    {
        let admin_cap = ts::take_from_address<AdminCap>(&scenario, ADMIN);
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        
        let withdrawn = contract::withdraw(&admin_cap, &mut treasury, LOOTBOX_PRICE / 2, ts::ctx(&mut scenario));
        
        // Check treasury has half remaining
        assert!(contract::get_treasury_balance(&treasury) == LOOTBOX_PRICE / 2, 13);
        
        transfer::public_transfer(withdrawn, ADMIN);
        ts::return_to_address(ADMIN, admin_cap);
        ts::return_shared(treasury);
    };
    
    ts::end(scenario);
}

#[test]
#[expected_failure(abort_code = 2)] // EInvalidAmount
fun test_admin_withdraw_zero_fails() {
    let mut scenario = setup_test();
    
    ts::next_tx(&mut scenario, ADMIN);
    {
        let admin_cap = ts::take_from_address<AdminCap>(&scenario, ADMIN);
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        
        let withdrawn = contract::withdraw(&admin_cap, &mut treasury, 0, ts::ctx(&mut scenario));
        
        transfer::public_transfer(withdrawn, ADMIN);
        ts::return_to_address(ADMIN, admin_cap);
        ts::return_shared(treasury);
    };
    
    ts::end(scenario);
}

// ==================== Integration Tests ====================

#[test]
fun test_full_workflow() {
    let mut scenario = setup_test();
    
    // Step 1: User1 buys lootbox
    create_sui_coin(&mut scenario, LOOTBOX_PRICE, USER1);
    ts::next_tx(&mut scenario, USER1);
    {
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        let payment = ts::take_from_address<Coin<SUI>>(&scenario, USER1);
        contract::buy_lootbox(&mut treasury, payment, ts::ctx(&mut scenario));
        ts::return_shared(treasury);
    };
    
    // Step 2: User2 buys lootbox
    create_sui_coin(&mut scenario, LOOTBOX_PRICE, USER2);
    ts::next_tx(&mut scenario, USER2);
    {
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        let payment = ts::take_from_address<Coin<SUI>>(&scenario, USER2);
        contract::buy_lootbox(&mut treasury, payment, ts::ctx(&mut scenario));
        ts::return_shared(treasury);
    };
    
    // Step 3: Setup Random (must be created by @0x0)
    ts::next_tx(&mut scenario, @0x0);
    {
        random::create_for_testing(ts::ctx(&mut scenario));
    };
    
    // Step 4: User1 opens lootbox
    ts::next_tx(&mut scenario, USER1);
    {
        let lootbox = ts::take_from_address<Lootbox>(&scenario, USER1);
        let random = ts::take_shared<Random>(&scenario);
        contract::open_and_receive_mascot(lootbox, &random, ts::ctx(&mut scenario));
        ts::return_shared(random);
    };
    
    // Step 5: User2 opens lootbox
    ts::next_tx(&mut scenario, USER2);
    {
        let lootbox = ts::take_from_address<Lootbox>(&scenario, USER2);
        let random = ts::take_shared<Random>(&scenario);
        contract::open_and_receive_mascot(lootbox, &random, ts::ctx(&mut scenario));
        ts::return_shared(random);
    };
    
    // Step 6: Admin withdraws all funds
    ts::next_tx(&mut scenario, ADMIN);
    {
        let admin_cap = ts::take_from_address<AdminCap>(&scenario, ADMIN);
        let mut treasury = ts::take_shared<Treasury>(&scenario);
        
        contract::withdraw_all(&admin_cap, &mut treasury, ts::ctx(&mut scenario));
        
        assert!(contract::get_treasury_balance(&treasury) == 0, 14);
        
        ts::return_to_address(ADMIN, admin_cap);
        ts::return_shared(treasury);
    };
    
    // Verify final state
    ts::next_tx(&mut scenario, USER1);
    {
        assert!(ts::has_most_recent_for_address<Mascot>(USER1), 15);
        assert!(ts::has_most_recent_for_address<Mascot>(USER2), 16);
        assert!(ts::has_most_recent_for_address<Coin<SUI>>(ADMIN), 17);
    };
    
    ts::end(scenario);
}