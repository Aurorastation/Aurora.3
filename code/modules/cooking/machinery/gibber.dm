
/obj/machinery/gibber
	name = "gibber"
	desc = "The name isn't descriptive enough?"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	density = 1
	anchored = TRUE
	req_access = list(access_kitchen,access_morgue)

	var/operating = 0 //Is it on?
	var/dirty = 0 // Does it need cleaning?
	var/mob/living/occupant // Mob who has been put inside
	var/gib_time = 40        // Time from starting until meat appears
	var/gib_throw_dir = WEST // Direction to spit meat and gibs in.

	idle_power_usage = 2
	active_power_usage = 500
	
//auto-gibs anything that bumps into it
/obj/machinery/gibber/autogibber
	var/turf/input_plate

/obj/machinery/gibber/autogibber/Initialize()
	. = ..()
	for(var/i in cardinal)
		var/obj/machinery/mineral/input/input_obj = locate( /obj/machinery/mineral/input, get_step(loc, i) )
		if(input_obj)
			if(isturf(input_obj.loc))
				input_plate = input_obj.loc
				gib_throw_dir = i
				qdel(input_obj)
				break

	if(!input_plate)
		log_misc("a [src] didn't find an input plate.")
		return

/obj/machinery/gibber/autogibber/CollidedWith(var/atom/A)
	if(!input_plate)
		return
	if(!ismob(A))
		return
	var/mob/M = A
	if(M.loc == input_plate)
		M.forceMove(src)
		M.gib()


/obj/machinery/gibber/Initialize()
	. = ..()
	add_overlay("grjam")

/obj/machinery/gibber/update_icon()
	cut_overlays()
	if (dirty)
		add_overlay("grbloody")
	if(stat & (NOPOWER|BROKEN))
		return
	if (!occupant)
		add_overlay("grjam")
	else if (operating)
		add_overlay("gruse")
	else
		add_overlay("gridle")

/obj/machinery/gibber/relaymove(mob/user as mob)
	go_out()
	return

/obj/machinery/gibber/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operating)
		to_chat(user, SPAN_DANGER("[src] is locked and running, wait for it to finish."))
		return
	startgibbing(user)

/obj/machinery/gibber/examine()
	..()
	to_chat(usr, "The safety guard is [emagged ? SPAN_DANGER("disabled") : "enabled"].")

/obj/machinery/gibber/emag_act(var/remaining_charges, var/mob/user)
	emagged = !emagged
	to_chat(user, SPAN_DANGER("You [emagged ? "disable" : "enable"] [src]'s safety guard."))
	return TRUE

/obj/machinery/gibber/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(G.state < GRAB_AGGRESSIVE)
			to_chat(user, SPAN_DANGER("You need a better grip to do that!"))
			return
		move_into_gibber(user,G.affecting)
		user.drop_from_inventory(G)

	else if(isorgan(W))
		user.drop_from_inventory(W)
		//TODO: Gibber Animations
		qdel(W)
		user.visible_message(SPAN_DANGER("[user] feeds [W] into [src], obliterating it."))

	do_hair_pull(user)

/obj/machinery/gibber/MouseDrop_T(mob/target, mob/user)
	if(user.stat || user.restrained())
		return
	move_into_gibber(user,target)

/obj/machinery/gibber/proc/move_into_gibber(var/mob/user,var/mob/living/victim)

	if(occupant)
		to_chat(user, SPAN_DANGER("[src] is full, empty it first!"))
		return

	if(operating)
		to_chat(user, SPAN_DANGER("[src] is locked and running, wait for it to finish."))
		return

	if(!(iscarbon(victim) || isanimal(victim)))
		to_chat(user, SPAN_DANGER("This is not suitable for [src]!"))
		return

	if(ishuman(victim) && !emagged && !victim.isMonkey())
		to_chat(user, SPAN_DANGER("[src]'s safety guard is engaged!"))
		return


	if(victim.abiotic(1))
		to_chat(user, SPAN_DANGER("[victim] may not have abiotic items on."))
		return

	user.visible_message(SPAN_DANGER("[user] starts to put [victim] into [src]!"))
	add_fingerprint(user)
	if(!do_mob(user, victim, 30 SECONDS) || occupant || !victim.Adjacent(src) || !user.Adjacent(src) || !victim.Adjacent(user))
		return
	user.visible_message(SPAN_DANGER("[user] stuffs [victim] into [src]!"))
	if(victim.client)
		victim.client.perspective = EYE_PERSPECTIVE
		victim.client.eye = src
	victim.forceMove(src)
	occupant = victim
	update_icon()

/obj/machinery/gibber/verb/eject()
	set category = "Object"
	set name = "Empty Gibber"
	set src in oview(1)

	if (usr.stat != 0)
		return
	go_out()
	add_fingerprint(usr)
	return

/obj/machinery/gibber/proc/go_out()
	if(operating || !occupant)
		return
	for(var/obj/O in src)
		O.forceMove(loc)
	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(loc)
	occupant = null
	update_icon()
	return


/obj/machinery/gibber/proc/startgibbing(mob/user as mob)
	if(operating)
		return
	if(!occupant)
		visible_message(SPAN_DANGER("You hear a loud metallic grinding sound."))
		return
	use_power_oneoff(1000)
	visible_message(SPAN_DANGER("You hear a loud [occupant.isSynthetic() ? "metallic" : "squelchy"] grinding sound."))
	operating = TRUE
	update_icon()

	var/slab_count = 3
	var/slab_type = /obj/item/reagent_containers/food/snacks/meat
	var/slab_nutrition = occupant.nutrition / 15

	// Some mobs have specific meat item types.
	if(isanimal(occupant))
		var/mob/living/simple_animal/critter = occupant
		if(critter.meat_amount)
			slab_count = critter.meat_amount
		if(critter.meat_type)
			slab_type = critter.meat_type
	else if(istype(occupant, /mob/living/carbon/alien))
		var/mob/living/carbon/alien/A = occupant
		slab_type = A.meat_type
	else if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		slab_type = H.species.meat_type

	// Small mobs don't give as much nutrition.
	slab_nutrition /= (issmall(occupant) + 1) * slab_count

	for(var/i=1 to slab_count)
		var/obj/item/reagent_containers/food/snacks/meat/new_meat = new slab_type(src, rand(3,8))
		if(istype(new_meat))
			new_meat.reagents.add_reagent(/decl/reagent/nutriment,slab_nutrition)
			if(occupant.reagents)
				occupant.reagents.trans_to_obj(new_meat, round(occupant.reagents.total_volume/slab_count,1))

	occupant.attack_log += "\[[time_stamp()]\] Was gibbed by <b>[user]/[user.ckey]</b>" //One shall not simply gib a mob unnoticed!
	user.attack_log += "\[[time_stamp()]\] Gibbed <b>[occupant]/[occupant.ckey]</b>"
	msg_admin_attack("[key_name_admin(user)] gibbed [occupant] ([occupant.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(occupant))

	occupant.ghostize()

	spawn(gib_time)

		operating = 0
		occupant.gib()
		occupant = null

		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		operating = 0
		for (var/obj/thing in contents)
			// Todo: unify limbs and internal organs
			// There's a chance that the gibber will fail to destroy some evidence.
			if(isorgan(thing) && prob(80))
				qdel(thing)
				continue
			thing.forceMove(get_turf(thing)) // Drop it onto the turf for throwing.
			thing.throw_at(get_edge_target_turf(src,gib_throw_dir),rand(1,3),emagged ? 50 : 10) // Being pelted with bits of meat and bone would hurt.

		update_icon()
