#define HEAT_CAPACITY_HUMAN 100 //249840 J/K, for a 72 kg person.

/obj/machinery/atmospherics/unary/cryo_cell
	name = "cryo cell"
	desc = "A cryogenic chamber that can freeze occupants while keeping them alive, preventing them from taking any further damage. It can be loaded with a chemical cocktail for various medical benefits."
	desc_info = "The cryogenic chamber, or 'cryo', treats most damage types, most notably genetic damage. It also stabilizes patients \
	in critical condition by placing them in stasis, so they can be treated at a later time.<br>\
	<br>\
	In order for it to work, it must be loaded with chemicals, and the temperature of the solution must reach a certain point. Additionally, it \
	requires a supply of pure oxygen, provided by canisters that are attached. The most commonly used chemicals in the chambers are Cryoxadone and \
	Clonexadone. Clonexadone is more effective in treating all damage, including Genetic damage, but is otherwise functionally identical.<br>\
	<br>\
	Activating the freezer nearby, and setting it to a temperature setting below 150, is recommended before operation! Further, any clothing the patient \
	is wearing that act as an insulator will reduce its effectiveness, and should be removed.<br>\
	<br>\
	Clicking the tube with a beaker full of chemicals in hand will place it in its storage to distribute when it is activated.<br>\
	<br>\
	Click your target with Grab intent, then click on the tube, with an empty hand, to place them in it. Click the tube again to open the menu. \
	Press the button on the menu to activate it. Once they have reached 100 health, right-click the cell and click 'Eject Occupant' to remove them. \
	Remember to turn it off, once you've finished, to save power and chemicals!"
	icon = 'icons/obj/cryogenics.dmi' // map only
	icon_state = "pod_preview"
	density = TRUE
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	interact_offline = TRUE
	z_flags = ZMM_MANGLE_PLANES

	var/on = 0
	idle_power_usage = 20
	active_power_usage = 200
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 30

	component_types = list(
		/obj/item/circuitboard/cryotube,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/console_screen,
		/obj/item/reagent_containers/glass/beaker/large
	)

	var/temperature_archived
	var/mob/living/carbon/human/occupant = null
	var/obj/item/reagent_containers/glass/beaker = null

	var/current_heat_capacity = 50

	var/temperature_warning_threshold = 170
	var/temperature_danger_threshold = T0C

	var/fast_stasis_mult = 0.6
	var/slow_stasis_mult = 1.7
	var/current_stasis_mult = 1

/obj/machinery/atmospherics/unary/cryo_cell/Initialize()
	. = ..()
	update_icon()
	atmos_init()

/obj/machinery/atmospherics/unary/cryo_cell/Destroy()
	var/turf/T = src.loc
	T.contents += contents
	if(beaker)
		beaker.forceMove(get_step(loc, SOUTH)) //Beaker is carefully ejected from the wreckage of the cryotube
		beaker = null
	return ..()

/obj/machinery/atmospherics/unary/cryo_cell/atmos_init()
	if(node) return
	var/node_connect = dir
	for(var/obj/machinery/atmospherics/target in get_step(src,node_connect))
		if(target.initialize_directions & get_dir(target,src))
			node = target
			break

/obj/machinery/atmospherics/unary/cryo_cell/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(is_adjacent)
		if(beaker)
			. += SPAN_NOTICE("It is loaded with a beaker.")
		if(occupant)
			occupant.examine(arglist(args))

	if(panel_open)
		. += "The maintenance hatch is open."

/obj/machinery/atmospherics/unary/cryo_cell/process()
	..()
	if(!node)
		return

	if(!on)
		return

	if(occupant)
		if(occupant.stat != 2)
			process_occupant()

	if(air_contents)
		temperature_archived = air_contents.temperature
		heat_gas_contents()
		expel_gas()

	if(abs(temperature_archived-air_contents.temperature) > 1)
		network.update = 1
		update_icon()

	return 1

/obj/machinery/atmospherics/unary/cryo_cell/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/atmospherics/unary/cryo_cell/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CryoTube", "Cryo Cell")
		ui.open()

/obj/machinery/atmospherics/unary/cryo_cell/ui_data(mob/user)
	var/list/data = list()
	data["isOperating"] = on
	data["hasOccupant"] = occupant ? TRUE : FALSE

	var/list/occupantData = list()
	if(occupant)
		occupantData["name"] = occupant.name
		var/displayed_stat = occupant.stat
		var/blood_oxygenation = occupant.get_blood_oxygenation()
		if((occupant.status_flags & FAKEDEATH))
			displayed_stat = DEAD
			blood_oxygenation = min(blood_oxygenation, BLOOD_VOLUME_SURVIVE)
		var/pulse_result
		if(occupant.should_have_organ(BP_HEART))
			var/obj/item/organ/internal/heart/heart = occupant.internal_organs_by_name[BP_HEART]
			if(!heart)
				pulse_result = 0
			else if(BP_IS_ROBOTIC(heart))
				pulse_result = -2
			else if(occupant.status_flags & FAKEDEATH)
				pulse_result = 0
			else
				pulse_result = occupant.get_pulse(GETPULSE_TOOL)
		else
			pulse_result = -1

		if(pulse_result == ">250")
			pulse_result = -3

		occupantData["stat"] = displayed_stat
		occupantData["bruteLoss"] = occupant.getBruteLoss()
		occupantData["cloneLoss"] = occupant.getCloneLoss()
		occupantData["bodyTemperature"] = occupant.bodytemperature
		occupantData["brainActivity"] = occupant.get_brain_result()
		occupantData["pulse"] = text2num(pulse_result)
		occupantData["cryostasis"] = occupant.stasis_value
		occupantData["bloodPressure"] = occupant.get_blood_pressure()
		occupantData["bloodPressureLevel"] = occupant.get_blood_pressure_alert()
		occupantData["bloodOxygenation"] = blood_oxygenation
	data["occupant"] = occupantData;

	data["cellTemperature"] = round(air_contents.temperature)
	data["cellTemperatureStatus"] = "good"
	if(air_contents.temperature >= temperature_danger_threshold)
		data["cellTemperatureStatus"] = "bad"
	else if(air_contents.temperature >= temperature_warning_threshold)
		data["cellTemperatureStatus"] = "average"

	data["isBeakerLoaded"] = beaker ? TRUE : FALSE
	data["beakerLabel"] = null
	data["beakerVolume"] = 0
	if(beaker)
		data["beakerLabel"] = beaker.label_text ? beaker.label_text : null
		for(var/_R in beaker.reagents.reagent_volumes)
			data["beakerVolume"] += REAGENT_VOLUME(beaker.reagents, _R)

	data["fastStasisMult"] = fast_stasis_mult
	data["slowStasisMult"] = slow_stasis_mult
	data["currentStasisMult"] = current_stasis_mult

	return data

/obj/machinery/atmospherics/unary/cryo_cell/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(usr == occupant)
		return

	. = TRUE

	switch(action)
		if("switchOn")
			on = TRUE
			update_icon()

		if("switchOff")
			on = FALSE
			update_icon()

		if("ejectBeaker")
			if(beaker)
				beaker.forceMove(get_step(loc, SOUTH))
				beaker = null

		if("ejectOccupant")
			if(!occupant || isslime(usr) || ispAI(usr))
				return
			move_eject()

		if("goFast")
			current_stasis_mult = fast_stasis_mult
			update_icon()

		if("goRegular")
			current_stasis_mult = 1
			update_icon()

		if("goSlow")
			current_stasis_mult = slow_stasis_mult
			update_icon()

		else
			return FALSE

	add_fingerprint(usr)

/obj/machinery/atmospherics/unary/cryo_cell/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers/glass))
		if(beaker)
			FEEDBACK_FAILURE(user, "A beaker is already loaded into the machine!")
			return TRUE

		beaker =  attacking_item
		user.drop_from_inventory(attacking_item,src)
		user.visible_message("[user] adds \a [attacking_item] to \the [src]!", "You add \a [attacking_item] to \the [src]!")
	else if(istype(attacking_item, /obj/item/grab))
		var/obj/item/grab/grab = attacking_item
		var/mob/living/L = grab.affecting

		if (!istype(L))
			return

		var/bucklestatus = L.bucklecheck(user)
		if(!bucklestatus)
			return TRUE

		user.visible_message(SPAN_NOTICE("[user] starts putting [L] into [src]."),
								SPAN_NOTICE("You start putting [L] into [src]."), range = 3)

		if(do_mob(user, L, 30, needhand = 0))
			for(var/mob/living/carbon/slime/M in range(1, L))
				if(M.victim == L)
					to_chat(user, SPAN_WARNING("[L] will not fit into the cryo because they have a slime latched onto their head."))
					return TRUE
			if(put_mob(L))
				user.visible_message(SPAN_NOTICE("[user] puts [L] into [src]."),
										SPAN_NOTICE("You put [L] into [src]."), range = 3)
				qdel(attacking_item)
				addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon)), 2.5 SECONDS)

	else if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE
	else if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	else if(default_part_replacement(user, attacking_item))
		return TRUE

	return TRUE

/obj/machinery/atmospherics/unary/cryo_cell/mouse_drop_receive(atom/dropped, mob/user, params)
	if(!istype(user))
		return
	if(!ismob(dropped))
		return
	var/mob/living/L = dropped
	for(var/mob/living/carbon/slime/M in range(1,L))
		if(M.victim == L)
			to_chat(usr, SPAN_WARNING("[L.name] will not fit into the cryo because they have a slime latched onto their head."))
			return

	var/bucklestatus = L.bucklecheck(user)
	if (!bucklestatus)
		return

	if(L == user)
		user.visible_message(SPAN_NOTICE("[user] starts climbing into [src]."),
								SPAN_NOTICE("<span class='notice'>You start climbing into [src]."), range = 3)

	else
		user.visible_message(SPAN_NOTICE("[user] starts putting [L] into the cryopod."),
								SPAN_NOTICE("<span class='notice'>You start putting [L] into [src]."), range = 3)

	if (do_mob(user, L, 30, needhand = 0))
		if (bucklestatus == 2)
			var/obj/structure/LB = L.buckled_to
			LB.user_unbuckle(user)
		if(put_mob(L))
			if(L == user)
				user.visible_message(SPAN_NOTICE("[user] climbs into [src]."),
										SPAN_NOTICE("<span class='notice'>You climb into [src]."), range = 3)

			else
				user.visible_message(SPAN_NOTICE("[user] puts [L] into [src]."),
										SPAN_NOTICE("<span class='notice'>You put [L] into [src]."), range = 3)

				if(user.pulling == L)
					user.pulling = null
			addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon)), 2.5 SECONDS)

/obj/machinery/atmospherics/unary/cryo_cell/update_icon(var/only_pickle = FALSE)
	ClearOverlays()
	icon_state = "pod[on]"

	var/image/I

	if(occupant)
		var/image/pickle = image(occupant.icon, occupant.icon_state)
		pickle.overlays = occupant.overlays
		pickle.pixel_z = 11
		AddOverlays(pickle)
		I = image(icon, "pod_over")
		AddOverlays(I)

	if(panel_open)
		AddOverlays("pod_panel")

	if(powered())
		var/warn_state = "off"
		if(on)
			warn_state = "safe"
			if(air_contents.temperature >= temperature_danger_threshold)
				warn_state = "danger"
			else if(air_contents.temperature >= temperature_warning_threshold)
				warn_state = "warn"
		I = overlay_image(icon, "lights_[warn_state]")
		AddOverlays(I)
		AddOverlays(emissive_appearance(icon, "lights_mask"))

	if(occupant && !only_pickle)
		I = image(icon, "pod_liquid")
		AddOverlays(I)
		I = image(icon, "pod_glass")
		AddOverlays(I)

/obj/machinery/atmospherics/unary/cryo_cell/proc/process_occupant()
	if(air_contents.total_moles < 10)
		return
	if(occupant)
		if(occupant.stat == DEAD)
			return
		occupant.bodytemperature += 2*(air_contents.temperature - occupant.bodytemperature)*current_heat_capacity/(current_heat_capacity + air_contents.heat_capacity())
		occupant.bodytemperature = max(occupant.bodytemperature, air_contents.temperature) // this is so ugly i'm sorry for doing it i'll fix it later i promise

		if(occupant.isSynthetic())
			return

		occupant.set_stat(UNCONSCIOUS)
		var/has_cryo = REAGENT_VOLUME(occupant.reagents, /singleton/reagent/cryoxadone) >= 1
		var/has_clonexa = REAGENT_VOLUME(occupant.reagents, /singleton/reagent/clonexadone) >= 1
		var/has_cryo_medicine = has_cryo || has_clonexa
		if(beaker && !has_cryo_medicine)
			beaker.reagents.trans_to_mob(occupant, 1, CHEM_BLOOD)

/obj/machinery/atmospherics/unary/cryo_cell/proc/heat_gas_contents()
	if(air_contents.total_moles < 1)
		return
	var/air_heat_capacity = air_contents.heat_capacity()
	var/combined_heat_capacity = current_heat_capacity + air_heat_capacity
	if(combined_heat_capacity > 0)
		var/combined_energy = T20C*current_heat_capacity + air_heat_capacity*air_contents.temperature
		air_contents.temperature = combined_energy/combined_heat_capacity

/obj/machinery/atmospherics/unary/cryo_cell/proc/expel_gas()
	if(air_contents.total_moles < 1)
		return

/obj/machinery/atmospherics/unary/cryo_cell/proc/go_out()
	if(!(occupant))
		return
	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(get_step(loc, SOUTH))	//this doesn't account for walls or anything, but i don't forsee that being a problem.
	if (occupant.bodytemperature < 261 && occupant.bodytemperature >= 70) //Patch by Aranclanos to stop people from taking burn damage after being ejected
		occupant.bodytemperature = 261									  // Changed to 70 from 140 by Zuhayr due to reoccurance of bug.
	occupant = null
	current_heat_capacity = initial(current_heat_capacity)
	update_use_power(POWER_USE_IDLE)
	flick_overlay_view(mutable_appearance(icon, "pod_opening"), 2.5 SECONDS)
	update_icon()

/obj/machinery/atmospherics/unary/cryo_cell/proc/put_mob(mob/living/carbon/human/M as mob)
	if (stat & (NOPOWER|BROKEN))
		to_chat(usr, SPAN_WARNING("The cryo cell is not functioning."))
		return
	if (!istype(M))
		to_chat(usr, SPAN_DANGER("The cryo cell cannot handle such a lifeform!"))
		return
	if (occupant)
		to_chat(usr, SPAN_DANGER("The cryo cell is already occupied!"))
		return
	if (M.abiotic())
		to_chat(usr, SPAN_WARNING("Subject may not have abiotic items on."))
		return
	if(!node)
		to_chat(usr, SPAN_WARNING("The cell is not correctly connected to its pipe network!"))
		return
	if (M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.stop_pulling()
	M.forceMove(src)
	M.ExtinguishMob()
	if(M.health > -100 && (M.health < 0 || M.sleeping))
		to_chat(M, SPAN_NOTICE("<b>You feel a cold liquid surround you. Your skin starts to freeze up.</b>"))
	occupant = M
	current_heat_capacity = HEAT_CAPACITY_HUMAN
	update_use_power(POWER_USE_ACTIVE)
//	M.metabslow = 1
	add_fingerprint(usr)
	update_icon(TRUE)
	flick_overlay_view(mutable_appearance(icon, "pod_closing"), 2.5 SECONDS)
	return 1

/obj/machinery/atmospherics/unary/cryo_cell/verb/move_eject()
	set name = "Eject occupant"
	set category = "Object"
	set src in oview(1)
	if(usr == occupant)//If the user is inside the tube...
		if (usr.stat == 2)//and he's not dead....
			return
		to_chat(usr, SPAN_NOTICE("Release sequence activated. This will take two minutes."))
		sleep(1200)
		if(!src || !usr || !occupant || (occupant != usr)) //Check if someone's released/replaced/bombed him already
			return
		go_out()//and release him from the eternal prison.
	else
		if (usr.stat != 0)
			return
		go_out()
	add_fingerprint(usr)
	return

/obj/machinery/atmospherics/unary/cryo_cell/verb/move_inside()
	set name = "Move Inside"
	set category = "Object"
	set src in oview(1)
	for(var/mob/living/carbon/slime/M in range(1,usr))
		if(M.victim == usr)
			to_chat(usr, SPAN_WARNING("You cannot do this while a slime is latched onto you!"))
			return
	if (usr.stat != 0)
		return
	usr.visible_message(SPAN_NOTICE("[usr] climbs into [src]."),
						SPAN_NOTICE("You climb into [src]."), range = 3)

	put_mob(usr)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon)), 2.5 SECONDS)
	return

/atom/proc/return_air_for_internal_lifeform(var/mob/living/lifeform)
	return return_air()

/obj/machinery/atmospherics/unary/cryo_cell/return_air_for_internal_lifeform()
	//assume that the cryo cell has some kind of breath mask or something that
	//draws from the cryo tube's environment, instead of the cold internal air.
	if(loc)
		return loc.return_air()

/obj/machinery/atmospherics/unary/cryo_cell/RefreshParts()
	..()
	var/man_rating = 0
	for(var/obj/item/stock_parts/P in component_parts)
		if(ismanipulator(P))
			man_rating += P.rating
	fast_stasis_mult = max(0.6/man_rating, 0.2)
	slow_stasis_mult = min(1.6+(man_rating/10), 2)

/datum/data/function/proc/reset()
	return

/datum/data/function/proc/r_input(href, href_list, mob/user as mob)
	return

/datum/data/function/proc/display()
	return

#undef HEAT_CAPACITY_HUMAN
