/obj/machinery/fabricator/micro
	name = "microlathe"
	desc = "It produces small items from common resources."
	icon = 'icons/obj/machinery/fabricators/microlathe.dmi'
	icon_state = "minilathe"
	idle_power_usage = 5
	active_power_usage = 1000
	fabricator_class = FABRICATOR_CLASS_MICRO
	base_storage_capacity = list(
		MATERIAL_ALUMINIUM = 5000,
		MATERIAL_GLASS = 5000,
		MATERIAL_PLASTIC = 5000
	)
	manufacturer = "idris"

//Subtype for mapping, starts preloaded and set to print glasses
/obj/machinery/fabricator/micro/bartender
	show_category = "Drinking Glasses"

/obj/machinery/fabricator/micro/bartender/Initialize()
	. = ..()
	stored_material[MATERIAL_GLASS] = base_storage_capacity[MATERIAL_GLASS]
