/obj/item/clothing/glasses/colorable
	name = "colorable glasses"
	desc = "These are glasses."
	icon = 'icons/obj/item/clothing/eyes/colorable_glasses.dmi'
	icon_state = "colorable_glasses"
	item_state = "colorable_glasses"
	icon_override = null
	contained_sprite = TRUE
	update_icon_on_init = TRUE
	var/additional_color = COLOR_GRAY // The default color.

/obj/item/clothing/glasses/colorable/update_icon()
	cut_overlays()
	var/image/frame = image(icon, null, "colorable_glasses_frame")
	frame.appearance_flags = RESET_COLOR|RESET_ALPHA
	frame.color = additional_color
	add_overlay(frame)

/obj/item/clothing/glasses/colorable/build_additional_parts(mob/living/carbon/human/H, mob_icon, slot)
	var/image/image = ..()
	if(slot == slot_glasses_str)
		var/image/frame = image(mob_icon, null, "colorable_glasses_ey_frame")
		frame.appearance_flags = RESET_COLOR|RESET_ALPHA
		frame.color = additional_color
		if(image)
			image.add_overlay(frame)
		else
			image = frame
	return image
