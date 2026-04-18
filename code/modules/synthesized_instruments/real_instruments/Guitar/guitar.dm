/obj/item/synthesized_instrument/guitar
	name = "guitar"
	desc = "A wooden musical instrument with six strings. This one looks like it may actually work."
	icon = 'icons/obj/musician.dmi'
	icon_state = "guitar"
	item_state = "guitar"
	contained_sprite = TRUE
	slot_flags = SLOT_BACK
	sound_player = /datum/sound_player/synthesizer
	path = /datum/instrument/guitar/clean_crisis


/obj/item/synthesized_instrument/guitar/multi
	name = "Polyguitar"
	desc = "An instrument for a more ass-kicking era."
	icon = 'icons/obj/musician.dmi'
	icon_state = "eguitar"
	item_state = "eguitar"
	contained_sprite = TRUE
	slot_flags = SLOT_BACK
	sound_player = /datum/sound_player/synthesizer
	path = /datum/instrument/guitar

/obj/item/synthesized_instrument/guitar/prrama
	name = "p'rrama"
	desc = "A traditional Adhomian string instrument, played with the hands and tail."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "prrama"
	item_state = "prrama"
	contained_sprite = TRUE

/obj/item/synthesized_instrument/guitar/prrama/interact(mob/user)
	if(!istajara(user))
		balloon_alert(user, "not a tajara!")
		return
	. = ..()
