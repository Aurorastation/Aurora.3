//Progress into Xenoarch and their items
/datum/research_concepts/generalscience
	name = "Science"
	id = "genscience"
	desc = "Research into the field of general science."
	level = 1
	maxlevel = 4
	progress = 0
	max_progress = 1000
	relatedtechs = list(
					  TECH_BIO  = 2
						)

/datum/research_concepts/generalscience/get_tech_desc(var/level = 1)
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

//Progress into weapons
/datum/research_concepts/weaponstech
	name = "Weapons Technology"
	id = "weaponstech"
	desc = "Research into the field of firearms."
	level = 1
	maxlevel = 4
	progress = 0
	max_progress = 1000
	relatedtechs = list(
					  TECH_BIO  = 2
						)

/datum/research_concepts/weaponstech/get_tech_desc(var/level = 1)
	..()
	switch(level)
		if(1)
			return "A standardization effort has allowed for different parts to be attached to the same frame and still work together."
		if(2)
			return ""
		if(3)
			return "Due to new fabrication practices, it is now much easier to produce more advanced ready-to-operate weaponery."
		if(4)
			return ""

//Research into robotics
/datum/research_concepts/robotics
	name = "Robotics"
	id = "robotics"
	desc = "Research into the field of robotics."
	level = 1
	maxlevel = 4
	progress = 0
	max_progress = 1000
	relatedtechs = list(
					  TECH_BIO  = 2
						)

/datum/research_concepts/robotics/get_tech_desc(var/level = 1)
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

