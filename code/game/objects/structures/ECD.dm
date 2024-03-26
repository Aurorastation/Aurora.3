#define ECD_LOOSE 0
#define ECD_BOLTED 1
#define ECD_WELDED 2

/obj/structure/ecd
	name = "Electronic Countermeasures Device"
	desc = "A large, heavy duty device in the shape of a cylinder. There's something about this piece of tech that feels rather alien. Inside, something hums softly."
	icon = 'icons/obj/structure/ECD.dmi'
	icon_state = "ECD"
	anchored = TRUE
	density = TRUE
	var/state = ECD_WELDED
	slowdown = 10
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/ecd/examine(mob/living/user, distance)
	. = ..()
	switch(state)
		if(ECD_LOOSE)
			to_chat(user, SPAN_NOTICE("\The [src] isn't attached to anything."))
		if(ECD_BOLTED)
			to_chat(user, SPAN_NOTICE("\The [src] is bolted to the floor."))
		if(ECD_WELDED)
			to_chat(user, SPAN_NOTICE("\The [src] is bolted and welded to the floor."))
	if(user.isSynthetic())
		to_chat(user, SPAN_NOTICE("\The [src] does not seem to be doing anything, but you can feel it. A signal, beyond anything you can consciously understand, weaving and scratching a shield around the back of your mind."))

/obj/structure/ecd/attackby(obj/item/W, mob/user)
	if(W.iswrench())
		switch(state)
			if(ECD_LOOSE)
				state = ECD_BOLTED
				W.play_tool_sound(get_turf(src), 75)
				user.visible_message(SPAN_NOTICE("\The [user] secures \the [src] to the floor."), \
					SPAN_NOTICE("You secure \the [src]'s external reinforcing bolts to the floor."), \
					SPAN_WARNING("You hear a ratcheting noise."))
				anchored = TRUE
			if(ECD_BOLTED)
				state = ECD_LOOSE
				W.play_tool_sound(get_turf(src), 75)
				user.visible_message(SPAN_NOTICE("\The [user] unsecures \the [src]'s reinforcing bolts from the floor."), \
					SPAN_NOTICE("You undo \the [src]'s external reinforcing bolts."), \
					SPAN_WARNING("You hear a ratcheting noise."))
				anchored = FALSE
			if(ECD_WELDED)
				to_chat(user, SPAN_WARNING("\The [src] needs to be unwelded from the floor."))
		return

	if(W.iswelder())
		var/obj/item/weldingtool/WT = W
		switch(state)
			if(ECD_LOOSE)
				to_chat(user, SPAN_WARNING("\The [src] needs to be wrenched to the floor."))
			if(ECD_BOLTED)
				if(WT.use(0, user))
					playsound(get_turf(src), 'sound/items/welder_pry.ogg', 50, TRUE)
					user.visible_message(SPAN_NOTICE("\The [user] starts to weld \the [src] to the floor."), \
						SPAN_NOTICE("You start to weld \the [src] to the floor."), \
						SPAN_WARNING("You hear the sound of metal being welded."))
					if(W.use_tool(src, user, 20, volume = 50))
						if(!src || !WT.isOn())
							return
						state = ECD_WELDED
						to_chat(user, SPAN_NOTICE("You weld \the [src] to the floor."))
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			if(ECD_WELDED)
				if(WT.use(0, user))
					playsound(get_turf(src), 'sound/items/welder_pry.ogg', 50, TRUE)
					user.visible_message(SPAN_NOTICE("\The [user] starts to cut \the [src] free from the floor."), \
						SPAN_NOTICE("You start to cut \the [src] free from the floor."), \
						SPAN_WARNING("You hear the sound of metal being welded."))
					if(W.use_tool(src, user, 20, volume = 50))
						if(!src || !WT.isOn())
							return
						state = ECD_BOLTED
						to_chat(user, SPAN_NOTICE("You cut \the [src] free from the floor."))
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
		return

#undef ECD_LOOSE
#undef ECD_BOLTED
#undef ECD_WELDED
