// This file exists because SpacemanDMM doesn't support GET PRIVATE SET vars, only fully PRIVATE vars.
// And these macro getters allow us to bypass this limitation by simulating an "Aggressively Inlined Public Get"
// Which kills proc overhead.
// If you use these to Set the associated vars, I will destroy you.

/// Public Get for /obj/organ/external/VAR_PRIVATE/pain
#define LIMB_GET_PAIN(limb) UNLINT(limb.pain)

/// Public Get for /obj/organ/external/VAR_PRIVATE/brute_dam
#define LIMB_GET_BRUTE_DAMAGE(limb) UNLINT(limb.brute_dam)

/// Public Get for /obj/organ/external/VAR_PRIVATE/burn_dam
#define LIMB_GET_BURN_DAMAGE(limb) UNLINT(limb.burn_dam)

/// Public Get for /obj/organ/external/VAR_PRIVATE/genetic_degradation
#define LIMB_GET_GENETIC_DAMAGE(limb) UNLINT(limb.genetic_degradation)

/// Public Get for /obj/organ/external/VAR_PRIVATE/dislocated
#define LIMB_GET_DISLOCATED(limb) UNLINT(limb.dislocated)
