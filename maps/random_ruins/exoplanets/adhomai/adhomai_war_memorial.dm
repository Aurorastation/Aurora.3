/datum/map_template/ruin/exoplanet/adhomai_war_memorial
	name = "Adhomian War Memorial"
	id = "adhomai_war_memorial"
	description = "A memorial honoring Tajaran soldiers who died in the Second Revolution."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)

	prefix = "adhomai/"
	suffix = "adhomai_war_memorial.dmm"

	unit_test_groups = list(1)

/obj/structure/sign/adhomai_memorial
	name = "memorial monument"
	desc = "A stone monument engraved with the names of soldiers who fought and died in one of the Tajaran civil wars."
	icon = 'icons/effects/64x64.dmi'
	icon_state = "adhomai_memorial"
	density = TRUE
	anchored = TRUE
	pixel_x = -16
	layer = ABOVE_HUMAN_LAYER
