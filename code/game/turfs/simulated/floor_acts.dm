/turf/simulated/floor/ex_act(severity)

	var/severity_mod = ((4-severity)/3)*100 + rand(-33,0)

	if(severity_mod >= 80)
		src.ChangeTurf(baseturf)
		if(prob(33)) new /obj/item/stack/material/steel(src)
	else if(severity_mod >= 33)
		src.break_tile_to_plating()
		src.hotspot_expose(1000,CELL_VOLUME)
	else
		src.break_tile()
		src.hotspot_expose(1000,CELL_VOLUME)

	return

/turf/simulated/floor/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)

	var/temp_destroy = get_damage_temperature()
	if(!burnt && prob(5))
		burn_tile(exposed_temperature)
	else if(temp_destroy && exposed_temperature >= (temp_destroy + 100) && prob(1) && !is_plating())
		make_plating() //destroy the tile, exposing plating
		burn_tile(exposed_temperature)
	return

//should be a little bit lower than the temperature required to destroy the material
/turf/simulated/floor/proc/get_damage_temperature()
	return flooring ? flooring.damage_temperature : null

/turf/simulated/floor/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	var/dir_to = get_dir(src, adj_turf)

	for(var/obj/structure/window/W in src)
		if(W.dir == dir_to || W.is_fulltile()) //Same direction or diagonal (full tile)
			W.fire_act(adj_air, adj_temp, adj_volume)
