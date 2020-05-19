/obj/item/remote_mecha
	name = "standard exosuit remote upgrade"
	desc = "A device that, when inserted into an exosuit, allows it to be remotely piloted."
	icon = 'icons/obj/modular_components.dmi'
	icon_state = "aislot"
	origin_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 4, TECH_DATA = 4)
	w_class = ITEMSIZE_SMALL
	var/mech_remote_network = "remotemechs"
	var/hardpoint_lock = FALSE // Whether mechs that receive this upgrade gets locked
	var/dummy_path = /mob/living/simple_animal/spiderbot

/obj/item/remote_mecha/examine(mob/user)
	. = ..()
	to_chat(user, FONT_SMALL(SPAN_WARNING("This exosuit upgrade cannot be undone if applied!")))
	if(Adjacent(user))
		var/message = "Applying \the [src] <b>will [hardpoint_lock ? "" : "not"]</b> lock the hardpoints[hardpoint_lock ? ", preventing further modification" : ""]."
		to_chat(user, FONT_SMALL(SPAN_NOTICE(message)))

/obj/item/remote_mecha/penal
	name = "penal exosuit remote upgrade"
	desc = "A device that, when inserted into an exosuit, allows it to be remotely piloted. Intended for prison networks."
	mech_remote_network = "prisonmechs"
	hardpoint_lock = TRUE

/obj/item/remote_mecha/penal/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		to_chat(user, FONT_SMALL(SPAN_NOTICE("Applying \the [src] will additionally add the mech to the security penal network, where they can remotely monitor and shut it down.")))

/obj/item/remote_mecha/ai
	name = "AI exosuit remote upgrade"
	desc = "A device that, when inserted into an exosuit, allows it to be remotely piloted by the artificial intelligence."
	mech_remote_network = "aimechs"
	dummy_path = /mob/living/simple_animal/spiderbot/ai