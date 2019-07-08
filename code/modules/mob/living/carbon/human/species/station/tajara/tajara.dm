/datum/species/tajaran
	name = "Tajara"
	short_name = "taj"
	name_plural = "Tajara"
	bodytype = "Tajara"
	icobase = 'icons/mob/human_races/tajara/r_tajaran.dmi'
	deform = 'icons/mob/human_races/tajara/r_def_tajaran.dmi'
	preview_icon = 'icons/mob/human_races/tajara/tajaran_preview.dmi'
	tail = "tajtail"
	tail_animation = 'icons/mob/species/tajaran/tail.dmi'
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp
	)
	darksight = 8
	slowdown = -1
	brute_mod = 1.2
	fall_mod = 0.5
	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_SIIK_MAAS, LANGUAGE_SIIK_TAJR, LANGUAGE_YA_SSA, LANGUAGE_SIIK_TAU)
	name_language = LANGUAGE_SIIK_MAAS
	ethanol_resistance = 0.8//Gets drunk a little faster
	rarity_value = 2
	economic_modifier = 7

	stamina = 90	// Tajara evolved to maintain a steady pace in the snow, sprinting wastes energy
	stamina_recovery = 4
	sprint_speed_factor = 0.65
	sprint_cost_factor = 0.75

	blurb = "The Tajaran race is a species of feline-like bipeds hailing from the planet of Adhomai in the S'rendarr \
	system. They have been brought up into the space age by the Humans and Skrell, who alledgedly influenced their \
	eventual revolution that overthrew their ancient monarchies to become totalitarian - and NanoTrasen friendly - \
	republics. Adhomai is still enduring a global war in the aftermath of the new world order, and many Tajara are \
	fleeing their homeworld to seek safety and employment in human space. They prefer colder environments, and speak \
	a variety of languages, mostly Siik'Maas, using unique inflections their mouths form."

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80  //Default 120

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000

	primitive_form = "Farwa"

	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#333333"

	reagent_tag = IS_TAJARA

	heat_discomfort_level = 292
	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
	)
	cold_discomfort_level = 275

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	default_h_style = "Tajaran Ears"

/datum/species/tajaran/before_equip(var/mob/living/carbon/human/H)
	. = ..()
	var/obj/item/clothing/shoes/sandal/S = new /obj/item/clothing/shoes/sandal(H)
	if(H.equip_to_slot_or_del(S,slot_shoes))
		S.autodrobe_no_remove = 1