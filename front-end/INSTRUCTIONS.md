# Mystery Lootbox - Frontend Instructions

## 🎁 Overview
This is a frontend application for the Mystery Lootbox NFT game on Sui blockchain. Users can buy lootboxes, open them to reveal random mascots with different rarity levels.

## 📋 Prerequisites
- Node.js (v18 or higher)
- pnpm (or npm/yarn)
- Sui Wallet browser extension
- Testnet SUI tokens

## 🚀 Getting Started

### 1. Install Dependencies
```bash
pnpm install
```

### 2. Start Development Server
```bash
pnpm dev
```

The app will be available at `http://localhost:5173`

### 3. Connect Wallet
- Click "Connect Wallet" button in the header
- Select your Sui wallet
- Make sure you're on Testnet network
- Ensure you have at least 0.1 SUI for buying lootboxes

## 🎮 How to Use

### Buy a Lootbox
1. Click the "🎁 Buy Lootbox (0.1 SUI)" button
2. Approve the transaction in your wallet
3. Wait for confirmation
4. Your new lootbox will appear in the "Your Lootboxes" section

### Open a Lootbox
1. Find your lootbox in the "Your Lootboxes" section
2. Click "🎁 Open Lootbox" button
3. Approve the transaction
4. Watch the animation as your lootbox opens
5. Your new mascot will appear in the "Your Mascots" section

### View Your Collection
- **Lootboxes**: Shows all unopened mystery boxes
- **Mascots**: Displays all mascots you've collected
- **Stats**: View your collection statistics including rare and epic mascots

## 🎨 Rarity System

Mascots come in 4 rarity levels:

| Rarity | Probability | Color |
|--------|------------|-------|
| Common | 60% | Gray |
| Uncommon | 25% | Green |
| Rare | 12% | Blue |
| Epic | 3% | Purple |

## 🔧 Configuration

The contract addresses are configured in `src/constants.ts`:

```typescript
export const PACKAGE_ID = "0xf99a3935114025f05af9d34139e76326cb3de96569167cca6eb18041d0ed7358";
export const TREASURY_ID = "0xbe008780cd6765e2ad1ccf0f6dae2db07ee80877b6c218f56ff09c8fd41581d3";
export const RANDOM_ID = "0x8"; // Sui's shared Random object
```

## 📦 Project Structure

```
front-end/
├── src/
│   ├── components/
│   │   ├── Header.tsx           # Navigation header with wallet connection
│   │   ├── BuyLootboxButton.tsx # Button to purchase lootboxes
│   │   ├── LootboxCard.tsx      # Display and open lootbox
│   │   └── MascotCard.tsx       # Display mascot NFT
│   ├── App.tsx                  # Main application logic
│   ├── constants.ts             # Contract addresses and configuration
│   ├── index.css                # Global styles and animations
│   └── main.tsx                 # Application entry point
├── package.json
└── vite.config.ts
```

## 🎯 Features

- ✅ Connect Sui wallet
- ✅ Buy lootboxes with SUI tokens
- ✅ Open lootboxes to reveal random mascots
- ✅ View collection of lootboxes and mascots
- ✅ Beautiful animations and effects
- ✅ Responsive design for mobile and desktop
- ✅ Real-time updates after transactions
- ✅ Rarity-based visual styling

## 🛠️ Build for Production

```bash
pnpm build
```

The built files will be in the `dist/` directory.

## 🐛 Troubleshooting

### Transaction Fails
- Ensure you have enough SUI for gas fees (at least 0.15 SUI)
- Check that you're on the correct network (Testnet)
- Make sure the contract addresses in `constants.ts` are correct

### Mascots Not Showing
- Click the "Refresh" button to reload your collection
- Check browser console for errors
- Verify the object IDs in the Sui Explorer

### Images Not Loading
- The mascot images are hosted on IPFS
- If images fail to load, a placeholder will be shown
- Check your internet connection

## 📝 Notes

- All transactions require wallet approval
- Opening lootboxes uses Sui's on-chain randomness
- Each lootbox costs exactly 0.1 SUI
- Mascots are NFTs that you fully own and can transfer

## 🔗 Useful Links

- [Sui Documentation](https://docs.sui.io/)
- [Sui Explorer (Testnet)](https://suiexplorer.com/?network=testnet)
- [Sui Wallet](https://chrome.google.com/webstore/detail/sui-wallet)

## 💡 Tips

- Buy multiple lootboxes at once to save on gas fees
- Rare and Epic mascots are valuable - keep them safe!
- Use the stats section to track your collection progress
- The refresh button updates your collection without reloading the page

