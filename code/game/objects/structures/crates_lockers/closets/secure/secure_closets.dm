/obj/structure/closet/secure_closet
	name = "secure locker"
	desc = "It's an immobile card-locked storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "secure1"
	density = TRUE
	opened = FALSE
	anchored = FALSE
	var/locked = TRUE
	var/broken = FALSE
	var/large = TRUE
	icon_closed = "secure"
	var/icon_locked = "secure1"
	icon_opened = "secureopen"
	var/icon_broken = "securebroken"
	var/icon_off = "secureoff"
	var/canbemoved = FALSE // if it can be moved by people using the right tools
	var/screwed = TRUE // if its screwed in place
	var/wrenched = TRUE // if its wrenched down
	wall_mounted = FALSE //never solid (You can always pass over it)
	health = 200

	//hacking
	var/crowbarred = FALSE
	var/crowbarred_overlay_state = "crowbarred"
	var/secured_wires = FALSE
	var/datum/wires/secure_closet/wires = null

/obj/structure/closet/secure_closet/Initialize(mapload)
	. = ..()
	var/wire_path = secured_wires ? /datum/wires/secure_closet/scrambled : /datum/wires/secure_closet
	wires = new wire_path(src)

/obj/structure/closet/secure_closet/can_open()
	if(locked)
		return FALSE
	return ..()

/obj/structure/closet/secure_closet/close()
	if(..())
		if(broken)
			icon_state = icon_off
		return TRUE
	else
		return FALSE

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
		to_chat(user, SPAN_NOTICE("Close the locker first."))
		return
	if(broken)
		to_chat(user, SPAN_WARNING("The locker appears to be broken."))
		return
	if(user.loc == src)
		to_chat(user, SPAN_NOTICE("You can't reach the lock from inside."))
		return
	if(allowed(user))
		locked = !locked
		user.visible_message(SPAN_NOTICE("The locker has been [locked ? "" : "un"]locked by [user]."), SPAN_NOTICE("You [locked ? "" : "un"]lock \the [src]."), range = 3)
		update_icon()
	else
		to_chat(user, SPAN_NOTICE("Access Denied"))

/obj/structure/closet/secure_closet/AltClick(mob/user)
	. = ..()

	if(use_check_and_message(user))
		return

	togglelock(user)

/obj/structure/closet/secure_closet/proc/CanChainsaw(var/obj/item/material/twohanded/chainsaw/ChainSawVar)
	return (ChainSawVar.powered && !opened && !broken)

/obj/structure/closet/secure_closet/attackby(obj/item/W, mob/user)
	if(opened)
		if(istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			if(large)
				MouseDrop_T(G.affecting, user)	//act like they were dragged onto the closet
			else
				to_chat(user, SPAN_NOTICE("The locker is too small to stuff [G.affecting] into!"))
		if(W.iswelder())
			var/obj/item/weldingtool/WT = W
			if(WT.isOn())
				user.visible_message(SPAN_WARNING("[user] begins cutting [src] apart."), SPAN_NOTICE("You begin cutting [src] apart."), "You hear a welding torch on metal.")
				playsound(loc, 'sound/items/welder_pry.ogg', 50, TRUE)
				if(!do_after(user, 2/W.toolspeed SECONDS, act_target = src, extra_checks = CALLBACK(src, .proc/is_open)))
					return
				if(!WT.remove_fuel(0, user))
					to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
					return
				else
					new /obj/item/stack/material/steel(loc)
					user.visible_message(SPAN_NOTICE("[src] has been cut apart by [user] with [WT]."), SPAN_NOTICE("You cut apart [src] with [WT]."))
					qdel(src)
					return
		else if(isrobot(user))
			return
		else if(W.loc != user) // This should stop mounted modules ending up outside the module.
			return
		if(W)
			user.drop_from_inventory(W,loc)
		else
			user.drop_item()
	else if(W.ismultitool() || W.iswirecutter())
		if(!crowbarred)
			to_chat(user, SPAN_WARNING("The secure locker's maintenance panel is still closed."))
			return
		wires.Interact(user)
		return
	else if(W.isscrewdriver() && canbemoved)
		if(screwed)
			to_chat(user, SPAN_NOTICE("You start to unscrew the locker from the floor..."))
			playsound(loc, W.usesound, 50, TRUE)
			if (do_after(user, 10/W.toolspeed SECONDS, act_target = src))
				to_chat(user, SPAN_NOTICE("You unscrew the locker!"))
				playsound(loc, W.usesound, 50, TRUE)
				screwed = FALSE
		else if(!screwed && wrenched)
			to_chat(user, SPAN_NOTICE("You start to screw the locker to the floor..."))
			playsound(src, 'sound/items/welder.ogg', 80, TRUE)
			if(do_after(user, 15/W.toolspeed SECONDS, act_target = src))
				to_chat(user, SPAN_NOTICE("You screw the locker!"))
				playsound(loc, W.usesound, 50, TRUE)
				screwed = TRUE
	else if(W.iswrench() && canbemoved)
		if(wrenched && !screwed)
			to_chat(user, SPAN_NOTICE("You start to unfasten the bolts holding the locker in place..."))
			playsound(loc, W.usesound, 50, TRUE)
			if (do_after(user, 15/W.toolspeed SECONDS, act_target = src))
				to_chat(user, SPAN_NOTICE("You unfasten the locker's bolts!"))
				playsound(loc, W.usesound, 50, TRUE)
				wrenched = FALSE
				anchored = FALSE
		else if(!wrenched)
			to_chat(user, SPAN_NOTICE("You start to fasten the bolts holding the locker in place..."))
			playsound(loc, W.usesound, 50, TRUE)
			if (do_after(user, 15/W.toolspeed SECONDS, act_target = src))
				to_chat(user, SPAN_NOTICE("You fasten the locker's bolts!"))
				playsound(loc, W.usesound, 50, TRUE)
				wrenched = TRUE
				anchored = TRUE
	else if(istype(W, /obj/item/device/hand_labeler))
		var/obj/item/device/hand_labeler/HL = W
		if (HL.mode == 1)
			return
		else
			togglelock(user)
	else if(W.iscrowbar())
		user.visible_message("<b>[user]</b> starts forcing the secure locker's maintenance panel [crowbarred ? "closed" : "open"] with \the [W]...", SPAN_NOTICE("You start forcing the secure locker's maintenance panel [crowbarred ? "closed" : "open"] with \the [W]..."))
		if(!do_after(user, 10 SECONDS))
			return
		playsound(src, /decl/sound_category/crowbar_sound, 80)
		crowbarred = !crowbarred
		update_icon()
	else
		if(!broken && istype(W,/obj/item/material/twohanded/chainsaw))
			var/obj/item/material/twohanded/chainsaw/ChainSawVar = W
			ChainSawVar.cutting = TRUE
			user.visible_message(SPAN_DANGER("[user.name] starts cutting the [src] with the [W]!"), SPAN_WARNING("You start cutting the [src]..."), SPAN_NOTICE("You hear a loud buzzing sound and metal grinding on metal..."))
			if(do_after(user, ChainSawVar.opendelay SECONDS, act_target = user, extra_checks  = CALLBACK(src, .proc/CanChainsaw, W)))
				user.visible_message(SPAN_WARNING("[user.name] finishes cutting open the [src] with the [W]."), SPAN_WARNING("You finish cutting open the [src]."), SPAN_NOTICE("You hear a metal clank and some sparks."))
				emag_act(INFINITY, user, SPAN_DANGER("The locker has been sliced open by [user] with \an [W]!"), SPAN_DANGER("You hear metal being sliced and sparks flying."))
				spark(src, 5)
			ChainSawVar.cutting = FALSE
		else if(istype(W, /obj/item/melee/energy/blade))//Attempt to cut open locker if locked
			if(emag_act(INFINITY, user, SPAN_DANGER("The locker has been sliced open by [user] with \an [W]!"), SPAN_DANGER("You hear metal being sliced and sparks flying.")))
				spark(src, 5)
				playsound(loc, 'sound/weapons/blade.ogg', 50, TRUE)
				playsound(loc, /decl/sound_category/spark_sound, 50, TRUE)
		else if(W.iswelder())
			var/obj/item/weldingtool/WT = W
			if(WT.isOn())
				user.visible_message(SPAN_WARNING("[user] begins welding [src] [welded ? "open" : "shut"]."), SPAN_NOTICE("You begin welding [src] [welded ? "open" : "shut"]."), "You hear a welding torch on metal.")
				playsound(loc, 'sound/items/welder_pry.ogg', 50, TRUE)
				if(!do_after(user, 2 SECONDS, act_target = src, extra_checks = CALLBACK(src, .proc/is_closed)))
					return
				if(!WT.remove_fuel(0, user))
					to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
					return
				welded = !welded
				update_icon()
				user.visible_message(SPAN_WARNING("[src] has been [welded ? "welded shut" : "unwelded"] by [user]."), SPAN_NOTICE("You weld [src] [!welded ? "open" : "shut"]."))
			else
				togglelock(user)
		else if(istype(W, /obj/item/ducttape))
			return
		else
			togglelock(user)//Attempt to lock locker if closed

/obj/structure/closet/secure_closet/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
	if(!broken)
		broken = TRUE
		locked = FALSE
		desc = "It appears to be broken."
		icon_state = icon_off
		flick(icon_broken, src)

		if(visual_feedback)
			visible_message(visual_feedback, audible_feedback)
		else if(user && emag_source)
			visible_message(SPAN_WARNING("\The [src] has been broken by \the [user] with \an [emag_source]!"), "You hear a faint electrical spark.")
		else
			visible_message(SPAN_WARNING("\The [src] sparks and breaks open!"), "You hear a faint electrical spark.")
		return 1

/obj/structure/closet/secure_closet/attack_hand(mob/user)
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
		to_chat(usr, SPAN_WARNING("This mob type can't use this verb."))

/obj/structure/closet/secure_closet/update_icon()//Putting the welded stuff in update_icon() so it's easy to overwrite for special cases (Fridges, cabinets, and whatnot)
	cut_overlays()
	if(!opened)
		if(broken)
			icon_state = icon_broken
		else if(locked)
			icon_state = icon_locked
		else
			icon_state = icon_closed
		if(welded)
			add_overlay(welded_overlay_state)
		if(crowbarred)
			add_overlay(crowbarred_overlay_state)
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
	broken = TRUE
	welded = 0
	locked = FALSE
	update_icon()
	//Do this to prevent contents from being opened into nullspace (read: bluespace)
	if(istype(loc, /obj/structure/bigDelivery))
		var/obj/structure/bigDelivery/BD = loc
		BD.unwrap()
	open()