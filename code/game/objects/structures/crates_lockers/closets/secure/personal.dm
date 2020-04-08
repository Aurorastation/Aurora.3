/obj/structure/closet/secure_closet/personal
	name = "personal closet"
	desc = "It's a secure locker for personnel. The first card swiped gains control."
	req_access = list(access_all_personal_lockers)
	var/registered_name = null

/obj/structure/closet/secure_closet/personal/fill()
	if(prob(50))
		new /obj/item/storage/backpack(src)
	else
		new /obj/item/storage/backpack/satchel_norm(src)
	new /obj/item/device/radio/headset(src)
	new /obj/item/device/radio/headset/alt(src)

/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/personal/patient/fill()
	if(prob(50))
		new /obj/item/clothing/under/medical_gown(src)
	else
		new /obj/item/clothing/under/medical_gown/white(src)
	new /obj/item/clothing/shoes/white( src )


/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

/obj/structure/closet/secure_closet/personal/cabinet/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened

/obj/structure/closet/secure_closet/personal/cabinet/fill()
	new /obj/item/storage/backpack/satchel/withwallet(src)
	new /obj/item/device/radio/headset(src)
	new /obj/item/device/radio/headset/alt(src)

/obj/structure/closet/secure_closet/personal/attackby(obj/item/W as obj, mob/user as mob)
	if (opened)
		if (istype(W, /obj/item/grab))
			MouseDrop_T(W:affecting, user)      //act like they were dragged onto the closet
		if(W)
			user.drop_from_inventory(W,loc)
		else
			user.drop_item()
	else if(W.GetID())
		if(user.loc == src)
			to_chat(user, "<span class='notice'>You can't reach the lock from inside.</span>")
			return
		var/obj/item/card/id/I = W.GetID()

		if(broken)
			to_chat(user, "<span class='warning'>It appears to be broken.</span>")
			return
		if(!I || !I.registered_name)	return
		if(allowed(user) || !registered_name || (istype(I) && (registered_name == I.registered_name)))
			//they can open all lockers, or nobody owns this, or they own this locker
			locked = !( locked )
			if(locked)	icon_state = icon_locked
			else	icon_state = icon_closed

			if(!registered_name)
				registered_name = I.registered_name
				desc = "Owned by [I.registered_name]."
		else
			to_chat(user, "<span class='warning'>Access Denied</span>")
	else if(istype(W, /obj/item/melee/energy/blade))
		var/obj/item/melee/energy/blade/blade = W
		if(emag_act(INFINITY, user, "The locker has been sliced open by [user] with \an [blade]!", "You hear metal being sliced and sparks flying."))
			blade.spark_system.queue()
			playsound(loc, 'sound/weapons/blade.ogg', 50, 1)
			playsound(loc, "sparks", 50, 1)
	else
		to_chat(user, "<span class='warning'>Access Denied</span>")
	return

/obj/structure/closet/secure_closet/personal/emag_act(var/remaining_charges, var/mob/user, var/visual_feedback, var/audible_feedback)
	if(!broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = icon_broken
		if(visual_feedback)
			visible_message("<span class='warning'>[visual_feedback]</span>", "<span class='warning'>[audible_feedback]</span>")
		return 1

/obj/structure/closet/secure_closet/personal/verb/reset()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Reset Lock"
	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return
	if(ishuman(usr))
		add_fingerprint(usr)
		if (locked || !registered_name)
			to_chat(usr, "<span class='warning'>You need to unlock it first.</span>")
		else if (broken)
			to_chat(usr, "<span class='warning'>It appears to be broken.</span>")
		else
			if (opened)
				if(!close())
					return
			locked = 1
			icon_state = icon_locked
			registered_name = null
			desc = "It's a secure locker for personnel. The first card swiped gains control."
	return
