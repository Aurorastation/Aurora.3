/obj/machinery/iv_drip
	name = "\improper IV drip"
	desc = "A professional standard intravenous stand with supplemental gas support for medical use."
	desc_info = "IV drips can be supplied beakers/bloodpacks for reagent transfusions, as well as one breath mask and gas tank for supplemental gas therapy. \
	<br>Click and Drag to attach/detach the IV or secure/remove the breath mask on your target. <br>Click the stand with an empty hand to toggle between \
	various modes. Using a wrench when it has a tank installed will secure it. It can be upgraded.<br>Alt Click the stand to remove items contained in the stand."
	icon = 'icons/obj/iv_drip.dmi'
	icon_state = "iv_stand"
	anchored = 0
	density = FALSE
	var/tipped = FALSE
	var/last_creak // Spam check
	var/last_full
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

	var/list/mask_blacklist = list(
		/obj/item/clothing/mask/breath/vaurca,
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
	STOP_PROCESSING(SSprocessing, src)
	if(attached)
		attached = null
		vein = null
	QDEL_NULL(beaker)
	if(breather)
		if(valve_open)
			tank_off()
		breather.remove_from_mob(breath_mask)
		breath_mask.forceMove(src)
		breather = null
	QDEL_NULL(breath_mask)
	QDEL_NULL(tank)
	return ..()

/obj/machinery/iv_drip/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(height && istype(mover) && mover.checkpass(PASSTABLE)) //allow bullets, beams, thrown objects, rats, drones, and the like through.
		return 1
	return ..()

/obj/machinery/iv_drip/Crossed(var/mob/H)
	if(ishuman(H))
		var/mob/living/carbon/human/M = H
		if(M.shoes?.item_flags & LIGHTSTEP)
			return
		if(tipped)
			if(M.m_intent == M_RUN && M.a_intent == I_HURT)
				if(breath_mask)
					if(prob(60))
						if(breather)
							src.visible_message(
								SPAN_WARNING("[M] trips on \the [src]'s [breath_mask] cable, pulling \the [breather] down as well!"),
								SPAN_WARNING("You trip on \the [src]'s [breath_mask] cable, pulling \the [breather] down as well!"))
							shake_animation(4)
							M.Weaken(3)
							breather.forceMove(src.loc)
							breather.Weaken(4)
							return
						src.visible_message(SPAN_WARNING("[M] trips on \the [src]'s [breath_mask] cable!"), SPAN_WARNING("You trip on \the [src]'s [breath_mask] cable!"))
						breath_mask.forceMove(src.loc)
						breath_mask = null
						shake_animation(4)
						M.Weaken(4)
						update_icon()
						return
					src.visible_message(SPAN_WARNING("[M] barely avoids tripping on \the [src]'s [breath_mask] cable."), SPAN_WARNING("You barely avoid tripping on \the [src]'s [breath_mask] cable."))
					shake_animation(2)
					return
				if(prob(25))
					src.visible_message(SPAN_WARNING("[M] trips on \the [src]!"), SPAN_WARNING("You trip on \the [src]!"))
					shake_animation(4)
					M.Weaken(3)
					return
				src.visible_message(SPAN_WARNING("[M] almost trips on \the [src]!"), SPAN_WARNING("You almost trip on \the [src]!"))
				shake_animation(2)
				return
		if(M.m_intent == M_RUN && M.a_intent == I_HURT)
			src.visible_message(SPAN_WARNING("[M] bumps into \the [src], knocking it over!"), SPAN_WARNING("You bump into \the [src], knocking it over!"))
			do_crash()
	return ..()

/obj/machinery/iv_drip/update_icon()
	cut_overlays()
	if(beaker)
		add_overlay("beaker[tipped ? "_tipped" : ""]")
		var/datum/reagents/reagents = beaker.reagents
		if(reagents?.total_volume)
			var/image/filling = image('icons/obj/iv_drip.dmi', src, "[tipped ? "tipped_" : ""]reagent")
			var/percent = round((reagents.total_volume / beaker.volume) * 100)
			switch(percent)
				if(0 to 9)		filling.icon_state = "[tipped ? "tipped_" : ""]reagent0"
				if(10 to 24) 	filling.icon_state = "[tipped ? "tipped_" : ""]reagent10"
				if(25 to 49)	filling.icon_state = "[tipped ? "tipped_" : ""]reagent25"
				if(50 to 74)	filling.icon_state = "[tipped ? "tipped_" : ""]reagent50"
				if(75 to 79)	filling.icon_state = "[tipped ? "tipped_" : ""]reagent75"
				if(80 to 90)	filling.icon_state = "[tipped ? "tipped_" : ""]reagent80"
				if(91 to INFINITY)	filling.icon_state = "[tipped ? "tipped_" : ""]reagent100"

			var/reagent_color = reagents.get_color()
			filling.icon += reagent_color
			add_overlay(filling)
		if(attached)
			add_overlay("iv_in[tipped ? "_tipped" : ""]")
			if(mode)
				add_overlay("light_green[tipped ? "_tipped" : ""]")
			else
				add_overlay("light_red[tipped ? "_tipped" : ""]")
			if(blood_message_sent)
				add_overlay("light_yellow[tipped ? "_tipped" : ""]")
		else
			add_overlay("iv_out[tipped ? "_tipped" : ""]")
	if(tank)
		if(istype(tank, /obj/item/tank/oxygen))
			tank_type = "oxy"
		else if(istype(tank, /obj/item/tank/anesthetic))
			tank_type = "anest"
		else if(istype(tank, /obj/item/tank/phoron))
			tank_type = "phoron"
		else
			tank_type = "other"
		add_overlay("tank_[tank_type][tipped ? "_tipped" : ""]")
		update_gauge()
	if(breath_mask)
		if(breather)
			add_overlay("mask_on[tipped ? "_tipped" : ""]")
		else
			add_overlay("mask_off[tipped ? "_tipped" : ""]")
		if(epp_active)
			add_overlay("light_blue[tipped ? "_tipped" : ""]")
	if(panel_open)
		add_overlay("panel_open[tipped ? "_tipped" : ""]")

/obj/machinery/iv_drip/proc/update_gauge()
	var/gauge_pressure = 0
	var/last_gauge_pressure
	if(tank.air_contents)
		gauge_pressure = tank.air_contents.return_pressure()
		if(gauge_pressure > TANK_IDEAL_PRESSURE)
			gauge_pressure = -1
		else
			gauge_pressure = round((gauge_pressure/TANK_IDEAL_PRESSURE)*tank.gauge_cap)
	if(gauge_pressure == last_gauge_pressure)
		return
	last_gauge_pressure = gauge_pressure
	add_overlay("[tank.gauge_icon][(gauge_pressure == -1) ? "overload" : gauge_pressure][tipped ? "_tipped" : ""]")

/obj/machinery/iv_drip/machinery_process()
	breather_process()
	attached_process()

/obj/machinery/iv_drip/proc/breather_process()
	if(breather)
		if(!tank)
			return
		if(breather.species.flags & NO_BREATHE)
			return

		if(!breather.Adjacent(src))
			step_to(src, get_turf(breather), 1)
			if(world.time > last_creak + 10 SECONDS)
				last_creak = world.time
				src.visible_message("\The [src]'s wheels creak as it slowly gets tugged towards [breather] by \the [breath_mask]'s cable.")
				playsound(src, 'sound/effects/roll.ogg', 50, 1)
				shake_animation(2)
			if(get_dist(src, breather) >= 2)
				src.visible_message("\The [src] jerks as \the [breath_mask]'s cable is pulled taut!", SPAN_WARNING("You feel \the [src] jerk as your [breath_mask]'s cable is pulled taut."))
				shake_animation(4)
				if(prob(40))
					do_crash()

		if(valve_open)
			var/obj/item/organ/internal/lungs/L = breather.internal_organs_by_name[BP_LUNGS]
			if(!L)
				src.visible_message(SPAN_NOTICE("\The [src] buzzes, automatically deactivating \the [tank]."))
				playsound(src, 'sound/machines/buzz-two.ogg', 50)
				tank_off()
				update_icon()
				return
			var/safe_pressure_min = breather.species.breath_pressure + 5
			safe_pressure_min *= 1 + rand(1,4) * L.damage/L.max_damage

			if(!tank_active) // Activates and sets the kPa to a safe pressure. This keeps from it constantly resetting itself
				tank.distribute_pressure = safe_pressure_min
				src.visible_message(SPAN_NOTICE("\The [src] chimes and adjusts \the [tank]'s release pressure"))
				playsound(src, 'sound/machines/chime.ogg', 50)
				tank_active = TRUE
			if(L.checking_rupture == FALSE) // Safely retracts in case the lungs are about to rupture
				src.visible_message(SPAN_WARNING("\The [src]'s flashes a warning light, automatically deactivating \the [tank] and retracting \the [breath_mask]."))
				playsound(src, 'sound/machines/twobeep.ogg', 50)
				breather.remove_from_mob(breath_mask)
				breather.update_inv_wear_mask()
				breath_mask.forceMove(src)
				breath_mask.canremove = TRUE
				breath_mask.adjustable = TRUE
				tank_off()
				update_icon()
				return
			if(tank.air_contents.return_pressure() == 0)
				src.visible_message(SPAN_WARNING("\The [src] buzzes and automatically closes the valve."))
				playsound(src, 'sound/machines/buzz-two.ogg', 50)
				tank_off()
				update_icon()
				return
			if(epp) // Emergency Positive Pressure system forces respiration
				if(breather.losebreath > 0)
					if(!epp_active)
						src.visible_message(SPAN_WARNING("\The [src] flashes a blue light, activating it's Emergency Positive Pressure system!"))
						playsound(breather, 'sound/machines/windowdoor.ogg', 50)
						epp_active = TRUE
						update_icon()
					tank.distribute_pressure = safe_pressure_min // Constantly adjusts the pressure to keep up with the damage
					breather.losebreath = 0
					to_chat(breather, SPAN_NOTICE("You feel fresh air being pushed into your lungs."))
			update_icon()

/obj/machinery/iv_drip/proc/attached_process()
	if(attached)
		if(!beaker)
			return
		if(!attached.dna)
			return
		if(NOCLONE in attached.mutations)
			return
		if(attached.species.flags & NO_BLOOD)
			return

		if(!attached.Adjacent(src))
			iv_rip()
			update_icon()
			return

		if(mode) // Injecting
			if(beaker.reagents.total_volume > 0)
				beaker.reagents.trans_to_mob(attached, transfer_amount, CHEM_BLOOD)
				update_icon()
			if(toggle_stop) // Automatically detaches if the blood volume is at 100%
				if((beaker.reagents.has_reagent(/decl/reagent/blood) || beaker.reagents.has_reagent(/decl/reagent/saline)) && attached.get_blood_volume() >= 100)
					visible_message("\The <b>[src]</b> flashes a warning light, disengaging from [attached] automatically!")
					playsound(src, 'sound/machines/buzz-two.ogg', 100)
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
					playsound(src, 'sound/machines/ping.ogg', 100)
				return
			if(attached.get_blood_volume() < 90 && !blood_message_sent)
				visible_message(SPAN_WARNING("\The <b>[src]</b> flashes a warning light!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 100)
				blood_message_sent = TRUE
			if(blood_message_sent)
				if(world.time > last_warning + 5 SECONDS)
					last_warning = world.time
					visible_message(SPAN_WARNING("\The <b>[src]</b> flashes a warning light!"))
					playsound(src, 'sound/machines/buzz-two.ogg', 100)
			if(attached.take_blood(beaker, amount))
				update_icon()

/obj/machinery/iv_drip/MouseDrop(over_object, src_location, over_location)
	..()
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
				visible_message("[usr][armor_check ? "" : "swiftly "] inserts \the [src] in \the [attached]'s [vein.name].")
				update_icon()
				return
			if("Breath mask")
				if(!breath_mask)
					to_chat(usr, SPAN_NOTICE("There is no breath mask installed into \the [src]!"))
					return
				if(breather)
					visible_message("[usr] removes [breather]'s mask.[valve_open ? " \The [tank]'s valve automatically closes." : ""]")
					breather.remove_from_mob(breath_mask)
					breather.update_inv_wear_mask()
					breath_mask.forceMove(src)
					breath_mask.canremove = TRUE
					breath_mask.adjustable = TRUE
					breath_mask.slowdown = 0
					breather = null
					if(valve_open)
						tank_off()
					update_icon()
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
				visible_message("<b>[usr]</b> secures the mask over \the <b>[breather]'s</b> face.")
				playsound(breather, 'sound/effects/buckle.ogg', 50)
				breath_mask.forceMove(breather.loc)
				breather.equip_to_slot(breath_mask, slot_wear_mask)
				breather.update_inv_wear_mask()
				breath_mask.canremove = FALSE
				breath_mask.adjustable = FALSE
				breath_mask.slowdown = 2
				update_icon()
				return

/obj/machinery/iv_drip/AltClick(mob/user)
	. = ..()
	var/list/options = list(
		"Transfer Rate" = image('icons/mob/screen/radial.dmi', "radial_transrate"),
		"Remove Container" = image('icons/mob/screen/radial.dmi', "iv_beaker"),
		"Remove Tank" = image('icons/mob/screen/radial.dmi', "iv_tank"),
		"Remove Breath Mask" = image('icons/mob/screen/radial.dmi', "iv_mask"))
	var/chosen_action = show_radial_menu(usr, src, options, require_near = TRUE, radius = 42, tooltips = TRUE)
	if(!chosen_action)
		return
	switch(chosen_action)
		if("Transfer Rate")
			transfer_rate()
		if("Remove Container")
			if(!beaker)
				to_chat(usr, SPAN_NOTICE("There is no reagent container to remove."))
				return
			usr.visible_message(SPAN_NOTICE("[usr] removes \the [beaker] from \the [src]."), SPAN_NOTICE("You remove \the [beaker] from \the [src]."))
			beaker.forceMove(usr.loc)
			usr.put_in_hands(beaker)
			beaker = null
			update_icon()
		if("Remove Tank")
			if(!tank)
				to_chat(usr, SPAN_NOTICE("There is no installed tank to remove."))
				return
			if(breather)
				to_chat(usr, SPAN_NOTICE("You cannot remove \the [tank] if someone's wearing the mask!"))
				return
			if(!is_loose)
				to_chat(usr, SPAN_NOTICE("You must loosen the nuts securing \the [tank] into place to remove it!"))
				return
			usr.visible_message(SPAN_NOTICE("[usr] removes \the [tank] from \the [src]."), SPAN_NOTICE("You remove \the [tank] from \the [src]."))
			tank.forceMove(usr.loc)
			usr.put_in_hands(tank)
			tank = null
			update_icon()
		if("Remove Breath Mask")
			if(!breath_mask)
				to_chat(usr, SPAN_NOTICE("There is no installed mask to remove."))
				return
			if(breather)
				to_chat(usr, SPAN_NOTICE("You cannot remove \the [breath_mask] if someone's wearing it!"))
				return
			usr.visible_message(SPAN_NOTICE("[usr] removes \the [breath_mask] from \the [src]."), SPAN_NOTICE("You remove \the [breath_mask] from the \the [src]."))
			breath_mask.forceMove(usr.loc)
			usr.put_in_hands(breath_mask)
			breath_mask = null
			update_icon()

/obj/machinery/iv_drip/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/reagent_containers/blood/ripped))
		to_chat(user, "You can't use a ripped bloodpack.")
		return
	if(istype(W, /obj/item/reagent_containers))
		if(beaker)
			to_chat(user, "There is already a reagent container loaded!")
			return
		usr.drop_from_inventory(W, src)
		beaker = W
		usr.visible_message(SPAN_NOTICE("[usr] attaches \the [W] to \the [src]."), SPAN_NOTICE("You attach \the [W] to \the [src]."))
		update_icon()
		return
	if(istype(W, /obj/item/clothing/mask/breath))
		if(is_type_in_list(W, mask_blacklist))
			to_chat(usr, "\The [W] is incompatible with \the [src].")
			return
		if(breath_mask)
			to_chat(usr, "There is already a mask installed.")
			return
		usr.drop_from_inventory(W, src)
		breath_mask = W
		usr.visible_message(SPAN_NOTICE("[usr] places \the [W] in \the [src]."), SPAN_NOTICE("You place \the [W] in \the [src]."))
		update_icon()
		return
	if(istype(W, /obj/item/tank))
		if(is_type_in_list(W, tank_blacklist))
			to_chat(usr, "\The [W] is incompatible with \the [src].")
			return
		if(tank)
			to_chat(usr, "There is already a tank installed!")
			return
		if(istype(W, /obj/item/tank/phoron))
			if(tipped)
				to_chat(usr, "You're not sure how to place \the [W] in the fallen [src].")
				return
		usr.drop_from_inventory(W, src)
		tank = W
		usr.visible_message(SPAN_NOTICE("[usr] places \the [W] in \the [src]."), SPAN_NOTICE("You place \the [W] in \the [src]."))
		update_icon()
		return
	if(W.iswrench())
		if(!tank)
			to_chat(usr, "There isn't a tank installed for you to secure!")
			return
		if(tank_type == "phoron")
			to_chat(usr, "You can't properly secure this type of tank to \the [src]!")
			return
		usr.visible_message(
			SPAN_NOTICE("[usr] [is_loose ? "tightens" : "loosens"] the nuts on [src]."),
			SPAN_NOTICE("You [is_loose ? "tighten" : "loosen"] the nuts on [src], [is_loose ? "securing \the [tank]" : "allowing \the [tank] to be removed"]."))
		playsound(src.loc, "sound/items/wrench.ogg", 50, 1)
		is_loose = !is_loose
		return
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_part_replacement(user, W))
		return
	return ..()

/obj/machinery/iv_drip/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/iv_drip/attack_hand(mob/user as mob)
	if(tipped)
		usr.visible_message("<b>[usr]</b> pulls \the [src] upright.", "You pull \the [src] upright.")
		icon_state = "iv_stand"
		tipped = FALSE
		update_icon()
		return
	if(user.a_intent == I_HURT)
		usr.visible_message("<b>[usr]</b> knocks \the [src] down!", "You knock \the [src] down!")
		do_crash()
		return
	var/list/options = list(
		"Transfer Rate" = image('icons/mob/screen/radial.dmi', "radial_transrate"),
		"Toggle Mode" = image('icons/mob/screen/radial.dmi', "iv_mode"),
		"Toggle Stop" = image('icons/mob/screen/radial.dmi', "iv_stop"),
		"Toggle Valve" = image('icons/mob/screen/radial.dmi', "iv_valve"),
		"Toggle EPP" = image('icons/mob/screen/radial.dmi', "iv_epp"))
	var/chosen_action = show_radial_menu(usr, src, options, require_near = TRUE, radius = 42, tooltips = TRUE)
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
	playsound(src, 'sound/items/drop/prosthetic.ogg', 50)
	spill()
	tipped = TRUE
	icon_state = "iv_stand_tipped"
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
			src.visible_message(SPAN_WARNING("\The [breath_mask] pulls \the [breather] down with \the [src]!"), SPAN_WARNING("\The [breath_mask] pulls you down with \the [src]!"))
			breather.forceMove(dropspot)
			breather.Weaken(4)
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
		src.visible_message("\The [tank] rattles, but remains firmly secured to \the [src].")

/obj/machinery/iv_drip/proc/iv_rip()
	attached.visible_message(SPAN_WARNING("The needle is ripped out of [attached]'s [vein.name]."), SPAN_DANGER("The needle <B>painfully</B> rips out of your [vein.name]."))
	vein.take_damage(brute = 5, damage_flags = DAM_SHARP)
	vein = null
	attached = null

/obj/machinery/iv_drip/proc/tank_off()
	tank.forceMove(src)
	if(breather.internals)
		breather.internals.icon_state = "internal0"
	breather.internal = null
	tank_active = FALSE
	valve_open = FALSE
	epp_active = FALSE

/obj/machinery/iv_drip/proc/toggle_check()
	if(!ishuman(usr) && !issilicon(usr))
		to_chat(usr, SPAN_WARNING("This mob cannot operate the controls!"))
		return
	if(usr.stat || usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You are in no shape to do this."))
		return
	if(!usr.Adjacent(src))
		to_chat(usr, SPAN_WARNING("You must get closer to \the [src] to do that!"))
		return
	return TRUE

/obj/machinery/iv_drip/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Mode"
	set src in view(1)

	if(!toggle_check())
		return
	mode = !mode
	usr.visible_message("<b>[usr]</b> toggles \the [src] to [mode ? "inject" : "take blood"].", SPAN_NOTICE("You set \the [src] to [mode ? "injecting" : "taking blood"]."))
	playsound(usr, 'sound/machines/buttonbeep.ogg', 50)
	update_icon()

/obj/machinery/iv_drip/verb/toggle_stop()
	set category = "Object"
	set name = "Toggle Stop"
	set src in view(1)

	if(!toggle_check())
		return
	toggle_stop = !toggle_stop
	usr.visible_message("<b>[usr]</b> toggles \the [src]'s automatic stop mode [toggle_stop ? "on" : "off"].", SPAN_NOTICE("You toggle \the [src]'s automatic stop mode [toggle_stop ? "on" : "off"]."))
	playsound(usr, 'sound/machines/click.ogg', 50)

/obj/machinery/iv_drip/verb/toggle_valve()
	set category = "Object"
	set name = "Toggle Valve"
	set src in view(1)

	if(!toggle_check())
		return
	if(!tank)
		to_chat(usr, SPAN_NOTICE("There is no tank for you to open the valve of!"))
		return
	if(!breather)
		to_chat(usr, SPAN_NOTICE("There is no one with \the [src]'s mask for you to open the valve!"))
		return

	if(!valve_open)
		usr.visible_message("<b>[usr]</b> opens \the [tank]'s valve.", SPAN_NOTICE("You open \the [tank]'s valve."))
		playsound(src, 'sound/effects/internals.ogg', 100)
		tank.forceMove(breather)
		breather.internal = tank
		if(breather.internals)
			breather.internals.icon_state = "internal1"
		valve_open = TRUE
		update_icon()
		return
	if(epp_active)
		var/response = alert(usr, "Are you sure you want to close \the [tank]'s valve? The Emergency Positive Pressure system is currently active!", "Toggle Valve", "Yes", "No")
		if(response == "No")
			return
		epp_active = FALSE
	usr.visible_message("<b>[usr]</b> closes \the [tank]'s valve.", SPAN_NOTICE("You close \the [tank]'s valve."))
	playsound(src, 'sound/effects/internals.ogg', 100)
	tank_off()
	update_icon()

/obj/machinery/iv_drip/verb/toggle_epp()
	set category = "Object"
	set name = "Toggle EPP"
	set src in view(1)

	if(!toggle_check())
		return
	if(epp_active)
		var/response = alert(usr, "Are you sure you want to turn off the Emergency Positive Pressure system? It is currently active!", "Toggle EPP", "Yes", "No")
		if(response == "No")
			return
		epp_active = FALSE
	epp = !epp
	usr.visible_message("<b>[usr]</b> toggles \the [src]'s Emergency Positive Pressure system [epp ? "on" : "off"].", SPAN_NOTICE("You toggle \the [src]'s Emergency Positive Pressure system [epp ? "on" : "off"]."))
	playsound(usr, 'sound/machines/click.ogg', 50)

/obj/machinery/iv_drip/verb/transfer_rate()
	set category = "Object"
	set name = "Set Transfer Rate"
	set src in view(1)

	if(!toggle_check())
		return
	set_rate:
		var/amount = input("Set transfer rate as u/sec (between [transfer_limit] and 0.001)") as num
		if ((0.001 > amount || amount > transfer_limit) && amount != 0)
			to_chat(usr, SPAN_WARNING("Entered value must be between 0.001 and [transfer_limit]."))
			goto set_rate
		if (transfer_amount == 0)
			transfer_amount = REM
			return
		transfer_amount = amount
		to_chat(usr, SPAN_NOTICE("Transfer rate set to [src.transfer_amount] u/sec"))

/obj/machinery/iv_drip/examine(mob/user)
	..(user)
	if (!(user in viewers(2, src)))
		return
	to_chat(user, SPAN_NOTICE("[src] is [mode ? "injecting" : "taking blood"] at a rate of [src.transfer_amount] u/sec, and the automatic injection stop mode is [toggle_stop ? "on" : "off"]."))
	to_chat(user, SPAN_NOTICE("\The [src] [attached ? "is attached to [attached]'s [vein.name]" : "has no one attached"]."))
	if(beaker)
		if(LAZYLEN(beaker.reagents.reagent_volumes))
			to_chat(user, SPAN_NOTICE("Attached is [icon2html(beaker, usr)] \a [beaker] with [adv_scan ? "[beaker.reagents.total_volume] units of primarily [beaker.reagents.get_primary_reagent_name()]" : "some liquid"]."))
		else
			to_chat(user, SPAN_NOTICE("Attached is [icon2html(beaker, usr)] \a [beaker]. It is empty."))
	else
		to_chat(user, SPAN_NOTICE("No chemicals are attached."))
	if(tank)
		to_chat(user, SPAN_NOTICE("Installed is [icon2html(tank, usr)] [is_loose ? "\a [tank] sitting loose" : "\a [tank] secured"] on the stand. The meter shows [round(tank.air_contents.return_pressure())]kPa, \
		with the pressure set to [tank.distribute_pressure]kPa. The valve is [valve_open ? "open" : "closed"]."))
	else
		to_chat(user, SPAN_NOTICE("No gas tank installed."))
	if(breath_mask)
		to_chat(user, SPAN_NOTICE("\The [src] has [icon2html(breath_mask, usr)] \a [breath_mask] installed. [breather ? breather : "No one"] is wearing it."))
	else
		to_chat(user, SPAN_NOTICE("No breath mask installed."))

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
