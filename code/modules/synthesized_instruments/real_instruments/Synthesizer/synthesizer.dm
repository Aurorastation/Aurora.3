//Synthesizer and minimoog. They work the same

/datum/sound_player/synthesizer
	volume = 40

/obj/structure/synthesized_instrument/synthesizer
	name = "The Synthesizer 3.0"
	desc = "A sound synthesizer."
	icon_state = "synthesizer"
	anchored = TRUE
	density = TRUE
	path = /datum/instrument
	sound_player = /datum/sound_player/synthesizer

/obj/structure/synthesized_instrument/synthesizer/attackby(obj/item/O, mob/user, params)
	if (istype(O, /obj/item/wrench))
		if (!anchored && !isinspace())
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(usr, SPAN_NOTICE(" You begin to tighten \the [src] to the floor..."))
			if (do_after(user, 2 SECONDS, src, DO_REPAIR_CONSTRUCT))
				if(!anchored && !isinspace())
					user.visible_message( \
						"[user] tightens \the [src]'s casters.", \
						SPAN_NOTICE(" You tighten \the [src]'s casters. Now it can be played again."), \
						span("italics", "You hear ratchet."))
					src.anchored = TRUE
		else if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(usr, SPAN_NOTICE(" You begin to loosen \the [src]'s casters..."))
			if (do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT))
				if(anchored)
					user.visible_message( \
						"[user] loosens \the [src]'s casters.", \
						SPAN_NOTICE(" You loosen \the [src]. Now it can be pulled somewhere else."), \
						span("italics", "You hear ratchet."))
					src.anchored = FALSE
	else
		..()

/obj/structure/synthesized_instrument/synthesizer/shouldStopPlaying(mob/user)
	return !((src && in_range(src, user) && src.anchored) || src.real_instrument.player.song.autorepeat)


//in-hand version
/obj/item/device/synthesized_instrument/synthesizer
	name = "Synthesizer Mini"
	desc = "The power of an entire orchestra in a handy midi keyboard format."
	icon_state = "h_synthesizer"
	item_state = "h_synthesizer"
	slot_flags = SLOT_BACK
	path = /datum/instrument
	sound_player = /datum/sound_player/synthesizer

/obj/structure/synthesized_instrument/synthesizer/minimoog
	name = "space minimoog"
	desc = "This is a minimoog, like a space piano, but more spacey!"
	icon_state = "minimoog"
	obj_flags = OBJ_FLAG_ROTATABLE
