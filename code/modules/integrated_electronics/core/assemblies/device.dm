/obj/item/device/assembly/electronic_assembly
	name = "electronic device"
	desc = "It's a case for building electronics with. It can be attached to other small devices."
	icon_state = "setup_device"
	var/opened = 0

	var/obj/item/device/electronic_assembly/device/EA

/obj/item/device/assembly/electronic_assembly/Initialize()
	EA = new(src)
	EA.holder = src
	// Circuit initialization here
	// This will allow us to replace the assembly when this one is loaded
	var/obj/item/integrated_circuit/built_in/device_input/input = new(EA)
	var/obj/item/integrated_circuit/built_in/device_output/output = new(EA)
	EA.add_component(input)
	EA.add_component(output)

/obj/item/device/assembly/electronic_assembly/attackby(obj/item/I, mob/user)
	if (I.iscrowbar())
		toggle_open(user)
	else if (opened && EA)
		EA.attackby(I, user)
	else
		..()

/obj/item/device/assembly/electronic_assembly/emp_act(severity)
	if(EA)
		EA.emp_act(severity)
	..()

/obj/item/device/assembly/electronic_assembly/examine(mob/user)
	if(EA)
		EA.examine(user)
	..()

/obj/item/device/assembly/electronic_assembly/attack_self(mob/user)
	if(EA)
		EA.attack_self(user)
	else
		..()

/obj/item/device/assembly/electronic_assembly/proc/toggle_open(mob/user)
	playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
	opened = !opened
	EA.opened = opened
	to_chat(user, "<span class='notice'>You [opened ? "open" : "close"] \the [src].</span>")
	secured = 1
	update_icon()

/obj/item/device/assembly/electronic_assembly/update_icon()
	if(EA)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]0"
	if(opened)
		icon_state = "[icon_state]-open"

//Called when another assembly acts on this one, var/radio will determine where it came from for wire calcs
/obj/item/device/assembly/electronic_assembly/pulsed(radio = 0)
	if(EA)
		for(var/obj/item/integrated_circuit/built_in/device_input/I in EA.assembly_components)
			I.do_work()

/obj/item/device/assembly/electronic_assembly/verb/toggle()
	set src in usr
	set category = "Object"
	set name = "Open/Close Device Assembly"
	set desc = "Open or close device assembly!"

	toggle_open(usr)

/obj/item/device/electronic_assembly/device
	name = "electronic device"
	icon_state = "setup_device"
	desc = "It's a tiny electronic device with specific use for attaching to other devices."
	var/obj/item/device/assembly/electronic_assembly/holder
	w_class = ITEMSIZE_TINY
	max_components = IC_COMPONENTS_BASE * 3/4
	max_complexity = IC_COMPLEXITY_BASE * 3/4

/obj/item/device/electronic_assembly/device/check_interactivity(mob/user)
	if(!CanInteract(user, state = deep_inventory_state))
		return 0
	return 1

/obj/item/device/electronic_assembly/device/save_special()
	if(holder)
		var/out = list("type" = initial(holder.name))
		var/custom_name = holder.name
		// Might be a good idea to save the description as well, but that would be too big
		// Also, if someon's planning to mass-produce completely customized items, then they stop being unique
		if(custom_name != initial(holder.name))
			out["name"] = sanitizeName(holder.name)
		return out
	return null

/obj/item/device/electronic_assembly/device/load_special(special_data)
	// Verify and load
	if(islist(special_data) && special_data["type"])
		var/device_path = SSelectronics.special_paths[special_data["type"]]
		if(device_path)
			var/obj/item/device/assembly/electronic_assembly/device = new device_path(null)
			if(special_data["name"])
				device.name = sanitizeName(special_data["name"])

			// Replace old IC
			QDEL_NULL(device.EA)
			holder = device
			holder.EA = src

/obj/item/device/electronic_assembly/device/post_load()
	if(holder)
		// Move the device where it belongs
		var/old_loc = loc
		forceMove(holder)
		holder.loc = old_loc
	else
		visible_message("<span class='warning'>The malformed device crumples on the floor!</span>")
		qdel(src)			// EMERGENCY DELETION!

/obj/item/device/electronic_assembly/device/resolve_ui_host()
	return holder

/obj/item/device/electronic_assembly/device/get_assembly_holder()
	return holder
