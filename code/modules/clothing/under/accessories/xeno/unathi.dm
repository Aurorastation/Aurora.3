/obj/item/clothing/accessory/sinta_hood
	name = "clan hood"
	desc = "A hood worn commonly by unathi away from home. No better way of both representing your clan to foreigners and keeping the sun out of your eyes in style!"
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "sinta_hood"
	item_state = "sinta_hood_up"
	slot_flags = SLOT_TIE|SLOT_HEAD
	contained_sprite = TRUE
	action_button_name = "Adjust Hood"
	var/up = TRUE

/obj/item/clothing/accessory/sinta_hood/attack_self()
	toggle()

/obj/item/clothing/accessory/sinta_hood/verb/toggle()
	set category = "Object"
	set name = "Adjust Hood"
	set src in usr

	if(use_check_and_message(usr))
		return
	up = !up
	if(up)
		flags_inv = BLOCKHAIR|BLOCKHEADHAIR
		body_parts_covered = HEAD
		item_state = "sinta_hood_up"
		to_chat(usr, SPAN_NOTICE("You flip \the [src] up."))
	else
		flags_inv = 0
		body_parts_covered = 0
		item_state = "sinta_hood"
		to_chat(usr, SPAN_NOTICE("You flip \the [src] down."))
	update_worn_icon()
	update_clothing_icon()
	update_icon()