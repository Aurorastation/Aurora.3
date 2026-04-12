/area/port_volturno
	name = "Port Volturno"
	requires_power = 0
	no_light_control = 1
	icon_state = "nature_showcase"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH
	base_turf = /turf/simulated/floor/exoplanet/assunzione
	ambience = AMBIENCE_KONYANG_TRAFFIC
	sound_environment = SOUND_ENVIRONMENT_CITY
	is_outside = OUTSIDE_NO

/area/port_volturno/exterior
	area_blurb = "A vast dome encloses you within the open space; beyond it only is killing cold and darkness, but here, inside, it is warm and bright and welcoming."

/area/port_volturno/interior
	name = "Port Volturno - Interior"
	icon_state = "green"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_HANGAR
	is_outside = OUTSIDE_NO
	area_blurb = "With the interior curvature of the dome out of sight, it's easy to imagine you're on a normal, well-lit temperate world somewhere."

/area/port_volturno/interior/spaceport
	name = "Port Volturno - Spaceport"
	icon_state = "ship"

/area/port_volturno/interior/spaceport/traffic_control
	name = "Port Volturno - Spaceport Traffic Control"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	icon_state = "wizard"

/area/port_volturno/interior/spaceport/security_office
	name = "Port Volturno - Spaceport Security Office"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	icon_state = "security"

//Main city buildings
/area/port_volturno/interior/liquor_store
	name = "Port Volturno - Duty-Free Liquor Store"
	icon_state = "crew_quarters"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/port_volturno/interior/music_store
	name = "Port Volturno - PV|AV"
	icon_state = "party"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/port_volturno/interior/clothing_store
	name = "Port Volturno - Parilti Outfitters"
	icon_state = "party"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/port_volturno/interior/parking
	name = "Port Volturno - Parking Garage"
	area_blurb = "Sounds echo impressively through this space."
	sound_environment = SOUND_AREA_STANDARD_STATION
	icon_state = "dk_yellow"

/area/port_volturno/interior/riad
	name = "Port Volturno - Spaceport Riad"
	icon_state = "bar"

/area/port_volturno/interior/riad/garden
	name = "Port Volturno - AEC Memorial Garden"
	icon_state = "green"

/area/port_volturno/interior/robotics
	name = "Port Volturno - Electromechanics Shop"
	icon_state = "machinist_workshop"

/area/port_volturno/interior/minimart
	name = "Port Volturno - QuikStop"
	icon_state = "merchant"

/area/port_volturno/interior/cafe
	name = "Port Volturno - Cafe"
	icon_state = "cafe"

/area/port_volturno/interior/stafylia
	name = "Port Volturno - Stafylia"
	icon_state = "burglar"

/area/port_volturno/interior/police
	name = "Port Volturno - Zeng-Hu ISD"
	icon_state = "security"

/area/port_volturno/interior/police/overseer
	name = "Port Volturno - Zeng-Hu ISD (Overseer's Office)"
	icon_state = "sec_hos"

/area/port_volturno/interior/police/brig
	name = "Port Volturno - Zeng-Hu ISD (Detention Area)"
	icon_state = "brig"

/area/port_volturno/interior/pool
	name = "Port Volturno - Pool"
	icon_state = "fitness_pool"

/area/port_volturno/interior/clinic
	name = "Port Volturno - Zeng-Hu Clinic"
	icon_state = "morgue"

/area/port_volturno/interior/clinic/pharmacy
	name = "Port Volturno - Zeng-Hu Clinic Pharmacy"
	icon_state = "phar"

/area/port_volturno/interior/clinic/storage
	name = "Port Volturno - Zeng-Hu Clinic Storage"
	icon_state = "toxstorage"

/area/port_volturno/interior/maintenance
	name = "Port Volturno - Maintenance Tunnels"
	icon_state = "green"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience = AMBIENCE_MAINTENANCE
	icon_state = "maintenance"
	area_blurb = "Even the emergency lighting here seems tuned a little brighter than seems strictly necessary."

/area/port_volturno/interior/hotel
	name = "Port Volturno - Hotel"
	icon_state = "locker"
	area_blurb = "Many local vendors either commute to Port Volturno daily or stay in hotels like these."

/area/port_volturno/interior/chapel
	name = "Port Volturno - Saint Alvisiol Chapel"
	icon_state = "chapel"

/area/port_volturno/interior/chapel/office
	name = "Port Volturno - Saint Alvisiol Chapel (Office)"
	icon_state = "chapeloffice"

/area/port_volturno/interior/tram_station
	name = "Port Volturno - Triesto Tram Line"
	icon_state = "ship"
	area_blurb = "The tram stations at Port Volturno serve not only as the fastest link to the rest of Triesto, but also as emergency shelters in the catastrophic event of a dome breach."
