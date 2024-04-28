/obj/machinery/iv_drip
	name = "\improper IV drip"
	desc = "A professional standard intravenous stand with supplemental gas support for medical use."
	desc_info = "IV drips can be supplied beakers/bloodpacks for reagent transfusions, as well as one breath mask and gas tank for supplemental gas therapy. \
	It can be upgraded. <br>Click and Drag to attach/detach the IV or secure/remove the breath mask on your target. <br>Click the stand with an empty hand to \
	toggle between various modes. Using a wrench when it has a tank installed will secure it.<br>Alt Click the stand to remove items contained in the stand."
	icon = 'icons/obj/iv_drip.dmi'
	icon_state = "iv_stand"
	anchored = 0
	density = FALSE
	var/tipped = FALSE
	var/last_full // Spam check
	var/last_warning

	// Blood Stuff
	var/mob/living/carbon/human/attached = null
	var/obj/item/organ/external/vein = null
	var/obj/item/reagent_containers/beaker = null
	var/transfer_amount = REM
	var/transfer_limit = 4
	var/mode = TRUE // TRUE is injecting, FALSE is taking blood.
	var/toggle_stop = TRUE
	var/blood_message_sent = FALSE
	var/attach_delay = 5
	var/armor_check = TRUE
	var/adv_scan = FALSE

	// Supplemental Gas Stuff
	var/mob/living/carbon/human/breather = null
	var/obj/item/clothing/mask/breath/breath_mask = null
	var/obj/item/tank/tank = null
	var/tank_type = null
	var/is_loose = TRUE
	var/list/tank_blacklist = list(/obj/item/tank/emergency_oxygen, /obj/item/tank/jetpack)
	var/valve_open = FALSE
	var/tank_active = FALSE
	var/epp = TRUE // Emergency Positive Pressure system. Can be toggled if you want to turn it off
	var/epp_active = FALSE

	//Matrix stuff
	var/matrix/iv_matrix

	//What we accept as a container for IV transfers. Prevents attaching food and organs to IVs.
	var/list/accepted_containers = list(
		/obj/item/reagent_containers/blood,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle)

	var/list/mask_blacklist = list(
		/obj/item/clothing/mask/gas/vaurca,
		/obj/item/clothing/mask/breath/skrell,
		/obj/item/clothing/mask/breath/lyodsuit,
		/obj/item/clothing/mask/breath/infiltrator)

	component_types = list(
		/obj/item/circuitboard/iv_drip,
		/obj/item/reagent_containers/syringe,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/scanning_module)

/obj/machinery/iv_drip/Destroy()
	if(attached)
		attached = null
		vein = null
	QDEL_NULL(beaker)
	if(breather)
		breath_mask_rip()
	QDEL_NULL(breath_mask)
	QDEL_NULL(tank)
	return ..()

/obj/machinery/iv_drip/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /obj/machinery/iv_drip))
		return FALSE
	if(height && istype(mover) && mover.checkpass(PASSTABLE)) //allow bullets, beams, thrown objects, rats, drones, and the like through.
		return TRUE
	return ..()

/obj/machinery/iv_drip/Crossed(var/mob/H)
	if(ishuman(H))
		var/mob/living/carbon/human/M = H
		if(M.shoes?.item_flags & ITEM_FLAG_LIGHT_STEP)
			return
		if(M.incapacitated())
			return
		if(tipped)
			return
		if(M.m_intent == M_RUN && M.a_intent == I_HURT)
			src.visible_message(SPAN_WARNING("[M] bumps into \the [src], knocking it over!"), SPAN_WARNING("You bump into \the [src], knocking it over!"))
			do_crash()
	return ..()

/obj/machinery/iv_drip/update_icon()
	cut_overlays()
	if(beaker)
		add_overlay("beaker")
		var/datum/reagents/reagents = beaker.reagents
		if(reagents?.total_volume)
			var/image/filling = image('icons/obj/iv_drip.dmi', src, "reagent")
			var/percent = round((reagents.total_volume / beaker.volume) * 100)
			var/fill_level = 0
			switch(percent)
				if(-INFINITY to 9)	fill_level = 0
				if(10 to 24)	 	fill_level = 10
				if(25 to 49)		fill_level = 25
				if(50 to 74)		fill_level = 50
				if(75 to 79)		fill_level = 75
				if(80 to 90)		fill_level = 80
				if(91 to INFINITY)	fill_level = 100
			filling.icon_state = "reagent[fill_level]"
			var/reagent_color = reagents.get_color()
			filling.icon += reagent_color
			add_overlay(filling)
		if(attached)
			add_overlay("iv_in")
			if(mode)
				add_overlay("light_green")
			else
				add_overlay("light_red")
			if(blood_message_sent)
				add_overlay("light_yellow")
		else
			add_overlay("iv_out")
	if(tank)
		if(istype(tank, /obj/item/tank/oxygen))
			tank_type = "oxy"
		else if(istype(tank, /obj/item/tank/anesthetic))
			tank_type = "anest"
		else if(istype(tank, /obj/item/tank/phoron))
			tank_type = "phoron"
		else
			tank_type = "other"
		add_overlay("tank_[tank_type]")

		var/tank_level = 2
		switch(tank.percent())
			if(-INFINITY to 4)	tank_level = 0
			if(05 to 19)		tank_level = 1
			if(20 to 39)		tank_level = 2
			if(40 to 59)		tank_level = 3
			if(60 to 79)		tank_level = 4
			if(80 to 90)		tank_level = 5
			if(91 to INFINITY)	tank_level = 6
		add_overlay("[tank.gauge_icon][tank_level]")
	if(breath_mask)
		if(breather)
			add_overlay("mask_on")
		else
			add_overlay("mask_off")
		if(epp_active)
			add_overlay("light_blue")
	if(panel_open)
		add_overlay("panel_open")

/obj/machinery/iv_drip/process()
	breather_process()
	attached_process()

/obj/machinery/iv_drip/proc/breather_process()
	if(breather)
		if(!breather.Adjacent(src))
			src.visible_message(SPAN_WARNING("\The [breath_mask] snaps back into \the [src]!"))
			breath_mask_rip()
			return
		var/mask_check = breath_mask.get_equip_slot()
		if(mask_check != slot_wear_mask)
			src.visible_message(SPAN_NOTICE("\The [src] automatically retracts \the [breath_mask]."))
			breath_mask_rip()
			return
		if(breath_mask.hanging)
			src.visible_message(SPAN_NOTICE("\The [src] automatically retracts \the [breath_mask]."))
			breath_mask_rip()
			return
		if(breath_mask.loc != breather)
			src.visible_message(SPAN_NOTICE("\The [src] automatically retracts \the [breath_mask]."))
			breath_mask_rip()
			return
		if(!tank)
			return
		if(breather.species.flags & NO_BREATHE)
			return

		if(valve_open)
			var/obj/item/organ/internal/lungs/L = breather.internal_organs_by_name[BP_LUNGS]
			if(!L)
				src.visible_message(SPAN_NOTICE("\The [src] buzzes, automatically deactivating \the [tank]."))
				playsound(src, 'sound/machines/buzz-two.ogg', 50, extrarange = SILENCED_SOUND_EXTRARANGE)
				tank_off()
				return
			var/safe_pressure_min = breather.species.breath_pressure + 5
			safe_pressure_min *= 1 + rand(1,4) * L.damage/L.max_damage

			if(!tank_active) // Activates and sets the kPa to a safe pressure. This keeps from it constantly resetting itself
				tank.distribute_pressure = safe_pressure_min
				src.visible_message(SPAN_NOTICE("\The [src] chimes and adjusts \the [tank]'s release pressure."))
				playsound(src, 'sound/machines/chime.ogg', 50, extrarange = SILENCED_SOUND_EXTRARANGE)
				tank_active = TRUE
			if(L.checking_rupture == FALSE) // Safely retracts in case the lungs are about to rupture
				src.visible_message(SPAN_WARNING("\The [src]'s flashes a warning light, automatically deactivating \the [tank] and retracting \the [breath_mask]."))
				playsound(src, 'sound/machines/twobeep.ogg', 50, extrarange = SILENCED_SOUND_EXTRARANGE)
				breath_mask_rip()
				return
			if(tank.air_contents.return_pressure() <= 10)
				src.visible_message(SPAN_WARNING("\The [src] buzzes, automatically deactivating \the [tank] and retracting \the [breath_mask]."))
				playsound(src, 'sound/machines/buzz-two.ogg', 50, extrarange = SILENCED_SOUND_EXTRARANGE)
				breath_mask_rip()
				return
			if(epp) // Emergency Positive Pressure system forces respiration
				if(breather.losebreath > 0)
					if(!epp_active)
						src.visible_message(SPAN_WARNING("\The [src] flashes a blue light, activating it's Emergency Positive Pressure system!"))
						playsound(breather, 'sound/machines/windowdoor.ogg', 50, extrarange = SILENCED_SOUND_EXTRARANGE)
						epp_active = TRUE
						update_icon()
					tank.distribute_pressure = safe_pressure_min // Constantly adjusts the pressure to keep up with the damage
					breather.losebreath = 0
					to_chat(breather, SPAN_NOTICE("You feel fresh air being pushed into your lungs."))
			update_icon()

/obj/machinery/iv_drip/proc/attached_process()
	if(attached)
		if(!attached.Adjacent(src))
			iv_rip()
			update_icon()
			return
		if(!beaker)
			return
		if(!attached.dna)
			return
		if((attached.mutations & NOCLONE))
			return
		if(attached.species.flags & NO_BLOOD)
			return

		if(mode) // Injecting
			if(beaker.reagents.total_volume > 0)
				beaker.reagents.trans_to_mob(attached, transfer_amount, CHEM_BLOOD)
				update_icon()
			if(toggle_stop) // Automatically detaches if the blood volume is at 100%
				if((beaker.reagents.has_reagent(/singleton/reagent/blood) || beaker.reagents.has_reagent(/singleton/reagent/saline)) && attached.get_blood_volume() >= 100)
					visible_message("\The <b>[src]</b> flashes a warning light, disengaging from [attached]'s [vein.name] automatically!")
					playsound(src, 'sound/machines/buzz-two.ogg', 100, extrarange = SILENCED_SOUND_EXTRARANGE)
					vein = null
					attached = null
					blood_message_sent = FALSE
					update_icon()
					return
		else // Taking
			var/amount = REAGENTS_FREE_SPACE(beaker.reagents)
			amount = min(amount, transfer_amount)
			if(amount == 0)
				if(world.time > last_full + 10 SECONDS)
					last_full = world.time
					visible_message("\The <b>[src]</b> pings.")
					playsound(src, 'sound/machines/ping.ogg', 100, extrarange = SILENCED_SOUND_EXTRARANGE)
				return
			if(attached.get_blood_volume() < 90 && !blood_message_sent)
				visible_message(SPAN_WARNING("\The <b>[src]</b> flashes a warning light!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 100, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
				blood_message_sent = TRUE
			if(blood_message_sent)
				if(world.time > last_warning + 5 SECONDS)
					last_warning = world.time
					visible_message(SPAN_WARNING("\The <b>[src]</b> flashes a warning light!"))
					playsound(src, 'sound/machines/buzz-two.ogg', 100, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
			if(attached.take_blood(beaker, amount))
				update_icon()

/obj/machinery/iv_drip/MouseDrop(over_object, src_location, over_location)
	..()
	if(use_check_and_message(usr))
		return
	if(isDrone(usr))
		return
	if(in_range(src, usr) && ishuman(over_object) && in_range(over_object, src))
		var/list/options = list(
			"IV drip" = image('icons/mob/screen/radial.dmi', "iv_drip"),
			"Breath mask" = image('icons/mob/screen/radial.dmi', "iv_mask"))
		var/chosen_action = show_radial_menu(usr, src, options, require_near = TRUE, radius = 42, tooltips = TRUE)
		if(!chosen_action)
			return
		switch(chosen_action)
			if("IV drip")
				if(attached)
					visible_message("[usr] detaches \the [src] from [attached]'s [vein.name].")
					vein = null
					attached = null
					blood_message_sent = FALSE
					update_icon()
					return
				attached = over_object
				vein = attached.get_organ(usr.zone_sel.selecting)
				var/checking = attached.can_inject(usr, TRUE, usr.zone_sel.selecting, armor_check)
				if(!checking)
					attached = null
					vein = null
					return
				if(armor_check)
					var/attach_time = attach_delay
					attach_time *= checking
					if(!do_mob(usr, attached, attach_time))
						to_chat(usr, SPAN_DANGER("Failed to insert \the [src]. You and [attached] must stay still!"))
						attached = null
						vein = null
						return
				visible_message("[usr][armor_check ? "" : " swiftly"] inserts \the [src] in \the [attached]'s [vein.name].")
				update_icon()
				return
			if("Breath mask")
				if(!breath_mask)
					to_chat(usr, SPAN_NOTICE("There is no breath mask installed into \the [src]!"))
					return
				if(breather)
					visible_message("[usr] removes [breather]'s mask.[valve_open ? " \The [tank]'s valve automatically closes." : ""]")
					breath_mask_rip()
					return
				breather = over_object
				if(!breather.organs_by_name[BP_HEAD])
					to_chat(usr, SPAN_WARNING("\The [breather] doesn't have a head!"))
					breather = null
					return
				if(!breather.check_has_mouth())
					to_chat(usr, SPAN_WARNING("\The [breather] doesn't have a mouth!"))
					breather = null
					return
				if(breather.head && (breather.head.body_parts_covered & FACE))
					to_chat(usr, SPAN_WARNING("You must remove \the [breather]'s [breather.head] first!"))
					breather = null
					return
				if(breather.wear_mask)
					to_chat(usr, SPAN_WARNING("You must remove \the [breather]'s [breather.wear_mask] first!"))
					breather = null
					return
				if(tank)
					tank_on()
				visible_message("<b>[usr]</b> secures the mask over \the <b>[breather]'s</b> face.")
				playsound(breather, 'sound/effects/buckle.ogg', 50, extrarange = SILENCED_SOUND_EXTRARANGE)
				breath_mask.forceMove(breather.loc)
				breather.equip_to_slot(breath_mask, slot_wear_mask)
				breather.update_inv_wear_mask()
				update_icon()
				tank_on()
				return

/obj/machinery/iv_drip/AltClick(mob/user)
	. = ..()
	if(use_check_and_message(user))
		return
	if(isDrone(user))
		return
	var/list/options = list(
		"Transfer Rate" = image('icons/mob/screen/radial.dmi', "radial_transrate"),
		"Remove Container" = image('icons/mob/screen/radial.dmi', "iv_beaker"),
		"Remove Tank" = image('icons/mob/screen/radial.dmi', "iv_tank"),
		"Remove Breath Mask" = image('icons/mob/screen/radial.dmi', "iv_mask"))
	var/chosen_action = show_radial_menu(user, src, options, require_near = TRUE, radius = 42, tooltips = TRUE)
	if(!chosen_action)
		return
	switch(chosen_action)
		if("Transfer Rate")
			transfer_rate()
		if("Remove Container")
			if(!beaker)
				to_chat(user, SPAN_NOTICE("There is no reagent container to remove."))
				return
			user.visible_message(SPAN_NOTICE("[user] removes \the [beaker] from \the [src]."), SPAN_NOTICE("You remove \the [beaker] from \the [src]."))
			beaker.forceMove(user.loc)
			user.put_in_hands(beaker)
			beaker = null
			update_icon()
		if("Remove Tank")
			if(!tank)
				to_chat(user, SPAN_NOTICE("There is no installed tank to remove."))
				return
			if(breather)
				to_chat(user, SPAN_NOTICE("You cannot remove \the [tank] if someone's wearing \the [breath_mask]!"))
				return
			if(!is_loose)
				to_chat(user, SPAN_NOTICE("You must loosen the nuts securing \the [tank] into place to remove it!"))
				return
			user.visible_message(SPAN_NOTICE("[user] removes \the [tank] from \the [src]."), SPAN_NOTICE("You remove \the [tank] from \the [src]."))
			tank.forceMove(user.loc)
			user.put_in_hands(tank)
			tank = null
			update_icon()
		if("Remove Breath Mask")
			if(!breath_mask)
				to_chat(user, SPAN_NOTICE("There is no installed mask to remove."))
				return
			if(breather)
				to_chat(user, SPAN_NOTICE("You cannot remove \the [breath_mask] if someone's wearing it!"))
				return
			user.visible_message(SPAN_NOTICE("[user] removes \the [breath_mask] from \the [src]."), SPAN_NOTICE("You remove \the [breath_mask] from the \the [src]."))
			breath_mask.forceMove(user.loc)
			user.put_in_hands(breath_mask)
			breath_mask = null
			update_icon()

/obj/machinery/iv_drip/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers/blood/ripped))
		to_chat(user, "You can't use a ripped bloodpack.")
		return TRUE
	if(is_type_in_list(attacking_item, accepted_containers))
		if(beaker)
			to_chat(user, "There is already a reagent container loaded!")
			return TRUE
		user.drop_from_inventory(attacking_item, src)
		beaker = attacking_item
		user.visible_message(SPAN_NOTICE("[user] attaches \the [attacking_item] to \the [src]."), SPAN_NOTICE("You attach \the [attacking_item] to \the [src]."))
		update_icon()
		return TRUE
	if(istype(attacking_item, /obj/item/clothing/mask/breath))
		if(is_type_in_list(attacking_item, mask_blacklist))
			to_chat(user, "\The [attacking_item] is incompatible with \the [src].")
			return TRUE
		if(breath_mask)
			to_chat(user, "There is already a mask installed.")
			return TRUE
		user.drop_from_inventory(attacking_item, src)
		breath_mask = attacking_item
		user.visible_message(SPAN_NOTICE("[user] places \the [attacking_item] in \the [src]."), SPAN_NOTICE("You place \the [attacking_item] in \the [src]."))
		update_icon()
		return TRUE
	if(istype(attacking_item, /obj/item/tank))
		if(is_type_in_list(attacking_item, tank_blacklist))
			to_chat(user, "\The [attacking_item] is incompatible with \the [src].")
			return TRUE
		if(tank)
			to_chat(user, "There is already a tank installed!")
			return TRUE
		if(istype(attacking_item, /obj/item/tank/phoron))
			if(tipped)
				to_chat(user, "You're not sure how to place \the [attacking_item] in the fallen [src].")
				return TRUE
		user.drop_from_inventory(attacking_item, src)
		tank = attacking_item
		user.visible_message(SPAN_NOTICE("[user] places \the [attacking_item] in \the [src]."), SPAN_NOTICE("You place \the [attacking_item] in \the [src]."))
		update_icon()
		return TRUE
	if(attacking_item.iswrench())
		if(!tank)
			to_chat(user, "There isn't a tank installed for you to secure!")
			return TRUE
		if(tank_type == "phoron")
			to_chat(user, "You can't properly secure this type of tank to \the [src]!")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("[user] [is_loose ? "tightens" : "loosens"] the nuts on [src]."),
			SPAN_NOTICE("You [is_loose ? "tighten" : "loosen"] the nuts on [src], [is_loose ? "securing \the [tank]" : "allowing \the [tank] to be removed"]."))
		playsound(src.loc, 'sound/items/wrench.ogg', 50, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)
		is_loose = !is_loose
		return TRUE
	if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE
	if(default_part_replacement(user, attacking_item))
		return TRUE
	return ..()

/obj/machinery/iv_drip/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/iv_drip/attack_hand(mob/user)
	if(use_check_and_message(user))
		return
	if(isDrone(user))
		return
	if(tipped)
		user.visible_message("<b>[user]</b> pulls \the [src] upright.", "You pull \the [src] upright.")
		icon_state = "iv_stand"
		tipped = FALSE
		animate(src, time = 3, transform = transform.Turn(-90), easing = SINE_EASING)
		update_icon()
		return
	if(user.a_intent == I_HURT)
		user.visible_message("<b>[user]</b> knocks \the [src] down!", "You knock \the [src] down!")
		do_crash()
		return
	var/list/options = list(
		"Transfer Rate" = image('icons/mob/screen/radial.dmi', "radial_transrate"),
		"Toggle Mode" = image('icons/mob/screen/radial.dmi', "iv_mode"),
		"Toggle Stop" = image('icons/mob/screen/radial.dmi', "iv_stop"),
		"Toggle Valve" = image('icons/mob/screen/radial.dmi', "iv_valve"),
		"Toggle EPP" = image('icons/mob/screen/radial.dmi', "iv_epp"))
	var/chosen_action = show_radial_menu(user, src, options, require_near = TRUE, radius = 42, tooltips = TRUE)
	if(!chosen_action)
		return
	switch(chosen_action)
		if("Transfer Rate")
			transfer_rate()
		if("Toggle Mode")
			toggle_mode()
		if("Toggle Stop")
			toggle_stop()
		if("Toggle Valve")
			toggle_valve()
		if("Toggle EPP")
			toggle_epp()

/obj/machinery/iv_drip/proc/do_crash()
	cut_overlays()
	visible_message(SPAN_WARNING("\The [src] falls over with a buzz, spilling out it's contents!"))
	flick("iv_crash[is_loose ? "" : "_tank_[tank_type]"]", src)
	playsound(src, 'sound/effects/table_slam.ogg', 50, extrarange = MEDIUM_RANGE_SOUND_EXTRARANGE)
	spill()
	tipped = TRUE
	animate(src, time = 5, transform = transform.Turn(90), easing = BOUNCE_EASING)
	update_icon()

/obj/machinery/iv_drip/proc/spill()
	var/turf/dropspot = get_turf(src)
	if(breath_mask)
		if(!breather)
			breath_mask.forceMove(dropspot)
			breath_mask.tumble(rand(1,3))
			breath_mask.SpinAnimation(4, 2)
			breath_mask = null
		else
			src.visible_message(SPAN_WARNING("\The [breath_mask] snaps away from \the [breather], retracting back into \the [src]!"), SPAN_WARNING("\The [breath_mask] snaps away from you, retracting back into \the [src]!"))
			breath_mask_rip()
	if(beaker)
		beaker.forceMove(dropspot)
		beaker.tumble(rand(1,3))
		beaker.SpinAnimation(4, 2)
		beaker = null
	if(attached)
		iv_rip()
	if(tank)
		if(is_loose)
			tank.forceMove(dropspot)
			tank.tumble(rand(1,2))
			tank.SpinAnimation(4, 2)
			tank = null
			tank_type = null
			if(breather)
				if(breather.internals)
					breather.internals.icon_state = "internal0"
				breather.internal = null
				valve_open = FALSE
				tank_active = FALSE
				epp_active = FALSE
		else
			src.visible_message("\The [tank] rattles, but remains firmly secured to \the [src].")

/obj/machinery/iv_drip/proc/iv_rip()
	attached.visible_message(SPAN_WARNING("The needle is ripped out of [attached]'s [vein.name]."), SPAN_DANGER("The needle <B>painfully</B> rips out of your [vein.name]."))
	vein.take_damage(brute = 5, damage_flags = DAMAGE_FLAG_SHARP)
	vein = null
	attached = null

/obj/machinery/iv_drip/proc/breath_mask_rip()
	if(valve_open)
		tank_off()
	if(breath_mask.hanging)
		breath_mask.hanging = FALSE
		breath_mask.adjust_sprites()
	if(breath_mask.loc != breather)
		var/loc_check = breath_mask.loc
		if(ismob(loc_check))
			var/mob/living/carbon/human/holder = loc_check
			holder.remove_from_mob(breath_mask)
			holder.update_inv_wear_mask()
			holder.update_inv_l_hand()
			holder.update_inv_r_hand()
		breath_mask.forceMove(src)
		breather = null
		update_icon()
		return
	breather.remove_from_mob(breath_mask)
	breather.update_inv_wear_mask()
	breath_mask.forceMove(src)
	breather = null
	update_icon()

/obj/machinery/iv_drip/proc/tank_on()
	playsound(src, 'sound/effects/internals.ogg', 100, extrarange = SILENCED_SOUND_EXTRARANGE)
	tank.forceMove(breather)
	breather.internal = tank
	if(breather.internals)
		breather.internals.icon_state = "internal1"
	valve_open = TRUE
	update_icon()
	return

/obj/machinery/iv_drip/proc/tank_off()
	playsound(src, 'sound/effects/internals.ogg', 100, extrarange = SILENCED_SOUND_EXTRARANGE)
	tank.forceMove(src)
	if(breather.internals)
		breather.internals.icon_state = "internal0"
	breather.internal = null
	tank_active = FALSE
	valve_open = FALSE
	epp_active = FALSE
	update_icon()

/obj/machinery/iv_drip/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Mode"
	set src in view(1)

	if(use_check_and_message(usr))
		return
	mode = !mode
	usr.visible_message("<b>[usr]</b> toggles \the [src] to [mode ? "inject" : "take blood"].", SPAN_NOTICE("You set \the [src] to [mode ? "injecting" : "taking blood"]."))
	playsound(usr, 'sound/machines/buttonbeep.ogg', 50, extrarange = SILENCED_SOUND_EXTRARANGE)
	update_icon()

/obj/machinery/iv_drip/verb/toggle_stop()
	set category = "Object"
	set name = "Toggle Stop"
	set src in view(1)

	if(use_check_and_message(usr))
		return
	toggle_stop = !toggle_stop
	usr.visible_message("<b>[usr]</b> toggles \the [src]'s automatic stop mode [toggle_stop ? "on" : "off"].", SPAN_NOTICE("You toggle \the [src]'s automatic stop mode [toggle_stop ? "on" : "off"]."))
	playsound(usr, 'sound/machines/click.ogg', 50, extrarange = SILENCED_SOUND_EXTRARANGE)

/obj/machinery/iv_drip/verb/toggle_valve()
	set category = "Object"
	set name = "Toggle Valve"
	set src in view(1)

	if(use_check_and_message(usr))
		return
	if(!tank)
		to_chat(usr, SPAN_NOTICE("There is no tank for you to open the valve of!"))
		return
	if(!breather)
		to_chat(usr, SPAN_NOTICE("There is no one wearing \the [src]'s [breath_mask] for you to open the valve for!"))
		return

	if(!valve_open)
		usr.visible_message("<b>[usr]</b> opens \the [tank]'s valve.", SPAN_NOTICE("You open \the [tank]'s valve."))
		tank_on()
		return
	if(valve_open)
		if(epp_active)
			var/response = alert(usr, "Are you sure you want to close \the [tank]'s valve? The Emergency Positive Pressure system is currently active!", "Toggle Valve", "Yes", "No")
			if(response == "No")
				return
			epp_active = FALSE
		usr.visible_message("<b>[usr]</b> closes \the [tank]'s valve.", SPAN_NOTICE("You close \the [tank]'s valve."))
		tank_off()
		return

/obj/machinery/iv_drip/verb/toggle_epp()
	set category = "Object"
	set name = "Toggle EPP"
	set src in view(1)

	if(use_check_and_message(usr))
		return
	if(epp_active)
		var/response = alert(usr, "Are you sure you want to turn off the Emergency Positive Pressure system? It is currently active!", "Toggle EPP", "Yes", "No")
		if(response == "No")
			return
		epp_active = FALSE
		update_icon()
	epp = !epp
	usr.visible_message("<b>[usr]</b> toggles \the [src]'s Emergency Positive Pressure system [epp ? "on" : "off"].", SPAN_NOTICE("You toggle \the [src]'s Emergency Positive Pressure system [epp ? "on" : "off"]."))
	playsound(usr, 'sound/machines/click.ogg', 50, extrarange = SILENCED_SOUND_EXTRARANGE)

/obj/machinery/iv_drip/verb/transfer_rate()
	set category = "Object"
	set name = "Set Transfer Rate"
	set src in view(1)

	if(use_check_and_message(usr))
		return
	set_rate:
		var/amount = tgui_input_number(usr, "Set the IV drip's transfer rate.", "IV Drip", transfer_amount, transfer_limit, 0.001, round_value = FALSE)
		if(!amount)
			return
		if ((0.001 > amount || amount > transfer_limit) && amount != 0)
			to_chat(usr, SPAN_WARNING("Entered value must be between 0.001 and [transfer_limit]."))
			goto set_rate
		if (transfer_amount == 0)
			transfer_amount = REM
			return
		transfer_amount = amount
		to_chat(usr, SPAN_NOTICE("Transfer rate set to [src.transfer_amount] u/sec."))

/obj/machinery/iv_drip/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance > 2)
		return
	. += SPAN_NOTICE("[src] is [mode ? "injecting" : "taking blood"] at a rate of [src.transfer_amount] u/sec, the automatic injection stop mode is [toggle_stop ? "on" : "off"]. The Emergency Positive Pressure \
	system is [epp ? "on" : "off"].")
	if(attached)
		. += SPAN_NOTICE("\The [src] is attached to [attached]'s [vein.name].")
	if(beaker)
		if(LAZYLEN(beaker.reagents.reagent_volumes))
			. += SPAN_NOTICE("Attached is [icon2html(beaker, user)] \a [beaker] with [adv_scan ? "[beaker.reagents.total_volume] units of primarily [beaker.reagents.get_primary_reagent_name()]" : "some liquid"].")
		else
			. += SPAN_NOTICE("Attached is [icon2html(beaker, user)] \a [beaker]. It is empty.")
	else
		. += SPAN_NOTICE("No chemicals are attached.")
	if(tank)
		. += SPAN_NOTICE("Installed is [icon2html(tank, user)] [is_loose ? "\a [tank] sitting loose" : "\a [tank] secured"] on the stand. The meter shows [round(tank.air_contents.return_pressure())]kPa, \
		with the pressure set to [round(tank.distribute_pressure)]kPa. The valve is [valve_open ? "open" : "closed"].")
	else
		. += SPAN_NOTICE("No gas tank installed.")
	if(breath_mask)
		. += SPAN_NOTICE("\The [src] has [icon2html(breath_mask, user)] \a [breath_mask] installed. [breather ? breather : "No one"] is wearing it.")
	else
		. += SPAN_NOTICE("No breath mask installed.")

/obj/machinery/iv_drip/RefreshParts()
	..()
	var/manip = 0
	var/scanner = 0
	adv_scan = FALSE
	armor_check = TRUE
	transfer_limit = 4
	for(var/obj/item/stock_parts/P in component_parts)
		if(ismanipulator(P))
			manip += P.rating
			transfer_limit += P.rating
		if(isscanner(P))
			scanner += P.rating
	if(manip >= 2)
		armor_check = FALSE
	if(scanner >= 2)
		adv_scan = TRUE
