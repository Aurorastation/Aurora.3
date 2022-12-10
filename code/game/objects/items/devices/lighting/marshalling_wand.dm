/obj/item/device/flashlight/marshallingwand
	name = "marshalling wand"
	desc = "A marshalling wand, used to direct air or space faring vessels during takeoff and landing."
	icon_state = "marshallingwand"
	item_state = "marshallingwand"
	w_class = ITEMSIZE_SMALL
	light_color = LIGHT_COLOR_RED
	light_wedge = LIGHT_OMNI
	brightness_on = 2
	action_button_name = "Toggle Marshalling Wands"

/obj/item/device/flashlight/marshallingwand/AltClick(mob/user)
	if(!use_check_and_message(user))
		if(!isturf(user.loc))
			to_chat(user, SPAN_WARNING("You cannot turn the light on while in this [user.loc].")) //To prevent some lighting anomalities.)
			return FALSE
		toggle()
		user.update_action_buttons()
		return TRUE

/obj/item/device/flashlight/marshallingwand/ui_action_click()
	AltClick(usr)

/obj/item/device/flashlight/marshallingwand/attack_self(mob/user)
	if(!on)
		to_chat(user, SPAN_WARNING("The wands need to be on before you can direct craft with them!"))
		return
	switch(user.a_intent)
		if(I_HELP)
			user.visible_message(SPAN_NOTICE("[user] points the marshalling wand forward, directing a pilot to take off."), SPAN_NOTICE("You point the marshalling wand forward, directing a pilot to take off."))
		if(I_DISARM)
			user.visible_message(SPAN_NOTICE("[user] waves the marshalling wand toward themself, directing a pilot to approach."), SPAN_NOTICE("You wave the marshalling wand toward yourself, directing a pilot to approach."))
		if(I_GRAB)
			user.visible_message(SPAN_NOTICE("[user] holds the marshalling wand out, directing a pilot to cease movement."), SPAN_NOTICE("You hold the marshalling wand out, directing a pilot to cease movement."))
		if(I_HURT)
			user.visible_message(SPAN_WARNING("[user] frantically waves the marshalling wand!"), SPAN_WARNING("You wave the marshalling wand frantically!"))

