/obj/item/mecha_equipment/drill_mover
	name = "mounted drill loader"
	desc = "A large back-mounted drill loader, capable of picking up and deploying large industrial drills."
	icon_state = "mecha_drill_loader"
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	w_class = ITEMSIZE_HUGE
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	var/obj/machinery/mining/drill/held_drill
	var/list/obj/machinery/mining/brace/held_braces
	var/charging = FALSE

/obj/item/mecha_equipment/drill_mover/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()

	if(.)
		for(var/obj/machinery/M in range(1, target))
			if(istype(M, /obj/machinery/mining/brace))
				var/obj/machinery/mining/brace/B = M
				B.anchored = FALSE
				B.disconnect()
				if(length(held_braces) < 2)
					owner.visible_message(SPAN_NOTICE("\The [owner] starts loading \the [B] into \the [src]."))
					if(do_after(user, 5 SECONDS, act_target = owner, extra_checks = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(atom_maintain_position), B, B.loc)))
						owner.visible_message(SPAN_NOTICE("\The [owner] loads \the [B] into \the [src]."))
						B.forceMove(src)
						LAZYADD(held_braces, B)
			if(!held_drill && istype(M, /obj/machinery/mining/drill))
				var/obj/machinery/mining/drill/D = M
				owner.visible_message(SPAN_NOTICE("\The [owner] starts loading \the [D] into \the [src]."))
				if(do_after(user, 5 SECONDS, act_target = owner, extra_checks = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(atom_maintain_position), D, D.loc)))
					owner.visible_message(SPAN_NOTICE("\The [owner] loads \the [D] into \the [src]."))
					D.anchored = FALSE
					D.active = FALSE
					D.forceMove(src)
					held_drill = D

/obj/item/mecha_equipment/drill_mover/attack_self(var/mob/user)
	. = ..()
	if(.)
		deploy_drill(user)

/obj/item/mecha_equipment/drill_mover/proc/deploy_drill(var/mob/user)
	var/turf/drill_turf = get_turf(src)
	var/turf/left_brace_turf = get_step(src, WEST)
	var/turf/right_brace_turf = get_step(src, EAST)
	var/list/turf/deployment_turfs = list(drill_turf, left_brace_turf, right_brace_turf)
	for(var/turf/T in list(drill_turf, left_brace_turf, right_brace_turf))
		if(T.density || isopenspace(T))
			to_chat(user, SPAN_WARNING("There isn't enough space to deploy the drill here!"))
			return
	if(held_drill)
		held_drill.forceMove(deployment_turfs[1])
		held_drill.anchored = TRUE
		deployment_turfs -= deployment_turfs[1]
	for(var/obj/machinery/mining/brace/B in held_braces)
		B.forceMove(deployment_turfs[1])
		B.anchored = TRUE
		B.connect()
		deployment_turfs -= deployment_turfs[1]
	if(held_drill)
		held_drill.check_supports()
		if(length(held_drill.supports) >= held_drill.braces_needed)
			held_drill.active = TRUE
			held_drill.need_update_field = TRUE
			held_drill.need_player_check = FALSE
			held_drill.update_icon()
	held_drill = null
	held_braces = null

/obj/item/mecha_equipment/drill_mover/get_hardpoint_status_value()
	var/carried_amount = 0
	if(held_drill)
		carried_amount++
	var/increase_amount = length(held_braces) // i have to do this because += with null makes the whole thing go weird
	if(increase_amount)
		carried_amount += increase_amount
	return carried_amount / 3

/obj/item/mecha_equipment/drill_mover/uninstalled()
	if(held_drill)
		held_drill.dropInto(get_turf(src))
	for(var/obj/brace in held_braces)
		brace.dropInto(get_turf(src))
		held_braces -= brace
	. = ..()