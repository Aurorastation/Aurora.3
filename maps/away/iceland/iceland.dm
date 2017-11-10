/datum/away_map/iceland
	name = "iceland"
	full_name = "Ice Land"
	path = "iceland"
	weathertypes = list("ice", "hail")

/datum/away_map/iceland/handle_random_gen()
	new /datum/random_map/noise/tundra(64321, 2, 2, zloc, 44, 44)
	var/huts = 1
	var/dmm_suite/loader = new
	while(huts)
		loader.load_map(file("maps/away/iceland/iceland_buildings/hut1.dmm"), z_offset = zloc, x_offset = rand(10,40), y_offset = rand(10, 40), no_changeturf = TRUE)
		huts--
	qdel(loader)

/area/away_mission/iceland/iceland_outside
	name = "\improper Iceland Outside"
	icon_state = "tcomsatcham" //sprite

/area/away_mission/iceland/iceland_inside
	name = "\improper Iceland Inside"
	icon_state = "tcomsatcham" //sprite