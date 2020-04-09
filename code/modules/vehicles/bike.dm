/obj/vehicle/bike
	name = "space-bike"
	desc = "Space wheelies! Woo! "
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike_off"
	dir = SOUTH

	load_item_visible = 1
	mob_offset_y = 5
	health = 100
	maxhealth = 100

	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5
	var/protection_percent = 60

	var/land_speed = 10 //if 0 it can't go on turf
	var/space_speed = 1
	var/bike_icon = "bike"

	var/datum/effect_system/ion_trail/ion
	var/kickstand = TRUE
	var/can_hover = TRUE

/obj/vehicle/bike/Initialize()
	. = ..()
	ion = new(src)
	turn_off()
	add_overlay(image('icons/obj/bike.dmi', "[icon_state]_off_overlay", MOB_LAYER + 1))
	icon_state = "[bike_icon]_off"

/obj/vehicle/bike/verb/toggle()
	set name = "Toggle Engine"
	set category = "Vehicle"
	set src in view(0)

	if(usr.incapacitated()) return

	if(!on)
		turn_on()
		src.visible_message("\The [src] rumbles to life.", "You hear something rumble deeply.")
		playsound(src, 'sound/misc/bike_start.ogg', 100, 1)
	else
		turn_off()
		src.visible_message("\The [src] putters before turning off.", "You hear something putter slowly.")

/obj/vehicle/bike/verb/kickstand()
	set name = "Toggle Kickstand"
	set category = "Vehicle"
	set src in view(0)

	if(usr.incapacitated()) return

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

/obj/vehicle/bike/load(var/atom/movable/C)
	var/mob/living/M = C
	if(!istype(C)) return 0
	if(M.buckled || M.restrained() || !Adjacent(M) || !M.Adjacent(src))
		return 0
	return ..(M)

/obj/vehicle/bike/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(!load(C))
		to_chat(user, "<span class='warning'>You were unable to load \the [C] onto \the [src].</span>")
		return

/obj/vehicle/bike/attack_hand(var/mob/user as mob)
	if(user == load)
		unload(load)
		to_chat(user, "You unbuckle yourself from \the [src]")
	else if(user != load && load)
		user.visible_message ("[user] starts to unbuckle [load] from \the [src]!")
		if(do_after(user, 8 SECONDS, act_target = src))
			unload(load)
			to_chat(user, "You unbuckle [load] from \the [src]")
			to_chat(load, "You were unbuckled from \the [src] by [user]")

/obj/vehicle/bike/relaymove(mob/user, direction)
	if(user != load || !on || user.incapacitated())
		return
	return Move(get_step(src, direction))

/obj/vehicle/bike/proc/check_destination(var/turf/destination)
	var/static/list/types = typecacheof(list(/turf/space, /turf/simulated/open, /turf/unsimulated/floor/asteroid))
	if(is_type_in_typecache(destination,types) || pulledby)
		return TRUE
	else
		return FALSE

/obj/vehicle/bike/Move(var/turf/destination)
	if(kickstand) return

	//these things like space, not turf. Dragging shouldn't weigh you down.
	var/is_on_space = check_destination(destination)
	if(is_on_space)
		if(!space_speed)
			return 0
		move_delay = space_speed
	else
		if(!land_speed)
			return 0
		move_delay = land_speed
	return ..()

/obj/vehicle/bike/turn_on()
	ion.start()
	anchored = 1

	if(can_hover)
		flying = TRUE

	update_icon()

	if(pulledby)
		pulledby.stop_pulling()
	..()

/obj/vehicle/bike/turn_off()
	ion.stop()
	anchored = kickstand

	if(can_hover)
		flying = FALSE

	update_icon()

	..()

/obj/vehicle/bike/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob && prob(protection_percent))
		buckled_mob.bullet_act(Proj)
		return
	..()

/obj/vehicle/bike/update_icon()
	cut_overlays()

	if(on)
		add_overlay(image('icons/obj/bike.dmi', "[bike_icon]_on_overlay", MOB_LAYER + 1))
		icon_state = "[bike_icon]_on"
	else
		add_overlay(image('icons/obj/bike.dmi', "[bike_icon]_off_overlay", MOB_LAYER + 1))
		icon_state = "[bike_icon]_off"

	..()


/obj/vehicle/bike/Destroy()
	QDEL_NULL(ion)

	return ..()

/obj/vehicle/bike/Collide(var/atom/movable/AM)
	. = ..()
	if(!buckled_mob)
		return
	if(buckled_mob.a_intent == I_HURT)
		if (istype(AM, /obj/vehicle))
			buckled_mob.setMoveCooldown(10)
			var/obj/vehicle/V = AM
			if(prob(50))
				if(V.buckled_mob)
					if(ishuman(V.buckled_mob))
						var/mob/living/carbon/human/I = V.buckled_mob
						I.visible_message(SPAN_DANGER("\The [I] falls off from \the [V]"))
						V.unload(I)
						I.throw_at(get_edge_target_turf(V.loc, V.loc.dir), 5, 1)
						I.apply_effect(2, WEAKEN)
				if(prob(25))
					if(ishuman(buckled_mob))
						var/mob/living/carbon/human/C = buckled_mob
						C.visible_message(SPAN_DANGER ("\The [C] falls off from \the [src]!"))
						unload(C)
						C.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
						C.apply_effect(2, WEAKEN)

		if(isliving(AM))
			if(ishuman(AM))
				var/mob/living/carbon/human/H = AM
				buckled_mob.attack_log += "\[[time_stamp()]\]<font color='orange'> Was rammed by [src]</font>"
				buckled_mob.attack_log += text("\[[time_stamp()]\] <font color='red'>rammed[buckled_mob.name] ([buckled_mob.ckey]) rammed [H.name] ([H.ckey]) with the [src].</font>")
				msg_admin_attack("[src] crashed into [key_name(H)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[H.x];Y=[H.y];Z=[H.z]'>JMP</a>)" )
				src.visible_message(SPAN_DANGER("\The [src] smashes into \the [H]!"))
				playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
				H.apply_damage(20, BRUTE)
				H.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
				H.apply_effect(4, WEAKEN)
				buckled_mob.setMoveCooldown(10)
				return TRUE

			else
				var/mob/living/L = AM
				src.visible_message(SPAN_DANGER("\The [src] smashes into \the [L]!"))
				playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
				L.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
				L.apply_damage(20, BRUTE)
				buckled_mob.setMoveCooldown(10)
				return TRUE

/obj/vehicle/bike/speeder
	name = "retrofitted speeder"
	desc = "A short bike that seems to consist mostly of an engine, a hover repulsor, vents and a steering shaft."
	icon_state = "speeder_on"

	health = 150
	maxhealth = 150

	fire_dam_coeff = 0.5
	brute_dam_coeff = 0.4

	bike_icon = "speeder"

/obj/vehicle/bike/monowheel
	name = "adhomian monowheel"
	desc = "A one-wheeled vehicle, fairly popular with Little Adhomai's greasers."
	icon_state = "monowheel_off"

	health = 250
	maxhealth = 250

	fire_dam_coeff = 0.5
	brute_dam_coeff = 0.4

	mob_offset_y = 1

	bike_icon = "monowheel"
	dir = EAST

	land_speed = 1
	space_speed = 0

	can_hover = FALSE

/obj/vehicle/bike/monowheel/RunOver(var/mob/living/carbon/human/H)
	if(!buckled_mob)
		return
	if(buckled_mob.a_intent == I_HURT)
		buckled_mob.attack_log += "\[[time_stamp()]\]<font color='orange'> Was rammed by [src]</font>"
		buckled_mob.attack_log += text("\[[time_stamp()]\] <font color='red'>rammed[buckled_mob.name] ([buckled_mob.ckey]) rammed [H.name] ([H.ckey]) with the [src].</font>")
		msg_admin_attack("[src] crashed into [key_name(H)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[H.x];Y=[H.y];Z=[H.z]'>JMP</a>)" )
		src.visible_message(SPAN_DANGER("\The [src] runs over \the [H]!"))
		H.apply_damage(30, BRUTE)
		H.apply_effect(4, WEAKEN)
		return TRUE

/obj/vehicle/bike/monowheel/check_destination(var/turf/destination)
	var/static/list/types = typecacheof(list(/turf/space))
	if(is_type_in_typecache(destination,types) || pulledby)
		return TRUE
	else
		return FALSE
