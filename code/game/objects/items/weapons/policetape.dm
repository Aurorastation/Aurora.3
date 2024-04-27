var/list/tape_roll_applications = list()

//Define all tape types in policetape.dm
/obj/item/taperoll
	name = "tape roll"
	icon = 'icons/obj/policetape.dmi'
	icon_state = "tape"
	w_class = ITEMSIZE_SMALL
	var/static/list/hazard_overlays
	var/turf/start
	var/turf/end
	var/tape_type = /obj/item/tape
	var/icon_base

/obj/item/taperoll/Initialize()
	. = ..()
	if(!hazard_overlays)
		hazard_overlays = list()
		hazard_overlays["[NORTH]"]	= image('icons/effects/warning_stripes.dmi', icon_state = "N")
		hazard_overlays["[EAST]"]	= image('icons/effects/warning_stripes.dmi', icon_state = "E")
		hazard_overlays["[SOUTH]"]	= image('icons/effects/warning_stripes.dmi', icon_state = "S")
		hazard_overlays["[WEST]"]	= image('icons/effects/warning_stripes.dmi', icon_state = "W")

/obj/item/tape
	name = "tape"
	icon = 'icons/obj/policetape.dmi'
	anchored = 1
	layer = BASE_ABOVE_OBJ_LAYER
	var/lifted = 0
	var/list/crumplers
	var/crumpled = 0
	var/icon_base

/obj/item/tape/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(LAZYLEN(crumplers) && is_adjacent)
		. += SPAN_WARNING("\The [initial(name)] has been crumpled by [english_list(crumplers)].")

/obj/item/taperoll/police
	name = "police tape"
	desc = "A roll of police tape used to block off crime scenes from the public."
	icon_state = "police_start"
	tape_type = /obj/item/tape/police
	icon_base = "police"

/obj/item/tape/police
	name = "police tape"
	desc = "A length of police tape.  Do not cross."
	req_access = list(ACCESS_SECURITY)
	icon_base = "police"

/obj/item/taperoll/medical
	name = "medical tape"
	desc = "A roll of medical tape used to prevent overcrowding of hallways during emergencies."
	icon_state = "medical_start"
	tape_type = /obj/item/tape/medical
	icon_base = "medical"

/obj/item/tape/medical
	name = "medical tape"
	desc = "A length of medical tape. Better not cross it."
	req_one_access = list(ACCESS_MEDICAL_EQUIP)
	icon_base = "medical"

/obj/item/taperoll/science
	name = "science tape"
	desc = "A high-tech roll of science tape, used to prevent curious onlookers from failing into a research-borne singularity."
	icon_state = "science_start"
	tape_type = /obj/item/tape/science
	icon_base = "science"

/obj/item/tape/science
	name = "science tape"
	desc = "A length of science tape. Better not cross it."
	req_one_access = list(ACCESS_RESEARCH)
	icon_base = "science"

/obj/item/taperoll/engineering
	name = "engineering tape"
	desc = "A roll of engineering tape used to block off working areas from the public."
	icon_state = "engineering_start"
	tape_type = /obj/item/tape/engineering
	icon_base = "engineering"

/obj/item/tape/engineering
	name = "engineering tape"
	desc = "A length of engineering tape. Better not cross it."
	desc_info = "You can use a multitool on this tape to allow emergency shield generators to deploy shields on this tile."
	req_one_access = list(ACCESS_ENGINE, ACCESS_ATMOSPHERICS)
	icon_base = "engineering"
	var/shield_marker = FALSE

/obj/item/tape/engineering/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(shield_marker)
		. += SPAN_NOTICE("This strip of tape has been modified to serve as a marker for emergency shield generators to lock onto.")

/obj/item/tape/engineering/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.ismultitool())
		shield_marker = !shield_marker
		to_chat(user, SPAN_NOTICE("You [shield_marker ? "" : "un"]designate \the [src] as a target for an emergency shield generator."))
		if(shield_marker)
			animate(src, 1 SECOND, color = color_rotation(-60))
		else
			animate(src, 1 SECOND, color = initial(color))
		return
	return ..()

/obj/item/taperoll/custodial
	name = "custodial holographic tape"
	desc = "A high-tech roll of custodial tape, used to prevent people from tracking dirt everywhere and getting their shoes dirty."
	icon_state = "custodial_start"
	tape_type = /obj/item/tape/custodial
	icon_base = "custodial"

/obj/item/tape/custodial
	name = "custodial holographic tape"
	desc = "A length of custodial tape. Better not cross it."
	req_one_access = list(ACCESS_JANITOR)
	icon_base = "custodial"

/obj/item/taperoll/attack_self(mob/user as mob)
	if(icon_state == "[icon_base]_start")
		start = get_turf(src)
		to_chat(usr, SPAN_NOTICE("You place the first end of the [src]."))
		icon_state = "[icon_base]_stop"
	else
		icon_state = "[icon_base]_start"
		end = get_turf(src)
		if(start.y != end.y && start.x != end.x || start.z != end.z)
			to_chat(usr, SPAN_NOTICE("[src] can only be laid horizontally or vertically."))
			return

		var/turf/cur = start
		var/dir
		if (start.x == end.x)
			var/d = end.y-start.y
			if(d) d = d/abs(d)
			end = get_turf(locate(end.x,end.y+d,end.z))
			dir = "v"
		else
			var/d = end.x-start.x
			if(d) d = d/abs(d)
			end = get_turf(locate(end.x+d,end.y,end.z))
			dir = "h"

		var/can_place = 1
		while (cur!=end && can_place)
			if(cur.density == 1)
				can_place = 0
			else if (istype(cur, /turf/space))
				can_place = 0
			else
				for(var/obj/O in cur)
					if(istype(O, /obj/structure/lattice) && (!istype(O, /obj/item/tape) && O.density))
						can_place = 0
						break
			cur = get_step_towards(cur,end)
		if (!can_place)
			to_chat(usr, SPAN_NOTICE("You can't run \the [src] through that!"))
			return

		cur = start
		var/tapetest = 0
		while (cur!=end)
			for(var/obj/item/tape/Ptest in cur)
				if(Ptest.icon_state == "[Ptest.icon_base]_[dir]")
					tapetest = 1
			if(tapetest != 1)
				var/obj/item/tape/P = new tape_type(cur)
				P.icon_state = "[P.icon_base]_[dir]"
			cur = get_step_towards(cur,end)
		to_chat(usr, SPAN_NOTICE("You finish placing the [src]."))	//Git Test)

/obj/item/taperoll/afterattack(var/atom/A, mob/user as mob, proximity)
	if(!proximity)
		return

	if (istype(A, /obj/machinery/door/airlock))
		var/turf/T = get_turf(A)
		var/obj/item/tape/P = new tape_type(T.x,T.y,T.z)
		P.forceMove(locate(T.x,T.y,T.z))
		P.icon_state = "[src.icon_base]_door"
		P.layer = ABOVE_DOOR_LAYER
		to_chat(user, SPAN_NOTICE("You finish placing the [src]."))

	if (istype(A, /turf/simulated/floor) ||istype(A, /turf/unsimulated/floor))
		var/turf/F = A
		var/direction = user.loc == F ? user.dir : turn(user.dir, 180)
		var/icon/hazard_overlay = hazard_overlays["[direction]"]
		if(tape_roll_applications[F] == null)
			tape_roll_applications[F] = 0

		if(tape_roll_applications[F] & direction) // hazard_overlay in F.overlays wouldn't work.
			user.visible_message("[user] uses the adhesive of \the [src] to remove area markings from \the [F].", "You use the adhesive of \the [src] to remove area markings from \the [F].")
			F.cut_overlay(hazard_overlay, TRUE)
			tape_roll_applications[F] &= ~direction
		else
			user.visible_message("[user] applied \the [src] on \the [F] to create area markings.", "You apply \the [src] on \the [F] to create area markings.")
			F.add_overlay(hazard_overlay, TRUE)
			tape_roll_applications[F] |= direction
		return

/obj/item/tape/proc/crumple(var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/card/id/ID = H.GetIdCard(TRUE)
		if(ID && ID.registered_name)
			LAZYDISTINCTADD(crumplers, ID.registered_name)
	if(!crumpled)
		crumpled = TRUE
		icon_state = "[icon_state]_c"
		name = "crumpled [name]"

/obj/item/tape/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!lifted && ismob(mover))
		var/mob/M = mover
		if(!allowed(M))	//only select few learn art of not crumpling the tape
			if(M.a_intent != I_HURT && M.m_intent != M_RUN)
				return FALSE
			to_chat(M, SPAN_WARNING("You aren't supposed to go past the [initial(name)]..."))
			crumple(mover)
	return ..()

/obj/item/tape/attackby(obj/item/attacking_item, mob/user)
	return breaktape(attacking_item, user)

/obj/item/tape/attack_hand(mob/user)
	if(user.a_intent == I_HELP)
		lifted = !lifted
		user.visible_message("<b>[user]</b> [lifted ? "lifts" : "drops"] the [initial(name)], [lifted ? "allowing" : "blocking"] passage.", SPAN_NOTICE("You [lifted ? "lift" : "drop"] the [initial(name)], [lifted ? "allowing" : "blocking"] passage."))
		var/shake_time = shake_animation()
		sleep(shake_time)
		if(!allowed(user))
			crumple(user)
		if(lifted)
			animate(src, 1 SECOND, alpha = 150)
			layer = ABOVE_HUMAN_LAYER
		else
			animate(src, 1 SECOND, alpha = initial(alpha))
			reset_plane_and_layer()
	else
		breaktape(null, user)

/obj/item/tape/proc/breaktape(obj/item/W as obj, mob/user as mob)
	if(user.a_intent == I_HELP && ((!W.can_puncture() && src.allowed(user))))
		to_chat(user, SPAN_NOTICE("You can't break \the [src] with that!"))
		return
	user.visible_message(SPAN_NOTICE("[user] breaks \the [src]!"))

	var/dir[2]
	var/icon_dir = src.icon_state
	if(icon_dir == "[src.icon_base]_h")
		dir[1] = EAST
		dir[2] = WEST
	if(icon_dir == "[src.icon_base]_v")
		dir[1] = NORTH
		dir[2] = SOUTH

	for(var/i=1;i<3;i++)
		var/N = 0
		var/turf/cur = get_step(src,dir[i])
		while(N != 1)
			N = 1
			for (var/obj/item/tape/P in cur)
				if(P.icon_state == icon_dir)
					N = 0
					qdel(P)
			cur = get_step(cur,dir[i])

	qdel(src)
	return TRUE
