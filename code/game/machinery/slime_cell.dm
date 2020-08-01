/obj/machinery/slime_cell
	name = "slime cell"
	desc = "A chamber capable of absorbing slime macronutrients for research purposes."
	icon = 'icons/obj/slime_cryo.dmi'
	icon_state = "slime_cell0"
	density = TRUE
	anchored = TRUE
	use_power = 0
	active_power_usage = 250
	var/mob/living/carbon/slime/occupant

/obj/machinery/slime_cell/machinery_process()
	if(!occupant)
		return
	if(stat & (NOPOWER|BROKEN))
		return
	for(var/tech_id in list(TECH_BLUESPACE, TECH_BIO, TECH_MAGNET))
		SSresearch.global_research.add_points_to_tech(tech_id, 250)

/obj/machinery/slime_cell/attackby(obj/item/G, mob/user)
	if(istype(G, /obj/item/grab))
		var/obj/item/grab/grab = G
		var/mob/living/carbon/slime/S = grab.affecting
		if(!istype(S))
			to_chat(user, SPAN_WARNING("Only non-pet slimes can be inserted into \the [src]!"))
			return
		if(!insert_check(user, S))
			return

		user.visible_message("<b>[user]</b> starts putting \the [S] into \the [src].", SPAN_NOTICE("You start putting \the [S] into \the [src]."), range = 3)

		if(do_mob(user, S, 30, needhand = 0))
			var/bucklestatus = S.bucklecheck(user)
			if(!bucklestatus)
				return
			if(bucklestatus == 2)
				var/obj/structure/LB = S.buckled
				LB.user_unbuckle_mob(user)
			if(insert_slime(user, S))
				user.visible_message("<b>[user]</b> puts [S] into [src].", SPAN_NOTICE("You put \the [S] into \the [src]."), range = 3)
				qdel(G)

/obj/machinery/slime_cell/MouseDrop_T(atom/movable/O, mob/living/user)
	if(!isslime(O))
		to_chat(user, SPAN_WARNING("Only non-pet slimes can be inserted into \the [src]!"))
		return
	if(!istype(user))
		return
	var/mob/living/carbon/slime/S = O

	if(!insert_check(user, S))
		return

	var/bucklestatus = S.bucklecheck(user)
	if (!bucklestatus)//We must make sure the person is unbuckled before they go in
		return

	if(S == user)
		user.visible_message("<b>[user]</b> starts climbing into \the [src].", SPAN_NOTICE("You start climbing into \the [src]."), range = 3)
	else
		user.visible_message("<b>[user]</b> starts putting \the [S] into \the [src].", SPAN_NOTICE("You start putting \the [S] into \the [src]."), range = 3)
	if(do_mob(user, S, 30, needhand = 0))
		if(bucklestatus == 2)
			var/obj/structure/LB = S.buckled
			LB.user_unbuckle_mob(user)
		if(insert_slime(user, S))
			if(S == user)
				user.visible_message("<b>[user]</b> climbs into \the [src].", SPAN_NOTICE("You climb into \the [src]."), range = 3)
			else
				user.visible_message("<b>[user]</b> puts [S] into [src].", SPAN_NOTICE("You put \the [S] into \the [src]."), range = 3)
				if(user.pulling == S)
					user.stop_pulling()

/obj/machinery/slime_cell/proc/insert_check(var/mob/user, var/mob/slime)
	if(stat & (NOPOWER|BROKEN))
		to_chat(usr, SPAN_WARNING("\The [src] is not functioning."))
		return FALSE
	if(!isslime(slime))
		to_chat(usr, SPAN_WARNING("\The [src] can only take non-pet slimes!"))
		return FALSE
	if(occupant)
		to_chat(usr, SPAN_WARNING("The cryo cell is already occupied!"))
		return FALSE
	return TRUE

/obj/machinery/slime_cell/proc/insert_slime(var/mob/user, var/mob/slime)
	if(!insert_check(user, slime))
		return
	if(slime.client)
		slime.client.perspective = EYE_PERSPECTIVE
		slime.client.eye = src
	slime.stop_pulling()
	slime.forceMove(src)
	occupant = slime
	update_use_power(2)
	add_fingerprint(user)
	update_icon()
	return TRUE

/obj/machinery/slime_cell/verb/move_eject()
	set name = "Eject Occupant"
	set category = "Object"
	set src in oview(1)

	if(usr == occupant)
		if(usr.stat)
			to_chat(usr, SPAN_WARNING("You are unable to eject while unconscious."))
			return
		to_chat(usr, "You manage to shock the internal circuitry with your internal charge, activating the release procedure. (You will eject in 30 seconds)")
		audible_message("\icon[src] [src] sparks!")
		addtimer(CALLBACK(src, .proc/go_out), 30 SECONDS)
	else
		if(use_check_and_message(usr))
			return
		go_out()
	add_fingerprint(usr)
	return

/obj/machinery/slime_cell/proc/go_out()
	if(!occupant)
		return

	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE

	occupant.forceMove(get_turf(src))
	occupant = null
	update_use_power(0)
	update_icon()

/obj/machinery/slime_cell/update_icon()
	cut_overlays()

	if(!occupant)
		icon_state = "slime_cell0"
	else
		icon_state = "cell_bottom"

		add_overlay("pod_rear")

		var/image/I = image(occupant.icon, null, occupant.icon_state)
		I.alpha = 170
		I.pixel_y = 6
		add_overlay(I)

		add_overlay("pod_fore")

/obj/machinery/slime_cell/Destroy()
	if(occupant)
		go_out()
	return ..()