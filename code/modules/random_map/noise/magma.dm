/datum/random_map/noise/magma
	descriptor = "magma"
	smoothing_iterations = 1

/datum/random_map/noise/magma/replace_space
	descriptor = "magma (replacement)"
	target_turf_type = /turf/space

/datum/random_map/noise/magma/get_map_char(var/value)
	var/val = min(9,max(0,round((value/cell_range)*10)))
	if(isnull(val)) val = 0
	switch(val)
		if(0)
			return "<font color='#000099'>~</font>"
		if(1)
			return "<font color='#0000BB'>~</font>"
		if(2)
			return "<font color='#0000DD'>~</font>"
		if(3)
			return "<font color='#66AA00'>[pick(list(".",","))]</font>"
		if(4)
			return "<font color='#77CC00'>[pick(list(".",","))]</font>"

/datum/random_map/noise/magma/get_appropriate_path(var/value)
	var/val = min(9,max(0,round((value/cell_range)*10)))
	if(isnull(val)) val = 0
	switch(val)
		if(0 to 4)
			return /turf/simulated/lava
		else
			return /turf/simulated/floor/asteroid/basalt
