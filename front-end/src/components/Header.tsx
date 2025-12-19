import { ConnectButton, useCurrentAccount } from "@mysten/dapp-kit";
import "@mysten/dapp-kit/dist/index.css";

function Header() {
  const account = useCurrentAccount();

  return (
    <header className="sticky top-0 z-50 backdrop-blur-lg bg-gray-900/80 border-b border-purple-500/30">
      <div className="max-w-7xl mx-auto px-4 py-4">
        <div className="flex items-center justify-between">
          {/* Logo */}
          <div className="flex items-center space-x-3">
            <div className="text-3xl">🎁</div>
            <div>
              <h1 className="text-xl font-bold gradient-text">
                Mystery Lootbox
              </h1>
              <p className="text-xs text-gray-400">Collect Rare Mascots</p>
            </div>
          </div>

          {/* Wallet Connection */}
          <div className="flex items-center space-x-4">
            {account && (
              <div className="hidden md:flex items-center space-x-2 bg-purple-900/30 px-4 py-2 rounded-lg border border-purple-500/30">
                <div className="w-2 h-2 bg-green-400 rounded-full animate-pulse"></div>
                <span className="text-sm text-gray-300">Connected</span>
              </div>
            )}
            <ConnectButton />
          </div>
        </div>
      </div>
    </header>
  );
}

export default Header;
