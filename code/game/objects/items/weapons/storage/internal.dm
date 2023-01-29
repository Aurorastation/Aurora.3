//A storage item intended to be used by other items to provide storage functionality.
//Types that use this should consider overriding emp_act() and hear_talk(), unless they shield their contents somehow.
/obj/item/storage/internal
	var/obj/item/master_item

/obj/item/storage/internal/New(obj/item/MI)
	master_item = MI
	loc = master_item
	name = master_item.name
	//verbs -= /obj/item/verb/verb_pickup	//make sure this is never picked up.
	..()

/obj/item/storage/internal/Destroy()
	master_item = null
	return ..()

/obj/item/storage/internal/attack_hand()
	return		//make sure this is never picked up

/obj/item/storage/internal/mob_can_equip(M, slot, disable_warning = FALSE)
	return 0	//make sure this is never picked up

//Helper procs to cleanly implement internal storages - storage items that provide inventory slots for other items.
//These procs are completely optional, it is up to the master item to decide when it's storage get's opened by calling open()
//However they are helpful for allowing the master item to pretend it is a storage item itself.
//If you are using these you will probably want to override attackby() as well.
//See /obj/item/clothing/suit/storage for an example.

//items that use internal storage have the option of calling this to emulate default storage MouseDrop behaviour.
//returns 1 if the master item's parent's MouseDrop() should be called, 0 otherwise. It's strange, but no other way of
//doing it without the ability to call another proc's parent, really.
/obj/item/storage/internal/proc/handle_mousedrop(mob/user as mob, obj/over_object as obj)
	if (ishuman(user) || issmall(user)) //so monkeys can take off their backpacks -- Urist

		if(over_object == user && Adjacent(user)) // this must come before the screen objects only block
			src.open(user)
			return 0

		if (!( istype(over_object, /obj/screen) ))
			return 1

		//makes sure master_item is equipped before putting it in hand, so that we can't drag it into our hand from miles away.
		//there's got to be a better way of doing this...
		if (!(master_item.loc == user) || (master_item.loc && master_item.loc.loc == user))
			return 0

		if (!( user.restrained() ) && !( user.stat ))
			switch(over_object.name)
				if("right hand")
					user.u_equip(master_item)
					user.equip_to_slot_if_possible(master_item, slot_r_hand)
				if("left hand")
					user.u_equip(master_item)
					user.equip_to_slot_if_possible(master_item, slot_l_hand)
			master_item.add_fingerprint(user)
			return 0
	return 0

//items that use internal storage have the option of calling this to emulate default storage attack_hand behaviour.
//returns 1 if the master item's parent's attack_hand() should be called, 0 otherwise.
//It's strange, but no other way of doing it without the ability to call another proc's parent, really.
/obj/item/storage/internal/proc/handle_attack_hand(mob/user as mob)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.l_store == master_item && !H.get_active_hand())	//Prevents opening if it's in a pocket.
			H.put_in_hands(master_item)
			H.l_store = null
			return 0
		if(H.r_store == master_item && !H.get_active_hand())
			H.put_in_hands(master_item)
			H.r_store = null
			return 0

	src.add_fingerprint(user)
	if (master_item.loc == user)
		src.open(user)
		return 0

	for(var/mob/M in range(1, master_item.loc))
		if (M.s_active == src)
			src.close(M)
	return 1

/obj/item/storage/internal/Adjacent(var/atom/neighbor)
	return master_item.Adjacent(neighbor)

/obj/item/storage/internal/skrell
	name = "headtail storage"
	icon = 'icons/obj/action_buttons/organs.dmi'
	icon_state = "skrell_headpocket"
	storage_slots = 1
	max_storage_space = 2
	max_w_class = ITEMSIZE_SMALL
	use_sound = null

/obj/item/storage/internal/skrell/Initialize()
	. = ..()
	name = initial(name)

// Helmet Slots
/obj/item/storage/internal/helmet
	var/list/helmet_storage_types = list(
		/obj/item/storage/box/fancy/cigarettes = HELMET_GARB_PASS_ICON,
		/obj/item/storage/box/fancy/cigarettes/acmeco = HELMET_GARB_PASS_ICON,
		/obj/item/storage/box/fancy/cigarettes/blank = HELMET_GARB_PASS_ICON,
		/obj/item/storage/box/fancy/cigarettes/dromedaryco = HELMET_GARB_PASS_ICON,
		/obj/item/storage/box/fancy/cigarettes/nicotine = HELMET_GARB_PASS_ICON,
		/obj/item/storage/box/fancy/cigarettes/rugged = HELMET_GARB_PASS_ICON,
		/obj/item/storage/box/fancy/cigarettes/pra = HELMET_GARB_PASS_ICON,
		/obj/item/storage/box/fancy/cigarettes/dpra = HELMET_GARB_PASS_ICON,
		/obj/item/storage/box/fancy/cigarettes/nka = HELMET_GARB_PASS_ICON
	)
	can_hold_strict = TRUE

/obj/item/storage/internal/helmet/Initialize(mapload, defer_shrinkwrap)
	. = ..()
	can_hold = list()
	for(var/thing_type in helmet_storage_types)
		can_hold += thing_type

/obj/item/storage/internal/helmet/handle_item_insertion(obj/item/W, prevent_messages)
	. = ..()
	if(. && istype(loc, /obj/item/clothing/head/helmet))
		var/obj/item/clothing/head/helmet/helmet = loc
		helmet.update_clothing_icon()

/obj/item/storage/internal/helmet/remove_from_storage(obj/item/W, atom/new_location)
	. = ..()
	if(. && istype(loc, /obj/item/clothing/head/helmet))
		var/obj/item/clothing/head/helmet/helmet = loc
		helmet.update_clothing_icon()

/obj/item/storage/internal/tail
	name = "tail storage"
	storage_slots = 1
	max_storage_space = 2
	max_w_class = ITEMSIZE_SMALL
	use_sound = null

/obj/item/storage/internal/tail/can_be_inserted(obj/item/clothing/tail_accessory/TA, stop_messages)
	if(!istype(TA))
		return FALSE
	. = ..()
	if(!.)
		return

	var/obj/item/organ/external/E = loc
	if(!istype(E))
		return FALSE

	var/mob/living/carbon/human/H = E.owner
	if(!istype(H))
		return FALSE

	if(!TA.compatible_with_human(H))
		return FALSE

	return TRUE

// we can generally assume user has all the proper groin stuff here, otherwise the above block of code is busted
/obj/item/storage/internal/tail/handle_item_insertion(obj/item/W, prevent_warning, mob/living/carbon/human/user)
	. = ..()
	if(.)
		user.update_tail_showing()

/obj/item/storage/internal/tail/remove_from_storage(obj/item/W, atom/new_location)
	. = ..()
	if(.)
		var/obj/item/organ/external/E = loc
		if(!istype(E))
			return
		var/mob/living/carbon/human/H = E.owner
		if(!istype(H))
			return
		H.update_tail_showing()