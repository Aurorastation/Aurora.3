/obj/vehicle/unicycle
	name = "unicycle"
	desc = "An one wheeled vehicle."
	icon_state = "unicycle"

	mob_offset_y = 4
	health = 50
	maxhealth = 50

	fire_dam_coeff = 0.8
	brute_dam_coeff = 0.8

	charge_use = 0

	light_range = 0

	powered = 1
	on = 1

/obj/vehicle/unicycle/Initialize()
	. = ..()
	add_overlay(image('icons/obj/vehicles.dmi', "unicycle_overlay", MOB_LAYER + 1))
	cell = new /obj/item/cell/high(src)

/obj/vehicle/unicycle/load(var/atom/movable/C)
	var/mob/living/M = C
	if(!istype(C)) return 0
	if(M.buckled_to || M.restrained() || !Adjacent(M) || !M.Adjacent(src))
		return 0
	return ..(M)

/obj/vehicle/unicycle/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(!load(C))
		to_chat(user, SPAN_WARNING("You were unable to load \the [C] onto \the [src]."))
		return

/obj/vehicle/unicycle/attack_hand(var/mob/user as mob)
	if(user == load)
		unload(load)
		to_chat(user, "You climb on \the [src]")
	else if(user != load && load)
		user.visible_message ("[user] starts to remove [load] from \the [src]!")
		if(do_after(user, 8 SECONDS, act_target = src))
			unload(load)
			to_chat(user, "You remove [load] from \the [src]")
			to_chat(load, "You were removed from \the [src] by [user]")

/obj/vehicle/unicycle/relaymove(mob/user, direction)
	if(user != load || !on || user.incapacitated())
		return
	return Move(get_step(src, direction))

/obj/vehicle/unicycle/Move()
	if(world.time > l_move_time + move_delay)
		var/old_loc = get_turf(src)

		var/init_anc = anchored
		anchored = 0
		if(!..())
			anchored = init_anc
			return 0

		set_dir(get_dir(old_loc, loc))
		anchored = init_anc

		//Dummy loads do not have to be moved as they are just an overlay
		//See load_object() proc in cargo_trains.dm for an example
		if(load && !istype(load, /datum/vehicle_dummy_load))
			load.forceMove(loc)
			load.set_dir(dir)

		if(prob(20))
			if(buckled)
				if(ishuman(buckled))
					var/mob/living/carbon/human/H = buckled
					if(H.mind && (H.mind.assigned_role != "Adhomian Circus Clown"))
						H.visible_message(SPAN_DANGER("\The [H] falls off from \the [src]!"))
						unload(H)
						H.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
						H.apply_effect(2, WEAKEN)


		return 1
	else
		return 0