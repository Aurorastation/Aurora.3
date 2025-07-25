/obj/machinery/mecha_part_fabricator
	name = "mechatronic fabricator"
	desc = "A general purpose fabricator that can be used to fabricate robotic equipment."
	icon = 'icons/obj/machinery/robotics_fabricator.dmi'
	icon_state = "fab"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 20
	active_power_usage = 5000
	req_access = list(ACCESS_ROBOTICS)
	component_types = list(
		/obj/item/circuitboard/mechfab,
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/micro_laser,
		/obj/item/stock_parts/console_screen
	)

	/**
	 * A `/list` of enqueued `/datum/design` to be printed, processed in the queue
	 */
	var/list/datum/design/queue = list()

	/**
	 * How much efficient (or inefficient) the protolathe is at manufacturing things
	 */
	var/mat_efficiency = 1

	/**
	 * The production speed of this specific protolathe, a factor
	 */
	var/production_speed = 1

	var/list/materials = list(DEFAULT_WALL_MATERIAL = 0, MATERIAL_GLASS = 0, MATERIAL_GOLD = 0, MATERIAL_SILVER = 0, MATERIAL_DIAMOND = 0, MATERIAL_PHORON = 0, MATERIAL_URANIUM = 0, MATERIAL_PLASTEEL = 0, MATERIAL_ALUMINIUM = 0, MATERIAL_LEAD = 0)
	var/res_max_amount = 200000

	var/datum/research/files

	var/list/categories = list()
	var/category = null
	var/sync_message = ""
	var/limb_manufacturer

	///The timer id for the build callback, if we're building something
	var/build_callback_timer

/obj/machinery/mecha_part_fabricator/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>matter bins</b> will increase material storage capacity."
	. += "Upgraded <b>micro-lasers</b> will increase fabrication speed."
	. += "Upgraded <b>manipulators</b> will improve material use efficiency."

/obj/machinery/mecha_part_fabricator/Initialize()
	. = ..()

	files = new /datum/research(src) //Setup the research data holder.
	limb_manufacturer = GLOB.basic_robolimb.company
	update_categories()

/obj/machinery/mecha_part_fabricator/update_icon()
	ClearOverlays()
	if(panel_open)
		AddOverlays("[icon_state]_panel")
	if(!(stat & (NOPOWER|BROKEN)))
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		AddOverlays("[icon_state]_lights")
	if(build_callback_timer)
		AddOverlays("[icon_state]_working")
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights_working"))
		AddOverlays("[icon_state]_lights_working")

/obj/machinery/mecha_part_fabricator/dismantle()
	for(var/f in materials)
		eject_materials(f, -1)

	//Stop the queue building if you're dismantling
	deltimer(build_callback_timer)

	..()

/obj/machinery/mecha_part_fabricator/RefreshParts()
	..()
	res_max_amount = 0

	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		res_max_amount += M.rating * 100000 // 200k -> 600k
	var/T = 0

	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		T += M.rating
	mat_efficiency = 1 - (T - 1) / 4 // 1 -> 0.5

	for(var/obj/item/stock_parts/micro_laser/M in component_parts) // Not resetting T is intended; speed is affected by both
		T += M.rating
	production_speed = T / 2 // 1 -> 3

/obj/machinery/mecha_part_fabricator/attack_hand(var/mob/user)
	if(..())
		return
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	do_hair_pull(user)
	ui_interact(user)

/obj/machinery/mecha_part_fabricator/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	var/datum/design/current = queue.len ? queue[1] : null
	if(current)
		data["current"] = current.name
	data["queue"] = get_queue_names()
	data["buildable"] = get_build_options()
	data["category"] = category
	data["categories"] = categories

	if(GLOB.fabricator_robolimbs)
		var/list/T = list()
		for(var/A in GLOB.fabricator_robolimbs)
			var/datum/robolimb/R = GLOB.fabricator_robolimbs[A]
			T += list(list("id" = A, "company" = R.company))
		data["manufacturers"] = T
		data["manufacturer"] = limb_manufacturer

	data["materials"] = get_materials()
	data["maxres"] = res_max_amount
	data["sync"] = sync_message

	//If we have something in the queue that we're trying to build, show the time left if the build is undergoing, otherwise null
	//the logic of displaying it is handled client-side
	if(current)
		if(build_callback_timer)
			data["timeleft"] = round(timeleft(build_callback_timer))
		else
			data["timeleft"] = null

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "mechfab.tmpl", "Exosuit Fabricator UI", 800, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/mecha_part_fabricator/Topic(href, href_list)
	if(..())
		return

	if(href_list["build"])
		var/path = text2path(href_list["build"])
		add_to_queue(path)

	if(href_list["remove"])
		remove_from_queue(text2num(href_list["remove"]))

	if(href_list["category"])
		if(href_list["category"] in categories)
			category = href_list["category"]

	if(href_list["manufacturer"])
		if(href_list["manufacturer"] in GLOB.fabricator_robolimbs)
			limb_manufacturer = href_list["manufacturer"]

	if(href_list["eject"])
		eject_materials(href_list["eject"], text2num(href_list["amount"]))

	if(href_list["sync"])
		sync()
	else
		sync_message = ""

	return 1

/obj/machinery/mecha_part_fabricator/attackby(obj/item/attacking_item, mob/user)
	if(build_callback_timer)
		to_chat(user, SPAN_NOTICE("\The [src] is busy. Please wait for completion of previous operation."))
		return TRUE
	if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE
	if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	if(default_part_replacement(user, attacking_item))
		return TRUE

	if(!istype(attacking_item, /obj/item/stack/material))
		return ..()

	var/obj/item/stack/material/M = attacking_item
	if(!M.material)
		return ..()
	if(!(M.material.name in list(MATERIAL_STEEL, MATERIAL_GLASS, MATERIAL_GOLD, MATERIAL_SILVER, MATERIAL_DIAMOND, MATERIAL_PHORON, MATERIAL_URANIUM, MATERIAL_PLASTEEL, MATERIAL_ALUMINIUM, MATERIAL_LEAD)))
		to_chat(user, SPAN_WARNING("\The [src] cannot hold [M.material.name]."))
		return TRUE

	var/sname = "[M.name]"
	if(materials[M.material.name] + M.perunit <= res_max_amount)
		if(M.amount >= 1)
			var/count = 0
			var/mutable_appearance/MA = mutable_appearance(icon, "material_insertion")
			MA.color = M.material.icon_colour
			//first play the insertion animation
			flick_overlay_view(MA, 1 SECONDS)

			//now play the progress bar animation
			flick_overlay_view(mutable_appearance(icon, "fab_progress"), 1 SECONDS)

			while(materials[M.material.name] + M.perunit <= res_max_amount && M.amount >= 1)
				materials[M.material.name] += M.perunit
				M.use(1)
				count++
			to_chat(user, SPAN_NOTICE("You insert [count] [sname] into \the [src]."))

			//Wake up, we have things to do (maybe)
			handle_queue()

	else
		to_chat(user, SPAN_NOTICE("\The [src] cannot hold more [sname]."))
	return TRUE

/obj/machinery/mecha_part_fabricator/mouse_drop_receive(atom/dropped, mob/user, params)
	var/mob/living/carbon/human/target = dropped
	if (!istype(target) || target.buckled_to || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.stat || istype(user, /mob/living/silicon/ai))
		return
	if(target == user)
		return
	src.add_fingerprint(user)
	var/target_loc = target.loc

	if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
		if(isskrell(target) || isunathi(target))
			return

		for(var/obj/item/protection in list(target.head))
			if(protection && (protection.flags_inv & BLOCKHAIR))
				return

		var/datum/sprite_accessory/hair/hair_style = GLOB.hair_styles_list[target.h_style]
		if(hair_style.length < 4)
			return

		user.visible_message(SPAN_WARNING("[user] starts feeding [target]'s hair into \the [src]!"), SPAN_WARNING("You start feeding [target]'s hair into \the [src]!"))
		if(!do_after(user, 5 SECONDS, target, DO_UNIQUE))
			return
		if(target_loc != target.loc)
			return
		if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
			user.visible_message(SPAN_WARNING("[user] feeds the [target]'s hair into the [src] and flicks it on!"), SPAN_ALERT("You turn the [src] on!"))
			do_hair_pull(target)
			user.attack_log += "\[[time_stamp()]\] <span class='warning'>Has fed [target.name]'s ([target.ckey]) hair into a [src].</span>"
			target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their hair fed into [src] by [user.name] ([user.ckey])</font>"
			msg_admin_attack("[key_name_admin(user)] fed [key_name_admin(target)] in a [src]. (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))
		else
			return
		if(!do_after(user, 3.5 SECONDS, target, DO_UNIQUE))
			return
		if(target_loc != target.loc)
			return
		if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
			user.visible_message(SPAN_ALERT("[user] starts tugging on [target]'s head as the [src] keeps running!"), SPAN_ALERT("You start tugging on [target]'s head!"))
			do_hair_pull(target)
			spawn(10)
			user.visible_message(SPAN_ALERT("[user] stops the [src] and leaves [target] resting as they are."), SPAN_ALERT("You turn the [src] off and let go of [target]."))

/obj/machinery/mecha_part_fabricator/emag_act(var/remaining_charges, var/mob/user)
	switch(emagged)
		if(0)
			emagged = 0.5
			visible_message("[icon2html(src, viewers(get_turf(src)))] <b>[src]</b> beeps: \"DB error \[Code 0x00F1\]\"")
			sleep(10)
			visible_message("[icon2html(src, viewers(get_turf(src)))] <b>[src]</b> beeps: \"Attempting auto-repair\"")
			sleep(15)
			visible_message("[icon2html(src, viewers(get_turf(src)))] <b>[src]</b> beeps: \"User DB corrupted \[Code 0x00FA\]. Truncating data structure...\"")
			sleep(30)
			visible_message("[icon2html(src, viewers(get_turf(src)))] <b>[src]</b> beeps: \"User DB truncated. Please contact your [SSatlas.current_map.company_name] system operator for future assistance.\"")
			req_access = null
			emagged = 1
			return 1
		if(0.5)
			visible_message("[icon2html(src, viewers(get_turf(src)))] <b>[src]</b> beeps: \"DB not responding \[Code 0x0003\]...\"")
		if(1)
			visible_message("[icon2html(src, viewers(get_turf(src)))] <b>[src]</b> beeps: \"No records in User DB\"")

/**
 * Adds a design to the queue
 *
 * * path: The path of the design to add
 */
/obj/machinery/mecha_part_fabricator/proc/add_to_queue(path)
	var/datum/design/D = files.known_designs[path]
	if(!D)
		return
	queue += D

	//Wake up, we have things to do
	handle_queue()

/**
 * Removes a design from the queue
 *
 * * index: The index of the design to remove
 */
/obj/machinery/mecha_part_fabricator/proc/remove_from_queue(index)
	queue.Cut(index, index + 1)

	//If we're removing the first thing in the queue, stop the build timer
	if(index == 1)
		deltimer(build_callback_timer)
		build_callback_timer = null

	//Wake up, we have things to do
	handle_queue()

/**
 * Handle the construction queue
 */
/obj/machinery/mecha_part_fabricator/proc/handle_queue()

	//No work to do or already busy, stop
	if(!length(queue) || build_callback_timer)
		//If we don't have a build in progress, revert to idle power usage
		if(!build_callback_timer)
			update_use_power(POWER_USE_IDLE)

		update_icon()
		return

	//If there's no power, there's no building
	if(stat & NOPOWER)
		queue = list()
		return

	//Get the first design in the queue
	var/datum/design/D = queue[1]

	//If we can build it, process the request
	if(can_build(D))
		update_use_power(POWER_USE_ACTIVE)

		//Add the callback timer for printing, and remove the design from the queue
		build_callback_timer = addtimer(CALLBACK(src, PROC_REF(build), D), (D.time / production_speed), TIMER_UNIQUE|TIMER_STOPPABLE)
		//No queue removal here because we show how long it takes to build in the UI

	else
		visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] \The [src] flashes: Insufficient materials to complete build: [D.name]."))

	update_icon()

/obj/machinery/mecha_part_fabricator/proc/can_build(var/datum/design/D)
	for(var/M in D.materials)
		if(materials[M] < D.materials[M] * mat_efficiency)
			return 0
	return 1

/**
 * Builds the given design, assuming all the necessary conditions are met
 *
 * * design_to_build: The design to build
 */
/obj/machinery/mecha_part_fabricator/proc/build(datum/design/design_to_build)
	//Consume the materials
	for(var/M in design_to_build.materials)
		materials[M] = max(0, materials[M] - design_to_build.materials[M] * mat_efficiency)

	intent_message(MACHINE_SOUND)

	if(design_to_build.build_path)
		var/loc_offset = get_step(src, dir)
		var/obj/new_item = design_to_build.Fabricate(loc_offset, src)
		visible_message("\The <b>[src]</b> pings, indicating that \the [new_item] is complete.", "You hear a ping.", intent_message = PING_SOUND)
		if(mat_efficiency != 1)
			if(new_item.matter && new_item.matter.len > 0)
				for(var/i in new_item.matter)
					new_item.matter[i] = new_item.matter[i] * mat_efficiency

	//We finished building, clear the timer and remove the thing from the queue
	build_callback_timer = null
	remove_from_queue(1)

	//Do the queue handling for the next item, or to stop
	handle_queue()

/obj/machinery/mecha_part_fabricator/proc/get_queue_names()
	. = list()
	for(var/i = 2 to queue.len)
		var/datum/design/D = queue[i]
		. += D.name

/obj/machinery/mecha_part_fabricator/proc/get_build_options()
	. = list()
	for(var/path in files.known_designs)
		var/datum/design/D = files.known_designs[path]
		if(!D.build_path || !(D.build_type & MECHFAB) || !D.category)
			continue
		. += list(list("name" = D.name, "id" = D.type, "category" = D.category, "resourses" = get_design_resourses(D), "time" = get_design_time(D)))

/obj/machinery/mecha_part_fabricator/proc/get_design_resourses(var/datum/design/D)
	var/list/F = list()
	for(var/T in D.materials)
		F += "[capitalize(T)]: [D.materials[T] * mat_efficiency]"
	return english_list(F, and_text = ", ")

/obj/machinery/mecha_part_fabricator/proc/get_design_time(var/datum/design/D)
	return time2text(round(10 * D.time / production_speed), "mm:ss")

/obj/machinery/mecha_part_fabricator/proc/update_categories()
	categories = list()
	for(var/path in files.known_designs)
		var/datum/design/D = files.known_designs[path]
		if(!D.build_path || !(D.build_type & MECHFAB) || !D.category)
			continue
		categories |= D.category
	if(!category || !(category in categories))
		category = categories[1]

/obj/machinery/mecha_part_fabricator/proc/get_materials()
	. = list()
	for(var/T in materials)
		. += list(list("mat" = capitalize(T), "amt" = materials[T]))

/obj/machinery/mecha_part_fabricator/proc/eject_materials(var/material, var/amount) // 0 amount = 0 means ejecting a full stack; -1 means eject everything
	var/recursive = amount == -1 ? 1 : 0
	material = lowertext(material)
	var/material/mattype = SSmaterials.get_material_by_name(material)
	var/stack_type = mattype.stack_type

	var/obj/item/stack/material/S = new stack_type(loc)
	if(amount <= 0)
		amount = S.max_amount
	var/ejected = min(round(materials[material] / S.perunit), amount)
	S.amount = min(ejected, amount)
	if(S.amount <= 0)
		qdel(S)
		return
	materials[material] -= ejected * S.perunit
	if(recursive && materials[material] >= S.perunit)
		eject_materials(material, -1)

/obj/machinery/mecha_part_fabricator/proc/sync()
	sync_message = "Error: no console found."
	for(var/obj/machinery/computer/rdconsole/RDC in get_area(src))
		if(!RDC.sync)
			continue
		for(var/id in RDC.files.known_tech)
			var/datum/tech/T = RDC.files.known_tech[id]
			files.AddTech2Known(T)
		files.RefreshResearch()
		sync_message = "Sync complete."
	update_categories()
