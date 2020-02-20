/datum/responseteam
	var/name = "Default Team"                         //ERT name.
	var/chance                                       //Probability to get picked.
	var/datum/ghostspawner/human/ert/spawner        //This response type's BASE spawner type.
	var/admin = FALSE								// if this is a special team that is not supossed to show up in regular rounds
	var/has_extra_equipment = FALSE 				// if this team spawns extra equipment on landmarks
