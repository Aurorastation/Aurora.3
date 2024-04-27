// Use the flags below to filter out ruins for planets and to categorize your ruin so it spawns appropriately
// If you're designing a lore planet, ignore this and use the whitelist system

//Flags for exoplanet ruin picking

#define RUIN_AIRLESS		BITFLAG(0)	// Ruins that have no atmos and are expected to be placed in (near) vacuum
#define RUIN_LOWPOP			BITFLAG(1)	// Ruin that may spawn in a sector with low permanent population or traffic
#define RUIN_HIGHPOP		BITFLAG(2)	// Ruin that may spawn in a sector with high permanent population or traffic
#define RUIN_MINING			BITFLAG(3)	// Ruin that spawns ores or otherwise is involved with mining
#define RUIN_SCIENCE		BITFLAG(4)	// Ruin that spawns artifacts or is otherwise scientific
#define RUIN_HOSTILE		BITFLAG(5)	// Ruin that spawns enemies (carp, turrets, etc.)
#define RUIN_WRECK			BITFLAG(6)	// Crash site (shuttle, ship, etc.)
#define RUIN_NATURAL		BITFLAG(7)	// Naturally occurring feature

#define RUIN_ALL_TAGS		RUIN_AIRLESS|RUIN_LOWPOP|RUIN_HIGHPOP|RUIN_MINING|RUIN_SCIENCE|RUIN_HOSTILE|RUIN_WRECK|RUIN_NATURAL

//planet flags

#define PLANET_BARREN		BITFLAG(0)
#define PLANET_ASTEROID		BITFLAG(1)
#define PLANET_DESERT		BITFLAG(2)
#define PLANET_GROVE		BITFLAG(3)
#define PLANET_GRASS		BITFLAG(4)
#define PLANET_LAVA			BITFLAG(5)
#define PLANET_SNOW			BITFLAG(6)
#define PLANET_MARSH		BITFLAG(7)
#define PLANET_CRYSTAL		BITFLAG(8)

#define ALL_PLANET_TYPES	PLANET_BARREN|PLANET_ASTEROID|PLANET_DESERT|PLANET_GROVE|PLANET_GRASS|PLANET_LAVA|PLANET_SNOW|PLANET_MARSH|PLANET_CRYSTAL
#define PLANET_LORE			BITFLAG(16)
