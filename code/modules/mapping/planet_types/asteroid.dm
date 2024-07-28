/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid
	name = "mineral asteroid"
	desc = "A large, resource rich asteroid."
	massvolume = "~0.02"
	surfacegravity = "0.04~"
	surface_color = COLOR_GRAY
	scanimage = "asteroid.png"
	possible_themes = list(/datum/exoplanet_theme/barren/asteroid)
	rock_colors = list(COLOR_ASTEROID_ROCK)
	planetary_area = /area/exoplanet/barren/asteroid
	ruin_planet_type = PLANET_ASTEROID
	ruin_allowed_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_MINING|RUIN_SCIENCE|RUIN_HOSTILE|RUIN_WRECK|RUIN_NATURAL

	place_near_main = list(1, 1)

	unit_test_groups = list(2)

	soil_data = list("Rich aluminium oxide layer", "Rich iron oxide layer", "Rich silver dust layer", "Rich gold dust layer", "Low density silicon dioxide layer", "Large rock particle layer")

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/update_icon()
	icon_state = "asteroid[rand(1,3)]"

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/generate_planet_image()
	skybox_image = image('icons/skybox/skybox_rock_128.dmi', "bigrock")
	skybox_image.color = pick(rock_colors)
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	skybox_image.blend_mode = BLEND_OVERLAY

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/generate_atmosphere()
	atmosphere = null

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/romanovich
	name = "romanovich cloud asteroid"
	desc = "A phoron rich asteroid."
	possible_themes = list(/datum/exoplanet_theme/barren/asteroid/phoron)

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ice
	name = "ice asteroid"
	desc = "A large, mineral-rich asteroid covered in frozen water deposits."
	surface_color = COLOR_BLUE_GRAY
	scanimage = "asteroid.png"
	possible_themes = list(/datum/exoplanet_theme/barren/asteroid/ice)
	rock_colors = list(COLOR_ASH)
	planetary_area = /area/exoplanet/barren/asteroid
	ruin_planet_type = PLANET_ASTEROID
	ruin_allowed_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_MINING|RUIN_SCIENCE|RUIN_HOSTILE|RUIN_WRECK|RUIN_NATURAL
