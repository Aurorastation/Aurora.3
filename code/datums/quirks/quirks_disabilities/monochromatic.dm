/datum/quirk/monochromatic
	name = "Monochromacy"
	desc = "You suffer from full colorblindness, and perceive nearly the entire world in blacks and whites."
	icon = FA_ICON_ADJUST
	value = 0
	medical_record_text = "Patient is afflicted with almost complete color blindness."
	category = CATEGORY_DISABILITY

/datum/quirk/monochromatic/add(client/client_source)
	quirk_holder.add_client_color(/datum/client_color/monochrome, QUIRK_TRAIT)

/datum/quirk/monochromatic/remove()
	quirk_holder.remove_client_color(QUIRK_TRAIT)
