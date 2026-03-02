/obj/item/clothing/suit/storage/toggle/highvis
	name = "high visibility jacket"
	desc = "A loose-fitting, high visibility jacket to help the wearer be recognizable in high traffic areas with large industrial equipment."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/highvis.dmi'
	icon_state = "jacket_highvis"
	item_state = "jacket_highvis"
	var/emissive_variant = "plain"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|ARMS
	siemens_coefficient = 0.8
	armor = list(
		MELEE = ARMOR_MELEE_MINOR,
		BIO = ARMOR_BIO_MINOR
	)
	protects_against_weather = TRUE
	fire_resist = T0C+200

/obj/item/clothing/suit/storage/toggle/highvis/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(slot == slot_wear_suit_str)
		var/image/emissive_overlay = emissive_appearance(mob_icon, "[opened ? "jacket_highvis_[emissive_variant]_open_su-emis" : "jacket_highvis_[emissive_variant]_su-emis"]", alpha = src.alpha)
		I.AddOverlays(emissive_overlay)
	return I

/obj/item/clothing/suit/storage/toggle/highvis/colorable
	name = "high visibility jacket"
	desc = "A jacket with reflective stripes. For use in different departments, commonly found in civilian industrial services, in dark or secluded areas where visibility is critical for safety."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/highvis.dmi'
	icon_state = "jacket_highvis_colorable"
	item_state = "jacket_highvis_colorable"
	emissive_variant = "light"
	build_from_parts = TRUE
	worn_overlay = "lining"
	has_accents = TRUE

/obj/item/clothing/suit/storage/toggle/highvis/alt
	icon_state = "jacket_highvis_alt"
	item_state = "jacket_highvis_alt"
	emissive_variant = "light"

/obj/item/clothing/suit/storage/toggle/highvis/red
	icon_state = "jacket_highvis_red"
	item_state = "jacket_highvis_red"
	emissive_variant = "light"

/obj/item/clothing/suit/storage/toggle/highvis/orange
	icon_state = "jacket_highvis_orange"
	item_state = "jacket_highvis_orange"
	emissive_variant = "plain_alt"
