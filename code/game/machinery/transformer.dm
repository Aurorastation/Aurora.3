/obj/machinery/transformer
	name = "Automatic Robotic Factory 5000"
	desc = "A large, complicated machine with thousands of moving parts and sharp instruments. There is an entrance and exit: large enough to fit someone inside"
	icon = 'icons/obj/recycling.dmi'
	icon_state = "separator-AO1"
	layer = MOB_LAYER+1 // Overhead
	anchored = 1
	density = 1
	var/transform_dead = 0
	var/transform_standing = 0
	var/canuse = 1

/obj/machinery/transformer/Initialize()
	// On us
	. = ..()
	if(loc)
		MakeConveyor()
	else
		addtimer(CALLBACK(src, .proc/MakeConveyor), 5)

/obj/machinery/transformer/proc/MakeConveyor()
	if (!loc)
		return
	new /obj/machinery/conveyor(loc, WEST, 1)
	var/turf/T = get_turf(src)
	if(T)// Spawn Conveyour Belts
		//East
		var/turf/east = get_step(src, EAST)
		if(istype(east, /turf/simulated/floor))
			new /obj/machinery/conveyor(east, WEST, 1)

		// West
		var/turf/west = get_step(src, WEST)
		if(istype(west, /turf/simulated/floor))
			new /obj/machinery/conveyor(west, WEST, 1)

/obj/machinery/transformer/CollidedWith(var/atom/movable/AM)
	// HasEntered didn't like people lying down.
	if(ishuman(AM))
		// Only humans can enter from the west side, while lying down.
		var/move_dir = get_dir(loc, AM.loc)
		var/mob/living/carbon/human/H = AM
		if((transform_standing || H.lying) && move_dir == EAST)
			AM.forceMove(src.loc)
			make_robot(AM)

/obj/machinery/transformer/proc/make_robot(var/mob/living/carbon/human/H)
	if(stat & (BROKEN|NOPOWER))
		return
	if(!transform_dead && H.stat == DEAD)
		playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
		return
	if(canuse)
		playsound(src.loc, 'sound/items/welder.ogg', 50, 1)
		use_power(6000) // Use a lot of power.
		message_admins("[key_name(H)] has been borgified by the Autoborger 5000.")
		visible_message("<span class='danger'>The machine makes a series of loud sounds as it starts to replace [H]'s organs and limbs with robotic parts!</span>")
		to_chat(H, "<span class='danger'>You feel a horrible pain as the machine you entered starts to rip you apart and replace your limbs and organs!</span>")
		to_chat(H, "<span class='danger'> You lose consciousness for a brief moment before waking up with a whole new body...</span>")
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
		canuse = FALSE
		addtimer(CALLBACK(src, .proc/rearm), 120 SECONDS)
		H.Robotize()
	else
		playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
		visible_message("<span class='notice'>The machine displays an error message reading it is still making the required parts.</span>")
		return

/obj/machinery/transformer/proc/rearm()
	src.visible_message("<span class='notice'>\The [src] pings!</span>")
	playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
	canuse = TRUE
