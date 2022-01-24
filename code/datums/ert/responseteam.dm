/datum/responseteam
	var/name = "Default Team"                         //ERT name.
	var/chance                                       //Probability to get picked.
	var/datum/ghostspawner/human/ert/spawner        //This response type's BASE spawner type.
	var/list/possible_space_sector = list()			//Which space sectors this ert can spawn, leave empty for admin only erts
	var/datum/map_template/equipment_map 			// if this team spawns extra equipment
