/obj/machinery/shield_matrix
	name = "shield matrix"
	desc = "A machine which controls the distribution of Force Renwicks in the shield generator."
	icon = 'icons/obj/machinery/shielding.dmi'
	icon_state = "capacitor"
	density = TRUE
	use_power = POWER_USE_OFF //doesn't use APC power
	req_one_access = list(access_captain, access_security, access_engine)
	var/active = FALSE
	var/strength_ratio = 0.34
	var/charge_ratio = 0.33
	var/modulator_ratio = 0.33
	var/locked = FALSE
	var/obj/machinery/shield_capacitor/owned_capacitor
	var/list/owned_projectors = list()
	var/list/modulators = list()
	var/list/available_modulators = list()
	var/list/mod_boards = list()
	var/max_renwick_draw = 100 //Need to test numbers on this
	var/renwick_draw = 100
	var/field_radius = 3
	var/max_field_radius = 100
	var/multi_z = TRUE

/obj/machinery/shield_matrix/Initialize()
	update_shield_parts()
	for(var/M in subtypesof(/obj/item/modulator_board))
		var/obj/item/modulator_board/MB = new M(src)
		if(istype(MB) && MB.origin_tech[TECH_ENGINEERING] <= 2)
			LAZYADD(mod_boards, MB)
			LAZYADD(available_modulators, MB.mod)

	return

/obj/machinery/shield_matrix/proc/update_shield_parts()
	owned_capacitor = null
	owned_projectors = list()

	if(!anchored)
		return FALSE

	for(var/obj/machinery/shield_capacitor/possible_cap in range(1, src))
		if(get_dir(possible_cap, src) == possible_cap.dir)
			owned_capacitor = possible_cap
			break

	for(var/obj/machinery/shield_gen/possible_projector in range(2, src))
		if(!possible_projector.directional || (get_dir(possible_projector, src) == switch_dir(possible_projector.dir)))
			LAZYADD(owned_projectors, possible_projector)

	return owned_capacitor && owned_projectors.len

/obj/machinery/shield_matrix/emag_act(var/remaining_charges, var/mob/user)
	if(prob(75))
		locked = !locked
		to_chat(user, "Controls are now [locked ? "locked." : "unlocked."]")
		. = TRUE
		updateDialog()

	spark(src, 5, alldirs)

/obj/machinery/shield_matrix/attackby(obj/item/W, mob/user)
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
		update_shield_parts()
	else
		..()

/obj/machinery/shield_matrix/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/shield_matrix/attack_hand(mob/user)
	if(stat & BROKEN)
		return
	interact(user)

/obj/machinery/shield_matrix/interact(mob/user)
	if(locked)
		to_chat(user, SPAN_WARNING("The device is locked. Swipe your ID to unlock it."))
		return
	if(!anchored)
		to_chat(user, SPAN_WARNING("The device needs to be bolted to the ground first."))
		return

	update_shield_parts()

	return ui_interact(user)

/obj/machinery/shield_matrix/process()
	if(active)
		if(!anchored)
			toggle()
		if(stat & BROKEN)
			toggle()
			return PROCESS_KILL

	var/renwicks = min(Floor(owned_capacitor.stored_charge RENWICKS), renwick_draw)

	if(!renwicks)
		return

	owned_capacitor.stored_charge -= renwicks JOULES

	if((strength_ratio + charge_ratio + modulator_ratio) != 1)
		strength_ratio = min(1, strength_ratio)
		charge_ratio = min(1-strength_ratio, charge_ratio)
		modulator_ratio = 1-(strength_ratio + charge_ratio)

	var/s_renwicks_per_projector = (renwicks * strength_ratio) / owned_projectors.len
	var/c_renwicks_per_projector = (renwicks * charge_ratio) / owned_projectors.len
	var/m_renwicks_per_projector = (renwicks * modulator_ratio) / owned_projectors.len

	for(var/obj/machinery/shield_gen/P in owned_projectors)
		P.generate_field(s_renwicks_per_projector, c_renwicks_per_projector, m_renwicks_per_projector)

/obj/machinery/shield_matrix/ex_act(var/severity)
	if(active)
		toggle()
	return ..()

/obj/machinery/shield_matrix/proc/toggle()
	active = !active
	update_icon()
	if(active)
		for(var/mob/M as anything in hearers(5,src))
			to_chat(M, "[icon2html(src, M)] You hear heavy droning start up.")
	else
		for(var/mob/M as anything in hearers(5,src))
			to_chat(M, "[icon2html(src, M)] You hear heavy droning fade out.")

/obj/machinery/shield_matrix/proc/get_modulators_by_name(var/available=TRUE, exclude_datums=TRUE)
	var/list/mods = list()
	for(var/datum/shield_mode/M in available ? available_modulators : modulators)
		if(exclude_datums)
			LAZYADD(mods, M.mode_name)
		else
			LAZYSET(mods, M.mode_name, M)
	return mods

/obj/machinery/shield_matrix/update_icon()
	if(stat & BROKEN)
		icon_state = "matrix_broke"
	else
		if (active)
			icon_state = "matrix_on"
		else
			icon_state = "capacitor"

/obj/machinery/shield_matrix/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShieldMatrix", "Shield Matrix", 480, 400)
		ui.open()

/obj/machinery/shield_matrix/ui_data(mob/user)
	var/list/data = list()

	data["owned_capacitor"] = !!owned_capacitor
	data["owned_projectors"] = owned_projectors
	data["active"] = active
	data["strength_ratio"] = strength_ratio
	data["charge_ratio"] = charge_ratio
	data["modulator_ratio"] = modulator_ratio
	data["available_modulators"] = get_modulators_by_name()
	data["modulators"] = get_modulators_by_name(FALSE)
	data["max_renwick_draw"] = max_renwick_draw
	data["renwick_draw"] = renwick_draw

	return data

/obj/machinery/shield_matrix/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle")
			toggle()
		if("setRenwickDraw")
			renwick_draw = between(0, params["renwick_draw"], max_renwick_draw)
		if("setNewRatios")
			strength_ratio = params["str"]
			charge_ratio = min(params["cha"], 1-strength_ratio)
			modulator_ratio = 1 - (strength_ratio + charge_ratio)
			update_static_data_for_all_viewers()
		if("changeModulators")
			var/list/available_mods = get_modulators_by_name(TRUE, FALSE)
			var/datum/shield_mode/M = available_mods[params["modulator"]]
			if(!M)
				return
			if(M in modulators)
				LAZYREMOVE(modulators, M)
			else
				LAZYADD(modulators, M)

/obj/machinery/shield_matrix/proc/has_modulator(var/flag)
	if(!(flag && LAZYLEN(modulators)))
		return FALSE

	var/modes = 0
	for(var/datum/shield_mode/M in modulators)
		modes |= M.mode_flag

	return (modes & flag)
