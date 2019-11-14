/datum/responseteam
	var/name = "Default Team"                         //ERT name.
	var/chance = 0                                       //Probability to get picked.
	var/ert_type = null                                  //THIS IS A FLAG. SECURITY|MEDICAL|ENGINEERING
	var/datum/ghostspawner/human/ert/spawner        //This response type's BASE spawner type.