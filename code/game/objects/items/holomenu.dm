/obj/item/holomenu
	name = "holo-menu"
	desc = "A hologram projector, this one has been set up to display text above itself."
	desc_info = "If you have bar or kitchen access, you can swipe your ID on this to root it in place, then you can click on it with an empty hand to adjust its text. Alt-clicking it will toggle its border."
	icon = 'icons/obj/holomenu.dmi'
	icon_state = "holomenu"

	layer = ABOVE_OBJ_LAYER

	light_color = LIGHT_COLOR_CYAN
	light_range = 1.4

	req_one_access = list(access_bar, access_kitchen)

	var/menu_text = ""
	var/border_on = FALSE

/obj/item/holomenu/update_icon()
	cut_overlays()
	if(anchored)
		set_light(2)
		add_overlay("holomenu-lights")
		if(length(menu_text))
			add_overlay("holomenu-text")
		if(border_on)
			add_overlay("holomenu-border")
	else
		set_light(0)

/obj/item/holomenu/attackby(obj/item/I, mob/user)
	var/obj/item/card/id/ID = I.GetID()
	if(istype(ID))
		if(check_access(ID))
			anchored = !anchored
			to_chat(user, SPAN_NOTICE("You [anchored ? "" : "un"]anchor \the [src]."))
			update_icon()
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return
	return ..()

/obj/item/holomenu/examine(mob/user, distance)
	if(anchored && length(menu_text) && Adjacent(user))
		interact(user)
		return
	return ..()

/obj/item/holomenu/attack_hand(mob/user)
	if(anchored)
		if(allowed(user))
			var/new_text = sanitize(input(user, "Enter new text for the holo-menu to display.", "Holo-Menu Display", html2pencode(menu_text, TRUE)) as null|message)
			if(!isnull(new_text))
				menu_text = pencode2html(new_text)
				update_icon()
		else
			interact(user)
		return
	return ..()

/obj/item/holomenu/interact(mob/user)
	var/datum/browser/holomenu_win = new(user, "holomenu", "Holo-Menu", 450, 500)
	holomenu_win.set_content(menu_text)
	holomenu_win.open()

/obj/item/holomenu/AltClick(mob/user)
	if(Adjacent(user))
		if(allowed(user))
			border_on = !border_on
			to_chat(user, SPAN_NOTICE("You toggle \the [src]'s border to be [border_on ? "on" : "off"]."))
			update_icon()
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return
	return ..()