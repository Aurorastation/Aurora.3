/datum/random_map/noise/fauna
	descriptor = "cave fauna"
	smoothing_iterations = 1
	wall_type =  null
	floor_type = null

/datum/random_map/noise/fauna/get_appropriate_path(var/value)
	return

/datum/random_map/noise/fauna/get_map_char(var/value)
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
		if(5)
			return "<font color='#88DD00'>[pick(list(".",","))]</font>"
		if(6)
			return "<font color='#99EE00'>[pick(list(".",","))]</font>"
		if(7)
			return "<font color='#00BB00'>[pick(list("T","t"))]</font>"
		if(8)
			return "<font color='#00DD00'>[pick(list("T","t"))]</font>"
		if(9)
			return "<font color='#00FF00'>[pick(list("T","t"))]</font>"

/datum/random_map/noise/fauna/get_additional_spawns(var/value, var/turf/T)

	var/area/turf_area = get_area(T)
	if(turf_area in the_station_areas)
		return
	if(T.density)
		return
	if(istype(T,/turf/simulated/open) || istype(T,/turf/space))
		return

	var/val = min(9,max(0,round((value/cell_range)*10)))
	if(isnull(val)) val = 0
	switch(val)
		if(2)
			if(prob(60))
				new /obj/effect/spawner/caverns/ambush(T)
		if(6)
			if(prob(60))
				new /obj/effect/spawner/caverns/ambush(T)
			else if(prob(30))
				new /obj/effect/spawner/caverns/nest(T)
		if(7)
			if(prob(30))
				new /obj/effect/spawner/caverns/ambush(T)
			else if(prob(30))
				new /obj/effect/spawner/caverns/sarlacc(T)
			else if(prob(30))
				new /obj/effect/spawner/caverns/nest(T)
		if(8)
			if(prob(45))
				new /obj/effect/spawner/caverns/ambush(T)
			else if(prob(30))
				new /obj/effect/spawner/caverns/nest(T)
			else if(prob(30))
				new /obj/effect/spawner/caverns/sarlacc(T)
		if(9)
			new /obj/effect/spawner/caverns/ambush(T)

////SPAWNERS////
/obj/effect/spawner/caverns
	icon = 'icons/mob/screen1.dmi'
	var/spawner_type
	var/claustrophobia = 6

/obj/effect/spawner/caverns/sarlacc
	icon_state = "x"

/obj/effect/spawner/caverns/initialize()
	for(var/obj/effect/spawner/caverns/C in orange(src,1))
		qdel(src)
		return

	for(var/obj/effect/spawner/caverns/C in orange(src,claustrophobia))
		if(istype(C,src.type))
			qdel(src)
			return
	..()

/obj/effect/spawner/caverns/nest
	icon_state = "x2"
	claustrophobia = 10

/obj/effect/spawner/caverns/ambush
	icon_state = "x3"
	claustrophobia = 2