/datum/map_template/ruin/exoplanet/adhomai_war_memorial
	name = "Adhomian War Memorial"
	id = "adhomai_war_memorial"
	description = "A memorial honoring Tajaran soldiers who died in the Second Revolution."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_war_memorial.dmm")

/obj/structure/sign/adhomai_memorial
	name = "memorial rock"
	desc = "A stone monument engraved with the names of soldiers who fought and died in one of the Tajaran civil wars."
	icon = 'icons/effects/64x64.dmi'
	icon_state = "adhomai_memorial"
	density = TRUE
	anchored = TRUE
	pixel_x = -16
	layer = ABOVE_ALL_MOB_LAYER