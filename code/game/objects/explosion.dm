//TODO: Flash range does nothing currently

proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = UP|DOWN)
	src = null	//so we don't abort once src is deleted
	var/datum/explosiondata/data = new
	data.epicenter = epicenter
	data.devastation_range = devastation_range
	data.heavy_impact_range = heavy_impact_range
	data.light_impact_range = light_impact_range
	data.flash_range = flash_range
	data.adminlog = adminlog
	data.z_transfer = z_transfer

	// queue work
	bomb_processor.queue(data)

proc/secondaryexplosion(turf/epicenter, range)
	for(var/turf/tile in range(range, epicenter))
		tile.ex_act(2)
