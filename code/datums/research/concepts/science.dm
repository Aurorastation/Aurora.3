//Progress into Xenoarch and their items
/datum/research_concepts/xenoarch
	name = "Xenoarcheology"
	id = "xenoarch"
	desc = "Research into the field of xenoarcheology."
	level = 1
	maxlevel = 4
	progress = 0
	max_progress = 1000
	relatedtechs = list(
					  TECH_BIO  = 2
						)

/datum/research_concepts/xenoarch/get_tech_desc(var/level = 1)
	..()
	switch(level)
		if(1)
			return ""
		if(2)
			return ""
		if(3)
			return ""
		if(4)
			return "Thanks to new advanced scanning technologies, modifications can be made to an existing gateway design that allows it to seek out areas in distant lands that have a high level of anomalous materials detected."

//Progress into Xenoarch and their mcbobs
/datum/research_concepts/weaponstech
	name = "Weapons Technology"
	id = "weaponstech"
	desc = "Research into the field of firearms."
	level = 1
	maxlevel = 5
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
			return ""
		if(4)
			return ""