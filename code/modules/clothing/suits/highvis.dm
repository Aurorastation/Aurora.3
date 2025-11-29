/obj/item/clothing/suit/storage/toggle/highvis
	name = "high visibility jacket"
	desc = "A loose-fitting, high visibility jacket to help the wearer be recognizable in high traffic areas with large industrial equipment."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/highvis.dmi'
	icon_state = "jacket_highvis"
	item_state = "jacket_highvis"
	body_parts_covered = UPPER_TORSO|ARMS
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/highvis/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(slot == slot_wear_suit_str)
		var/image/emissive_overlay = emissive_appearance(mob_icon, "[opened ? "jacket_highvis_open_su-emis" : "jacket_highvis_su-emis"]", alpha = src.alpha)
		I.AddOverlays(emissive_overlay)
	return I

/obj/item/clothing/suit/storage/toggle/highvis/alt
	name = "high visibility jacket"
	desc = "A bright yellow jacket with reflective stripes. For use in operations, engineering, and sometimes even law enforcement, in cold and poor weather or when visibility is low."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/highvis.dmi'
	icon_state = "jacket_highvis_alt"
	item_state = "jacket_highvis_alt"
	body_parts_covered = UPPER_TORSO|ARMS
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/highvis/alt/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(slot == slot_wear_suit_str)
		var/image/emissive_overlay = emissive_appearance(mob_icon, "[opened ? "jacket_highvis_alt_open_su-emis" : "jacket_highvis_alt_su-emis"]", alpha = src.alpha)
		I.AddOverlays(emissive_overlay)
	return I

/obj/item/clothing/suit/storage/toggle/highvis/red
	name = "high visibility jacket"
	desc = "A red jacket with reflective stripes. For use in different departments, commonly found in civilian emergency services, in cold and poor weather or when visibility is low."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/highvis.dmi'
	icon_state = "jacket_highvis_red"
	item_state = "jacket_highvis_red"
	body_parts_covered = UPPER_TORSO|ARMS
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/highvis/red/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(slot == slot_wear_suit_str)
		var/image/emissive_overlay = emissive_appearance(mob_icon, "[opened ? "jacket_highvis_red_open_su-emis" : "jacket_highvis_red_su-emis"]", alpha = src.alpha)
		I.AddOverlays(emissive_overlay)
	return I

/obj/item/clothing/suit/storage/toggle/highvis/orange
	name = "high visibility jacket"
	desc = "An orange jacket with reflective stripes. For use in different departments, commonly found in civilian industrial services, in dark or secluded areas where visibility is critical for safety."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/highvis.dmi'
	icon_state = "jacket_highvis_orange"
	item_state = "jacket_highvis_orange"
	body_parts_covered = UPPER_TORSO|ARMS
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/highvis/orange/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(slot == slot_wear_suit_str)
		var/image/emissive_overlay = emissive_appearance(mob_icon, "[opened ? "jacket_highvis_orange_open_su-emis" : "jacket_highvis_orange_su-emis"]", alpha = src.alpha)
		I.AddOverlays(emissive_overlay)
	return I
