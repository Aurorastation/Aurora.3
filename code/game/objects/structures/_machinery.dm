/*
Overview:
	Used to create objects that need a per step proc call.  Default definition of 'New()'
	stores a reference to src machine in global 'machines list'.  Default definition
	of 'Del' removes reference to src machine in global 'machines list'.

Class Variables:
	use_power (num)
		current state of auto power use.
		Possible Values:
			0 -- no auto power use
			1 -- machine is using power at its idle power level
			2 -- machine is using power at its active power level

	active_power_usage (num)
		Value for the amount of power to use when in active power mode

	idle_power_usage (num)
		Value for the amount of power to use when in idle power mode

	power_channel (num)
		What channel to draw from when drawing power for power mode
		Possible Values:
			AREA_USAGE_EQUIP:0 -- Equipment Channel
			AREA_USAGE_LIGHT:2 -- Lighting Channel
			AREA_USAGE_ENVIRON:3 -- Environment Channel

	component_parts (list)
		A list of component parts of machine used by frame based machines.

	panel_open (num)
		Whether the panel is open

	uid (num)
		Unique id of machine across all machines.

	gl_uid (global num)
		Next uid value in sequence

	stat (bitflag)
		Machine status bit flags.
		Possible bit flags:
			BROKEN:1 -- Machine is broken
			NOPOWER:2 -- No power is being supplied to machine.
			POWEROFF:4 -- tbd
			MAINT:8 -- machine is currently under going maintenance.
			EMPED:16 -- temporary broken by EMP pulse

Class Procs:
	New()                     'game/machinery/machine.dm'

	Destroy()                     'game/machinery/machine.dm'

	powered(chan = AREA_USAGE_EQUIP)         'modules/power/power_usage.dm'
		Checks to see if area that contains the object has power available for power
		channel given in 'chan'.

	use_power_oneoff(amount, chan=AREA_USAGE_EQUIP, autocalled)   'modules/power/power_usage.dm'
		Deducts 'amount' from the power channel 'chan' of the area that contains the object.
		This is not a continuous draw, but rather will be cleared after one APC update.

	power_change()               'modules/power/power_usage.dm'
		Called by the area that contains the object when ever that area under goes a
		power state change (area runs out of power, or area channel is turned off).

	RefreshParts()               'game/machinery/machine.dm'
		Called to refresh the variables in the machine that are contributed to by parts
		contained in the component_parts list. (example: glass and material amounts for
		the autolathe)

		Default definition handles power usage only (all parts contribute based on energy_rating).

	assign_uid()               'game/machinery/machine.dm'
		Called by machine to assign a value to the uid variable.

	process()                  'game/machinery/machine.dm'
		Called by the 'master_controller' once per game tick for each machine that is listed in the 'machines' list.


	Compiled by Aygar
*/

/obj/structure/machinery
	name = "machinery"
	icon = 'icons/obj/stationobjs.dmi'
	init_flags = INIT_MACHINERY_PROCESS_SELF
	pass_flags_self = PASSMACHINE | LETPASSCLICKS
	destroy_sound = 'sound/effects/meteorimpact.ogg'
	hitsound = 'sound/effects/metalhit.ogg'

	/**
	 * 'stat' = 'state'. Controlled by a bitflag, differentiates between a few different possible states including the machine being broken or unpowered.
	 * These definitions are copypasted from 'code/__DEFINES/machinery.dm' so they can be easily referenced in code.
	 * SO THAT MEANS IF THEY'VE BEEN UPDATED THERE, MAKE SURE THEY'RE UPDATED HERE!
	 *
	 * #define BROKEN   0x1
	 * #define NOPOWER  0x2
	 * #define POWEROFF 0x4  // TBD.
	 * #define MAINT    0x8  // Under maintenance.
	 * #define EMPED    0x10 // Temporary broken by EMP pulse.
	 *
	 * #define INOPERABLE(machine)  (machine.stat & (BROKEN|NOPOWER|MAINT|EMPED))
	 * #define OPERABLE(machine)    !INOPERABLE(machine)
	 */
	var/stat = 0
	/// Is this machine emagged?
	var/emagged = 0
	/// Bitfield of physical currencies this machine accepts. See `code/__DEFINES/economy.dm`.
	var/accepted_currencies = CURRENCY_CREDITS

	/// In what power state is this machine? Possible states include being off, idle, or active - see code/__defines/machinery.dm.
	/// You should not be modifying this directly! Use the procs in power_usage.dm.
	var/use_power = POWER_USE_IDLE
	var/internal = FALSE
	/// How much power should this be drawing in the idle power state?
	var/idle_power_usage = 0
	/// How much power should this be drawing in the active power state?
	var/active_power_usage = 0
	var/power_init_complete = FALSE
	/// What power channel does this fall under in APCs? Possible channels include: AREA_USAGE_EQUIP, AREA_USAGE_ENVIRON or AREA_USAGE_LIGHT
	var/power_channel = AREA_USAGE_EQUIP
	/**
	 * List of types that should be spawned as component_parts for this machine.
	 * Structure:
	 *     type -> num_objects
	 *
	 * num_objects is optional, and will be treated as 1 if omitted.
	 *
	 * example:
	 * 	component_types = list(
	 * 		/obj/foo/bar,
	 * 		/obj/baz = 2
	 * 		)
	 **/
	var/list/component_types
	/// List of all the parts used to build it, if made from certain kinds of frames.
	var/list/component_parts = null
	/// Use the generic power rating mechanics for parts, or bespoke.
	var/parts_power_mgmt = TRUE
	/// The total power rating of all parts serves as a power usage multiplier.
	var/parts_power_usage = 0
	/// Whether a mapped instance of this machine should persist its stock part upgrades between rounds.
	var/persistent_parts = TRUE
	/// Original map location used to associate this machine with its persistent parts. Runtime-created machines leave this null.
	var/tmp/persistent_parts_id
	/// Saved stock parts data supplied by the persistence type before atom initialization.
	var/tmp/list/persistent_parts_content
	/// Whether this machine has had its stock parts upgraded or loaded from persistence.
	var/tmp/persistent_parts_upgraded = FALSE
	/// IRL day index (since 2000-01-01) when this machine's persistent parts were last upgraded or decay-checked.
	var/tmp/persistent_parts_saved_day
	/// IRL timeofday (deciseconds since 00:00 UTC) when this machine's persistent parts were last upgraded or decay-checked.
	var/tmp/persistent_parts_saved_timeofday
	/// IRL day index captured when persistence initialization supplied saved data.
	var/tmp/persistent_parts_load_day
	/// IRL timeofday captured when persistence initialization supplied saved data.
	var/tmp/persistent_parts_load_timeofday

	var/uid
	var/panel_open = 0
	var/global/gl_uid = 1
	/// Can the machine be interacted with while de-powered?
	var/interact_offline = FALSE
	/// Is this machine currently printing anything?
	var/printing = FALSE
	/// Component parts queued for processing by the machine. Expected type: `/obj/item/stock_parts` Unused currently.
	var/list/processing_parts

	/// Bitflag. What is being processed. One of `MACHINERY_PROCESS_*`.
	var/processing_flags

	/// Played sound on usage.
	var/clicksound
	/// Volume.
	var/clickvol = 40
	/// Signaller attached to the machine
	var/obj/item/assembly/signaler/signaler
	/// Overmap sector the machine is linked to
	var/obj/effect/overmap/visitable/linked

	/**
	 * Manufacturer of this machine. Used for TGUI themes, when you have a base type and subtypes with different themes (like the coffee machine).
	 * Pass the manufacturer in ui_data and then use it in the UI.
	 */
	var/manufacturer = null

	///Do we want to hook into on_enter_area and on_exit_area?
	///Disables some optimizations
	var/always_area_sensitive = FALSE
	/// Whether Alt-clicking this machine attempts to link a PDA carried or worn by the user.
	var/pda_linkable = FALSE

/obj/structure/machinery/mechanics_hints(mob/user, distance, is_adjacent)
	. = ..()
	if(pda_linkable)
		. += "Alt-click this machine to link or unlink an available modular computer."

/obj/structure/machinery/feedback_hints(mob/user, distance, is_adjacent)
	. = list()
	if(signaler && is_adjacent)
		. += SPAN_WARNING("\The [src] has a hidden signaler attached to it. You might or might not notice this.")
	// Still needs some work- must be able to be distinguish between thinobjectsgs that are anchored that can be casually
	// unanchored (i.e. vending machines) vs. objects that are anchored but require other steps to unanchor (i.e. airlocks).
	/*
	if(anchored)
		. += SPAN_NOTICE("\The [src] is anchored to the floor by a couple of <b>bolts</b>.")
	*/

/obj/structure/machinery/Initialize(mapload, d = 0, populate_components = TRUE, is_internal = FALSE)
	//Stupid macro used in power usage
	CAN_BE_REDEFINED(TRUE)

	. = ..()
	if(d)
		set_dir(d)

	if(init_flags & INIT_MACHINERY_PROCESS_ALL)
		START_PROCESSING_MACHINE(src, init_flags & INIT_MACHINERY_PROCESS_ALL)
	SSmachinery.machinery += src // All machines should be in machinery.

	var/turf/T = get_turf(src)
	if(mapload && T && is_station_level(T.z) && has_ranked_component_types())
		persistent_parts_id = "[T.x]-[T.y]-[T.z]-[type]"

	if (populate_components && component_types)
		component_parts = list()
		for (var/type in component_types)
			var/count = component_types[type]
			if(ispath(type, /obj/item/stack))
				if(isnull(count))
					count = 1
				component_parts += new type(src, count)
			else
				if(count > 1)
					for (var/i in 1 to count)
						component_parts += new type(src)
				else
					component_parts += new type(src)

		apply_persistent_parts()

		if(component_parts.len)
			RefreshParts()

	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/Destroy()
	//Stupid macro used in power usage
	CAN_BE_REDEFINED(TRUE)

	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_ALL)
	SSmachinery.machinery -= src

	//Clear the component parts
	//If the components are inside the machine, delete them, otherwise we assume they were dropped to the ground during deconstruction,
	//and were not removed from the component_parts list by deconstruction code
	if(component_parts)
		for(var/atom/A in component_parts)
			if(A.loc == src)
				qdel(A)
	component_parts = null

	return ..()

/obj/structure/machinery/on_death(damage, damage_flags, damage_type, armor_penetration, obj/weapon)
	var/turf/current_turf = get_turf(src)
	spark(current_turf, 3, GLOB.alldirs)
	if(component_parts)
		for(var/obj/item/stock_parts/part in component_parts)
			if(prob(25))
				part.forceMove(current_turf)
				component_parts -= part
		var/obj/item/circuitboard/board = locate() in component_parts
		if(istype(board))
			if(prob(25))
				board.forceMove(current_turf)
				component_parts -= board
			else
				new /obj/item/trash/broken_electronics(current_turf)
	var/metal_to_spawn = 0
	for(var/i = 1 to 2)
		if(prob(50))
			metal_to_spawn++
		else
			new /obj/item/material/shard(current_turf, MATERIAL_STEEL)
	if(metal_to_spawn)
		new /obj/item/stack/material/steel(get_turf(src), metal_to_spawn)
	if(!should_use_health)
		return FALSE
	qdel(src)

/obj/structure/machinery/examine_descriptor(mob/user)
	return "machine"

// /obj/structure/machinery/proc/process_all()
// 	/* Uncomment this if/when you need component processing
// 	if(processing_flags & MACHINERY_PROCESS_COMPONENTS)
// 		for(var/thing in processing_parts)
// 			var/obj/item/stock_parts/part = thing
// 			if(part.machine_process(src) == PROCESS_KILL)
// 				part.stop_processing() */

// 	if((processing_flags & MACHINERY_PROCESS_SELF))
// 		. = process()
// 		if(. == PROCESS_KILL)
// 			STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/structure/machinery/process(seconds_per_tick)
	return PROCESS_KILL

/obj/structure/machinery/emp_act(severity)
	. = ..()
	if(use_power && stat == 0)
		use_power_oneoff(7500/severity)

		var/obj/effect/overlay/pulse2 = new(src.loc)
		pulse2.icon = 'icons/effects/effects.dmi'
		pulse2.icon_state = "empdisable"
		pulse2.name = "emp sparks"
		pulse2.anchored = 1
		pulse2.set_dir(pick(GLOB.cardinals))

		QDEL_IN(pulse2, 10)

/**
 * Check to see if the machine is operable
 *
 * * `additional_flags` - Additional flags to check for, that could have been added to the `stat` variable
 *
 * Returns `TRUE` if the machine is operable, `FALSE` otherwise
 */
/obj/structure/machinery/proc/operable(additional_flags = 0)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)

	if(stat & (NOPOWER|BROKEN|additional_flags))
		return FALSE
	else
		return TRUE

/obj/structure/machinery/proc/toggle_power(power_set = -1, additional_flags = 0)
	if(power_set >= 0)
		update_use_power(power_set)
	else if (use_power || !operable(additional_flags))
		update_use_power(POWER_USE_OFF)
	else
		update_use_power(initial(use_power))

	update_icon()

/obj/structure/machinery/CanUseTopic(mob/user)
	if(stat & BROKEN)
		return STATUS_CLOSE

	if(!interact_offline && (stat & NOPOWER))
		return STATUS_CLOSE

	return ..()

/obj/structure/machinery/CouldUseTopic(mob/user)
	..()
	if(clicksound && iscarbon(user))
		playsound(src, clicksound, clickvol)
	user.set_machine(src)

/obj/structure/machinery/CouldNotUseTopic(mob/user)
	user.unset_machine()

////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/machinery/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	if(isrobot(user))
		// For some reason attack_robot doesn't work
		// This is to stop robots from using cameras to remotely control machines.
		if(user.client && user.client.eye == user)
			return src.attack_hand(user)
	else
		return src.attack_hand(user)

/obj/structure/machinery/AltClick(mob/user)
	if(!pda_linkable)
		return ..()
	if(!user.TurfAdjacent(get_turf(src)))
		return FALSE

	var/obj/item/modular_computer/pda = user.get_pda_for_linking()
	if(!pda)
		to_chat(user, SPAN_WARNING("You do not have a PDA available to link."))
		return TRUE

	user.visible_message(
		SPAN_NOTICE("\The [user] swipes \the [pda] over \the [src]."),
		SPAN_NOTICE("You swipe \the [pda] over \the [src]."),
		range = 3
	)
	add_fingerprint(user)
	return toggle_pda_link(pda, user)

/// Toggles a PDA's connection to this machine. PDA-linkable machinery should override this.
/obj/structure/machinery/proc/toggle_pda_link(obj/item/modular_computer/pda, mob/user)
	return FALSE

/// Returns the label shown for a linked PDA, including the wearer's ID when the PDA has no inserted ID.
/obj/structure/machinery/proc/get_pda_link_name(obj/item/modular_computer/pda, mob/user)
	. = pda.name
	if(pda.card_slot?.stored_card || !ishuman(user))
		return

	var/mob/living/carbon/human/human_user = user
	var/obj/item/card/id/worn_id = human_user.wear_id?.GetID()
	if(worn_id?.registered_name)
		. += " ([worn_id.registered_name])"

/obj/structure/machinery/attack_hand(mob/user)
	if(!operable(MAINT))
		return TRUE
	if(user.lying || user.stat)
		return TRUE
	if (!istype(usr, /mob/living/carbon/human) && !istype(usr, /mob/living/silicon))
		to_chat(usr, SPAN_WARNING("You don't have the dexterity to do this!"))
		return TRUE

	src.add_fingerprint(user)

	return ..()

/obj/structure/machinery/attack_ranged(mob/user, params)
	if(..())
		return TRUE
	if(isipc(user))
		var/mob/living/carbon/human/robot = user
		var/obj/item/organ/internal/machine/wireless_access/wireless_access_point = robot.internal_organs_by_name[BP_WIRELESS_ACCESS]
		if(wireless_access_point?.access_terminal(src))
			attack_hand(user)
			return TRUE

/obj/structure/machinery/attackby(obj/item/attacking_item, mob/user)
	if(default_part_replacement(user, attacking_item))
		return TRUE

	if(obj_flags & OBJ_FLAG_SIGNALER)
		if(issignaler(attacking_item))
			if(signaler)
				to_chat(user, SPAN_WARNING("\The [src] already has a signaler attached."))
				return TRUE
			var/obj/item/assembly/signaler/S = attacking_item
			user.drop_from_inventory(attacking_item, src)
			signaler = S
			S.machine = src
			user.visible_message("<b>[user]</b> attaches \the [S] to \the [src].", SPAN_NOTICE("You attach \the [S] to \the [src]."), range = 3)
			log_and_message_admins("has attached a signaler to \the [src].", user, get_turf(src))
			return TRUE
		else if(attacking_item.tool_behaviour == TOOL_WIRECUTTER && signaler)
			user.visible_message("<b>[user]</b> removes \the [signaler] from \the [src].", SPAN_NOTICE("You remove \the [signaler] from \the [src]."), range = 3)
			user.put_in_hands(detach_signaler())
			return TRUE
	return ..()

/obj/structure/machinery/proc/detach_signaler(var/turf/detach_turf)
	if(!signaler)
		return

	if(!detach_turf)
		detach_turf = get_turf(src)
	if(!detach_turf)
		LOG_DEBUG("[src] tried to drop a signaler, but it had no turf ([src.x]-[src.y]-[src.z])")
		return

	var/obj/item/assembly/signaler/S = signaler

	signaler.forceMove(detach_turf)
	signaler.machine = null
	signaler = null

	return S

/obj/structure/machinery/proc/RefreshParts()
	/*
	if(parts_power_mgmt)
		var/new_idle_power
		var/new_active_power

		if(!component_parts || !component_parts.len)
			return
		var/parts_energy_rating = 0

		for(var/obj/item/stock_parts/part in component_parts)
			parts_energy_rating += part.energy_rating()

		new_idle_power = initial(idle_power_usage) * (1 + parts_energy_rating)
		new_active_power = initial(active_power_usage) * (1 + parts_energy_rating)

		change_power_consumption(new_idle_power)
		change_power_consumption(new_active_power, POWER_USE_ACTIVE)
	*/

/obj/structure/machinery/proc/assign_uid()
	uid = gl_uid
	gl_uid++

/obj/structure/machinery/proc/state(var/msg)
	for(var/mob/O in hearers(src, null))
		O.show_message("[icon2html(src, O)] <span class = 'notice'>[msg]</span>", 2)

/obj/structure/machinery/proc/ping(text=null)
	if (!text)
		text = "\The [src] pings."

	state(text, "blue")
	playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)

/obj/structure/machinery/proc/pingx3(text=null)
	if (!text)
		text = "\The [src] pings."

	state(text, "blue")
	playsound(src.loc, 'sound/machines/pingx3.ogg', 50, 0)

/obj/structure/machinery/proc/buzz(text=null)
	if (!text)
		text = "\The [src] buzzes."

	state(text, "blue")
	playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0) //TODO: Check if that one is the correct sound

/obj/structure/machinery/proc/shock(mob/user, prb)
	if(!operable())
		return 0
	if(!prob(prb))
		return 0
	spark(src, 5, GLOB.alldirs)
	if (electrocute_mob(user, get_area(src), src, 0.7))
		var/area/temp_area = get_area(src)
		if(temp_area)
			var/obj/structure/machinery/power/apc/temp_apc = temp_area.get_apc()

			if(temp_apc && temp_apc.terminal && temp_apc.terminal.powernet)
				temp_apc.terminal.powernet.trigger_warning()
		if(user.stunned)
			return 1
	return 0

/obj/structure/machinery/proc/default_deconstruction_crowbar(var/mob/user, var/obj/item/C)
	if(!istype(C) || C.tool_behaviour != TOOL_CROWBAR)
		return 0
	if(!panel_open)
		return 0
	. = dismantle()

/obj/structure/machinery/proc/default_deconstruction_screwdriver(var/mob/user, var/obj/item/S)
	if(!istype(S) || S.tool_behaviour != TOOL_SCREWDRIVER)
		return FALSE
	S.play_tool_sound(get_turf(src), 50)
	panel_open = !panel_open
	to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance hatch of [src]."))
	update_icon()
	return TRUE

/obj/structure/machinery/proc/get_part_replacement_type(obj/item/part)
	var/obj/item/circuitboard/board = locate(/obj/item/circuitboard) in component_parts
	var/replacement_type

	if(board?.req_components)
		for(var/component_type in board.req_components)
			var/board_part_type = ispath(component_type) ? component_type : text2path(component_type)
			if(!ispath(board_part_type, /obj/item/stock_parts) && !ispath(board_part_type, /obj/item/reagent_containers/glass))
				continue
			if(istype(part, board_part_type) && (!replacement_type || ispath(board_part_type, replacement_type)))
				replacement_type = board_part_type

	if(replacement_type)
		return replacement_type

	for(var/component_type in component_types)
		var/component_part_type = ispath(component_type) ? component_type : text2path(component_type)
		if(!ispath(component_part_type, /obj/item/stock_parts) && !ispath(component_part_type, /obj/item/reagent_containers/glass))
			continue
		if(istype(part, component_part_type) && (!replacement_type || ispath(component_part_type, replacement_type)))
			replacement_type = component_part_type

	return replacement_type

/obj/structure/machinery/proc/has_ranked_component_types()
	if(!persistent_parts || !LAZYLEN(component_types))
		return FALSE
	for(var/component_type in component_types)
		if(is_ranked_stock_part_path(component_type))
			return TRUE
	return FALSE

/** Applies persistent upgraded parts supplied before initialization and decays their ratings by 1.0 per IRL day down to 0.5. */
/obj/structure/machinery/proc/apply_persistent_parts()
	if(!persistent_parts_id || !islist(persistent_parts_content) || !LAZYLEN(component_parts))
		persistent_parts_content = null
		return

	var/list/saved_parts = persistent_parts_content["parts"]
	if(!islist(saved_parts) || !length(saved_parts))
		persistent_parts_content = null
		return

	var/current_day = isnum(persistent_parts_load_day) ? persistent_parts_load_day : get_current_irl_day()
	var/current_timeofday = isnum(persistent_parts_load_timeofday) ? persistent_parts_load_timeofday : world.timeofday
	var/saved_day = persistent_parts_content["saved_day"]
	var/saved_timeofday = persistent_parts_content["saved_timeofday"]

	var/elapsed_days = 0
	if(isnum(saved_day) && isnum(saved_timeofday))
		elapsed_days = max(0, get_elapsed_irl_days(saved_day, saved_timeofday, current_day, current_timeofday))

	var/decay_amount = round(elapsed_days * STOCK_PART_DAILY_DECAY, 0.01)
	if(decay_amount > 0 || !isnum(saved_day) || !isnum(saved_timeofday))
		persistent_parts_saved_day = current_day
		persistent_parts_saved_timeofday = current_timeofday
	else
		persistent_parts_saved_day = saved_day
		persistent_parts_saved_timeofday = saved_timeofday

	var/list/remaining_saved_parts = saved_parts.Copy()
	var/applied_any = FALSE

	for(var/i in 1 to length(component_parts))
		var/obj/item/stock_parts/existing_part = component_parts[i]
		if(!istype(existing_part) || !existing_part.ranked_part)
			continue

		var/replacement_base_type = get_part_replacement_type(existing_part)
		if(!replacement_base_type)
			continue

		var/match_index = 0
		for(var/j in 1 to length(remaining_saved_parts))
			var/list/entry = remaining_saved_parts[j]
			if(!islist(entry))
				continue
			var/obj/item/stock_parts/saved_type = ispath(entry["type"]) ? entry["type"] : text2path(entry["type"])
			if(!is_ranked_stock_part_path(saved_type) || !ispath(saved_type, replacement_base_type))
				continue
			match_index = j
			break

		if(!match_index)
			continue

		var/list/matched_entry = remaining_saved_parts[match_index]
		remaining_saved_parts.Cut(match_index, match_index + 1)

		var/obj/item/stock_parts/saved_type = ispath(matched_entry["type"]) ? matched_entry["type"] : text2path(matched_entry["type"])
		var/saved_rating = isnum(matched_entry["rating"]) ? matched_entry["rating"] : initial(saved_type.rating)
		var/decayed_rating = max(STOCK_PART_MIN_RATING, round(saved_rating - decay_amount, 0.01))

		if(existing_part.type != saved_type)
			var/obj/item/stock_parts/new_part = new saved_type(src)
			new_part.set_rating(decayed_rating)
			component_parts[i] = new_part
			qdel(existing_part)
		else
			existing_part.set_rating(decayed_rating)

		applied_any = TRUE

	if(applied_any)
		persistent_parts_upgraded = TRUE
	persistent_parts_content = null

/obj/structure/machinery/proc/has_persistent_part_changes()
	if(!LAZYLEN(component_parts) || !LAZYLEN(component_types))
		return FALSE

	var/list/expected_counts = list()
	for(var/component_type in component_types)
		var/path = ispath(component_type) ? component_type : text2path(component_type)
		if(!is_ranked_stock_part_path(path))
			continue
		var/count = component_types[component_type]
		if(!isnum(count) || count < 1)
			count = 1
		expected_counts[path] = (expected_counts[path] || 0) + count

	var/list/actual_counts = list()
	for(var/obj/item/stock_parts/part in component_parts)
		if(!part.ranked_part)
			continue
		if(round(part.rating, 0.01) != initial(part.rating))
			return TRUE
		actual_counts[part.type] = (actual_counts[part.type] || 0) + 1

	if(length(expected_counts) != length(actual_counts))
		return TRUE

	for(var/path in expected_counts)
		if(actual_counts[path] != expected_counts[path])
			return TRUE

	return FALSE

/obj/structure/machinery/proc/get_persistent_parts_data()
	if(!persistent_parts || !persistent_parts_id || !persistent_parts_upgraded || !LAZYLEN(component_parts))
		return null
	if(!has_persistent_part_changes())
		return null

	var/list/saved_parts = list()
	for(var/obj/item/stock_parts/part in component_parts)
		if(!part.ranked_part)
			continue
		saved_parts += list(list(
			"type" = "[part.type]",
			"rating" = round(part.rating, 0.01)
		))

	if(!length(saved_parts))
		return null

	return list(
		"saved_day" = isnum(persistent_parts_saved_day) ? persistent_parts_saved_day : get_current_irl_day(),
		"saved_timeofday" = isnum(persistent_parts_saved_timeofday) ? persistent_parts_saved_timeofday : world.timeofday,
		"parts" = saved_parts
	)

/obj/structure/machinery/proc/default_part_replacement(var/mob/user, var/obj/item/storage/part_replacer/R)
	if(!LAZYLEN(component_parts))
		return FALSE
	else if(istype(R))
		var/parts_replaced = FALSE
		var/ranked_parts_replaced = FALSE
		if(panel_open)
			for(var/obj/item/reagent_containers/glass/G in component_parts)
				var/replacement_type = get_part_replacement_type(G)
				if(!replacement_type)
					continue
				for(var/obj/item/reagent_containers/glass/B in R.contents)
					if(B.reagents && B.reagents.total_volume > 0) continue
					if(istype(B, replacement_type))
						if(B.volume > G.volume)
							R.remove_from_storage(B, src)
							R.handle_item_insertion(G, 1)
							component_parts -= G
							component_parts += B
							B.forceMove(src)
							to_chat(user, SPAN_NOTICE("[G.name] replaced with [B.name]."))
							parts_replaced = TRUE
							break
			for(var/obj/item/stock_parts/A in component_parts)
				var/replacement_type = get_part_replacement_type(A)
				if(!replacement_type)
					continue
				var/obj/item/stock_parts/best_part
				for(var/obj/item/stock_parts/B in R.contents)
					if(istype(B, replacement_type) && B.rating > A.rating)
						if(!best_part || B.rating > best_part.rating)
							best_part = B
				if(best_part)
					R.remove_from_storage(best_part, src)
					R.handle_item_insertion(A, 1)
					component_parts -= A
					component_parts += best_part
					best_part.forceMove(src)
					to_chat(user, SPAN_NOTICE("[A.name] replaced with [best_part.name]."))
					parts_replaced = TRUE
					if(A.ranked_part || best_part.ranked_part)
						ranked_parts_replaced = TRUE
			if(ranked_parts_replaced && persistent_parts_id)
				persistent_parts_upgraded = TRUE
				persistent_parts_saved_day = get_current_irl_day()
				persistent_parts_saved_timeofday = world.timeofday
			if(parts_replaced)
				RefreshParts()
				update_icon()
				playsound(src, 'sound/items/rped.ogg', 40, TRUE)
			return TRUE
		else
			to_chat(user, SPAN_NOTICE("The following parts have been detected in \the [src]:"))
			to_chat(user, counting_english_list(component_parts))
	else return FALSE

/obj/structure/machinery/dismantle()
	playsound(loc, SFX_CROWBAR, 50, 1)
	var/obj/structure/machinery/constructable_frame/machine_frame/M = new /obj/structure/machinery/constructable_frame/machine_frame(loc)
	M.set_dir(src.dir)
	M.state = 3
	M.icon_state = "blueprint_1"

	for(var/obj/I in component_parts)
		I.forceMove(loc)
		component_parts -= I

	qdel(src)

	return TRUE

/obj/structure/machinery/proc/print(var/obj/paper, var/play_sound = 1, var/print_sfx = SFX_PRINT, var/print_delay = 10, var/message, var/mob/user)
	if( printing )
		return FALSE

	printing = TRUE

	if (play_sound)
		playsound(src.loc, print_sfx, 50, 1)

	if(!message)
		message = "\The [src] rattles to life and spits out a paper titled [paper]."
	visible_message(SPAN_NOTICE(message))

	addtimer(CALLBACK(src, PROC_REF(print_move_paper), paper, user), print_delay)

	return TRUE

/obj/structure/machinery/proc/print_move_paper(obj/paper, mob/user)
	if(user && ishuman(user) && user.Adjacent(src))
		user.put_in_hands(paper)
	else
		paper.forceMove(loc)
	printing = FALSE

/obj/structure/machinery/proc/do_hair_pull(mob/living/carbon/human/H)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!istype(H))
		return

	//for whatever reason, skrell's tentacles have a really long length
	//horns would not get caught in the machine
	//vaurca have fine control of their antennae
	if(isskrell(H) || isunathi(H) || isvaurca(H))
		return

	var/datum/sprite_accessory/hair/hair_style = GLOB.hair_styles_list[H.h_style]
	for(var/obj/item/protection in list(H.head))
		if(protection && (protection.flags_inv & BLOCKHAIR|BLOCKHEADHAIR))
			return

	if(hair_style.length >= 4 && prob(25))
		H.apply_damage(30, DAMAGE_BRUTE, BP_HEAD)
		H.visible_message(SPAN_DANGER("\The [H]'s hair catches in \the [src]!"),
					SPAN_DANGER("Your hair gets caught in \the [src]!"))
		if(H.can_feel_pain())
			H.emote("scream")
			H.apply_damage(45, DAMAGE_PAIN)

// A late init operation called in SSshuttle for ship computers and holopads, used to attach the thing to the right ship.
/obj/structure/machinery/proc/attempt_hook_up(var/obj/effect/overmap/visitable/sector)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(sector))
		return FALSE
	if(sector.check_ownership(src))
		linked = sector
		return TRUE
	return FALSE

/obj/structure/machinery/proc/sync_linked()
	var/obj/effect/overmap/visitable/sector = get_map_sector(src)
	if(!sector)
		return
	return attempt_hook_up_recursive(sector)

/obj/structure/machinery/proc/attempt_hook_up_recursive(var/obj/effect/overmap/visitable/sector)
	if(attempt_hook_up(sector))
		return sector
	for(var/obj/effect/overmap/visitable/candidate in sector)
		if((. = .(candidate)))
			return

/obj/proc/on_user_login(mob/M)
	return

/obj/structure/machinery/proc/set_emergency_state(var/new_security_level)
	return

/obj/structure/machinery/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	. = ..()
	if(isliving(hitting_atom))
		var/mob/living/M = hitting_atom
		M.turf_collision(src, throwingdatum.speed)
		return
	else
		visible_message(SPAN_DANGER("\The [src] was hit by \the [hitting_atom]."))

/obj/structure/machinery/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(. < UI_INTERACTIVE)
		if(user?.machine)
			user.unset_machine()
