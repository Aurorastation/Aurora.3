/datum/responseteam
	var/name = "Default Team"                         //ERT name.
	var/chance                                       //Probability to get picked.
	var/datum/ghostspawner/human/ert/spawner        //This response type's BASE spawner type.
	var/admin = FALSE								// if this is a special team that is not supossed to show up in regular rounds
	var/datum/map_template/equipment_map 			// if this team spawns extra equipment
	var/minimum_call_time = 0						// the amount of time the round has to pass before this team is eligible to respond
