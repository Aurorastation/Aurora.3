//Insert slots allow items to be inserted into assemblies from outside.
//These items can then be used by other components through ref pins.

/obj/item/integrated_circuit/insert_slot
	category_text = "Insert slot"
	var/capacity = 0
	var/list/allowed_types = list()
	var/list/items_contained = list()

	activators = list(
		"eject contents" = IC_PINTYPE_PULSE_IN,
		"on inserted" = IC_PINTYPE_PULSE_OUT,
		"on ejected" = IC_PINTYPE_PULSE_OUT
	)

	outputs = list(
		"has item" = IC_PINTYPE_BOOLEAN,
		"slot reference" = IC_PINTYPE_REF,
		"item reference" = IC_PINTYPE_REF,
		"item name" = IC_PINTYPE_STRING,
		"stored count" = IC_PINTYPE_NUMBER,
		"remaining capacity" = IC_PINTYPE_NUMBER
	)

	power_draw_per_use = 10
	w_class = WEIGHT_CLASS_NORMAL
	size = 5
	complexity = 1

/obj/item/integrated_circuit/insert_slot/Initialize()
	. = ..()
	items_contained = list()
	update_outputs()

/obj/item/integrated_circuit/insert_slot/interact(mob/user)
	update_outputs()
	. = ..()

/obj/item/integrated_circuit/insert_slot/proc/get_first_item()
	if(items_contained.len)
		return items_contained[1]
	return null

//Call this from components that want to get items from this component.
//Set remove to FALSE if you do not want the item removed from the slot and just want a reference.
/obj/item/integrated_circuit/insert_slot/proc/get_item(var/remove = FALSE)
	if(items_contained.len > 0)
		var/obj/item/item_to_return = items_contained[1]

		if(remove)
			items_contained -= item_to_return
			update_outputs()
			push_data()

		return item_to_return

	return null

/obj/item/integrated_circuit/insert_slot/proc/update_outputs()
	var/obj/item/held_item = get_first_item()

	set_pin_data(IC_OUTPUT, 1, !!held_item)
	set_pin_data(IC_OUTPUT, 2, src)
	set_pin_data(IC_OUTPUT, 3, held_item)
	set_pin_data(IC_OUTPUT, 4, held_item ? held_item.name : null)
	set_pin_data(IC_OUTPUT, 5, items_contained.len)
	set_pin_data(IC_OUTPUT, 6, max(capacity - items_contained.len, 0))

/obj/item/integrated_circuit/insert_slot/do_work()
	while(items_contained.len)
		var/obj/item/O = items_contained[1]
		items_contained -= O
		O.forceMove(get_turf(src))
		visible_message(SPAN_NOTICE("\The [src] drops [O] on the ground."))

	update_outputs()
	push_data()
	activate_pin(3)
	return TRUE

/obj/item/integrated_circuit/insert_slot/proc/insert(var/obj/item/O, var/mob/user)
	if(!O || !user)
		return FALSE

	if(!is_type_in_list(O, allowed_types))
		return FALSE

	if(items_contained.len >= capacity)
		to_chat(user, SPAN_WARNING("\The [src] is too full to add [O]."))
		return FALSE

	items_contained += O
	user.drop_from_inventory(O, src)

	to_chat(user, SPAN_NOTICE("You add [O] to \the [src]."))

	update_outputs()
	push_data()
	activate_pin(2)
	return TRUE

/obj/item/integrated_circuit/insert_slot/paper_tray
	name = "paper tray"
	desc = "A simple paper tray similar to one from a printer."
	extended_desc = "A simple paper tray. Paper can be inserted and used by other components. Holds 10 sheets. \
	The slot reference output can be wired directly into printer paper-source inputs."
	capacity = 10
	size = 8
	power_draw_per_use = 30
	allowed_types = list(/obj/item/paper)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

	outputs = list(
		"has item" = IC_PINTYPE_BOOLEAN,
		"slot reference" = IC_PINTYPE_REF,
		"item reference" = IC_PINTYPE_REF,
		"item name" = IC_PINTYPE_STRING,
		"stored count" = IC_PINTYPE_NUMBER,
		"remaining capacity" = IC_PINTYPE_NUMBER,
		"top paper text" = IC_PINTYPE_STRING,
		"top paper used length" = IC_PINTYPE_NUMBER
	)

/obj/item/integrated_circuit/insert_slot/paper_tray/update_outputs()
	..()

	var/obj/item/paper/P = get_first_item()

	if(P)
		set_pin_data(IC_OUTPUT, 7, P.info)
		set_pin_data(IC_OUTPUT, 8, length(P.info))
	else
		set_pin_data(IC_OUTPUT, 7, null)
		set_pin_data(IC_OUTPUT, 8, 0)

/obj/item/integrated_circuit/insert_slot/beaker_holder
	name = "beaker holder"
	desc = "A slot for holding a beaker."
	extended_desc = "A slot for holding a beaker with reagents. It has a bracket to hold the beaker in place and a lid to prevent spillage. \
	The slot reference output can be wired directly into reagent pump source inputs."
	capacity = 1
	allowed_types = list(/obj/item/reagent_containers/glass/beaker)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_BIO = 2, TECH_MATERIAL = 2)

	outputs = list(
		"has item" = IC_PINTYPE_BOOLEAN,
		"slot reference" = IC_PINTYPE_REF,
		"item reference" = IC_PINTYPE_REF,
		"item name" = IC_PINTYPE_STRING,
		"stored count" = IC_PINTYPE_NUMBER,
		"remaining capacity" = IC_PINTYPE_NUMBER,
		"reagent volume" = IC_PINTYPE_NUMBER,
		"maximum volume" = IC_PINTYPE_NUMBER,
		"free space" = IC_PINTYPE_NUMBER,
		"reagent names" = IC_PINTYPE_LIST
	)

/obj/item/integrated_circuit/insert_slot/beaker_holder/update_outputs()
	..()

	var/obj/item/reagent_containers/glass/beaker/B = get_first_item()
	var/list/reagent_names = list()

	if(B && B.reagents)
		for(var/_RE in B.reagents.reagent_volumes)
			var/singleton/reagent/RE = GET_SINGLETON(_RE)
			reagent_names += RE.name

		set_pin_data(IC_OUTPUT, 7, B.reagents.total_volume)
		set_pin_data(IC_OUTPUT, 8, B.reagents.maximum_volume)
		set_pin_data(IC_OUTPUT, 9, REAGENTS_FREE_SPACE(B.reagents))
		set_pin_data(IC_OUTPUT, 10, reagent_names)
	else
		set_pin_data(IC_OUTPUT, 7, 0)
		set_pin_data(IC_OUTPUT, 8, 0)
		set_pin_data(IC_OUTPUT, 9, 0)
		set_pin_data(IC_OUTPUT, 10, list())

/obj/item/integrated_circuit/insert_slot/id_slot
	name = "ID card slot"
	desc = "A slot for holding and reading an ID card."
	extended_desc = "A narrow slot for holding a single ID card. Outputs the card reference, registered name, assignment, job title, corporation, and access list. \
	If credential caching is enabled, inserted access is copied to the assembly access card."
	capacity = 1
	size = 4
	power_draw_per_use = 15
	allowed_types = list(/obj/item/card/id)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)

	inputs = list(
		"enable credential cache" = IC_PINTYPE_BOOLEAN
	)

	outputs = list(
		"has item" = IC_PINTYPE_BOOLEAN,
		"slot reference" = IC_PINTYPE_REF,
		"item reference" = IC_PINTYPE_REF,
		"item name" = IC_PINTYPE_STRING,
		"stored count" = IC_PINTYPE_NUMBER,
		"remaining capacity" = IC_PINTYPE_NUMBER,
		"registered name" = IC_PINTYPE_STRING,
		"assignment" = IC_PINTYPE_STRING,
		"job title" = IC_PINTYPE_STRING,
		"corporation" = IC_PINTYPE_STRING,
		"passkey" = IC_PINTYPE_LIST
	)

/obj/item/integrated_circuit/insert_slot/id_slot/insert(var/obj/item/O, var/mob/user)
	. = ..()
	if(.)
		cache_access_if_enabled(O)

/obj/item/integrated_circuit/insert_slot/id_slot/proc/cache_access_if_enabled(var/obj/item/I)
	if(!get_pin_data(IC_INPUT, 1))
		return

	if(!assembly || !assembly.access_card)
		return

	var/list/access = I.GetAccess()
	if(access)
		assembly.access_card.access |= access

/obj/item/integrated_circuit/insert_slot/id_slot/update_outputs()
	..()

	var/obj/item/I = get_first_item()
	set_pin_data(IC_OUTPUT, 1, !!I)
	set_pin_data(IC_OUTPUT, 2, src)
	set_pin_data(IC_OUTPUT, 3, I)
	set_pin_data(IC_OUTPUT, 4, I ? I.name : null)
	set_pin_data(IC_OUTPUT, 5, I ? 1 : 0)
	set_pin_data(IC_OUTPUT, 6, I ? 0 : capacity)
	var/obj/item/card/id/card = null
	var/list/access = null

	if(I)
		card = I.GetID()
		access = I.GetAccess()

	if(card)
		var/list/split_assignment = ic_split_assignment(card.assignment)

		set_pin_data(IC_OUTPUT, 7, card.registered_name)
		set_pin_data(IC_OUTPUT, 8, card.assignment)
		set_pin_data(IC_OUTPUT, 9, split_assignment["job title"])
		set_pin_data(IC_OUTPUT, 10, split_assignment["corporation"])
		set_pin_data(IC_OUTPUT, 11, access ? access : list())
	else
		set_pin_data(IC_OUTPUT, 7, null)
		set_pin_data(IC_OUTPUT, 8, null)
		set_pin_data(IC_OUTPUT, 9, null)
		set_pin_data(IC_OUTPUT, 10, null)
		set_pin_data(IC_OUTPUT, 11, list())

/obj/item/integrated_circuit/insert_slot/card_slot
	name = "card slot"
	desc = "A generic slot for holding and reading card-like objects."
	extended_desc = "A generic card slot. It accepts any card object, outputs the held item reference, and attempts to read access data from it."
	capacity = 1
	size = 4
	power_draw_per_use = 15
	allowed_types = list(/obj/item/card)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)

	inputs = list(
		"enable credential cache" = IC_PINTYPE_BOOLEAN
	)

	outputs = list(
		"has item" = IC_PINTYPE_BOOLEAN,
		"slot reference" = IC_PINTYPE_REF,
		"item reference" = IC_PINTYPE_REF,
		"item name" = IC_PINTYPE_STRING,
		"stored count" = IC_PINTYPE_NUMBER,
		"remaining capacity" = IC_PINTYPE_NUMBER,
		"registered name" = IC_PINTYPE_STRING,
		"assignment" = IC_PINTYPE_STRING,
		"job title" = IC_PINTYPE_STRING,
		"corporation" = IC_PINTYPE_STRING,
		"passkey" = IC_PINTYPE_LIST,
		"has access data" = IC_PINTYPE_BOOLEAN
	)

/obj/item/integrated_circuit/insert_slot/card_slot/insert(var/obj/item/O, var/mob/user)
	. = ..()
	if(.)
		cache_access_if_enabled(O)

/obj/item/integrated_circuit/insert_slot/card_slot/proc/cache_access_if_enabled(var/obj/item/I)
	if(!get_pin_data(IC_INPUT, 1))
		return

	if(!assembly || !assembly.access_card)
		return

	var/list/access = I.GetAccess()
	if(access)
		assembly.access_card.access |= access

/obj/item/integrated_circuit/insert_slot/card_slot/update_outputs()
	..()

	var/obj/item/I = get_first_item()
	var/obj/item/card/id/card = null
	var/list/access = null

	if(I)
		card = I.GetID()
		access = I.GetAccess()

	if(card)
		var/list/split_assignment = ic_split_assignment(card.assignment)

		set_pin_data(IC_OUTPUT, 7, card.registered_name)
		set_pin_data(IC_OUTPUT, 8, card.assignment)
		set_pin_data(IC_OUTPUT, 9, split_assignment["job title"])
		set_pin_data(IC_OUTPUT, 10, split_assignment["corporation"])
		set_pin_data(IC_OUTPUT, 11, access ? access : list())
		set_pin_data(IC_OUTPUT, 12, TRUE)
	else
		set_pin_data(IC_OUTPUT, 7, null)
		set_pin_data(IC_OUTPUT, 8, null)
		set_pin_data(IC_OUTPUT, 9, null)
		set_pin_data(IC_OUTPUT, 10, null)
		set_pin_data(IC_OUTPUT, 11, access ? access : list())
		set_pin_data(IC_OUTPUT, 12, !!length(access))

/obj/item/integrated_circuit/insert_slot/power_cell_slot
	name = "power cell slot"
	desc = "A socket for holding and reading a power cell."
	extended_desc = "A reinforced socket that holds a single power cell. Outputs charge, maximum charge, and charge percentage."
	capacity = 1
	size = 7
	power_draw_per_use = 20
	allowed_types = list(/obj/item/cell)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)

	outputs = list(
		"has item" = IC_PINTYPE_BOOLEAN,
		"slot reference" = IC_PINTYPE_REF,
		"item reference" = IC_PINTYPE_REF,
		"item name" = IC_PINTYPE_STRING,
		"stored count" = IC_PINTYPE_NUMBER,
		"remaining capacity" = IC_PINTYPE_NUMBER,
		"cell charge" = IC_PINTYPE_NUMBER,
		"max charge" = IC_PINTYPE_NUMBER,
		"percentage" = IC_PINTYPE_NUMBER
	)

/obj/item/integrated_circuit/insert_slot/power_cell_slot/update_outputs()
	..()

	var/obj/item/cell/C = get_first_item()

	if(C)
		set_pin_data(IC_OUTPUT, 7, C.charge)
		set_pin_data(IC_OUTPUT, 8, C.maxcharge)
		set_pin_data(IC_OUTPUT, 9, C.percent())
	else
		set_pin_data(IC_OUTPUT, 7, 0)
		set_pin_data(IC_OUTPUT, 8, 0)
		set_pin_data(IC_OUTPUT, 9, 0)


/obj/item/integrated_circuit/insert_slot/storage_slot
	name = "storage slot"
	desc = "A bracket for holding a storage container."
	extended_desc = "A bracket that can hold one storage item. Outputs the storage reference for scanner, grabber, sorter, or custom storage logic."
	capacity = 1
	size = 8
	power_draw_per_use = 25
	allowed_types = list(/obj/item/storage)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

	outputs = list(
		"has item" = IC_PINTYPE_BOOLEAN,
		"slot reference" = IC_PINTYPE_REF,
		"item reference" = IC_PINTYPE_REF,
		"item name" = IC_PINTYPE_STRING,
		"stored count" = IC_PINTYPE_NUMBER,
		"remaining capacity" = IC_PINTYPE_NUMBER,
		"storage reference" = IC_PINTYPE_REF,
		"contained item count" = IC_PINTYPE_NUMBER
	)

/obj/item/integrated_circuit/insert_slot/storage_slot/update_outputs()
	..()

	var/obj/item/storage/S = get_first_item()

	if(S)
		set_pin_data(IC_OUTPUT, 7, S)
		set_pin_data(IC_OUTPUT, 8, S.contents.len)
	else
		set_pin_data(IC_OUTPUT, 7, null)
		set_pin_data(IC_OUTPUT, 8, 0)

/obj/item/integrated_circuit/insert_slot/tool_slot
	name = "tool slot"
	desc = "A reinforced slot for holding a tool."
	extended_desc = "A utility slot that can hold one tool or general item. Outputs the held item reference for machines that require a physical tool."
	capacity = 1
	size = 6
	power_draw_per_use = 20
	allowed_types = list(/obj/item)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

	outputs = list(
		"has item" = IC_PINTYPE_BOOLEAN,
		"slot reference" = IC_PINTYPE_REF,
		"item reference" = IC_PINTYPE_REF,
		"item name" = IC_PINTYPE_STRING,
		"stored count" = IC_PINTYPE_NUMBER,
		"remaining capacity" = IC_PINTYPE_NUMBER,
		"tool reference" = IC_PINTYPE_REF
	)

/obj/item/integrated_circuit/insert_slot/tool_slot/update_outputs()
	..()

	var/obj/item/I = get_first_item()
	set_pin_data(IC_OUTPUT, 7, I)

/obj/item/integrated_circuit/insert_slot/item_tray
	name = "general item tray"
	desc = "A generic tray for holding small items."
	extended_desc = "A broad item tray. It accepts ordinary items and exposes the held item reference, name, count, and remaining capacity. \
	Use this when a more specific insert slot does not exist."
	capacity = 5
	size = 8
	power_draw_per_use = 20
	allowed_types = list(/obj/item)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)
