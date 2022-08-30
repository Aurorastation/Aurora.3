/obj
	animate_movement = 2

	var/list/matter //Used to store information about the contents of the object.
	var/recyclable = FALSE //Whether the object can be recycled (eaten) by something like the Autolathe
	var/w_class // Size of the object.
	var/list/origin_tech = null	//Used by R&D to determine what research bonuses it grants.
	var/unacidable = 0 //universal "unacidabliness" var, here so you can use it in any obj.

	var/obj_flags //Special flags such as whether or not this object can be rotated.
	var/throwforce = 1
	var/list/attack_verb //Used in attackby() to say how something was attacked "[x] has been [z.attack_verb] by [y] with [z]"
	var/sharp = 0		// whether this object cuts
	var/edge = FALSE	// whether this object is more likely to dismember
	var/in_use = 0 // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
	var/damtype = BRUTE
	var/force = 0
	var/armor_penetration = 0
	var/noslice = 0 // To make it not able to slice things.

	var/being_shocked = 0

	var/icon_species_tag = ""//If set, this holds the 3-letter shortname of a species, used for species-specific worn icons
	var/icon_auto_adapt = 0//If 1, this item will automatically change its species tag to match the wearer's species.
	//requires that the wearer's species is listed in icon_supported_species_tags
	var/list/icon_supported_species_tags //Used with icon_auto_adapt, a list of species which have differing appearances for this item
	var/icon_species_in_hand = 0//If 1, we will use the species tag even for rendering this item in the left/right hand.

	var/equip_slot = 0
	var/usesound
	var/toolspeed = 1

	// Climbing Variables
	var/climbable = FALSE
	var/climb_time = 5 SECONDS
	var/shakable = FALSE
	var/list/climbers = list()

/obj/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/Topic(href, href_list, var/datum/topic_state/state = default_state)
	if(..())
		return 1

	// In the far future no checks are made in an overriding Topic() beyond if(..()) return
	// Instead any such checks are made in CanUseTopic()
	if(CanUseTopic(usr, state, href_list) == STATUS_INTERACTIVE)
		CouldUseTopic(usr)
		return 0

	CouldNotUseTopic(usr)
	return 1

/obj/CanUseTopic(var/mob/user, var/datum/topic_state/state)
	if(user.CanUseObjTopic(src))
		return ..()
	to_chat(user, SPAN_DANGER("[icon2html(src, user)]Access Denied!"))
	return STATUS_CLOSE

/mob/living/silicon/CanUseObjTopic(var/obj/O)
	var/id = src.GetIdCard()
	return O.check_access(id)

/mob/proc/CanUseObjTopic()
	return 1

/obj/proc/CouldUseTopic(var/mob/user)
	user.AddTopicPrint(src)

/mob/proc/AddTopicPrint(var/obj/target)
	target.add_hiddenprint(src)

/mob/living/AddTopicPrint(var/obj/target)
	if(Adjacent(target))
		target.add_fingerprint(src)
	else
		target.add_hiddenprint(src)

/mob/living/silicon/ai/AddTopicPrint(var/obj/target)
	target.add_hiddenprint(src)

/obj/proc/CouldNotUseTopic(var/mob/user)
	// Nada

/obj/proc/ai_can_interact(var/mob/user)
	if(!Adjacent(user) && within_jamming_range(src, FALSE)) // if not adjacent to it, it uses wireless signal
		to_chat(user, SPAN_WARNING("Something in the area of \the [src] is blocking the remote signal!"))
		return FALSE
	return TRUE

/obj/item/proc/is_used_on(obj/O, mob/user)

/obj/assume_air(datum/gas_mixture/giver)
	if(loc)
		return loc.assume_air(giver)
	else
		return null

/obj/remove_air(amount)
	if(loc)
		return loc.remove_air(amount)
	else
		return null

/obj/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if((M.client && M.machine == src))
				is_in_use = 1
				src.attack_hand(M)
		if(istype(usr, /mob/living/silicon/ai) || istype(usr, /mob/living/silicon/robot))
			if(!(usr in nearby))
				if(usr.client && usr.machine==src) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
					is_in_use = 1
					src.attack_ai(usr)
		in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if((M.client && M.machine == src))
				is_in_use = 1
				src.interact(M)
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0

/obj/attack_ghost(mob/user)
	ui_interact(user)
	..()

/obj/proc/interact(mob/user)
	return

/mob/proc/unset_machine()
	src.machine = null

/mob/proc/set_machine(var/obj/O)
	if(src.machine)
		unset_machine()
	src.machine = O
	if(istype(O))
		O.in_use = 1

/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)

/obj/proc/hide(var/hide)
	invisibility = hide ? INVISIBILITY_MAXIMUM : initial(invisibility)
	level = hide ? 1 : initial(level)

/obj/proc/hides_under_flooring()
	return level == 1

/obj/proc/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	if(talking_atom)
		talking_atom.catchMessage(text, M)

/obj/proc/see_emote(mob/M as mob, text, var/emote_type)
	return

/obj/proc/tesla_act(var/power, var/melt = FALSE)
	if(melt)
		visible_message(SPAN_DANGER("\The [src] melts down until ashes are left!"))
		new /obj/effect/decal/cleanable/ash(loc)
		qdel(src)
		return
	being_shocked = 1
	var/power_bounced = power / 2
	tesla_zap(src, 3, power_bounced)
	addtimer(CALLBACK(src, .proc/reset_shocked), 10)

/obj/proc/reset_shocked()
	being_shocked = 0


/obj/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	return

//To be called from things that spill objects on the floor.
//Makes an object move around randomly for a couple of tiles
/obj/proc/tumble(var/dist)
	if(dist >= 1)
		spawn()
			dist += rand(0,1)
			for(var/i = 1, i <= dist, i++)
				if(src)
					step(src, pick(NORTH,SOUTH,EAST,WEST))
					sleep(rand(2,4))


/obj/proc/auto_adapt_species(var/mob/living/carbon/human/wearer)
	if(icon_auto_adapt)
		icon_species_tag = ""
		if(loc == wearer && icon_supported_species_tags.len)
			if(wearer.species.short_name in icon_supported_species_tags)
				icon_species_tag = wearer.species.short_name
				return 1
	return 0


//This function should be called on an item when it is:
//Built, autolathed, protolathed, crafted or constructed. At runtime, by players or machines

//It should NOT be called on things that:
//spawn at roundstart, are adminspawned, arrive on shuttles, spawned from vendors, removed from fridges and containers, etc
//This is useful for setting special behaviour for built items that shouldn't apply to those spawned at roundstart
/obj/proc/Created()
	return

/obj/proc/rotate(var/mob/user, var/anchored_ignore = FALSE)
	if(use_check_and_message(user))
		return

	if(anchored && !anchored_ignore)
		to_chat(user, SPAN_WARNING("\The [src] is bolted down to the floor!"))
		return

	set_dir(turn(dir, 90))
	update_icon()
	return TRUE

/obj/AltClick(var/mob/user)
	if(obj_flags & OBJ_FLAG_ROTATABLE)
		rotate(user)
		return
	if(obj_flags & OBJ_FLAG_ROTATABLE_ANCHORED)
		rotate(user, TRUE)
		return
	..()

/obj/examine(mob/user)
	. = ..()
	if((obj_flags & OBJ_FLAG_ROTATABLE) || (obj_flags & OBJ_FLAG_ROTATABLE_ANCHORED))
		to_chat(user, SPAN_SUBTLE("Can be rotated with alt-click."))
	if(contaminated)
		to_chat(user, SPAN_ALIEN("\The [src] has been contaminated with phoron!"))

// whether mobs can unequip and drop items into us or not
/obj/proc/can_hold_dropped_items()
	return TRUE

/obj/proc/damage_flags()
	. = 0
	if(has_edge(src))
		. |= DAM_EDGE
	if(is_sharp(src))
		. |= DAM_SHARP
		if(damtype == BURN)
			. |= DAM_LASER

//
// Climbing Code
//

/obj/attack_hand(mob/user)
	if(shakable)
		if(LAZYLEN(climbers) && !(user in climbers))
			user.visible_message(
				SPAN_DANGER("\The [user] shakes \the [src]."),
				SPAN_NOTICE("You shake \the [src].")
			)
		shake_object()

/obj/Initialize()
	..()
	if(climbable)
		verbs += /obj/proc/climb_onto_object

/obj/proc/climb_onto_object()
	set name = "Climb Onto"
	set desc = "Climbs onto something"
	set category = "Object"
	set src in oview(1)

	if(can_climb(usr))
		do_climb(usr)

/obj/handle_middle_mouse_click(mob/user)
	if(can_climb(user))
		do_climb(usr)
		return TRUE
	return FALSE

/obj/MouseDrop_T(mob/target, mob/user)
	var/mob/living/H = user
	if(istype(H) && can_climb(H) && target == user)
		do_climb(target)

/obj/proc/can_climb(var/mob/living/user, post_climb_check = 0)
	if(!climbable || !can_touch(user) || (!post_climb_check && (user in climbers)))
		return FALSE

	if(!user.Adjacent(src))
		to_chat(user, SPAN_DANGER("You can't climb there, the way is blocked."))
		return FALSE

	var/obj/occupied = turf_is_crowded()
	if(occupied)
		to_chat(user, SPAN_DANGER("There's \a [occupied] in the way."))
		return FALSE
	return TRUE

/obj/proc/turf_is_crowded(var/exclude_self = FALSE)
	var/turf/T = get_turf(src)
	if(!T || !istype(T))
		return FALSE
	for(var/obj/O in T.contents)
		if(istype(O, /obj))
			var/obj/S = O
			if(S.climbable)
				continue
		if(O && O.density && !(O.flags & ON_BORDER)) //ON_BORDER is handled by the Adjacent() check.
			if(exclude_self && O == src)
				continue
			return O
	return FALSE

/obj/proc/do_climb(var/mob/living/user)
	if(!can_climb(user))
		return

	user.visible_message(SPAN_WARNING("[user] starts [flags & ON_BORDER ? "leaping over" : "climbing onto"] \the [src]!"))
	LAZYADD(climbers, user)

	if(!do_after(user, climb_time))
		LAZYREMOVE(climbers, user)
		return

	if(!can_climb(user, post_climb_check=1))
		LAZYREMOVE(climbers, user)
		return
		
	var/turf/TT = get_turf(src)
	if(flags & ON_BORDER)
		TT = get_step(get_turf(src), dir)
		if(user.loc == TT)
			TT = get_turf(src)

	user.visible_message(SPAN_WARNING("[user] [flags & ON_BORDER ? "leaps over" : "climbs onto"] \the [src]!"))
	user.forceMove(TT)
	LAZYREMOVE(climbers, user)

/obj/proc/shake_object()
	for(var/mob/living/M in climbers)
		M.Weaken(1)
		to_chat(M, SPAN_DANGER("You topple as you are shaken off \the [src]!"))
		LAZYREMOVE(climbers, M)

	for(var/mob/living/M in get_turf(src))
		if(M.lying)
			return // No spamming this on people.

		M.Weaken(3)

		to_chat(M, SPAN_DANGER("You topple as \the [src] moves under you!"))

		if(prob(25))
			var/damage = rand(15, 30)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				to_chat(H, SPAN_DANGER("You land heavily!"))
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
				to_chat(M, SPAN_DANGER("You land heavily on your [affecting.name]!"))
				affecting.take_damage(damage, 0)
				if(affecting.parent)
					affecting.parent.add_autopsy_data("Misadventure", damage)
			else
				to_chat(H, SPAN_DANGER("You land heavily!"))
				H.adjustBruteLoss(damage)

			H.UpdateDamageIcon()
			H.updatehealth()
	return

/obj/proc/can_touch(var/mob/user)
	if(!user)
		return FALSE
	if(!Adjacent(user))
		return FALSE
	if(user.restrained() || user.buckled_to)
		to_chat(user, SPAN_NOTICE("You need your hands and legs free for this."))
		return FALSE
	if(user.stat || user.paralysis || user.sleeping || user.lying || user.weakened)
		return FALSE
	if(issilicon(user))
		to_chat(user, SPAN_NOTICE("You need hands for this."))
		return FALSE
	return TRUE