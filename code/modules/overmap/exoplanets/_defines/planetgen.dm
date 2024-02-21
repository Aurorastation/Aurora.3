#define BIOME_RANDOM_SQUARE_DRIFT 2

#define BIOME_POLAR "polar"
#define BIOME_COOL "cool"
#define BIOME_WARM "warm"
#define BIOME_EQUATOR "equatorial"

#define BIOME_ARID "arid"
#define BIOME_SEMIARID "semiarid"
#define BIOME_SUBHUMID "subhumid"
#define BIOME_HUMID "humid"

/// Discrete batched perlin-like noise; results in large clumps, argument is cutoff value (lower value makes spawns rarer), range (-0.5, 0.5)
#define BATCHED_NOISE BITFLAG(0)
/// Poisson disk sampling; results in a uniform distribution of single points, argument is minimum # turfs between points
#define POISSON_SAMPLE BITFLAG(1)
/// Pure random chance on a per-tile basis; equivalent to prob(X) per turf
#define PURE_RANDOM	BITFLAG(2)
/// Will always spawn terrain features of this type
#define ALWAYS_GEN BITFLAG(3)
/// ALWAYS_GEN but only in the lower 0.0-0.99x bound specified for normal heat/humidity in this biome
#define HEIGHT_MOD BITFLAG(4)

/// The only 'mandatory' generator define, insofar that you need to use it to override turf_type
#define PLANET_TURF "turfs"
// Some useful defines, but so long as generators and spawn_turfs have the same string value,
// these can be literally anything
#define GRASSES "grasses"
#define SMALL_FLORA "bushes"
#define LARGE_FLORA "trees"
#define WILDLIFE "mobs"

#define GRASS_1 "grass1"
#define GRASS_2 "grass2"
#define GRASS_3 "grass3"

#define SURFACE_ORES "surface"
#define RARE_ORES "rare"
#define DEEP_ORES "deep" // yo that's deep
