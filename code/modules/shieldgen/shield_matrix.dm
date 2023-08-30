var/global/list/default_shield_boards = list(/obj/item/modulator_board/hyperkinetic,
											/obj/item/modulator_board/photonic,
											/obj/item/modulator_board/humanoids,
											/obj/item/modulator_board/silicon,
											/obj/item/modulator_board/mobs,
											/obj/item/modulator_board/hull)

/obj/machinery/shield_matrix
	name = "shield matrix"
	desc = "A machine which controls the distribution of Force Renwicks in the shield generator."
	icon = 'icons/obj/machinery/shielding.dmi'
	icon_state = "matrix"
	density = TRUE
	use_power = POWER_USE_OFF //doesn't use APC power
	req_one_access = list(access_captain, access_security, access_engine)
	obj_flags = OBJ_FLAG_ROTATABLE
	var/active = FALSE
	var/strength_ratio = 0.34
	var/charge_ratio = 0.33
	var/modulator_ratio = 0.33
	var/locked = FALSE
	var/obj/machinery/shield_capacitor/owned_capacitor
	var/list/owned_projectors = list(PROJ_DIR_ALL = null,
									PROJ_DIR_NORTH = null,
									PROJ_DIR_EAST = null,
									PROJ_DIR_SOUTH = null,
									PROJ_DIR_WEST = null)
	var/list/projector_power = list(PROJ_DIR_ALL = 0,
									PROJ_DIR_NORTH = 0,
									PROJ_DIR_EAST = 0,
									PROJ_DIR_SOUTH = 0,
									PROJ_DIR_WEST = 0)
	var/list/modulators = list()
	var/list/available_modulators = list()
	var/list/mod_boards = list()
	var/field_radius = 3
	var/max_field_radius = 100
	var/multi_z = TRUE
	var/maint = FALSE

/obj/machinery/shield_matrix/Initialize()
	update_shield_parts()
	for(var/M in default_shield_boards)
		var/obj/item/modulator_board/MB = new M(src)
		if(istype(MB))
			LAZYADD(mod_boards, MB)
			LAZYADD(available_modulators, MB.mod)
	if(dir == NORTH)
		pixel_y = 7
	else
		pixel_y = 0
	return

/obj/machinery/shield_matrix/proc/update_shield_parts()
	owned_capacitor = null
	owned_projectors = list()

	if(!anchored)
		return FALSE

	for(var/obj/machinery/shield_capacitor/possible_cap in range(1, src))
		if(!possible_cap.anchored)
			continue
		if(get_cardinal_dir(possible_cap, src) == possible_cap.dir)
			owned_capacitor = possible_cap
			possible_cap.owned_matrix = src
			break

	var/projectors = 0
	for(var/obj/machinery/shield_gen/possible_projector in range(2, src))
		if(!possible_projector.anchored)
			continue
		if(!possible_projector.directional || (get_cardinal_dir(possible_projector, src) == reverse_direction(possible_projector.dir)))
			var/proj_dir = PROJ_DIR_ALL
			if(possible_projector.directional)
				switch(possible_projector.dir)
					if (NORTH)
						proj_dir = PROJ_DIR_NORTH
					if (EAST)
						proj_dir = PROJ_DIR_EAST
					if (SOUTH)
						proj_dir = PROJ_DIR_SOUTH
					if (WEST)
						proj_dir = PROJ_DIR_WEST
			LAZYSET(owned_projectors, proj_dir, possible_projector)
			possible_projector.parent_matrix = src
			projectors++

	if(projectors)
		for(var/D in projector_power)
			if(!owned_projectors[D])
				continue
			LAZYSET(projector_power, D, 1/projectors)

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
	else if(W.ismultitool())
		maint = !maint
		visible_message(SPAN_NOTICE("\The [src]'s maintaince protocol has been [maint ? "activated":"deactivated"] by \the [user]."))
		update_icon()
	else if(W.iswrench())
		anchored = !anchored
		visible_message(SPAN_NOTICE("\The [src] has been [anchored ? "bolted to the floor":"unbolted from the floor"] by \the [user]."))

		if(active)
			toggle()
		update_shield_parts()
	else if(maint && istype(W, /obj/item/modulator_board))
		var/obj/item/modulator_board/MB = W
		for(var/datum/shield_mode/M in available_modulators)
			if(istype(MB.mod, M.type))
				to_chat(user, SPAN_NOTICE("\The [src] already has \a [MB] installed."))
				return
		LAZYADD(mod_boards, MB)
		LAZYADD(available_modulators, MB.mod)
		user.drop_from_inventory(MB)
		MB.forceMove(src)
		visible_message(SPAN_NOTICE("\The [user] installs \the [MB] into \the [src]."))
	else
		..()

/obj/machinery/shield_matrix/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/shield_matrix/attack_hand(mob/user)
	if(stat & BROKEN)
		return
	else if(maint)
		var/obj/item/modulator_board/MB = input(user, "Choose a modulator board to remove.", "Shield Matrix") in mod_boards
		if(MB)
			user.put_in_hands(MB)
			LAZYREMOVE(mod_boards, MB)
			LAZYREMOVE(available_modulators, MB.mod)
			return
	interact(user)

/obj/machinery/shield_matrix/interact(mob/user)
	if(locked)
		to_chat(user, SPAN_WARNING("The device is locked. Swipe your ID to unlock it."))
		return
	if(!anchored)
		to_chat(user, SPAN_WARNING("The device needs to be bolted to the ground first."))
		return

	return ui_interact(user)

/obj/machinery/shield_matrix/process()
	if(active)
		if(!anchored)
			toggle()
		if(stat & BROKEN)
			toggle()
			return PROCESS_KILL
	if(!owned_capacitor)
		return

	var/renwicks = owned_capacitor.stored_charge RENWICKS

	if(!renwicks)
		return

	owned_capacitor.stored_charge -= renwicks JOULES

	if((strength_ratio + charge_ratio + modulator_ratio) != 1)
		strength_ratio = min(1, strength_ratio)
		charge_ratio = min(1-strength_ratio, charge_ratio)
		modulator_ratio = 1-(strength_ratio + charge_ratio)

	for(var/D in owned_projectors)
		var/obj/machinery/shield_gen/P = owned_projectors[D]
		if(!P.directional)
			P.shield_max = SHIELD_STRENGTH_MAX / 4
			continue
		P.shield_max = SHIELD_STRENGTH_MAX * projector_power[D]

	var/s_renwicks_per_projector = (renwicks * strength_ratio)
	var/c_renwicks_per_projector = (renwicks * charge_ratio)
	var/m_renwicks_per_projector = (renwicks * modulator_ratio)

	for(var/D in owned_projectors)
		var/obj/machinery/shield_gen/P = owned_projectors[D]
		P.generate_field(s_renwicks_per_projector * projector_power[D], c_renwicks_per_projector * projector_power[D], m_renwicks_per_projector * projector_power[D])

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
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

	else
		for(var/mob/M as anything in hearers(5,src))
			to_chat(M, "[icon2html(src, M)] You hear heavy droning fade out.")
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/shield_matrix/proc/get_modulators_by_name(var/available=TRUE, exclude_datums=TRUE)
	var/list/mods = list()
	for(var/datum/shield_mode/M in available ? available_modulators : modulators)
		if(exclude_datums)
			LAZYADD(mods, M.mode_name)
		else
			LAZYSET(mods, M.mode_name, M)
	return mods

/obj/machinery/shield_matrix/proc/get_modulator_by_flag(var/flag)
	for(var/datum/shield_mode/M in modulators)
		if(flag == M.mode_flag)
			return M
	return FALSE

/obj/machinery/shield_matrix/update_icon()
	if (active)
		icon_state = "matrix_on"
	else
		icon_state = "matrix"
	cut_overlays()
	if(maint)
		add_overlay(overlay_image(icon, "matrix_panel"))

/obj/machinery/shield_matrix/rotate()
	. = ..()
	if(dir == NORTH)
		pixel_y = 7
	else
		pixel_y = 0

/obj/machinery/shield_matrix/ui_interact(mob/user, var/datum/tgui/ui)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShieldMatrix", "Shield Matrix", 600, 600)
		ui.open()

/obj/machinery/shield_matrix/ui_data(mob/user)
	var/list/data = list()
	var/list/proj_dirs = list()

	for(var/D in owned_projectors)
		if(owned_projectors[D])
			LAZYADD(proj_dirs, D)

	data["owned_capacitor"] = !!owned_capacitor
	data["projector_power"] = list(list("dir" = PROJ_DIR_ALL, "power" = projector_power[PROJ_DIR_ALL] * 100),
								list("dir" = PROJ_DIR_NORTH, "power" = projector_power[PROJ_DIR_NORTH] * 100),
								list("dir" = PROJ_DIR_EAST, "power" = projector_power[PROJ_DIR_EAST] * 100),
								list("dir" = PROJ_DIR_SOUTH, "power" = projector_power[PROJ_DIR_SOUTH] * 100),
								list("dir" = PROJ_DIR_WEST, "power" = projector_power[PROJ_DIR_WEST] * 100))
	data["owned_projectors"] = proj_dirs
	data["active"] = active
	data["strength_ratio"] = strength_ratio * 100
	data["charge_ratio"] = charge_ratio * 100
	data["modulator_ratio"] = modulator_ratio * 100
	data["available_modulators"] = get_modulators_by_name()
	data["modulators"] = get_modulators_by_name(FALSE)
	data["max_field_radius"] = max_field_radius
	data["field_radius"] = field_radius
	data["multiz"] = multi_z

	return data

/obj/machinery/shield_matrix/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle")
			toggle()
		if("setFieldRadius")
			field_radius = between(0, params["field_radius"], max_field_radius)
		if("setNewRatios")
			if(params["power"] == "strength")
				strength_ratio = params["ratio"] / 100
				charge_ratio = between(0, charge_ratio, 1 - strength_ratio)
				modulator_ratio = 1 - (strength_ratio + charge_ratio)
			else if(params["power"] == "charge")
				charge_ratio = params["ratio"] / 100
				strength_ratio = between(0, strength_ratio, 1 - charge_ratio)
				modulator_ratio = 1 - (strength_ratio + charge_ratio)
			else if(params["power"] == "modulator")
				modulator_ratio = params["ratio"] / 100
				strength_ratio = between(0, strength_ratio, 1 - modulator_ratio)
				charge_ratio = 1 - (strength_ratio + modulator_ratio)
		if("changeModulators")
			var/list/available_mods = get_modulators_by_name(TRUE, FALSE)
			var/datum/shield_mode/M = available_mods[params["modulator"]]
			if(!M)
				return
			if(M in modulators)
				LAZYREMOVE(modulators, M)
			else
				LAZYADD(modulators, M)
		if("setPower")
			if(LAZYLEN(owned_projectors) == 1)
				projector_power[params["dir"]] = 1
				return
			projector_power[params["dir"]] = params["power"] / 100
			var/total_pwr = projector_power[params["dir"]]
			var/projectors = 1
			for(var/D in projector_power)
				if(D == params["dir"] || !LAZYISIN(owned_projectors, D))
					continue
				projector_power[D] = between(0, projector_power[D], 1 - total_pwr)
				total_pwr += projector_power[D]
				projectors++
				if((projectors == LAZYLEN(owned_projectors)) && total_pwr < 1) //Top up any left over capacity
					projector_power[D] += 1 - total_pwr
		if("multiz")
			multi_z = !multi_z

/obj/machinery/shield_matrix/proc/has_modulator(var/flag)
	if(!(flag && LAZYLEN(modulators)))
		return FALSE

	var/modes = 0
	for(var/datum/shield_mode/M in modulators)
		modes |= M.mode_flag

	return (modes & flag)

/obj/machinery/shield_matrix/proc/get_greedy_modules()
	var/list/greedy_modules = list()
	for(var/datum/shield_mode/M in modulators)
		if(M.greedy)
			LAZYADD(greedy_modules, M)
	return greedy_modules
