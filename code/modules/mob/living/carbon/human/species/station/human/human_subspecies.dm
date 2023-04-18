/datum/species/human/offworlder
	name = SPECIES_HUMAN_OFFWORLD
	name_plural = "Off-Worlder Humans"
	blurb = "The Offworlders are humans that have adapted to zero-G conditions through a lifetime of conditioning, exposure, and physical modification. \
	They thrive in thinner atmosphere and weightlessness, more often than not utilizing advanced life support and body-bracing equipment to sustain themselves in normal Human environments."
	hide_name = FALSE

	icobase = 'icons/mob/human_races/human/r_offworlder.dmi'
	deform = 'icons/mob/human_races/human/r_offworlder.dmi'
	preview_icon = 'icons/mob/human_races/human/offworlder_preview.dmi'

	flash_mod = 1.2
	oxy_mod = 0.8
	brute_mod = 1.2
	toxins_mod = 1.2
	bleed_mod = 0.5
	grab_mod = 1.1
	resist_mod = 0.75

	warning_low_pressure = 30
	hazard_low_pressure = 10

	examine_color = "#C2AE95"

/datum/species/human/offworlder/equip_later_gear(var/mob/living/carbon/human/H)
	if(istype(H.get_equipped_item(slot_back), /obj/item/storage/backpack) && H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/rmt(H.back), slot_in_backpack))
		return
	var/obj/item/storage/pill_bottle/rmt/PB = new /obj/item/storage/pill_bottle/rmt(get_turf(H))
	H.put_in_hands(PB)

/datum/species/human/offworlder/get_species_tally(var/mob/living/carbon/human/H)

	if(istype(H.back, /obj/item/rig/light/offworlder))
		var/obj/item/rig/light/offworlder/rig = H.back
		if(!rig.offline)
			return 0
		else
			return 3

	var/obj/item/organ/external/l_leg = H.get_organ(BP_L_LEG)
	var/obj/item/organ/external/r_leg = H.get_organ(BP_R_LEG)

	if((l_leg.status & ORGAN_ROBOT) && (r_leg.status & ORGAN_ROBOT))
		return

	if(H.w_uniform)
		var/obj/item/clothing/under/suit = H.w_uniform
		if(locate(/obj/item/clothing/accessory/offworlder/bracer) in suit.accessories)
			return 0

	var/obj/item/organ/internal/stomach/S = H.internal_organs_by_name[BP_STOMACH]
	if(S)
		for(var/_R in S.ingested.reagent_volumes)
			if(_R == /singleton/reagent/rmt)
				return 0

	return 4

/datum/species/human/offworlder/handle_environment_special(var/mob/living/carbon/human/H)
	if(prob(5))
		if(!H.can_feel_pain())
			return

		var/area/A = get_area(H)
		if(A && !A.has_gravity())
			return

		var/obj/item/organ/external/l_leg = H.get_organ(BP_L_LEG)
		var/obj/item/organ/external/r_leg = H.get_organ(BP_R_LEG)

		if((l_leg.status & ORGAN_ROBOT) && (r_leg.status & ORGAN_ROBOT))
			return

		if(istype(H.back, /obj/item/rig/light/offworlder))
			var/obj/item/rig/light/offworlder/rig = H.back
			if(!rig.offline)
				return

		if(H.w_uniform)
			var/obj/item/clothing/under/uniform = H.w_uniform
			if(locate(/obj/item/clothing/accessory/offworlder/bracer) in uniform.accessories)
				return

		var/obj/item/organ/internal/stomach/S = H.internal_organs_by_name[BP_STOMACH]
		if(S)
			for(var/_R in S.ingested.reagent_volumes)
				if(_R == /singleton/reagent/rmt)
					return

		var/pain_message = pick("You feel sluggish as if something is weighing you down.",
								"Your legs feel harder to move.",
								"You begin to have trouble standing upright.")

		to_chat(H, "<span class='warning'>[pain_message]</span>")
