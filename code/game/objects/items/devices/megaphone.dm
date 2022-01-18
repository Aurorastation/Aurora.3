/obj/item/device/megaphone
	name = "megaphone"
	desc = "Pretend to be a director for a brief moment before someone tackles you to make you shut up."
	desc_fluff = "Annoy your colleagues! Scare interns! Impress no one!"
	desc_info = "A device used to project your voice. Loudly."
	icon = 'icons/obj/contained_items/tools/megaphone.dmi'
	icon_state = "megaphone"
	item_state = "megaphone"
	contained_sprite = TRUE
	w_class = ITEMSIZE_SMALL
	flags = CONDUCT

	var/active = FALSE
	var/speech_sound = 'sound/items/megaphone.ogg'

/obj/item/device/megaphone/handle_pickup_drop(var/mob/M, var/picked_up = TRUE)
	..()
	handle_signals(M, !picked_up)

/obj/item/device/megaphone/equipped(mob/user, slot, assisted_equip)
	. = ..()
	if(!(slot in list(slot_r_hand, slot_l_hand)))
		handle_signals(user, TRUE)

/obj/item/device/megaphone/attack_self(mob/user)
	active = !active
	to_chat(user, SPAN_NOTICE("You turn \the [src] [active ? "on" : "off"]."))
	handle_signals(user)

/obj/item/device/megaphone/proc/handle_signals(var/mob/M, var/disable = FALSE)
	if(active && !disable)
		RegisterSignal(M, COMSIG_SAY_MODIFIER, .proc/modify_say)
	else
		UnregisterSignal(M, COMSIG_SAY_MODIFIER)

/obj/item/device/megaphone/proc/modify_say(var/mob/M, var/list/say_modifiers)
	if(say_modifiers[SAY_MOD_FONT_SIZE] < FONT_SIZE_LARGE)
		say_modifiers[SAY_MOD_FONT_SIZE] = FONT_SIZE_LARGE
	say_modifiers[SAY_MOD_VERB] = "broadcasts"

	var/turf/T = get_turf(src)
	if(T)
		playsound(T, speech_sound, 100, FALSE, 1)
		for(var/mob/living/carbon/human/H in range(T, 2) - M)
			if(get_dist(T, H) < 1) // within one tile
				H.earpain(3, TRUE, 2)
			else
				H.earpain(2, TRUE, 2)

/obj/item/device/megaphone/red
	name = "red megaphone"
	desc = "To make people do your bidding."
	desc_fluff = "It's in a menacing crimson red."
	icon_state = "megaphone_red"
	item_state = "megaphone_red"

/obj/item/device/megaphone/sec
	name = "security megaphone"
	desc = "To stop people from stepping over the police tape."
	desc_fluff = "Nothing to see here. Move along."
	icon_state = "megaphone_sec"
	item_state = "megaphone_sec"

/obj/item/device/megaphone/med
	name = "medical megaphone"
	desc = "To make people leave the ICU."
	desc_fluff = "Realistcally only used to startle the CMO's cat."
	icon_state = "megaphone_med"
	item_state = "megaphone_med"

/obj/item/device/megaphone/sci
	name = "science megaphone"
	desc = "To make people stand clear of the blast zone."
	desc_fluff = "Something to rival the explosions heard in the science department."
	icon_state = "megaphone_sci"
	item_state = "megaphone_sci"

/obj/item/device/megaphone/engi
	name = "engineering megaphone"
	desc = "To make people get out of construction sites."
	desc_fluff = "At home in construction sites and road works, it'll stick by you in diverting traffic and dim-witted coworkers."
	icon_state = "megaphone_engi"
	item_state = "megaphone_engi"

/obj/item/device/megaphone/cargo
	name = "supply megaphone"
	desc = "To make people to push crates."
	desc_fluff = "Only certified forklift operators will be able to handle the sheer power of this megaphone. Either that, or just be the Quartermaster."
	icon_state = "megaphone_cargo"
	item_state = "megaphone_cargo"

/obj/item/device/megaphone/command
	name = "command megaphone"
	desc = "To make people to get back to work."
	desc_fluff = "Exude authority by decree of having the louder voice."
	icon_state = "megaphone_command"
	item_state = "megaphone_command"

/obj/item/device/megaphone/clown
	name = "clown's megaphone"
	desc = "Something that should not exist."
	icon_state = "megaphone_clown"
	item_state = "megaphone_clown"

/obj/item/device/megaphone/stagemicrophone
	name = "dazzling stage microphone"
	desc = "A glamorous looking stage microphone, complete with running lights and holographic effects around it."
	icon_state = "stagemicrophone"
	item_state = "stagemicrophone"
