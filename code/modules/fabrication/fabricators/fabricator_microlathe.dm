/obj/machinery/fabricator/microlathe
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
		MATERIAL_PLASTIC = 5000,
		MATERIAL_BAMBOO = 5000
	)
	manufacturer = "idris"

	component_types = list(
		/obj/item/circuitboard/microlathe,
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/micro_laser,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/console_screen
	)

	fabricating_sound_loop = /datum/looping_sound/fabricator/minilathe

//Subtype for mapping, starts preloaded and set to print glasses
/obj/machinery/fabricator/microlathe/bartender
	show_category = "Drinking Glasses"

/obj/machinery/fabricator/microlathe/bartender/Initialize(mapload)
	. = ..()
	stored_material[MATERIAL_GLASS] = storage_capacity[MATERIAL_GLASS]

//Subtype for mapping, starts preloaded and set to print cutlery
/obj/machinery/fabricator/microlathe/cafe
	show_category = "Cutlery"

/obj/machinery/fabricator/microlathe/cafe/Initialize(mapload)
	. = ..()
	stored_material[MATERIAL_PLASTIC] = storage_capacity[MATERIAL_PLASTIC]
	stored_material[MATERIAL_BAMBOO] = storage_capacity[MATERIAL_BAMBOO]
