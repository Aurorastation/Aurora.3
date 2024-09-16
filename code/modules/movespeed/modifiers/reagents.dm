ABSTRACT_TYPE(/datum/movespeed_modifier/reagent)
	blacklisted_movetypes = (FLYING|FLOATING)

//Depends on the amount of caffeine in the drink
/datum/movespeed_modifier/reagent/caffeine
	variable = TRUE

/datum/movespeed_modifier/reagent/hyperzine
	multiplicative_slowdown = -1

/datum/movespeed_modifier/reagent/stimm
	multiplicative_slowdown = -1.5

/datum/movespeed_modifier/reagent/skrell_nootropic
	multiplicative_slowdown = -0.5

/datum/movespeed_modifier/reagent/dionae_stimulant
	multiplicative_slowdown = -1

/datum/movespeed_modifier/reagent/kokoreed
	multiplicative_slowdown = -1

/datum/movespeed_modifier/reagent/kilosemine
	multiplicative_slowdown = -1

ABSTRACT_TYPE(/datum/movespeed_modifier/reagent/zorasoda)

/datum/movespeed_modifier/reagent/zorasoda/drone
	multiplicative_slowdown = -1


ABSTRACT_TYPE(/datum/movespeed_modifier/alcohol)

///This is ONLY for the intoxication management of alcohol, NOT for anything else
///if you're not using it in `code\modules\mob\living\carbon\human\intoxication.dm`, you're doing it wrong
/datum/movespeed_modifier/alcohol/intoxication
	multiplicative_slowdown = 2
	variable = TRUE

//Only speed boost for unathi
/datum/movespeed_modifier/alcohol/butanol
	multiplicative_slowdown = 0
	variable = TRUE
