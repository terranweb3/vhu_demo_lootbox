import { useState } from "react";
import { useSignAndExecuteTransaction, useSuiClient } from "@mysten/dapp-kit";
import { Transaction } from "@mysten/sui/transactions";
import { PACKAGE_ID, RANDOM_ID } from "../constants";

interface LootboxCardProps {
  lootboxId: string;
  onOpened: () => void;
}

export default function LootboxCard({ lootboxId, onOpened }: LootboxCardProps) {
  const [isOpening, setIsOpening] = useState(false);
  const [isShaking, setIsShaking] = useState(false);
  const { mutate: signAndExecute } = useSignAndExecuteTransaction();
  const suiClient = useSuiClient();

  const handleOpen = async () => {
    setIsShaking(true);
    setTimeout(() => setIsShaking(false), 500);

    setIsOpening(true);

    const tx = new Transaction();
    tx.moveCall({
      target: `${PACKAGE_ID}::contract::open_and_receive_mascot`,
      arguments: [
        tx.object(lootboxId),
        tx.object(RANDOM_ID),
      ],
    });

    signAndExecute(
      {
        transaction: tx,
      },
      {
        onSuccess: async (result) => {
          console.log("Lootbox opened successfully!", result);
          await suiClient.waitForTransaction({
            digest: result.digest,
          });
          setTimeout(() => {
            setIsOpening(false);
            onOpened();
          }, 1000);
        },
        onError: (error) => {
          console.error("Error opening lootbox:", error);
          setIsOpening(false);
          alert("Failed to open lootbox. Please try again.");
        },
      }
    );
  };

  return (
    <div
      className={`relative bg-gradient-to-br from-purple-900/50 to-blue-900/50 rounded-xl p-6 border-2 border-purple-500/50 card-hover ${
        isShaking ? "shake-animation" : ""
      }`}
    >
      <div className="flex flex-col items-center space-y-4">
        <div className="text-6xl float-animation">📦</div>
        <h3 className="text-xl font-bold text-purple-300">Mystery Lootbox</h3>
        <p className="text-sm text-gray-400 text-center">
          Open to reveal a random mascot!
        </p>
        <button
          onClick={handleOpen}
          disabled={isOpening}
          className={`w-full py-3 px-6 rounded-lg font-bold text-white transition-all ${
            isOpening
              ? "bg-gray-600 cursor-not-allowed"
              : "bg-gradient-to-r from-purple-600 to-blue-600 hover:from-purple-700 hover:to-blue-700 pulse-glow"
          }`}
        >
          {isOpening ? (
            <span className="flex items-center justify-center">
              <svg
                className="animate-spin h-5 w-5 mr-2"
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
              Opening...
            </span>
          ) : (
            "🎁 Open Lootbox"
          )}
        </button>
      </div>
    </div>
  );
}

