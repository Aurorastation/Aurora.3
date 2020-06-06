/obj/item/device/pin_extractor
	name = "firing pin extractor"
	desc = "A device that is capable of removing firing pin without damaging it."
	icon = 'icons/obj/device.dmi'
	icon_state = "pin_extractor"
	item_state = "pin_extractor"
	w_class = 2
	flags = CONDUCT
	action_button_name = "Toggle extractor"
	var/on = 0
	var/activation_sound = 'sound/effects/lighton.ogg'
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_MAGNET = 4)


/obj/item/device/pin_extractor/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/device/pin_extractor/attack_self(mob/user)
	on = !on
	if(on && activation_sound)
		playsound(src.loc, activation_sound, 75, 1)
	update_icon()
	user.update_action_buttons()
	return 1

/obj/item/device/pin_extractor/afterattack(atom/target, mob/user, proximity_flag)
	if(proximity_flag)
		if(istype(target, /obj/item/gun))
			if(!on)
				to_chat(user, "<span class ='notice'>\The [src.name] is not turned on.</span>")
				..()
				return
			var/obj/item/gun/G = target
			if(G.pin)
				to_chat(user, "<span class ='notice'>You begin removing [G.name]'s [G.pin.name] using \the [src.name], it will take 15 seconds.</span>")

				if(!do_after(user, 15 SECONDS, act_target = target))
					return

				to_chat(user, "<span class ='notice'>You remove [G.name]'s [G.pin.name].</span>")
				G.pin.forceMove(get_turf(G))
				G.pin.gun = null
				G.pin = null

			else
				to_chat(user, "<span class ='notice'>\The [G.name] doesn't have a firing pin installed.</span>")
		else
			..()
