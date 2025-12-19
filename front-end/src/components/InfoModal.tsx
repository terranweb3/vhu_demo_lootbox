import { useState } from "react";

export default function InfoModal() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <>
      {/* Info Button */}
      <button
        onClick={() => setIsOpen(true)}
        className="fixed bottom-6 right-6 w-14 h-14 bg-gradient-to-r from-purple-600 to-blue-600 rounded-full shadow-lg hover:shadow-xl transition-all pulse-glow flex items-center justify-center text-2xl z-40"
        aria-label="Information"
      >
        ℹ️
      </button>

      {/* Modal */}
      {isOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm">
          <div className="bg-gradient-to-br from-gray-900 to-gray-800 rounded-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto border-2 border-purple-500/50 shadow-2xl">
            {/* Header */}
            <div className="sticky top-0 bg-gradient-to-r from-purple-900/90 to-blue-900/90 backdrop-blur-sm p-6 border-b border-purple-500/30">
              <div className="flex items-center justify-between">
                <h2 className="text-2xl font-bold text-white">
                  🎁 How to Play
                </h2>
                <button
                  onClick={() => setIsOpen(false)}
                  className="text-gray-400 hover:text-white transition-colors text-2xl"
                >
                  ✕
                </button>
              </div>
            </div>

            {/* Content */}
            <div className="p-6 space-y-6">
              {/* How to Play */}
              <section className="space-y-3">
                <h3 className="text-xl font-bold text-purple-300 flex items-center space-x-2">
                  <span>🎮</span>
                  <span>How to Play</span>
                </h3>
                <ol className="space-y-2 text-gray-300 list-decimal list-inside">
                  <li>Connect your Sui wallet (make sure you're on Testnet)</li>
                  <li>Buy a lootbox for 0.1 SUI</li>
                  <li>Open the lootbox to reveal a random mascot</li>
                  <li>Collect mascots of different rarities!</li>
                </ol>
              </section>

              {/* Rarity System */}
              <section className="space-y-3">
                <h3 className="text-xl font-bold text-blue-300 flex items-center space-x-2">
                  <span>✨</span>
                  <span>Rarity System</span>
                </h3>
                <div className="space-y-2">
                  <div className="flex items-center justify-between p-3 bg-gray-500/20 rounded-lg border border-gray-500/30">
                    <div className="flex items-center space-x-3">
                      <div className="w-3 h-3 bg-gray-400 rounded-full"></div>
                      <span className="font-semibold text-gray-300">Common</span>
                    </div>
                    <span className="text-gray-400">60% chance</span>
                  </div>
                  <div className="flex items-center justify-between p-3 bg-green-500/20 rounded-lg border border-green-500/30">
                    <div className="flex items-center space-x-3">
                      <div className="w-3 h-3 bg-green-400 rounded-full"></div>
                      <span className="font-semibold text-green-300">Uncommon</span>
                    </div>
                    <span className="text-green-400">25% chance</span>
                  </div>
                  <div className="flex items-center justify-between p-3 bg-blue-500/20 rounded-lg border border-blue-500/30">
                    <div className="flex items-center space-x-3">
                      <div className="w-3 h-3 bg-blue-400 rounded-full"></div>
                      <span className="font-semibold text-blue-300">Rare</span>
                    </div>
                    <span className="text-blue-400">12% chance</span>
                  </div>
                  <div className="flex items-center justify-between p-3 bg-purple-500/20 rounded-lg border border-purple-500/30">
                    <div className="flex items-center space-x-3">
                      <div className="w-3 h-3 bg-purple-400 rounded-full animate-pulse"></div>
                      <span className="font-semibold text-purple-300">Epic</span>
                    </div>
                    <span className="text-purple-400">3% chance</span>
                  </div>
                </div>
              </section>

              {/* Tips */}
              <section className="space-y-3">
                <h3 className="text-xl font-bold text-pink-300 flex items-center space-x-2">
                  <span>💡</span>
                  <span>Tips</span>
                </h3>
                <ul className="space-y-2 text-gray-300">
                  <li className="flex items-start space-x-2">
                    <span className="text-purple-400 mt-1">•</span>
                    <span>Each lootbox costs exactly 0.1 SUI</span>
                  </li>
                  <li className="flex items-start space-x-2">
                    <span className="text-purple-400 mt-1">•</span>
                    <span>Make sure you have extra SUI for gas fees</span>
                  </li>
                  <li className="flex items-start space-x-2">
                    <span className="text-purple-400 mt-1">•</span>
                    <span>Mascots are NFTs that you fully own</span>
                  </li>
                  <li className="flex items-start space-x-2">
                    <span className="text-purple-400 mt-1">•</span>
                    <span>Click refresh to update your collection</span>
                  </li>
                  <li className="flex items-start space-x-2">
                    <span className="text-purple-400 mt-1">•</span>
                    <span>Epic mascots are very rare - collect them all!</span>
                  </li>
                </ul>
              </section>

              {/* Contract Info */}
              <section className="space-y-3">
                <h3 className="text-xl font-bold text-cyan-300 flex items-center space-x-2">
                  <span>🔗</span>
                  <span>Contract Info</span>
                </h3>
                <div className="bg-gray-800/50 rounded-lg p-4 space-y-2 text-sm">
                  <div>
                    <span className="text-gray-400">Network:</span>
                    <span className="text-white ml-2 font-mono">Testnet</span>
                  </div>
                  <div>
                    <span className="text-gray-400">Package ID:</span>
                    <div className="text-white font-mono text-xs break-all mt-1">
                      0xf99a3935114025f05af9d34139e76326cb3de96569167cca6eb18041d0ed7358
                    </div>
                  </div>
                </div>
              </section>
            </div>

            {/* Footer */}
            <div className="sticky bottom-0 bg-gradient-to-r from-purple-900/90 to-blue-900/90 backdrop-blur-sm p-6 border-t border-purple-500/30">
              <button
                onClick={() => setIsOpen(false)}
                className="w-full py-3 bg-gradient-to-r from-purple-600 to-blue-600 hover:from-purple-700 hover:to-blue-700 rounded-lg font-bold text-white transition-all"
              >
                Got it!
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}

