// explosion logic is in code/controllers/Processes/explosives.dm now

/proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = UP|DOWN, spreading = config.use_spreading_explosions)
	UNLINT(src = null)	//so we don't abort once src is deleted
	var/datum/explosiondata/data = new
	data.epicenter = epicenter
	data.devastation_range = devastation_range
	data.heavy_impact_range = heavy_impact_range
	data.light_impact_range = light_impact_range
	data.flash_range = flash_range
	data.adminlog = adminlog
	data.z_transfer = z_transfer
	data.spreading = spreading
	data.rec_pow = max(0,devastation_range) * 2 + max(0,heavy_impact_range) + max(0,light_impact_range)

	// queue work
	SSexplosives.queue(data)

	//Machines which report explosions.
	for(var/i,i<=doppler_arrays.len,i++)
		var/obj/machinery/doppler_array/Array = doppler_arrays[i]
		if(Array)
			var/x0 = epicenter.x
			var/y0 = epicenter.y
			var/z0 = epicenter.z
			Array.sense_explosion(x0,y0,z0,devastation_range,heavy_impact_range,light_impact_range)

// == Recursive Explosions stuff ==

/client/proc/kaboom()
	var/power = input(src, "power?", "power?") as num
	var/turf/T = get_turf(src.mob)
	var/datum/explosiondata/d = new
	d.spreading = TRUE
	d.epicenter = T
	d.rec_pow = power
	SSexplosives.queue(d)

/atom
	var/explosion_resistance

/turf/space
	explosion_resistance = 3

/turf/simulated/open
	explosion_resistance = 3

/turf/simulated/floor
	explosion_resistance = 1

/turf/simulated/mineral
	explosion_resistance = 2

/turf/simulated/wall
	explosion_resistance = 10
