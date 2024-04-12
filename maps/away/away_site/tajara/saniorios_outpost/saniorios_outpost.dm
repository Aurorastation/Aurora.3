/datum/map_template/ruin/away_site/saniorios_outpost
	name = "Sani'Orios"
	description = "A gas giant composed of ammonia. Its planetary ring is home to several spaceship wrecks and hidden smuggler bases."
	suffixes = list("away_site/tajara/saniorios_outpost/saniorios_outpost.dmm")
	sectors = list(SECTOR_SRANDMARR)
	spawn_weight = 1
	spawn_cost = 2
	id = "saniorios_outpost"
	unit_test_groups = list(1)

/singleton/submap_archetype/saniorios_outpost
	map = "Sani'Orios"
	descriptor = "A gas giant composed of ammonia. Its planetary ring is home to several spaceship wrecks and hidden smuggler bases."

/obj/effect/overmap/visitable/sector/saniorios_outpost
	name = "Sani'Orios"
	desc = "A gas giant composed of ammonia. Its planetary ring is home to several spaceship wrecks and hidden smuggler bases."
	icon_state = "globe3"
	color = COLOR_DARK_BLUE_GRAY

/obj/effect/overmap/visitable/sector/saniorios_outpost/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/planet.dmi', "")

	var/image/base = image('icons/skybox/planet.dmi', "base[pick(1,2,3)]")
	base.color = color
	skybox_image.overlays += base

	var/image/shadow = image('icons/skybox/planet.dmi', "shadow[pick(1,2,3)]")
	shadow.blend_mode = BLEND_MULTIPLY
	skybox_image.overlays += shadow

	var/image/rings = image('icons/skybox/planet_rings.dmi', "dense")
	rings.color = COLOR_ASTEROID_ROCK
	rings.pixel_x = -128
	rings.pixel_y = -128
	skybox_image.overlays += rings

	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	skybox_image.blend_mode = BLEND_OVERLAY
	return skybox_image

/obj/effect/shuttle_landmark/saniorios_outpost
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/saniorios_outpost/nav1
	name = "Sani'Orios Navpoint #1"
	landmark_tag = "nav_hsaniorios_outpost_1"

/obj/effect/shuttle_landmark/saniorios_outpost/nav2
	name = "Sani'OriosNavpoint #2"
	landmark_tag = "nav_hsaniorios_outpost_2"

/obj/effect/shuttle_landmark/saniorios_outpost/nav3
	name = "Sani'Orios Navpoint #3"
	landmark_tag = "nav_hsaniorios_outpost_3"
