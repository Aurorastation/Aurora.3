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

#define PLANET_BARREN		"barren"
#define PLANET_ASTEROID		"asteroid"
#define PLANET_DESERT		"desert"
#define PLANET_GROVE		"grove"
#define PLANET_GRASS		"grass"
#define PLANET_LAVA			"lava"
#define PLANET_SNOW			"snow"

#define ALL_PLANET_TYPES	list(PLANET_BARREN, PLANET_ASTEROID, PLANET_DESERT, PLANET_GROVE, PLANET_GRASS, PLANET_LAVA, PLANET_SNOW)
#define PLANET_LORE			"lore"
