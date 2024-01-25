//A file for generic event sectors that can be visited regardless of the location of the ship for repeated events.
/datum/space_sector/generic
	name = SECTOR_GENERIC
	description = "Самый обычный сектор. И чего интересного здесь вообще можно найти?"
	skybox_icon = "black_hole"
	starlight_color = COLOR_WHITE

//The star nursery sector. This isn't technically a labelled map sector, but this functions to change the skybox. For use in the idris_cruise event map.
/datum/space_sector/star_nursery
	name = SECTOR_STAR_NURSERY
	description = "Звёздный климат в этой системе крайне непредсказуем, что генерирует невероятной красоты виды, которые попросту невозможно найти в остальной галактике. \
	Изучать это место очень прибыльно, одновременно можно увидеть и смерть и рождение сразу многих звёзд."
	skybox_icon = "star_nursery"
	starlight_color = COLOR_WHITE
