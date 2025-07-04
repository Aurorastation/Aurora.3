/obj/item/mech_component/sensors
	name = "head"
	pixel_y = -18
	center_of_mass = list("x"=24, "y"=34)
	icon_state = "loader_head"
	gender = NEUTER

	var/vision_flags = 0
	var/see_invisible = 0
	var/obj/item/robot_parts/robot_component/radio/radio
	var/obj/item/robot_parts/robot_component/camera/camera
	var/obj/item/mech_component/control_module/software
	var/active_sensors = 0
	has_hardpoints = list(HARDPOINT_HEAD)
	power_use = 15

/obj/item/mech_component/sensors/Destroy()
	QDEL_NULL(camera)
	QDEL_NULL(radio)
	QDEL_NULL(software)
	. = ..()

/obj/item/mech_component/sensors/get_missing_parts_text()
	. = ..()

	if(!radio)
		. += SPAN_WARNING("It is missing a <a href='byond://?src=[REF(src)];info=radio'>radio</a>.")
	if(!camera)
		. += SPAN_WARNING("It is missing a <a href='byond://?src=[REF(src)];info=camera'>camera</a>.")
	if(!software)
		. += SPAN_WARNING("It is missing an <a href='byond://?src=[REF(src)];info=module'>exosuit control module</a>.")

/obj/item/mech_component/sensors/Topic(href, href_list)
	. = ..()
	if(.)
		return
	switch(href_list["info"])
		if("radio")
			to_chat(usr, SPAN_NOTICE("A radio can be created at a mechatronic fabricator."))
		if("camera")
			to_chat(usr, SPAN_NOTICE("A camera can be created at a mechatronic fabricator."))
		if("module")
			to_chat(usr, SPAN_NOTICE("An exosuit control module can be created at a mechatronic fabricator, while the software chips it uses can be printed at the circuit imprinter."))

/obj/item/mech_component/sensors/return_diagnostics(mob/user)
	..()
	if(software)
		to_chat(user, SPAN_NOTICE(" Installed Software"))
		for(var/exosystem_software in software.installed_software)
			to_chat(user, SPAN_NOTICE(" - <b>[capitalize_first_letters(exosystem_software)]</b>"))
	else
		to_chat(user, SPAN_WARNING("  - Control Module Missing or Non-functional."))
	if(radio)
		to_chat(user, SPAN_NOTICE("  - Radio Integrity: <b>[round(((radio.max_dam - radio.total_dam) / radio.max_dam) * 100, 0.1)]%</b>"))
	else
		to_chat(user, SPAN_WARNING("  - Radio Missing or Non-functional."))

/obj/item/mech_component/sensors/prebuild()
	radio = new(src)
	camera = new(src)

/obj/item/mech_component/sensors/update_components()
	radio = locate() in src
	camera = locate() in src
	software = locate() in src

/obj/item/mech_component/sensors/proc/get_sight(powered)
	var/flags = 0
	if((total_damage >= 0.8 * max_damage) || !powered)
		flags |= BLIND
	else if(active_sensors && powered)
		flags |= vision_flags

	return flags

/obj/item/mech_component/sensors/proc/get_invisible(powered)
	var/invisible = 0
	if((total_damage <= 0.8 * max_damage) && active_sensors && powered)
		invisible = see_invisible
	return invisible

/obj/item/mech_component/sensors/ready_to_install()
	return (radio && camera)

/obj/item/mech_component/sensors/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/mech_component/control_module))
		if(software)
			to_chat(user, SPAN_WARNING("\The [src] already has a control modules installed."))
			return
		if(install_component(attacking_item, user)) software = attacking_item
	else if(istype(attacking_item,/obj/item/robot_parts/robot_component/radio))
		if(radio)
			to_chat(user, SPAN_WARNING("\The [src] already has a radio installed."))
			return
		if(install_component(attacking_item, user)) radio = attacking_item
	else if(istype(attacking_item,/obj/item/robot_parts/robot_component/camera))
		if(camera)
			to_chat(user, SPAN_WARNING("\The [src] already has a camera installed."))
			return
		if(install_component(attacking_item, user)) camera = attacking_item
	else
		return ..()

/obj/item/mech_component/control_module
	name = "exosuit control module"
	desc = "A clump of circuitry and software chip docks, used to program exosuits."
	icon_state = "control"
	icon = 'icons/mecha/mech_equipment.dmi'
	gender = NEUTER
	var/list/installed_software = list()
	var/max_installed_software = 2

/obj/item/mech_component/control_module/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += SPAN_NOTICE("<a href='byond://?src=[REF(src)];info=software'>It has [max_installed_software - LAZYLEN(installed_software)] empty slot\s remaining out of [max_installed_software].</a>")

/obj/item/mech_component/control_module/Topic(href, href_list)
	. = ..()
	if(.)
		return
	switch(href_list["info"])
		if("software")
			to_chat(usr, SPAN_NOTICE("Software for \the [src] can be created at the circuit imprinter."))

/obj/item/mech_component/control_module/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/circuitboard/exosystem))
		install_software(attacking_item, user)
		return
	else if(attacking_item.isscrewdriver())
		var/result = ..()
		update_software()
		return result
	else
		return ..()

/obj/item/mech_component/control_module/proc/install_software(var/obj/item/circuitboard/exosystem/software, var/mob/user)
	if(installed_software.len >= max_installed_software)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] can only hold [max_installed_software] software modules."))
		return
	if(user)
		to_chat(user, SPAN_NOTICE("You load \the [software] into \the [src]'s memory."))
		user.unEquip(software)
	software.forceMove(src)
	update_software()

/obj/item/mech_component/control_module/proc/update_software()
	installed_software = list()
	for(var/obj/item/circuitboard/exosystem/program in contents)
		installed_software |= program.contains_software
