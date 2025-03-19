/obj/structure/closet/secure_closet/personal
	name = "personal closet"
	desc = "It's a secure locker for personnel. The first card swiped gains control."
	req_access = list(ACCESS_ALL_PERSONAL_LOCKERS)
	var/registered_name = null

/obj/structure/closet/secure_closet/personal/fill()
	if(prob(50))
		new /obj/item/storage/backpack(src)
	else
		new /obj/item/storage/backpack/satchel(src)
	new /obj/item/device/radio/headset(src)
	new /obj/item/device/radio/headset/alt(src)

/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/personal/patient/fill()
	if(prob(50))
		new /obj/item/clothing/under/medical_gown(src)
		new /obj/item/clothing/under/medical_gown(src)
	else
		new /obj/item/clothing/under/medical_gown/white(src)
		new /obj/item/clothing/under/medical_gown/white(src)
	new /obj/item/clothing/shoes/sneakers( src )
	new /obj/item/clothing/shoes/sneakers( src )


/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinet"
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	door_anim_angle = 160
	door_anim_squish = 0.22
	door_hinge_alt = 7.5
	double_doors = TRUE

/obj/structure/closet/secure_closet/personal/cabinet/fill()
	new /obj/item/storage/backpack/satchel/leather/withwallet(src)
	new /obj/item/device/radio/headset(src)
	new /obj/item/device/radio/headset/alt(src)

/obj/structure/closet/secure_closet/personal/attackby(obj/item/attacking_item, mob/user)
	if (opened)
		if (istype(attacking_item, /obj/item/grab))
			var/obj/item/grab/G = attacking_item
			mouse_drop_receive(G.affecting, user)      //act like they were dragged onto the closet
		if(attacking_item)
			user.drop_from_inventory(attacking_item,loc)
		else
			user.drop_item()
	else if(attacking_item.GetID())
		if(user.loc == src)
			to_chat(user, SPAN_NOTICE("You can't reach the lock from inside."))
			return
		var/obj/item/card/id/I = attacking_item.GetID()

		if(broken)
			to_chat(user, SPAN_WARNING("It appears to be broken."))
			return
		if(!I || !I.registered_name)	return
		if(allowed(user) || !registered_name || (istype(I) && (registered_name == I.registered_name)))
			//they can open all lockers, or nobody owns this, or they own this locker
			locked = !( locked )
			update_icon()

			if(!registered_name)
				registered_name = I.registered_name
				desc = "Owned by [I.registered_name]."
		else
			to_chat(user, SPAN_WARNING("Access Denied"))
	else if(istype(attacking_item, /obj/item/melee/energy/blade))
		var/obj/item/melee/energy/blade/blade = attacking_item
		if(emag_act(INFINITY, user, "The locker has been sliced open by [user] with \an [blade]!", "You hear metal being sliced and sparks flying."))
			blade.spark_system.queue()
			playsound(loc, 'sound/weapons/blade.ogg', 50, 1)
			playsound(loc, /singleton/sound_category/spark_sound, 50, 1)
	else
		to_chat(user, SPAN_WARNING("Access Denied"))
	return

/obj/structure/closet/secure_closet/personal/emag_act(var/remaining_charges, var/mob/user, var/visual_feedback, var/audible_feedback)
	if(!broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		update_icon()
		if(visual_feedback)
			visible_message(SPAN_WARNING("[visual_feedback]"), SPAN_WARNING("[audible_feedback]"))
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
			to_chat(usr, SPAN_WARNING("You need to unlock it first."))
		else if (broken)
			to_chat(usr, SPAN_WARNING("It appears to be broken."))
		else
			if (opened)
				if(!close())
					return
			locked = 1
			update_icon()
			registered_name = null
			desc = "It's a secure locker for personnel. The first card swiped gains control."
	return
