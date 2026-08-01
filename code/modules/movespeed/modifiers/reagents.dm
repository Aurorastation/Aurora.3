ABSTRACT_TYPE(/datum/movespeed_modifier/reagent)
	blacklisted_movetypes = (FLYING|FLOATING)

// These movespeed_modifiers are derived from metabolizing reagents, and if stacked can cause characters to move faster than ghosts
// For all reagents which increase movespeed, we give them the id 'reagent_speedup' and a priority correlating with their mutliplicative slowdown.
// This ensures that if a player ingests multiple reagents which increase movement speed, only the greatest movespeed bonus will apply.
// While we could do some fancy shit with weighting for multiple speedup reagents, it is best to keep this behavior simple for gameplay.

//Depends on the amount of caffeine in the drink
/datum/movespeed_modifier/reagent/caffeine
	id = "reagent_speedup"
	variable = TRUE

/datum/movespeed_modifier/reagent/hyperzine
	id = "reagent_speedup"
	priority = 50
	multiplicative_slowdown = -0.5

/datum/movespeed_modifier/reagent/stimm
	id = "reagent_speedup"
	priority = 75
	multiplicative_slowdown = -0.75

/datum/movespeed_modifier/reagent/skrell_nootropic
	id = "reagent_speedup"
	priority = 25
	multiplicative_slowdown = -0.25

/datum/movespeed_modifier/reagent/dionae_stimulant
	id = "reagent_speedup"
	priority = 50
	multiplicative_slowdown = -0.5

/datum/movespeed_modifier/reagent/kokoreed
	id = "reagent_speedup"
	priority = 50
	multiplicative_slowdown = -0.5

/datum/movespeed_modifier/reagent/kilosemine
	id = "reagent_speedup"
	priority = 50
	multiplicative_slowdown = -0.5

ABSTRACT_TYPE(/datum/movespeed_modifier/reagent/zorasoda)

/datum/movespeed_modifier/reagent/zorasoda/drone
	id = "reagent_speedup"
	priority = 50
	multiplicative_slowdown = -0.5


ABSTRACT_TYPE(/datum/movespeed_modifier/alcohol)


///This is ONLY for the intoxication management of alcohol, NOT for anything else
///if you're not using it in `code\modules\mob\living\carbon\human\intoxication.dm`, you're doing it wrong
/// As of the introduction of removing stacking reagent movespeed modifiers, both alcohol AND any non-alcohol 'slowdown' chems should use the same id
/// and priority system as used in 'speedup' chems.
/datum/movespeed_modifier/alcohol/intoxication
	id = "reagent_slowdown"
	priority = 50
	multiplicative_slowdown = 0.3
	variable = TRUE

//Only speed boost for unathi
/datum/movespeed_modifier/alcohol/butanol
	id = "reagent_slowdown"
	multiplicative_slowdown = 0
	variable = TRUE
