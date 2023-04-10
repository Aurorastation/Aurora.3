/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid
	name = "mineral asteroid"
	desc = "A large, resource rich asteroid."
	surface_color = COLOR_GRAY
	map_generators = list()
	possible_themes = list(/datum/exoplanet_theme/barren/asteroid)
	rock_colors = list(COLOR_ASTEROID_ROCK)
	planetary_area = /area/exoplanet/barren/asteroid

	possible_random_ruins = list(
		/datum/map_template/ruin/exoplanet/abandoned_mining,
		/datum/map_template/ruin/exoplanet/hideout,
		/datum/map_template/ruin/exoplanet/crashed_shuttle_01,
		/datum/map_template/ruin/exoplanet/crashed_sol_shuttle_01,
		/datum/map_template/ruin/exoplanet/crashed_skrell_shuttle_01,
		/datum/map_template/ruin/exoplanet/mystery_ship_1,
		/datum/map_template/ruin/exoplanet/crashed_satelite,
		/datum/map_template/ruin/exoplanet/abandoned_listening_post,
		/datum/map_template/ruin/exoplanet/crashed_escape_pod_1,
		/datum/map_template/ruin/exoplanet/digsite,
		/datum/map_template/ruin/exoplanet/crashed_pod,
		/datum/map_template/ruin/exoplanet/crashed_coc_skipjack,
		/datum/map_template/ruin/exoplanet/carp_nest,
		/datum/map_template/ruin/exoplanet/drill_site)
	place_near_main = list(1, 1)

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/update_icon()
  icon_state = "asteroid[rand(1,3)]"

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/generate_planet_image()
	skybox_image = image('icons/skybox/skybox_rock_128.dmi', "bigrock")
	skybox_image.color = pick(rock_colors)
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	skybox_image.blend_mode = BLEND_OVERLAY

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/romanovich
	name = "romanovich cloud asteroid"
	desc = "A phoron rich asteroid."
	possible_themes = list(/datum/exoplanet_theme/barren/asteroid/phoron)
