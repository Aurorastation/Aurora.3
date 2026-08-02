/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator
	name = "synthetic fabricator"
	desc = "A general purpose fabricator that can be used to fabricate equipment for synthetics or exosuits."
	icon = 'icons/obj/machinery/robotics_fabricator.dmi'
	icon_state = "fab"
	idle_power_usage = 20
	active_power_usage = 5000
	req_access = list(ACCESS_ROBOTICS)
	component_types = list(
		/obj/item/circuitboard/mechfab,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/micro_laser,
		/obj/item/stock_parts/console_screen
	)
	manufacturer = "hephaestus"
	build_type = MECHFAB
	product_offset = TRUE

	fabrication_loop_type = /datum/looping_sound/synth_fab

	/// Manufacturer used for the currently assigned prosthetic job.
	var/limb_manufacturer = PROSTHETIC_IND

/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator/LateInitialize()
	. = ..()
	if(!linked_console)
		for(var/obj/structure/machinery/computer/rdconsole/console in range(3, src))
			console.SyncRDevices()
			if(linked_console)
				break

/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "- Materials are drawn from the research material silo linked to the same R&D console."
	. += "- Upgraded <b>micro-lasers</b> will increase fabrication speed."
	. += SPAN_NOTICE("	- The current speed increase is <b>[round((1 - (1 / production_speed)) * 100)]%</b>")
	. += "- Upgraded <b>manipulators</b> will improve material use efficiency."
	. += SPAN_NOTICE("	- The current cost reduction is <b>[round((1 - mat_efficiency) * 100)]%</b>")

/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Click-drag someone with long hair onto this machine to start feeding it their hair! This will hurt and piss them off!"

/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator/Initialize()
	. = ..()

	update_icon()

/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator/update_icon()
	ClearOverlays()
	if(panel_open)
		AddOverlays("[icon_state]_panel")
	if(!(stat & (NOPOWER | BROKEN)))
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		AddOverlays("[icon_state]_lights")
	if(build_callback_timer)
		AddOverlays("[icon_state]_working")
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights_working"))
		AddOverlays("[icon_state]_lights_working")

/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator/RefreshParts()
	..()
	var/manipulator_rating = 0
	for(var/obj/item/stock_parts/manipulator/manipulator in component_parts)
		manipulator_rating += manipulator.rating
	mat_efficiency = 1 - (manipulator_rating - 1) / 4

	var/laser_rating = 0
	for(var/obj/item/stock_parts/micro_laser/laser in component_parts)
		laser_rating += laser.rating
	production_speed = max(1, laser_rating)

/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator/attack_hand(mob/user)
	if(..())
		return
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	do_hair_pull(user)

	var/cancelled = FALSE
	SEND_SIGNAL(user, COMSIG_USE_MECH_FAB, &cancelled)
	if(cancelled)
		return

/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator/on_product_completed(obj/new_item, datum/design/design_to_build, datum/research_fabrication_job/job)
	visible_message("\The <b>[src]</b> pings, indicating that \the [new_item] is complete.", "You hear a ping.", intent_message = PING_SOUND)

/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator/mouse_drop_receive(atom/dropped, mob/user, params)
	var/mob/living/carbon/human/target = dropped
	if (!istype(target) || target.buckled_to || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.stat || istype(user, /mob/living/silicon/ai))
		return
	if(target == user)
		return
	src.add_fingerprint(user)
	var/target_loc = target.loc

	if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
		if(isskrell(target) || isunathi(target))
			return

		for(var/obj/item/protection in list(target.head))
			if(protection && (protection.flags_inv & BLOCKHAIR))
				return

		var/datum/sprite_accessory/hair/hair_style = GLOB.hair_styles_list[target.h_style]
		if(hair_style.length < 4)
			return

		user.visible_message(SPAN_WARNING("[user] starts feeding [target]'s hair into \the [src]!"), SPAN_WARNING("You start feeding [target]'s hair into \the [src]!"))
		if(!do_after(user, 5 SECONDS, target, DO_UNIQUE))
			return
		if(target_loc != target.loc)
			return
		if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
			user.visible_message(SPAN_WARNING("[user] feeds the [target]'s hair into the [src] and flicks it on!"), SPAN_ALERT("You turn the [src] on!"))
			do_hair_pull(target)
			user.attack_log += "\[[time_stamp()]\] <span class='warning'>Has fed [target.name]'s ([target.ckey]) hair into a [src].</span>"
			target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their hair fed into [src] by [user.name] ([user.ckey])</font>"
			msg_admin_attack("[key_name_admin(user)] fed [key_name_admin(target)] in a [src]. (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))
		else
			return
		if(!do_after(user, 3.5 SECONDS, target, DO_UNIQUE))
			return
		if(target_loc != target.loc)
			return
		if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
			user.visible_message(SPAN_ALERT("[user] starts tugging on [target]'s head as the [src] keeps running!"), SPAN_ALERT("You start tugging on [target]'s head!"))
			do_hair_pull(target)
			spawn(10)
			user.visible_message(SPAN_ALERT("[user] stops the [src] and leaves [target] resting as they are."), SPAN_ALERT("You turn the [src] off and let go of [target]."))

/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator/emag_act(var/remaining_charges, var/mob/user)
	switch(emagged)
		if(0)
			emagged = 0.5
			visible_message("[icon2html(src, viewers(get_turf(src)))] <b>[src]</b> beeps: \"DB error \[Code 0x00F1\]\"")
			sleep(10)
			visible_message("[icon2html(src, viewers(get_turf(src)))] <b>[src]</b> beeps: \"Attempting auto-repair\"")
			sleep(15)
			visible_message("[icon2html(src, viewers(get_turf(src)))] <b>[src]</b> beeps: \"User DB corrupted \[Code 0x00FA\]. Truncating data structure...\"")
			sleep(30)
			visible_message("[icon2html(src, viewers(get_turf(src)))] <b>[src]</b> beeps: \"User DB truncated. Please contact your [SSatlas.current_map.company_name] system operator for future assistance.\"")
			req_access = null
			emagged = 1
			return 1
		if(0.5)
			visible_message("[icon2html(src, viewers(get_turf(src)))] <b>[src]</b> beeps: \"DB not responding \[Code 0x0003\]...\"")
		if(1)
			visible_message("[icon2html(src, viewers(get_turf(src)))] <b>[src]</b> beeps: \"No records in User DB\"")

/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator/on_job_started(datum/research_fabrication_job/job)
	limb_manufacturer = job?.manufacturer

/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator/on_job_cleared()
	limb_manufacturer = PROSTHETIC_IND
