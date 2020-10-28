/obj/item/clothing/accessory/sinta_hood
	name = "clan hood"
	desc = "A hood worn commonly by travelers, explorers, and levies. It's main purpose is to block the glare of sun when traveling, and to represent their clan. Often they have the names sewn into the inside to help identify the owner should it, or the owner, be lost."
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

/obj/item/clothing/accessory/sinta_surcoat
	name = "ghaz'ak"
	desc = "The Ghaz'ak is common among levies and warriors alike, displaying the colors of the ruling body that they fight for. While it's main use it to keep the sun's glare off of armor, particularly patriotic sinta have taken to wearing it outside of combat."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "surcoat"
	item_state = "surcoat"
	slot_flags = SLOT_TIE|SLOT_OCLOTHING
	contained_sprite = TRUE