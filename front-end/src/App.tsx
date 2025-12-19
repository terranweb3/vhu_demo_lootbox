import { useState, useEffect } from "react";
import {
  useCurrentAccount,
  useSuiClientQuery,
  ConnectButton,
} from "@mysten/dapp-kit";
import LootboxCard from "./components/LootboxCard";
import MascotCard from "./components/MascotCard";
import BuyLootboxButton from "./components/BuyLootboxButton";
import InfoModal from "./components/InfoModal";
import { PACKAGE_ID } from "./constants";

interface LootboxObject {
  objectId: string;
  name: string;
}

interface MascotObject {
  objectId: string;
  name: string;
  rarity: number;
  mascotType: number;
  imageUrl: string;
}

function App() {
  const account = useCurrentAccount();
  const [lootboxes, setLootboxes] = useState<LootboxObject[]>([]);
  const [mascots, setMascots] = useState<MascotObject[]>([]);
  const [refreshKey, setRefreshKey] = useState(0);

  // Query owned objects
  const { data: ownedObjects, refetch } = useSuiClientQuery(
    "getOwnedObjects",
    {
      owner: account?.address || "",
      filter: {
        MatchAny: [
          {
            StructType: `${PACKAGE_ID}::contract::Lootbox`,
          },
          {
            StructType: `${PACKAGE_ID}::contract::Mascot`,
          },
        ],
      },
      options: {
        showContent: true,
        showType: true,
      },
    },
    {
      enabled: !!account,
    }
  );

  useEffect(() => {
    if (ownedObjects?.data) {
      const lootboxList: LootboxObject[] = [];
      const mascotList: MascotObject[] = [];

      ownedObjects.data.forEach((obj) => {
        const content = obj.data?.content;
        if (content && content.dataType === "moveObject") {
          const fields = content.fields as any;

          if (obj.data?.type?.includes("::Lootbox")) {
            lootboxList.push({
              objectId: obj.data.objectId,
              name: fields.name || "Mystery Lootbox",
            });
          } else if (obj.data?.type?.includes("::Mascot")) {
            mascotList.push({
              objectId: obj.data.objectId,
              name: fields.name || "Mascot",
              rarity:
                fields.rarity?.fields?.name === "Epic"
                  ? 3
                  : fields.rarity?.fields?.name === "Rare"
                  ? 2
                  : fields.rarity?.fields?.name === "Uncommon"
                  ? 1
                  : 0,
              mascotType: fields.mascot_type || 1,
              imageUrl: fields.image_url || "",
            });
          }
        }
      });

      setLootboxes(lootboxList);
      setMascots(mascotList);
    }
  }, [ownedObjects, refreshKey]);

  const handleRefresh = () => {
    setRefreshKey((prev) => prev + 1);
    refetch();
  };

  if (!account) {
    return (
      <div className="min-h-screen flex items-center justify-center p-4">
        <div className="text-center space-y-6">
          <div className="text-8xl float-animation">🎁</div>
          <h1 className="text-5xl font-bold gradient-text">Mystery Lootbox</h1>
          <p className="text-xl text-gray-300">
            Connect your wallet to start collecting mascots!
          </p>
          <div className="flex justify-center pt-4">
            <ConnectButton />
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen p-4 md:p-8">
      <div className="max-w-7xl mx-auto space-y-8">
        {/* Hero Section */}
        <div className="text-center space-y-4 py-8">
          <h1 className="text-5xl md:text-6xl font-bold gradient-text">
            🎁 Mystery Lootbox
          </h1>
          <p className="text-xl text-gray-300">
            Buy lootboxes and discover rare mascots!
          </p>
        </div>

        {/* Buy Section */}
        <div className="flex flex-col items-center space-y-4 py-8">
          <BuyLootboxButton onSuccess={handleRefresh} />
          <button
            onClick={handleRefresh}
            className="text-purple-400 hover:text-purple-300 transition-colors flex items-center space-x-2"
          >
            <svg
              className="w-5 h-5"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
              />
            </svg>
            <span>Refresh</span>
          </button>
        </div>

        {/* Lootboxes Section */}
        {lootboxes.length > 0 && (
          <div className="space-y-4">
            <h2 className="text-3xl font-bold text-purple-300">
              📦 Your Lootboxes ({lootboxes.length})
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {lootboxes.map((lootbox) => (
                <LootboxCard
                  key={lootbox.objectId}
                  lootboxId={lootbox.objectId}
                  onOpened={handleRefresh}
                />
              ))}
            </div>
          </div>
        )}

        {/* Mascots Section */}
        <div className="space-y-4">
          <h2 className="text-3xl font-bold text-blue-300">
            ✨ Your Mascots ({mascots.length})
          </h2>
          {mascots.length === 0 ? (
            <div className="text-center py-16 space-y-4">
              <div className="text-6xl opacity-50">🎭</div>
              <p className="text-xl text-gray-400">
                No mascots yet. Buy and open lootboxes to start your collection!
              </p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {mascots.map((mascot) => (
                <MascotCard
                  key={mascot.objectId}
                  mascotId={mascot.objectId}
                  name={mascot.name}
                  rarity={mascot.rarity}
                  mascotType={mascot.mascotType}
                  imageUrl={mascot.imageUrl}
                />
              ))}
            </div>
          )}
        </div>

        {/* Stats Section */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 py-8">
          <div className="bg-gradient-to-br from-purple-900/30 to-blue-900/30 rounded-xl p-6 text-center border border-purple-500/30">
            <div className="text-3xl font-bold text-purple-400">
              {lootboxes.length}
            </div>
            <div className="text-gray-400 mt-2">Lootboxes</div>
          </div>
          <div className="bg-gradient-to-br from-blue-900/30 to-cyan-900/30 rounded-xl p-6 text-center border border-blue-500/30">
            <div className="text-3xl font-bold text-blue-400">
              {mascots.length}
            </div>
            <div className="text-gray-400 mt-2">Mascots</div>
          </div>
          <div className="bg-gradient-to-br from-green-900/30 to-emerald-900/30 rounded-xl p-6 text-center border border-green-500/30">
            <div className="text-3xl font-bold text-green-400">
              {mascots.filter((m) => m.rarity >= 2).length}
            </div>
            <div className="text-gray-400 mt-2">Rare+</div>
          </div>
          <div className="bg-gradient-to-br from-pink-900/30 to-purple-900/30 rounded-xl p-6 text-center border border-pink-500/30">
            <div className="text-3xl font-bold text-pink-400">
              {mascots.filter((m) => m.rarity === 3).length}
            </div>
            <div className="text-gray-400 mt-2">Epic</div>
          </div>
        </div>
      </div>

      {/* Info Modal */}
      <InfoModal />
    </div>
  );
}

export default App;
