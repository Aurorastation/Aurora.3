/obj/machinery/ecmo
	name = "\improper ECMO"
	desc = "An Extra-Corporeal Membrane Oxygenator."
	desc_info = "ECMO must be supplied with a blood pack and an oxygen tank."
	icon = 'icons/obj/ecmo.dmi'
	icon_state = "ecmo_stand"
	anchored = 0
	density = FALSE
	var/tipped = FALSE
	var/last_full // Spam check
	var/last_warning

	// Blood Stuff
	var/mob/living/carbon/human/attached = null
	var/obj/item/organ/external/vein = null
	var/obj/item/organ/external/artery = null
	var/obj/item/reagent_containers/beaker = null
	var/transfer_amount = 5
	var/transfer_limit = 10
	var/brain_damage_pinner = 140 // Brain damage amount to keep the patient at/above
	var/rip_vein_damage = 30 // The damage to apply to the vein (and currently artery too) when the vein or the artery line are ripped out
	var/list/artery_line_valid_targets = list("groin", "chest")
	var/blood_message_sent = FALSE
	var/attach_delay = 5
	var/armor_check = TRUE
	var/adv_scan = FALSE

	// Supplemental Gas Stuff
	var/mob/living/carbon/human/breather = null
	var/obj/item/clothing/mask/breath/breath_mask = null
	var/obj/item/tank/tank = null
	var/is_loose = TRUE
	var/list/tank_blacklist = list(/obj/item/tank/emergency_oxygen, /obj/item/tank/jetpack)
	var/valve_open = FALSE
	var/tank_active = FALSE

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

/obj/machinery/ecmo/Destroy()
	if(attached)
		attached = null
		vein = null
	QDEL_NULL(beaker)
	if(breather)
		breath_mask_rip()
	QDEL_NULL(breath_mask)
	QDEL_NULL(tank)
	return ..()

/obj/machinery/ecmo/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(height && istype(mover) && mover.checkpass(PASSTABLE)) //allow bullets, beams, thrown objects, rats, drones, and the like through.
		return 1
	return ..()

/obj/machinery/ecmo/Crossed(var/mob/H)
	if(ishuman(H))
		var/mob/living/carbon/human/M = H
		if(M.shoes?.item_flags & LIGHTSTEP)
			return
		if(M.incapacitated())
			return
		if(tipped)
			if(M.m_intent == M_RUN && M.a_intent == I_HURT)
				if(breath_mask)
					if(prob(60))
						if(breather)
							src.visible_message(
								SPAN_WARNING("[M] trips on \the [src]'s artery line, pulling it off from \the [breather]!"),
								SPAN_WARNING("You trip on \the [src]'s artery line, pulling it off from \the [breather]!"))
							shake_animation(4)
							M.Weaken(3)
							breath_mask_rip()
							return
						src.visible_message(SPAN_WARNING("[M] trips on \the [src]'s artery line!"), SPAN_WARNING("You trip on \the [src]'s artery line!"))
						breath_mask = null
						shake_animation(4)
						M.Weaken(4)
						update_icon()
						return
					src.visible_message(SPAN_WARNING("[M] barely avoids tripping on \the [src]'s artery line."), SPAN_WARNING("You barely avoid tripping on \the [src]'s artery line."))
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

/obj/machinery/ecmo/update_icon()
	cut_overlays()
	if(beaker)
		add_overlay("beaker[tipped ? "_tipped" : ""]")
		var/datum/reagents/reagents = beaker.reagents
		if(reagents?.total_volume)
			var/image/filling = image('icons/obj/iv_drip.dmi', src, "[tipped ? "tipped_" : ""]reagent")
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
			filling.icon_state = "[tipped ? "tipped_" : ""]reagent[fill_level]"
			var/reagent_color = reagents.get_color()
			filling.icon += reagent_color
			add_overlay(filling)
		if(attached)
			add_overlay("iv_in[tipped ? "_tipped" : ""]")

			if(attached.get_blood_volume() < 100)
				add_overlay("light_green[tipped ? "_tipped" : ""]")
			if(blood_message_sent)
				add_overlay("light_yellow[tipped ? "_tipped" : ""]")
		else
			add_overlay("iv_out[tipped ? "_tipped" : ""]")
	if(tank)
		add_overlay("tank_oxy[tipped ? "_tipped" : ""]")

		var/tank_level = 2
		switch(tank.percent())
			if(-INFINITY to 4)	tank_level = 0
			if(05 to 19)		tank_level = 1
			if(20 to 39)		tank_level = 2
			if(40 to 59)		tank_level = 3
			if(60 to 79)		tank_level = 4
			if(80 to 90)		tank_level = 5
			if(91 to INFINITY)	tank_level = 6
		add_overlay("[tank.gauge_icon][tank_level][tipped ? "_tipped" : ""]")
	if(breath_mask)
		if(breather)
			add_overlay("arterial_line_on[tipped ? "_tipped" : ""]")
		else
			add_overlay("arterial_line_off[tipped ? "_tipped" : ""]")
	if(panel_open)
		add_overlay("panel_open[tipped ? "_tipped" : ""]")

/obj/machinery/ecmo/process()
	breather_process()
	attached_process()

/obj/machinery/ecmo/proc/breather_process()
	if(breather)
		if(!breather.Adjacent(src))
			src.visible_message(SPAN_WARNING("\The artery line snaps back into \the [src]!"))
			breath_mask_rip()
			return
		if(!tank)
			return
		if(breather.species.flags & NO_BREATHE)
			return

		if(!vein)
			src.visible_message(SPAN_WARNING("The loop is open (no vein line), disconnecting the artery line!"))
			breath_mask_rip(TRUE)
			return

		if(valve_open && attached)
			var/obj/item/organ/internal/brain/B = breather.internal_organs_by_name[BP_BRAIN]
			var/obj/item/organ/internal/lungs/L = breather.internal_organs_by_name[BP_LUNGS]
			var/obj/item/organ/internal/heart/H = breather.internal_organs_by_name[BP_HEART]

			if(B.damage >= brain_damage_pinner && breather.get_brain_result())
				B.damage = brain_damage_pinner

			if(L.get_oxygen_deprivation() >= 70)
				L.remove_oxygen_deprivation(10)

			if(H.pulse <= PULSE_SLOW)
				H.pulse = PULSE_SLOW

			if(tank.air_contents.return_pressure() <= 300)
				src.visible_message(SPAN_WARNING("\The [src] buzzes, automatically closing the valve due to the lack of tank pressure."))
				playsound(src, 'sound/machines/buzz-two.ogg', 50)
				valve_open = FALSE
				return

			tank.remove_air(0.05) //Not sure what amount those things have, but the ECMO should consume a significant amount of air and must be balanced this way for the sense of urgency

			update_icon()

/obj/machinery/ecmo/proc/attached_process()
	if(attached)
		if(!attached.Adjacent(src))
			iv_rip()
			update_icon()
			return
		if(!beaker)
			return
		if(!attached.dna)
			return
		if(NOCLONE in attached.mutations)
			return
		if(attached.species.flags & NO_BLOOD)
			return

		if((beaker.reagents.has_reagent(/decl/reagent/blood) || beaker.reagents.has_reagent(/decl/reagent/saline)) && attached.get_blood_volume() >= 100) // Do not add blood if the blood volume is >= 100%
			update_icon()
		else
			if(beaker.reagents.total_volume > 0)
				beaker.reagents.trans_to_mob(attached, transfer_amount, CHEM_BLOOD)
				update_icon()

/obj/machinery/ecmo/MouseDrop(over_object, src_location, over_location)
	..()
	if(use_check_and_message(usr))
		return
	if(isDrone(usr))
		return
	if(in_range(src, usr) && ishuman(over_object) && in_range(over_object, src))
		var/list/options = list(
			"Vein Line" = image('icons/mob/screen/ecmo_radial.dmi', "vein"),
			"Artery Line" = image('icons/mob/screen/ecmo_radial.dmi', "artery"))
		var/chosen_action = show_radial_menu(usr, src, options, require_near = TRUE, radius = 42, tooltips = TRUE)
		if(!chosen_action)
			return
		switch(chosen_action)
			if("Vein Line")
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
			if("Artery Line")
				if(!breath_mask)
					to_chat(usr, SPAN_NOTICE("There is no artery line installed into \the [src]!"))
					return
				if(breather)
					visible_message("[usr] removes the artery line from [breather].[valve_open ? " \The [tank]'s valve automatically closes." : ""]")
					artery = null
					breath_mask_rip(TRUE)
					return

				if(!attached)
					to_chat(usr, SPAN_NOTICE("There is no vein line attached to [over_object]!"))
					return

				if(!(usr.zone_sel.selecting in artery_line_valid_targets))
					to_chat(usr, SPAN_NOTICE("It's not possible to cannulate in this location, aim for a bigger artery!"))
					return

				visible_message("<b>[usr]</b> starts to cannulate \the <b>[over_object]'s [usr.zone_sel.selecting]</b>.")
				if (do_after(usr, 60))
					breather = over_object
					artery = breather.get_organ(usr.zone_sel.selecting)

					visible_message("<b>[usr]</b> connects the artery line to \the <b>[breather]'s [artery]</b>.")
					playsound(breather, 'sound/effects/buckle.ogg', 50)
					update_icon()
					return

/obj/machinery/ecmo/AltClick(mob/user)
	. = ..()
	if(use_check_and_message(user))
		return
	if(isDrone(user))
		return
	var/list/options = list(
		"Infusion Rate" = image('icons/mob/screen/radial.dmi', "radial_transrate"),
		"Remove Container" = image('icons/mob/screen/ecmo_radial.dmi', "iv_beaker"),
		"Remove Tank" = image('icons/mob/screen/radial.dmi', "iv_tank"))
	var/chosen_action = show_radial_menu(user, src, options, require_near = TRUE, radius = 42, tooltips = TRUE)
	if(!chosen_action)
		return
	switch(chosen_action)
		if("Infusion Rate")
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
				to_chat(user, SPAN_NOTICE("You cannot remove \the [tank] if someone is canulated with the artery line!"))
				return
			if(!is_loose)
				to_chat(user, SPAN_NOTICE("You must loosen the nuts securing \the [tank] into place to remove it!"))
				return
			user.visible_message(SPAN_NOTICE("[user] removes \the [tank] from \the [src]."), SPAN_NOTICE("You remove \the [tank] from \the [src]."))
			tank.forceMove(user.loc)
			user.put_in_hands(tank)
			tank = null
			update_icon()


/obj/machinery/ecmo/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/reagent_containers))
		if(istype(W, /obj/item/reagent_containers/blood/ripped))
			to_chat(user, "You can't use a ripped bloodpack.")
			return TRUE
		if(istype(W, /obj/item/reagent_containers))
			if(beaker)
				to_chat(user, "There is already a reagent container loaded!")
				return TRUE
		if(!istype(W, /obj/item/reagent_containers/blood))
			to_chat(user, "The ECMO only accepts blood packs.")
			return TRUE
		user.drop_from_inventory(W, src)
		beaker = W
		user.visible_message(SPAN_NOTICE("[user] attaches \the [W] to \the [src]."), SPAN_NOTICE("You attach \the [W] to \the [src]."))
		update_icon()
		return TRUE
	if(istype(W, /obj/item/clothing/mask/breath))
		if(is_type_in_list(W, mask_blacklist))
			to_chat(user, "\The [W] is incompatible with \the [src].")
			return TRUE
		if(breath_mask)
			to_chat(user, "There is already an artery line installed.")
			return TRUE
		user.drop_from_inventory(W, src)
		breath_mask = W
		user.visible_message(SPAN_NOTICE("[user] places \the [W] in \the [src]."), SPAN_NOTICE("You place \the [W] in \the [src]."))
		update_icon()
		return TRUE
	if(istype(W, /obj/item/tank))
		if(is_type_in_list(W, tank_blacklist))
			to_chat(user, "\The [W] is incompatible with \the [src].")
			return TRUE
		if(tank)
			to_chat(user, "There is already a tank installed!")
			return TRUE
		if(!istype(W, /obj/item/tank/oxygen))
			to_chat(user, "The ECMO only accepts oxygen tanks.")
			return TRUE
		user.drop_from_inventory(W, src)
		tank = W
		user.visible_message(SPAN_NOTICE("[user] places \the [W] in \the [src]."), SPAN_NOTICE("You place \the [W] in \the [src]."))
		update_icon()
		return TRUE
	if(W.iswrench())
		if(!tank)
			to_chat(user, "There isn't a tank installed for you to secure!")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("[user] [is_loose ? "tightens" : "loosens"] the nuts on [src]."),
			SPAN_NOTICE("You [is_loose ? "tighten" : "loosen"] the nuts on [src], [is_loose ? "securing \the [tank]" : "allowing \the [tank] to be removed"]."))
		playsound(src.loc, "sound/items/wrench.ogg", 50, 1)
		is_loose = !is_loose
		return TRUE
	if(default_deconstruction_screwdriver(user, W))
		return TRUE
	if(default_part_replacement(user, W))
		return TRUE
	return ..()

/obj/machinery/ecmo/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/ecmo/attack_hand(mob/user)
	if(use_check_and_message(user))
		return
	if(isDrone(user))
		return
	if(tipped)
		user.visible_message("<b>[user]</b> pulls \the [src] upright.", "You pull \the [src] upright.")
		icon_state = "ecmo_stand"
		tipped = FALSE
		update_icon()
		return
	if(user.a_intent == I_HURT)
		user.visible_message("<b>[user]</b> knocks \the [src] down!", "You knock \the [src] down!")
		do_crash()
		return
	var/list/options = list(
		"Transfer Rate" = image('icons/mob/screen/radial.dmi', "radial_transrate"),
		"Toggle Valve" = image('icons/mob/screen/ecmo_radial.dmi', "iv_valve"))
	var/chosen_action = show_radial_menu(user, src, options, require_near = TRUE, radius = 42, tooltips = TRUE)
	if(!chosen_action)
		return
	switch(chosen_action)
		if("Transfer Rate")
			transfer_rate()
		if("Toggle Valve")
			toggle_valve()

/obj/machinery/ecmo/proc/do_crash()
	cut_overlays()
	visible_message(SPAN_WARNING("\The [src] falls over with a buzz, spilling out it's contents!"))
	flick("ecmo_crash[is_loose ? "" : "_tank_oxy"]", src)
	playsound(src, 'sound/items/drop/prosthetic.ogg', 50)
	spill()
	tipped = TRUE
	icon_state = "ecmo_stand_tipped"
	update_icon()

/obj/machinery/ecmo/proc/spill()
	var/turf/dropspot = get_turf(src)
	if(breath_mask)
		if(!breather)
			breath_mask.forceMove(dropspot)
			breath_mask.tumble(rand(1,3))
			breath_mask.SpinAnimation(4, 2)
			breath_mask = null
		else
			src.visible_message(SPAN_WARNING("The artery line is ripped out from [breather], retracting back into \the [src]!"), SPAN_WARNING("\The artery line rips out of you, retracting back into \the [src]!"))
			vein.take_damage(brute = rip_vein_damage, damage_flags = DAM_SHARP)
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
			if(breather)
				if(breather.internals)
					breather.internals.icon_state = "internal0"
				breather.internal = null
				valve_open = FALSE
				tank_active = FALSE
		else
			src.visible_message("\The [tank] rattles, but remains firmly secured to \the [src].")

/obj/machinery/ecmo/proc/iv_rip()
	attached.visible_message(SPAN_WARNING("The vein line is ripped out of [attached]'s [vein.name]."), SPAN_DANGER("The vein line <B>painfully</B> rips out of your [vein.name]."))
	vein.take_damage(brute = rip_vein_damage, damage_flags = DAM_SHARP)
	vein = null
	attached = null

/obj/machinery/ecmo/proc/breath_mask_rip(var/safe_ripped = FALSE)
	if(artery && !safe_ripped)
		artery.take_damage(brute = rip_vein_damage, damage_flags = DAM_SHARP)
	if(valve_open)
		tank_off()
	if(breath_mask.hanging)
		breath_mask.hanging = FALSE
		breath_mask.adjust_sprites()
	if(breath_mask.loc != breather)
		var/loc_check = breath_mask.loc
		if(ismob(loc_check))
			var/mob/living/carbon/human/holder = loc_check
			holder.update_inv_l_hand()
			holder.update_inv_r_hand()
		breather = null
		update_icon()
		return
	breather = null
	update_icon()

/obj/machinery/ecmo/proc/tank_off()
	tank.forceMove(src)
	if(breather.internals)
		breather.internals.icon_state = "internal0"
	breather.internal = null
	tank_active = FALSE
	valve_open = FALSE
	update_icon()

/obj/machinery/ecmo/verb/toggle_valve()
	set category = "Object"
	set name = "Toggle Valve"
	set src in view(1)

	if(use_check_and_message(usr))
		return
	if(!tank)
		to_chat(usr, SPAN_NOTICE("There is no tank for you to open the valve of!"))
		return
	if(!breather)
		to_chat(usr, SPAN_NOTICE("There is no one wearing \the [src]'s artery line, it would be pointless to start the membrane oxygenation!"))
		return

	if(!valve_open)
		usr.visible_message("<b>[usr]</b> opens \the [tank]'s valve.", SPAN_NOTICE("You open \the [tank]'s valve."))
		playsound(src, 'sound/effects/internals.ogg', 100)
		tank.forceMove(breather)
		breather.internal = tank
		if(breather.internals)
			breather.internals.icon_state = "internal1"
		valve_open = TRUE
		icon_state = "ecmo_running"
		update_icon()
		return

	usr.visible_message("<b>[usr]</b> closes \the [tank]'s valve.", SPAN_NOTICE("You close \the [tank]'s valve."))
	playsound(src, 'sound/effects/internals.ogg', 100)
	icon_state = "ecmo_stand"
	tank_off()

/obj/machinery/ecmo/verb/transfer_rate()
	set category = "Object"
	set name = "Set Transfer Rate"
	set src in view(1)

	if(use_check_and_message(usr))
		return
	set_rate:
		var/amount = input("Set infusion rate as u/sec (between [transfer_limit] and 0.001)") as num
		if ((0.001 > amount || amount > transfer_limit) && amount != 0)
			to_chat(usr, SPAN_WARNING("Entered value must be between 0.001 and [transfer_limit]."))
			goto set_rate
		if (transfer_amount == 0)
			transfer_amount = REM
			return
		transfer_amount = amount
		to_chat(usr, SPAN_NOTICE("Infusion rate set to [src.transfer_amount] u/sec"))

/obj/machinery/ecmo/examine(mob/user)
	..(user)
	if(!(user in viewers(2, src)))
		return
	to_chat(user, SPAN_NOTICE("[src] is transfusing at a rate of [src.transfer_amount] u/sec."))
	if(attached)
		to_chat(user, SPAN_NOTICE("\The [src] is attached to [attached]'s [vein.name]."))
	if(beaker)
		if(LAZYLEN(beaker.reagents.reagent_volumes))
			to_chat(user, SPAN_NOTICE("Attached is [icon2html(beaker, user)] \a [beaker] with [adv_scan ? "[beaker.reagents.total_volume] units of primarily [beaker.reagents.get_primary_reagent_name()]" : "some liquid"]."))
		else
			to_chat(user, SPAN_NOTICE("Attached is [icon2html(beaker, user)] \a [beaker]. It is empty."))
	else
		to_chat(user, SPAN_NOTICE("No chemicals are attached."))
	if(tank)
		to_chat(user, SPAN_NOTICE("Installed is [icon2html(tank, user)] [is_loose ? "\a [tank] sitting loose" : "\a [tank] secured"] on the stand. The meter shows [round(tank.air_contents.return_pressure())]kPa, \
		with the pressure set to [round(tank.distribute_pressure)]kPa. The valve is [valve_open ? "open" : "closed"]."))
	else
		to_chat(user, SPAN_NOTICE("No gas tank installed."))
	if(breath_mask)
		to_chat(user, SPAN_NOTICE("\The [src] has \an artery line installed. [breather ? breather : "No one"] has it attached."))
	else
		to_chat(user, SPAN_NOTICE("No artery line installed."))

/obj/machinery/ecmo/RefreshParts()
	..()
	var/manip = 0
	var/scanner = 0
	adv_scan = FALSE
	armor_check = TRUE
	transfer_limit = 9
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
