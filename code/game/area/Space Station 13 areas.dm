/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)

*/

/*-----------------------------------------------------------------------------*/

/////////
//SPACE//
/////////

/area/space
	name = "Space"
	icon_state = "space"
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = 1
	power_light = 0
	power_equip = 0
	power_environ = 0
	ambience = list('sound/ambience/ambispace.ogg','sound/music/title2.ogg','sound/music/space.ogg','sound/music/main.ogg','sound/music/traitor.ogg')
	no_light_control = 1
	base_turf = /turf/space

area/space/atmosalert()
	return

/area/space/fire_alert()
	return

/area/space/fire_reset()
	return

/area/space/readyalert()
	return

/area/space/partyalert()
	return

/area/arrival
	requires_power = 0
	no_light_control = 1

/area/arrival/start
	name = "\improper Arrival Area"
	icon_state = "start"

/area/admin
	name = "\improper Admin room"
	icon_state = "start"


////////////
//SHUTTLES//
////////////
//shuttle areas must contain at least two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.
//All shuttles should now be under shuttle since we have smooth-wall code.

/area/shuttle
	requires_power = 0
	sound_env = SMALL_ENCLOSED
	no_light_control = 1
	flags = SPAWN_ROOF

/area/shuttle/arrival
	name = "\improper Arrival Shuttle"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/arrival/centcom
	icon_state = "shuttle2"
	base_turf = /turf/unsimulated/floor
	centcomm_area = 1

/area/shuttle/arrival/centcom/Entered(atom/movable/Obj, atom/oldLoc)
	. = ..()
	if (!istype(Obj, /mob/living) || !SSarrivals)
		return

	SSarrivals.on_hotzone_enter(Obj)

/area/shuttle/arrival/centcom/Exited(atom/movable/Obj, atom/newLoc)
	. = ..()
	if (!istype(Obj, /mob/living) || !SSarrivals)
		return

	SSarrivals.on_hotzone_exit(Obj)

/area/shuttle/arrival/transit
	icon_state = "shuttle2"
	centcomm_area = 1

/area/shuttle/arrival/station
	icon_state = "shuttle"
	base_turf = /turf/simulated/floor/asteroid
	station_area = 1

/area/shuttle/escape
	name = "\improper Emergency Shuttle"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/escape/station
	name = "\improper Emergency Shuttle Station"
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/asteroid
	station_area = 1

/area/shuttle/escape/centcom
	name = "\improper Emergency Shuttle Centcom"
	icon_state = "shuttle"
	base_turf = /turf/unsimulated/floor
	centcomm_area = 1

/area/shuttle/escape/transit // the area to pass through for 3 minute transit
	name = "\improper Emergency Shuttle Transit"
	icon_state = "shuttle"
	centcomm_area = 1

/area/shuttle/escape_pod1
	name = "\improper Escape Pod One"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/escape_pod1/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/asteroid
	station_area = 1

/area/shuttle/escape_pod1/centcom
	icon_state = "shuttle"
	base_turf = /turf/space
	centcomm_area = 1

/area/shuttle/escape_pod1/transit
	icon_state = "shuttle"
	centcomm_area = 1

/area/shuttle/escape_pod2
	name = "\improper Escape Pod Two"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/escape_pod2/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/asteroid
	station_area = 1

/area/shuttle/escape_pod2/centcom
	icon_state = "shuttle"
	base_turf = /turf/space
	centcomm_area = 1

/area/shuttle/escape_pod2/transit
	icon_state = "shuttle"
	centcomm_area = 1

/area/shuttle/escape_pod3
	name = "\improper Escape Pod Three"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/escape_pod3/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/asteroid
	station_area = 1

/area/shuttle/escape_pod3/centcom
	icon_state = "shuttle"
	base_turf = /turf/space
	centcomm_area = 1

/area/shuttle/escape_pod3/transit
	icon_state = "shuttle"
	centcomm_area = 1

/area/shuttle/escape_pod5 //Pod 4 was lost to meteors
	name = "\improper Escape Pod Five"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/escape_pod5/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/asteroid
	station_area = 1

/area/shuttle/escape_pod5/centcom
	icon_state = "shuttle"
	base_turf = /turf/space
	centcomm_area = 1

/area/shuttle/escape_pod5/transit
	icon_state = "shuttle"
	centcomm_area = 1

/area/shuttle/mining
	name = "\improper Mining Shuttle"

/area/shuttle/mining/station
	icon_state = "shuttle2"
	station_area = 1

/area/shuttle/mining/outpost
	icon_state = "shuttle"
	station_area = 1

/area/shuttle/transport1/centcom
	icon_state = "shuttle"
	name = "\improper Transport Shuttle Centcom"
	base_turf = /turf/unsimulated/floor
	centcomm_area = 1

/area/shuttle/transport1/station
	icon_state = "shuttle"
	name = "\improper Transport Shuttle"
	base_turf = /turf/simulated/floor/asteroid
	station_area = 1

/area/shuttle/specops/centcom
	name = "\improper Special Ops Shuttle"
	flags = RAD_SHIELDED | SPAWN_ROOF
	base_turf = /turf/unsimulated/floor
	icon_state = "shuttlered"
	centcomm_area = 1

/area/shuttle/specops/station
	icon_state = "shuttlered2"
	base_turf = /turf/simulated/floor/asteroid
	station_area = 1

/area/shuttle/syndicate_elite
	name = "\improper Merc Elite Shuttle"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/syndicate_elite/mothership
	icon_state = "shuttlered"
	centcomm_area = 1

/area/shuttle/syndicate_elite/station
	icon_state = "shuttlered2"
	base_turf = /turf/simulated/floor/asteroid
	station_area = 1

/area/shuttle/administration
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/administration/centcom
	name = "\improper Administration Shuttle Centcom"
	icon_state = "shuttlered"
	base_turf = /turf/unsimulated/floor
	centcomm_area = 1

/area/shuttle/administration/station
	name = "\improper Administration Shuttle"
	icon_state = "shuttlered2"
	base_turf = /turf/simulated/floor/asteroid
	station_area = 1

/area/shuttle/research
	name = "\improper Research Shuttle"

/area/shuttle/research/station
	icon_state = "shuttle2"
	station_area = 1

/area/shuttle/research/outpost
	icon_state = "shuttle"
	station_area = 1

// CENTCOM

/area/prison/solitary
	name = "\improper CentComm Solitary Confinement"
	icon_state = "brig"
	centcomm_area = 1

/area/centcom
	name = "\improper Centcom"
	icon_state = "centcom"
	requires_power = 0
	no_light_control = 1
	base_turf = /turf/unsimulated/floor
	centcomm_area = 1

/area/centcom/control
	name = "\improper Centcom Control"

/area/centcom/spawning
	name = "\improper Centcom Preparatory Wing"

/area/centcom/evac
	name = "\improper Centcom Emergency Shuttle"

/area/centcom/suppy
	name = "\improper Centcom Supply Shuttle"

/area/centcom/ferry
	name = "\improper Centcom Transport Shuttle"

/area/centcom/shuttle
	name = "\improper Centcom Administration Shuttle"

/area/centcom/test
	name = "\improper Centcom Testing Facility"

/area/centcom/living
	name = "\improper Centcom Living Quarters"

/area/centcom/specops
	name = "\improper Centcom Special Ops"

/area/centcom/creed
	name = "Creed's Office"

/area/centcom/holding
	name = "\improper Holding Facility"

//SYNDICATES

/area/syndicate_mothership
	name = "\improper Mercenary Base"
	icon_state = "syndie-ship"
	requires_power = 0
	dynamic_lighting = 0
	no_light_control = 1
	centcomm_area = 1

/area/syndicate_mothership/control
	name = "\improper Mercenary Control Room"
	icon_state = "syndie-control"

/area/syndicate_mothership/elite_squad
	name = "\improper Elite Mercenary Squad"
	icon_state = "syndie-elite"

/area/syndicate_mothership/raider_base
	name = "\improper Pirate Hideout"
	icon_state = "syndie-control"
	dynamic_lighting = 1

//EXTRA

/area/asteroid					// -- TLE
	name = "\improper Moon"
	icon_state = "asteroid"
	requires_power = 0
	sound_env = ASTEROID
	no_light_control = 1

/area/asteroid/cave				// -- TLE
	name = "\improper Moon - Underground"
	icon_state = "cave"
	requires_power = 0
	sound_env = ASTEROID

/area/asteroid/artifactroom
	name = "\improper Moon - Artifact"
	icon_state = "cave"
	sound_env = SMALL_ENCLOSED

/area/tdome
	name = "\improper Thunderdome"
	icon_state = "thunder"
	requires_power = 0
	dynamic_lighting = 0
	sound_env = ARENA
	no_light_control = 1
	centcomm_area = 1

/area/tdome/tdome1
	name = "\improper Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "\improper Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomeadmin
	name = "\improper Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "\improper Thunderdome (Observer.)"
	icon_state = "purple"

//ACTORS GUILD
/area/acting
	name = "\improper Centcom Acting Guild"
	icon_state = "red"
	dynamic_lighting = 0
	requires_power = 0
	no_light_control = 1
	centcomm_area = 1

/area/acting/backstage
	name = "\improper Backstage"

/area/acting/stage
	name = "\improper Stage"
	dynamic_lighting = 1
	icon_state = "yellow"


//ENEMY

//names are used
/area/syndicate_station
	name = "\improper Independent Station"
	icon_state = "yellow"
	requires_power = 0
	flags = RAD_SHIELDED | SPAWN_ROOF
	no_light_control = 1

/area/syndicate_station/start
	name = "\improper Mercenary Forward Operating Base"
	icon_state = "yellow"
	centcomm_area = 1
	base_turf = /turf/space

/area/syndicate_station/surface
	name = "\improper Surface of the Station"
	icon_state = "southwest"
	station_area = 1
	base_turf = /turf/simulated/floor/asteroid

/area/syndicate_station/above
	name = "\improper Above the Station"
	icon_state = "northwest"

/area/syndicate_station/under
	name = "\improper Under the Station"
	icon_state = "northeast"

/area/syndicate_station/caverns
	name = "\improper Caverns"
	icon_state = "southeast"
	base_turf = /turf/simulated/floor/asteroid

/area/syndicate_station/arrivals_dock
	name = "\improper Docked with Station"
	icon_state = "shuttle"
	station_area = 1
	base_turf = /turf/simulated/floor/asteroid

/area/syndicate_station/transit
	name = "\improper Hyperspace"
	icon_state = "shuttle"
	centcomm_area = 1

/area/wizard_station
	name = "\improper Wizard's Den"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 0
	no_light_control = 1
	centcomm_area = 1

/area/skipjack_station
	name = "\improper Skipjack"
	icon_state = "yellow"
	requires_power = 0
	no_light_control = 1
	base_turf = /turf/space
	flags = SPAWN_ROOF

/area/skipjack_station/start
	name = "\improper Skipjack"
	icon_state = "yellow"
	centcomm_area = 1

/area/skipjack_station/transit
	name = "\improper Hyperspace"
	icon_state = "shuttle"
	centcomm_area = 1

/area/skipjack_station/surface
	name = "\improper Surface of the Station"
	icon_state = "southwest"
	station_area = 1
	base_turf = /turf/simulated/floor/asteroid

/area/skipjack_station/above
	name = "\improper Above the Station"
	icon_state = "northwest"

/area/skipjack_station/under
	name = "\improper Under the Station"
	icon_state = "northeast"

/area/skipjack_station/cavern
	name = "\improper Caverns"
	icon_state = "southeast"
	base_turf = /turf/simulated/floor/asteroid

////////////////////
//SPACE STATION 13//
////////////////////

//Maintenance


/area/maintenance
	flags = RAD_SHIELDED | HIDE_FROM_HOLOMAP
	sound_env = TUNNEL_ENCLOSED
	turf_initializer = new /datum/turf_initializer/maintenance()
	ambience = list(
		'sound/ambience/ambimaint1.ogg',
		'sound/ambience/ambimaint2.ogg',
		'sound/ambience/ambimaint3.ogg',
		'sound/ambience/ambimaint4.ogg',
		'sound/ambience/ambimaint5.ogg'
	)
	station_area = 1

/area/maintenance/civ
	name = "\improper Civilian Maintenance"
	icon_state = "maintcentral"

/area/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/starboard
	name = "Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/port
	name = "Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/atmos_control
	name = "Atmospherics Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fpmaint
	name = "Fore Port Maintenance - 1"
	icon_state = "fpmaint"

/area/maintenance/fpmaint2
	name = "Fore Port Maintenance - 2"
	icon_state = "fpmaint"

/area/maintenance/fsmaint
	name = "Fore Starboard Maintenance - 1"
	icon_state = "fsmaint"

/area/maintenance/fsmaint2
	name = "Fore Starboard Maintenance - 2"
	icon_state = "fsmaint"

/area/maintenance/asmaint
	name = "Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/engi_shuttle
	name = "Engineering Shuttle Access"
	icon_state = "maint_e_shuttle"

/area/maintenance/engi_engine
	name = "Engine Maintenance"
	icon_state = "maint_engine"

/area/maintenance/asmaint2
	name = "Science Maintenance"
	icon_state = "asmaint"

/area/maintenance/apmaint
	name = "Cargo Maintenance"
	icon_state = "apmaint"

/area/maintenance/maintcentral
	name = "Bridge Maintenance"
	icon_state = "maintcentral"

/area/maintenance/arrivals
	name = "Surface Maintenance"
	icon_state = "maint_arrivals"

/area/maintenance/bar
	name = "Bar Maintenance"
	icon_state = "maint_bar"

/area/maintenance/cargo
	name = "Cargo Maintenance"
	icon_state = "maint_cargo"

/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/maintenance/engineering
	name = "Engineering Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/sublevel
	name = "Sub-level Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/evahallway
	name = "\improper EVA Maintenance"
	icon_state = "maint_eva"

/area/maintenance/solarmaint
	name = "\improper Surface - Solar Maintenance"
	icon_state = "maint_eva"
	base_turf = /turf/space

/area/maintenance/dormitory
	name = "Dormitory Maintenance"
	icon_state = "maint_dormitory"

/area/maintenance/incinerator
	name = "\improper Incinerator"
	icon_state = "disposal"

/area/maintenance/library
	name = "Library Maintenance"
	icon_state = "maint_library"

/area/maintenance/locker
	name = "Locker Room Maintenance"
	icon_state = "maint_locker"

/area/maintenance/medbay
	name = "Medbay Maintenance"
	icon_state = "maint_medbay"

/area/maintenance/research_port
	name = "Research Maintenance - Port"
	icon_state = "maint_research_port"

/area/maintenance/research_starboard
	name = "Research Maintenance - Starboard"
	icon_state = "maint_research_starboard"

/area/maintenance/research_shuttle
	name = "Research Shuttle Dock Maintenance"
	icon_state = "maint_research_shuttle"

/area/maintenance/security_port
	name = "Security Maintenance - Port"
	icon_state = "maint_security_port"

/area/maintenance/security_starboard
	name = "Security Maintenance - Starboard"
	icon_state = "maint_security_starboard"

/area/maintenance/storage
	name = "Atmospherics"
	icon_state = "green"

// SUBSTATIONS (Subtype of maint, that should let them serve as shielded area during radstorm)

/area/maintenance/substation
	name = "Substation"
	icon_state = "substation"
	sound_env = SMALL_ENCLOSED

/area/maintenance/substation/engineering // Probably will be connected to engineering SMES room, as wires cannot be crossed properly without them sharing powernets.
	name = "Engineering Substation"

// No longer used:
/area/maintenance/substation/medical_science // Medbay and Science. Each has it's own separated machinery, but it originates from the same room.
	name = "Medical Research Substation"

/area/maintenance/substation/medical // Medbay
	name = "Main Lvl. Medical Substation"

/area/maintenance/substation/research // Research
	name = "Main Lvl. Research Substation"

/area/maintenance/substation/civilian_east // Bar, kitchen, dorms, ...
	name = "Surface Lvl. Civilian Substation"

/area/maintenance/substation/civilian_west // Cargo, PTS, locker room, probably arrivals, ...)
	name = "Main Lvl. Civilian Substation"

/area/maintenance/substation/command // AI and central cluster. This one will be between HoP office and meeting room (probably).
	name = "Command Substation"

/area/maintenance/substation/security // Security, Brig, Permabrig, etc.
	name = "Security Substation"




//Hallway

/area/hallway
	sound_env = LARGE_ENCLOSED
	allow_nightmode = 1
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/hallway/primary/fore
	name = "\improper Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "\improper Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/aft
	name = "\improper Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/port
	name = "\improper Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/central_one
	name = "\improper Central Primary Hallway"
	icon_state = "hallC1"

/area/hallway/primary/central_two
	name = "\improper Central Primary Hallway"
	icon_state = "hallC2"

/area/hallway/primary/central_three
	name = "\improper Central Primary Hallway"
	icon_state = "hallC3"

/area/hallway/secondary/exit
	name = "\improper Surface - Red Dock"
	icon_state = "escape"
	no_light_control = 1
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

/area/hallway/secondary/construction
	name = "\improper Construction Area"
	icon_state = "construction"
	allow_nightmode = 0

/area/hallway/secondary/entry/fore
	name = "\improper Surface Lvl. Hallway Fore"
	icon_state = "entry_1"

/area/hallway/secondary/entry/port
	name = "\improper Surface - Yellow Dock"
	icon_state = "entry_2"

/area/hallway/secondary/entry/starboard
	name = "\improper Arrival Shuttle Hallway - Starboard"
	icon_state = "entry_3"

/area/hallway/secondary/entry/aft
	name = "\improper Surface Lvl. Hallway Aft"
	icon_state = "entry_4"

/area/hallway/secondary/entry/dock
	name = "\improper Surface - Blue Dock"
	icon_state = "arrivals_dock"
	holomap_color = HOLOMAP_AREACOLOR_ARRIVALS

//Command

/area/bridge
	name = "\improper Bridge"
	icon_state = "bridge"
	no_light_control = 1
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/bridge/minibar
    name = "\improper Command Break Room"
    icon_state = "bridge"

/area/bridge/ailobby
    name = "\improper AI Elevator Access"
    icon_state = "ai_foyer"

/area/bridge/aibunker
    name = "\improper Command - Bunker"
    icon_state = "ai_foyer"

/area/bridge/centcom_meetingroom
    name = "\improper Level A Meeting Room"
    icon_state = "bridge"

/area/bridge/levela
    name = "\improper Surface - Bridge"
    icon_state = "bridge"

/area/crew_quarters/heads/cryo
    name = "\improper Command - Dormitory"
    icon_state = "head_quarters"

/area/bridge/meeting_room
	name = "\improper Command - Conference Room"
	icon_state = "bridge"
	ambience = list()
	sound_env = MEDIUM_SOFTFLOOR

/area/crew_quarters/captain
	name = "\improper Command - Captain's Office"
	icon_state = "captain"
	sound_env = MEDIUM_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/crew_quarters/heads
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/crew_quarters/heads/hop
	name = "\improper Command - HoP's Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/hor
	name = "\improper Research - RD's Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/chief
	name = "\improper Engineering - CE's Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/hos
	name = "\improper Security - HoS' Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/cmo
	name = "\improper Medbay - CMO's Office"
	icon_state = "head_quarters"

/area/crew_quarters/courtroom
	name = "\improper Courtroom"
	icon_state = "courtroom"

/area/comms
	name = "\improper Communications Relay"
	icon_state = "tcomsatcham"
	no_light_control = 1
	station_area = 1

/area/server
	name = "\improper Research Server Room"
	icon_state = "server"
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

//Crew

/area/crew_quarters
	name = "\improper Dormitories"
	icon_state = "Sleep"
	flags = RAD_SHIELDED
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

/area/holodeck
	name = "\improper Holodeck"
	icon_state = "Holodeck"
	sound_env = LARGE_ENCLOSED
	no_light_control = TRUE
	station_area = TRUE
	dynamic_lighting = FALSE

/area/holodeck/alphadeck
	name = "\improper Holodeck Alpha"
	dynamic_lighting = TRUE

/area/holodeck/source_plating
	name = "\improper Holodeck - Off"

/area/holodeck/source_chapel
	name = "\improper Holodeck - Chapel"

/area/holodeck/source_gym
	name = "\improper Holodeck - Gym"
	sound_env = ARENA

/area/holodeck/source_range
	name = "\improper Holodeck - Range"
	sound_env = ARENA

/area/holodeck/source_emptycourt
	name = "\improper Holodeck - Empty Court"
	sound_env = ARENA

/area/holodeck/source_boxingcourt
	name = "\improper Holodeck - Boxing Court"
	sound_env = ARENA

/area/holodeck/source_basketball
	name = "\improper Holodeck - Basketball Court"
	sound_env = ARENA

/area/holodeck/source_thunderdomecourt
	name = "\improper Holodeck - Thunderdome Court"
	sound_env = ARENA

/area/holodeck/source_courtroom
	name = "\improper Holodeck - Courtroom"
	sound_env = AUDITORIUM

/area/holodeck/source_beach
	name = "\improper Holodeck - Beach"
	sound_env = PLAIN

/area/holodeck/source_burntest
	name = "\improper Holodeck - Atmospheric Burn Test"

/area/holodeck/source_wildlife
	name = "\improper Holodeck - Wildlife Simulation"

/area/holodeck/source_meetinghall
	name = "\improper Holodeck - Meeting Hall"
	sound_env = AUDITORIUM

/area/holodeck/source_theatre
	name = "\improper Holodeck - Theatre"
	sound_env = CONCERT_HALL

/area/holodeck/source_picnicarea
	name = "\improper Holodeck - Picnic Area"
	sound_env = PLAIN

/area/holodeck/source_snowfield
	name = "\improper Holodeck - Snow Field"
	sound_env = FOREST

/area/holodeck/source_desert
	name = "\improper Holodeck - Desert"
	sound_env = PLAIN

/area/holodeck/source_space
	name = "\improper Holodeck - Space"
	has_gravity = 0
	sound_env = SPACE

//Engineering

/area/engineering
	name = "\improper Engineering"
	icon_state = "engineering"
	ambience = list(
		'sound/ambience/ambisin1.ogg',
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/ambisin3.ogg',
		'sound/ambience/ambisin4.ogg'
	)
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/atmos
	name = "\improper Engineering - Atmospherics"
	icon_state = "atmos"
	sound_env = LARGE_ENCLOSED
	no_light_control = 1
	ambience = list('sound/ambience/ambiatm1.ogg')

/area/engineering/atmos/monitoring
	name = "\improper Engineering - Atmospherics Monitoring Room"
	icon_state = "atmos_monitoring"
	sound_env = STANDARD_STATION

/area/engineering/atmos/storage
	name = "\improper Engineering - Atmospherics Storage"
	icon_state = "atmos_storage"
	sound_env = SMALL_ENCLOSED

/area/engineering/drone_fabrication
	name = "\improper Engineering - Drone Fabrication"
	icon_state = "drone_fab"
	sound_env = SMALL_ENCLOSED

/area/engineering/engine_smes
	name = "\improper Engineering - Main Lvl. SMES Room"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED

/area/engineering/engine_room
	name = "\improper Engineering - Engine Room"
	icon_state = "engine"
	sound_env = LARGE_ENCLOSED
	no_light_control = 1

/area/engineering/engine_airlock
	name = "\improper Engineering - Engine Room Airlock"
	icon_state = "engine"

/area/engineering/engine_monitoring
	name = "\improper Engineering - Monitoring Room"
	icon_state = "engine_monitoring"

/area/engineering/engine_waste
	name = "\improper Engineering - Engine Waste Handling"
	icon_state = "engine_waste"
	no_light_control = 1

/area/engineering/engineering_monitoring
	name = "\improper Engineering - Monitoring Room"
	icon_state = "engine_monitoring"

/area/engineering/foyer
	name = "\improper Engineering - Foyer"
	icon_state = "engineering_foyer"
	allow_nightmode = 1

/area/engineering/storage
	name = "\improper Engineering - Storage"
	icon_state = "engineering_storage"

/area/engineering/break_room
	name = "\improper Engineering - Break Room"
	icon_state = "engineering_break"
	sound_env = MEDIUM_SOFTFLOOR

/area/engineering/engine_eva
	name = "\improper Engineering - Engine EVA"
	icon_state = "engine_eva"

/area/engineering/locker_room
	name = "\improper Engineering - Locker Room"
	icon_state = "engineering_locker"

/area/engineering/workshop
	name = "\improper Engineering - Workshop"
	icon_state = "engineering_workshop"

/area/engineering/cooling
	name = "\improper Engineering - Engine Cooling Radiator"
	icon_state = "engineering_monitoring"

/area/engineering/gravity_gen
	name = "\improper Engineering - Gravity Generator"
	icon_state = "engine"


//Solars

/area/solar
	requires_power = 1
	always_unpowered = 1
	base_turf = /turf/space
	station_area = 1

	auxport
		name = "\improper Roof Solar Array"
		icon_state = "panelsA"
		base_turf = /turf/space

	auxstarboard
		name = "\improper Fore Starboard Solar Array"
		icon_state = "panelsA"

	fore
		name = "\improper Surface - Fore TComms Solar Array"
		icon_state = "yellow"

	aft
		name = "\improper Aft Solar Array"
		icon_state = "aft"

	starboard
		name = "\improper Surface - Aft TComms Solar Array"
		icon_state = "panelsS"

	port
		name = "\improper Surface - Port TComms Solar Array"
		icon_state = "panelsP"

/area/maintenance/auxsolarport
	name = "Solar Maintenance - Fore Port"
	icon_state = "SolarcontrolP"
	sound_env = SMALL_ENCLOSED

/area/maintenance/starboardsolar
	name = "Solar Maintenance - Aft"
	icon_state = "SolarcontrolS"
	sound_env = SMALL_ENCLOSED

/area/maintenance/portsolar
	name = "Solar Maintenance - Port"
	icon_state = "SolarcontrolP"
	sound_env = SMALL_ENCLOSED

/area/maintenance/auxsolarstarboard
	name = "Solar Maintenance - Fore Starboard"
	icon_state = "SolarcontrolS"
	sound_env = SMALL_ENCLOSED

/area/maintenance/foresolar
	name = "Solar Maintenance - Fore"
	icon_state = "SolarcontrolA"
	sound_env = SMALL_ENCLOSED

/area/assembly
	station_area = 1

/area/assembly/chargebay
	name = "\improper Mech Bay"
	icon_state = "mechbay"

/area/assembly/robotics
	name = "\improper Robotics Lab"
	icon_state = "robotics"

/area/assembly/assembly_line //Derelict Assembly Line
	name = "\improper Assembly Line"
	icon_state = "ass_line"
	power_equip = 0
	power_light = 0
	power_environ = 0

//Teleporter

/area/teleporter
	name = "\improper Command - Teleporter"
	icon_state = "teleporter"
	station_area = 1

//MedBay

/area/medical
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/medical/medbay
	name = "\improper Medbay Hallway - Port"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

//Medbay is a large area, these additional areas help level out APC load.

/area/medical/emt
	name = "\improper Medical - Emergency Technician Storage"
	icon_state = "medbay"

/area/medical/temp_morgue
	name = "\improper Medical - Temporary Morgue"
	icon_state = "morgue"

/area/medical/medbay2
	name = "\improper Medbay Hallway - Starboard"
	icon_state = "medbay2"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/medbay3
	name = "\improper Medbay Hallway - Fore"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/medbay4
	name = "\improper Medbay Hallway - Staff Wing"
	icon_state = "medbay4"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/biostorage
	name = "\improper Medical - Secondary Storage"
	icon_state = "medbay2"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/reception
	name = "\improper Medical - Reception"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/psych
	name = "\improper Medical - Psych Room"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')

/area/crew_quarters/medbreak
	name = "\improper Medical - Break Room"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/patients_rooms
	name = "\improper Medical - Patient's Rooms"
	icon_state = "patients"

/area/medical/ward
	name = "\improper Medical - Recovery Ward"
	icon_state = "patients"

/area/medical/patient_a
	name = "\improper Medical - Isolation A"
	icon_state = "patients"

/area/medical/patient_b
	name = "\improper Medical - Isolation B"
	icon_state = "patients"

/area/medical/patient_c
	name = "\improper Medical - Isolation C"
	icon_state = "patients"

/area/medical/patient_wing
	name = "\improper Medical - Patient Wing"
	icon_state = "patients"

/area/medical/cmostore
	name = "\improper Secure Storage"
	icon_state = "CMO"

/area/medical/robotics
	name = "\improper Robotics"
	icon_state = "medresearch"

/area/medical/virology
	name = "\improper Medical - Virology"
	icon_state = "virology"

/area/medical/virologyaccess
	name = "\improper Medical - Virology Access"
	icon_state = "virology"

/area/medical/morgue
	name = "\improper Medical - Long-term Morgue"
	icon_state = "morgue"
	ambience = list('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg','sound/music/main.ogg')

/area/medical/chemistry
	name = "\improper Medical - Chemistry"
	icon_state = "chem"

/area/medical/surgery
	name = "\improper Medical - Operating Theatre"
	icon_state = "surgery"
	no_light_control = 1

/area/medical/surgeryobs
	name = "\improper Medical - Operation Observation Room"
	icon_state = "surgery"

/area/medical/surgeryprep
	name = "\improper Medical - Pre-Op Prep Room"
	icon_state = "surgery"

/area/medical/surgerywing
	name = "\improper Medical - Surgery Wing"
	icon_state = "surgery"

/area/medical/cryo
	name = "\improper Cryogenics"
	icon_state = "cryo"

/area/medical/gen_treatment
	name = "\improper Medical - General Treatment"
	icon_state = "cryo"

/area/medical/exam_room
	name = "\improper Medical - Exam Room"
	icon_state = "exam_room"

/area/medical/genetics
	name = "\improper Genetics Lab"
	icon_state = "genetics"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/medical/genetics_cloning
	name = "\improper Medical - Cloning Lab"
	icon_state = "cloning"

/area/medical/sleeper
	name = "\improper Medical - Emergency Treatment Centre"
	icon_state = "exam_room"
	no_light_control = 1

/area/medical/icu
	name = "\improper Medical -  Intensive Care Unit"
	icon_state = "cryo"


//Security

/area/security
	no_light_control = 1
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/security/main
	name = "\improper Security - Equipment Room"
	icon_state = "security"

/area/security/lobby
	name = "\improper Security - Lobby"
	icon_state = "security"
	allow_nightmode = 1
	no_light_control = 0

/area/security/brig
	name = "\improper Security - Brig"
	icon_state = "brig"

/area/security/brig/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = 0
		temp_closet.icon_state = temp_closet.icon_closed
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.releasetime = 1
	..()

/area/security/prison
	name = "\improper Security - Prison Wing"
	icon_state = "sec_prison"

/area/security/prison/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = 0
		temp_closet.icon_state = temp_closet.icon_closed
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.releasetime = 1
	..()

/area/security/warden
	name = "\improper Security - Warden's Office"
	icon_state = "Warden"

/area/security/armoury
	name = "\improper Security - Armory"
	icon_state = "Warden"

/area/security/forensics_office
	name = "\improper Security - Forensic Office"
	icon_state = "detective"
	sound_env = MEDIUM_SOFTFLOOR

/area/security/detectives_office
	name = "\improper Security - Detective's Office"
	icon_state = "detective"

/area/security/range
	name = "\improper Security - Firing Range"
	icon_state = "firingrange"

/area/security/tactical
	name = "\improper Security - Tactical Equipment"
	icon_state = "Tactical"


/*
	New()
		..()

		spawn(10) //let objects set up first
			for(var/turf/turfToGrayscale in src)
				if(turfToGrayscale.icon)
					var/icon/newIcon = icon(turfToGrayscale.icon)
					newIcon.GrayScale()
					turfToGrayscale.icon = newIcon
				for(var/obj/objectToGrayscale in turfToGrayscale) //1 level deep, means tables, apcs, locker, etc, but not locker contents
					if(objectToGrayscale.icon)
						var/icon/newIcon = icon(objectToGrayscale.icon)
						newIcon.GrayScale()
						objectToGrayscale.icon = newIcon
*/

/area/security/nuke_storage
	name = "\improper Vault"
	icon_state = "nuke_storage"
	holomap_color = null
	flags = HIDE_FROM_HOLOMAP

/area/security/checkpoint
	name = "\improper Security Checkpoint"
	icon_state = "checkpoint1"

/area/security/checkpoint2
	name = "\improper Security - Arrivals Checkpoint"
	icon_state = "security"

/area/security/checkpoint/supply
	name = "Security Post - Cargo Bay"
	icon_state = "checkpoint1"

/area/security/checkpoint/engineering
	name = "Security Post - Engineering"
	icon_state = "checkpoint1"

/area/security/checkpoint/medical
	name = "Security Post - Medbay"
	icon_state = "checkpoint1"

/area/security/checkpoint/science
	name = "Security Post - Science"
	icon_state = "checkpoint1"

/area/security/vacantoffice
	name = "\improper Vacant Office"
	icon_state = "security"

/area/security/vacantoffice2
	name = "\improper Security - Meeting Room"
	icon_state = "security"

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

//rnd (Research and Development
/area/rnd
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/rnd/research
	name = "\improper Research and Development"
	icon_state = "research"

/area/rnd/telesci
	name = "\improper Research - Telescience Laboratory"
	icon_state = "research"

/area/rnd/docking
	name = "\improper Research Dock"
	icon_state = "research_dock"

/area/rnd/lab
	name = "\improper Research - R&D Laboratory"
	icon_state = "toxlab"

/area/rnd/rdoffice
	name = "\improper Research Director's Office"
	icon_state = "head_quarters"

/area/rnd/supermatter
	name = "\improper Research - Supermatter Lab"
	icon_state = "toxlab"

/area/rnd/xenobiology
	name = "\improper Research - Xenobiology Lab"
	icon_state = "xeno_lab"

/area/rnd/xenobiology/xenoflora_storage
	name = "\improper Research - Xenoflora Storage"
	icon_state = "xeno_f_store"
	no_light_control = TRUE

/area/rnd/xenobiology/xenoflora
	name = "\improper Research - Xenoflora Lab"
	icon_state = "xeno_f_lab"
	no_light_control = TRUE

/area/rnd/storage
	name = "\improper Research - Toxins Storage"
	icon_state = "toxstorage"

/area/rnd/test_area
	name = "\improper Research - Toxins Test Area"
	icon_state = "toxtest"

/area/rnd/mixing
	name = "\improper Research - Toxins Mixing Room"
	icon_state = "toxmix"

/area/rnd/misc_lab
	name = "\improper Research - Miscellaneous Research"
	icon_state = "toxmisc"

/area/toxins
	station_area = 1

/area/toxins/server
	name = "\improper Research - Server Room"
	icon_state = "server"
	station_area = 1

//Storage
/area/storage
	station_area = 1

/area/storage/tools
	name = "Auxiliary Tool Storage"
	icon_state = "storage"
	allow_nightmode = 1

/area/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"
	allow_nightmode = 1

/area/storage/autolathe
	name = "Autolathe Storage"
	icon_state = "storage"

/area/storage/art
	name = "Art Supply Storage"
	icon_state = "storage"

/area/storage/auxillary
	name = "Auxillary Storage"
	icon_state = "auxstorage"

/area/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/storage/emergency
	name = "Starboard Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/emergency2
	name = "Port Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/emergency3
	name = "Central Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/tech
	name = "Technical Storage"
	icon_state = "auxstorage"

/area/storage/testroom
	requires_power = 0
	name = "\improper Test Room"
	icon_state = "storage"

//DJSTATION

/area/djstation
	name = "\improper Listening Post"
	icon_state = "LP"
	no_light_control = 1

/area/djstation/solars
	name = "\improper Listening Post Solars"
	icon_state = "LPS"

//DERELICT

/area/derelict
	name = "\improper Derelict Station"
	icon_state = "storage"
	no_light_control = 1
	base_turf = /turf/space

/area/derelict/hallway/northwest
	name = "\improper NSS Aurora I"
	icon_state = "hallP"

/area/derelict/hallway/northeast
	name = "\improper NSS Aurora I"
	icon_state = "yellow"

/area/derelict/hallway/southwest
	name = "\improper NSS Aurora I"
	icon_state = "hallS"

/area/derelict/hallway/southeast
	name = "\improper NSS Aurora I"
	icon_state = "green"

/area/derelict/hallway/secondary
	name = "\improper Derelict Secondary Hallway"
	icon_state = "hallS"

/area/derelict/arrival
	name = "\improper Derelict Arrival Centre"
	icon_state = "yellow"

/area/derelict/storage/equipment
	name = "Derelict Equipment Storage"

/area/derelict/storage/storage_access
	name = "Derelict Storage Access"

/area/derelict/storage/engine_storage
	name = "Derelict Engine Storage"
	icon_state = "green"

/area/derelict/bridge
	name = "\improper Derelict Control Room"
	icon_state = "bridge"

/area/derelict/secret
	name = "\improper Derelict Secret Room"
	icon_state = "library"

/area/derelict/bridge/access
	name = "Derelict Control Room Access"
	icon_state = "auxstorage"

/area/derelict/bridge/ai_upload
	name = "\improper Derelict Computer Core"
	icon_state = "ai"

/area/derelict/solar_control
	name = "\improper Derelict Solar Control"
	icon_state = "engine"

/area/derelict/crew_quarters
	name = "\improper Derelict Crew Quarters"
	icon_state = "fitness"

/area/derelict/medical
	name = "Derelict Medbay"
	icon_state = "medbay"

/area/derelict/medical/morgue
	name = "\improper Derelict Morgue"
	icon_state = "morgue"

/area/derelict/medical/chapel
	name = "\improper Derelict Chapel"
	icon_state = "chapel"

/area/derelict/teleporter
	name = "\improper Derelict Teleporter"
	icon_state = "teleporter"

/area/derelict/eva
	name = "Derelict EVA Storage"
	icon_state = "eva"

/area/derelict/ship
	name = "\improper Abandoned Ship"
	icon_state = "yellow"

/area/solar/derelict_starboard
	name = "\improper Derelict Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/derelict_aft
	name = "\improper Derelict Aft Solar Array"
	icon_state = "aft"

/area/derelict/singularity_engine
	name = "\improper Derelict Singularity Engine"
	icon_state = "engine"

//HALF-BUILT STATION (REPLACES DERELICT IN BAYCODE, ABOVE IS LEFT FOR DOWNSTREAM)

/area/shuttle/constructionsite
	name = "\improper Construction Site Shuttle"
	icon_state = "yellow"

/area/shuttle/constructionsite/station
	name = "\improper Construction Site Shuttle"

/area/shuttle/constructionsite/site
	name = "\improper Construction Site Shuttle"

/area/constructionsite
	name = "\improper Construction Site"
	icon_state = "storage"
	no_light_control = 1

/area/constructionsite/storage
	name = "\improper Construction Site Storage Area"

/area/constructionsite/science
	name = "\improper Construction Site Research"

/area/constructionsite/bridge
	name = "\improper Construction Site Bridge"
	icon_state = "bridge"

/area/constructionsite/maintenance
	name = "\improper Construction Site Maintenance"
	icon_state = "yellow"

/area/constructionsite/hallway/aft
	name = "\improper Construction Site Aft Hallway"
	icon_state = "hallP"

/area/constructionsite/hallway/fore
	name = "\improper Construction Site Fore Hallway"
	icon_state = "hallS"

/area/constructionsite/atmospherics
	name = "\improper Construction Site Atmospherics"
	icon_state = "green"

/area/constructionsite/medical
	name = "\improper Construction Site Medbay"
	icon_state = "medbay"

/area/constructionsite/ai
	name = "\improper Construction Computer Core"
	icon_state = "ai"

/area/constructionsite/engineering
	name = "\improper Construction Site Engine Bay"
	icon_state = "engine"

/area/solar/constructionsite
	name = "\improper Construction Site Solars"
	icon_state = "aft"

/area/constructionsite/teleporter
	name = "Construction Site Teleporter"
	icon_state = "yellow"

//Construction

/area/construction
	name = "\improper Engineering Construction Area"
	icon_state = "yellow"
	no_light_control = 1
	base_turf = /turf/space
	station_area = 1

/area/construction/supplyshuttle
	name = "\improper Supply Shuttle"
	icon_state = "yellow"

/area/construction/quarters
	name = "\improper Engineer's Quarters"
	icon_state = "yellow"

/area/construction/qmaint
	name = "Maintenance"
	icon_state = "yellow"

/area/construction/hallway
	name = "\improper Hallway"
	icon_state = "yellow"

/area/construction/solars
	name = "\improper Solar Panels"
	icon_state = "yellow"

/area/construction/solarscontrol
	name = "\improper Solar Panel Control"
	icon_state = "yellow"

/area/construction/Storage
	name = "Construction Site Storage"
	icon_state = "yellow"

//AI

/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"

/area/turret_protected
	station_area = 1
	flags = HIDE_FROM_HOLOMAP

/area/turret_protected/ai_upload
	name = "\improper AI Upload Chamber"
	icon_state = "ai_upload"
	ambience = list('sound/ambience/ambimalf.ogg')

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Access"
	icon_state = "ai_foyer"
	ambience = list('sound/ambience/ambimalf.ogg')
	sound_env = SMALL_ENCLOSED

/area/turret_protected/ai_server_room
	name = "Messaging Server Room"
	icon_state = "ai_server"
	sound_env = SMALL_ENCLOSED

/area/turret_protected/ai
	name = "\improper AI Chamber"
	icon_state = "ai_chamber"
	ambience = list('sound/ambience/ambimalf.ogg')

/area/turret_protected/ai_cyborg_station
	name = "\improper Cyborg Station"
	icon_state = "ai_cyborg"
	sound_env = SMALL_ENCLOSED

/area/turret_protected/aisat
	name = "\improper AI Satellite"
	icon_state = "ai"

/area/turret_protected/aisat_interior
	name = "\improper AI Satellite"
	icon_state = "ai"

/area/turret_protected/AIsatextFP
	name = "\improper AI Sat Ext"
	icon_state = "storage"
	luminosity = 1

/area/turret_protected/AIsatextFS
	name = "\improper AI Sat Ext"
	icon_state = "storage"
	luminosity = 1

/area/turret_protected/AIsatextAS
	name = "\improper AI Sat Ext"
	icon_state = "storage"
	luminosity = 1

/area/turret_protected/AIsatextAP
	name = "\improper AI Sat Ext"
	icon_state = "storage"
	luminosity = 1

/area/turret_protected/NewAIMain
	name = "\improper AI Main New"
	icon_state = "storage"



//Misc



/area/wreck/ai
	name = "\improper AI Chamber"
	icon_state = "ai"

/area/wreck/main
	name = "\improper Wreck"
	icon_state = "storage"

/area/wreck/engineering
	name = "\improper Power Room"
	icon_state = "engine"

/area/wreck/bridge
	name = "\improper Bridge"
	icon_state = "bridge"

/area/generic
	name = "Unknown"
	icon_state = "storage"



// Telecommunications Satellite
/area/tcommsat
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')
	no_light_control = 1
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/tcommsat/entrance
	name = "\improper Telecoms Teleporter"
	icon_state = "tcomsatentrance"

/area/tcommsat/chamber
	name = "\improper Telecoms Central Compartment"
	icon_state = "tcomsatcham"

/area/turret_protected/tcomsat
	name = "\improper Telecoms Satellite"
	icon_state = "tcomsatlob"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/turret_protected/tcomfoyer
	name = "\improper Telecoms Foyer"
	icon_state = "tcomsatentrance"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/turret_protected/tcomwest
	name = "\improper Telecommunications Satellite West Wing"
	icon_state = "tcomsatwest"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/turret_protected/tcomeast
	name = "\improper Telecommunications Satellite East Wing"
	icon_state = "tcomsateast"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/tcommsat/computer
	name = "\improper Telecoms Control Room"
	icon_state = "tcomsatcomp"

/area/tcommsat/lounge
	name = "\improper Telecommunications Satellite Lounge"
	icon_state = "tcomsatlounge"
	base_turf = /turf/space

/area/tcommsat/powercontrol
	name = "\improper Telecommunications Power Control"
	icon_state = "tcomsatwest"

/area/tcommsat/mainlvl_tcomms__relay
	name = "\improper Sublevel - Telecommunications Relay"
	icon_state = "tcomsatcham"

/area/beach
	name = "Keelin's private beach"
	icon_state = "null"
	luminosity = 1
	dynamic_lighting = 0
	requires_power = 0
//	var/sound/mysound = null
	no_light_control = 1
	var/iter = 0

/* //todo: make this don't suck
/area/beach/New()
	..()
	var/sound/S = new/sound()
	mysound = S
	S.file = 'sound/ambience/shore.ogg'
	S.repeat = 1
	S.wait = 0
	S.channel = 123
	S.volume = 100
	S.priority = 255
	S.status = SOUND_UPDATE
	process()

/area/beach/Entered(atom/movable/Obj,atom/OldLoc)
	if(ismob(Obj))
		var/mob/M = Obj
		if(M.client)
			mysound.status = SOUND_UPDATE
			sound_to(M, mysound)

/area/beach/Exited(atom/movable/Obj)
	if(ismob(Obj))
		var/mob/M = Obj
		if(M.client)
			mysound.status = SOUND_PAUSED | SOUND_UPDATE
			sound_to(M, mysound)

/area/beach/proc/process()
	set background = 1

	var/sound/S = null
	var/sound_delay = 0
	if(prob(25))
		S = sound(file=pick('sound/ambience/seag1.ogg','sound/ambience/seag2.ogg','sound/ambience/seag3.ogg'), volume=100)
		sound_delay = rand(0, 50)

	for(var/mob/living/carbon/human/H in src)
		if(H.client)
			mysound.status = SOUND_UPDATE
			to_chat(H, mysound)
			if(S)
				spawn(sound_delay)
					sound_to(H, S)

	spawn(60) .()
*/


//merchant station and shuttle

/area/merchant_station
	name = "\improper Merchant Station"
	icon_state = "merchant"
	requires_power = 0
	dynamic_lighting = 1
	no_light_control = 1
	centcomm_area = 1

/area/merchant_station/transit
	name = "\improper Hyperspace"
	icon_state = "shuttle"
	centcomm_area = 1

/area/merchant_ship
	name = "\improper Merchant Ship"
	icon_state = "yellow"
	requires_power = 0
	flags = RAD_SHIELDED | SPAWN_ROOF
	no_light_control = 1

/area/merchant_ship/start
	name = "\improper Merchant Ship Docked"
	icon_state = "yellow"
	centcomm_area = 1
	base_turf = /turf/space

/area/merchant_ship/docked
	name = "\improper Docked with station"
	icon_state = "southwest"
	station_area = 1
	base_turf = /turf/simulated/floor/asteroid
