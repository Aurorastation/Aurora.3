#define NO_SPACE "No Space"
#define FILL_COMPLETELY "Fill Completely"
#define FILL_INCOMPLETELY "Fill Incompletely"

/obj/machinery/fabricator/proc/load_lathe(obj/item/O, mob/user)

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
		var/image/adding_mat_overlay = overlay_image(icon, "[icon_state]_mat")
		adding_mat_overlay.color = sheet.material.icon_colour
		AddOverlays(adding_mat_overlay)
		CUT_OVERLAY_IN(adding_mat_overlay, 1 SECOND)

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
