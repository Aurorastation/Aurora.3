/datum/away_map/iceland
	name = "iceland"
	full_name = "Ice Land"
	path = "iceland"
	weathertypes = list("ice", "hail")
	type_of_map = MAP_AWAY

/datum/away_map/iceland/handle_random_gen()
	new /datum/random_map/noise/tundra(null, 2, 2, zloc, 44, 44)

/area/away_mission/iceland/iceland_outside
	name = "\improper Iceland Outside"
	icon_state = "tcomsatcham" //sprite

/area/away_mission/iceland/iceland_inside
	name = "\improper Iceland Inside"
	icon_state = "tcomsatcham" //sprite