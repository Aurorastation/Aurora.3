/obj/structure/closet/secure_closet
	name = "secure locker"
	desc = "It's an immobile card-locked storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "secure1"
	density = 1
	opened = 0
	anchored = 0
	var/locked = 1
	var/broken = 0
	var/large = 1
	icon_closed = "secure"
	var/icon_locked = "secure1"
	icon_opened = "secureopen"
	var/icon_broken = "securebroken"
	var/icon_off = "secureoff"
	wall_mounted = 0 //never solid (You can always pass over it)
	health = 200

/obj/structure/closet/secure_closet/can_open()
	if(locked)
		return 0
	return ..()

/obj/structure/closet/secure_closet/close()
	if(..())
		if(broken)
			icon_state = icon_off
		return 1
	else
		return 0

/obj/structure/closet/secure_closet/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken)
		if(prob(50/severity))
			locked = !locked
			update_icon()
		if(prob(20/severity) && !opened)
			if(!locked)
				open()
			else
				req_access = list()
				req_access += pick(get_all_station_access())
	..()

/obj/structure/closet/secure_closet/proc/togglelock(mob/user as mob)
	if(opened)
		to_chat(user,  "<span class='notice'>Close the locker first.</span>")
		return
	if(broken)
		to_chat(user,  "<span class='warning'>The locker appears to be broken.</span>")
		return
	if(user.loc == src)
		to_chat(user, "<span class='notice'>You can't reach the lock from inside.</span>")
		return
	if(allowed(user))
		locked = !locked
		for(var/mob/O in viewers(user, 3))
			if((O.client && !( O.blinded )))
				to_chat(O, "<span class='notice'>The locker has been [locked ? null : "un"]locked by [user].</span>")
		update_icon()
	else
		to_chat(user,  "<span class='notice'>Access Denied</span>")

/obj/structure/closet/secure_closet/AltClick(mob/user)
	. = ..()

	if(use_check_and_message(user))
		return

	togglelock(user)

/obj/structure/closet/secure_closet/proc/CanChainsaw(var/obj/item/material/twohanded/chainsaw/ChainSawVar)
	return (ChainSawVar.powered && !opened && !broken)

/obj/structure/closet/secure_closet/attackby(obj/item/W as obj, mob/user as mob)
	if(!opened)
		if(!broken && istype(W,/obj/item/material/twohanded/chainsaw))
			var/obj/item/material/twohanded/chainsaw/ChainSawVar = W
			ChainSawVar.cutting = 1
			user.visible_message(\
				"<span class='danger'>[user.name] starts cutting the [src] with the [W]!</span>",\
				"<span class='warning'>You start cutting the [src]...</span>",\
				"<span class='notice'>You hear a loud buzzing sound and metal grinding on metal...</span>"\
			)
			if(do_after(user, ChainSawVar.opendelay SECONDS, act_target = user, extra_checks  = CALLBACK(src, .proc/CanChainsaw, W)))
				user.visible_message(\
					"<span class='warning'>[user.name] finishes cutting open the [src] with the [W].</span>",\
					"<span class='warning'>You finish cutting open the [src].</span>",\
					"<span class='notice'>You hear a metal clank and some sparks.</span>"\
				)
				emag_act(INFINITY, user, "<span class='danger'>The locker has been sliced open by [user] with \an [W]</span>!", "<span class='danger'>You hear metal being sliced and sparks flying.</span>")
				spark(src, 5)
			ChainSawVar.cutting = 0
		else if(istype(W, /obj/item/melee/energy/blade))//Attempt to cut open locker if locked
			if(emag_act(INFINITY, user, "<span class='danger'>The locker has been sliced open by [user] with \an [W]</span>!", "<span class='danger'>You hear metal being sliced and sparks flying.</span>"))
				spark(src, 5)
				playsound(loc, 'sound/weapons/blade.ogg', 50, 1)
				playsound(loc, /decl/sound_category/spark_sound, 50, 1)
				return
		else
			togglelock(user)//Attempt to lock locker if closed
			return
	return ..()

/obj/structure/closet/secure_closet/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
	if(!broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = icon_off
		flick(icon_broken, src)

		if(visual_feedback)
			visible_message(visual_feedback, audible_feedback)
		else if(user && emag_source)
			visible_message("<span class='warning'>\The [src] has been broken by \the [user] with \an [emag_source]!</span>", "You hear a faint electrical spark.")
		else
			visible_message("<span class='warning'>\The [src] sparks and breaks open!</span>", "You hear a faint electrical spark.")
		return 1

/obj/structure/closet/secure_closet/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(locked)
		togglelock(user)
	else
		toggle(user)

/obj/structure/closet/secure_closet/verb/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if(ishuman(usr))
		add_fingerprint(usr)
		togglelock(usr)
	else if(istype(usr, /mob/living/silicon/robot) && Adjacent(usr))
		togglelock(usr)
	else
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")

/obj/structure/closet/secure_closet/update_icon()//Putting the welded stuff in update_icon() so it's easy to overwrite for special cases (Fridges, cabinets, and whatnot)
	cut_overlays()
	if(!opened)
		if(locked)
			icon_state = icon_locked
		else
			icon_state = icon_closed
		if(welded)
			add_overlay(welded_overlay_state)
	else
		icon_state = icon_opened


/obj/structure/closet/secure_closet/req_breakout()
	if(!opened && locked)
		if (welded)
			return 2
		else
			return 1
	else
		return ..() //It's a secure closet, but isn't locked.

/obj/structure/closet/secure_closet/break_open()
	desc += " It appears to be broken."
	icon_state = icon_off
	spawn()
		flick(icon_broken, src)
		sleep(10)
		flick(icon_broken, src)
		sleep(10)
	broken = 1
	welded = 0
	locked = 0
	update_icon()
	//Do this to prevent contents from being opened into nullspace (read: bluespace)
	if(istype(loc, /obj/structure/bigDelivery))
		var/obj/structure/bigDelivery/BD = loc
		BD.unwrap()
	open()

