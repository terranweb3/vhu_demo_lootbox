/// Module: contract
module contract::contract;

use sui::coin::{Self, Coin};
use sui::balance::{Self, Balance};
use sui::sui::SUI;
use sui::event;
use sui::random::{Self, Random};
use std::string::{Self, String};

// ==================== Constants ====================

/// Giá mint lootbox: 0.1 SUI = 100_000_000 MIST
const LOOTBOX_PRICE: u64 = 100_000_000;

/// Xác suất rarity (tổng = 10000 = 100%)
const COMMON_THRESHOLD: u16 = 6000;      // 60% (0-5999)
const UNCOMMON_THRESHOLD: u16 = 8500;    // 25% (6000-8499)
const RARE_THRESHOLD: u16 = 9700;        // 12% (8500-9699)
// EPIC: 3% (9700-9999)

// ==================== Error Codes ====================

const EInsufficientPayment: u64 = 1;
const EInvalidAmount: u64 = 2;

// ==================== Structs ====================

/// Rarity levels
public enum Rarity has store, copy, drop {
    Common,
    Uncommon,
    Rare,
    Epic,
}

/// Lootbox NFT - chưa mở
public struct Lootbox has key, store {
    id: UID,
    name: String,
}

/// Mascot NFT - kết quả sau khi mở lootbox
public struct Mascot has key, store {
    id: UID,
    name: String,
    rarity: Rarity,
    mascot_type: u8, // 1-4 tương ứng với 4 loại linh vật
    image_url: String,
}

/// Treasury để lưu trữ SUI từ việc bán lootbox
public struct Treasury has key {
    id: UID,
    balance: Balance<SUI>,
}

/// Admin capability
public struct AdminCap has key {
    id: UID,
}

// ==================== Events ====================

public struct LootboxMinted has copy, drop {
    lootbox_id: ID,
    buyer: address,
    price: u64,
}

public struct LootboxOpened has copy, drop {
    lootbox_id: ID,
    mascot_id: ID,
    owner: address,
    rarity: u8, // 0=Common, 1=Uncommon, 2=Rare, 3=Epic
    mascot_type: u8,
}

// ==================== Init Function ====================

fun init(ctx: &mut TxContext) {
    // Tạo Treasury
    transfer::share_object(Treasury {
        id: object::new(ctx),
        balance: balance::zero(),
    });

    // Tạo AdminCap và gửi cho deployer
    transfer::transfer(
        AdminCap { id: object::new(ctx) },
        ctx.sender()
    );
}

// ==================== Public Functions ====================

/// Mint lootbox bằng cách trả 0.1 SUI
public fun mint_lootbox(
    treasury: &mut Treasury,
    payment: Coin<SUI>,
    ctx: &mut TxContext
): Lootbox {
    // Kiểm tra số tiền thanh toán
    let paid = coin::value(&payment);
    assert!(paid >= LOOTBOX_PRICE, EInsufficientPayment);

    // Thêm payment vào treasury
    let paid_balance = coin::into_balance(payment);
    balance::join(&mut treasury.balance, paid_balance);

    // Tạo lootbox
    let lootbox_id = object::new(ctx);
    let lootbox_id_copy = object::uid_to_inner(&lootbox_id);

    let lootbox = Lootbox {
        id: lootbox_id,
        name: string::utf8(b"Mystery Lootbox"),
    };

    // Emit event
    event::emit(LootboxMinted {
        lootbox_id: lootbox_id_copy,
        buyer: ctx.sender(),
        price: LOOTBOX_PRICE,
    });

    lootbox
}

/// Mở lootbox để nhận mascot ngẫu nhiên
#[allow(lint(public_random))]
public fun open_lootbox(
    lootbox: Lootbox,
    r: &Random,
    ctx: &mut TxContext
): Mascot {
    let Lootbox { id: lootbox_id, name: _ } = lootbox;
    let lootbox_id_inner = object::uid_to_inner(&lootbox_id);
    object::delete(lootbox_id);

    // Tạo random generator
    let mut generator = random::new_generator(r, ctx);
    
    // Random rarity (0-9999)
    let rarity_roll = random::generate_u16_in_range(&mut generator, 0, 9999);
    
    // Random mascot type (1-4)
    let mascot_type = random::generate_u8_in_range(&mut generator, 1, 4);

    // Xác định rarity
    let (rarity, rarity_u8, rarity_name) = if (rarity_roll < COMMON_THRESHOLD) {
        (Rarity::Common, 0, b"Common")
    } else if (rarity_roll < UNCOMMON_THRESHOLD) {
        (Rarity::Uncommon, 1, b"Uncommon")
    } else if (rarity_roll < RARE_THRESHOLD) {
        (Rarity::Rare, 2, b"Rare")
    } else {
        (Rarity::Epic, 3, b"Epic")
    };

    // Tạo tên mascot
    let mut name_bytes = b"Mascot #";
    vector::append(&mut name_bytes, u8_to_ascii(mascot_type));
    vector::append(&mut name_bytes, b" - ");
    vector::append(&mut name_bytes, rarity_name);

    // Tạo image URL từ IPFS theo rarity
    let image_url_bytes = if (rarity_u8 == 3) {
        // Epic
        b"https://ipfs.io/ipfs/bafybeibj2mfe3xbagh74y72tnnnf7ca3ndi76filgdzzzst26n2qnmmdim/1.png"
    } else if (rarity_u8 == 2) {
        // Rare
        b"https://ipfs.io/ipfs/bafybeibj2mfe3xbagh74y72tnnnf7ca3ndi76filgdzzzst26n2qnmmdim/2.png"
    } else if (rarity_u8 == 0) {
        // Common
        b"https://ipfs.io/ipfs/bafybeibj2mfe3xbagh74y72tnnnf7ca3ndi76filgdzzzst26n2qnmmdim/3.png"
    } else {
        // Uncommon
        b"https://ipfs.io/ipfs/bafybeibj2mfe3xbagh74y72tnnnf7ca3ndi76filgdzzzst26n2qnmmdim/4.png"
    };

    let mascot_id = object::new(ctx);
    let mascot_id_copy = object::uid_to_inner(&mascot_id);

    let mascot = Mascot {
        id: mascot_id,
        name: string::utf8(name_bytes),
        rarity,
        mascot_type,
        image_url: string::utf8(image_url_bytes),
    };

    // Emit event
    event::emit(LootboxOpened {
        lootbox_id: lootbox_id_inner,
        mascot_id: mascot_id_copy,
        owner: ctx.sender(),
        rarity: rarity_u8,
        mascot_type,
    });

    mascot
}

/// Mint và transfer lootbox cho người mua
entry fun buy_lootbox(
    treasury: &mut Treasury,
    payment: Coin<SUI>,
    ctx: &mut TxContext
) {
    let lootbox = mint_lootbox(treasury, payment, ctx);
    transfer::public_transfer(lootbox, ctx.sender());
}

/// Mở lootbox và transfer mascot cho người mở
#[allow(lint(public_random))]
entry fun open_and_receive_mascot(
    lootbox: Lootbox,
    r: &Random,
    ctx: &mut TxContext
) {
    let mascot = open_lootbox(lootbox, r, ctx);
    transfer::public_transfer(mascot, ctx.sender());
}

// ==================== Admin Functions ====================

/// Admin rút tiền từ treasury
public fun withdraw(
    _: &AdminCap,
    treasury: &mut Treasury,
    amount: u64,
    ctx: &mut TxContext
): Coin<SUI> {
    assert!(amount > 0, EInvalidAmount);
    let withdrawn = balance::split(&mut treasury.balance, amount);
    coin::from_balance(withdrawn, ctx)
}

/// Admin rút toàn bộ tiền từ treasury
entry fun withdraw_all(
    admin: &AdminCap,
    treasury: &mut Treasury,
    ctx: &mut TxContext
) {
    let total = balance::value(&treasury.balance);
    if (total > 0) {
        let coin = withdraw(admin, treasury, total, ctx);
        transfer::public_transfer(coin, ctx.sender());
    }
}

// ==================== View Functions ====================

/// Lấy thông tin mascot
public fun get_mascot_info(mascot: &Mascot): (String, u8, u8, String) {
    (mascot.name, rarity_to_u8(&mascot.rarity), mascot.mascot_type, mascot.image_url)
}

/// Lấy balance của treasury
public fun get_treasury_balance(treasury: &Treasury): u64 {
    balance::value(&treasury.balance)
}

/// Convert rarity enum sang u8
fun rarity_to_u8(rarity: &Rarity): u8 {
    match (rarity) {
        Rarity::Common => 0,
        Rarity::Uncommon => 1,
        Rarity::Rare => 2,
        Rarity::Epic => 3,
    }
}

// ==================== Helper Functions ====================

/// Convert u8 to ASCII bytes
fun u8_to_ascii(num: u8): vector<u8> {
    if (num == 0) return b"0";
    
    let mut result = vector::empty<u8>();
    let mut n = num;
    
    while (n > 0) {
        let digit = (n % 10) as u8;
        vector::push_back(&mut result, 48 + digit); // 48 is ASCII '0'
        n = n / 10;
    };
    
    vector::reverse(&mut result);
    result
}

// ==================== Tests ====================

#[test_only]
public fun init_for_testing(ctx: &mut TxContext) {
    init(ctx);
}
