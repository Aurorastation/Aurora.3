/mob/living/carbon/human/gib()
	vr_disconnect()

	for(var/obj/item/organ/I in internal_organs)
		I.removed()
		if(isturf(loc))
			I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)

	for(var/obj/item/organ/external/E in src.organs)
		E.droplimb(0,DROPLIMB_EDGE,1)

	sleep(1)

	for(var/obj/item/I in src)
		drop_from_inventory(I)
		I.throw_at(get_edge_target_turf(src,pick(alldirs)), rand(1,3), round(30/I.w_class))

	..(species.gibbed_anim)
	gibs(loc, viruses, dna, null, species.flesh_color, species.blood_color)

/mob/living/carbon/human/dust()
	vr_disconnect()

	if(species)
		..(species.dusted_anim, species.remains_type)
	else
		..()

/mob/living/carbon/human/death(gibbed)
	if(stat == DEAD)
		return

	vr_disconnect()

	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)

	//Handle species-specific deaths.
	species.handle_death(src, gibbed)
	animate_tail_stop()

	//Handle brain slugs.
	var/obj/item/organ/external/head = get_organ(BP_HEAD)
	var/mob/living/simple_animal/borer/B

	if(head)
		for(var/I in head.implants)
			if(istype(I,/mob/living/simple_animal/borer))
				B = I
		if(B)
			if(!B.ckey && ckey && B.controlling)
				B.ckey = ckey
				B.controlling = 0
			if(B.host_brain?.ckey)
				ckey = B.host_brain.ckey
				B.host_brain.ckey = null
				B.host_brain.name = "host brain"
				B.host_brain.real_name = "host brain"

			verbs -= /mob/living/carbon/proc/release_control

	callHook("death", list(src, gibbed))

	if(!gibbed)
		if(species.death_sound)
			playsound(loc, species.death_sound, 80, 1, 1)

	if(SSticker.mode)
		sql_report_death(src)
		SSticker.mode.check_win()

	if(wearing_rig?.ai_override_enabled)
		wearing_rig.notify_ai("<span class='danger'>Warning: user death event. Mobility control passed to integrated intelligence system.</span>")

	. = ..(gibbed, species.death_message, species.death_message_range)

	if(!gibbed) //We want to handle organs one last time to make sure that hearts don't report a positive pulse after death.
		handle_organs()

	handle_hud_list()

/mob/living/carbon/human/proc/ChangeToHusk()
	if(HUSK in mutations)
		return

	if(f_style)
		f_style = "Shaved"		//we only change the icon_state of the hair datum, so it doesn't mess up their UI/UE
	if(h_style)
		h_style = "Bald"
	update_hair(0)

	name = "Unknown"
	real_name = "Unknown"

	scrub_flavor_text()

	mutations.Add(HUSK)
	status_flags |= DISFIGURED	//makes them unknown without fucking up other stuff like admintools
	update_body(TRUE)
	return

/mob/living/carbon/human/proc/Drain()
	ChangeToHusk()
	mutations |= HUSK
	return

/mob/living/carbon/human/proc/ChangeToSkeleton(var/keep_name = FALSE)
	if(SKELETON in src.mutations)	return

	if(f_style)
		f_style = "Shaved"
	if(h_style)
		h_style = "Bald"
	update_hair(0)

	if(!keep_name)
		name = "Unknown"
		real_name = "Unknown"
		scrub_flavor_text()

	mutations.Add(SKELETON)
	status_flags |= DISFIGURED
	update_body(TRUE)
	return

/mob/living/carbon/human/proc/scrub_flavor_text()
	for(var/text in flavor_texts)
		flavor_texts[text] = null

/mob/living/carbon/human/proc/vr_disconnect()
	if(remote_network)
		SSvirtualreality.remove_robot(src, remote_network)
		remote_network = null

/mob/living/carbon/human/proc/drop_all_limbs(var/droplimb_type = DROPLIMB_BLUNT)
	for(var/thing in organs)
		var/obj/item/organ/external/limb = thing
		var/limb_can_amputate = (limb.limb_flags & ORGAN_CAN_AMPUTATE)
		limb.limb_flags |= ORGAN_CAN_AMPUTATE
		limb.droplimb(TRUE, droplimb_type, TRUE, TRUE)
		if(!QDELETED(limb) && !limb_can_amputate)
			limb.limb_flags &= ~ORGAN_CAN_AMPUTATE
	dump_contents()
	qdel(src)