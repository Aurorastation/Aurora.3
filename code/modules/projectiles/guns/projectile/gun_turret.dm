/// GUN TURRETS /// Gun turrets are portable guns that need to be set up and can shoot afterwards.
/obj/item/weapon/projectile/gun_turret
	name = "stationary machinegun"
	desc = "basic heavy machinegun."
	icon =
	icon_state =
	item_state =
	plane = ABOVE_OBJ_PLANE
	layer = ABOVE_OBJ_LAYER + 0.11
	anchored = 1
	density = 1
	w_class = ITEM_SIZE_IMMENSE
	load_method = SINGLE_CASING
  handle_casings = EJECT_CASINGS
	max_shells = 6000
	caliber = "9mm"
	slot_flags = 0 // They are too big to be carried in bags
	ammo_type = /obj/item/ammo_casing/c9mm // Only for testing purposes

	burst=1
	burst_delay=0.1
	fire_delay=0.1
	fire_sound = 'sound/weapons/gunshot/gunshot_saw.ogg'

	firemodes = list(
		list(mode_name="semiauto", burst=1, burst_delay=0.1, fire_delay=0.1, burst_accuracy=list(0,-1), dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="3-round bursts", burst=3, burst_delay=0.1, fire_delay=0.2, burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0))
		)

	var/user_old_x = 0
	var/user_old_y = 0
	var/mob/used_by_mob = null
	var/obj/item/weapon/mg_disassembled/disassembled = null
	var/obj/item/weapon/tripod/tripod = null

/obj/item/weapon/projectile/gun_turret/AltClick(mob/user)
	..()
	if(used_by_mob == user)
		safety = !safety
		playsound(user, 'sound/weapons/mg_safety.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You toggle the safety [safety ? "on":"off"].</span>")

/obj/item/weapon/projectile/gun_turret/New(loc, var/direction)
	..()
	if(direction)
		set_dir(direction)
	if(!tripod)
		tripod = new/obj/item/weapon/mg_tripod
	if(!disassembled)
		disassembled = new/obj/item/weapon/mg_disassembled

	update_layer()

/obj/item/weapon/projectile/gun_turret/Destroy()
	if(used_by_mob)
		stopped_using(used_by_mob, 0)

	var/turf/T = get_turf(src)

	if(isturf(T))
		if(disassembled)
			disassembled.forceMove(T)
			disassembled = null

		if(tripod)
			tripod.forceMove(T)
			tripod = null
	..()


/obj/item/weapon/projectile/gun_turret/Fire(atom/A ,mob/user)
	if(A == src)
		if(firemodes.len > 1)
			var/datum/firemode/new_mode = switch_firemodes(user)
			if(new_mode)
				to_chat(user, "<span class='notice'>\The [src] is now set to [new_mode.name].</span>")
				return
	if(check_direction(user, A))
		return ..()
	else
		rotate_to(user, A)
		update_layer()
		return

/obj/item/weapon/projectile/gun_turret/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /obj/item/projectile))
		return 1
	return 0

/obj/item/weapon/projectile/gun_turret/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && in_range(src, usr)) && !used_by_mob)
		unload_ammo(usr, 0)
		return

/obj/item/weapon/projectile/gun_turret/attack_hand(mob/user)
	var/grip_dir = reverse_direction(dir)
	var/turf/T = get_step(src.loc, grip_dir)
	if(user.loc == T)
		if(user.get_active_hand() == null && user.get_inactive_hand() == null)
			started_using(user)

		else
			to_chat(user, "\red Your hands are busy by holding things.")

	else
		to_chat(user, "\red You're too far from the handles.")

/obj/item/weapon/projectile/gun_turret/proc/update_layer()
	if(dir == NORTH)
		layer = initial(layer) + 0.1
		plane = initial(plane)
//	else if(dir == SOUTH)
//		layer = initial(layer) + 0.1
//		plane = initial(plane)
	else
		layer = ABOVE_OBJ_LAYER + 0.2
		plane = ABOVE_HUMAN_PLANE

/*
	if(dir != SOUTH)
		layer = initial(layer) + 0.1
		plane = initial(plane)
	else
		layer = ABOVE_OBJ_LAYER + 0.1
		plane = ABOVE_HUMAN_PLANE
		*/

/obj/item/weapon/projectile/gun_turret/proc/check_direction(mob/user, atom/A)
	if(get_turf(A) == src.loc)
		return 0

	var/shot_dir = get_carginal_dir(src, A)
	if(shot_dir != dir)
		return 0

	return 1

/obj/item/weapon/projectile/gun_turret/proc/rotate_to(mob/user, atom/A)
	if(!A || !user.x || !user.y || !A.x || !A.y)
		return
	var/dx = A.x - user.x
	var/dy = A.y - user.y
	if(!dx && !dy)
		return

	var/direction
	if(abs(dx) < abs(dy))
		if(dy > 0)
			direction = NORTH
		else
			direction = SOUTH
	else
		if(dx > 0)
			direction = EAST
		else
			direction = WEST

	if(/obj/structure/sandbag in src.loc.contents)
		var/obj/structure/sandbag/S = locate(src.loc.contents)
		if(direction == reverse_direction(S.dir))
			to_chat(user, "<span class='notice'>You can't rotate it in that way!</span>")
			return 0

	src.set_dir(direction)
	user.set_dir(direction)
	update_pixels(user)
	to_chat(user, "You rotate the [name]")

	return 0

/obj/item/weapon/projectile/gun_turret/proc/update_pixels(mob/user as mob)
	var/diff_x = 0
	var/diff_y = 0
	if(dir == EAST)
		diff_x = -16 + user_old_x
	if(dir == WEST)
		diff_x = 16 + user_old_x
	if(dir == NORTH)
		diff_y = -16 + user_old_y
	if(dir == SOUTH)
		diff_y = 16 + user_old_y
	animate(user, pixel_x=diff_x, pixel_y=diff_y, 4, 1)

/obj/item/weapon/projectile/gun_turret/proc/started_using(mob/user as mob, var/need_message = 1)
	if(need_message)
		user.visible_message("<span class='notice'>[user.name] handeled \the [src].</span>", \
							 "<span class='notice'>You handeled \the [src].</span>")
	used_by_mob = user
	user.using_object = src
	user.update_canmove()
	user.forceMove(src.loc)
	user.set_dir(src.dir)
	user_old_x = user.pixel_x
	user_old_y = user.pixel_y
	update_pixels(user)

/obj/item/weapon/gun/projectile/gun_turret/proc/stopped_using(mob/user as mob, var/need_message = 1)
	if(need_message)
		user.visible_message("<span class='notice'>[user.name] released \the [src].</span>", \
							 "<span class='notice'>You released \the [src].</span>")
	used_by_mob = null
	user.using_object = null
	user.anchored = 0
	user.update_canmove()
	var/grip_dir = reverse_direction(dir)
	var/old_dir = dir
	step(user, grip_dir)
	animate(user, pixel_x=user_old_x, pixel_y=user_old_y, 4, 1)
	user_old_x = 0
	user_old_y = 0
	user.dir = old_dir // visual better

/obj/item/weapon/projectile/gun_turret/proc/detach_tripod(var/mob/user)
	if(!disassembled || !tripod || !ismob(user))
		return

	var/turf/T = get_turf(src.loc)
	tripod.forceMove(T)
	tripod.attach_to_turf(T, user, 0)
	disassembled.forceMove(T)
	playsound(src, 'sound/items/hw_weapon.ogg', 50, 1)
	user.put_in_hands(disassembled)
	tripod = null
	disassembled = null
	qdel(src)

/obj/item/weapon/projectile/gun_turret/verb/detach_from_tripod()
	set name = "Detach from tripod"
	set category = "Object"
	set src in view(1)

	if(ammo_magazine)
		to_chat(usr, "You need to unload [name] first!")
		return

	detach_tripod(usr)


/obj/item/gun/projectile/gun_turret/machine_gun_turret // The assembly itself
  name = "heavy machine gun turret"
	desc = "A tripod-mounted machine gun turret. Brutally simple, as it is effective for area denial. Has a clunky reload with big ammo boxes."
  desc_extended = "Produced by the San Colette Interstellar Armaments Company (CAISC), the Colletish Armaments Multipurpose Machinegun Model 3 is a heavy piece of equipment, perfect for area denial and suppressive fire. Brutally simple, as it is effective \
the MPM-3 excelled as the perfect emplacement weapon to secure outposts, convoys and as a secondary vehicle armament, due to its easy maintenance and low jam probability. Chambered in 14.5mm to shred even your best protected enemy."
	icon_state =
	load_method = MAGAZINE
	caliber =
	ammo_type = /obj/item/ammo_casing/mg_turret
	max_shells = 0
	allowed_magazines = /obj/item/ammo_magazine/mg_turret

	burst = 1
	burst_delay = 0.1
	fire_delay = 0.1
	fire_sound =
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=3, burst_accuracy=null, dispersion=null),
		list(mode_name="short bursts", burst=3, fire_delay=4, burst_delay = 1, burst_accuracy=list(1,0,-1),       dispersion=list(0.3, 0.6, 0.6)),
		list(mode_name="long bursts",   burst=5, fire_delay=4, burst_delay = 1, burst_accuracy=list(1,0,0,-1,-2), dispersion=list(0.3, 0.6, 0.6, 1.2, 1.5)),
    list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=5, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(5, 10, 15, 20, 25)) // All firemodes because it has no fire selector
		)

/obj/item/gun/projectile/gun_turret/update_icon()
	..()
	if(ammo_magazine)
		icon_state =
	else
		icon_state =

/// The assembly parts ///

/obj/item/weapon/tripod
	name = "machine gun turret tripod"
  desc = "A very heavy metal tripod to mount a weapon on it. Needs a bit to be set up."
  w_class = ITEMSIZE_LARGE
	icon_state =
  action_button_name = "Deploy the turret tripod."
	need_type = /obj/item/weapon/gun/projectile/gun_turret/machine_gun_turret

/obj/item/weapon/mg_disassembled
  name = "heavy machine gun"
  desc = "The actual gun for the heavy machine gun turret. Very heavy and very bulky."
  desc_extended =
  w_class = ITEMSIZE_LARGE
  icon_state =

/obj/item/gun_shield
  name = "turret gun shield"
  desc = "A thick metal shield with a small viewing port. Intended to partially protect you, when it's mounted on a gun turret."
  icon_state =
  w_class = ITEMSIZE_NORMAL
