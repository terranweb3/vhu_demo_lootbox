import {
  RARITY_NAMES,
  RARITY_COLORS,
  RARITY_BG_COLORS,
  RARITY_BORDER_COLORS,
} from "../constants";

interface MascotCardProps {
  mascotId: string;
  name: string;
  rarity: number;
  mascotType: number;
  imageUrl: string;
  isNew?: boolean;
}

export default function MascotCard({
  name,
  rarity,
  mascotType,
  imageUrl,
  isNew = false,
}: MascotCardProps) {
  const rarityName = RARITY_NAMES[rarity];
  const rarityColor = RARITY_COLORS[rarity as keyof typeof RARITY_COLORS];
  const rarityBg = RARITY_BG_COLORS[rarity as keyof typeof RARITY_BG_COLORS];
  const rarityBorder =
    RARITY_BORDER_COLORS[rarity as keyof typeof RARITY_BORDER_COLORS];

  return (
    <div
      className={`relative bg-gradient-to-br from-gray-900 to-gray-800 rounded-xl overflow-hidden border-2 ${rarityBorder} card-hover ${
        isNew ? "reveal-animation" : ""
      }`}
    >
      {/* Rarity badge */}
      <div
        className={`absolute top-3 right-3 px-3 py-1 rounded-full ${rarityBg} ${rarityColor} font-bold text-sm z-10 backdrop-blur-sm`}
      >
        {rarityName}
      </div>

      {/* Image */}
      <div className="relative aspect-square overflow-hidden bg-gradient-to-br from-purple-900/30 to-blue-900/30">
        <img
          src={imageUrl}
          alt={name}
          className="w-full h-full object-cover hover:scale-110 transition-transform duration-300"
          onError={(e) => {
            // Fallback if image fails to load
            (e.target as HTMLImageElement).src =
              "https://via.placeholder.com/400x400/667eea/ffffff?text=Mascot";
          }}
        />
      </div>

      {/* Info */}
      <div className="p-4 space-y-2">
        <h3 className="text-lg font-bold text-white truncate">{name}</h3>
        <div className="flex items-center justify-between text-sm">
          <span className="text-gray-400">Type #{mascotType}</span>
          <span className={`font-semibold ${rarityColor}`}>★ {rarityName}</span>
        </div>
      </div>

      {/* New badge */}
      {isNew && (
        <div className="absolute top-3 left-3 bg-red-500 text-white px-3 py-1 rounded-full font-bold text-xs animate-pulse">
          NEW!
        </div>
      )}
    </div>
  );
}

