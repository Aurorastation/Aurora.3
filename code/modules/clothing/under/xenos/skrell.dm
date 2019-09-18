/obj/item/clothing/under/skrell
	name = "federation uniform"
	desc = "The uniform worn by Official Jagon Federation Representatives and Diplomats.  It looks pretty waterproof."
	icon = 'icons/obj/skrell_items.dmi'
	icon_state = "skrell_formal"
	item_state = "skrell_formal"
	contained_sprite = TRUE

/obj/item/clothing/under/skrell/qeblak
	name = "qeblak ceremonial garment"
	desc = "A traditional garment worn by Qeblak Star Keepers"
	icon_state = "qeblak_uniform"
	item_state = "qeblak_uniform"
	action_button_name = "Toggle Ceremonial Garment Lights"
	var/lights = FALSE

/obj/item/clothing/under/skrell/qeblak/update_icon()
	..()
	if(lights)
		item_state = "[initial(icon_state)]_on"
	else
		item_state = initial(item_state)

/obj/item/clothing/under/skrell/qeblak/attack_self(mob/user)
	toggle_lights()

/obj/item/clothing/under/skrell/qeblak/verb/toggle_lights()
	set name = "Toggle Ceremonial Garment Lights"
	set category = "Object"
	set src in usr

	if (use_check_and_message(usr))
		return

	lights = !lights

	if(lights)
		set_light(2)
	else
		set_light(0)

	update_icon()
	usr.update_inv_w_uniform()