#define BASE_COLOR "Base Color"
#define ACCENT_COLOR "Accent Color"

// Only works for clothes that are already recolorable.
/obj/item/device/clothes_dyer
	name = "clothes dyer"
	desc = "This is a device designed to rapidly dye clothes to new colors. Naysayers say it isn't great for the fabric, but what do they know?"
	icon = 'icons/obj/item/device/paint_sprayer.dmi'
	icon_state = "paint_sprayer"
	item_state = "paint_sprayer"
	/// Controls whether the dyer changes the primary or accent color of the clothes item.
	var/selected_mode = BASE_COLOR
	/// Contains the colors the dyer is set to for each possible mode.
	var/list/colors_by_mode = list(BASE_COLOR = "#FFFFFF", ACCENT_COLOR = "#FFFFFF")

/obj/item/device/clothes_dyer/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Select the desired color by using the item on yourself, and alternate between the primary and secondary colour of the item by alt-clicking the item. This only works on clothing items that are recolorable."

// Changes the color of the selected mode.
/obj/item/device/clothes_dyer/attack_self(mob/user)
	var/selected_color = input(user, "Please select dye color.", "Dye Color", colors_by_mode[selected_mode]) as color|null
	if (!selected_color)
		return

	colors_by_mode[selected_mode] = selected_color
	to_chat(user, SPAN_NOTICE("You adjust the color of <span style='color:[selected_color]'>[selected_mode]</span>."))

// Switches the mode.
/obj/item/device/clothes_dyer/AltClick(mob/user)
	if (!Adjacent(user))
		return

	var/new_selected_mode = tgui_input_list(user, "Please select which clothing aspect you would like to dye.", "Dyeing Mode", colors_by_mode, selected_mode)
	if (!new_selected_mode)
		return

	selected_mode = new_selected_mode
	to_chat(user, SPAN_NOTICE("You adjust the mode of the clothes dyer to <span style='color:[colors_by_mode[new_selected_mode]]'>[new_selected_mode]</span>."))

// Changes the color on clothing.
/obj/item/device/clothes_dyer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if (!proximity_flag)
		return

	if (!isclothing(target))
		return

	var/obj/item/clothing/target_clothing = target

	playsound(get_turf(target), 'sound/effects/spray3.ogg', 30, TRUE, -6)
	switch(selected_mode)
		if (BASE_COLOR)
			target_clothing.color = colors_by_mode[selected_mode]
		if (ACCENT_COLOR)
			target_clothing.accent_color = colors_by_mode[selected_mode]
	target_clothing.update_icon()
	target_clothing.update_clothing_icon()
	to_chat(user, SPAN_NOTICE("You dye the clothing."))

#undef BASE_COLOR
#undef ACCENT_COLOR
