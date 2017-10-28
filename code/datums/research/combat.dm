//Explains laser technology.
/datum/research_concepts/laser_tech
	name = "Laser Technology"
	id = "lasertech"
	short_desc = "Research into the field of lasers, both big and small."
	long_desc = "Through the use of very powerful lasers and focusers, the power of energy can be put to use in both combat and scientic situations."
	level = 1
	maxlevel = 4
	progress = 0
	max_progress = 1250
	relatedtechs = list(
					  TECH_BIO  = 2
						)

/datum/research_concepts/laser_tech/get_tech_desc(var/long = 0, var/level = 1)
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
				return ""
			if(2)
				return ""
			if(3)
				return ""
			if(4)
				return ""