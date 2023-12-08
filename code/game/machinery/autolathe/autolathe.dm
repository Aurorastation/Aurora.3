/obj/machinery/autolathe
	name = "autolathe"
	desc = "A large device loaded with various item schematics. It uses a combination of steel and glass to fabricate items."
	icon = 'icons/obj/machinery/autolathe.dmi'
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = /singleton/sound_category/keyboard_sound
	clickvol = 30

	var/print_loc

	var/list/stored_material =  list(DEFAULT_WALL_MATERIAL = 0, MATERIAL_GLASS = 0)
	var/list/storage_capacity = list(DEFAULT_WALL_MATERIAL = 0, MATERIAL_GLASS = 0)
	var/show_category = "All"

	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE
	var/busy = FALSE
	var/datum/autolathe/recipe/build_item

	var/mat_efficiency = 1
	var/build_time = 50

	var/does_flick = TRUE

	var/datum/wires/autolathe/wires

	component_types = list(
		/obj/item/circuitboard/autolathe,
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/console_screen
	)

/obj/machinery/autolathe/mounted
	name = "\improper mounted autolathe"
	density = FALSE
	anchored = FALSE
	idle_power_usage = FALSE
	active_power_usage = FALSE
	interact_offline = TRUE
	does_flick = FALSE

/obj/machinery/autolathe/Initialize()
	..()
	wires = new(src)
	print_loc = src
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/autolathe/LateInitialize()
	populate_lathe_recipes()

/obj/machinery/autolathe/Destroy()
	QDEL_NULL(wires)
	return ..()

/obj/machinery/autolathe/proc/populate_lathe_recipes()
	if(SSmaterials.autolathe_recipes && SSmaterials.autolathe_categories)
		return

	SSmaterials.autolathe_recipes = list()
	SSmaterials.autolathe_categories = list()
	for(var/R in subtypesof(/datum/autolathe/recipe))
		var/datum/autolathe/recipe/recipe = new R
		SSmaterials.autolathe_recipes += recipe
		SSmaterials.autolathe_categories |= recipe.category

		var/obj/item/I = new recipe.path
		if(I.matter && !recipe.resources) //This can be overidden in the datums.
			recipe.resources = list()
			for(var/material in I.matter)
				recipe.resources[material] = I.matter[material]*1.25 // More expensive to produce than they are to recycle.
		qdel(I)
	SSmaterials.autolathe_categories |= "All"
	SSmaterials.autolathe_categories = sort_list(SSmaterials.autolathe_categories, GLOBAL_PROC_REF(cmp_text_asc))

/obj/machinery/autolathe/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Autolathe", capitalize_first_letters(name))
		ui.open()

/obj/machinery/autolathe/ui_data(mob/user)
	. = ..()
	var/list/data = list()
	data["disabled"] = disabled
	data["material_efficiency"] = mat_efficiency
	data["materials"] = list()
	data["categories"] = SSmaterials.autolathe_categories
	for(var/material in stored_material)
		data["materials"] += list(list("material" = material, "stored" = stored_material[material], "max_capacity" = storage_capacity[material]))
	data["recipes"] = list()
	for(var/recipe in SSmaterials.autolathe_recipes)
		var/datum/autolathe/recipe/R = recipe
		if(R.hidden && !hacked)
			continue
		var/list/recipe_data = list()
		recipe_data["name"] = R.name
		var/list/resources = list()
		for(var/resource in R.resources)
			resources += list("material" = resource, "amount" = R.resources[resource] * mat_efficiency)
			recipe_data["sheets"] = stored_material[resource]/round(R.resources[resource]*mat_efficiency)
			recipe_data["can_make"] = !isnull(stored_material[resource]) && stored_material[resource] < round(R.resources[resource]*mat_efficiency)
		recipe_data["category"] = R.category
		recipe_data["resources"] = resources
		recipe_data["max_sheets"] = null
		if(R.is_stack)
			var/obj/item/stack/R_stack = R.path
			recipe_data["max_sheets"] = initial(R_stack.max_amount)
		data["recipes"] += list(recipe_data)
	return data

/obj/machinery/autolathe/attackby(obj/item/O, mob/user)
	if(busy)
		to_chat(user, SPAN_NOTICE("\The [src] is busy. Please wait for the completion of previous operation."))
		return TRUE

	if(default_deconstruction_screwdriver(user, O))
		SStgui.update_uis(src)
		return TRUE
	if(default_deconstruction_crowbar(user, O))
		return TRUE
	if(default_part_replacement(user, O))
		return TRUE

	if(stat)
		return TRUE

	if(panel_open)
		//Don't eat multitools or wirecutters used on an open lathe.
		if(O.ismultitool() || O.iswirecutter())
			if(panel_open)
				wires.Interact(user)
			else
				to_chat(user, SPAN_WARNING("\The [src]'s wires aren't exposed."))
			return TRUE

	if(O.loc != user && !istype(O, /obj/item/stack))
		return FALSE

	if(is_robot_module(O))
		return FALSE

	load_lathe(O, user)
	return TRUE

/obj/machinery/autolathe/attack_hand(mob/user)
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/autolathe/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	if(busy)
		to_chat(usr, SPAN_WARNING("The autolathe is busy. Please wait for the completion of previous operation."))
		return

	if(action == "make" && SSmaterials.autolathe_recipes)
		var/index = text2num(params["make"])
		var/multiplier = text2num(params["multiplier"])
		build_item = null

		if(index > 0 && index <= length(SSmaterials.autolathe_recipes))
			build_item = SSmaterials.autolathe_recipes[index]

		//Exploit detection, not sure if necessary after rewrite.
		if(!build_item || multiplier < 0 || multiplier > 100)
			var/turf/exploit_loc = get_turf(usr)
			message_admins("[key_name_admin(usr)] tried to exploit an autolathe to duplicate an item! ([exploit_loc ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[exploit_loc.x];Y=[exploit_loc.y];Z=[exploit_loc.z]'>JMP</a>" : "null"])", 0)
			log_admin("EXPLOIT : [key_name(usr)] tried to exploit an autolathe to duplicate an item!",ckey=key_name(usr))
			return

		busy = TRUE
		update_use_power(POWER_USE_ACTIVE)

		intent_message(MACHINE_SOUND)

		//Check if we still have the materials.
		for(var/material in build_item.resources)
			if(!isnull(stored_material[material]))
				if(stored_material[material] < round(build_item.resources[material] * mat_efficiency) * multiplier)
					return

		//Consume materials.
		for(var/material in build_item.resources)
			if(!isnull(stored_material[material]))
				stored_material[material] = max(0, stored_material[material] - round(build_item.resources[material] * mat_efficiency) * multiplier)

		if(does_flick)
			//Fancy autolathe animation.
			add_overlay("process")

		sleep(build_time)

		busy = FALSE
		update_use_power(POWER_USE_IDLE)

		//Sanity check.
		if(!build_item || !src)
			return

		//Create the desired item.
		var/obj/item/I = new build_item.path(get_turf(print_loc))
		I.Created()
		if(multiplier > 1 && istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			S.amount = multiplier
		build_item = null
		cut_overlay("process")
		I.update_icon()

	return TRUE

/obj/machinery/autolathe/update_icon()
	icon_state = (panel_open ? "autolathe_panel" : "autolathe")

//Updates overall lathe storage size.
/obj/machinery/autolathe/RefreshParts()
	..()
	var/mb_rating = 0
	var/man_rating = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	storage_capacity[DEFAULT_WALL_MATERIAL] = mb_rating * 25000
	storage_capacity["glass"] = mb_rating * 12500
	build_time = 50 / man_rating
	mat_efficiency = 1.1 - man_rating * 0.1 // Normally, price is 1.25 the amount of material, so this shouldn't go higher than 0.8. Maximum rating of parts is 3

/obj/machinery/autolathe/dismantle()
	for(var/mat in stored_material)
		var/material/M = SSmaterials.get_material_by_name(mat)
		if(!istype(M))
			continue
		var/obj/item/stack/material/S = new M.stack_type(get_turf(src))
		if(stored_material[mat] > S.perunit)
			S.amount = round(stored_material[mat] / S.perunit)
		else
			qdel(S)
	..()
	return TRUE

#define NO_SPACE "No Space"
#define FILL_COMPLETELY "Fill Completely"
#define FILL_INCOMPLETELY "Fill Incompletely"

/obj/machinery/autolathe/proc/load_lathe(obj/item/O, mob/user)

	//Resources are being loaded.
	var/obj/item/eating = O
	if(!eating.matter || !eating.recyclable)
		to_chat(user, SPAN_WARNING("\The [eating] cannot be recycled by \the [src]."))
		return

	var/list/fill_status = list() // Used to determine message in cases of multiple materials.
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.
	var/is_stack = FALSE //Affects the fill message

	for(var/material in eating.matter)
		if(isnull(stored_material[material]) || isnull(storage_capacity[material]))
			continue
		if(stored_material[material] >= storage_capacity[material])
			LAZYADD(fill_status[NO_SPACE], material)
			continue

		var/total_material = eating.matter[material]

		//If it's a stack, we eat multiple sheets.
		if(istype(eating, /obj/item/stack))
			var/obj/item/stack/stack = eating
			is_stack = TRUE
			total_material *= stack.get_amount()

		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
			LAZYADD(fill_status[FILL_COMPLETELY], material)
		else
			LAZYADD(fill_status[FILL_INCOMPLETELY], material)

		stored_material[material] += total_material
		total_used += total_material
		mass_per_sheet += eating.matter[material]

	if(fill_status[NO_SPACE])
		to_chat(user, SPAN_WARNING("\The [src] is full of [english_list(fill_status[NO_SPACE])]. Please remove some material in order to insert more."))
		return
	else if(fill_status[FILL_COMPLETELY])
		to_chat(user, SPAN_NOTICE("You fill \the [src] to capacity with [english_list(fill_status[FILL_COMPLETELY])][is_stack ? "." : " from \the [eating]."]"))
	else if(fill_status[FILL_INCOMPLETELY])
		to_chat(user, SPAN_NOTICE("You fill \the [src] with [english_list(fill_status[FILL_INCOMPLETELY])][is_stack ? "." : " from \the [eating]."]"))

	// Plays metal insertion animation.
	if(istype(eating, /obj/item/stack/material))
		var/obj/item/stack/material/sheet = eating
		var/icon/load = icon(icon, "load")
		load.Blend(sheet.material.icon_colour,ICON_MULTIPLY)
		add_overlay(load)
		CUT_OVERLAY_IN(load, 6)

	if(istype(eating, /obj/item/stack))
		var/obj/item/stack/stack = eating
		var/amount_needed = total_used / mass_per_sheet
		stack.use(min(stack.get_amount(), (round(amount_needed) == amount_needed)? amount_needed : round(amount_needed) + 1)) // Prevent maths imprecision from leading to infinite resources
	else
		user.remove_from_mob(O)
		qdel(O)

#undef NO_SPACE
#undef FILL_COMPLETELY
#undef FILL_INCOMPLETELY
