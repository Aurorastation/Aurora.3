// explosion logic is in code/controllers/Processes/explosives.dm now

/proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = UP|DOWN, is_rec = config.use_recursive_explosions)
	src = null	//so we don't abort once src is deleted
	if (is_rec)
		var/datum/explosion/recursive/ex = new
		ex.epicenter = epicenter
		ex.adminlog = adminlog
		ex.z_transfer = z_transfer
		ex.power = max(0,devastation_range) * 2 + max(0,heavy_impact_range) + max(0,light_impact_range)
		SSkaboom.queue(ex)
	else
		var/datum/explosion/circular/ex = new
		ex.epicenter = epicenter
		ex.adminlog = adminlog
		ex.z_transfer = z_transfer
		ex.devastation_range = devastation_range
		ex.heavy_impact_range = heavy_impact_range
		ex.light_impact_range = light_impact_range
		SSboom.queue(ex)

// == Recursive Explosions stuff ==

/client/proc/kaboom()
	var/power = input(src, "power?", "power?") as num
	var/turf/T = get_turf(src.mob)
	var/datum/explosion/recursive/ex = new
	ex.epicenter = T
	ex.power = power
	SSkaboom.queue(ex)

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
