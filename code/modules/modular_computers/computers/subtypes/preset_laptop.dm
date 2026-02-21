/obj/item/modular_computer/laptop/preset
	anchored = FALSE
	screen_on = FALSE
	icon_state = "laptop-closed"

/obj/item/modular_computer/laptop/preset/Destroy()
	. = ..()

/obj/item/modular_computer/laptop/preset/install_default_hardware()
	..()
	processor_unit = new /obj/item/computer_hardware/processor_unit(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	battery_module = new /obj/item/computer_hardware/battery_module(src)
	battery_module.charge_to_full()
	nano_printer = new /obj/item/computer_hardware/nano_printer(src)
	nano_printer.max_paper = 10
	nano_printer.stored_paper = 5
	tesla_link = new /obj/item/computer_hardware/tesla_link/charging_cable(src)
	universal_port = new /obj/item/computer_hardware/universal_port(src)

// the laptop in the modular computer loadout
/obj/item/modular_computer/laptop/preset/loadout/install_default_hardware()
	. = ..()
	card_slot = new /obj/item/computer_hardware/card_slot(src)

// Tajaran laptop
/obj/item/modular_computer/laptop/preset/tajara
	name = "tesla laptop"
	desc = "A bulky portable computer from the People's Republic of Adhomai."
	desc_extended = "Tesla technology is a novel field of research hailing from the People's Republic of Adhomai. The scalable power generation technology \
	has been uitilized by the Adhomian nation in numerous consumer goods, including personal computers. While traditional Adhomian computers are static desktops, \
	the National Computational Technologies Manufactory produces a line of bulky 'portable' computers utilizing tesla generators."
	icon = 'icons/obj/modular_computers/tesla_laptop.dmi'
	w_class = WEIGHT_CLASS_BULKY //Massive computer, cannot be stored. Also to balance for the Tesla generator
	soundloop = /datum/looping_sound/old_computer

/obj/item/modular_computer/laptop/preset/tajara/install_default_hardware()
	..()
	tesla_link = new /obj/item/computer_hardware/tesla_link/tesla_generator(src)

/obj/item/modular_computer/laptop/preset/tajara/update_icon()
	..()
	if(anchored)
		icon_state = enabled ? "laptop-open-on" : "[icon_state]"

/obj/item/laptop_case
	name = "tesla laptop case"
	desc = "A huge briefcase-esque place to store one's tesla laptop."
	desc_extended = "The National Computational Technologies Manufactory is the primary producer of consumer-grade\
	computers within the People's Republic of Adhomai. The majority of their products are static desktops,\
	however with the further development of Tesla technologies, attempts at a portable computer have resulted in\
	bulky but powerful products that are quickly spreading across the cities of the Republic."
	icon = 'icons/obj/storage/briefcase.dmi'
	icon_state = "laptop_case_closed"
	item_state = "briefcase_black"
	contained_sprite = TRUE
	force = 15
	throwforce = 5
	throw_speed = 1
	throw_range = 4
	w_class = WEIGHT_CLASS_BULKY
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

	var/obj/item/laptop_case/machine
	var/opened = FALSE

/obj/item/laptop_case/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can ALT-click on this case to open and close it. A tesla laptop can only be removed or added when it is open!"

/obj/item/laptop_case/Initialize()
	. = ..()
	if(!machine)
		machine = new /obj/item/modular_computer/laptop/preset/tajara(src)

/obj/item/laptop_case/Destroy()
	QDEL_NULL(machine)
	return ..()

/obj/item/laptop_case/AltClick(mob/user)
	if(!Adjacent(user))
		return

	playsound(loc, 'sound/items/storage/briefcase.ogg', 50, 0, -5)

	opened = !opened
	update_icon()

/obj/item/laptop_case/update_icon()
	if(opened && machine)
		icon_state = "laptop_case_open"
	else if (opened && !machine)
		icon_state = "laptop_case_open_e"
	else if (!opened)
		icon_state = "laptop_case_closed"

/obj/item/laptop_case/attack_self(mob/user)
	if(use_check_and_message(user))
		return
	if(((user.contents.Find(src) || in_range(src, user))))
		if(opened)
			if(!machine)
				to_chat(user, SPAN_ALERT("\The [src] is currently empty!"))
			else
				user.put_in_hands(machine)
				machine = null
				update_icon()
		else
			to_chat(user, SPAN_ALERT("\The [src] is currently closed!"))
	return

/obj/item/laptop_case/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	attack_self(over)

/obj/item/laptop_case/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/modular_computer/laptop/preset/tajara))
		if(!machine)
			user.drop_item(attacking_item)
			user.unEquip(attacking_item)
			attacking_item.forceMove(src)
			src.machine = attacking_item
			user.visible_message(SPAN_ALERT("[user] places \the [attacking_item] into \the [src]."), SPAN_ALERT ("You store \the [attacking_item] in \the [src]."))
			src.update_icon()
		else
			to_chat(user, SPAN_ALERT("\The [src] already has a computer in it!"))
		. = ..()

// Engineering
/obj/item/modular_computer/laptop/preset/engineering
	name = "engineering laptop"
	desc = "A portable computer belonging to the engineering department. It appears to have been used as a door stop at one point or another."
	_app_preset_type = /datum/modular_computer_app_presets/engineering
	enrolled = DEVICE_COMPANY

/obj/item/modular_computer/laptop/preset/engineering/ce
	name = "chief engineer's laptop"
	desc = "A portable computer belonging to the chief engineer."
	_app_preset_type = /datum/modular_computer_app_presets/engineering/ce

// Medical
/obj/item/modular_computer/laptop/preset/medical
	name = "medical laptop"
	desc = "A portable computer belonging to the medical department."
	_app_preset_type = /datum/modular_computer_app_presets/medical
	enrolled = DEVICE_COMPANY

/obj/item/modular_computer/laptop/preset/medical/cmo
	name = "chief medical officer's laptop"
	desc = "A portable computer belonging to the chief medical officer."
	_app_preset_type = /datum/modular_computer_app_presets/medical/cmo

// Research
/obj/item/modular_computer/laptop/preset/research
	name = "research laptop"
	desc = "A portable computer belonging to the research department."
	_app_preset_type = /datum/modular_computer_app_presets/research
	enrolled = DEVICE_COMPANY

/obj/item/modular_computer/laptop/preset/research/install_default_hardware()
	..()
	ai_slot = new /obj/item/computer_hardware/ai_slot(src)

/obj/item/modular_computer/laptop/preset/research/rd
	name = "research director's laptop"
	desc = "A portable computer belonging to the research director. The edges are stained and partially melted."
	_app_preset_type = /datum/modular_computer_app_presets/research/rd

// Command
/obj/item/modular_computer/laptop/preset/command
	name = "command laptop"
	_app_preset_type = /datum/modular_computer_app_presets/command
	enrolled = DEVICE_COMPANY

/obj/item/modular_computer/laptop/preset/command/teleporter
	name = "teleporter control laptop"
	desc = "A portable computer that has a special teleporter control program loaded."
	_app_preset_type = /datum/modular_computer_app_presets/command/teleporter

/obj/item/modular_computer/laptop/preset/command/xo
	name = "executive officer's laptop"
	desc = "A portable computer beloning to the executive officer. The fan is filled with dog hair."
	_app_preset_type = /datum/modular_computer_app_presets/command/hop

/obj/item/modular_computer/laptop/preset/command/xo/install_default_hardware()
	..()
	card_slot = new /obj/item/computer_hardware/card_slot(src)

/obj/item/modular_computer/laptop/preset/command/captain
	name = "captain's laptop"
	desc = "A portable computer belonging to the captain."
	_app_preset_type = /datum/modular_computer_app_presets/command/captain

/obj/item/modular_computer/laptop/preset/command/captain/install_default_hardware()
	..()
	card_slot = new /obj/item/computer_hardware/card_slot(src)

// Security
/obj/item/modular_computer/laptop/preset/security
	name = "security laptop"
	desc = "A portable computer belonging to the security department."
	_app_preset_type = /datum/modular_computer_app_presets/security
	enrolled = DEVICE_COMPANY

/obj/item/modular_computer/laptop/preset/security/hos
	name = "head of security's laptop"
	desc = "A portable computer belonging to the head of security. It smells faintly of gunpowder."
	_app_preset_type = /datum/modular_computer_app_presets/security/hos

// Civilian
/obj/item/modular_computer/laptop/preset/civilian
	_app_preset_type = /datum/modular_computer_app_presets/civilian
	enrolled = DEVICE_COMPANY

// Supply
/obj/item/modular_computer/laptop/preset/supply
	name = "supply laptop"
	desc = "A portable computer belonging to cargo."
	_app_preset_type = /datum/modular_computer_app_presets/supply
	enrolled = DEVICE_COMPANY

/obj/item/modular_computer/laptop/preset/supply/om
	name = "operations manager's laptop"
	desc = "A portable computer belonging to the operation's manager."
	_app_preset_type = /datum/modular_computer_app_presets/supply/om

/obj/item/modular_computer/laptop/preset/supply/robotics
	name = "robotics laptop"
	desc = "A portable computer with support for specialized robotics software."
	_app_preset_type = /datum/modular_computer_app_presets/supply/machinist

/obj/item/modular_computer/laptop/preset/supply/robotics/install_default_hardware()
	..()
	access_cable_dongle = new /obj/item/computer_hardware/access_cable_dongle(src)

// Representative
/obj/item/modular_computer/laptop/preset/representative
	name = "representative's laptop"
	desc = "A portable computer belonging to the representative's office."
	_app_preset_type = /datum/modular_computer_app_presets/representative
	enrolled = DEVICE_COMPANY
