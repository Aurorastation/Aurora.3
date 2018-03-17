//explains cloning and the RED. Improves cloning, the RED, and animal cubes.
/datum/research_concepts/crispr
	name = "CRISPR"
	id = "crispr"
	desc = "Research into the field of DNA editing."
	level = 1
	maxlevel = 4
	progress = 0
	max_progress = 1000
	relatedtechs = list(
					  TECH_BIO  = 2
						)

/datum/research_concepts/crispr/get_tech_desc(var/level = 1)
	..()
	switch(level)
		if(1)
			return "CRISPR-Cpf1 uses a single RNA to cut DNA for persise and flexiable editing."
		if(2)
			return ""
		if(3)
			return ""
		if(4)
			return ""