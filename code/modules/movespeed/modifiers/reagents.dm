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

//Only speed boost for unathi
/datum/movespeed_modifier/alcohol/butanol
	variable = TRUE
