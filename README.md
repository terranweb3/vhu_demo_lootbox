# 🎁 Mystery Lootbox - Sui NFT Game

A fun lootbox NFT game built on the Sui blockchain where users can buy mystery boxes and open them to reveal random mascots with different rarity levels.

## 🌟 Features

- **Buy Lootboxes**: Purchase mystery lootboxes for 0.1 SUI
- **Random Mascots**: Open lootboxes to reveal mascots with 4 rarity levels
- **Rarity System**: Common (60%), Uncommon (25%), Rare (12%), Epic (3%)
- **NFT Ownership**: All mascots are NFTs that you fully own
- **Beautiful UI**: Modern, responsive interface with smooth animations
- **On-chain Randomness**: Uses Sui's built-in randomness for fair drops

## 📁 Project Structure

```
vhu_demo_lootbox/
├── contract/          # Move smart contract
│   ├── sources/
│   │   └── contract.move
│   └── Move.toml
└── front-end/         # React + TypeScript frontend
    ├── src/
    │   ├── components/
    │   ├── App.tsx
    │   └── constants.ts
    └── package.json
```

## 🚀 Quick Start

### Contract (Already Deployed)

**Network**: Sui Testnet

**Deployed Addresses**:
- Package ID: `0xf99a3935114025f05af9d34139e76326cb3de96569167cca6eb18041d0ed7358`
- Treasury: `0xbe008780cd6765e2ad1ccf0f6dae2db07ee80877b6c218f56ff09c8fd41581d3`

### Frontend Setup

1. Navigate to frontend directory:
```bash
cd front-end
```

2. Install dependencies:
```bash
pnpm install
```

3. Start development server:
```bash
pnpm dev
```

4. Open browser at `http://localhost:5173`

## 🎮 How to Play

1. **Connect Wallet**: Click "Connect Wallet" and select your Sui wallet
2. **Get Testnet SUI**: Make sure you have at least 0.15 SUI on testnet
3. **Buy Lootbox**: Click "Buy Lootbox (0.1 SUI)" button
4. **Open Lootbox**: Click "Open Lootbox" on your purchased box
5. **Collect Mascots**: View your collection and try to get rare mascots!

## 🎨 Rarity System

| Rarity | Probability | Color |
|--------|------------|-------|
| Common | 60% | Gray |
| Uncommon | 25% | Green |
| Rare | 12% | Blue |
| Epic | 3% | Purple |

## 🛠️ Tech Stack

**Smart Contract**:
- Move language
- Sui blockchain

**Frontend**:
- React 19
- TypeScript
- Vite
- Tailwind CSS 4
- @mysten/dapp-kit
- @mysten/sui

## 📝 Contract Functions

### Public Functions
- `buy_lootbox()`: Purchase a lootbox for 0.1 SUI
- `open_and_receive_mascot()`: Open a lootbox to get a random mascot
- `get_mascot_info()`: View mascot details
- `get_treasury_balance()`: Check treasury balance

### Admin Functions
- `withdraw()`: Withdraw specific amount from treasury
- `withdraw_all()`: Withdraw all funds from treasury

## 🔗 Useful Links

- [Sui Documentation](https://docs.sui.io/)
- [Sui Explorer](https://suiexplorer.com/?network=testnet)
- [Sui Wallet](https://chrome.google.com/webstore/detail/sui-wallet)

## 📄 License

MIT

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

---

Built with ❤️ on Sui blockchain