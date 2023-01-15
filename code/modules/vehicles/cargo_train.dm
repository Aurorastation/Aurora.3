/obj/vehicle/train/cargo/engine
	name = "cargo train tug"
	desc = "A ridable electric car designed for pulling cargo trolleys."
	desc_info = "Click resist, or type resist into the red bar below to get off. Use ctrl-click to quickly toggle the engine if you're adjacent (only when vehicle is stationary). Alt-click will grab the keys, if present. If latched, you can use a wrench to unlatch."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "cargo_engine"
	on = 0
	powered = 1
	locked = 0

	load_item_visible = 1
	load_offset_x = 0
	mob_offset_y = 7

	var/vueui_template = "trainengine"

	var/car_limit = 3		//how many cars an engine can pull before performance degrades
	active_engines = 1
	var/obj/item/key/key

/obj/item/key/cargo_train
	name = "key"
	desc = "A keyring with a small steel key, and a yellow fob reading \"Choo Choo!\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "train_keys"
	w_class = ITEMSIZE_TINY

/obj/vehicle/train/cargo/trolley
	name = "cargo train trolley"
	desc_info = "You can use a wrench to unlatch this."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "cargo_trailer"
	anchored = 0
	passenger_allowed = 0
	locked = 0

	load_item_visible = 1
	load_offset_x = 0
	load_offset_y = 4
	mob_offset_y = 8

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/train/cargo/engine/setup_vehicle()
	..()
	setup_engine()

/obj/vehicle/train/cargo/engine/proc/setup_engine()
	cell = new /obj/item/cell/high(src)
	key = new /obj/item/key/cargo_train(src)
	var/image/I = new(icon = icon, icon_state = "[icon_state]_overlay", layer = src.layer + 0.2) //over mobs
	add_overlay(I)
	turn_off()

/obj/vehicle/train/cargo/engine/attack_hand(mob/user)
	if(use_check_and_message(user))
		return
	if(!load || user == load) // no driver, or the user is the driver
		ui_interact(user)
		return
	..()

/obj/vehicle/train/cargo/engine/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)

	if(!ui)
		ui = new(user, src, "vehicles-[vueui_template]", 600, 400, capitalize_first_letters(initial(name)))
		ui.auto_update_content = TRUE

	ui.open()

/obj/vehicle/train/cargo/engine/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	if(!length(data))
		data = list()

	data["is_on"] = on
	data["has_key"] = !!key
	data["has_cell"] = !!cell
	if(cell)
		data["cell_charge"] = cell.charge
		data["cell_max_charge"] = cell.maxcharge
	data["is_towing"] = !!tow
	if(tow)
		data["tow"] = tow.name

	return data

/obj/vehicle/train/cargo/engine/Topic(href, href_list, state)
	. = ..()
	if(.)
		return TRUE

	if(load && load != usr)
		to_chat(usr, SPAN_WARNING("You can't interact with \the [src] while its in use."))
		return TRUE

	if(href_list["toggle_engine"])
		if(!on)
			start_engine(usr)
		else
			stop_engine(usr)
	if(href_list["key"])
		remove_key(usr)
	if(href_list["unlatch"])
		tow.unattach(usr)
	SSvueui.check_uis_for_change(src)

/obj/vehicle/train/cargo/engine/Move(var/turf/destination)
	if(on && cell.charge < charge_use)
		turn_off()
		update_stats()
		if(load && is_train_head())
			to_chat(load, "The drive motor briefly whines, then drones to a stop.")

	if(is_train_head() && !on)
		return 0

	//space check ~no flying space trains sorry
	if(on && istype(destination, /turf/space))
		return 0

	return ..()

/obj/vehicle/train/cargo/trolley/attackby(obj/item/W as obj, mob/user as mob)
	if(open && W.iswirecutter())
		passenger_allowed = !passenger_allowed
		user.visible_message("<span class='notice'>[user] [passenger_allowed ? "cuts" : "mends"] a cable in [src].</span>","<span class='notice'>You [passenger_allowed ? "cut" : "mend"] the load limiter cable.</span>")
	else
		..()

/obj/vehicle/train/cargo/engine/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/key/cargo_train))
		if(!key)
			user.drop_from_inventory(W, src)
			key = W
			to_chat(user, SPAN_NOTICE("You slide the key into the ignition."))
		else
			to_chat(user, SPAN_WARNING("\The [src] already has a key inserted."))
		return
	..()

// Cargo trains are open topped, so you can shoot at the driver.
// Or you can shoot at the tug itself, if you're good.
/obj/vehicle/train/cargo/bullet_act(var/obj/item/projectile/Proj)
	if (buckled && Proj.original == buckled)
		buckled.bullet_act(Proj)
	else
		..()

/obj/vehicle/train/cargo/update_icon()
	if(open)
		icon_state = initial(icon_state) + "_open"
	else
		icon_state = initial(icon_state)

/obj/vehicle/train/cargo/trolley/insert_cell(var/obj/item/cell/C, var/mob/living/carbon/human/H)
	return

/obj/vehicle/train/cargo/engine/insert_cell(var/obj/item/cell/C, var/mob/living/carbon/human/H)
	..()
	update_stats()

/obj/vehicle/train/cargo/engine/remove_cell(var/mob/living/carbon/human/H)
	..()
	update_stats()

/obj/vehicle/train/cargo/engine/Collide(atom/Obstacle)
	var/obj/machinery/door/D = Obstacle
	var/mob/living/carbon/human/H = load
	if(istype(D) && istype(H))
		H.Collide(D)		//a little hacky, but hey, it works, and respects access rights

	. = ..()

/obj/vehicle/train/cargo/trolley/Collide(atom/Obstacle)
	if(!lead)
		return //so people can't knock others over by pushing a trolley around
	. = ..()

//-------------------------------------------
// Train procs
//-------------------------------------------
/obj/vehicle/train/cargo/engine/turn_on()
	if(!key)
		audible_message("\The [src] whirrs, but the lack of a key causes it to shut down.")
		return
	else
		..()
		update_stats()

/obj/vehicle/train/cargo/RunOver(var/mob/living/carbon/human/H)
	var/list/parts = list(BP_HEAD, BP_CHEST, BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM)

	H.apply_effects(5, 5)
	for(var/i = 0, i < rand(1,5), i++)
		var/def_zone = pick(parts)
		H.apply_damage(rand(5,10), BRUTE, def_zone)

/obj/vehicle/train/cargo/trolley/RunOver(var/mob/living/carbon/human/H)
	..()
	attack_log += text("\[[time_stamp()]\] <span class='warning'>ran over [H.name] ([H.ckey])</span>")

/obj/vehicle/train/cargo/engine/RunOver(var/mob/living/carbon/human/H)
	..()

	if(is_train_head() && istype(load, /mob/living/carbon/human))
		var/mob/living/carbon/human/D = load
		to_chat(D, "<span class='danger'>You ran over [H]!</span>")
		visible_message("<span class='danger'>\The [src] ran over [H]!</span>")
		attack_log += text("\[[time_stamp()]\] <span class='warning'>ran over [H.name] ([H.ckey]), driven by [D.name] ([D.ckey])</span>")
		msg_admin_attack("[D.name] ([D.ckey]) ran over [H.name] ([H.ckey]). (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(D),ckey_target=key_name(H))
	else
		attack_log += text("\[[time_stamp()]\] <span class='warning'>ran over [H.name] ([H.ckey])</span>")


//-------------------------------------------
// Interaction procs
//-------------------------------------------
/obj/vehicle/train/cargo/engine/relaymove(mob/user, direction)
	if(user != load)
		return 0

	if(user.restrained())
		return 0

	if(is_train_head())
		if(direction == reverse_direction(dir) && tow)
			return 0
		if(Move(get_step(src, direction)))
			return 1
		return 0
	else
		return ..()

/obj/vehicle/train/cargo/engine/examine(mob/user)
	if(!..(user, 1))
		return

	if(!istype(usr, /mob/living/carbon/human))
		return

	to_chat(user, "The power light is [on ? "on" : "off"].\nThere are[key ? "" : " no"] keys in the ignition.")
	to_chat(user, "The charge meter reads [cell? round(cell.percent(), 0.01) : 0]%")

/obj/vehicle/train/cargo/engine/CtrlClick(var/mob/user)
	if(Adjacent(user))
		if(on)
			stop_engine(usr)
		else
			start_engine(usr)
	else
		return ..()

/obj/vehicle/train/cargo/engine/AltClick(var/mob/user)
	if(Adjacent(user))
		remove_key(user)
	else
		return ..()

/obj/vehicle/train/cargo/engine/proc/start_engine(var/mob/user)
	if(on)
		to_chat(user, SPAN_WARNING("The engine is already running."))
		return

	turn_on()
	if(on)
		to_chat(user, SPAN_NOTICE("You start \the [src]'s engine."))
	else if(cell.charge < charge_use)
		to_chat(user, SPAN_WARNING("\The [src] is out of power."))

/obj/vehicle/train/cargo/engine/proc/stop_engine(var/mob/user)
	if(!on)
		to_chat(user, SPAN_WARNING("The engine is already stopped."))
		return

	turn_off()
	if(!on)
		to_chat(user, SPAN_NOTICE("You stop [src]'s engine."))

/obj/vehicle/train/cargo/engine/proc/remove_key(var/mob/user)
	if(!key)
		to_chat(usr, SPAN_WARNING("\The [src] doesn't have a key inserted!"))
		return
	if(load && load != usr)
		return

	if(on)
		turn_off()

	user.put_in_hands(key)
	key = null

/obj/vehicle/train/cargo/engine/emag_act(var/remaining_charges, mob/user)
	. = ..()
	if(.)
		update_car(train_length, active_engines)

//-------------------------------------------
// Loading/unloading procs
//-------------------------------------------
/obj/vehicle/train/cargo/trolley/load(var/atom/movable/C)
	if(ismob(C) && !passenger_allowed)
		return 0
	if(!istype(C,/obj/machinery) && !istype(C,/obj/structure/closet) && !istype(C,/obj/structure/largecrate) && !istype(C,/obj/structure/reagent_dispensers) && !istype(C,/obj/structure/ore_box) && !istype(C, /mob/living/carbon/human))
		return 0

	//if there are any items you don't want to be able to interact with, add them to this check
	// ~no more shielded, emitter armed death trains
	if(istype(C, /obj/machinery))
		load_object(C)
	else
		..()

	if(load)
		return 1

/obj/vehicle/train/cargo/engine/load(var/atom/movable/C)
	if(!istype(C, /mob/living/carbon/human))
		return 0

	return ..()

//Load the object "inside" the trolley and add an overlay of it.
//This prevents the object from being interacted with until it has
// been unloaded. A dummy object is loaded instead so the loading
// code knows to handle it correctly.
/obj/vehicle/train/cargo/trolley/proc/load_object(var/atom/movable/C)
	if(!isturf(C.loc)) //To prevent loading things from someone's inventory, which wouldn't get handled properly.
		return 0
	if(load || C.anchored)
		return 0

	var/datum/vehicle_dummy_load/dummy_load = new()
	load = dummy_load

	if(!load)
		return
	dummy_load.actual_load = C
	C.forceMove(src)

	if(load_item_visible)
		var/mutable_appearance/MA = new(C)
		MA.pixel_x += load_offset_x
		MA.pixel_y += load_offset_y
		MA.layer = FLOAT_LAYER

		add_overlay(MA)

/obj/vehicle/train/cargo/trolley/unload(var/mob/user, var/direction)
	if(istype(load, /datum/vehicle_dummy_load))
		var/datum/vehicle_dummy_load/dummy_load = load
		load = dummy_load.actual_load
		dummy_load.actual_load = null
		qdel(dummy_load)
		cut_overlays()
	..()

//-------------------------------------------
// Latching/unlatching procs
//-------------------------------------------

/obj/vehicle/train/cargo/engine/latch(obj/vehicle/train/T, mob/user)
	if(!istype(T) || !Adjacent(T))
		return 0

	//if we are attaching a trolley to an engine we don't care what direction
	// it is in and it should probably be attached with the engine in the lead
	if(istype(T, /obj/vehicle/train/cargo/trolley))
		T.attach_to(src, user)
	else
		var/T_dir = get_dir(src, T)	//figure out where T is wrt src

		if(dir == T_dir) 	//if car is ahead
			src.attach_to(T, user)
		else if(reverse_direction(dir) == T_dir)	//else if car is behind
			T.attach_to(src, user)

//-------------------------------------------------------
// Stat update procs
//
// Update the trains stats for speed calculations.
// The longer the train, the slower it will go. car_limit
// sets the max number of cars one engine can pull at
// full speed. Adding more cars beyond this will slow the
// train proportionate to the length of the train. Adding
// more engines increases this limit by car_limit per
// engine.
//-------------------------------------------------------
/obj/vehicle/train/cargo/engine/update_car(var/train_length, var/active_engines)
	src.train_length = train_length
	src.active_engines = active_engines

	//Update move delay
	if(!is_train_head() || !on)
		move_delay = initial(move_delay)		//so that engines that have been turned off don't lag behind
	else
		move_delay = max(0, (-car_limit * active_engines) + train_length - active_engines)	//limits base overweight so you cant overspeed trains
		move_delay *= (1 / max(1, active_engines)) * 2 										//overweight penalty (scaled by the number of engines)
		move_delay += config.walk_speed 													//base reference speed
		move_delay *= config.vehicle_delay_multiplier												//makes cargo trains 10% slower than running when not overweight
		if(emagged)
			move_delay -= 2

/obj/vehicle/train/cargo/trolley/update_car(var/train_length, var/active_engines)
	src.train_length = train_length
	src.active_engines = active_engines

	if(!lead && !tow)
		anchored = 0
	else
		anchored = 1
