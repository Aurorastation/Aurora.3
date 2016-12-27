// explosion logic is in code/controllers/Processes/explosives.dm now

proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = UP|DOWN, is_rec = config.use_recursive_explosions)
	src = null	//so we don't abort once src is deleted
	var/datum/explosiondata/data = new
	data.epicenter = epicenter
	data.devastation_range = devastation_range
	data.heavy_impact_range = heavy_impact_range
	data.light_impact_range = light_impact_range
	data.flash_range = flash_range
	data.adminlog = adminlog
	data.z_transfer = z_transfer
	data.is_rec = is_rec

	// queue work
	bomb_processor.queue(data)

// == Recursive Explosions stuff ==

/client/proc/kaboom()
	var/power = input(src, "power?", "power?") as num
	var/turf/T = get_turf(src.mob)
	var/datum/explosiondata/d = new
	d.is_rec = 1
	d.epicenter = T
	d.rec_pow = power
	bomb_processor.queue(d)

/obj
	var/explosion_resistance

/turf
	var/explosion_resistance

/turf/space
	explosion_resistance = 3

/turf/simulated/floor
	explosion_resistance = 1

/turf/simulated/mineral
	explosion_resistance = 2

/turf/simulated/shuttle/floor
	explosion_resistance = 1

/turf/simulated/shuttle/floor4
	explosion_resistance = 1

/turf/simulated/shuttle/plating
	explosion_resistance = 1

/turf/simulated/shuttle/wall
	explosion_resistance = 10

/turf/simulated/wall
	explosion_resistance = 10