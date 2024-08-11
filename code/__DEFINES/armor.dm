// Armor will turn attacks into less dangerous (e.g. turning cut into bruise), so keep that in mind when decided what armor value to use.
// Some levels are marked with what they intend to block in such way.
#define  ARMOR_TYPE_STANDARD		1
#define  ARMOR_TYPE_EXOSUIT			2
#define  ARMOR_TYPE_RIG				4

#define  ARMOR_BALLISTIC_MINOR		10
#define  ARMOR_BALLISTIC_SMALL		25
#define  ARMOR_BALLISTIC_PISTOL		30
#define  ARMOR_BALLISTIC_MEDIUM		40
#define  ARMOR_BALLISTIC_CARBINE    45 //Reduces polymer round damage to 15.3.
#define  ARMOR_BALLISTIC_MAJOR      55 //Reduces 762 round damage to 18.
#define  ARMOR_BALLISTIC_RIFLE		60 //Used by security ballistic armour. Drops 762 down to 11.2 damage.
#define  ARMOR_BALLISTIC_AP			75
#define  ARMOR_BALLISTIC_HEAVY		100

#define  ARMOR_LASER_MINOR			10
#define  ARMOR_LASER_SMALL			25
#define  ARMOR_LASER_KEVLAR			30
#define  ARMOR_LASER_PISTOL			35
#define  ARMOR_LASER_MEDIUM			40 // Drops midlasers down to 22.5 damage.
#define  ARMOR_LASER_RIFLE			45 // Drops midlasers down to 18 damage.
#define  ARMOR_LASER_MAJOR			55 // Drops midlasers down to 9 damage.
#define  ARMOR_LASER_AP				70
#define  ARMOR_LASER_HEAVY			100

#define  ARMOR_MELEE_MINOR			5
#define  ARMOR_MELEE_SMALL			10
#define  ARMOR_MELEE_KNIVES			15
#define	 ARMOR_MELEE_MEDIUM			20
#define  ARMOR_MELEE_KEVLAR			25
#define  ARMOR_MELEE_RESISTANT		30
#define  ARMOR_MELEE_MAJOR			50
#define  ARMOR_MELEE_VERY_HIGH		70
#define  ARMOR_MELEE_SHIELDED		100

#define  ARMOR_BIO_MINOR			10
#define  ARMOR_BIO_SMALL			25
#define  ARMOR_BIO_RESISTANT		50
#define  ARMOR_BIO_STRONG			75
#define  ARMOR_BIO_SHIELDED			100

#define  ARMOR_RAD_MINOR			10
#define  ARMOR_RAD_SMALL			25
#define  ARMOR_RAD_RESISTANT		40
#define  ARMOR_RAD_SHIELDED			100

#define  ARMOR_BOMB_MINOR			10
#define  ARMOR_BOMB_PADDED			30
#define  ARMOR_BOMB_RESISTANT		60
#define  ARMOR_BOMB_SHIELDED		100

#define  ARMOR_ENERGY_MINOR			10
#define  ARMOR_ENERGY_SMALL			25
#define  ARMOR_ENERGY_RESISTANT		40
#define  ARMOR_ENERGY_STRONG		75
#define  ARMOR_ENERGY_SHIELDED		100
