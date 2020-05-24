#define IC_COMPONENTS_BASE 25
#define IC_COMPLEXITY_BASE 75

/obj/item/device/electronic_assembly
	name = "electronic assembly"
	desc = "It's a case, for building small electronics with."
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/assemblies/electronic_setups.dmi'
	icon_state = "setup_small"
	item_flags = NOBLUDGEON
	matter = list()		// To be filled later
	var/list/assembly_components = list()
	var/list/ckeys_allowed_to_scan = list() // Players who built the circuit can scan it as a ghost.
	var/max_components = IC_COMPONENTS_BASE
	var/max_complexity = IC_COMPLEXITY_BASE
	var/opened = FALSE
	var/obj/item/cell/device/battery // Internal cell which most circuits need to work.
	var/cell_type = /obj/item/cell/device
	var/can_charge = TRUE //Can it be charged in a recharger?
	var/circuit_flags = IC_FLAG_ANCHORABLE
	var/charge_sections = 4
	var/charge_delay = 4
	var/ext_next_use = 0
	var/collw
	var/allowed_circuit_action_flags = IC_ACTION_COMBAT | IC_ACTION_LONG_RANGE //which circuit flags are allowed
	var/creator // circuit creator if any
	var/static/next_assembly_id = 0
	var/interact_page = 0
	var/components_per_page = 5
	health = 30
	pass_flags = 0
	anchored = FALSE
	var/detail_color = COLOR_ASSEMBLY_BLACK
	var/list/color_whitelist = list( //This is just for checking that hacked colors aren't in the save data.
		COLOR_ASSEMBLY_BLACK, COLOR_ASSEMBLY_BGRAY,
		COLOR_ASSEMBLY_WHITE, COLOR_ASSEMBLY_RED,
		COLOR_ASSEMBLY_ORANGE, COLOR_ASSEMBLY_BEIGE,
		COLOR_ASSEMBLY_BROWN, COLOR_ASSEMBLY_GOLD,
		COLOR_ASSEMBLY_YELLOW, COLOR_ASSEMBLY_GURKHA,
		COLOR_ASSEMBLY_LGREEN, COLOR_ASSEMBLY_GREEN,
		COLOR_ASSEMBLY_LBLUE, COLOR_ASSEMBLY_BLUE,
		COLOR_ASSEMBLY_PURPLE, COLOR_ASSEMBLY_HOT_PINK
	)

/obj/item/device/electronic_assembly/examine(mob/user)
	. = ..()
	if(IC_FLAG_ANCHORABLE & circuit_flags)
		to_chat(user, "<span class='notice'>The anchoring bolts [anchored ? "are" : "can be"] <b>wrenched</b> in place and the maintenance panel <b>[opened ? "can be" : "is"]</b> screwed in place.</span>")
	else
		to_chat(user, "<span class='notice'>The maintenance panel <b>[opened ? "can be" : "is"]</b> screwed in place.</span>")
	if(health != initial(health))
		if(health <= initial(health)/2)
			to_chat(user,"<span class='warning'>It looks pretty beat up.</span>")
		else
			to_chat(user, "<span class='warning'>Its got a few dents in it.</span>")

	if((isobserver(user) && ckeys_allowed_to_scan[user.ckey]) || check_rights(R_ADMIN, 0, user))
		to_chat(user, "You can <a href='?src=\ref[src];ghostscan=1'>scan</a> this circuit.");


/obj/item/device/electronic_assembly/proc/take_damage(var/amnt)
	health = health - amnt
	if(health <= 0)
		visible_message("<span class='danger'>\The [src] falls to pieces!</span>")
		qdel(src)
	else if(health < initial(health)*0.15 && prob(5))
		visible_message("<span class='danger'>\The [src] starts to break apart!</span>")


/obj/item/device/electronic_assembly/proc/check_interactivity(mob/user)
	return (!user.incapacitated() && CanUseTopic(user))

/obj/item/device/electronic_assembly/GetAccess()
	. = list()
	for(var/obj/item/integrated_circuit/output/O in assembly_components)
		var/o_access = O.GetAccess()
		. |= o_access

/obj/item/device/electronic_assembly/Bump(atom/AM)
	collw = AM
	.=..()
	if(istype(AM, /obj/machinery/door/airlock) ||  istype(AM, /obj/machinery/door/window))
		var/obj/machinery/door/D = AM
		if(D.check_access(src))
			D.open()

/obj/item/device/electronic_assembly/Initialize(mapload, printed = FALSE)
	. = ..()
	if (!printed)
		battery = new(src)
	START_PROCESSING(SSelectronics, src)
	matter[DEFAULT_WALL_MATERIAL] = round((max_complexity + max_components) / 4) * SSelectronics.cost_multiplier

/obj/item/device/electronic_assembly/Destroy()
	STOP_PROCESSING(SSelectronics, src)
	for(var/circ in assembly_components)
		remove_component(circ)
		qdel(circ)
	return ..()

/obj/item/device/electronic_assembly/process()
	// First we generate power.
	for(var/obj/item/integrated_circuit/passive/power/P in assembly_components)
		P.make_energy()

	var/power_failure = FALSE
	if((health / initial(health)) < 0.5 && prob(5))
		visible_message("<span class='warning'>\The [src] shudders and sparks</span>")
		power_failure = TRUE
	// Now spend it.
	for(var/I in assembly_components)
		var/obj/item/integrated_circuit/IC = I
		if(IC.power_draw_idle)
			if(power_failure || !draw_power(IC.power_draw_idle))
				IC.power_fail()

/obj/item/device/electronic_assembly/MouseDrop_T(atom/dropping, mob/user)
	if(user == dropping)
		interact(user)
	else
		..()

/obj/item/device/electronic_assembly/interact(mob/user)
	. = ..()
	if(!check_interactivity(user))
		return

	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "circuits-assembly", 655, 350, name)

	ui.open()

/obj/item/device/electronic_assembly/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		. = data = list()
		
	VUEUI_SET_CHECK(data["name"], name, ., data)
	VUEUI_SET_CHECK(data["size"], return_total_size(), ., data)
	VUEUI_SET_CHECK(data["complexity"], return_total_complexity(), ., data)

	VUEUI_SET_CHECK(data["battery"], battery != null, ., data)
	if(battery)
		VUEUI_SET_CHECK(data["battery_charge"], round(battery.charge, 0.1), ., data)
		VUEUI_SET_CHECK(data["battery_maxcharge"], battery.maxcharge, ., data)
		VUEUI_SET_CHECK(data["battery_percent"], round(battery.percent(), 0.1), ., data)

	VUEUI_SET_CHECK_IFNOTSET(data["max_components"], max_components, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["max_complexity"], max_complexity, ., data)

	LAZYINITLIST(data["components"])

	if(interact_page != data["cur_page"] || LAZYLEN(assembly_components) != LAZYLEN(data["components"]))
		data["components"].Cut()
		var/start_index = ((components_per_page * interact_page) + 1)
		var/list/components_to_show = list()

		for(var/i = start_index to min(length(assembly_components), start_index + (components_per_page - 1)))
			var/obj/item/integrated_circuit/circuit = assembly_components[i]
			// Add adds the contents of a list, so we need to wrap a list in another
			components_to_show.Add(list(list("component" = "\ref[circuit]", 
										"name" = circuit.displayed_name,
										"index" = i,
										"removable" = circuit.removable)))

		VUEUI_SET_CHECK(data["components"], components_to_show, ., data)

		VUEUI_SET_CHECK(data["page_num"], Ceiling(length(assembly_components)/components_per_page), ., data)
		VUEUI_SET_CHECK(data["cur_page"], interact_page, ., data)

/obj/item/device/electronic_assembly/proc/update_interact_page(page)
	interact_page = Clamp(page, 0, Ceiling(length(assembly_components)/components_per_page) - 1)

/obj/item/device/electronic_assembly/proc/try_update_ui(datum/vueui/ui, user)
	if(!istype(ui))
		// UI was updated externally, for example, after attaching a new component
		ui = SSvueui.get_open_ui(user, src)

	// NOTE: Statement above is not guaranteed to actually return valid UI
	if(istype(ui))
		// Constant updates for better experience.
		ui.check_for_change(TRUE)

/obj/item/device/electronic_assembly/Topic(href, href_list, state = interactive_state)
	if(href_list["ghostscan"])
		if((isobserver(usr) && ckeys_allowed_to_scan[usr.ckey]) || check_rights(R_ADMIN,0,usr))
			if(assembly_components.len)
				var/saved = "On circuit printers with cloning enabled, you may use the code below to clone the circuit:<br><br><code>[SSelectronics.save_electronic_assembly(src)]</code>"
				show_browser(usr, saved, "window=circuit_scan;size=500x600;border=1;can_resize=1;can_close=1;can_minimize=1")
			else
				to_chat(usr, "<span class='warning'>The circuit is empty!</span>")
		return TOPIC_NOACTION

	if(isobserver(usr))
		return TOPIC_NOACTION

	if(!check_interactivity(usr))
		return TOPIC_NOACTION

	. = TOPIC_HANDLED

	// VueUI seems to be unable to send json with a parameter of 0 within it
	// So we have to send 1-based indices and subtract 1 here
	if(href_list["select_page"])
		update_interact_page(text2num(href_list["select_page"]) - 1)
		. = TOPIC_REFRESH

	if(href_list["rename"])
		rename(usr)
		. = TOPIC_REFRESH

	if(href_list["remove_cell"])
		if(!battery)
			to_chat(usr, "<span class='warning'>There's no power cell to remove from \the [src].</span>")
		else
			usr.put_in_hands(battery)
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			to_chat(usr, "<span class='notice'>You pull \the [battery] out of \the [src]'s power supplier.</span>")
			battery = null
		. = TOPIC_REFRESH

	if(href_list["component"])
		var/obj/item/integrated_circuit/component = locate(href_list["component"]) in assembly_components
		if(component)
			// Builtin components are not supposed to be removed or rearranged
			if(!component.removable)
				return TOPIC_NOACTION

			add_allowed_scanner(usr.ckey)

			var/current_pos = assembly_components.Find(component)

			if(href_list["remove"])
				try_remove_component(component, usr)
				. = TOPIC_REFRESH

			else if(href_list["set_slot"])
				var/selected_slot = input("Select a new slot", "Select slot", current_pos) as null|num
				if(!check_interactivity(usr))
					return TOPIC_NOACTION
				if(selected_slot < 1 || selected_slot > length(assembly_components))
					return TOPIC_NOACTION

				assembly_components.Remove(component)
				assembly_components.Insert(selected_slot, component)
				. = TOPIC_REFRESH

	if (. == TOPIC_REFRESH)
		var/datum/vueui/ui = href_list["vueui"]
		try_update_ui(ui, usr)

/obj/item/device/electronic_assembly/proc/rename()
	var/mob/M = usr
	if(!check_interactivity(M))
		return
	var/input = input("What do you want to name this?", "Rename", src.name) as null|text
	input = sanitizeName(input,allow_numbers = 1)
	if(!check_interactivity(M))
		return
	if(!QDELETED(src) && input)
		to_chat(M, "<span class='notice'>The machine now has a label reading '[input]'.</span>")
		name = input
		var/datum/vueui/ui = SSvueui.get_open_ui(usr, src)
		if(ui)
			ui.title = name
			try_update_ui(null, usr)

/obj/item/device/electronic_assembly/proc/add_allowed_scanner(ckey)
	ckeys_allowed_to_scan[ckey] = TRUE

/obj/item/device/electronic_assembly/proc/can_move()
	return FALSE

/obj/item/device/electronic_assembly/update_icon()
	if(opened)
		icon_state = initial(icon_state) + "-open"
	else
		icon_state = initial(icon_state)
	overlays.Cut()
	if(detail_color == COLOR_ASSEMBLY_BLACK) //Black colored overlay looks almost but not exactly like the base sprite, so just cut the overlay and avoid it looking kinda off.
		return
	var/image/detail_overlay = image('icons/obj/assemblies/electronic_setups.dmi', src,"[icon_state]-color")
	detail_overlay.color = detail_color
	overlays += detail_overlay

/obj/item/device/electronic_assembly/examine(mob/user)
	. = ..()
	for(var/I in assembly_components)
		var/obj/item/integrated_circuit/IC = I
		IC.external_examine(user)
		// This gets really annoying on more complex assemblies
		//if(opened)
		//	IC.internal_examine(user)
	if(opened)
		interact(user)

//This only happens when this EA is loaded via the printer
/obj/item/device/electronic_assembly/proc/post_load()
	for(var/I in assembly_components)
		var/obj/item/integrated_circuit/IC = I
		IC.on_data_written()

/obj/item/device/electronic_assembly/proc/return_total_complexity()
	. = 0
	var/obj/item/integrated_circuit/part
	for(var/p in assembly_components)
		part = p
		. += part.complexity

/obj/item/device/electronic_assembly/proc/return_total_size()
	. = 0
	var/obj/item/integrated_circuit/part
	for(var/p in assembly_components)
		part = p
		. += part.size

// Returns true if the circuit made it inside.
/obj/item/device/electronic_assembly/proc/try_add_component(obj/item/integrated_circuit/IC, mob/user)
	if(!opened)
		to_chat(user, "<span class='warning'>\The [src]'s hatch is closed, you can't put anything inside.</span>")
		return FALSE

	if(IC.w_class > w_class)
		to_chat(user, "<span class='warning'>\The [IC] is way too big to fit into \the [src].</span>")
		return FALSE

	var/total_part_size = return_total_size()
	var/total_complexity = return_total_complexity()

	if((total_part_size + IC.size) > max_components)
		to_chat(user, "<span class='warning'>You can't seem to add the '[IC]', as there's insufficient space.</span>")
		return FALSE
	if((total_complexity + IC.complexity) > max_complexity)
		to_chat(user, "<span class='warning'>You can't seem to add the '[IC]', since this setup's too complicated for the case.</span>")
		return FALSE
	if((allowed_circuit_action_flags & IC.action_flags) != IC.action_flags)
		to_chat(user, "<span class='warning'>You can't seem to add the '[IC]', since the case doesn't support the circuit type.</span>")
		return FALSE

	if(!user.unEquip(IC,src))
		return FALSE

	to_chat(user, "<span class='notice'>You slide \the [IC] inside \the [src].</span>")
	playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
	add_allowed_scanner(user.ckey)

	add_component(IC)
	return TRUE


// Actually puts the circuit inside, doesn't perform any checks.
/obj/item/device/electronic_assembly/proc/add_component(obj/item/integrated_circuit/component)
	component.forceMove(get_object())
	component.assembly = src
	assembly_components |= component
	// Put here just in case something somehow adds a component forcefully
	try_update_ui(null, usr)


/obj/item/device/electronic_assembly/proc/try_remove_component(obj/item/integrated_circuit/IC, mob/user, silent)
	if(!opened)
		if(!silent)
			to_chat(user, "<span class='warning'>[src]'s hatch is closed, so you can't fiddle with the internal components.</span>")
		return FALSE

	if(!IC.removable)
		if(!silent)
			to_chat(user, "<span class='warning'>\The [src] is permanently attached to the case.</span>")
		return FALSE

	remove_component(IC)
	if(!silent)
		to_chat(user, "<span class='notice'>You pop \the [IC] out of the case, and slide it out.</span>")
		playsound(src, 'sound/items/crowbar.ogg', 50, 1)
		user.put_in_hands(IC)
	add_allowed_scanner(user.ckey)

	// Make sure we're not on an invalid page
	update_interact_page(interact_page)

	return TRUE

// Actually removes the component, doesn't perform any checks.
/obj/item/device/electronic_assembly/proc/remove_component(obj/item/integrated_circuit/component)
	component.disconnect_all()
	component.dropInto(loc)
	component.assembly = null
	assembly_components.Remove(component)


/obj/item/device/electronic_assembly/afterattack(atom/target, mob/user, proximity)
	. = ..()
	for(var/obj/item/integrated_circuit/input/S in assembly_components)
		if(S.sense(target,user,proximity))
			if(proximity)
				visible_message("<span class='notice'>\The [user] waves \the [src] around \the [target].</span>")
			else
				visible_message("<span class='notice'>\The [user] points \the [src] towards \the [target].</span>")


/obj/item/device/electronic_assembly/attackby(obj/item/I, mob/living/user)
	if(I.iswrench())
		if(isturf(loc) && (IC_FLAG_ANCHORABLE & circuit_flags))
			user.visible_message("\The [user] starts wrenching \the [src]'s anchoring bolts [anchored ? "back" : "into position"].")
			playsound(get_turf(user), 'sound/items/Ratchet.ogg',50)
			if(do_after(user, 50/I.toolspeed))
				user.visible_message("\The [user] wrenches \the [src]'s anchoring bolts [anchored ? "back" : "into position"].")
				anchored = !anchored
	else if(istype(I, /obj/item/integrated_circuit))
		if(!user.canUnEquip(I))
			return FALSE
		if(try_add_component(I, user))
			return TRUE
		else
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)
			return ..()
	else if(I.ismultitool() || istype(I, /obj/item/device/integrated_electronics/wirer) || istype(I, /obj/item/device/integrated_electronics/debugger))
		if(opened)
			interact(user)
			return TRUE
		else
			to_chat(user, "<span class='warning'>[src]'s hatch is closed, so you can't fiddle with the internal components.</span>")
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)
			return ..()
	else if(istype(I, /obj/item/cell/device))
		if(!opened)
			to_chat(user, "<span class='warning'>\The [src]'s hatch is closed, so you can't access \the [src]'s power supplier.</span>")
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)
			return ..()
		if(battery)
			to_chat(user, "<span class='warning'>\The [src] already has \a [battery] installed. Remove it first if you want to replace it.</span>")
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)
			return ..()
		var/obj/item/cell/device/cell = I
		if(user.unEquip(I,loc))
			user.drop_from_inventory(I, loc)
			cell.forceMove(src)
			battery = cell
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You slot \the [cell] inside \the [src]'s power supplier.</span>")
			return TRUE
		return FALSE
	else if(istype(I, /obj/item/device/integrated_electronics/detailer))
		var/obj/item/device/integrated_electronics/detailer/D = I
		detail_color = D.detail_color
		update_icon()
	else if(I.isscrewdriver())
		var/hatch_locked = FALSE
		for(var/obj/item/integrated_circuit/manipulation/hatchlock/H in assembly_components)
			// If there's more than one hatch lock, only one needs to be enabled for the assembly to be locked
			if(H.lock_enabled)
				hatch_locked = TRUE
				break

		if(hatch_locked)
			to_chat(user, "<span class='notice'>The screws are covered by a locking mechanism!</span>")
			return FALSE

		playsound(src, I.usesound, 25)
		opened = !opened
		to_chat(user, "<span class='notice'>You [opened ? "open" : "close"] the maintenance hatch of \the [src].</span>")
		update_icon()
	else if(I.iscoil())
		var/obj/item/stack/cable_coil/C = I
		if(health < initial(health) && do_after(user, 10, src) && C.use(1))
			user.visible_message("\The [user] patches up \the [src]")
			health = min(initial(health), health + 5)
	else
		if(user.a_intent == I_HURT) // Kill it
			to_chat(user, "<span class='danger'>\The [user] hits \the [src] with \the [I]</span>")
			take_damage(I.force)
		else
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)

/obj/item/device/electronic_assembly/attack_self(mob/user)
	if(!check_interactivity(user))
		return
	if(opened)
		interact(user)

	var/list/input_selection = list()
	var/list/available_inputs = list()
	for(var/obj/item/integrated_circuit/input/input in assembly_components)
		if(input.ask_input)
			available_inputs.Add(input)
			var/i = 0
			for(var/obj/item/integrated_circuit/s in available_inputs)
				if(s.name == input.name && s.displayed_name == input.displayed_name && s != input)
					i++
			var/disp_name= "[input.displayed_name] \[[input.name]\]"
			if(i)
				disp_name += " ([i+1])"
			input_selection.Add(disp_name)

	var/obj/item/integrated_circuit/input/choice
	if(available_inputs)
		var/selection = input(user, "What do you want to interact with?", "Interaction") as null|anything in input_selection
		if(selection)
			var/index = input_selection.Find(selection)
			choice = available_inputs[index]

	if(choice)
		choice.ask_for_input(user)

/obj/item/device/electronic_assembly/bullet_act(var/obj/item/projectile/P)
	take_damage(P.damage)

/obj/item/device/electronic_assembly/emp_act(severity)
	. = ..()
	for(var/I in src)
		var/atom/movable/AM = I
		AM.emp_act(severity)

/obj/item/device/electronic_assembly/get_cell()
	if(battery)
		return battery

// Returns true if power was successfully drawn.
/obj/item/device/electronic_assembly/proc/draw_power(amount)
	if(battery?.use(amount * CELLRATE))
		return TRUE
	return FALSE

// Ditto for giving.
/obj/item/device/electronic_assembly/proc/give_power(amount)
	if(battery?.give(amount * CELLRATE))
		return TRUE
	return FALSE


// Returns the object that is supposed to be used in attack messages, location checks, etc.
// Override in children for special behavior.
/obj/item/device/electronic_assembly/proc/get_object()
	return src

/obj/item/device/electronic_assembly/attack_hand(mob/user)
	if(anchored)
		attack_self(user)
		return
	..()

/obj/item/device/electronic_assembly/proc/on_anchored()
	for(var/obj/item/integrated_circuit/IC in assembly_components)
		IC.on_anchored()

/obj/item/device/electronic_assembly/proc/on_unanchored()
	for(var/obj/item/integrated_circuit/IC in assembly_components)
		IC.on_unanchored()

// resolve_ui_host is used in multiple places and most of the time, it is the same as ui_host
/obj/item/device/electronic_assembly/ui_host()
	return resolve_ui_host()

/obj/item/device/electronic_assembly/proc/resolve_ui_host()
	return src

/obj/item/device/electronic_assembly/proc/get_assembly_holder()
	return src