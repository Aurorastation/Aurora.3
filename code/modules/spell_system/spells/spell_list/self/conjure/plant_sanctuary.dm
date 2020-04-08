/spell/aoe_turf/conjure/grove/sanctuary
	name = "Sanctuary"
	desc = "Creates a sanctuary of nature around the wizard as well as creating a healing plant."
	feedback = "SY"
	invocation = "Bo k'itan"
	invocation_type = SpI_SHOUT
	spell_flags = IGNOREDENSE | IGNORESPACE | NEEDSCLOTHES | Z2NOCAST | IGNOREPREV
	cooldown_min = 600
	cast_sound = 'sound/species/diona/gestalt_grow.ogg'
	
	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 3, Sp_POWER = 1)

	seed_type = /datum/seed/merlin_tear
	newVars = list("name" = "sanctuary", "desc" = "This grass makes you feel comfortable. Peaceful.","blessed" = 1)

	hud_state = "wiz_grove"

/spell/aoe_turf/conjure/grove/sanctuary/empower_spell()
	if(!..())
		return 0

	seed.set_trait(TRAIT_SPREAD,2) //make it grow.
	spread = 40
	return "Your sanctuary will now grow beyond that of the grassy perimeter."

/datum/seed/merlin_tear
	name = "merlin tears"
	seed_name = "merlin tears"
	display_name = "merlin tears"
	chems = list("bicaridine" = list(3,7), "dermaline" = list(3,7), "dylovene" = list(3,7), "tricordrazine" = list(3,7), "alkysine" = list(1,2), "imidazoline" = list(1,2), "peridaxon" = list(4,5))
	kitchen_tag = "berries"

/datum/seed/merlin_tear/setup_traits()
	..()
	set_trait(TRAIT_PLANT_ICON,"bush5")
	set_trait(TRAIT_PRODUCT_ICON,"berry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#4d4dff")
	set_trait(TRAIT_PLANT_COLOUR, "#ff6600")
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_IMMUTABLE,1)