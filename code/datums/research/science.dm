//Quantum mechanics. Explains and improves telescience, the emergency relay, telecommunications, and the fax machine (?).
/datum/research_concepts/quantummech
	name = "Quantum mechanics"
	id = "quantummech"
	short_desc = "Research into the field of DNA editing."
	long_desc = "Research into CRISPR and its subtypes has allowed humans to change DNA and prevent diseases caused by genetics."
	level = 1
	maxlevel = 4
	progress = 0
	max_progress = 1000
	relatedtechs = list(
					  TECH_BIO  = 2
						)

/datum/research_concepts/quantummech/get_tech_desc(var/long = 0, var/level = 1)
	..()
	if(long)
		switch(level)
			if(1)
				return ""
			if(2)
				return ""
			if(3)
				return ""
			if(4)
				return ""
	else
		switch(level)
			if(1)
				return "Through years of research a breakthrough has allowed for long range quantum entanglement of large items."
			if(2)
				return "Further advances have allowed for improved long range communication methods, slightly reducing delay times and increasing the power potiental."
			if(3)
				return "New super scanning prototypes allow for advanced computers and even more reliable quantum entanglement methods."
			if(4)
				return ""

//experimental technology that allows for exploration into bluespace
/datum/research_concepts/bluespace_manip
	name = "Bluespace manipulation"
	id = "bluespacemanip"
	short_desc = "Research into the field of experimental bluespace."
	long_desc = "Research into manipulating and exploring bluespace. Bluespace often contains exotic artifacts with strange properties that could be of use to the station staff."
	level = 0
	maxlevel = 3
	progress = 0
	max_progress = 2250
	relatedtechs = list(
					  TECH_BIO  = 2
						)
	
/datum/research_concepts/bluespace_manip/get_tech_desc(var/long = 0, var/level = 1)
	..()
	if(long)
		switch(level)
			if(1)
				return "Further research into the field of bluespace has revealed that spontanious generation of matter that inserts and removes itself from the dimension occurs at random. It is possible to travel to one of these signals when they appear, though it is risky as the location could be removed suddenly."
			if(2)
				return ""
			if(3)
				return ""
	else
		switch(level)
			if(1)
				return "By using a modified warp gate it is possible to send people into bluespace for short periods of time."
			if(2)
				return "Several enhancments to exisiting technology have allowed for more stable and prolonged bluespace exploration."
			if(3)
				return "By using "

// Materials science. The general "tech level" of everything.
/datum/research_concepts/materials_science
	name = "Materials science"
	id = "matscience"
	short_desc = "Research into the field of various materials."
	long_desc = ""
	level = 1
	maxlevel = 8
	progress = 0
	max_progress = 2000
	relatedtechs = list(
					  TECH_BIO  = 2
						)

/datum/research_concepts/quantummech/get_tech_desc(var/long = 0, var/level = 1)
	..()
	if(long)
		switch(level)
			if(1)
				return ""
			if(2)
				return ""
			if(3)
				return ""
			if(4)
				return ""
	else
		switch(level)
			if(1)
				return "Through years of research a breakthrough has allowed for long range quantum entanglement of large items."
			if(2)
				return "Further advances have allowed for improved long range communication methods, slightly reducing delay times and increasing the power potiental."
			if(3)
				return "New super scanning prototypes allow for advanced computers and even more reliable quantum entanglement methods."
			if(4)
				return ""