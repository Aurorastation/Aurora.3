/obj/item/storage/box/fancy/yoke
	name = "yoke"
	desc = "A sturdy device made out of bio-friendly materials. This will hold your canned drinks together easy peasy."
	desc_info = "Click drag it to pick it up, click on it to take out a can."
	icon = 'icons/obj/item/reagent_containers/food/drinks/soda.dmi'
	icon_state = "yoke"
	center_of_mass = list("x" = 16,"y" = 9)
	can_hold = list()
	starts_with = list()
	storage_slots = 6
	icon_overlays = FALSE
	closable = FALSE
	var/list/obj/item/reagent_containers/food/drinks/cans/cans = list()
	var/list/can_positions = list( // these are the correct positions for energy drinks achieved via trial and error
		list(10, -6),
		list(10, 2),
		list(0, -6),
		list(0, 2),
		list(-10, -6),
		list(-10, 2)
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

/obj/item/storage/box/fancy/yoke/attackby(obj/item/attacking_item, mob/user)
	to_chat(user, SPAN_WARNING("\The [src] cannot be refilled with items!"))

/obj/item/storage/box/fancy/yoke/random
	starts_with = list()

/obj/item/storage/box/fancy/yoke/random/fill()
	for(var/i = 1 to 6)
		var/list/soda_options = list(
			/obj/item/reagent_containers/food/drinks/cans/cola,
			/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind,
			/obj/item/reagent_containers/food/drinks/cans/thirteenloko,
			/obj/item/reagent_containers/food/drinks/cans/dr_gibb,
			/obj/item/reagent_containers/food/drinks/cans/starkist,
			/obj/item/reagent_containers/food/drinks/cans/space_up,
			/obj/item/reagent_containers/food/drinks/cans/lemon_lime,
			/obj/item/reagent_containers/food/drinks/cans/iced_tea,
			/obj/item/reagent_containers/food/drinks/cans/grape_juice,
			/obj/item/reagent_containers/food/drinks/cans/tonic,
			/obj/item/reagent_containers/food/drinks/cans/sodawater,
			/obj/item/reagent_containers/food/drinks/cans/root_beer,
			/obj/item/reagent_containers/food/drinks/cans/diet_cola,
			/obj/item/reagent_containers/food/drinks/cans/peach_soda,
			/obj/item/reagent_containers/food/drinks/cans/melon_soda,
			/obj/item/reagent_containers/food/drinks/cans/himeokvass,
			/obj/item/reagent_containers/food/drinks/cans/xanuchai
		)
		var/path = pick(soda_options)
		if(starts_with[path])
			starts_with[path] = starts_with[path] + 1
		else
			starts_with[path] = 1
	return ..()

/obj/item/storage/box/fancy/yoke/alcoholic/random/fill()
	for(var/i = 1 to 6)
		var/list/soda_options = list(
			/obj/item/reagent_containers/food/drinks/cans/beer,
			/obj/item/reagent_containers/food/drinks/cans/beer/rice,
			/obj/item/reagent_containers/food/drinks/cans/beer/rice/shimauma,
			/obj/item/reagent_containers/food/drinks/cans/beer/rice/moonlabor,
			/obj/item/reagent_containers/food/drinks/cans/beer/earthmover,
			/obj/item/reagent_containers/food/drinks/cans/beer/whistlingforest
		)
		var/path = pick(soda_options)
		if(starts_with[path])
			starts_with[path] = starts_with[path] + 1
		else
			starts_with[path] = 1
	return ..()

/obj/item/storage/box/fancy/yoke/beer
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/beer = 6)

/obj/item/storage/box/fancy/yoke/ebisu
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/beer/rice = 6)

/obj/item/storage/box/fancy/yoke/shimauma
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/beer/rice/shimauma = 6)

/obj/item/storage/box/fancy/yoke/moonlabor
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/beer/rice/moonlabor = 6)

/obj/item/storage/box/fancy/yoke/earthmover
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/beer/earthmover = 6)

/obj/item/storage/box/fancy/yoke/whistlingforest
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/beer/whistlingforest = 6)

/obj/item/storage/box/fancy/yoke/energy
	icon_state = "yoke_energy" //energy drinks are 2 pixels taller

/obj/item/storage/box/fancy/yoke/energy/zoracherry
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/zorasoda/cherry = 6)

/obj/item/storage/box/fancy/yoke/energy/zoraphoron
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/zorasoda/phoron = 6)

/obj/item/storage/box/fancy/yoke/energy/zoraklax
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/zorasoda/klax = 6)

/obj/item/storage/box/fancy/yoke/energy/zoracthur
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/zorasoda/cthur = 6)

/obj/item/storage/box/fancy/yoke/energy/zoravenom
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/zorasoda/venomgrass = 6)

/obj/item/storage/box/fancy/yoke/energy/zorahozm
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/zorasoda/hozm = 6)

/obj/item/storage/box/fancy/yoke/energy/zorakois
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/zorasoda/kois = 6)

/obj/item/storage/box/fancy/yoke/energy/random
	starts_with = list()

/obj/item/storage/box/fancy/yoke/energy/random/fill()
	for(var/i = 1 to 6)
		var/list/energy_options = list(
			/obj/item/reagent_containers/food/drinks/cans/zorasoda/cherry,
			/obj/item/reagent_containers/food/drinks/cans/zorasoda/phoron,
			/obj/item/reagent_containers/food/drinks/cans/zorasoda/klax,
			/obj/item/reagent_containers/food/drinks/cans/zorasoda/cthur,
			/obj/item/reagent_containers/food/drinks/cans/zorasoda/venomgrass,
			/obj/item/reagent_containers/food/drinks/cans/zorasoda/hozm,
			/obj/item/reagent_containers/food/drinks/cans/zorasoda/kois
		)
		var/path = pick(energy_options)
		if(starts_with[path])
			starts_with[path] = starts_with[path] + 1
		else
			starts_with[path] = 1
	return ..()
