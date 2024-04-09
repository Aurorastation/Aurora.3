/datum/map_template/ruin/away_site/omgolo_tourist
	name = "Omgolo Relaxation Platform"
	description = "A gas giant. Its planetary ring is home to several mining stations, hidden smuggler outposts, and tourist platforms."
	suffixes = list("away_site/uueoaesa/omgolo/omgolo_tourist.dmm")
	sectors = list(SECTOR_UUEOAESA)
	spawn_weight = 1
	spawn_cost = 2
	id = "omgolo_tourist"
	ban_ruins = list(/datum/map_template/ruin/away_site/omgolo_smuggler)
	unit_test_groups = list(2)

/singleton/submap_archetype/omgolo_tourist
	map = "Omgolo Relaxation Platform"
	descriptor = "A gas giant. Its planetary ring is home to several mining stations, hidden smuggler outposts, and tourist platforms."

/obj/effect/overmap/visitable/sector/omgolo_tourist
	name = "Omgolo"
	desc = "A gas giant. Its planetary ring is home to several mining stations, hidden smuggler outposts, and tourist platforms."
	icon_state = "globe3"
	color = "#cf5b02"

/obj/effect/overmap/visitable/sector/omgolo_tourist/get_skybox_representation()
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

/area/omgolo_tourist
	name = "Abandoned Tourism Platform"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/space
	area_flags = AREA_FLAG_RAD_SHIELDED
