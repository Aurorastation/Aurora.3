/datum/map_template/ruin/away_site/saniorios_smuggler
	name = "Sani'Orios"
	description = "A gas giant composed of ammonia, Its planetary ring is home to several spaceship wrecks and hidden smuggler bases."
	suffixes = list("away_site/tajara/saniorios_smuggler/saniorios_smuggler.dmm")
	sectors = list(SECTOR_SRANDMARR)
	spawn_weight = 1
	spawn_cost = 2
	id = "saniorios_smuggler"

/singleton/submap_archetype/saniorios_smuggler
	map = "Sani'Orios"
	descriptor = "A gas giant composed of ammonia, Its planetary ring is home to several spaceship wrecks and hidden smuggler bases."

/obj/effect/overmap/visitable/sector/saniorios_smuggler
	name = "Sani'Orios"
	desc = "A gas giant composed of ammonia, Its planetary ring is home to several spaceship wrecks and hidden smuggler bases."
	icon_state = "globe"
	color = COLOR_DARK_BLUE_GRAY

/obj/effect/overmap/visitable/sector/saniorios_smuggler/get_skybox_representation()

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

/area/saniorios_smuggler
	name = "Abandoned Shipping Outpost"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/space
	flags = RAD_SHIELDED