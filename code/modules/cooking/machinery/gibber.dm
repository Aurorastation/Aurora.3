
/obj/machinery/gibber
	name = "autobutcher"
	desc = "Also known as the gibber, affectionately."
	desc_extended = "WARNING: Insurance no longer covers entertaining intrusive thoughts. Keep your limbs to yourself."
	icon = 'icons/obj/machinery/cooking_machines.dmi'
	icon_state = "grinder"
	density = TRUE
	anchored = TRUE
	req_access = list(ACCESS_GALLEY,ACCESS_MORGUE)

	/// Is it on?
	var/operating = FALSE
	/// Does it need cleaning?
	var/dirty = FALSE
	/// Mob who has been put inside
	var/mob/living/occupant
	/// Time from starting until meat appears
	var/gib_time = 4 SECONDS
	/// Direction to spit meat and gibs in.
	var/gib_throw_dir = WEST

	idle_power_usage = 2
	active_power_usage = 500

/// Auto-gibs anything that moves onto its input plate. This is a fun variant, someone map it in somewhere!
/obj/machinery/gibber/autogibber
	var/turf/input_plate

/obj/machinery/gibber/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The safety guard is [emagged ? SPAN_DANGER("disabled") : "enabled"]."

/obj/machinery/gibber/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This can be emagged to let you feed people into it; it also removes the ID access requirements."

/obj/machinery/gibber/autogibber/Initialize()
	. = ..()
	for(var/i in GLOB.cardinals)
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

/obj/machinery/gibber/autogibber/CollidedWith(atom/bumped_atom)
	if(stat & (NOPOWER|BROKEN))
		return
	if(!input_plate)
		return
	if(!ismob(bumped_atom))
		return
	var/mob/victim_mob = bumped_atom
	var/mob/living/carbon/human/victim_human
	// A lot of reused code here but it's needed to prevent CollidedWith from running DoMob, which makes SpaceDMM sad because of SHOULD_NOT_SLEEP and etc etc etc.
	if(ishuman(victim_mob))
		victim_human = victim_mob

	if(occupant)
		if(victim_human.client)
			to_chat(victim_human, SPAN_DANGER("[src] is full, you can't fit!"))
		return FALSE

	if(operating)
		if(victim_human.client)
			to_chat(victim_human, SPAN_DANGER("[src] is locked and running, it won't let you in!"))
		return FALSE

	if(ishuman(victim_human) && !emagged)
		if(victim_human.client)
			to_chat(victim_human, SPAN_DANGER("\The [src]'s safety guard is engaged!"))
		return FALSE

	if(istype(victim_mob, /mob) && victim_mob.loc == input_plate)
		visible_message(SPAN_DANGER("[victim_mob] gets automatically fed into \the [src]!"))
	else
		return FALSE
	if(victim_human.client)
		victim_human.client.perspective = EYE_PERSPECTIVE
		victim_human.client.eye = src
	victim_mob.forceMove(src)
	occupant = victim_mob
	startgibbing(victim_mob)
	update_icon()

/obj/machinery/gibber/Initialize()
	. = ..()
	AddOverlays("grjam")

/obj/machinery/gibber/update_icon()
	ClearOverlays()
	if(dirty)
		AddOverlays("grbloody")
	if(stat & (NOPOWER|BROKEN))
		return
	if(!occupant)
		AddOverlays("grjam")
	else if (operating)
		AddOverlays("gruse")
	else
		AddOverlays("gridle")

/obj/machinery/gibber/relaymove(mob/living/user, direction)
	. = ..()

	go_out()
	return

/obj/machinery/gibber/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operating)
		to_chat(user, SPAN_DANGER("[src] is locked and running, wait for it to finish."))
		return
	startgibbing(user)

/obj/machinery/gibber/emag_act(var/remaining_charges, var/mob/user)
	emagged = !emagged
	to_chat(user, SPAN_DANGER("You [emagged ? "disable" : "enable"] [src]'s safety guard."))
	return TRUE

/obj/machinery/gibber/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/grab))
		var/obj/item/grab/G = attacking_item
		if(G.state < GRAB_AGGRESSIVE)
			to_chat(user, SPAN_DANGER("You need a better grip to do that!"))
			return
		move_into_gibber(user,G.affecting)
		user.drop_from_inventory(G)

	else if(isorgan(attacking_item))
		user.drop_from_inventory(attacking_item)
		//TODO: Gibber Animations
		qdel(attacking_item)
		user.visible_message(SPAN_DANGER("[user] feeds [attacking_item] into [src], obliterating it."))

	do_hair_pull(user)

/obj/machinery/gibber/mouse_drop_receive(atom/dropped, mob/user, params)
	if(user.stat || user.restrained())
		return
	move_into_gibber(user, dropped)

/**
 * Moves the victim into the gibber. This can be triggered by a user trying to place the victim inside, or by
 * being sucked in via the input plate.
 */
/obj/machinery/gibber/proc/move_into_gibber(var/mob/user, var/mob/victim, var/automatic = FALSE)
	// All of these check for a user because if the machine is working autonomously, there's no one to send messages to in most cases we'd want to.
	if(occupant)
		to_chat(user, SPAN_DANGER("[src] is full, empty it first!"))
		return FALSE

	if(operating)
		to_chat(user, SPAN_DANGER("[src] is locked and running, wait for it to finish."))
		return FALSE

	if(!(iscarbon(victim) || isanimal(victim)))
		to_chat(user, SPAN_DANGER("This is not suitable for [src]!"))
		return FALSE

	if(ishuman(victim) && !emagged && !victim.isMonkey())
		to_chat(user, SPAN_DANGER("[src]'s safety guard is engaged!"))
		return FALSE

	if(victim.abiotic(1))
		to_chat(user, SPAN_DANGER("[victim] may not have abiotic items on."))
		return FALSE

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
			new_meat.reagents.add_reagent(/singleton/reagent/nutriment,slab_nutrition)
			if(occupant.reagents)
				occupant.reagents.trans_to_obj(new_meat, round(occupant.reagents.total_volume/slab_count,1))

	occupant.attack_log += "\[[time_stamp()]\] Was gibbed by <b>[user]/[user.ckey]</b>" //One shall not simply gib a mob unnoticed!
	user.attack_log += "\[[time_stamp()]\] Gibbed <b>[occupant]/[occupant.ckey]</b>"
	msg_admin_attack("[key_name_admin(user)] gibbed [occupant] ([occupant.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(occupant))

	occupant.ghostize()

	spawn(gib_time)

		operating = FALSE
		occupant.gib()
		occupant = null

		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		for (var/obj/thing in contents)
			// Todo: unify limbs and internal organs
			// There's a chance that the gibber will fail to destroy some evidence.
			if(isorgan(thing) && prob(80))
				qdel(thing)
				continue
			thing.forceMove(get_turf(thing)) // Drop it onto the turf for throwing.
			thing.throw_at(get_edge_target_turf(src,gib_throw_dir),rand(1,3),emagged ? 50 : 10) // Being pelted with bits of meat and bone would hurt.

		update_icon()
