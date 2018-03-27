//explains cloning and the RED. Improves cloning, the RED, and animal cubes.
/datum/research_concepts/medicine
	name = "Medicine"
	id = "medicine"
	desc = "Research into the field of repairing organics ."
	level = 1
	maxlevel = 4
	progress = 0
	max_progress = 1000
	relatedtechs = list(
					  TECH_BIO  = 2
						)

/datum/research_concepts/medicine/get_tech_desc(var/level = 1)
	..()
	switch(level)
		if(1)
			return ""
		if(2)
			return ""
		if(3)
			return ""
		if(4)
			return ""