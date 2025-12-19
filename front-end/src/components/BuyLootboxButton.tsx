import { useState } from "react";
import { useSignAndExecuteTransaction, useSuiClient } from "@mysten/dapp-kit";
import { Transaction } from "@mysten/sui/transactions";
import { PACKAGE_ID, TREASURY_ID, LOOTBOX_PRICE } from "../constants";

interface BuyLootboxButtonProps {
  onSuccess: () => void;
}

export default function BuyLootboxButton({ onSuccess }: BuyLootboxButtonProps) {
  const [isBuying, setIsBuying] = useState(false);
  const { mutate: signAndExecute } = useSignAndExecuteTransaction();
  const suiClient = useSuiClient();

  const handleBuy = async () => {
    setIsBuying(true);

    const tx = new Transaction();
    
    // Split coin for payment
    const [coin] = tx.splitCoins(tx.gas, [LOOTBOX_PRICE]);
    
    tx.moveCall({
      target: `${PACKAGE_ID}::contract::buy_lootbox`,
      arguments: [
        tx.object(TREASURY_ID),
        coin,
      ],
    });

    signAndExecute(
      {
        transaction: tx,
      },
      {
        onSuccess: async (result) => {
          console.log("Lootbox purchased successfully!", result);
          await suiClient.waitForTransaction({
            digest: result.digest,
          });
          setTimeout(() => {
            setIsBuying(false);
            onSuccess();
          }, 1000);
        },
        onError: (error) => {
          console.error("Error buying lootbox:", error);
          setIsBuying(false);
          alert("Failed to buy lootbox. Please check your balance and try again.");
        },
      }
    );
  };

  return (
    <button
      onClick={handleBuy}
      disabled={isBuying}
      className={`w-full max-w-md py-4 px-8 rounded-xl font-bold text-lg text-white transition-all ${
        isBuying
          ? "bg-gray-600 cursor-not-allowed"
          : "bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 pulse-glow"
      }`}
    >
      {isBuying ? (
        <span className="flex items-center justify-center">
          <svg
            className="animate-spin h-6 w-6 mr-3"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
          >
            <circle
              className="opacity-25"
              cx="12"
              cy="12"
              r="10"
              stroke="currentColor"
              strokeWidth="4"
            ></circle>
            <path
              className="opacity-75"
              fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
            ></path>
          </svg>
          Purchasing...
        </span>
      ) : (
        "🎁 Buy Lootbox (0.1 SUI)"
      )}
    </button>
  );
}

