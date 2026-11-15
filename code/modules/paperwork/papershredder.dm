/obj/structure/machinery/papershredder
	name = "paper shredder"
	desc = "For those documents you don't want seen."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "papershredder0"
	density = 1
	anchored = 1
	maxhealth = OBJECT_HEALTH_LOW
	var/max_paper = 10
	var/paperamount = 0
	/// Whether this initially mapped Horizon shredder's contents persist between rounds.
	var/persistent_contents = TRUE
	/// Original map identity used to persist contents without persisting the shredder itself.
	var/tmp/contents_persistence_id
	var/list/shred_amounts = list(
		/obj/item/photo = -1,
		/obj/item/shreddedp = 1,
		/obj/item/paper = 1,
		/obj/item/newspaper = 3,
		/obj/item/card/id = -1,
		/obj/item/paper_bundle = 3
		)// use -1 if it doesn't generate paper

/singleton/persistent_type/generic/papershredder_contents
	/// Persistent paper shredders present on the Horizon when the round's map finished loading.
	var/list/papershredder_register = list()
	/// Whether initialization completed successfully. Prevents a failed load from overwriting saved contents.
	var/contents_initialized = FALSE

/** Loads saved contents into paper shredders mapped onto the Horizon. */
/singleton/persistent_type/generic/papershredder_contents/initialization_hook()
	papershredder_register = list()
	contents_initialized = FALSE
	if(!SSpersistence.map_supports_persistence)
		return

	var/datum/persistent_generic/saved_generic = SSpersistence.genericLoad(/singleton/persistent_type/generic/papershredder_contents)
	var/list/saved_contents = saved_generic?.content
	for(var/obj/structure/machinery/papershredder/shredder in world)
		CHECK_TICK
		var/turf/shredder_turf = get_turf(shredder)
		if(!shredder_turf || !is_station_level(shredder_turf.z) || !shredder.persistent_contents)
			continue

		papershredder_register += shredder
		shredder.contents_persistence_id = "[shredder_turf.x],[shredder_turf.y],[shredder_turf.z],[shredder.type]"
		var/saved_amount = saved_contents?[shredder.contents_persistence_id]
		if(isnum(saved_amount))
			shredder.paperamount = clamp(saved_amount, 0, shredder.max_paper)
			shredder.update_icon()
	contents_initialized = TRUE

/** Saves contents for the initially mapped paper shredders without considering their current locations. */
/singleton/persistent_type/generic/papershredder_contents/finalization_hook()
	if(!contents_initialized)
		return

	var/list/all_contents = list()
	for(var/obj/structure/machinery/papershredder/shredder as anything in papershredder_register)
		CHECK_TICK
		if(QDELETED(shredder))
			continue
		all_contents[shredder.contents_persistence_id] = shredder.paperamount

	var/obj/item/paper/paper_type = /obj/item/paper
	var/expiration_days = initial(paper_type.persistent_objects_expiration_time_days)
	SSpersistence.genericSave(/singleton/persistent_type/generic/papershredder_contents, all_contents, expires_in_days = expiration_days)

/obj/structure/machinery/papershredder/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(contents_persistence_id)
		var/obj/item/paper/paper_type = /obj/item/paper
		var/persistence_days = initial(paper_type.persistent_objects_expiration_time_days)
		var/persistence_duration = "[persistence_days] day[(persistence_days != 1) ? "s" : ""]"
		var/persistence_label = "<i class='fa-solid [FA_ICON_CALENDAR_DAYS]'></i> [persistence_duration]"
		. += SPAN_TOOLTIP("This is a persistence mechanic. Shredded paper left inside this machine remains available between rounds aboard the SCCV Horizon and expires after [persistence_duration].", persistence_label)

/obj/structure/machinery/papershredder/attackby(obj/item/attacking_item, mob/user)
	if (istype(attacking_item, /obj/item/storage))
		empty_bin(user, attacking_item)
		return

	else if (attacking_item.tool_behaviour == TOOL_WRENCH)
		attacking_item.play_tool_sound(get_turf(src), 50)
		anchored = !anchored
		user.visible_message(
			SPAN_NOTICE("[anchored ? "\The [user] fastens \the [src] to \the [loc]." : "\The unfastens \the [src] from \the [loc]."]"),
			SPAN_NOTICE("[anchored ? "You fasten \the [src] to \the [loc]." : "You unfasten \the [src] from \the [loc]."]"),
			"You hear a ratchet."
		)
		return

	else
		var/paper_result
		for(var/shred_type in shred_amounts)
			if(istype(attacking_item, shred_type))
				paper_result = shred_amounts[shred_type]
		if(paper_result)
			if (!anchored)
				to_chat(user, SPAN_WARNING("\The [src] must be anchored to the ground to operate!"))
				return
			if(paperamount == max_paper)
				to_chat(user, SPAN_WARNING("\The [src] is full; please empty it before you continue."))
				return
			if (paper_result > 0)
				paperamount += paper_result
			if(astype(attacking_item, /obj/item/paper)?.crumpled)
				flick("papershredder_s_on", src)
			else if(attacking_item.icon_state == "paper_words")
				flick("papershredder_w_on", src)
			else if(attacking_item.icon_state == "paper_plane")
				flick("papershredder_p_on", src)
			else
				flick("papershredder_on", src)
			qdel(attacking_item)
			playsound(src.loc, 'sound/items/bureaucracy/papershred.ogg', 75, 1)
			to_chat(user, SPAN_NOTICE("You shred the paper."))
			intent_message(MACHINE_SOUND)
			if(paperamount > max_paper)
				to_chat(user, SPAN_DANGER("\The [src] was too full, and shredded paper goes everywhere!"))
				for(var/i=(paperamount-max_paper);i>0;i--)
					var/obj/item/shreddedp/SP = get_shredded_paper()
					SP.forceMove(get_turf(src))
					SP.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),1,5)
				paperamount = max_paper
			update_icon()
			return
	return ..()

/obj/structure/machinery/papershredder/verb/empty_contents()
	set name = "Empty bin"
	set category = "Object"
	set src in range(1)

	if(usr.stat || usr.restrained() || usr.weakened || usr.paralysis || usr.lying || usr.stunned)
		return

	if(!paperamount)
		to_chat(usr, SPAN_NOTICE("\The [src] is empty."))
		return

	empty_bin(usr)

/obj/structure/machinery/papershredder/proc/empty_bin(var/mob/living/user, var/obj/item/storage/empty_into)

	// Sanity.
	if(empty_into && !istype(empty_into))
		empty_into = null

	if(empty_into && empty_into.contents.len >= empty_into.storage_slots)
		to_chat(user,  SPAN_NOTICE("\The [empty_into] is full."))
		return

	while(paperamount)
		var/obj/item/shreddedp/SP = get_shredded_paper()
		if(!SP) break
		if(empty_into)
			empty_into.handle_item_insertion(SP)
			if(empty_into.contents.len >= empty_into.storage_slots)
				break
	if(empty_into)
		if(paperamount)
			to_chat(user,  SPAN_NOTICE("You fill \the [empty_into] with as much shredded paper as it will carry."))
		else
			to_chat(user,  SPAN_NOTICE("You empty \the [src] into \the [empty_into]."))

	else
		to_chat(user,  SPAN_NOTICE("You empty \the [src]."))
	update_icon()

/obj/structure/machinery/papershredder/proc/get_shredded_paper()
	if(!paperamount)
		return
	paperamount--
	return new /obj/item/shreddedp(get_turf(src))

/obj/structure/machinery/papershredder/update_icon() //makes it show how full the papershredder is while covering up the animation. Seemsgood - Wezzy
	ClearOverlays()
	switch(paperamount)
		if(2 to 3)
			AddOverlays("papershredder1")
		if(4 to 5)
			AddOverlays("papershredder2")
		if(6 to 7)
			AddOverlays("papershredder3")
		if(8 to 9)
			AddOverlays("papershredder4")
		if(10)
			AddOverlays("papershredder5")

/obj/item/shreddedp/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/flame/lighter))
		burnpaper(attacking_item, user)
	else
		..()

/obj/item/shreddedp/proc/burnpaper(obj/item/P, mob/user)
	var/class = "warning"

	if (!user.restrained())
		if (istype(P, /obj/item/flame))
			var/obj/item/flame/F = P
			if (!F.lit)
				return
		else if (P.tool_behaviour == TOOL_WELDER)
			var/obj/item/weldingtool/F = P // NOW THAT'S WHAT I CALL RECYCLING - wezzy
			if (!F.welding)
				return
			if (!F.use(1, user))
				return
		else

			return

		if(istype(P, /obj/item/flame/lighter/zippo))
			class = "rose"

		user.visible_message(span("[class]", "[user] holds \the [P] up to \the [src], trying to burn it!"), \
		span("[class]", "You hold \the [P] up to \the [src], burning it slowly."))
		playsound(src.loc, 'sound/items/bureaucracy/paperburn.ogg', 50, 1)
		flick("shredp_onfire", src)

		if (do_after(user, 2 SECONDS, src, DO_UNIQUE | DO_USER_CAN_MOVE))
			user.visible_message(span("[class]", "[user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap."), \
			span("[class]", "You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap."))
			new /obj/effect/decal/cleanable/ash(src.loc)
			qdel(src)

/obj/item/shreddedp
	name = "shredded paper"
	desc = "The remains of a private, confidential, or otherwise sensitive document."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "shredp"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_range = 3
	throw_speed = 1
