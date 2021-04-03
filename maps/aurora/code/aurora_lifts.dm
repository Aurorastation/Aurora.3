/obj/turbolift_map_holder/aurora
	depth = 2
	lift_size_x = 4
	lift_size_y = 4
	clear_objects = 0

//Main Lift
/obj/turbolift_map_holder/aurora/civilian
	name = "Aurora lift placeholder - Main"
	dir = WEST

	depth = 3
	lift_size_x = 4
	lift_size_y = 4

	areas_to_use = list(
		/area/turbolift/main_station,
		/area/turbolift/main_mid,
		/area/turbolift/main_arrivals
		)

/obj/turbolift_map_holder/aurora/civilian_aux
	name = "Aurora lift placeholder - Aux"
	dir = WEST

	depth = 3
	lift_size_x = 4
	lift_size_y = 4

	areas_to_use = list(
		/area/turbolift/main_station_aux,
		/area/turbolift/main_mid_aux,
		/area/turbolift/main_arrivals_aux
		)

/area/turbolift/main_arrivals
	name = "Civilian Lift - Arrivals"
	lift_announce_str = "Arriving at the Surface Level. Facilities on this floor include: Blue, Red and Yellow Docks, Cryogenics Storage, Cargo Bay, Primary Tool Storage, Recreational Facilities."

	lift_floor_label = "Surface Lvl."
	lift_floor_name = "Surface Lvl."

/area/turbolift/main_arrivals_aux
	name = "Civilian Lift - Arrivals"
	lift_announce_str = "Arriving at the Surface Level. Facilities on this floor include: Blue, Red and Yellow Docks, Cryogenics Storage, Cargo Bay, Primary Tool Storage, Recreational Facilities."

	lift_floor_label = "Surface Lvl."
	lift_floor_name = "Surface Lvl."

/area/turbolift/main_station
	name = "Civilian Lift - Main"
	lift_announce_str = "Arriving at the Main Level. Facilities on this floor include: Engineering, Medical, Security, Science, Command departments, Cargo Office, Chapel, Bar, Kitchen."

	lift_floor_label = "Main Lvl."
	lift_floor_name = "Main Lvl."

	base_turf = /turf/simulated/floor/plating

/area/turbolift/main_station_aux
	name = "Civilian Lift - Main"
	lift_announce_str = "Arriving at the Main Level. Facilities on this floor include: Engineering, Medical, Security, Science, Command departments, Cargo Office, Chapel, Bar, Kitchen."

	lift_floor_label = "Main Lvl."
	lift_floor_name = "Main Lvl."

	base_turf = /turf/simulated/floor/plating

/area/turbolift/main_mid
	name = "Civilian Lift - Mid Level"
	lift_announce_str = "Arriving at (Unknown). Facilities on this floor include: (Unknown)."

	lift_floor_label = "Under construction"
	lift_floor_name = "Under construction"

/area/turbolift/main_mid_aux
	name = "Civilian Lift - Mid Level"
	lift_announce_str = "Arriving at (Unknown). Facilities on this floor include: (Unknown)."

	lift_floor_label = "Under construction"
	lift_floor_name = "Under construction"

//Security
/obj/turbolift_map_holder/aurora/security
	name = "Aurora lift placeholder - Security"
	dir = SOUTH

	depth = 2

	areas_to_use = list(
		/area/turbolift/security_maintenance,
		/area/turbolift/security_station
		)

/area/turbolift/security_station
	name = "Station - By Security"
	lift_announce_str = "Arriving at the station level, by the Security department."

	lift_floor_label = "Security Main"
	lift_floor_name = "Security Main"

/area/turbolift/security_maintenance
	name = "Maintenance - Below Security"
	lift_announce_str = "Arriving at the maintenance level, below the Security department."
	base_turf = /turf/simulated/floor/plating

	lift_floor_label = "Lower Sec"
	lift_floor_name = "Lower Sec"

	base_turf = /turf/simulated/floor/plating

//Research
/obj/turbolift_map_holder/aurora/research
	name = "Aurora lift placeholder - Research"
	dir = NORTH

	lift_size_x = 4
	lift_size_y = 4
	depth = 2

	areas_to_use = list(
		/area/turbolift/research_maintenance,
		/area/turbolift/research_station
		)

/area/turbolift/research_station
	name = "Station - By Research"
	lift_announce_str = "Arriving at the Research Main Level. Facilities in this floor include: Research and Development, Robotics, Telescience, Miscellaneous Research, Conference Room."

	lift_floor_label = "Main Level (Research)"
	lift_floor_name = "Main Level (Research)"

/area/turbolift/research_maintenance
	name = "Maintenance - Below Research"
	lift_announce_str = "Arriving at the Research Sub-Level. Facilities in this floor include: Xenoarcheology, Toxins, Bomb Range, Test Range, Xenobiology, Xenobotany."
	base_turf = /turf/simulated/floor/plating

	lift_floor_label = "Sub-Level (Research)"
	lift_floor_name = "Sub-Level (Research)"

	base_turf = /turf/simulated/floor/plating

//Engineering
/obj/turbolift_map_holder/aurora/engineering
	name = "Aurora lift placeholder - Engineering"
	dir = SOUTH

	lift_size_x = 5
	lift_size_y = 4
	depth = 2

	areas_to_use = list(
		/area/turbolift/engineering_maintenance,
		/area/turbolift/engineering_station
		)

/area/turbolift/engineering_station
	name = "Station - By Engineering"
	lift_announce_str = "Arriving at the Engineering Main Level. Facilities in this floor include: Engine Bay, Main Storage, Hard Storage, Atmospherics, Monitoring Room, Lobby."

	lift_floor_label = "Main Level (Engineering)"
	lift_floor_name = "Main Level (Engineering)"

/area/turbolift/engineering_maintenance
	name = "Maintenance - Below Engineering"
	lift_announce_str = "Arriving at the Engineering Sub-Level. Reminder: Stop located in Maintenance. Facilities in this floor include: Secondary Engine Bay, Break Room, Storage, Washroom."

	lift_floor_label = "Sub-Level (Engineering)"
	lift_floor_name = "Sub-Level (Engineering)"

	base_turf = /turf/simulated/floor/plating

//Cargo
/obj/turbolift_map_holder/aurora/cargo
	name = "Aurora lift placeholder - Cargo"
	dir = EAST

	lift_size_x = 5
	lift_size_y = 5
	depth = 3

	areas_to_use = list(
		/area/turbolift/cargo_station,
		/area/turbolift/cargo_mid,
		/area/turbolift/cargo_deliverys
		)

/area/turbolift/cargo_station
	name = "Station - By Cargo"
	lift_announce_str = "Arriving at the Cargo Main Level. Facilities in this floor include: Cargo Office, Warehouse, Sorting Office, Resource Processing, Mining Station."

	lift_floor_label = "Main Level (Cargo)"
	lift_floor_name = "Main Level (Cargo)"

	base_turf = /turf/simulated/floor/plating

/area/turbolift/cargo_deliverys
	name = "Arrivals - Cargo"
	lift_announce_str = "Arriving at the Cargo Surface Level. Facilities in this floor include: Cargo Shuttle Dock, Cargo Bay."

	lift_floor_label = "Surface Level (Cargo)"
	lift_floor_name = "Surface Level (Cargo)"

/area/turbolift/cargo_mid
	name = "Arrivals - Cargo"
	lift_announce_str = "Arriving at (Unknown). Facilities in this floor include: (Unknown)."

	lift_floor_label = "Under Construction"
	lift_floor_name = "Under Construction"


//Medical
/obj/turbolift_map_holder/aurora/medical
	name = "Aurora lift placeholder - Medical"
	dir = WEST

	lift_size_x = 4
	lift_size_y = 4
	depth = 3

	areas_to_use = list(
		/area/turbolift/medical_sub,
		/area/turbolift/medical_station,
		/area/turbolift/medical_interstitial
		)

/area/turbolift/medical_station
	name = "Medical Lift - Main"
	lift_announce_str = "Arriving at the Medical Main Level. Facilities in this floor include: Lobby, Chemistry, Intensive Care Unit, General Treatment Unit, Surgery Wing, Consultation Wing."

	lift_floor_label = "Main Level (Medical)"
	lift_floor_name = "Main Level (Medical)"

/area/turbolift/medical_sub
	name = "Medical Lift - Sub"
	lift_announce_str = "Arriving at the Medical Sub-Level. Facilities in this floor include: Virology, Supervised Living Center, Long-term Morgue, Staff Wing, Briefing Room."

	lift_floor_label = "Sub-Level (Medical)"
	lift_floor_name = "Sub-Level (Medical)"

	base_turf = /turf/simulated/floor/plating

/area/turbolift/medical_interstitial
	name = "Medical Lift - Interstitial"
	lift_announce_str = "Arriving at the Medical Upper-Level. Facilities in this floor include: Psychiatry Wing, Psychiatrist's Office, Therapy Ward."

	lift_floor_label = "Upper-Level (Medical)"
	lift_floor_name = "Upper-Level (Medical)"

//AI Access
/obj/turbolift_map_holder/aurora/aiaccess
	name = "Aurora lift placeholder - AI Access"
	dir = NORTH

	lift_size_x = 4
	lift_size_y = 4
	depth = 2

	areas_to_use = list(
		/area/turbolift/ai_sub,
		/area/turbolift/ai_station
		)

/area/turbolift/ai_station
	name = "AI Access Lift - Main"
	lift_announce_str = "Arriving at the Command Main Level. Facilities in this floor include: Bridge, Command Dormitories, Command Recreational Area."

	lift_floor_label = "Main Level (Command)"
	lift_floor_name = "Main Level (Command)"

/area/turbolift/ai_sub
	name = "AI Access Lift - Lower"
	lift_announce_str = "Arriving at the Command Sub-Level. Facilities in this floor include: Messaging Server, Cyborg Charging Station, Artificial Intelligence Wing."

	lift_floor_label = "Sub-Level (Command)"
	lift_floor_name = "Sub-Level (Command)"

	base_turf = /turf/simulated/floor/plating



//Vault
/obj/turbolift_map_holder/aurora/vault
	name = "Aurora lift placeholder - Vault"
	dir = SOUTH

	lift_size_x = 4
	lift_size_y = 4
	depth = 2

	areas_to_use = list(
		/area/turbolift/vault_sub,
		/area/turbolift/vault_station
		)

/area/turbolift/vault_station
	name = "Vault Access Lift - Main"
	lift_announce_str = "Arriving at the Main Level. Facilities on this floor include: Engineering, Medical, Security, Science and Command departments, Kitchen, Bar, Cargo Office."

	lift_floor_label = "Main Lvl."
	lift_floor_name = "Main Lvl."



/area/turbolift/vault_sub
	name = "Vault Access Lift - sub"
	lift_announce_str = "Arriving at Vault Access. Facilities on this floor include: Vault. Alert: Secure Area ahead. Non-authorized personnel will be prosecuted."

	lift_floor_label = "Sub-Level (Vault)"
	lift_floor_name = "Sub-Level (Vault)"

	base_turf = /turf/simulated/floor/plating


//Command
/obj/turbolift_map_holder/aurora/command
	name = "Aurora lift placeholder - Command"
	dir = NORTH

	lift_size_x = 4
	lift_size_y = 4
	depth = 3

	areas_to_use = list(
		/area/turbolift/command_sub,
		/area/turbolift/command_mid,
		/area/turbolift/command_station
		)

/area/turbolift/command_station
	name = "Command Lift - Main"
	lift_announce_str = "Arriving at the Command Surface Level. Facilities in this floor include: Escape Pods, Meeting Room, Secure Docks."

	lift_floor_label = "Surface Level (Command)"
	lift_floor_name = "Surface Level (Command)"

/area/turbolift/command_sub
	name = "Command Lift - Sub"
	lift_announce_str = "Arriving at the Command Main Level. Facilities in this floor include: Bridge, Command Dormitories, Command Recreational Area."

	lift_floor_label = "Main Level (Command)"
	lift_floor_name = "Main Level (Command)"

	base_turf = /turf/simulated/floor/plating

/area/turbolift/command_mid
	name = "Command Lift - Mid"
	lift_announce_str = "Arriving at the (Command Unknown). Facilities in this floor include: (Unknown)"
	lift_floor_label = "Under Construction"
	lift_floor_name = "Under Construction"
