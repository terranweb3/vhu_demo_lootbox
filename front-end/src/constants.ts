// Contract addresses and configuration
export const PACKAGE_ID = "0xf99a3935114025f05af9d34139e76326cb3de96569167cca6eb18041d0ed7358";
export const TREASURY_ID = "0xbe008780cd6765e2ad1ccf0f6dae2db07ee80877b6c218f56ff09c8fd41581d3";
export const RANDOM_ID = "0x8"; // Sui's shared Random object

// Contract constants
export const LOOTBOX_PRICE = 100_000_000; // 0.1 SUI in MIST
export const LOOTBOX_PRICE_SUI = 0.1;

// Rarity configuration
export const RARITY_NAMES = ["Common", "Uncommon", "Rare", "Epic"];
export const RARITY_COLORS = {
  0: "text-gray-400", // Common
  1: "text-green-400", // Uncommon
  2: "text-blue-400", // Rare
  3: "text-purple-400", // Epic
};

export const RARITY_BG_COLORS = {
  0: "bg-gray-500/20", // Common
  1: "bg-green-500/20", // Uncommon
  2: "bg-blue-500/20", // Rare
  3: "bg-purple-500/20", // Epic
};

export const RARITY_BORDER_COLORS = {
  0: "border-gray-500", // Common
  1: "border-green-500", // Uncommon
  2: "border-blue-500", // Rare
  3: "border-purple-500", // Epic
};

