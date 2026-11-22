//I would have rewritten this whole thing, but it requires to change half a million systems for it to be proper, therefore
//i declare this shit legacy code, to be slowly phased out as things get updated
/mob/living/carbon/human/movement_delay()

	var/tally = 0
	if(species.slowdown)
		tally = species.slowdown

	if(lying) //Crawling, it's slower
		tally += (8 + ((weakened * 3) + (confused * 2)))

	if (!(species.flags & NO_EQUIP_SPEEDMODS))
		tally += get_pulling_movement_delay()

	if (istype(loc, /turf/space) || isopenturf(loc))
		if(!(locate(/obj/structure/lattice, loc) || locate(/obj/structure/stairs, loc) || locate(/obj/structure/ladder, loc)))
			return 0

	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.

	var/health_deficiency = maxhealth - health
	if(health_deficiency >= 40)
		tally += (health_deficiency / 25)

	var/shock = get_shock()
	if(shock >= 10)
		tally += (shock / 30) //get_shock checks if we can feel pain

	if(species)
		tally += species.get_species_tally(src)

	tally += species.handle_movement_tally(src)

	if(is_asystole())
		tally += 10  //heart attacks are kinda distracting

	if(aiming?.aiming_at)
		tally += 5 // Iron sights make you slower, it's a well-known fact.

	if (is_drowsy())
		tally += 6

	if (!(species.flags & NO_COLD_SLOWDOWN))	// Bugs and machines don't move slower when cold.
		if((mutations & FAT))
			tally += 1.5
		if (bodytemperature < species.cold_discomfort_level)
			tally += (species.cold_discomfort_level - bodytemperature) / 10 * 1.75

	tally += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow
	if((mutations & mRun))
		tally = 0

	if(pulling)
		tally += get_load_movement_delay(pulling)

	var/obj/item/grab/grab = get_type_in_hands(/obj/item/grab)
	if(istype(grab) && ismovable(grab.affecting))
		tally += get_load_movement_delay(grab.affecting)

	var/turf/T = get_turf(src)
	if(T) // changelings don't get movement costs
		var/datum/changeling/changeling
		if(mind)
			changeling = mind.antag_datums[MODE_CHANGELING]
		if(!changeling)
			tally += T.movement_cost
		if(species && istype(T, /turf/simulated/floor/exoplanet/water))
			if(species.can_breathe_water())
				tally -= T.movement_cost

	if(HAS_TRAIT(src, TRAIT_SHOE_GRIP))
		tally += 1
	var/movement_tally_modifier = 0
	SEND_SIGNAL(src, COMSIG_GET_MOVEMENT_TALLY, &movement_tally_modifier)
	tally += movement_tally_modifier

	tally += GLOB.config.human_delay

	if(!isnull(facing_dir) && facing_dir != dir)
		tally += 3


	return tally


/mob/living/carbon/human/Allow_Spacemove(var/check_drift = 0)
	//Can we act?
	if(restrained())	return 0

	//Do we have a working jetpack?
	var/obj/item/tank/jetpack/thrust = GetJetpack(src)

	if(thrust)
		if(((!check_drift) || (check_drift && thrust.stabilization_on)) && (!lying) && (thrust.allow_thrust(0.01, src)))
			inertia_dir = 0
			return 1

	//If no working jetpack then use the other checks
	. = ..()


/mob/living/carbon/human/slip_chance(var/prob_slip = 5)
	if(!..())
		return 0
	if(SEND_SIGNAL(src, COMSIG_GET_SLIP_MODIFIERS) & COMPONENT_PREVENT_SLIP)
		return 0

	//Check hands and mod slip
	if(!l_hand)	prob_slip -= 2
	else if(l_hand.w_class <= 2)	prob_slip -= 1
	if (!r_hand)	prob_slip -= 2
	else if(r_hand.w_class <= 2)	prob_slip -= 1

	return prob_slip

/mob/living/carbon/human/Check_Shoegrip(checkSpecies = TRUE)
	//magboots + dense_object = no floating. Doesn't work if lying. Grabbedby and buckled_to are for mob carrying, wheelchairs, roller beds, etc.
	if(shoes && (shoes.item_flags & ITEM_FLAG_NO_SLIP) && istype(shoes, /obj/item/clothing/shoes/magboots) && !lying && !buckled_to && !length(grabbed_by))
		return TRUE
	if(HAS_TRAIT(src, TRAIT_SHOE_GRIP))
		return TRUE
	if(SEND_SIGNAL(src, COMSIG_CHECK_SHOE_GRIP) & COMPONENT_HAS_SHOE_GRIP)
		return TRUE
	return FALSE

/mob/living/carbon/human/set_dir(var/new_dir, ignore_facing_dir = FALSE)
	. = ..()
	if(. && tail_style)
		update_tail_showing(!lying)

/mob/living/carbon/human/Move(atom/newloc, direct)
	// A prone mob already sharing a table's turf without this state is on top of
	// it, and must crawl off before it can deliberately crawl underneath one.
	var/started_move_crawling = lying && client?.moving && (crawling_under_table || !(locate(/obj/structure/table) in get_turf(src)))
	var/obj/structure/table/old_table = crawling_under_table ? get_crawlable_table() : null
	var/obj/structure/table/new_table = started_move_crawling ? get_crawlable_table(newloc) : null
	if(started_move_crawling && new_table && mob_size >= TABLE_CRAWL_MAX_MOB_SIZE)
		to_chat(src, SPAN_WARNING("You are too large to fit underneath \the [new_table]."))
		return FALSE

	if(started_move_crawling && (old_table || new_table))
		if(!old_table && new_table)
			visible_message(
				SPAN_NOTICE("[src] starts crawling underneath \the [new_table]."),
				SPAN_NOTICE("You start crawling underneath \the [new_table].")
			)
		else if(old_table && !new_table)
			visible_message(
				SPAN_NOTICE("[src] starts crawling out from underneath \the [old_table]."),
				SPAN_NOTICE("You start crawling out from underneath \the [old_table].")
			)
		var/obj/structure/table/delay_target = new_table || old_table
		if(!do_after(src, 0.5 SECOND, delay_target, DO_DEFAULT | DO_USER_UNIQUE_ACT, INCAPACITATION_DEFAULT & ~INCAPACITATION_FORCELYING))
			return FALSE
		new_table = get_crawlable_table(newloc)
		if(new_table && mob_size >= TABLE_CRAWL_MAX_MOB_SIZE)
			to_chat(src, SPAN_WARNING("You are too large to fit underneath \the [new_table]."))
			return FALSE
		if(!old_table && !new_table)
			return FALSE

	attempting_table_crawl = started_move_crawling

	// Treat prone movement as low enough to pass beneath tables and other
	// structures which explicitly allow PASSTABLE movers beneath them.
	var/crawling_under_tables = lying && mob_size < TABLE_CRAWL_MAX_MOB_SIZE && !(pass_flags & PASSTABLE)
	if(crawling_under_tables)
		pass_flags |= PASSTABLE

	. = ..()

	if(crawling_under_tables)
		pass_flags &= ~PASSTABLE
	attempting_table_crawl = FALSE

	if(. && started_move_crawling && get_crawlable_table())
		start_crawling_under_table()
	if(. && started_move_crawling)
		var/obj/structure/table/rustled_table = get_crawlable_table() || old_table
		if(!QDELETED(rustled_table))
			rustled_table.rustle_from_crawler()

	if(.) //We moved
		handle_leg_damage()

	var/turf/T = get_turf(loc)


	if (client && T)
		var/turf/T1 = GET_TURF_ABOVE(T)
		if(up_hint)
			up_hint.icon_state = "uphint[(T1 ? !!isopenturf(T1) : 0)]"

	if (!stat && !lying)
		if ((x == last_x && y == last_y) || !footsound)
			return
		last_x = x
		last_y = y

/mob/living/carbon/human/Moved(atom/old_loc, movement_dir, forced, list/old_locs)
	. = ..()
	if(crawling_under_table && ((forced && old_loc != loc) || !get_crawlable_table()))
		stop_crawling_under_table()

/mob/living/carbon/human/forceMove(atom/destination)
	if(crawling_under_table && destination != loc)
		stop_crawling_under_table()
	return ..()

/mob/living/carbon/human/lay_down()
	if(crawling_under_table && get_crawlable_table())
		to_chat(src, SPAN_WARNING("You cannot stand up while underneath a table!"))
		return
	return ..()

/mob/living/carbon/human/proc/get_crawlable_table(atom/location = src)
	for(var/obj/structure/table/table in get_turf(location))
		if(table.can_crawl_under())
			return table
	return null

/mob/living/carbon/human/proc/start_crawling_under_table()
	if(crawling_under_table || mob_size >= TABLE_CRAWL_MAX_MOB_SIZE)
		return
	crawling_under_table = TRUE
	table_crawl_old_layer = layer
	layer = HIDING_MOB_LAYER

/mob/living/carbon/human/proc/stop_crawling_under_table()
	if(!crawling_under_table)
		return
	crawling_under_table = FALSE
	layer = table_crawl_old_layer
	table_crawl_old_layer = MOB_LAYER

/mob/living/carbon/human/verb/search_nearby()
	set name = "Search Nearby"
	set desc = "Search nearby hiding places for concealed characters."
	set category = "IC.Maneuver"

	if(stat || incapacitated(INCAPACITATION_DISABLED) || lying || !isturf(loc))
		to_chat(src, SPAN_WARNING("You are not in a position to search nearby hiding places."))
		return
	if(world.time < next_table_search)
		to_chat(src, SPAN_WARNING("You need a moment before searching again."))
		return

	next_table_search = world.time + 5 SECONDS
	visible_message(
		SPAN_NOTICE("[src] begins carefully searching the nearby area."),
		SPAN_NOTICE("You begin carefully searching the nearby area.")
	)
	if(!do_after(src, 2 SECONDS, do_flags = DO_DEFAULT | DO_USER_UNIQUE_ACT))
		return

	clear_table_search_silhouettes()
	var/static/icon/search_shadow
	if(!search_shadow)
		search_shadow = icon('icons/mob/npc/spider_queen.dmi', "spider_queen_shadow")
		search_shadow.Scale(32, 32)
	for(var/mob/living/carbon/human/hidden in view(5, src))
		if(hidden == src || !hidden.crawling_under_table)
			continue

		var/image/search_spot = image(search_shadow, loc = hidden)

		search_spot.appearance_flags |= KEEP_APART | RESET_TRANSFORM | RESET_COLOR | RESET_ALPHA
		search_spot.dir = SOUTH
		search_spot.layer = ABOVE_TABLE_LAYER
		search_spot.pixel_y = 8
		search_spot.alpha = 190
		search_spot.mouse_opacity = MOUSE_OPACITY_ICON
		LAZYADD(table_search_silhouettes, search_spot)

	if(length(table_search_silhouettes))
		client?.images += table_search_silhouettes
		to_chat(src, SPAN_NOTICE("You spot [length(table_search_silhouettes)] suspicious disturbance\s nearby."))
		addtimer(CALLBACK(src, PROC_REF(clear_table_search_silhouettes)), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	else
		to_chat(src, SPAN_NOTICE("You find nobody concealed nearby."))

/mob/living/carbon/human/proc/clear_table_search_silhouettes()
	if(client && length(table_search_silhouettes))
		client.images -= table_search_silhouettes
	table_search_silhouettes = null


/mob/living/carbon/human/proc/handle_leg_damage()
	if(!can_feel_pain())
		return
	var/crutches = 0
	for (var/obj/item/cane/C as anything in get_type_in_hands(/obj/item/cane))
		if(istype(C) && (C?.can_support))
			crutches++
	for(var/organ_name in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/E = get_organ(organ_name)
		if(E && (ORGAN_IS_DISLOCATED(E)|| E.is_broken()))
			if(crutches)
				crutches--
			else
				E.add_pain(10)

/mob/living/carbon/human/mob_has_gravity()
	. = ..()
	if(!. && mob_negates_gravity())
		. = 1

/mob/living/carbon/human/mob_negates_gravity()
	return (shoes && shoes.negates_gravity())

/mob/living/carbon/human/get_pulling_movement_delay()
	. = ..()

	if(ishuman(pulling))
		var/mob/living/carbon/human/H = pulling
		if(H.species.slowdown > species.slowdown)
			. += H.species.slowdown - species.slowdown
