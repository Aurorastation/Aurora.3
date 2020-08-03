/obj/item/quick
	name = "quick box"
	desc = "A box that lets you quickly retrieve items. You shouldn't be seeing this."
	desc_info = "Click drag this onto your sprite to put it in one of your hands. Click it to take out one item."
	icon = 'icons/obj/storage.dmi'
	icon_state = "nitrilebox"
	item_state = "sheet-metal"
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	throwforce = 1
	throw_speed = 3
	throw_range = 7
	layer = OBJ_LAYER - 0.1
	var/can_put_back = FALSE

	var/additional_overlay

	var/max_amount = 50
	var/amount

	var/list/allowed_items
	var/spawn_new = TRUE
	var/list/contained_items = list()
	var/spawn_type
	var/item_name = "item"

/obj/item/quick/Initialize()
	. = ..()
	if(!amount)
		amount = max_amount
	if(!spawn_type)
		amount = 0
	else
		set_item_name()
	if(!spawn_new && amount)
		for(var/i = 1 to amount)
			var/obj/O = new spawn_type(src)
			contained_items += O
	if(additional_overlay)
		add_overlay(additional_overlay)

/obj/item/quick/proc/set_item_name()
	var/obj/item = spawn_type
	item_name = initial(item.name)

/obj/item/quick/MouseDrop(mob/user)
	if(use_check_and_message(user, USE_DISALLOW_SILICONS))
		return
	if(user.put_in_hands(src))
		to_chat(user, SPAN_NOTICE("You pick up \the [src]."))

/obj/item/quick/attack_hand(mob/user)
	if(!spawn_type && !length(allowed_items))
		to_chat(user, SPAN_DANGER("\The [src] doesn't have a spawn type, report this bug on github."))
		log_debug("quick storage [src] has no spawn_type")
		return
	if(!amount)
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if(H.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user, SPAN_WARNING("You try to move your [temp.name], but cannot!"))
			return

	add_fingerprint(user)
	amount--
	var/obj/item/I
	if(spawn_new)
		I = new spawn_type(src)
	else
		I = pick(contained_items)
		contained_items -= I
	user.put_in_hands(I)
	to_chat(user, SPAN_NOTICE("You take \the [I] out of \the [src]."))

/obj/item/quick/attackby(obj/item/O, mob/user)
	if(!can_put_back)
		to_chat(user, SPAN_WARNING("Items cannot be placed back into \the [src]."))
	else if(istype(O, spawn_type))
		to_chat(user, SPAN_NOTICE("You put \the [O] into \the [src]."))
		if(spawn_new)
			qdel(O)
		else
			user.drop_from_inventory(O, src)
			contained_items += O
		amount++
	else if(length(allowed_items) && is_type_in_list(O, allowed_items))
		if(amount)
			to_chat(user, SPAN_WARNING("\The [src] can take \the [O], but it has to be emptied first."))
			return
		to_chat(user, SPAN_NOTICE("You put \the [O] into \the [src]."))
		spawn_type = O.type
		if(spawn_new)
			qdel(O)
		else
			user.drop_from_inventory(O, src)
			contained_items += O
		amount++
		set_item_name()
	else
		to_chat(user, SPAN_WARNING("\The [src] doesn't take this type of item."))

/obj/item/quick/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(amount)
			to_chat(user, SPAN_NOTICE("There are [amount] [item_name]\s remaining in \the [src]."))
		else
			to_chat(user, SPAN_WARNING("\The [src] is empty."))