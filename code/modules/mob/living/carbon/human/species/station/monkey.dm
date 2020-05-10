/datum/species/monkey
	name = "Monkey"
	short_name = "mon"
	name_plural = "Monkeys"
	blurb = "Ook."

	icobase = 'icons/mob/human_races/monkeys/r_monkey.dmi'
	deform = 'icons/mob/human_races/monkeys/r_monkey.dmi'
	damage_overlays = 'icons/mob/human_races/masks/dam_monkey.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_monkey.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_monkey.dmi'
	language = null
	default_language = "Chimpanzee"
	greater_form = "Human"
	mob_size = MOB_SMALL
	has_fine_manipulation = 0
	show_ssd = null

	eyes = "blank_eyes"

	gibbed_anim = "gibbed-m"
	dusted_anim = "dust-m"

	death_message = "lets out a faint chimper as it collapses and stops moving..."
	death_message_range = 7

	tail = "chimptail"

	unarmed_types = list(/datum/unarmed_attack/bite, /datum/unarmed_attack/claws)
	inherent_verbs = list(/mob/living/proc/ventcrawl)
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
		H.custom_emote("chimpers pitifully")

	if(H.shock_stage > 10 && prob(3))
		H.emote(pick("cry","whimper"))

	if(H.shock_stage >= 40 && prob(3))
		H.emote("scream")

	if(!H.restrained() && H.lying && H.shock_stage >= 60 && prob(3))
		H.custom_emote("thrashes in agony")

/datum/species/monkey/get_random_name()
	return "[lowertext(name)] ([rand(100,999)])"

/datum/species/monkey/tajaran
	name = "Farwa"
	short_name = "far"
	name_plural = "Farwa"
	fall_mod = 0.25

	icobase = 'icons/mob/human_races/monkeys/r_farwa.dmi'
	deform = 'icons/mob/human_races/monkeys/r_farwa.dmi'

	greater_form = "Tajara"
	default_language = "Farwa"
	flesh_color = "#AFA59E"
	base_color = "#333333"
	tail = "farwatail"
	holder_type = /obj/item/holder/monkey/farwa

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

/datum/species/monkey/tajaran/get_random_name()
	return "farwa ([rand(100,999)])" // HACK HACK HACK, oh lords of coding please forgive me!

/datum/species/monkey/tajaran/m_sai
	name = "M'sai Farwa"
	greater_form = "M'sai Tajara"

/datum/species/monkey/tajaran/zhan_khazan
	name = "Zhan-Khazan Farwa"
	greater_form = "Zhan-Khazan Tajara"

/datum/species/monkey/skrell
	name = "Neaera"
	short_name = "nea"
	name_plural = "Neaera"

	icobase = 'icons/mob/human_races/monkeys/r_neaera.dmi'
	deform = 'icons/mob/human_races/monkeys/r_neaera.dmi'

	greater_form = "Skrell"
	default_language = "Neaera"
	flesh_color = "#8CD7A3"
	blood_color = "#1D2CBF"
	reagent_tag = IS_SKRELL
	tail = null
	holder_type = /obj/item/holder/monkey/neaera
	fall_mod = 0.25

/datum/species/monkey/unathi
	name = "Stok"
	short_name = "sto"
	name_plural = "Stok"

	icobase = 'icons/mob/human_races/monkeys/r_stok.dmi'
	deform = 'icons/mob/human_races/monkeys/r_stok.dmi'

	tail = "stoktail"
	greater_form = "Unathi"
	default_language = "Stok"
	flesh_color = "#34AF10"
	base_color = "#066000"
	reagent_tag = IS_UNATHI
	holder_type = /obj/item/holder/monkey/stok
	fall_mod = 0.75

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

/datum/species/monkey/bug
	name = "V'krexi"
	short_name = "kre"
	name_plural = "V'krexi"
	meat_type = /obj/item/reagent_containers/food/snacks/meat/bug
	holder_type = null//No icons for held Vkrexi yet
	icobase = 'icons/mob/human_races/monkeys/r_vkrexi.dmi'
	deform = 'icons/mob/human_races/monkeys/r_vkrexi.dmi'

	inherent_verbs = list(
		/mob/living/carbon/human/proc/bugbite
		)

	tail = "vkrexitail"
	greater_form = "Vaurca Worker"
	default_language = "V'krexi"
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

