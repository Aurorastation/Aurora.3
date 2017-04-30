/obj/turbolift_map_holder/aurora
	depth = 2
	lift_size_x = 4
	lift_size_y = 4
	clear_objects = 0

//Main Lift
/obj/turbolift_map_holder/aurora/civilian
	name = "Aurora lift placeholder - Main"
	dir = SOUTH

	depth = 3
	lift_size_x = 6
	lift_size_y = 6

	areas_to_use = list(
		/area/turbolift/main_station,
		/area/turbolift/main_mid,
		/area/turbolift/main_arrivals
		)

/area/turbolift/main_arrivals
	name = "Civilian Lift - Arrivals"
	lift_announce_str = "Arriving at Arrivals"

	lift_floor_label = "Arrivals"
	lift_floor_name = "Arrivals"

/area/turbolift/main_station
	name = "Civilian Lift - Main"
	lift_announce_str = "Arriving at Main floor"

	lift_floor_label = "Main"
	lift_floor_name = "Main"

/area/turbolift/main_mid
	name = "Civilian Lift - Mid Level"
	lift_announce_str = "Arriving at Unknown"

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
	lift_announce_str = "Arriving at the station level, by the R&D department."

	lift_floor_label = "R&D Main"
	lift_floor_name = "R&D Main"

/area/turbolift/research_maintenance
	name = "Maintenance - Below Research"
	lift_announce_str = "Arriving at the maintenance level, below the R&D department."
	base_turf = /turf/simulated/floor/plating

	lift_floor_label = "Lower R&D"
	lift_floor_name = "Lower R&D"

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
	lift_announce_str = "Arriving at the station level, by the Engineering department."

	lift_floor_label = "Engineering Main"
	lift_floor_name = "Engineering Main"

/area/turbolift/engineering_maintenance
	name = "Maintenance - Below Engineering"
	lift_announce_str = "Arriving at the maintenance level, below the Engineering department."

	lift_floor_label = "Lower Engineering"
	lift_floor_name = "Lower Engineering"

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
	lift_announce_str = "Arriving at the station level, by the Cargo department."

	lift_floor_label = "Cargo Main"
	lift_floor_name = "Cargo Main"

/area/turbolift/cargo_deliverys
	name = "Arrivals - Cargo"
	lift_announce_str = "Arriving at Cargo department, Deliverys."

	lift_floor_label = "Cargo Arrivals"
	lift_floor_name = "Cargo Arrivals"

/area/turbolift/cargo_mid
	name = "Arrivals - Cargo"
	lift_announce_str = "Arriving at Unknown."

	lift_floor_label = "Cargo Arrivals"
	lift_floor_name = "Cargo Arrivals"


//Medical
/obj/turbolift_map_holder/aurora/medical
	name = "Aurora lift placeholder - Medical"
	dir = WEST

	lift_size_x = 4
	lift_size_y = 4
	depth = 2

	areas_to_use = list(
		/area/turbolift/medical_sub,
		/area/turbolift/medical_station
		)

/area/turbolift/medical_station
	name = "Medical Lift - Main"
	lift_announce_str = "Arriving at Medical bay"

	lift_floor_label = "Medical Main"
	lift_floor_name = "Medical Main"

/area/turbolift/medical_sub
	name = "Medical Lift - Sub"
	lift_announce_str = "Arriving at lower Medical"

	lift_floor_label = "Lower Medical"
	lift_floor_name = "Lower Medical"

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
	lift_announce_str = "Arriving at Main Floor"

	lift_floor_label = "Main"
	lift_floor_name = "AI Control Main"

/area/turbolift/ai_sub
	name = "AI Access Lift - Lower"
	lift_announce_str = "Arriving at AI control"

	lift_floor_label = "AI Control"
	lift_floor_name = "AI Control"



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
	lift_announce_str = "Arriving at Main floor"

	lift_floor_label = "Main"
	lift_floor_name = "Vault Main"


/area/turbolift/vault_sub
	name = "Vault Access Lift - sub"
	lift_announce_str = "Arriving at Vault Access"

	lift_floor_label = "Vault Access"
	lift_floor_name = "Vault Access"


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
	lift_announce_str = "Arriving at Main floor"

	lift_floor_label = "Main"
	lift_floor_name = "Command Main"

/area/turbolift/command_sub
	name = "Command Lift - Sub"
	lift_announce_str = "Arriving at Command level"

	lift_floor_label = "Meeting/Escape Pods"
	lift_floor_name = "Command Meeting"

/area/turbolift/command_mid
	name = "Command Lift - Mid"
	lift_announce_str = "Arriving at Command Unknown"
	lift_floor_label = "Command Floor"
	lift_floor_name = "Secret Command Floor"
