/obj/vehicle/bike
	name = "space-bike"
	desc = "Space wheelies! Woo!"
	desc_info = "Click-drag yourself onto the bike to climb onto it.<br>\
		- Click-drag it onto yourself to access its mounted storage.<br>\
		- CTRL-click the bike to toggle the engine.<br>\
		- ALT-click to toggle the kickstand which prevents movement by driving and dragging.<br>\
		- Click the resist button or type \"resist\" in the command bar at the bottom of your screen to get off the bike."
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

	var/land_speed = 5 //if 0 it can't go on turf
	var/space_speed = 1
	var/bike_icon = "bike"

	var/storage_type = /obj/item/storage/toolbox/bike_storage
	var/obj/item/storage/storage_compartment
	var/datum/effect_system/ion_trail/ion
	var/ion_type = /datum/effect_system/ion_trail
	var/kickstand = TRUE
	var/can_hover = TRUE

/obj/vehicle/bike/setup_vehicle()
	..()
	ion = new ion_type(src)
	turn_off()
	add_overlay(image(icon, "[icon_state]_off_overlay", MOB_LAYER + 1))
	icon_state = "[bike_icon]_off"
	if(storage_type)
		storage_compartment = new storage_type(src)

/obj/vehicle/bike/CtrlClick(var/mob/user)
	if(Adjacent(user) && anchored)
		toggle_engine(user)
	else
		return ..()

/obj/vehicle/bike/proc/toggle_engine(var/mob/user)
	if(use_check_and_message(user))
		return

	if(!on)
		turn_on()
		src.visible_message("\The [src] rumbles to life.", "You hear something rumble deeply.")
		playsound(src, 'sound/machines/vehicles/bike_start.ogg', 100, 1)
	else
		turn_off()
		src.visible_message("\The [src] putters before turning off.", "You hear something putter slowly.")

/obj/vehicle/bike/AltClick(var/mob/user)
	if(Adjacent(user))
		kickstand(user)
	else
		return ..()

/obj/vehicle/bike/proc/kickstand(var/mob/user)
	if(use_check_and_message(user))
		return

	if(kickstand)
		user.visible_message("\The [user] puts up \the [src]'s kickstand.", "You put up \the [src]'s kickstand.", "You hear a thunk.")
		playsound(src, 'sound/machines/vehicles/bike_stand_up.ogg', 50, 1)
	else
		if(isturf(loc))
			var/turf/T = loc
			if (T.is_hole)
				to_chat(user, SPAN_WARNING("You don't think kickstands work here."))
				return
		user.visible_message("\The [user] puts down \the [src]'s kickstand.", "You put down \the [src]'s kickstand.", "You hear a thunk.")

		playsound(src, 'sound/machines/vehicles/bike_stand_down.ogg', 50, 1)
		if(ismob(pulledby))
			var/mob/M = pulledby
			M.stop_pulling()


	kickstand = !kickstand
	anchored = (kickstand || on)

/obj/vehicle/bike/load(var/atom/movable/C)
	var/mob/living/M = C
	if(!istype(C)) return 0
	if(M.buckled_to || M.restrained() || !Adjacent(M) || !M.Adjacent(src))
		return 0
	return ..(M)

/obj/vehicle/bike/MouseDrop(atom/over)
	if(usr == over && ishuman(over))
		var/mob/living/carbon/human/H = over
		storage_compartment.open(H)

/obj/vehicle/bike/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(!load(C))
		to_chat(user, SPAN_WARNING("You were unable to load \the [C] onto \the [src]."))
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
	if(kickstand)
		visible_message("The kickstand prevents the bike from moving!")
		return

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

	if(ismob(pulledby))
		var/mob/M = pulledby
		M.stop_pulling()
	..()

/obj/vehicle/bike/turn_off()
	ion.stop()
	anchored = kickstand

	if(can_hover)
		flying = FALSE

	update_icon()

	..()

/obj/vehicle/bike/bullet_act(var/obj/item/projectile/Proj)
	if(buckled && prob(protection_percent))
		buckled.bullet_act(Proj)
		return
	..()

/obj/vehicle/bike/update_icon()
	cut_overlays()

	if(on)
		add_overlay(image(icon, "[bike_icon]_on_overlay", MOB_LAYER + 1))
		icon_state = "[bike_icon]_on"
	else
		add_overlay(image(icon, "[bike_icon]_off_overlay", MOB_LAYER + 1))
		icon_state = "[bike_icon]_off"

	..()


/obj/vehicle/bike/Destroy()
	QDEL_NULL(ion)

	return ..()

/obj/vehicle/bike/Collide(var/atom/movable/AM)
	. = ..()
	collide_act(AM)

/obj/vehicle/bike/proc/collide_act(var/atom/movable/AM)
	var/mob/living/M
	if(!buckled)
		return
	if(istype(buckled, /mob/living))
		M = buckled
	if(M.a_intent == I_HURT)
		if (istype(AM, /obj/vehicle))
			M.setMoveCooldown(10)
			var/obj/vehicle/V = AM
			if(prob(50))
				if(V.buckled)
					if(ishuman(V.buckled))
						var/mob/living/carbon/human/I = V.buckled
						I.visible_message(SPAN_DANGER("\The [I] falls off from \the [V]"))
						V.unload(I)
						I.throw_at(get_edge_target_turf(V.loc, V.loc.dir), 5, 1)
						I.apply_effect(2, WEAKEN)
				if(prob(25))
					if(ishuman(buckled))
						var/mob/living/carbon/human/C = buckled
						C.visible_message(SPAN_DANGER ("\The [C] falls off from \the [src]!"))
						unload(C)
						C.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
						C.apply_effect(2, WEAKEN)

		if(isliving(AM))
			if(ishuman(AM))
				var/mob/living/carbon/human/H = AM
				M.attack_log += "\[[time_stamp()]\]<font color='orange'> Was rammed by [src]</font>"
				M.attack_log += text("\[[time_stamp()]\] <span class='warning'>rammed[M.name] ([M.ckey]) rammed [H.name] ([H.ckey]) with the [src].</span>")
				msg_admin_attack("[src] crashed into [key_name(H)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[H.x];Y=[H.y];Z=[H.z]'>JMP</a>)" )
				src.visible_message(SPAN_DANGER("\The [src] smashes into \the [H]!"))
				playsound(src, /singleton/sound_category/swing_hit_sound, 50, 1)
				H.apply_damage(20, BRUTE)
				H.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
				H.apply_effect(4, WEAKEN)
				M.setMoveCooldown(10)
				return TRUE

			else
				var/mob/living/L = AM
				src.visible_message(SPAN_DANGER("\The [src] smashes into \the [L]!"))
				playsound(src, /singleton/sound_category/swing_hit_sound, 50, 1)
				L.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
				L.apply_damage(20, BRUTE)
				M.setMoveCooldown(10)
				return TRUE

/obj/vehicle/bike/speeder
	name = "retrofitted speeder"
	desc = "A short bike that seems to consist mostly of an engine, a hover repulsor, vents and a steering shaft."
	icon_state = "speeder_on"

	health = 150
	maxhealth = 150

	fire_dam_coeff = 0.5
	brute_dam_coeff = 0.4

	storage_type = /obj/item/storage/toolbox/bike_storage/speeder
	bike_icon = "speeder"

/obj/vehicle/bike/monowheel
	name = "adhomian monowheel"
	desc = "A one-wheeled vehicle, fairly popular with Little Adhomai's greasers."
	desc_info = "Drag yourself onto the monowheel to mount it, toggle the engine to be able to drive around. Deploy the kickstand to prevent movement by driving and dragging. Drag it onto yourself to access its mounted storage. Resist to get off."
	icon_state = "monowheel_off"

	health = 250
	maxhealth = 250

	fire_dam_coeff = 0.5
	brute_dam_coeff = 0.4

	mob_offset_y = 1

	storage_type = /obj/item/storage/toolbox/bike_storage/monowheel
	bike_icon = "monowheel"
	dir = EAST

	land_speed = 1
	space_speed = 0

	can_hover = FALSE

/obj/vehicle/bike/monowheel/RunOver(var/mob/living/carbon/human/H)
	var/mob/living/M
	if(!buckled)
		return
	if(istype(buckled, /mob/living))
		M = buckled
	if(M.a_intent == I_HURT)
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Was rammed by [src]</font>"
		M.attack_log += text("\[[time_stamp()]\] <span class='warning'>rammed[M.name] ([M.ckey]) rammed [H.name] ([H.ckey]) with the [src].</span>")
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

/obj/item/storage/toolbox/bike_storage
	name = "bike storage"
	max_w_class = ITEMSIZE_LARGE
	max_storage_space = 50
	care_about_storage_depth = FALSE

/obj/item/storage/toolbox/bike_storage/speeder
	name = "speeder storage"

/obj/item/storage/toolbox/bike_storage/monowheel
	name = "monowheel storage"

/obj/vehicle/bike/casino
	name = "retrofitted snowmobile"
	desc = "A modified snowmobile. There is a coin slot on the panel."
	icon_state = "snow_on"

	bike_icon = "snow"
	land_speed = 3
	protection_percent = 10
	can_hover = FALSE
	var/paid = FALSE

/obj/vehicle/bike/casino/Move(var/turf/destination)
	if(!paid)
		return
	..()

/obj/vehicle/bike/casino/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/coin/casino))
		if(!paid)
			paid = TRUE
			to_chat(user, SPAN_NOTICE("Payment confirmed, enjoy two minutes of unlimited snowmobile use."))
			addtimer(CALLBACK(src, .proc/rearm), 2 MINUTES)
		return
	..()

/obj/vehicle/bike/casino/proc/rearm()
	visible_message(SPAN_NOTICE("\The [src] beeps lowly, asking for another chip to continue."))
	paid = FALSE

/obj/vehicle/bike/casino/check_destination(var/turf/destination)
	var/static/list/types = typecacheof(list(/turf/space))
	if(is_type_in_typecache(destination,types) || pulledby)
		return TRUE
	else
		return FALSE

/obj/vehicle/bike/snow
	name = "snowmobile"
	desc = "A vehicle adapted to travel on snow."
	icon_state = "snow_on"

	bike_icon = "snow"
	land_speed = 3
	space_speed = 0
	protection_percent = 10
	can_hover = FALSE