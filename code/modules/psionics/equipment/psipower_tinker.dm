/obj/item/psychic_power/tinker
	name = "psychokinetic crowbar"
	icon_state = "crowbar"
	force = 11
	var/emulating = "crowbar"
	var/list/tools = list("crowbar", "wrench", "screwdriver", "cutters")

/obj/item/psychic_power/tinker/Initialize(mapload, ...)
	. = ..()
	var/list/new_tools = list()
	for(var/tool_name in tools)
		var/image/radial_image = image('icons/obj/psychic_powers.dmi', tool_name)
		new_tools[capitalize_first_letters(tool_name)] = radial_image
	tools = new_tools

/obj/item/psychic_power/tinker/iscrowbar()
	return emulating == "crowbar"

/obj/item/psychic_power/tinker/iswrench()
	return emulating == "wrench"

/obj/item/psychic_power/tinker/isscrewdriver()
	return emulating == "screwdriver"

/obj/item/psychic_power/tinker/iswirecutter()
	return emulating == "cutters"

/obj/item/psychic_power/tinker/attack_self(mob/user)
	if(!owner || loc != owner)
		return

	var/choice = show_radial_menu(user, user, tools, radius = 42, tooltips = TRUE)
	if(!choice)
		playsound(get_turf(src), 'sound/effects/psi/power_fail.ogg', 40, TRUE)
		owner.drop_from_inventory(src)
		return

	if(!owner || loc != owner)
		return

	emulating = lowertext(choice)
	name = "psychokinetic [emulating]"
	icon_state = emulating
	to_chat(owner, SPAN_NOTICE("You begin emulating \a [emulating]."))
	playsound(get_turf(src), 'sound/effects/psi/power_fabrication.ogg', 40, TRUE)
