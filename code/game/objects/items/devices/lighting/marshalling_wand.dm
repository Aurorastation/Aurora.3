/obj/item/flashlight/marshallingwand
	name = "marshalling wand"
	desc = "A marshalling wand, used to direct air or space faring vessels during takeoff and landing."
	icon_state = "marshallingwand"
	item_state = "marshallingwand"
	build_from_parts = TRUE
	worn_overlay = "bulb"
	worn_overlay_color = LIGHT_COLOR_WHITE
	w_class = WEIGHT_CLASS_SMALL
	light_system = MOVABLE_LIGHT
	light_range = 2
	action_button_name = "Toggle Marshalling Wands"

/obj/item/flashlight/marshallingwand/Initialize()
	. = ..()
	update_icon() // Initial build_from_parts assembly

/obj/item/flashlight/marshallingwand/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "ALT-click the marshalling wand to turn it on and off. Everytime you turn it on it will be blue, signaling and idle intent."
	. += "Using the wand will change its color based of your intent. Each intent has a different output."
	. += "Holding two marshalling wands in your hands will mirror the state of one to the other, so that they are always in sync."

// Override brights. The marshalling wands are meant to be always bright, this will toggle the on and off instead.
/obj/item/flashlight/marshallingwand/AltClick(mob/user)
	if(!use_check_and_message(user))
		if(!isturf(user.loc))
			to_chat(user, SPAN_WARNING("You cannot turn the light on while in this [user.loc].")) // To prevent some lighting anomalities.)
			return FALSE
		toggle()
		if(on)
			set_light_color(LIGHT_COLOR_BLUE) // Default to blue (stand-by) when turned on
			worn_overlay_color = light_color
		else
			worn_overlay_color = LIGHT_COLOR_WHITE
		update_icon()
		mirror_held_wands(src)
		user.update_action_buttons()
		return TRUE

/obj/item/flashlight/marshallingwand/ui_action_click()
	AltClick(usr)

/obj/item/flashlight/marshallingwand/attack_self(mob/user)
	// Are we holding one or two wands?
	var/wand_invariant = ""
	if(ismob(loc))
		var/mob/m = loc
		var/item = m.get_inactive_hand()
		if(item && istype(item, /obj/item/flashlight/marshallingwand))
			wand_invariant = "wands"
		else
			wand_invariant = "wand"

	if(!on)
		to_chat(user, SPAN_WARNING("The [wand_invariant] need to be turned on before you can direct crafts with them!"))
		return

	switch(user.a_intent)
		if(I_HELP)
			set_light_color(LIGHT_COLOR_GREEN) // Green for go!
		if(I_DISARM)
			set_light_color(LIGHT_COLOR_BLUE) // Blue for stand-by - Idle while nothing is happening yet.
		if(I_GRAB)
			set_light_color(LIGHT_COLOR_YELLOW) // Yellow for hold - Last checks are in progress. Prepare for takeoff!
		if(I_HURT)
			set_light_color(LIGHT_COLOR_RED) // Stop! Craft is being serviced or shutting down.
	worn_overlay_color = light_color

	switch(light_color)
		if(LIGHT_COLOR_GREEN)
			user.visible_message(SPAN_NOTICE("[user] quickly waves the marshalling [wand_invariant] forward, giving the craft the lift-off signal!"), SPAN_NOTICE("You wave the marshalling [wand_invariant] forward quickly, directing the craft to take off."))
		if(LIGHT_COLOR_BLUE)
			user.visible_message(SPAN_NOTICE("[user] holds the marshalling [wand_invariant] close to themselves, deck is idle, don't do any unexpected things!"), SPAN_NOTICE("You hold the marshalling [wand_invariant] close to yourself, signaling an idle stance..."))
		if(LIGHT_COLOR_YELLOW)
			user.visible_message(SPAN_WARNING("[user] holds the marshalling [wand_invariant] out to the sides, indicating that the craft is being checked before lift off, prepare for lift off!"), SPAN_WARNING("You hold the marshalling [wand_invariant] out to your sides, indicating that the craft is being prepared for lift off."))
		if(LIGHT_COLOR_RED)
			user.visible_message(SPAN_WARNING("[user] steadily holds the marshalling [wand_invariant] above their head in a cross! Hold all movement!"), SPAN_WARNING("You hold the marshalling [wand_invariant] in a cross above your head, signaling full stop."))

	update_icon()
	mirror_held_wands(src)

/obj/item/flashlight/marshallingwand/update_icon()
	ClearOverlays()
	var/image/bulb_overlay = overlay_image(icon, "[initial(icon_state)]_[worn_overlay]")
	bulb_overlay.blend_mode = BLEND_OVERLAY
	AddOverlays(bulb_overlay)
	if(on)
		var/image/light_overlay = overlay_image(icon, "marshallingwand-overlay", light_color)
		light_overlay.blend_mode = BLEND_OVERLAY
		AddOverlays(light_overlay)
		set_light_range_power_color(light_range, flashlight_power, light_color)
	set_light_on(on)
	update_held_icon()

/obj/item/flashlight/marshallingwand/proc/mirror_held_wands(var/obj/item/flashlight/marshallingwand/source_wand)
	// If we are holding a wand in the other hand, make sure to mirror the state of this one to it, so that they are always in sync.
	if(ismob(loc))
		var/mob/m = loc
		var/item_act = m.get_active_hand()
		var/item_inact = m.get_inactive_hand()
		if(!item_act || !item_inact || !istype(item_act, /obj/item/flashlight/marshallingwand) || !istype(item_inact, /obj/item/flashlight/marshallingwand))
			return // Only one wand or different item, abort.
		var/obj/item/flashlight/marshallingwand/target_wand
		if(item_act == source_wand) // Check which one needs the update.
			target_wand = item_inact
		else
			target_wand = item_act
		target_wand.on = source_wand.on
		target_wand.set_light_color(source_wand.light_color)
		target_wand.worn_overlay_color = source_wand.worn_overlay_color
		target_wand.update_icon()
