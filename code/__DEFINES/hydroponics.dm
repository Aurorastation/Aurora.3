/// The colour of dead plant sprites.
#define DEAD_PLANT_COLOUR "#C2A180"

// Seed noun datums
#define SEED_NOUN_SPORES          "spores"
#define SEED_NOUN_PITS            "pits"
#define SEED_NOUN_NODES           "nodes"
#define SEED_NOUN_CUTTINGS        "cuttings"
#define SEED_NOUN_SEEDS           "seeds"
#define SEED_NOUN_EGGS            "eggs"

#define GROWTH_WORMS			  "worms"
#define GROWTH_VINES			  "vines"
#define GROWTH_BIOMASS			  "biomass"
#define GROWTH_MOLD				  "mold"

// The various standardised ideal heat values.
#define IDEAL_HEAT_MOGHES 333
#define IDEAL_HEAT_TROPICAL 303
#define IDEAL_HEAT_TEMPERATE 293
#define IDEAL_HEAT_COLD 283
#define IDEAL_HEAT_ADHOMAI 257

// The various standardised ideal light values. They vary by incrmeents of 2.
#define IDEAL_LIGHT_HIGH 7
#define IDEAL_LIGHT_TEMPERATE 5
#define IDEAL_LIGHT_DIM 3

// Definitions for genes (trait groupings)
#define GENE_BIOCHEMISTRY "biochemistry"
#define GENE_HARDINESS "hardiness"
#define GENE_ENVIRONMENT "environment"
#define GENE_METABOLISM "metabolism"
#define GENE_STRUCTURE "appearance"
#define GENE_DIET "diet"
#define GENE_PIGMENT "pigment"
#define GENE_OUTPUT "output"
#define GENE_ATMOSPHERE "atmosphere"
#define GENE_VIGOUR "vigour"
#define GENE_FRUIT "fruit"
#define GENE_SPECIAL "special"

#define ALL_GENES list(GENE_BIOCHEMISTRY,GENE_HARDINESS,GENE_ENVIRONMENT,GENE_METABOLISM,GENE_STRUCTURE,GENE_DIET,GENE_PIGMENT,GENE_OUTPUT,GENE_ATMOSPHERE,GENE_VIGOUR,GENE_FRUIT,GENE_SPECIAL)

/* --- ### GENERAL TRAITS ### --- */

/// Which chemicals are inside the plant?
#define TRAIT_CHEMS                1
/// Will the plant emit gasses into its environment?
#define TRAIT_EXUDE_GASSES         2
/// If set, the plant will periodically alter local temp by this amount.
#define TRAIT_ALTER_TEMP           3
/// General purpose plant strength value.
#define TRAIT_POTENCY              4
/// If 1, this plant will fruit repeatedly.
#define TRAIT_HARVEST_REPEAT       5
/// Can be used to make a battery.
#define TRAIT_PRODUCES_POWER       6
/// When thrown, causes a splatter decal.
#define TRAIT_JUICY                7
/// Icon to use for fruit coming from this plant.
#define TRAIT_PRODUCT_ICON         8
/// Icon to use for the plant growing in the tray.
#define TRAIT_PLANT_ICON           0
/// Will the plant remove gasses from its environment?
#define TRAIT_CONSUME_GASSES       10
/// The plant can starve.
#define TRAIT_REQUIRES_NUTRIENTS   11
/// Plant eats this much per tick.
#define TRAIT_NUTRIENT_CONSUMPTION 12
/// The plant can become dehydrated.
#define TRAIT_REQUIRES_WATER       13
/// Plant drinks this much per tick.
#define TRAIT_WATER_CONSUMPTION    14
/// 0 = none, 1 = eat pests in tray, 2 = eat living things (when a vine).
#define TRAIT_CARNIVOROUS          15
/// 0 = no, 1 = gain health from weed level.
#define TRAIT_PARASITE             16
/// Can cause damage/inject reagents when thrown or handled.
#define TRAIT_STINGS               17
/// The temperature from which the heat tolerance is calculated.
/// At this temperature, plus or minus the heat tolerance, is where the plant can grow without dying.
#define TRAIT_IDEAL_HEAT           18
/// The departure from ideal light that is survivable. If the departure goes above this value, damage will be dealt.
/// Has nothing to do with growth speed, only when the plant will begin taking damage!
#define TRAIT_HEAT_TOLERANCE       19
/// The temperature from which the light tolerance is calculated.
#define TRAIT_IDEAL_LIGHT          20
/// The departure from ideal light that is survivable. If the departure goes above this value, damage will be dealt.
/// Has nothing to do with growth speed, only when the plant will begin taking damage!
#define TRAIT_LIGHT_TOLERANCE      21
/// Low pressure capacity. Below this value in kPa, the plant begins taking damage.
#define TRAIT_LOWKPA_TOLERANCE     22
/// High pressure capacity. Above this value in kPa, the plant begins taking damage.
#define TRAIT_HIGHKPA_TOLERANCE    23
/// When thrown, acts as a grenade.
#define TRAIT_EXPLOSIVE            24
/// Resistance to poison.
#define TRAIT_TOXINS_TOLERANCE     25
/// Threshold for pests to impact health.
#define TRAIT_PEST_TOLERANCE       26
/// Threshold for weeds to impact health.
#define TRAIT_WEED_TOLERANCE       27
/// Maximum plant HP when growing. Determines for how long it can be taking damage until it dies.
#define TRAIT_ENDURANCE            28
/// Amount of product the plant will yield.
#define TRAIT_YIELD                29
/// 0 limits plant to tray, 1 = creepers, 2 = vines.
#define TRAIT_SPREAD               30
/// Time taken before the plant is mature. The higher this value, the longer it will take to mature.
#define TRAIT_MATURATION           31
/// Time before harvesting can be undertaken again.
#define TRAIT_PRODUCTION           32
/// Uses the bluespace tomato effect.
#define TRAIT_TELEPORTING          33
/// Colour of the plant icon.
#define TRAIT_PLANT_COLOUR         34
/// Colour to apply to product icon.
#define TRAIT_PRODUCT_COLOUR       35
/// Plant is bioluminescent.
#define TRAIT_BIOLUM               36
/// The colour of the plant's radiance.
#define TRAIT_BIOLUM_COLOUR        37
/// If set, plant will never mutate. If -1, plant is highly mutable.
#define TRAIT_IMMUTABLE            38
#define TRAIT_FLESH_COLOUR         39
/// If set, plant will periodically release smoke clouds of its reagent.
#define TRAIT_SPOROUS              40
/// The power of the plant's radiance.
#define TRAIT_BIOLUM_PWR           41
/// 0 = normal plant, 1 = big tree
#define TRAIT_LARGE                42
/// The color of the leaves, if the plant has any.
#define TRAIT_LEAVES_COLOUR        43
/// The range of temperature from the ideal in which the plant will grow faster than otherwise.
/// This does not kill the plant if they go outside it, it only determines growth speed!
#define TRAIT_HEAT_PREFERENCE      44
/// The range of lumens from the ideal in which the plant will grow faster than otherwise.
/// This does not kill the plant if they go outside it, it only determines growth speed!
#define TRAIT_LIGHT_PREFERENCE     45
