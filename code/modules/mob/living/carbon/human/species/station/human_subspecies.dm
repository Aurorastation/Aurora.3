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

/datum/species/human/offworlder/equip_later_gear(var/mob/living/carbon/human/H)
	if(H.back)
		var/obj/item/I = H.back
		H.unEquip(I)
		H.put_in_hands(I)

	var/obj/item/weapon/rig/light/offworlder/skeleton = new(get_turf(H))
	skeleton.autodrobe_no_remove = TRUE
	H.equip_to_slot_or_del(skeleton,slot_back)
	to_chat(H, "<span class='notice'>You have access to \the [skeleton], deploy it to allow you to walk properly.</span>")

/datum/species/human/offworlder/get_species_tally(var/mob/living/carbon/human/H)

	if(H.back && istype(H.back, /obj/item/weapon/rig/light/offworlder))
		var/obj/item/weapon/rig/light/offworlder/rig = H.back
		if(!rig.offline)
			return 0
		else
			return 3

	if(H.w_uniform)
		var/obj/item/clothing/under/suit = H.w_uniform
		if(locate(/obj/item/clothing/accessory/offworlder/bracer) in suit.accessories)
			return 0


	if(H.reagents)
		if(H.reagents.has_reagent("RMT", 1))
			return 0

	return 4

/datum/species/human/offworlder/handle_environment_special(var/mob/living/carbon/human/H)
	if(prob(5))
		if(!H.can_feel_pain())
			return

		if(H.back && istype(H.back, /obj/item/weapon/rig/light/offworlder))
			var/obj/item/weapon/rig/light/offworlder/rig = H.back
			if(!rig.offline)
				return

		if(H.w_uniform)
			var/obj/item/clothing/under/uniform = H.w_uniform
			if(locate(/obj/item/clothing/accessory/offworlder/bracer) in suit.uniform)
				return


		if(H.reagents)
			if(H.reagents.has_reagent("RMT", 1))
				return

		to_chat(H, "<span class='warning'>owww my bones hurt a lot oww oof my booones</span>")