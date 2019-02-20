/datum/species/human/offworlder
	name = "Off-Worlder Human"
	name_plural = "off-worlders Humans"
	blurb = "The Offworlders are humans that have adapted to zero-G conditions through a lifetime of conditioning, exposure, and physical modification. \
	They thrive in thinner atmosphere and weightlessness, more often than not utilizing advanced life support and body-bracing equipment to sustain themselves in normal Human environments."
	icobase = 'icons/mob/human_races/subspecies/r_offworlder.dmi'

	flash_mod =     1.2
	oxy_mod =       0.8
	brute_mod =     1.2
	toxins_mod =    1.2
	bleed_mod = 0.5

	warning_low_pressure = 30
	hazard_low_pressure = 10

	spawn_flags = IS_RESTRICTED
/*
/datum/species/human/offworlder/equip_later_gear(var/mob/living/carbon/human/H)
	if(H.back)
		var/obj/item/I = H.back
		H.unEquip(I)
		H.put_in_hands(I)

	var/obj/item/weapon/rig/light/offworlder/skeleton = new(get_turf(H))
	skeleton.autodrobe_no_remove = TRUE
	H.equip_to_slot_or_del(skeleton,slot_back)

*/
/datum/species/human/offworlder/stance_check(var/mob/living/carbon/human/H)
	if(H.back && istype(H.back, /obj/item/weapon/rig/light/offworlder))
		var/obj/item/weapon/rig/light/offworlder/rig = H.back
		if(!rig.offline)
			return 0
		else
			return 3

	return 4

