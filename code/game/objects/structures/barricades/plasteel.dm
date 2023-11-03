/obj/structure/barricade/plasteel
	name = "plasteel barricade"
	desc = "A very sturdy barricade made out of plasteel panels, the pinnacle of strongpoints. Use a blowtorch to repair. Can be flipped down to create a path."
	icon_state = "plasteel_closed_0"
	health = 800
	maxhealth = 800
	force_level_absorption = 20
	stack_type = /obj/item/stack/material/plasteel
	build_amt = 8
	stack_amount = 8
	destroyed_stack_amount = 4
	barricade_hitsound = 'sound/effects/metalhit.ogg'
	barricade_type = "plasteel"
	density = 0
	closed = TRUE
	can_wire = TRUE

	var/build_state = BARRICADE_BSTATE_SECURED //Look at __game.dm for barricade defines
	var/tool_cooldown = 0 //Delay to apply tools to prevent spamming
	var/busy = 0 //Standard busy check
	var/linked = 0
	var/recentlyflipped = FALSE
	var/hasconnectionoverlay = TRUE
	var/linkable = TRUE

/obj/structure/barricade/plasteel/update_icon()
	..()
	if(linked)
		for(var/direction in cardinal)
			for(var/obj/structure/barricade/plasteel/cade in get_step(src, direction))
				if(((dir & (NORTH|SOUTH) && get_dir(src, cade) & (EAST|WEST)) || (dir & (EAST|WEST) && get_dir(src, cade) & (NORTH|SOUTH))) && dir == cade.dir && cade.linked && cade.closed == src.closed && hasconnectionoverlay)
					if(closed)
						overlays += image('icons/obj/barricades.dmi', icon_state = "[src.barricade_type]_closed_connection_[get_dir(src, cade)]")
					else
						overlays += image('icons/obj/barricades.dmi', icon_state = "[src.barricade_type]_connection_[get_dir(src, cade)]")
					continue


/obj/structure/barricade/plasteel/handle_barrier_chance(mob/living/M)
	if(!closed) // Closed = gate down for plasteel for some reason
		return ..()
	else
		return 0

/obj/structure/barricade/plasteel/examine(mob/user)
	. = ..()

	switch(build_state)
		if(BARRICADE_BSTATE_SECURED)
			to_chat(user, SPAN_INFO("The protection panel is still tighly screwed in place."))
		if(BARRICADE_BSTATE_UNSECURED)
			to_chat(user, SPAN_INFO("The protection panel has been removed, you can see the anchor bolts."))
		if(BARRICADE_BSTATE_MOVABLE)
			to_chat(user, SPAN_INFO("The protection panel has been removed and the anchor bolts loosened. It's ready to be taken apart."))

/obj/structure/barricade/plasteel/weld_cade(obj/item/W, mob/user)
	busy = TRUE
	..()
	busy = FALSE

/obj/structure/barricade/plasteel/attackby(obj/item/W, mob/user)
	if(W.iswelder())
		if(busy || tool_cooldown > world.time)
			return
		tool_cooldown = world.time + 10
		var/obj/item/weldingtool/WT = W
		if(damage_state == BARRICADE_DMG_HEAVY)
			to_chat(user, SPAN_WARNING("[src] has sustained too much structural damage to be repaired."))
			return

		if(health == maxhealth)
			to_chat(user, SPAN_WARNING("[src] doesn't need repairs."))
			return

		weld_cade(WT, user)
		return

	switch(build_state)
		if(2) //Fully constructed step. Use screwdriver to remove the protection panels to reveal the bolts
			if(W.isscrewdriver())
				if(busy || tool_cooldown > world.time)
					return
				tool_cooldown = world.time + 10
				for(var/obj/structure/barricade/B in loc)
					if(B != src && B.dir == dir)
						to_chat(user, SPAN_WARNING("There's already a barricade here."))
						return
				if(!W.use_tool(src, user, 10, volume = 50))
					return
				user.visible_message(SPAN_NOTICE("[user] removes [src]'s protection panel."),
				SPAN_NOTICE("You remove [src]'s protection panels, exposing the anchor bolts."))
				build_state = BARRICADE_BSTATE_UNSECURED
				return
			if(W.iscrowbar())
				playsound(src.loc, 'sound/items/crowbar_pry.ogg', 25, 1)
				if(linked)
					user.visible_message(SPAN_NOTICE("[user] removes the linking on [src]."),
					SPAN_NOTICE("You remove the linking on [src]."))
				else if(linkable)
					user.visible_message(SPAN_NOTICE("[user] sets up [src] for linking."),
					SPAN_NOTICE("You set up [src] for linking."))
				else
					to_chat(user, SPAN_WARNING("The [src] has no linking points."))
					return
				linked = !linked
				for(var/direction in cardinal)
					for(var/obj/structure/barricade/plasteel/cade in get_step(src, direction))
						cade.update_icon()
				update_icon()
		if(1) //Protection panel removed step. Screwdriver to put the panel back, wrench to unsecure the anchor bolts
			if(W.isscrewdriver())
				if(busy || tool_cooldown > world.time)
					return
				tool_cooldown = world.time + 10
				if(!W.use_tool(src, user, 10, volume = 50))
					return
				user.visible_message(SPAN_NOTICE("[user] set [src]'s protection panel back."),
				SPAN_NOTICE("You set [src]'s protection panel back."))
				build_state = BARRICADE_BSTATE_SECURED
				return
			if(W.iswrench())
				if(busy || tool_cooldown > world.time)
					return
				if(!W.use_tool(src, user, 10, volume = 50))
					return
				user.visible_message(SPAN_NOTICE("[user] loosens [src]'s anchor bolts."),
				SPAN_NOTICE("You loosen [src]'s anchor bolts."))
				anchored = FALSE
				build_state = BARRICADE_BSTATE_MOVABLE
				update_icon() //unanchored changes layer
				return

		if(0) //Anchor bolts loosened step. Apply crowbar to unseat the panel and take apart the whole thing. Apply wrench to rescure anchor bolts
			if(W.iswrench())
				if(busy || tool_cooldown > world.time)
					return
				tool_cooldown = world.time + 10
				var/turf/T = loc
				if(!(istype(T)) || istype(T, /turf/space))
					to_chat(user, SPAN_WARNING("[src] must be secured on a proper surface!"))
					return
				if(!W.use_tool(src, user, 10, volume = 50))
					return
				user.visible_message(SPAN_NOTICE("[user] secures [src]'s anchor bolts."),
				SPAN_NOTICE("You secure [src]'s anchor bolts."))
				anchored = TRUE
				build_state = BARRICADE_BSTATE_UNSECURED
				update_icon() //unanchored changes layer
				return
			if(W.iscrowbar())
				if(busy || tool_cooldown > world.time)
					return
				tool_cooldown = world.time + 10
				user.visible_message(SPAN_NOTICE("[user] starts unseating [src]'s panels."),
				SPAN_NOTICE("You start unseating [src]'s panels."))
				playsound(src.loc, 'sound/items/crowbar_pry.ogg', 25, 1)
				busy = 1
				if(W.use_tool(src, user, 8 SECONDS, volume = 50))
					busy = 0
					user.visible_message(SPAN_NOTICE("[user] takes [src]'s panels apart."),
					SPAN_NOTICE("You take [src]'s panels apart."))
					playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
					barricade_deconstruct(TRUE) //Note : Handles deconstruction too !
				else
					busy = 0
				return

	. = ..()

/obj/structure/barricade/plasteel/attack_hand(mob/user as mob)
	if(closed)
		if(recentlyflipped)
			to_chat(user, SPAN_NOTICE("\The [src] has been flipped too recently!"))
			return
		user.visible_message(SPAN_NOTICE("[user] flips [src] open."),
		SPAN_NOTICE("You flip [src] open."))
		open(src)
		recentlyflipped = TRUE
		addtimer(CALLBACK(src, PROC_REF(remove_cooldown)), 1 SECOND)

	else
		if(recentlyflipped)
			to_chat(user, SPAN_NOTICE("\The [src] has been flipped too recently!"))
			return
		user.visible_message(SPAN_NOTICE("[user] flips [src] closed."),
		SPAN_NOTICE("You flip [src] closed."))
		close(src)
		recentlyflipped = TRUE
		addtimer(CALLBACK(src, PROC_REF(remove_cooldown)), 1 SECOND)

/obj/structure/barricade/plasteel/proc/remove_cooldown()
	recentlyflipped = !recentlyflipped

/obj/structure/barricade/plasteel/proc/open(var/obj/structure/barricade/plasteel/origin)
	if(!closed)
		return
	playsound(src.loc, 'sound/items/wrench.ogg', 25, 1)
	closed = 0
	density = 1
	if(linked)
		for(var/direction in cardinal)
			for(var/obj/structure/barricade/plasteel/cade in get_step(src, direction))
				if(((dir & (NORTH|SOUTH) && get_dir(src, cade) & (EAST|WEST)) || (dir & (EAST|WEST) && get_dir(src, cade) & (NORTH|SOUTH))) && dir == cade.dir && cade != origin && cade.linked)
					cade.open(src)
	update_icon()

/obj/structure/barricade/plasteel/proc/close(var/obj/structure/barricade/plasteel/origin)
	if(closed)
		return
	playsound(src.loc, 'sound/items/wrench.ogg', 25, 1)
	closed = 1
	density = 0
	if(linked)
		for(var/direction in cardinal)
			for(var/obj/structure/barricade/plasteel/cade in get_step(src, direction))
				if(((dir & (NORTH|SOUTH) && get_dir(src, cade) & (EAST|WEST)) || (dir & (EAST|WEST) && get_dir(src, cade) & (NORTH|SOUTH))) && dir == cade.dir && cade != origin && cade.linked)
					cade.close(src)
	update_icon()


/obj/structure/barricade/plasteel/wired/New()
	can_wire = FALSE
	is_wired = TRUE
	climbable = FALSE
	update_icon()
	. = ..()
