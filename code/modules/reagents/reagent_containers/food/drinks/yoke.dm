/obj/item/storage/box/fancy/yoke
	name = "yoke"
	desc = "A sturdy device made out of bio-friendly materials. This will hold your canned drinks together easy peasy."
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

/obj/item/storage/box/fancy/yoke/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Click drag it to pick it up, click on it to take out a can."

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

	// Calling this here so the appended names change when cans are removed from the yoke.
	append_cans()

/// We use this to append the names of the cans in a yoke to its name, for QoL.
/obj/item/storage/box/fancy/yoke/proc/append_cans()
	// Return early and use the initial name if there's no cans, so we don't have stray brackets.
	if(!length(cans))
		name = initial(name)
		return

	// Names of cans in the yoke that we are selecting to append to the name. No names in this should repeat.
	var/list/taken_names = list()

	for(var/obj/can in cans)
		taken_names |= can.name

	// We end this at the third item, so at maximum two items in the yoke will be in the name.
	var/can_name_string = initial(name) + " (" + jointext(taken_names, ", ", 1, 3)

	if(length(taken_names) > 2)
		can_name_string += ", ...)"
	else
		can_name_string += ")"

	name = can_name_string

/obj/item/storage/box/fancy/yoke/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	var/mob/mob_dropped_over = over
	if(use_check_and_message(mob_dropped_over))
		return
	to_chat(mob_dropped_over, SPAN_NOTICE("You pick up \the [src]."))
	mob_dropped_over.put_in_hands(src)

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
		)
		var/list/rare_soda_options = list(
			/obj/item/reagent_containers/food/drinks/cans/peach_soda,
			/obj/item/reagent_containers/food/drinks/cans/melon_soda,
			/obj/item/reagent_containers/food/drinks/cans/himeokvass,
			/obj/item/reagent_containers/food/drinks/cans/xanuchai,
			/obj/item/reagent_containers/food/drinks/cans/beetle_milk,
			/obj/item/reagent_containers/food/drinks/cans/threetowns
		)

		var/path = pick(soda_options)
		if(prob(10))
			path = pick(rare_soda_options)
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

// soda

/obj/item/storage/box/fancy/yoke/cola
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/cola = 6)

/obj/item/storage/box/fancy/yoke/space_mountain_wind
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 6)

/obj/item/storage/box/fancy/yoke/thirteenloko
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/thirteenloko = 6)

/obj/item/storage/box/fancy/yoke/dr_gibb
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 6)

/obj/item/storage/box/fancy/yoke/starkist
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/starkist = 6)

/obj/item/storage/box/fancy/yoke/space_up
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/space_up = 6)

/obj/item/storage/box/fancy/yoke/lemon_lime
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/lemon_lime = 6)

/obj/item/storage/box/fancy/yoke/iced_tea
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/iced_tea = 6)

/obj/item/storage/box/fancy/yoke/grape_juice
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/grape_juice = 6)

/obj/item/storage/box/fancy/yoke/tonic
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/tonic = 6)

/obj/item/storage/box/fancy/yoke/sodawater
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/sodawater = 6)

/obj/item/storage/box/fancy/yoke/root_beer
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/root_beer = 6)

/obj/item/storage/box/fancy/yoke/diet_cola
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/diet_cola = 6)

/obj/item/storage/box/fancy/yoke/peach_soda
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/peach_soda = 6)

/obj/item/storage/box/fancy/yoke/melon_soda
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/melon_soda = 6)

/obj/item/storage/box/fancy/yoke/himeokvass
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/himeokvass = 6)

/obj/item/storage/box/fancy/yoke/xanuchai
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/xanuchai = 6)

/obj/item/storage/box/fancy/yoke/beetle_milk
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/beetle_milk = 6)

// alcoholic drinks

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

/obj/item/storage/box/fancy/yoke/threetowns
	starts_with = list(/obj/item/reagent_containers/food/drinks/cans/threetowns = 6)

// Energy drinks
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
