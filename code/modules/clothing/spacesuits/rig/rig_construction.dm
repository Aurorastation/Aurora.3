/obj/item/rig_assembly
	name = "hardsuit control module assembly"
	icon = 'icons/obj/rig_modules.dmi'
	desc = "An assembly frame of back-mounted hardsuit deployment and control mechanism."
	slot_flags = SLOT_BACK
	w_class = 4
	var/obj/item/weapon/circuitboard/circuit = null
	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null
	var/state = 1

/obj/item/rig_assembly/ce
	name = "advanced voidsuit control module assembly"
	desc = "An assembly frame for an advanced voidsuit that protects against hazardous, low pressure environments."
