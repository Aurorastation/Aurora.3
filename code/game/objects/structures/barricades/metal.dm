/obj/structure/barricade/metal
	name = "metal barricade"
	desc = "A sturdy and easily assembled barricade made of metal plates, often used for quick fortifications. Use a blowtorch to repair."
	icon_state = "metal_0"
	build_amt = 4
	health = 450
	maxhealth = 450
	force_level_absorption = 10
	stack_type = /obj/item/stack/material/steel
	stack_amount = 4
	destroyed_stack_amount = 2
	barricade_hitsound = 'sound/effects/metalhit.ogg'
	barricade_type = "metal"
	can_wire = TRUE
	var/build_state = BARRICADE_BSTATE_SECURED //Look at __game.dm for barricade defines

/obj/structure/barricade/metal/examine(mob/user)
	..()
	switch(build_state)
		if(BARRICADE_BSTATE_SECURED)
			to_chat(user, SPAN_INFO("The protection panel is still tighly screwed in place."))
		if(BARRICADE_BSTATE_UNSECURED)
			to_chat(user, SPAN_INFO("The protection panel has been removed, you can see the anchor bolts."))
		if(BARRICADE_BSTATE_MOVABLE)
			to_chat(user, SPAN_INFO("The protection panel has been removed and the anchor bolts loosened. It's ready to be taken apart."))

/obj/structure/barricade/metal/attackby(obj/item/W, mob/user)
	if(W.iswelder())
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
		if(BARRICADE_BSTATE_SECURED) //Fully constructed step. Use screwdriver to remove the protection panels to reveal the bolts
			if(W.isscrewdriver())
				if(!W.use_tool(src, user, 1 SECOND, volume = 40))
					return
				user.visible_message(SPAN_NOTICE("[user] removes [src]'s protection panel."),
				SPAN_NOTICE("You remove [src]'s protection panels, exposing the anchor bolts."))
				build_state = BARRICADE_BSTATE_UNSECURED
				return

		if(BARRICADE_BSTATE_UNSECURED) //Protection panel removed step. Screwdriver to put the panel back, wrench to unsecure the anchor bolts
			if(W.isscrewdriver())
				if(!W.use_tool(src, user, 2 SECONDS, volume = 40))
					return
				user.visible_message(SPAN_NOTICE("[user] screws \the [src]'s protection panel back."),
				SPAN_NOTICE("You screw \the [src]'s protection panel back."))
				build_state = BARRICADE_BSTATE_SECURED
				return
			if(W.iswrench())
				if(!W.use_tool(src, user, 1 SECOND, volume = 40))
					return
				user.visible_message(SPAN_NOTICE("[user] loosens [src]'s anchor bolts."),
				SPAN_NOTICE("You loosen [src]'s anchor bolts."))
				anchored = FALSE
				build_state = BARRICADE_BSTATE_MOVABLE
				update_icon() //unanchored changes layer
				return
		if(BARRICADE_BSTATE_MOVABLE) //Anchor bolts loosened step. Apply crowbar to unseat the panel and take apart the whole thing. Apply wrench to resecure anchor bolts
			if(W.iswrench())
				for(var/obj/structure/barricade/B in loc)
					if(B != src && B.dir == dir)
						to_chat(user, SPAN_WARNING("There's already a barricade here."))
						return
				var/turf/T = loc
				if(!(istype(T)) || istype(T, /turf/space))
					to_chat(user, SPAN_WARNING("[src] must be secured on a proper surface!"))
					return
				if(!W.use_tool(src, user, 1 SECOND, volume = 50))
					return
				user.visible_message(SPAN_NOTICE("[user] secures [src]'s anchor bolts."),
				SPAN_NOTICE("You secure [src]'s anchor bolts."))
				build_state = BARRICADE_BSTATE_UNSECURED
				anchored = TRUE
				update_icon() //unanchored changes layer
				return
			if(W.iscrowbar())
				user.visible_message(SPAN_NOTICE("[user] starts unseating [src]'s panels."),
				SPAN_NOTICE("You start unseating [src]'s panels."))
				if(W.use_tool(src, user, 3 SECONDS, volume = 40))
					user.visible_message(SPAN_NOTICE("[user] takes [src]'s panels apart."),
					SPAN_NOTICE("You take [src]'s panels apart."))
					barricade_deconstruct(TRUE) //Note : Handles deconstruction too !
				return

	. = ..()

/obj/structure/barricade/metal/wired/Initialize(mapload, mob/user)
	. = ..()
	maxhealth += 50
	update_health(-50)
	can_wire = FALSE
	is_wired = TRUE
	climbable = FALSE
	update_icon()
