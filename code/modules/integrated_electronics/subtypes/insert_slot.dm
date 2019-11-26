//Insert slots allow items to be inserted into assemblies from outside
//These items can then be used by other components
/obj/item/integrated_circuit/insert_slot
	category_text = "Insert slot"
	var/capacity = 0
	var/list/allowed_types = list()
	var/list/items_contained = list()
	activators = list("eject contents" = IC_PINTYPE_PULSE_IN)
	outputs = list("has item" = IC_PINTYPE_BOOLEAN)
	power_draw_per_use = 1 
	w_class = ITEMSIZE_NORMAL
	size = 5
	complexity = 1

//call this function from components that want to get items from this component
//set remove to FALSE if you dont want the item removed from the component and just want a reference to it 
//(e.g. for beakers)
/obj/item/integrated_circuit/insert_slot/proc/get_item(var/remove = FALSE)
	if(items_contained.len > 0)
		var/itemToReturn = items_contained[1]
		if(remove)
			items_contained -= itemToReturn
			if(items_contained.len <= 0)
				set_pin_data(IC_OUTPUT, 1, FALSE)
				push_data()
		return itemToReturn
	return null

/obj/item/integrated_circuit/insert_slot/do_work()
	for(var/obj/item/O in items_contained)
		O.forceMove(get_turf(src))
		visible_message("<span class='notice'>\The [src] drops [O] on the ground.</span>")
		items_contained -= O
	set_pin_data(IC_OUTPUT, 1, FALSE)
	push_data()
	return TRUE

/obj/item/integrated_circuit/insert_slot/proc/insert(var/obj/item/O, var/mob/user)
	if(is_type_in_list(O, allowed_types))
		if(items_contained.len >= capacity)
			to_chat(user, "<span class='warning'>\The [src] is too full to add [O].</span>")
			return FALSE
		items_contained += O
		user.drop_from_inventory(O,src)
		to_chat(user, "<span class='notice'>You add [O] to \the [src].</span>")
		set_pin_data(IC_OUTPUT, 1, TRUE)
		return TRUE

/obj/item/integrated_circuit/insert_slot/paper_tray
	name = "paper tray"
	desc = "A simple paper tray similar to one from a printer."
	extended_desc = "A simple paper tray, paper can be inserted and used by other components. \
	Paper can be inserted through a slot in the casing. Holds 10 sheets"
	capacity = 10
	size = 8
	power_draw_per_use = 3
	allowed_types = list(/obj/item/paper)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_MATERIALS = 2)

/obj/item/integrated_circuit/insert_slot/beaker_holder
	name = "beaker holder"
	desc = "A slot for holding a beaker"
	extended_desc = "A slot for holding a beaker with reagents. \
	It has a bracket to hold the beaker in place and a lid to prevent spillage. \
	There is an extraction tube built into the lid"
	capacity = 1
	allowed_types = list(/obj/item/reagent_containers/glass/beaker)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_BIO = 2, TECH_MATERIALS = 2)
