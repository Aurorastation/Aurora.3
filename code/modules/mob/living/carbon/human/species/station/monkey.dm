/datum/species/monkey
	name = SPECIES_MONKEY
	short_name = "mon"
	name_plural = "Monkeys"
	blurb = "Ook."

	icobase = 'icons/mob/human_races/monkeys/r_monkey.dmi'
	deform = 'icons/mob/human_races/monkeys/r_monkey.dmi'
	skeleton_icon = 'icons/mob/human_races/monkeys/monkey_skeleton.dmi'
	damage_overlays = 'icons/mob/human_races/masks/dam_monkey.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_monkey.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_monkey.dmi'
	language = LANGUAGE_CHIMPANZEE
	default_language = LANGUAGE_CHIMPANZEE
	secondary_langs = list(LANGUAGE_CHIMPANZEE)
	greater_form = SPECIES_HUMAN
	mob_size = MOB_SMALL
	show_ssd = null

	bodytype = BODYTYPE_MONKEY

	eyes = "blank_eyes"

	gibbed_anim = "gibbed-m"

	death_message = "lets out a faint chimper as it collapses and stops moving..."
	death_message_range = 7

	tail = "chimptail"

	unarmed_types = list(/datum/unarmed_attack/bite, /datum/unarmed_attack/claws)
	inherent_verbs = list(/mob/living/proc/ventcrawl, /mob/living/carbon/human/proc/change_animal_name)
	hud_type = /datum/hud_data/monkey

	meat_type = /obj/item/reagent_containers/food/snacks/meat/monkey

	rarity_value = 0.1
	total_health = 75
	brute_mod = 1.5
	burn_mod = 1.5
	fall_mod = 0.5
	grab_mod = 1.25
	resist_mod = 0.25
	natural_climbing = 1

	spawn_flags = IS_RESTRICTED

	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	pass_flags = PASSTABLE
	holder_type = /obj/item/holder/monkey

/datum/species/monkey/handle_npc(var/mob/living/carbon/human/H)
	if(H.stat != CONSCIOUS)
		return

	if(prob(33) && H.canmove && isturf(H.loc) && !H.pulledby) //won't move if being pulled
		step(H, pick(cardinal))

	if(prob(1))
		H.emote(pick("scratch","jump","roll","tail"))

	if(H.get_shock() && H.shock_stage < 40 && prob(3))
		H.custom_emote(AUDIBLE_MESSAGE, "chimpers pitifully")

	if(H.shock_stage > 10 && prob(3))
		H.emote(pick("cry","whimper"))

	if(H.shock_stage >= 40 && prob(3))
		H.emote("scream")

	if(!H.restrained() && H.lying && H.shock_stage >= 60 && prob(3))
		H.custom_emote(AUDIBLE_MESSAGE, "thrashes in agony")

/datum/species/monkey/New()
	..()
	equip_adjust = list(
		slot_l_hand_str =    list("[NORTH]" = list("x" = 1, "y" = 2),  "[EAST]" = list("x" = -3, "y" = 1), "[SOUTH]" = list("x" = -2, "y" = 2), "[WEST]" = list("x" = 3, "y" = 2)),
		slot_r_hand_str =    list("[NORTH]" = list("x" = -1, "y" = 2), "[EAST]" = list("x" = -2, "y" = 2), "[SOUTH]" = list("x" = 2, "y" = 2),  "[WEST]" = list("x" = 2, "y" = 2)),
		slot_head_str =      list("[NORTH]" = list("x" = 0, "y" = 0),  "[EAST]" = list("x" = -2, "y" = 0), "[SOUTH]" = list("x" = 0, "y" = 0),  "[WEST]" = list("x" = 2, "y" = 0)),
		slot_wear_mask_str = list("[NORTH]" = list("x" = 0, "y" = 0),  "[EAST]" = list("x" = -1, "y" = 0), "[SOUTH]" = list("x" = 0, "y" = 0),  "[WEST]" = list("x" = 1, "y" = 0))
	)

/datum/species/monkey/get_random_name()
	return "[lowertext(name)] ([rand(100,999)])"

/datum/species/monkey/tajaran
	name = SPECIES_MONKEY_TAJARA
	short_name = "far"
	name_plural = "Farwa"
	fall_mod = 0.25

	icobase = 'icons/mob/human_races/monkeys/r_farwa.dmi'
	deform = 'icons/mob/human_races/monkeys/r_farwa.dmi'

	greater_form = SPECIES_TAJARA
	default_language = LANGUAGE_FARWA
	flesh_color = "#AFA59E"
	base_color = "#333333"
	tail = "farwatail"
	holder_type = /obj/item/holder/monkey/farwa

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai

/datum/species/monkey/tajaran/get_random_name()
	return "farwa ([rand(100,999)])" // HACK HACK HACK, oh lords of coding please forgive me!

/datum/species/monkey/skrell
	name = SPECIES_MONKEY_SKRELL
	short_name = "nea"
	name_plural = "Neaera"
	meat_type = /obj/item/reagent_containers/food/snacks/meat/neaera

	icobase = 'icons/mob/human_races/monkeys/r_neaera.dmi'
	deform = 'icons/mob/human_races/monkeys/r_neaera.dmi'

	greater_form = SPECIES_SKRELL
	default_language = LANGUAGE_NEAERA
	flesh_color = "#8CD7A3"
	blood_color = "#1D2CBF"
	reagent_tag = IS_SKRELL
	tail = null
	holder_type = /obj/item/holder/monkey/neaera
	fall_mod = 0.25

	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart/skrell/neaera,
		BP_LUNGS =    /obj/item/organ/internal/lungs/skrell/neaera,
		BP_LIVER =    /obj/item/organ/internal/liver/skrell/neaera,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys/skrell/neaera,
		BP_BRAIN =    /obj/item/organ/internal/brain/skrell/neaera,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_EYES =     /obj/item/organ/internal/eyes/skrell/neaera
		)

/datum/species/monkey/unathi
	name = SPECIES_MONKEY_UNATHI
	short_name = "sto"
	name_plural = LANGUAGE_STOK

	icobase = 'icons/mob/human_races/monkeys/r_stok.dmi'
	deform = 'icons/mob/human_races/monkeys/r_stok.dmi'

	tail = "stoktail"
	greater_form = SPECIES_UNATHI
	default_language = LANGUAGE_STOK
	flesh_color = "#34AF10"
	base_color = "#066000"
	reagent_tag = IS_UNATHI
	holder_type = /obj/item/holder/monkey/stok
	fall_mod = 0.75

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

/datum/species/monkey/bug
	name = SPECIES_MONKEY_VAURCA
	short_name = "kre"
	name_plural = "V'krexi"
	meat_type = /obj/item/reagent_containers/food/snacks/meat/bug
	holder_type = null//No icons for held Vkrexi yet
	icobase = 'icons/mob/human_races/monkeys/r_vkrexi.dmi'
	deform = 'icons/mob/human_races/monkeys/r_vkrexi.dmi'

	inherent_verbs = list(
		/mob/living/carbon/human/proc/bugbite,
		/mob/living/carbon/human/proc/change_animal_name
		)

	tail = "vkrexitail"
	greater_form = SPECIES_VAURCA_WORKER
	default_language = LANGUAGE_BUG
	blood_color = "#E6E600"
	flesh_color = "#E6E600"
	//base_color = "#E6E600"
	warning_low_pressure = 50
	hazard_low_pressure = 0
	siemens_coefficient = 0.2
	darksight = 8
	death_message = "chitters faintly before crumbling to the ground, their eyes dead and lifeless..."
	halloss_message = "crumbles to the ground, too weak to continue fighting."
	list/heat_discomfort_strings = list(
		"Your blood feels like its boiling in the heat.",
		"You feel uncomfortably warm.",
		"Your carapace feels hot as the sun."
		)
	list/cold_discomfort_strings = list(
		"You chitter in the cold.",
		"You shiver suddenly.",
		"Your carapace is ice to the touch."
		)
	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1
	brute_mod = 0.8
	burn_mod = 2
	fall_mod = 0
	slowdown = -1

