/obj/item/computer_hardware/universal_port
	name = "universal port"
	desc = "A small, universal slot wherein an access cable can be slotted in."
	critical = FALSE
	icon_state = "aislot"
	hardware_size = 3

	/// The access cable currently inserted into this slot.
	var/obj/item/access_cable/access_cable

/obj/item/computer_hardware/universal_port/Destroy()
	if(access_cable)
		access_cable.retract()
	access_cable = null
	return ..()

/obj/item/computer_hardware/universal_port/remove_cable(obj/item/access_cable/cable)
	access_cable = null

/obj/item/computer_hardware/universal_port/insert_cable(obj/item/access_cable/cable, mob/user)
	. = ..()
	access_cable = cable
	cable.create_cable(cable.beam_source, parent_computer)

/obj/item/computer_hardware/universal_port/cable_interact(obj/item/access_cable/cable, mob/user)
	. = ..()
	if(parent_computer)
		parent_computer.attack_self(user)
