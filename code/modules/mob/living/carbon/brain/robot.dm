/obj/item/device/mmi/digital/robot
	name = "robotic intelligence circuit"
	desc = "The pinnacle of artifical intelligence which can be achieved using classical computer science."
	icon = 'icons/obj/module.dmi'
	icon_state = "mainboard"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3, TECH_DATA = 4)

/obj/item/device/mmi/digital/robot/Initialize(mapload, ...)
	. = ..()
	brainmob.name = "[pick(list("ADA","DOS","GNU","MAC","WIN"))]-[rand(1000, 9999)]"
	brainmob.real_name = brainmob.name
	name = "robotic intelligence circuit ([brainmob.name])"

/obj/item/device/mmi/digital/robot/update_icon()
	icon_state = "mainboard"

/obj/item/device/mmi/digital/robot/transfer_identity(mob/living/carbon/H)
	..()
	if(brainmob.mind)
		brainmob.mind.assigned_role = "Robotic Intelligence"
	to_chat(brainmob, "<span class='notify'>You feel slightly disoriented. That's normal when you're little more than a complex circuit.</span>")

/obj/item/device/mmi/digital/robot/ready_for_use(var/mob/user)
	if(!brainmob)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a personality loaded on it yet!"))
		return
	if(brainmob.stat == DEAD)
		to_chat(user, SPAN_WARNING("The personality inside \the [src] is dead!"))
		return FALSE
	return TRUE

/obj/item/device/mmi/digital/robot/set_cradle_state(var/new_state)
	return

/obj/item/device/mmi/digital/robot/attackby(obj/item/I, mob/user)
	return

/obj/item/device/mmi/digital/robot/attack_self(mob/user)
	return