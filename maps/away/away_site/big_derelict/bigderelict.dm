/datum/map_template/ruin/away_site/big_derelict
	name = "large derelict"
	description = "A very large derelict station. According to the starmap, it shouldn't exist."

	prefix = "away_site/big_derelict/"
	suffix = "bigderelict.dmm"

	sectors = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_TABITI, SECTOR_BADLANDS, SECTOR_AEMAQ, ALL_COALITION_SECTORS)
	sectors_blacklist = list(ALL_SPECIFIC_SECTORS)
	spawn_weight = 1
	spawn_cost = 2
	id = "big_derelict"

	unit_test_groups = list(1)

/singleton/submap_archetype/big_derelict
	map = "large derelict"
	descriptor = "A very large derelict station. According to the starmap, it shouldn't exist."

/obj/effect/overmap/visitable/sector/big_derelict
	name = "large derelict"
	desc = "A very large derelict station. The sensor array is picking up large amounts of echo, suggesting large, hollow spaces within. Unknown biological lifesigns have been detected inside the station. There is no starmap record of a station ever being in this location."

/obj/effect/overmap/visitable/sector/big_derelict/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/wrecks.dmi', "debris_large2")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image
