/spell/aoe_turf/conjure/grove
	name = "Grove"
	desc = "Creates a sanctuary of nature around the wizard as well as creating a healing plant."

	spell_flags = IGNOREDENSE | IGNORESPACE | NEEDSCLOTHES | Z2NOCAST | IGNOREPREV
	charge_max = 1200
	school = "conjuration"
	cast_sound = 'sound/species/diona/gestalt_grow.ogg'
	range = 1
	cooldown_min = 600

	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 3, Sp_POWER = 1)

	summon_amt = 47
	summon_type = list(/turf/simulated/floor/grass/alt)
	var/spread = 0
	var/datum/seed/seed
	var/seed_type = /datum/seed/merlin_tear

/spell/aoe_turf/conjure/grove/New()
	..()
	if(seed_type)
		seed = new seed_type()
	else
		seed = SSplants.create_random_seed(1)

/spell/aoe_turf/conjure/grove/before_cast()
	var/turf/T = get_turf(holder)
	var/obj/effect/plant/P = new(T,seed)
	P.spread_chance = spread