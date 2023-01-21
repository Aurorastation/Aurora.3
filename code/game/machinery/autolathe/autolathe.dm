/obj/machinery/autolathe
	name = "autolathe"
	desc = "A large device loaded with various item schematics. It uses a combination of steel and glass to fabricate items."
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

/obj/machinery/autolathe/interact(mob/user)
	if(..() || (disabled && !panel_open))
		to_chat(user, SPAN_DANGER("\The [src] is disabled!"))
		return

	if(shocked)
		shock(user, 50)

	var/dat = "<center>"

	if(!disabled)
		dat += "<table width = '100%'>"
		var/material_top = "<tr>"
		var/material_bottom = "<tr>"

		for(var/material in stored_material)
			material_top += "<td width = '25%' align = center><b>[capitalize_first_letters(material)]</b></td>"
			material_bottom += "<td width = '25%' align = center>[stored_material[material]]<b>/[storage_capacity[material]]</b></td>"

		dat += "[material_top]</tr>[material_bottom]</tr></table><hr>"
		dat += "<h2>Printable Designs</h2><h3>Showing: <a href='?src=\ref[src];change_category=1'>[show_category]</a></h3></center><table width = '100%'>"

		var/index = 0
		for(var/recipe in SSmaterials.autolathe_recipes)
			var/datum/autolathe/recipe/R = recipe
			index++
			if(R.hidden && !hacked || (show_category != "All" && show_category != R.category))
				continue
			var/can_make = TRUE
			var/material_string = ""
			var/multiplier_string = ""
			var/max_sheets
			var/comma
			if(!R.resources || !R.resources.len)
				material_string = "No resources required.</td>"
			else
				//Make sure it's buildable and list requires resources.
				for(var/material in R.resources)
					var/sheets = round(stored_material[material]/round(R.resources[material]*mat_efficiency))
					if(isnull(max_sheets) || max_sheets > sheets)
						max_sheets = sheets
					if(!isnull(stored_material[material]) && stored_material[material] < round(R.resources[material]*mat_efficiency))
						can_make = FALSE
					if(!comma)
						comma = TRUE
					else
						material_string += ", "
					material_string += "[round(R.resources[material] * mat_efficiency)] [material]"
				material_string += "<br></td>"
				//Build list of multipliers for sheets.
				if(R.is_stack)
					if(max_sheets)
						var/obj/item/stack/R_stack = R.path
						max_sheets = min(max_sheets, initial(R_stack.max_amount))
						multiplier_string += "<br>"
						for(var/i = 5; i < max_sheets; i *= 2) //5,10,20,40...
							multiplier_string += "<a href='?src=\ref[src];make=[index];multiplier=[i]'>\[x[i]\]</a>"
						multiplier_string += "<a href='?src=\ref[src];make=[index];multiplier=[max_sheets]'>\[x[max_sheets]\]</a>"

			dat += "<tr class='build'><td width = 40%>[R.hidden ? "<font color = 'red'>*</font>" : ""]<b>[can_make ? "<a href='?src=\ref[src];make=[index];multiplier=1'>" : "<div class='no-build'>"][R.name][can_make ? "</a>" : "</div>"]</b>[R.hidden ? "<font color = 'red'>*</font>" : ""][multiplier_string]</td><td align = right>[material_string]</tr>"
		dat += "</table><hr>"

	var/datum/browser/autolathe_win = new(user, "autolathe", "<center>Autolathe Control Panel</center>")
	autolathe_win.set_content(dat)
	autolathe_win.add_stylesheet("misc", 'html/browser/misc.css')
	autolathe_win.open()

/obj/machinery/autolathe/attackby(obj/item/O, mob/user)
	if(busy)
		to_chat(user, SPAN_NOTICE("\The [src] is busy. Please wait for the completion of previous operation."))
		return TRUE

	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
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

	updateUsrDialog()
	return TRUE

/obj/machinery/autolathe/attack_hand(mob/user)
	user.set_machine(src)
	interact(user)

/obj/machinery/autolathe/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	if(href_list["change_category"])
		var/choice = input("Which category do you wish to display?") as null|anything in SSmaterials.autolathe_categories+"All"
		if(!choice)
			return
		show_category = choice
		updateUsrDialog()
		return

	if(busy)
		to_chat(usr, SPAN_WARNING("The autolathe is busy. Please wait for the completion of previous operation."))
		return

	if(href_list["make"] && SSmaterials.autolathe_recipes)
		var/index = text2num(href_list["make"])
		var/multiplier = text2num(href_list["multiplier"])
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
			flick("autolathe_n", src)

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

	updateUsrDialog()

/obj/machinery/autolathe/update_icon()
	icon_state = (panel_open ? "autolathe_t" : "autolathe")

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
		to_chat(user, SPAN_NOTICE("You fill \the [src] to capacity with [english_list(fill_status[FILL_COMPLETELY])] with \the [eating]."))
	else if(fill_status[FILL_INCOMPLETELY])
		to_chat(user, SPAN_NOTICE("You fill \the [src] with [english_list(fill_status[FILL_INCOMPLETELY])] \the [eating]."))

	flick("autolathe_o", src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating, /obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(min(stack.get_amount(), total_used / mass_per_sheet)) // Prevent maths imprecision from leading to infinite resources
	else
		user.remove_from_mob(O)
		qdel(O)

#undef NO_SPACE
#undef FILL_COMPLETELY
#undef FILL_INCOMPLETELY
