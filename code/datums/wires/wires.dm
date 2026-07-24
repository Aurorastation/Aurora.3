#define MAXIMUM_EMP_WIRES 3

GLOBAL_LIST_INIT(wire_color_directory, list())
GLOBAL_LIST_INIT(wire_name_directory, list())
GLOBAL_LIST_INIT(wire_skill_reveal_directory, list())

/datum/wires
	/// The holder (atom that contains these wires).
	var/atom/holder
	/// The holder's typepath (used for sanity checks to make sure the holder is the appropriate type for these wire sets).
	var/holder_type
	/// Whether this wire datum errors out if it has a wrong holder or not.
	var/cares_about_holder = TRUE
	/// Key that enables wire assignments to be common across different holders. If null, will use the holder_type as a key.
	var/dictionary_key = null
	/// The display name for the wire set. Used in the hacking interface.
	var/proper_name = "Unknown"

	/// List of all wires.
	var/list/wires = list()
	/// List of cut wires.
	var/list/cut_wires = list() // List of wires that have been cut.
	/// Dictionary of colours to wire.
	var/list/colors = list()
	/// List of attached assemblies.
	var/list/assemblies = list()
	/// If every instance of these wires should be random. Prevents wires from showing up in station blueprints.
	var/random = FALSE
	/// Wire manufacturer for the UI skin.
	var/manufacturer = "hephaestus"
	/// Skill component path used for partial wire reveals. Null disables skill-based reveals.
	var/associated_skill = ELECTRICAL_ENGINEERING_SKILL_COMPONENT
	/// Key used for round-stable partial skill-based reveals
	var/skill_reveal_key

/datum/wires/New(atom/holder)
	..()
	if(!istype(holder, holder_type) && cares_about_holder)
		CRASH("Wire holder is not of the expected type!")

	src.holder = holder
	if(istype(holder, /obj/structure/machinery))
		var/obj/structure/machinery/M = holder
		manufacturer = M.manufacturer

	// If there is a dictionary key set, we'll want to use that. Otherwise, use the holder type.
	var/key = dictionary_key ? dictionary_key : holder_type
	skill_reveal_key = key

	RegisterSignal(holder, COMSIG_QDELETING, PROC_REF(on_holder_qdel))
	if(random)
		randomize()
	else
		if(!GLOB.wire_color_directory[key])
			randomize()
			GLOB.wire_color_directory[key] = colors
			GLOB.wire_name_directory[key] = proper_name
		else
			colors = GLOB.wire_color_directory[key]

/datum/wires/Destroy()
	holder = null
	skill_reveal_key = null
	//properly clear refs to avoid harddels & other problems
	for(var/color in assemblies)
		var/obj/item/assembly/assembly = assemblies[color]
		assembly.holder = null
	LAZYCLEARLIST(assemblies)
	return ..()

/datum/wires/proc/add_duds(duds)
	while(duds)
		var/dud = WIRE_DUD_PREFIX + "[--duds]"
		if(dud in wires)
			continue
		wires += dud

///Called when holder is qdeleted for us to clean ourselves as not to leave any unlawful references.
/datum/wires/proc/on_holder_qdel(atom/source, force)
	SIGNAL_HANDLER

	qdel(src)

/datum/wires/proc/randomize()
	var/static/list/possible_colors = list(
	"blue",
	"brown",
	"crimson",
	"cyan",
	"gold",
	"green",
	"grey",
	"lime",
	"magenta",
	"orange",
	"pink",
	"purple",
	"red",
	"silver",
	"violet",
	"white",
	"yellow",
	)

	var/list/my_possible_colors = possible_colors.Copy()

	for(var/wire in shuffle(wires))
		colors[pick_n_take(my_possible_colors)] = wire

/datum/wires/proc/shuffle_wires()
	colors.Cut()
	if(skill_reveal_key)
		GLOB.wire_skill_reveal_directory -= skill_reveal_key
	randomize()

/datum/wires/proc/repair()
	for(var/wire in cut_wires)
		cut(wire) // I KNOW I KNOW OK


/datum/wires/proc/get_wire(color)
	return colors[color]

/datum/wires/proc/get_color_of_wire(wire_type)
	for(var/color in colors)
		var/other_type = colors[color]
		if(wire_type == other_type)
			return color

/datum/wires/proc/get_attached(color)
	if(assemblies[color])
		return assemblies[color]
	return null

/datum/wires/proc/is_attached(color)
	if(assemblies[color])
		return TRUE

/datum/wires/proc/is_cut(wire)
	return (wire in cut_wires)

/datum/wires/proc/is_color_cut(color)
	return is_cut(get_wire(color))

/datum/wires/proc/is_all_cut()
	if(cut_wires.len == wires.len)
		return TRUE

/datum/wires/proc/is_dud(wire)
	return findtext(wire, WIRE_DUD_PREFIX, 1, length(WIRE_DUD_PREFIX) + 1)

/datum/wires/proc/is_dud_color(color)
	return is_dud(get_wire(color))

/datum/wires/proc/cut(wire, source)
	if(is_cut(wire))
		cut_wires -= wire
		SEND_SIGNAL(src, COMSIG_MEND_WIRE(wire), wire)
		on_cut(wire, mend = TRUE, source = source)
	else
		cut_wires += wire
		SEND_SIGNAL(src, COMSIG_CUT_WIRE(wire), wire)
		on_cut(wire, mend = FALSE, source = source)

/datum/wires/proc/cut_color(color, source)
	cut(get_wire(color), source)

/datum/wires/proc/cut_random(source)
	cut(wires[rand(1, wires.len)], source)

/datum/wires/proc/cut_all(source)
	for(var/wire in wires)
		cut(wire, source)

/datum/wires/proc/pulse(wire, user, force=FALSE)
	if(!force && is_cut(wire))
		return
	on_pulse(wire, user)

/datum/wires/proc/pulse_color(color, mob/living/user, force=FALSE)
	pulse(get_wire(color), user, force)

/datum/wires/proc/pulse_assembly(obj/item/assembly/signaler/S)
	for(var/color in assemblies)
		if(S == assemblies[color])
			pulse_color(color, force=TRUE)
			return TRUE

/datum/wires/proc/attach_assembly(color, obj/item/assembly/signaler/S)
	if(S && istype(S) && !is_attached(color))
		assemblies[color] = S
		S.forceMove(holder)
		S.connected = src
		return S

/datum/wires/proc/detach_assembly(color)
	var/obj/item/assembly/signaler/S = get_attached(color)
	if(S && istype(S))
		assemblies -= color
		S.connected = null
		S.forceMove(holder.loc)
		return S

/// Called from [/atom/proc/emp_act]
/datum/wires/proc/emp_pulse()
	var/list/possible_wires = shuffle(wires)
	var/remaining_pulses = MAXIMUM_EMP_WIRES

	for(var/wire in possible_wires)
		if(prob(33))
			pulse(wire)
			remaining_pulses--
			if(!remaining_pulses)
				break

/datum/wires/proc/get_wire_diagram(var/mob/user)
	return

//
// Overridable Procs
//

/datum/wires/proc/interactable(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	if((SEND_SIGNAL(user, COMSIG_TRY_WIRES_INTERACT, holder) & COMPONENT_CANT_INTERACT_WIRES))
		return FALSE
	return TRUE

/datum/wires/proc/get_status()
	return list()

/datum/wires/proc/on_cut(wire, mend = FALSE, source = null)
	return

/datum/wires/proc/on_pulse(wire, user)
	return

// End Overridable Procs

/datum/wires/proc/interact(mob/user)
	if(!interactable(user))
		return
	ui_interact(user)
	for(var/A in assemblies)
		var/obj/item/I = assemblies[A]
		if(istype(I) && I.on_found(user))
			return


/**
 * Checks whether wire assignments should be revealed.
 *
 * Returns TRUE if every wire assignment in this panel should be revealed, FALSE otherwise.
 * Currently checks for admin ghosts and blueprints.
 * Arguments:
 * * user - The mob to check when deciding whether to reveal wires.
 */
/datum/wires/proc/can_reveal_wires(mob/user)
	// Admin ghost can see a purpose of each wire.
	if(isghost(user) && check_rights(R_MOD, FALSE, user))
		return TRUE

	// The following checks only apply for non-randomized wires.
	if (random)
		return FALSE

	// Station blueprints do that too
	if(istype(user.get_active_hand(), /obj/item/blueprints))
		return TRUE

	return FALSE

/**
 * Whether the given wire should always be revealed.
 *
 * Intended to be overridden. Allows for forcing a wire's assignmenmt to always be revealed
 * in the hacking interface.
 * Arguments:
 * * color - Color string of the wire to check.
 */
/datum/wires/proc/always_reveal_wire(color)
	return FALSE

/**
 * Gets how many wires this user's associated skill reveals.
 *
 * Familiar: 15%; Trained: 35%; Professional: 65%.
 * Arguments:
 * * user - The mob to check when deciding how many wires to reveal.
 */
/datum/wires/proc/get_skill_revealed_wire_count(mob/user)
	if(random || !associated_skill || !LAZYLEN(colors) || !user)
		return 0

	var/skill_level = GET_SKILL_LEVEL(user, associated_skill)
	if(isnull(skill_level))
		skill_level = SKILL_LEVEL_UNFAMILIAR

	// If you're trained in various electromechanical biz, you can probably suss out at least some basics.
	var/has_electromech_proficiency = (GET_SKILL_LEVEL(user, ELECTRICAL_ENGINEERING_SKILL_COMPONENT) >= SKILL_LEVEL_TRAINED && GET_SKILL_LEVEL(user, MECHANICAL_ENGINEERING_SKILL_COMPONENT) >= SKILL_LEVEL_TRAINED)
	var/reveal_percent = 0
	if(skill_level >= SKILL_LEVEL_PROFESSIONAL)
		reveal_percent = 75
	else if(skill_level >= SKILL_LEVEL_TRAINED)
		reveal_percent = 50
	else if(skill_level >= SKILL_LEVEL_FAMILIAR || has_electromech_proficiency)
		reveal_percent = 30
	else
		return 0

	return clamp(round(LAZYLEN(colors) * reveal_percent / 100), 0, LAZYLEN(colors))

/datum/wires/proc/get_skill_revealed_colors(var/reveal_count)
	if(reveal_count <= 0 || random || !LAZYLEN(colors))
		return null

	var/reveal_key = skill_reveal_key ? skill_reveal_key : (dictionary_key ? dictionary_key : holder_type)
	var/list/skill_reveal_order = GLOB.wire_skill_reveal_directory[reveal_key]
	var/rebuild_order = !skill_reveal_order || length(skill_reveal_order) != LAZYLEN(colors)
	if(!rebuild_order)
		for(var/color in skill_reveal_order)
			if(!(color in colors))
				rebuild_order = TRUE
				break

	if(rebuild_order)
		skill_reveal_order = list()
		for(var/color in colors)
			skill_reveal_order += color
		skill_reveal_order = shuffle(skill_reveal_order)
		GLOB.wire_skill_reveal_directory[reveal_key] = skill_reveal_order

	return skill_reveal_order.Copy(1, reveal_count + 1)

/datum/wires/ui_host()
	return holder

/datum/wires/ui_status(mob/user)
	if(interactable(user))
		return ..()
	return UI_CLOSE

/datum/wires/ui_state(mob/user)
	return GLOB.physical_state


/datum/wires/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Wires", "[capitalize(holder.name)] Wires")
		ui.open()

/datum/wires/ui_data(mob/user)
	var/list/data = list()
	var/list/payload = list()
	var/reveal_all = can_reveal_wires(user)
	var/list/skill_revealed_colors
	if(!reveal_all)
		skill_revealed_colors = get_skill_revealed_colors(get_skill_revealed_wire_count(user))

	for(var/color in colors)
		var/wire_label = null
		if(reveal_all || always_reveal_wire(color) || (skill_revealed_colors && (color in skill_revealed_colors)))
			wire_label = is_dud_color(color) ? "None" : get_wire(color)

		payload.Add(list(list(
			"color" = color,
			"wire" = wire_label,
			"cut" = is_color_cut(color),
			"attached" = is_attached(color)
		)))
	data["manufacturer"] = manufacturer
	data["wires"] = payload
	data["status"] = get_status()
	data["proper_name"] = (proper_name != "Unknown") ? proper_name : null
	data["tamper_resistance"] = FALSE
	if(random)
		data["tamper_resistance"] = TRUE
	return data

/datum/wires/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || !interactable(usr))
		return

	var/mob/living/L = usr
	var/target_wire = params["wire"]
	switch(action)
		if("attach")
			// Attach
			if(!is_attached(target_wire))
				var/obj/item/assembly/signaler/I = L.get_type_in_hands(/obj/item/assembly/signaler)
				if(!istype(I))
					to_chat(usr, SPAN_WARNING("You do not have a signaler to attach!"))
					return
				usr.drop_from_inventory(I)
				if(!attach_assembly(target_wire, I))
					I.forceMove(get_turf(L))
				. = TRUE
			// Detach
			else
				var/obj/item/O = detach_assembly(target_wire)
				if(O)
					L.put_in_hands(O)
					. = TRUE

		if("cut") // Toggles the cut/mend status
			var/obj/item/I = L.get_active_hand()
			if(!I || !I.tool_behaviour == TOOL_WIRECUTTER)
				if(isrobot(L))
					var/mob/living/silicon/robot/R = L
					I = R.return_wirecutter()
				else
					I = L.get_inactive_hand()
			if(I?.tool_behaviour == TOOL_WIRECUTTER)
				cut_color(target_wire, source = L)
				holder.add_hiddenprint(L)
				I.play_tool_sound(holder, 50)
				. = TRUE
			else
				to_chat(L, SPAN_WARNING("You need wirecutters!"))

		if("pulse")
			var/obj/item/I = L.get_active_hand()
			if(!I || !I.tool_behaviour == TOOL_MULTITOOL)
				if(isrobot(L))
					var/mob/living/silicon/robot/R = L
					I = R.return_multitool()
				else
					I = L.get_inactive_hand()
			if(I?.tool_behaviour == TOOL_MULTITOOL)
				pulse_color(target_wire, L)
				holder.add_hiddenprint(L)
				. = TRUE
			else
				to_chat(L, SPAN_WARNING("You need a multitool!"))

#undef MAXIMUM_EMP_WIRES
