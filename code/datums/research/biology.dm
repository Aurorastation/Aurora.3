//explains cloning the RED, and animal cubes. Improves cloning, the RED, and animal cubes.
/datum/research_concepts/crispr
	name = "CRISPR"
	id = "crispr"
	short_desc = "Research into the field of DNA editing."
	long_desc = "Research into CRISPR and its subtypes has allowed humans to change DNA and prevent diseases caused by genetics."
	level = 1
	maxlevel = 4
	progress = 0
	max_progress = 1000
	relatedtechs = list(
					  TECH_BIO  = 2
						)

/datum/research_concepts/crispr/get_tech_desc(var/long = 0, var/level = 1)
	..()
	if(long)
		switch(level)
			if(1)
				return "CRISPR-Cpf1 is a persise cutting enzyme used to form a single complex RNA for performing cutting actions. The Cpf1 allows for mulitple cuts to be performed which makes working with mutated genes easy to work with as a second cut can be made to remove the mutation from the sample."
			if(2)
				return ""
			if(3)
				return ""
			if(4)
				return ""
	else
		switch(level)
			if(1)
				return "CRISPR-Cpf1 uses a single RNA to cut DNA for persise and flexiable editing."
			if(2)
				return ""
			if(3)
				return ""
			if(4)
				return ""