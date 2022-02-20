/obj/structure
	icon = 'icons/obj/structures.dmi'
	w_class = ITEMSIZE_IMMENSE
	layer = OBJ_LAYER - 0.01

	var/climbable
	var/breakable
	var/parts
	var/list/climbers
	var/list/footstep_sound	//footstep sounds when stepped on

	var/material/material
	var/build_amt = 2 // used by some structures to determine into how many pieces they should disassemble into or be made with

	var/slowdown = 0 //amount that pulling mobs have their movement delayed by

/obj/structure/Destroy()
	if(parts)
		new parts(loc)
	if (smooth)
		queue_smooth_neighbors(src)
	return ..()

/obj/structure/attack_hand(mob/user)
	if(breakable)
		if(HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			attack_generic(user,1,"smashes")
		else if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_generic(user,1,"slices")

	if(LAZYLEN(climbers) && !(user in climbers))
		user.visible_message("<span class='warning'>[user] shakes \the [src].</span>", \
					"<span class='notice'>You shake \the [src].</span>")
		structure_shaken()

	return ..()

/obj/structure/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			return

/obj/structure/proc/dismantle()
	var/material/dismantle_material
	if(!get_material())
		dismantle_material = SSmaterials.get_material_by_name(DEFAULT_WALL_MATERIAL) //if there is no defined material, it will use steel
	else
		dismantle_material = get_material()
	for(var/i = 1 to build_amt)
		dismantle_material.place_sheet(loc)
	qdel(src)

/obj/structure/Initialize(mapload)
	. = ..()
	if (!mapload)
		updateVisibility(src)	// No point checking this before visualnet initializes.
	if(climbable)
		verbs += /obj/structure/proc/climb_on
	if (smooth)
		queue_smooth(src)
		queue_smooth_neighbors(src)

/obj/structure/proc/climb_on()

	set name = "Climb structure"
	set desc = "Climbs onto a structure."
	set category = "Object"
	set src in oview(1)

	if(can_climb(usr))
		do_climb(usr)

/obj/structure/handle_middle_mouse_click(mob/user)
	if(can_climb(user))
		do_climb(usr)
		return TRUE
	return FALSE

/obj/structure/MouseDrop_T(mob/target, mob/user)

	var/mob/living/H = user
	if(istype(H) && can_climb(H) && target == user)
		do_climb(target)
	else
		return ..()

/obj/structure/proc/can_climb(var/mob/living/user, post_climb_check=0)
	if (!climbable || !can_touch(user) || (!post_climb_check && (user in climbers)))
		return 0

	if (!user.Adjacent(src))
		to_chat(user, "<span class='danger'>You can't climb there, the way is blocked.</span>")
		return 0

	var/obj/occupied = turf_is_crowded()
	if(occupied)
		to_chat(user, "<span class='danger'>There's \a [occupied] in the way.</span>")
		return 0
	return 1

/obj/structure/proc/turf_is_crowded(var/exclude_self = FALSE)
	var/turf/T = get_turf(src)
	if(!T || !istype(T))
		return 0
	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			var/obj/structure/S = O
			if(S.climbable)
				continue
		if(O && O.density && !(O.flags & ON_BORDER)) //ON_BORDER structures are handled by the Adjacent() check.
			if(exclude_self && O == src)
				continue
			return O
	return 0

/obj/structure/proc/do_climb(var/mob/living/user)
	if (!can_climb(user))
		return

	usr.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")
	LAZYADD(climbers, user)

	if(!do_after(user,50))
		LAZYREMOVE(climbers, user)
		return

	if (!can_climb(user, post_climb_check=1))
		LAZYREMOVE(climbers, user)
		return

	usr.forceMove(get_turf(src))

	if (get_turf(user) == get_turf(src))
		usr.visible_message("<span class='warning'>[user] climbs onto \the [src]!</span>")
	LAZYREMOVE(climbers, user)

/obj/structure/proc/structure_shaken()
	for(var/mob/living/M in climbers)
		M.Weaken(1)
		to_chat(M, "<span class='danger'>You topple as you are shaken off \the [src]!</span>")
		LAZYREMOVE(climbers, M)

	for(var/mob/living/M in get_turf(src))
		if(M.lying) return //No spamming this on people.

		M.Weaken(3)
		to_chat(M, "<span class='danger'>You topple as \the [src] moves under you!</span>")

		if(prob(25))

			var/damage = rand(15,30)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				to_chat(H, "<span class='danger'>You land heavily!</span>")
				M.adjustBruteLoss(damage)
				return

			var/obj/item/organ/external/affecting

			switch(pick(list("ankle","wrist",BP_HEAD,"knee","elbow")))
				if("ankle")
					affecting = H.get_organ(pick(BP_L_FOOT, BP_R_FOOT))
				if("knee")
					affecting = H.get_organ(pick(BP_L_LEG, BP_R_LEG))
				if("wrist")
					affecting = H.get_organ(pick(BP_L_HAND, BP_R_HAND))
				if("elbow")
					affecting = H.get_organ(pick(BP_L_ARM, BP_R_ARM))
				if(BP_HEAD)
					affecting = H.get_organ(BP_HEAD)

			if(affecting)
				to_chat(M, "<span class='danger'>You land heavily on your [affecting.name]!</span>")
				affecting.take_damage(damage, 0)
				if(affecting.parent)
					affecting.parent.add_autopsy_data("Misadventure", damage)
			else
				to_chat(H, "<span class='danger'>You land heavily!</span>")
				H.adjustBruteLoss(damage)

			H.UpdateDamageIcon()
			H.updatehealth()
	return

/obj/structure/proc/can_touch(var/mob/user)
	if (!user)
		return 0
	if(!Adjacent(user))
		return 0
	if (user.restrained() || user.buckled_to)
		to_chat(user, "<span class='notice'>You need your hands and legs free for this.</span>")
		return 0
	if (user.stat || user.paralysis || user.sleeping || user.lying || user.weakened)
		return 0
	if (issilicon(user))
		to_chat(user, "<span class='notice'>You need hands for this.</span>")
		return 0
	return 1

/obj/structure/attack_generic(var/mob/user, var/damage, var/attack_verb, var/wallbreaker)
	if(!breakable || !damage || !wallbreaker)
		return 0
	visible_message("<span class='danger'>[user] [attack_verb] the [src] apart!</span>")
	user.do_attack_animation(src)
	spawn(1)
		qdel(src)
	return 1

/obj/structure/get_material()
	return material
