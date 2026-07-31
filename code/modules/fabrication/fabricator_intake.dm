#define NO_SPACE "No Space"
#define FILL_COMPLETELY "Fill Completely"
#define FILL_INCOMPLETELY "Fill Incompletely"

///Loads the lathe with materials
/obj/structure/machinery/fabricator/proc/load_lathe(obj/item/loading_item, mob/user)

	//Resources are being loaded.
	var/obj/item/eating = loading_item
	if(!eating.matter || !eating.recyclable)
		to_chat(user, SPAN_WARNING("\The [eating] cannot be recycled by \the [src]."))
		return

	var/list/fill_status = list() // Used to determine message in cases of multiple materials.
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.
	var/is_stack = FALSE //Affects the fill message

	normalize_material_storage()
	for(var/material in eating.matter)
		var/material_path = SSmaterials.material_to_path(material, FALSE)
		if(!material_path || isnull(stored_material[material_path]) || isnull(storage_capacity[material_path]))
			continue
		var/material_name = SSmaterials.material_display_name(material_path)
		if(stored_material[material_path] >= storage_capacity[material_path])
			LAZYADD(fill_status[NO_SPACE], material_name)
			continue

		var/total_material = eating.matter[material]

		//If it's a stack, we eat multiple sheets.
		if(istype(eating, /obj/item/stack))
			var/obj/item/stack/stack = eating
			is_stack = TRUE
			total_material *= stack.get_amount()

		if(stored_material[material_path] + total_material > storage_capacity[material_path])
			total_material = storage_capacity[material_path] - stored_material[material_path]
			LAZYADD(fill_status[FILL_COMPLETELY], material_name)
		else
			LAZYADD(fill_status[FILL_INCOMPLETELY], material_name)

		stored_material[material_path] += total_material
		total_used += total_material
		mass_per_sheet += eating.matter[material]

	if(total_used <= 0 || mass_per_sheet <= 0)
		if(fill_status[NO_SPACE])
			to_chat(user, SPAN_WARNING("\The [src] is full of [english_list(fill_status[NO_SPACE])]. Please remove some material in order to insert more."))
		else
			to_chat(user, SPAN_WARNING("\The [src] cannot accept any materials from \the [eating]."))
		return

	if(fill_status[FILL_COMPLETELY])
		to_chat(user, SPAN_NOTICE("You fill \the [src] to capacity with [english_list(fill_status[FILL_COMPLETELY])][is_stack ? "." : " from \the [eating]."]"))
	else if(fill_status[FILL_INCOMPLETELY])
		to_chat(user, SPAN_NOTICE("You fill \the [src] with [english_list(fill_status[FILL_INCOMPLETELY])][is_stack ? "." : " from \the [eating]."]"))

	// Plays metal insertion animation.
	if(istype(eating, /obj/item/stack/material) && does_flick)
		var/obj/item/stack/material/sheet = eating
		var/image/adding_mat_overlay = overlay_image(icon, "[icon_state]_mat")
		adding_mat_overlay.color = sheet.material.icon_colour
		AddOverlays(adding_mat_overlay)
		CUT_OVERLAY_IN(adding_mat_overlay, 1 SECOND)

	// Play the lights animation (even if what we inserted wasn't a stack)
	if(powered() && does_flick)
		flick_overlay_view(mutable_appearance(icon, "[icon_state]_progress"), 1 SECONDS)

	if(istype(eating, /obj/item/stack))
		var/obj/item/stack/stack = eating
		var/amount_needed = total_used / mass_per_sheet
		stack.use(min(stack.get_amount(), (round(amount_needed) == amount_needed)? amount_needed : round(amount_needed) + 1)) // Prevent maths imprecision from leading to infinite resources
	else
		user.remove_from_mob(loading_item)
		qdel(loading_item)

#undef NO_SPACE
#undef FILL_COMPLETELY
#undef FILL_INCOMPLETELY
