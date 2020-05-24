/obj/item/device/electronic_assembly/implant
	name = "electronic implant"
	icon_state = "setup_implant"
	desc = "It's a case, for building very tiny electronics with."
	w_class = ITEMSIZE_TINY
	max_components = IC_COMPONENTS_BASE / 2
	max_complexity = IC_COMPLEXITY_BASE / 2
	var/obj/item/implant/integrated_circuit/implant = null

/obj/item/device/electronic_assembly/implant/resolve_ui_host()
	return implant

/obj/item/device/electronic_assembly/implant/get_assembly_holder()
	return implant

/obj/item/device/electronic_assembly/implant/update_icon()
	..()
	implant.icon_state = icon_state

/obj/item/device/electronic_assembly/implant/save_special()
	if(implant)
		// Shouldn't be possible to have other/named implants, but better generic than sorry
		var/out = list("type" = initial(implant.name))
		var/custom_name = implant.name
		if(custom_name != initial(implant.name))
			out["name"] = sanitizeName(implant.name)
		return out
	return null

/obj/item/device/electronic_assembly/implant/load_special(special_data)
	if(islist(special_data) && special_data["type"])
		var/implant_path = SSelectronics.special_paths[special_data["type"]]
		var/obj/item/implant/integrated_circuit/new_implant = new implant_path(get_turf(loc))
		if(special_data["name"])
			new_implant.name = sanitizeName(special_data["name"])

		// Remove old IC
		QDEL_NULL(new_implant.IC)
		implant = new_implant
		new_implant.IC = src
	return

/obj/item/device/electronic_assembly/implant/post_load()
	..()
	if(implant)
		// Replace the assembly with the implant
		var/old_loc = loc
		forceMove(implant)
		implant.loc = old_loc
	else
		visible_message("<span class='warning'>The malformed device crumples on the floor!</span>")
		qdel(src)			// EMERGENCY DELETION!