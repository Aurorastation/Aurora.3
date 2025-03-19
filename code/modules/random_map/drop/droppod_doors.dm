/obj/structure/droppod_door
	name = "pod door"
	desc = "A drop pod door. Opens rapidly using explosive bolts."
	icon = 'icons/obj/structures.dmi'
	icon_state = "droppod_door_closed"
	anchored = 1
	density = 1
	opacity = 1
	layer = TURF_LAYER + 0.1
	var/deploying
	var/deployed

/obj/structure/droppod_door/Initialize(mapload, var/autoopen)
	. = ..(mapload)
	if(autoopen)
		addtimer(CALLBACK(src, PROC_REF(deploy)), 100)

/obj/structure/droppod_door/attack_ai(var/mob/user)
	if(!Adjacent(user))
		return
	attack_hand(user)

/obj/structure/droppod_door/attack_generic(var/mob/user)
	attack_hand(user)

/obj/structure/droppod_door/attack_hand(var/mob/user)
	if(deploying || deployed) return
	to_chat(user, SPAN_DANGER("You prime the explosive bolts. Better get clear!"))
	sleep(30)
	deploy()

/obj/structure/droppod_door/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if(WT.isOn())
			user.visible_message(
				SPAN_NOTICE("[user] begins cutting \the [src]'s safety bolts."),
				SPAN_NOTICE("You begin welding \the [src]'s safety bolts."),
				SPAN_NOTICE("You hear a welding torch on metal.")
			)
			if(!WT.use_tool(src, user, 50, volume = 50))
				return
			if(!WT.use(1, user))
				to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
				return
			user.visible_message(
				SPAN_NOTICE("[user] cuts \the [src]'s safety bolts and removes the plating."),
				SPAN_NOTICE("You cut \the [src]'s safety bolts and remove the plating.")
			)
			new /obj/item/stack/material/steel(get_turf(src), 5)
			qdel(src)

/obj/structure/droppod_door/proc/deploy()
	if(deployed)
		return

	deployed = 1
	visible_message(SPAN_DANGER("The explosive bolts on \the [src] detonate, throwing it open!"))
	playsound(src.loc, 'sound/effects/bang.ogg', 50, 1, 5)

	// This is shit but it will do for the sake of testing.
	for(var/obj/structure/droppod_door/D in orange(1,src))
		if(D.deployed)
			continue
		D.deploy()

	// Overwrite turfs.
	var/turf/origin = get_turf(src)
	origin.ChangeTurf(/turf/simulated/floor/reinforced)
	origin.reconsider_lights() // Forcing updates
	var/turf/T = get_step(origin, src.dir)
	T.ChangeTurf(/turf/simulated/floor/reinforced)
	T.reconsider_lights() // Forcing updates

	// Destroy turf contents.
	for(var/obj/O in origin)
		if(!O.simulated)
			continue
		qdel(O) //crunch
	for(var/obj/O in T)
		if(!O.simulated)
			continue
		qdel(O) //crunch

	// Hurl the mobs away.
	for(var/mob/living/M in T)
		M.throw_at(get_edge_target_turf(T,src.dir),rand(0,3),50)
	for(var/mob/living/M in origin)
		M.throw_at(get_edge_target_turf(origin,src.dir),rand(0,3),50)

	// Create a decorative ramp bottom and flatten out our current ramp.
	density = 0
	opacity = 0
	icon_state = "ramptop"
	var/obj/structure/droppod_door/door_bottom = new(T)
	door_bottom.deployed = 1
	door_bottom.density = 0
	door_bottom.opacity = 0
	door_bottom.dir = src.dir
	door_bottom.icon_state = "rampbottom"
