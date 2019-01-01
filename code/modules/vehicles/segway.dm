/obj/vehicle/segway
	name = "security segway"
	desc = "Nanotrasen's soultion to the security weight crisis!"
	icon = 'icons/obj/segway.dmi'
	icon_state = "segway"
	dir = SOUTH

	load_item_visible = 1
	mob_offset_y = 5
	health = 120
	maxhealth = 120

	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5
	var/protection_percent = 60

	var/land_speed = 4 //if 0 it can't go on turf
	var/space_speed = 8
	var/segway_icon = "segway"

	var/datum/effect_system/ion_trail/ion
	var/kickstand = 1
	var/obj/item/weapon/key/segwaykey/key

/obj/item/weapon/key/segwaykey
	name = "key"
	desc = "A small key. It has the symbol of Nanotrasen's Internal Security Department on it."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "segwaykeys"
	w_class = 1

/obj/vehicle/segway/Initialize()
	. = ..()
	ion = new(src)
	cell = new /obj/item/weapon/cell/high(src)
	turn_off()

/obj/vehicle/segway/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/key/segwaykey))
		if(!key)
			user.drop_from_inventory(W,src)
			key = W
			verbs += /obj/vehicle/train/cargo/engine/verb/remove_key
		return
	..()

/obj/vehicle/segway/verb/toggle()
	set name = "Toggle Engine"
	set category = "Vehicle"
	set src in view(0)

	if(use_check(usr))
		return

	if(!key)
		return

	if(!on)
		turn_on()
		src.visible_message("\The [src] starts up with a rumble", "You hear something rumble deeply.")
		playsound(src, 'sound/misc/bike_start.ogg', 100, 1)
	else
		turn_off()
		src.visible_message("\The [src] putters before turning off.", "You hear something putter slowly.")

/obj/vehicle/segway/verb/siren()
	set name = "Hail Suspect"
	set category = "Vehicle"
	set src in view(0)

	if(use_check(usr))
		return

	if(!on)
		src.visible_message("You attempt to use \the [src]'s siren with the engine off, it won't work however.", "You hear a thunk.")
		return
	else
		playsound(get_turf(src), 'sound/voice/halt.ogg', 100, 1, vary = 0)


/obj/vehicle/segway/verb/kickstand()
	set name = "Toggle Kickstand"
	set category = "Vehicle"
	set src in view(0)

	if(use_check(usr))
		return

	if(kickstand)
		usr.visible_message("\The [usr] puts up \the [src]'s kickstand.", "You put up \the [src]'s kickstand.", "You hear a thunk.")
		playsound(src, 'sound/misc/bike_stand_up.ogg', 50, 1)
	else
		if(isturf(loc))
			var/turf/T = loc
			if (T.is_hole)
				to_chat(usr, "<span class='warning'>You don't think kickstands work here.</span>")
				return
		usr.visible_message("\The [usr] puts down \the [src]'s kickstand.", "You put down \the [src]'s kickstand.", "You hear a thunk.")
		playsound(src, 'sound/misc/bike_stand_down.ogg', 50, 1)
		if(pulledby)
			pulledby.stop_pulling()

	kickstand = !kickstand
	anchored = (kickstand || on)

/obj/vehicle/segway/load(var/atom/movable/C)
	var/mob/living/M = C
	if(!istype(M)) 
		return 0
	if(M.buckled || M.restrained() || !Adjacent(M) || !M.Adjacent(src))
		return 0
	return ..(M)

/obj/vehicle/segway/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(!load(C))
		to_chat(user, "<span class='warning'>You were unable to load \the [C] onto \the [src].</span>")
		return

/obj/vehicle/segway/attack_hand(var/mob/user as mob)
	if(user == load)
		unload(load)
		to_chat(user, "You unbuckle yourself from \the [src].")
	else if(user != load && load)
		user.visible_message ("[user] starts to unbuckle [load] from \the [src]!")
		if(do_after(user, 8 SECONDS, act_target = src))
			unload(load)
			user <<"You unbuckle [load] from \the [src]."
			load <<"You were unbuckled from \the [src] by [user]."

/obj/vehicle/segway/relaymove(mob/user, direction)
	if(user != load || !on || user.incapacitated())
		return
	return Move(get_step(src, direction))

/obj/vehicle/segway/Move(var/turf/destination)
	if(kickstand)
		return

	//these things like space, not turf. Dragging shouldn't weigh you down.
	var/static/list/types = typecacheof(list(/turf/space, /turf/simulated/open, /turf/simulated/floor/asteroid))
	if(is_type_in_typecache(destination,types) || pulledby)
		if(!space_speed)
			return 0
		move_delay = space_speed
	else
		if(!land_speed)
			return 0
		move_delay = land_speed
	return ..()

/obj/vehicle/segway/turn_on()
	ion.start()
	anchored = 1


	if(pulledby)
		pulledby.stop_pulling()
	..()
/obj/vehicle/segway/turn_off()
	ion.stop()
	anchored = kickstand


	..()

/obj/vehicle/segway/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob && prob(protection_percent))
		buckled_mob.bullet_act(Proj)
		return
	..()


/obj/vehicle/segway/Destroy()
	QDEL_NULL(ion)

	if (key)
		QDEL_NULL(key)

	return ..()



/obj/vehicle/segway/verb/remove_key()
	set name = "Remove key"
	set category = "Vehicle"
	set src in view(0)

	if (use_check(usr, show_messages = FALSE))
		return

	if(!key || (load && load != usr))
		return

	if(on)
		turn_off()

	key.forceMove(usr.loc)
	if(!usr.get_active_hand())
		usr.put_in_hands(key)

	verbs -= /obj/vehicle/segway/verb/remove_key
