//CHEMICAL ORGANS

/obj/item/organ/psy_chem
	name = "phoron sac"
	icon_state = "vox_lung"
	organ_tag = "phoron sacs"
	parent_organ = "chest"
	var/dexalin_level = 10
	var/leporazine_level = 10
	var/phoron_level = 25

/obj/item/organ/psy_chem/process()
	if(owner)
		var amount = 1
		if(is_broken())
			amount *= 0.5
		else if(is_bruised())
			amount *= 0.1

		var/dexalin_volume_raw = owner.reagents.get_reagent_amount(/datum/reagent/dexalin)
		var/phoron_volume_raw = owner.reagents.get_reagent_amount(/datum/reagent/toxin/phoron)
		var/leporazine_volume_raw = owner.reagents.get_reagent_amount(/datum/reagent/leporazine)

		if((dexalin_volume_raw < dexalin_level || !dexalin_volume_raw) && (phoron_volume_raw < phoron_level || !phoron_volume_raw))
			owner.reagents.add_reagent(/datum/reagent/toxin/phoron, amount)
		if((leporazine_volume_raw < leporazine_level || !leporazine_volume_raw) && (phoron_volume_raw < phoron_level || !phoron_volume_raw))
			owner.reagents.add_reagent(/datum/reagent/toxin/phoron, amount)
	..()

/obj/item/organ/liver/psy_worm
	name = "chemical reactor"
	icon_state = "vox_heart"
	parent_organ = "groin"
	var/acetone_level = 20
	var/copper_level = 5
	var/silicon_level = 5


/obj/item/organ/liver/psy_worm/process()
	if(owner)
		var amount = 0.8
		if(is_broken())
			amount *= 0.5
		else if(is_bruised())
			amount *= 0.1

		var/acetone_volume_raw = owner.reagents.get_reagent_amount(/datum/reagent/acetone)
		var/copper_volume_raw = owner.reagents.get_reagent_amount(/datum/reagent/silicon)
		var/silicon_volume_raw = owner.reagents.get_reagent_amount(/datum/reagent/copper)
		var/breath_fail_ratio = 1
		var/obj/item/organ/lungs/psy_worm/totally_not_lungs_I_swear = owner.internal_organs_by_name["tracheae"]
		if(totally_not_lungs_I_swear)
			breath_fail_ratio = owner.failed_last_breath
		if((acetone_volume_raw < acetone_level || !acetone_volume_raw) && breath_fail_ratio)
			owner.reagents.add_reagent(/datum/reagent/acetone, amount)
		if(owner.bodytemperature >= 600 || owner.bodytemperature <= 200)
			if(owner.nutrition >= 100)
				if((copper_volume_raw < copper_level || !copper_volume_raw))
					owner.reagents.add_reagent(/datum/reagent/copper, amount)
					owner.nutrition -= amount
				if((silicon_volume_raw < silicon_level || !silicon_volume_raw))
					owner.reagents.add_reagent(/datum/reagent/silicon, amount)
					owner.nutrition -= amount
	..()

// FAKE LUNGS

/obj/item/organ/lungs/psy_worm
	name = "tracheae"
	icon_state = "lungs"
	organ_tag = "lungs"
	parent_organ = "head"

/obj/item/organ/lungs/psy_worm/handle_failed_breath()
	var/mob/living/carbon/human/H = owner

	H.adjustOxyLoss(-(owner.chem_effects["dexalin"]))

	if(!owner.failed_last_breath && owner.chem_effects["dexalin"])
		H.oxygen_alert = 0
	if(owner.failed_last_breath && (damage))
		H.adjustOxyLoss(1 * owner.failed_last_breath)
		if(owner.chem_effects["dexalin"])
			H.oxygen_alert = 1
		else
			H.oxygen_alert = 2

/obj/item/organ/psy_camo
	name = "photoreceptor cluster"
	organ_tag = "photoreceptor cluster"
	parent_organ = "groin"
	icon = 'icons/mob/alien.dmi'
	icon_state = "weed_extract"
	var/datum/modifier/cloaking_device/modifier = null

/obj/item/organ/psy_camo/verb/active_camo(var/moved = 0 as num)
	set category = "Abilities"
	set name = "Active Camo"
	set desc = "Camouflage yourself"
	set src in usr

	if(owner)
		if (modifier)
			modifier.stop(1)
			modifier = null
			if(!moved)
				if(ispsyworm(owner))
					anim(get_turf(owner), owner,'icons/mob/species/psy_worm/effects.dmi',,"uncloak",,owner.dir)
				visible_message("<span class='danger'>\The [owner] fades out of invisibility with a hiss.</span>")
		else
			if(ispsyworm(owner))
				anim(get_turf(owner), owner,'icons/mob/species/psy_worm/effects.dmi',,"cloak",,owner.dir)
			modifier = owner.add_modifier(/datum/modifier/cloaking_device, MODIFIER_ITEM, owner, override = MODIFIER_OVERRIDE_NEIGHBOR, _check_interval = 30)
			visible_message("<span class='danger'>\The [owner]'s flesh flashes a number of vibrant colors before fading to match the background perfectly!</span>")
			owner.apply_effect(2, STUN, 0)

/obj/item/organ/psy_camo/verb/change_colour()
	set category = "Abilities"
	set name = "Change Colour"
	set desc = "Choose the colour of your skin."
	set src in usr

	if(owner)
		var/new_skin = input(usr, "Choose your new skin colour: ", "Change Colour", rgb(owner.r_skin, owner.g_skin, owner.b_skin)) as color|null
		owner.change_skin_color(hex2num(copytext(new_skin, 2, 4)), hex2num(copytext(new_skin, 4, 6)), hex2num(copytext(new_skin, 6, 8)))
		if(ispsyworm(owner))
			anim(get_turf(owner), owner,'icons/mob/species/psy_worm/effects.dmi',,"rainbow",,owner.dir)
		visible_message("<span class='danger'>\The [owner]'s flesh flashes a number of vibrant colors before settling on a new hue!</span>")

//I CAN KILL YOU WITH MY MIND

/obj/item/organ/brain/psy_worm
	var lowblood_tally = 0
	var lowblood_mult = 2
	name = "illuminated cortex"
	parent_organ = "head"
	icon_state = "brain_skrell"

/obj/item/organ/brain/psy_worm/process()
	if(!owner)
		return

	// No heart? You are going to have a very bad time. Not 100% lethal because heart transplants should be a thing.
	var/blood_volume = round(owner.vessel.get_reagent_amount("blood"))
	if(!owner.internal_organs_by_name["heart"])
		if(blood_volume > BLOOD_VOLUME_SURVIVE)
			blood_volume = BLOOD_VOLUME_SURVIVE
		owner.Paralyse(3)

	//Effects of bloodloss
	switch(blood_volume)
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			lowblood_tally = 1 * lowblood_mult
			if(prob(1))
				to_chat(owner, "<span class='warning'>You're finding it difficult to move.</span>")
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			lowblood_tally = 3 * lowblood_mult
			if(prob(1))
				to_chat(owner, "<span class='warning'>Moving has become very difficult.</span>")
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			lowblood_tally = 5 * lowblood_mult
			if(prob(15))
				to_chat(owner, "<span class='warning'>You're almost unable to move!</span>")
		if(-(INFINITY) to BLOOD_VOLUME_SURVIVE)
			lowblood_tally = 6 * lowblood_mult
			if(prob(10))
				to_chat(owner, "<span class='warning'>Your body is barely functioning and is starting to shut down.</span>")
				owner.Paralyse(1)
			for(var/obj/item/organ/I in owner.internal_organs)
				if(prob(5))
					I.take_damage(5)
	..()

//LIMBS

/obj/item/organ/external/chest/psy_worm
	name = "thorax"
	amputation_point = "spine"
	encased = "exoskeleton"

/obj/item/organ/external/groin/psy_worm
	name = "abdomen"

/obj/item/organ/external/arm/psy_worm
	name = "left claw"
	amputation_point = "coxa"

/obj/item/organ/external/arm/right/psy_worm
	name = "right claw"
	amputation_point = "coxa"

/obj/item/organ/external/leg/psy_worm
	name = "left tail hemisphere"

/obj/item/organ/external/leg/right/psy_worm
	name = "right tail hemisphere"

/obj/item/organ/external/foot/psy_worm
	name = "left tail tip"
	amputation_point = "left tail hemisphere"

/obj/item/organ/external/foot/right/psy_worm
	name = "right tail tip"
	amputation_point = "right tail hemisphere"

/obj/item/organ/external/hand/psy_worm
	name = "left grasper"

/obj/item/organ/external/hand/right/psy_worm
	name = "right grasper"

/obj/item/organ/external/head/psy_worm
	limb_name = "head"