/obj/item/storage/box/fancy/yoke
	name = "yoke"
	desc = "A sturdy device made out of bio-friendly materials. This will hold your energy drinks together easy peasy."
	desc_info = "Click drag it to pick it up, click on it to take out a can."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "yoke"
	center_of_mass = list("x" = 16,"y" = 9)
	can_hold = list()
	starts_with = list()
	storage_slots = 6
	icon_overlays = FALSE
	closable = FALSE
	var/list/obj/item/reagent_containers/food/drinks/cans/cans = list()
	var/list/can_positions = list( // these are the correct positions for energy drinks achieved via trial and error
		list(4, -4),
		list(-2, -2),
		list(-8, 0),
		list(9, -3),
		list(4, 0),
		list(-2, 3)
	)

/obj/item/storage/box/fancy/yoke/fill()
	. = ..()
	for(var/obj/item/reagent_containers/food/drinks/cans/C in contents)
		cans += C

/obj/item/storage/box/fancy/yoke/update_icon()
	for(var/thing in underlays)
		underlays -= thing

	for(var/i = 1 to length(cans))
		var/mutable_appearance/can = mutable_appearance(cans[i].icon, cans[i].icon_state)
		var/list/positions = can_positions[i]
		can.pixel_x = positions[1]
		can.pixel_y = positions[2]
		underlays += can

/obj/item/storage/box/fancy/yoke/MouseDrop(mob/user)
	if(use_check_and_message(user))
		return
	to_chat(user, SPAN_NOTICE("You pick up \the [src]."))
	user.put_in_hands(src)

/obj/item/storage/box/fancy/yoke/attack_hand(mob/user)
	if(!length(contents)) // no more cans, continue as normal
		return ..()

	if(use_check_and_message(user))
		return
	
	var/obj/item/reagent_containers/food/drinks/cans/C = cans[length(cans)]
	cans -= C
	remove_from_storage(C, get_turf(user))
	user.put_in_hands(C)
	update_icon()

/obj/item/storage/box/fancy/yoke/attackby(obj/item/W, mob/user)
	to_chat(user, SPAN_WARNING("\The [src] cannot be refilled with items!"))

/obj/item/storage/box/fancy/yoke/zoracherry
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/can_50cl/zora_soda/cherry = 6)

/obj/item/storage/box/fancy/yoke/zoraphoron
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/can_50cl/zora_soda/phoron_passion = 6)

/obj/item/storage/box/fancy/yoke/zoraklax
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/can_50cl/zora_soda/energy_crush = 6)

/obj/item/storage/box/fancy/yoke/zoracthur
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/can_50cl/zora_soda/rockin_raspberry = 6)

/obj/item/storage/box/fancy/yoke/zoravenom
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/can_50cl/zora_soda/sour_venom_grass = 6)

/obj/item/storage/box/fancy/yoke/zorahozm
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/can_50cl/zora_soda/hozm = 6)

/obj/item/storage/box/fancy/yoke/zorakois
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/can_50cl/zora_soda/kois_twist = 6)

/obj/item/storage/box/fancy/yoke/random
	starts_with = list()

/obj/item/storage/box/fancy/yoke/random/fill()
	for(var/i = 1 to 6)
		var/list/energy_options = list(
			/obj/item/reagent_containers/food/drinks/cans/can_50cl/zora_soda/cherry,
			/obj/item/reagent_containers/food/drinks/cans/can_50cl/zora_soda/phoron_passion,
			/obj/item/reagent_containers/food/drinks/cans/can_50cl/zora_soda/energy_crush,
			/obj/item/reagent_containers/food/drinks/cans/can_50cl/zora_soda/rockin_raspberry,
			/obj/item/reagent_containers/food/drinks/cans/can_50cl/zora_soda/sour_venom_grass,
			/obj/item/reagent_containers/food/drinks/cans/can_50cl/zora_soda/hozm,
			/obj/item/reagent_containers/food/drinks/cans/can_50cl/zora_soda/kois_twist
		)
		var/path = pick(energy_options)
		if(starts_with[path])
			starts_with[path] = starts_with[path] + 1
		else
			starts_with[path] = 1
	return ..()