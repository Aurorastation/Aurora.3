/obj/item/device/megaphone
	name = "megaphone"
	desc = "Pretend to be a director for a brief moment before someone tackles you to make you shut up."
	desc_extended = "Annoy your colleagues! Scare interns! Impress no one!"
	desc_info = "A device used to project your voice. Loudly."
	icon = 'icons/obj/item/tools/megaphone.dmi'
	icon_state = "megaphone"
	item_state = "megaphone"
	contained_sprite = TRUE
	w_class = ITEMSIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTABLE

	/// Whether we amplify the volume of the user's spoken words or not
	var/active = FALSE

	/// The sound the user makes when they speak with us
	var/activation_sound = 'sound/items/megaphone.ogg'

/obj/item/device/megaphone/attack_self(mob/user)
	active = !active
	playsound(loc, 'sound/items/penclick.ogg', 70, TRUE)
	to_chat(user, SPAN_WARNING("You flick \the [src] [active ? "on" : "off"]!"))

/obj/item/device/megaphone/equipped(mob/user, slot, initial)
	. = ..()

	if(slot == slot_l_hand || slot == slot_r_hand)
		RegisterSignal(user, COMSIG_LIVING_SAY, PROC_REF(get_say_modifiers), TRUE)
	else
		UnregisterSignal(user, COMSIG_LIVING_SAY)

/obj/item/device/megaphone/dropped(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_LIVING_SAY)

/obj/item/device/megaphone/proc/get_say_modifiers(var/mob/speaker, var/list/variables)
	SIGNAL_HANDLER

	if(!active)
		return

	variables["font_size"] = FONT_SIZE_LARGE
	variables["speech_sound"] = activation_sound
	variables["sound_vol"] = 80

/obj/item/device/megaphone/red
	name = "red megaphone"
	desc = "To make people do your bidding."
	desc_extended = "It's in a menacing crimson red."
	icon_state = "megaphone_red"
	item_state = "megaphone_red"

/obj/item/device/megaphone/sec
	name = "security megaphone"
	desc = "To stop people from stepping over the police tape."
	desc_extended = "Nothing to see here. Move along."
	icon_state = "megaphone_sec"
	item_state = "megaphone_sec"

/obj/item/device/megaphone/med
	name = "medical megaphone"
	desc = "To make people leave the ICU."
	desc_extended = "Realistcally only used to startle the CMO's cat."
	icon_state = "megaphone_med"
	item_state = "megaphone_med"

/obj/item/device/megaphone/sci
	name = "science megaphone"
	desc = "To make people stand clear of the blast zone."
	desc_extended = "Something to rival the explosions heard in the science department."
	icon_state = "megaphone_sci"
	item_state = "megaphone_sci"

/obj/item/device/megaphone/engi
	name = "engineering megaphone"
	desc = "To make people get out of construction sites."
	desc_extended = "At home in construction sites and road works, it'll stick by you in diverting traffic and dim-witted coworkers."
	icon_state = "megaphone_engi"
	item_state = "megaphone_engi"

/obj/item/device/megaphone/cargo
	name = "operations megaphone"
	desc = "To make people to push crates."
	desc_extended = "Only certified forklift operators will be able to handle the sheer power of this megaphone. Either that, or just be the Operations Manager."
	icon_state = "megaphone_cargo"
	item_state = "megaphone_cargo"

/obj/item/device/megaphone/command
	name = "command megaphone"
	desc = "To make people to get back to work."
	desc_extended = "Exude authority by decree of having the louder voice."
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
