
////////////
///AUTAKH///
////////////

/datum/species/unathi/autakh
	name = "Aut'akh Unathi"
	short_name = "aut"
	name_plural = "Aut'akh Unathi"

	icobase = 'icons/mob/human_races/r_autakh.dmi'
	deform = 'icons/mob/human_races/r_def_lizard.dmi'
	tail = "autakh"
	tail_animation = null

	slowdown = 0.5
	brute_mod = 0.7
	burn_mod = 1.2
	toxins_mod = 0.8
	fall_mod = 1.1

	economic_modifier = 4

	sprint_speed_factor = 2.6
	sprint_cost_factor = 1.10

	rarity_value = 4

	metabolism_mod = 2

	eyes_are_impermeable = TRUE
	breakcuffs = list(MALE, FEMALE)

	meat_type = /obj/item/stack/material/steel
	remains_type = /obj/effect/decal/remains/robot

	death_message = "gives one shrill beep before falling lifeless."
	knockout_message = "encounters a hardware fault and suddenly reboots!"
	halloss_message = "encounters a hardware fault and suddenly reboots."
	halloss_message_self = "ERROR: Unrecoverable machine check exception.<BR>System halted, rebooting..."

	blurb = "The Aut'akh are a religious commune of cybernetically-augmented Unathi. They mostly hail from Moghes, and are made up of castoffs, refugees and exiles \
	from other clans who have settled in the icy north pole. Formed from survivors of the contact war, the Aut'akh take a radical view of the standard Unathi position that \
	the body is just a shell; they believe that meat is animated by soul, while metal is powered by electricity, and thus replacing one's body with metal empowers the soul.<br><br> \
	They are managed, but not ruled, by their god Oss, a silent deity who quietly facilitates the Aut'akh's prosperity behind the scenes. They are almost excessively friendly, \
	seeing all the beings of the galaxy as potential Aut'akh or allies for the Aut'akh. They also hold a strong spiritual tradition, believing that highly charismatic or intelligent \
	people or strong fighters are blessed with magic"

	cold_level_1 = 250 //Default 260 - Lower is better
	cold_level_2 = 210 //Default 200
	cold_level_3 = 120 //Default 120

	heat_level_1 = 380 //Default 360 - Higher is better
	heat_level_2 = 420 //Default 400
	heat_level_3 = 1000 //Default 1000

	inherent_verbs = list(
		/mob/living/proc/devour,
		/mob/living/carbon/human/proc/regurgitate,
		/mob/living/carbon/human/proc/detach_limb,
		/mob/living/carbon/human/proc/attach_limb
	)

	has_organ = list(
		"heart" =    /obj/item/organ/heart,
		"lungs" =    /obj/item/organ/lungs,
		"liver" =    /obj/item/organ/liver,
		"kidneys" =  /obj/item/organ/kidneys/autakh,
		"brain" =    /obj/item/organ/brain,
		"eyes" =     /obj/item/organ/eyes/autakh,
		"anchor" =   /obj/item/organ/anchor,
		"haemodynamic" =   /obj/item/organ/haemodynamic,
		"adrenal" =   /obj/item/organ/adrenal
		)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/autakh),
		"groin" =  list("path" = /obj/item/organ/external/groin/autakh),
		"head" =   list("path" = /obj/item/organ/external/head/autakh),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/autakh),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/autakh),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/autakh),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/autakh),
		"l_hand" = list("path" = /obj/item/organ/external/hand/autakh),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/autakh),
		"l_foot" = list("path" = /obj/item/organ/external/foot/autakh),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/autakh)
		)

	appearance_flags = HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	flags = NO_CHUBBY | NO_SCAN

	flesh_color = "#575757"
	base_color = "#575757"

	heat_discomfort_level = 290
	heat_discomfort_strings = list(
		"Your organs feel warm.",
		"Your temperature sensors are reading high.",
		"You feel warm enough to take a nap."
		)

	cold_discomfort_level = 285
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You read a cryogenic environment.",
		"Your servos creak in the cold."
		)

	siemens_coefficient = 1.1

	nutrition_loss_factor = 1.2

	hydration_loss_factor = 1.2

	light_range = 2
	light_power = 0.5

/datum/species/unathi/autakh/get_light_color(mob/living/carbon/human/H)
	if (!istype(H))
		return null

	var/obj/item/organ/eyes/eyes = H.get_eyes()
	if (eyes)
		var/eyegb = rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3])
		return eyegb