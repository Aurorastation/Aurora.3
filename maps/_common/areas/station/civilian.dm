//Crew

/area/crew_quarters
	name = "\improper Dormitories"
	icon_state = "Sleep"
	flags = RAD_SHIELDED
	station_area = 1

/area/sconference_room
	name = "\improper Surface - Conference Room"
	icon_state = "Sleep"
	station_area = 1

/area/crew_quarters/toilet
	name = "\improper Dormitory Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/sleep
	name = "\improper Dormitories"
	icon_state = "Sleep"
	allow_nightmode = 1
	holomap_color = HOLOMAP_AREACOLOR_DORMS

/area/crew_quarters/sleep/engi_wash
	name = "\improper Engineering - Washroom"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/crew_quarters/sleep/bedrooms
	name = "\improper Dormitory Bedroom One"
	icon_state = "Sleep"
	sound_env = SMALL_SOFTFLOOR

/area/crew_quarters/sleep/cryo
	name = "\improper Cryogenic Storage"
	icon_state = "Sleep"

/area/crew_quarters/sleep/main
	name = "\improper Main Level Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/sleep/engineering
	name = "\improper Engineering Dormitories"
	icon_state = "Sleep"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/crew_quarters/sleep/security
	name = "\improper Security Dormitories"
	icon_state = "Sleep"
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/crew_quarters/sleep/research
	name = "\improper Research Dormitories"
	icon_state = "Sleep"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/crew_quarters/sleep/medical
	name = "\improper Medical Dormitories"
	icon_state = "Sleep"
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/crew_quarters/sleep_male
	name = "\improper Male Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep_male/toilet_male
	name = "\improper Male Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/sleep_female
	name = "\improper Female Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep_female/toilet_female
	name = "\improper Female Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/locker
	name = "\improper Locker Room"
	icon_state = "locker"
	allow_nightmode = 1

/area/crew_quarters/locker/locker_toilet
	name = "\improper Main Level Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/fitness
	name = "\improper Fitness Room"
	icon_state = "fitness"
	allow_nightmode = 1

/area/crew_quarters/cafeteria
	name = "\improper Cafeteria"
	icon_state = "cafeteria"

/area/crew_quarters/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"

/area/crew_quarters/bar
	name = "\improper Bar"
	icon_state = "bar"
	sound_env = LARGE_SOFTFLOOR
	allow_nightmode = 1

/area/crew_quarters/theatre
	name = "\improper Theatre"
	icon_state = "Theatre"
	sound_env = LARGE_SOFTFLOOR

/area/library
 	name = "\improper Library"
 	icon_state = "library"
 	sound_env = LARGE_SOFTFLOOR
 	station_area = 1

/area/chapel
 	station_area = 1

/area/chapel/main
	name = "\improper Chapel"
	icon_state = "chapel"
	ambience = list('sound/ambience/ambicha1.ogg','sound/ambience/ambicha2.ogg','sound/ambience/ambicha3.ogg','sound/ambience/ambicha4.ogg','sound/music/traitor.ogg')
	sound_env = LARGE_ENCLOSED

/area/chapel/office
	name = "\improper Chapel Office"
	icon_state = "chapeloffice"

/area/lawoffice
	name = "\improper Internal Affairs"
	icon_state = "law"
	station_area = 1


/area/quartermaster
	name = "\improper Quartermasters"
	icon_state = "quart"
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/quartermaster/office
	name = "\improper Cargo Office"
	icon_state = "quartoffice"

/area/quartermaster/storage
	name = "\improper Cargo Warehouse"
	icon_state = "quartstorage"
	sound_env = LARGE_ENCLOSED

/area/quartermaster/loading
	name = "\improper Cargo Bay"
	icon_state = "quartloading"

/area/quartermaster/qm
	name = "\improper Cargo - Quartermaster's Office"
	icon_state = "quart"

/area/quartermaster/miningdock
	name = "\improper Cargo Mining Dock"
	icon_state = "mining"

/area/janitor/
	name = "\improper Custodial Closet"
	icon_state = "janitor"
	station_area = 1

/area/hydroponics
	name = "\improper Hydroponics"
	icon_state = "hydro"
	no_light_control = TRUE
	station_area = 1

/area/hydroponics/garden
	name = "\improper Garden"
	icon_state = "garden"

/area/store
	name = "\improper Station Store"
	icon_state = "quartstorage"
	station_area = 1

/area/journalistoffice
	name = "\improper Journalist's Office"
	station_area = 1
	sound_env = SMALL_SOFTFLOOR