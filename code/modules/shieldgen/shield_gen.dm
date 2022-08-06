//renwicks: fictional unit to describe shield strength
//a small meteor hit will deduct 1 renwick of strength from that shield tile
//light explosion range will do 1 renwick's damage
//medium explosion range will do 2 renwick's damage
//heavy explosion range will do 3 renwick's damage
//explosion damage is cumulative. if a tile is in range of light, medium and heavy damage, it will take a hit from all three

/obj/machinery/shield_gen
	name = "bubble shield generator"
	desc = "Machine that generates an impenetrable field of energy when activated."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "generator0"
	var/active = FALSE
	var/field_radius = 3
	var/max_field_radius = 100
	var/list/field
	density = TRUE
	var/locked = FALSE
	var/average_field_strength = 0
	var/strengthen_rate = 0.2
	var/max_strengthen_rate = 0.5	//the maximum rate that the generator can increase the average field strength
	var/dissipation_rate = 0.030	//the percentage of the shield strength that needs to be replaced each second
	var/min_dissipation = 0.01		//will dissipate by at least this rate in renwicks per field tile (otherwise field would never dissipate completely as dissipation is a percentage)
	var/powered = FALSE
	var/check_powered = TRUE
	var/obj/machinery/shield_capacitor/owned_capacitor
	var/target_field_strength = 10
	var/max_field_strength = 10
	var/time_since_fail = 100
	var/energy_conversion_rate = 0.0002	//how many renwicks per watt?
	use_power = POWER_USE_OFF	//doesn't use APC power
	var/multiz = TRUE
	var/multi_unlocked = TRUE
	req_one_access = list(access_captain, access_security, access_engine)

/obj/machinery/shield_gen/Initialize()
	for(var/obj/machinery/shield_capacitor/possible_cap in range(1, src))
		if(get_dir(possible_cap, src) == possible_cap.dir)
			owned_capacitor = possible_cap
			break
	field = list()
	. = ..()

/obj/machinery/shield_gen/Destroy()
	for(var/obj/effect/energy_field/D as anything in field)
		field.Remove(D)
		D.loc = null
	return ..()

/obj/machinery/shield_gen/emag_act(var/remaining_charges, var/mob/user)
	if(prob(75))
		locked = !locked
		to_chat(user, "Controls are now [locked ? "locked." : "unlocked."]")
		. = TRUE
		updateDialog()

	spark(src, 5, alldirs)

/obj/machinery/shield_gen/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id))
		if(allowed(user))
			locked = !locked
			to_chat(user, "Controls are now [locked ? "locked." : "unlocked."]")
			updateDialog()
		else
			to_chat(user, SPAN_ALERT("Access denied."))
	else if(W.iswrench())
		anchored = !anchored
		visible_message(SPAN_NOTICE("\The [src] has been [anchored ? "bolted to the floor":"unbolted from the floor"] by \the [user]."))

		if(active)
			toggle()
		if(anchored)
			for(var/obj/machinery/shield_capacitor/cap in range(1, src))
				if(cap.owned_gen)
					continue
				if(get_dir(cap, src) == cap.dir && cap.anchored)
					owned_capacitor = cap
					owned_capacitor.owned_gen = src
					updateDialog()
					break
		else
			if(owned_capacitor && owned_capacitor.owned_gen == src)
				owned_capacitor.owned_gen = null
			owned_capacitor = null
	else
		..()

/obj/machinery/shield_gen/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/shield_gen/attack_hand(mob/user)
	if(stat & BROKEN)
		return
	interact(user)

/obj/machinery/shield_gen/interact(mob/user)
	if(locked)
		to_chat(user, SPAN_WARNING("The device is locked. Swipe your ID to unlock it."))
		return
	if(!anchored)
		to_chat(user, SPAN_WARNING("The device needs to be bolted to the ground first."))
		return
	else
		if(owned_capacitor)
			if(!(owned_capacitor in range(1, src) && get_dir(owned_capacitor, src) == owned_capacitor.dir && owned_capacitor.anchored))
				if(owned_capacitor.owned_gen == src)
					owned_capacitor.owned_gen = null
				owned_capacitor = null
	if(!owned_capacitor)
		for(var/obj/machinery/shield_capacitor/cap in range(1, src))
			if(cap.owned_gen)
				continue
			if(get_dir(cap, src) == cap.dir && cap.anchored)
				owned_capacitor = cap
				owned_capacitor.owned_gen = src
				updateDialog()
				break
	return ui_interact(user)

/obj/machinery/shield_gen/process()
	if(active)
		if(!anchored)
			toggle()
		if(stat & BROKEN)
			toggle()
			return PROCESS_KILL

	average_field_strength = max(average_field_strength, 0)

	if(field.len)
		time_since_fail++
		var/total_renwick_increase = 0 //the amount of renwicks that the generator can add this tick, over the entire field
		var/renwick_upkeep_per_field = max(average_field_strength * dissipation_rate, min_dissipation)

		//figure out how much energy we need to draw from the capacitor
		if(active && owned_capacitor?.active)
			var/target_renwick_increase = min(target_field_strength - average_field_strength, strengthen_rate) + renwick_upkeep_per_field //per field tile

			var/required_energy = field.len * target_renwick_increase / energy_conversion_rate
			var/assumed_charge = min(owned_capacitor.stored_charge, required_energy)
			total_renwick_increase = assumed_charge * energy_conversion_rate
			assumed_charge = max(assumed_charge, 0)
			owned_capacitor.stored_charge -= assumed_charge
		else
			renwick_upkeep_per_field = max(renwick_upkeep_per_field, 0.5)

		var/renwick_increase_per_field = total_renwick_increase/field.len //per field tile

		average_field_strength = 0 //recalculate the average field strength
		for(var/obj/effect/energy_field/E as anything in field)
			var/amount_to_strengthen = renwick_increase_per_field - renwick_upkeep_per_field
			if(E.ticks_recovering > 0 && amount_to_strengthen > 0)
				E.Strengthen( min(amount_to_strengthen / 10, 0.1) )
				E.ticks_recovering -= 1
			else
				E.Strengthen(amount_to_strengthen)

			average_field_strength += E.strength

		average_field_strength /= field.len
		if(average_field_strength < 1)
			time_since_fail = 0
	else
		average_field_strength = 0

/obj/machinery/shield_gen/ex_act(var/severity)
	if(active)
		toggle()
	return ..()

/obj/machinery/shield_gen/proc/toggle()
	active = !active
	update_icon()
	if(active)
		var/list/covered_turfs = get_shielded_turfs()
		var/turf/T = get_turf(src)
		for(var/turf/O as anything in covered_turfs - T)
			var/obj/effect/energy_field/E = new(O)
			field.Add(E)
		covered_turfs = null

		for(var/mob/M as anything in hearers(5,src))
			to_chat(M, "[icon2html(src, M)] You hear heavy droning start up.")
	else
		for(var/obj/effect/energy_field/D as anything in field)
			field.Remove(D)
			D.loc = null

		for(var/mob/M as anything in hearers(5,src))
			to_chat(M, "[icon2html(src, M)] You hear heavy droning fade out.")

/obj/machinery/shield_gen/update_icon()
	if(stat & BROKEN)
		icon_state = "broke"
	else
		if (active)
			icon_state = "generator1"
		else
			icon_state = "generator0"

//grab the border tiles in a square around this machine
/obj/machinery/shield_gen/proc/get_shielded_turfs()
	var/turf/T = get_turf(src)
	. = list()

	if(field_radius > 0 && T)
		var/connected_levels = list(T.z)
		if(multiz)
			for(var/turf/connected_z_turf as anything in (getzabove(src) + getzbelow(src)))
				connected_levels += connected_z_turf.z

		. += block(\
			locate(T.x - field_radius, T.y + field_radius, min(connected_levels)),\
			locate(T.x + field_radius - 1, T.y + field_radius, max(connected_levels))\
			)

		. += block(\
			locate(T.x + field_radius, T.y - field_radius, min(connected_levels)),\
			locate(T.x - field_radius + 1, T.y - field_radius, max(connected_levels))\
		)

		. += block(\
			locate(T.x - field_radius, T.y + field_radius - 1, min(connected_levels)),\
			locate(T.x - field_radius, T.y - field_radius, max(connected_levels))\
			)

		. += block(\
			locate(T.x + field_radius, T.y + field_radius, min(connected_levels)),\
			locate(T.x + field_radius, T.y - field_radius + 1, max(connected_levels))\
			)

/obj/machinery/shield_gen/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, src, "machinery-shields-shield", 480, 400, "Shield Generator")
		ui.open()
		ui.auto_update_content = TRUE

/obj/machinery/shield_gen/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	data = ..() || list()

	data["owned_capacitor"] = owned_capacitor
	data["active"] = active
	data["time_since_fail"] = time_since_fail
	data["multi_unlocked"] = multi_unlocked
	data["multiz"] = multiz
	data["field_radius"] = field_radius
	data["min_field_radius"] = 1
	data["max_field_radius"] = max_field_radius
	data["average_field"] = round(average_field_strength, 0.01)
	data["progress_field"] = (target_field_strength ? round(100 * average_field_strength / target_field_strength, 0.1) : "NA")
	data["power_take"] = round(field.len * max(average_field_strength * dissipation_rate, min_dissipation) / energy_conversion_rate)
	data["shield_power"] = round(field.len * min(strengthen_rate, target_field_strength - average_field_strength) / energy_conversion_rate)
	data["strengthen_rate"] = (strengthen_rate * 10)
	data["max_strengthen_rate"] = (max_strengthen_rate * 10)
	data["target_field_strength"] = target_field_strength

	return data

/obj/machinery/shield_gen/Topic(href, href_list)
	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return

	if(href_list["toggle"])
		toggle()

	if(href_list["multiz"])
		multiz = !multiz

	if (href_list["size_set"])
		field_radius = between(1, text2num(href_list["size_set"]), max_field_radius)

	if (href_list["charge_set"])
		strengthen_rate = (between(1, text2num(href_list["charge_set"]), (max_strengthen_rate * 10)) / 10)

	if (href_list["field_set"])
		target_field_strength = between(1, text2num(href_list["field_set"]), 10)

	src.add_fingerprint(usr)
	return 1

/obj/machinery/shield_gen/proc/getzabove(var/turf/location)
	var/connected = list()
	var/turf/above = GetAbove(location)

	if(above)
		connected += above
		var/connected_levels = getzabove(above)
		for(var/turf/z as anything in connected_levels)
			connected += z

	return connected

/obj/machinery/shield_gen/proc/getzbelow(var/turf/location)
	var/connected = list()
	var/turf/below = GetBelow(location)

	if(below)
		connected += below
		var/connected_levels = getzbelow(below)
		for(var/turf/z as anything in connected_levels)
			connected += z

	return connected
