/mob/living/carbon/human/skeleton/Initialize(mapload)
	. = ..(mapload, SPECIES_SKELETON)

/mob/living/carbon/human/skeleton
	var/master

/mob/living/carbon/human/skeleton/assign_player(var/mob/user)
	. = ..()
	if(master)
		to_chat(src, "<B>You are a skeleton minion to [master], they are your master. Obey and protect your master at all costs, you have no free will.</B>")

/datum/species/skeleton //SPOOKY
	name = SPECIES_SKELETON
	name_plural = "skeletons"
	bodytype = BODYTYPE_SKELETON
	icobase = 'icons/mob/human_races/r_skeleton.dmi'
	deform = 'icons/mob/human_races/r_skeleton.dmi'
	eyes = "blank_eyes"

	total_health = 100 //skeletons are frail

	default_language = LANGUAGE_TCB
	language = LANGUAGE_CULT
	name_language = LANGUAGE_CULT
	unarmed_types = list(/datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/sharp)
	darksight = 8
	has_organ = list() //skeletons are empty shells for now, maybe we can add something in the future
	siemens_coefficient = 0
	ethanol_resistance = -1 //no drunk skeletons
	taste_sensitivity = TASTE_NUMB
	break_cuffs = TRUE

	meat_type = /obj/item/reagent_containers/food/snacks/meat/undead

	reagent_tag = IS_UNDEAD

	rarity_value = 10
	blurb = "Skeletons are undead brought back to life through dark wizardry, \
	they are empty shells fueled by sheer obscure power and blood-magic. \
	However, some men are cursed to carry such burden due to vile curses."

	warning_low_pressure = 50 //immune to pressure, so they can into space/survive breaches without worries
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	body_temperature = T0C //skeletons are cold

	blood_color = "#CCCCCC"
	flesh_color = "#AAAAAA"

	remains_type = /obj/effect/decal/cleanable/ash

	death_message = "collapses, their bones clattering in a symphony of demise..."
	death_message_range = 7
	death_sound = 'sound/effects/falling_bones.ogg'

	breath_type = null
	poison_type = null

	flags = NO_BLOOD | NO_SCAN | NO_SLIP | NO_POISON | NO_PAIN | NO_BREATHE | NO_EMBED | NO_CHUBBY
	spawn_flags = IS_RESTRICTED

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/skeleton),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/skeleton),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/skeleton),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/skeleton),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/skeleton),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/skeleton),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/skeleton),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/skeleton),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/skeleton),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/skeleton),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/skeleton)
		)

	stamina	=	500			  //Tireless automatons
	stamina_recovery = 1
	sprint_speed_factor = 0.3
	exhaust_threshold = 10

	max_nutrition_factor = -1

	max_hydration_factor = -1

	hud_type = /datum/hud_data/construct

/datum/species/skeleton/handle_death_check(var/mob/living/carbon/human/H)
	if(H.get_total_health() <= config.health_threshold_dead)
		return TRUE
	return FALSE

/mob/living/carbon/human/apparition/Initialize(mapload)
	. = ..(mapload, SPECIES_CULTGHOST)

/datum/species/apparition
	name = SPECIES_CULTGHOST
	name_plural = "apparitions"
	bodytype = BODYTYPE_CULTGHOST
	icobase = 'icons/mob/human_races/r_manifested.dmi'
	deform = 'icons/mob/human_races/r_manifested.dmi'

	default_language = LANGUAGE_TCB
	language = LANGUAGE_CULT
	name_language = LANGUAGE_CULT
	has_organ = list()

	reagent_tag = IS_UNDEAD

	rarity_value = 10
	blurb = "Apparitions are vengeful spirits, they are given temporary bodies to fulfill the wicked \
	desires of their masters. A common sight among the ranks of the geometer of blood."

	remains_type = /obj/effect/decal/cleanable/ash

	meat_type = /obj/item/reagent_containers/food/snacks/meat/undead

	flesh_color = "#551A8B"

	flags = NO_BLOOD | NO_SCAN | NO_SLIP | NO_POISON | NO_PAIN | NO_BREATHE | NO_EMBED
	spawn_flags = IS_RESTRICTED

	stamina	=	500			  //Tireless automatons
	stamina_recovery = 1
	sprint_speed_factor = 0.3
	exhaust_threshold = 0 //No oxyloss, so zero threshold

	max_nutrition_factor = -1

	max_hydration_factor = -1

	hud_type = /datum/hud_data/construct

/datum/species/apparition/handle_death(var/mob/living/carbon/human/H)
	set waitfor = 0
	sleep(1)
	new /obj/effect/decal/cleanable/ash(H.loc)
	qdel(H)

/datum/species/apparition/handle_death_check(var/mob/living/carbon/human/H)
	if(H.get_total_health() <= config.health_threshold_dead)
		return TRUE
	return FALSE


/mob/living/carbon/human/zombie/Initialize(mapload)
	. = ..(mapload, SPECIES_ZOMBIE)

/datum/species/zombie
	name = SPECIES_ZOMBIE
	name_plural = "Zombies"
	bodytype = BODYTYPE_HUMAN
	icobase = 'icons/mob/human_races/zombie/r_zombie.dmi'
	deform = 'icons/mob/human_races/zombie/r_zombie.dmi'

	hide_name = TRUE

	name_language = null // Use the first-name last-name generator rather than a language scrambler

	language = null
	default_language = LANGUAGE_GIBBERING

	unarmed_types = list(/datum/unarmed_attack/bite/infectious, /datum/unarmed_attack/claws/strong/zombie)
	darksight = 8

	has_fine_manipulation = FALSE

	speech_sounds = list('sound/hallucinations/growl1.ogg','sound/hallucinations/growl2.ogg','sound/hallucinations/growl3.ogg')
	speech_chance = 50

	ethanol_resistance = -1
	taste_sensitivity = TASTE_NUMB
	break_cuffs = TRUE

	has_organ = list(
		BP_ZOMBIE_PARASITE = /obj/item/organ/internal/parasite/zombie,
		BP_BRAIN =           /obj/item/organ/internal/brain/zombie,
		BP_STOMACH =         /obj/item/organ/internal/stomach
	)
	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/zombie),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/zombie),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/zombie),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/zombie),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/zombie),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/zombie),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/zombie),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/zombie),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/zombie),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/zombie),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/zombie)
	)

	total_health = 100

	slowdown = 2

	vision_flags = DEFAULT_SIGHT

	reagent_tag = IS_UNDEAD

	rarity_value = 10
	blurb = "Once a living person, this unholy creature was created either by the power of science or necromancy."

	remains_type = /obj/effect/decal/remains/human
	dust_remains_type = /obj/effect/decal/remains/human/burned

	meat_type = /obj/item/reagent_containers/food/snacks/meat/undead

	flesh_color = "#76a05e"

	flags = NO_BLOOD | NO_SCAN | NO_POISON | NO_PAIN | NO_BREATHE
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR | HAS_SOCKS
	spawn_flags = IS_RESTRICTED

	stamina	=	500			  //Tireless automatons
	stamina_recovery = 1
	sprint_speed_factor = 0.1
	exhaust_threshold = 10

	inherent_verbs = list(/mob/living/carbon/human/proc/darkness_eyes)

	allowed_eat_types = TYPE_ORGANIC | TYPE_HUMANOID

	gluttonous = 1

/datum/species/zombie/handle_post_spawn(var/mob/living/carbon/human/H)
	H.mutations |= CLUMSY
	var/datum/martial_art/zombie/Z = new /datum/martial_art/zombie()
	Z.teach(H)
	to_chat(H, "<font size=4><span class='notice'>Use the Check Attacks verb in your IC tab for information on your attacks! They are important! Your bite infects, but is worse at getting through armour than your claws, which have great damage and are armor piercing!</font></span>")
	H.accent = ACCENT_BLUESPACE
	return ..()

//Zombies do not have oxygen, so we have to handle the sprint this way
/datum/species/zombie/handle_sprint_cost(var/mob/living/carbon/human/H, var/cost, var/pre_move)
	. = ..()

	if(exhaust_threshold && (H.stamina) < (exhaust_threshold * 0.8))
		H.m_intent = M_WALK
		H.hud_used.move_intent.update_move_icon(H)
		to_chat(H, SPAN_DANGER("You're too exhausted to run anymore!"))
		H.flash_pain(H.get_shock())
		return 0

/datum/species/zombie/tajara
	name = SPECIES_ZOMBIE_TAJARA
	name_plural = "Tajara Zombies"
	bodytype = BODYTYPE_TAJARA
	icobase = 'icons/mob/human_races/zombie/r_zombie_tajara.dmi'
	deform = 'icons/mob/human_races/zombie/r_zombie_tajara.dmi'
	tail = "tajtail"
	tail_animation = 'icons/mob/species/tajaran/tail.dmi'

	slowdown = -1
	brute_mod = 1.2
	fall_mod = 0.5

	name_language = LANGUAGE_SIIK_MAAS

	remains_type = /obj/effect/decal/remains/xeno
	dust_remains_type = /obj/effect/decal/remains/xeno/burned

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	default_h_style = "Tajaran Ears"

	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

/datum/species/zombie/unathi
	name = SPECIES_ZOMBIE_UNATHI
	name_plural = "Unathi Zombies"
	bodytype = BODYTYPE_UNATHI
	icobase = 'icons/mob/human_races/zombie/r_zombie_unathi.dmi'
	deform = 'icons/mob/human_races/zombie/r_zombie_unathi.dmi'
	tail = "sogtail"
	tail_animation = 'icons/mob/species/unathi/tail.dmi'

	slowdown = 0.5
	brute_mod = 0.8
	grab_mod = 0.75
	fall_mod = 1.2

	mob_size = 10
	climb_coeff = 1.35

	name_language = LANGUAGE_UNATHI

	remains_type = /obj/effect/decal/remains/xeno
	dust_remains_type = /obj/effect/decal/remains/xeno/burned

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

/datum/species/zombie/skrell
	name = SPECIES_ZOMBIE_SKRELL
	name_plural = "Skrell Zombies"
	bodytype = BODYTYPE_SKRELL
	icobase = 'icons/mob/human_races/zombie/r_zombie_skrell.dmi'
	deform = 'icons/mob/human_races/zombie/r_zombie_skrell.dmi'

	grab_mod = 1.25

	name_language = LANGUAGE_SKRELLIAN

	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_SOCKS

	inherent_verbs = list(
	/mob/living/carbon/human/proc/commune,
	/mob/living/carbon/human/proc/sonar_ping,
	/mob/living/carbon/human/proc/darkness_eyes,
	)

	flesh_color = "#8CD7A3"
	blood_color = "#1D2CBF"

	remains_type = /obj/effect/decal/remains/xeno
	dust_remains_type = /obj/effect/decal/remains/xeno/burned

	default_h_style = "Skrell Short Tentacles"


///A zombie tuned for tankness
/datum/species/zombie/bull
	name = SPECIES_ZOMBIE_BULL
	name_plural = SPECIES_ZOMBIE_BULL+"s"
	icobase = 'icons/mob/human_races/zombie/r_zombie_bull.dmi'
	deform = 'icons/mob/human_races/zombie/r_zombie_bull.dmi'

	total_health = 200

	allowed_eat_types = TYPE_ORGANIC | TYPE_HUMANOID | TYPE_SYNTHETIC | TYPE_WEIRD
	gluttonous = GLUT_ANYTHING
	stomach_capacity = 10

	stamina = 50
	sprint_speed_factor = 0.9
	slowdown = 2
	exhaust_threshold = 20

	bump_flag = HEAVY
	species_height = HEIGHT_CLASS_TALL

	natural_armor = list(
		ballistic = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_MEDIUM,
		melee = ARMOR_MELEE_MAJOR,
		bomb = null,
		energy = ARMOR_ENERGY_RESISTANT
	)

	unarmed_types = list(/datum/unarmed_attack/bite/infectious)


///A zombie tuned to hunt preys
/datum/species/zombie/hunter
	name = SPECIES_ZOMBIE_HUNTER
	name_plural = SPECIES_ZOMBIE_HUNTER+"s"
	icobase = 'icons/mob/human_races/zombie/r_zombie_hunter.dmi'
	deform = 'icons/mob/human_races/zombie/r_zombie_hunter.dmi'
	slowdown = 2

	total_health = 90

	stamina = 40
	sprint_speed_factor = 0.9
	slowdown = -2
	standing_jump_range = 5
	natural_climbing = TRUE

	vision_flags = SEE_SELF | SEE_MOBS
	hearing_sensitivity = HEARING_VERY_SENSITIVE

	natural_armor = list(
		ballistic = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		melee = ARMOR_MELEE_MAJOR,
		bomb = ARMOR_BOMB_PADDED,
		energy = ARMOR_ENERGY_SMALL
	)

	unarmed_types = list(/datum/unarmed_attack/shocking) //This zombie cannot infect, it's an harrass type of zombie

///A zombie tuned for charge attacks
/datum/species/zombie/rhino
	name = SPECIES_ZOMBIE_THINO
	name_plural = SPECIES_ZOMBIE_THINO+"s"
	icobase = 'icons/mob/human_races/zombie/r_zombie_rhino.dmi'
	deform = 'icons/mob/human_races/zombie/r_zombie_rhino.dmi'
	slowdown = 2

	total_health = 90

	stamina = 50
	sprint_speed_factor = 0.7
	standing_jump_range = 5

	vision_flags = SEE_SELF

	bump_flag = HEAVY
	push_flags = HEAVY

	mob_size = MOB_LARGE
	grab_mod = 5

	natural_armor = list(
		ballistic = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		melee = ARMOR_MELEE_MAJOR,
		bomb = ARMOR_BOMB_PADDED,
		energy = ARMOR_ENERGY_SMALL
	)

	maneuvers = list(/singleton/maneuver/leap/areagrab)

	unarmed_types = list(/datum/unarmed_attack/bite/infectious, /datum/unarmed_attack/golem)
