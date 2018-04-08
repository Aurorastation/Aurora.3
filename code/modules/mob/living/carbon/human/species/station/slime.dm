/datum/species/slime
	name = "Slime"
	name_plural = "slimes"
	mob_size = MOB_SMALL

	icobase = 'icons/mob/human_races/r_slime.dmi'
	deform = 'icons/mob/human_races/r_slime.dmi'

	language = null //todo?
	unarmed_types = list(/datum/unarmed_attack/slime_glomp)
	flags = NO_SCAN | NO_SLIP | NO_BREATHE | NO_EMBED
	spawn_flags = IS_RESTRICTED
	siemens_coefficient = 3 //conductive
	darksight = 3
	rarity_value = 5
	virus_immune = 1
	fall_mod = 0

	blood_color = "#05FF9B"
	flesh_color = "#05FFFB"

	remains_type = /obj/effect/decal/cleanable/ash
	death_message = "rapidly loses cohesion, splattering across the ground..."

	has_organ = list(
		"brain" = /obj/item/organ/brain/slime
		)

	breath_type = null
	poison_type = null

	bump_flag = SLIME
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL

	has_limbs = list(
		TARGET_CHEST =  list("path" = /obj/item/organ/external/chest/unbreakable),
		TARGET_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable),
		TARGET_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable),
		TARGET_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable),
		TARGET_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable),
		TARGET_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable),
		TARGET_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable),
		TARGET_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable),
		TARGET_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable),
		TARGET_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable),
		TARGET_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable)
		)

/datum/species/slime/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		if(H)
			H.gib()
