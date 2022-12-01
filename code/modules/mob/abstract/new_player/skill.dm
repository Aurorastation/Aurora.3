var/global/const
	SKILL_NONE = 0
	SKILL_BASIC = 1
	SKILL_ADEPT = 2
	SKILL_EXPERT = 3

datum/skill/var
	ID = "none" // ID of the skill, used in code
	name = "None" // name of the skill
	desc = "Placeholder skill" // detailed description of the skill
	field = "Misc" // the field under which the skill will be listed
	secondary = FALSE // secondary skills only have two levels and cost significantly less

var/global/list/SKILLS = null
var/list/SKILL_ENGINEER = list("field" = "Engineering", "EVA" = SKILL_ADEPT, "construction" = SKILL_ADEPT, "electrical" = SKILL_BASIC, "devices" = SKILL_BASIC, "powersource" = SKILL_ADEPT, "atmos" = SKILL_BASIC, "shipweapons" = SKILL_BASIC)
var/list/SKILL_ATMOS_TECH = list("field" = "Engineering", "EVA" = SKILL_ADEPT, "construction" = SKILL_ADEPT, "electrical" = SKILL_BASIC, "atmos" = SKILL_ADEPT)
var/list/SKILL_MACHINIST = list("field" = "Science", "devices" = SKILL_ADEPT, "electrical" = SKILL_BASIC, "computer" = SKILL_ADEPT, "anatomy" = SKILL_BASIC, "mechpilot" = SKILL_BASIC)
var/list/SKILL_SECURITY_OFFICER = list("field" = "Security", "combat" = SKILL_BASIC, "EVA" = SKILL_ADEPT, "weapons" = SKILL_ADEPT, "law" = SKILL_ADEPT, "forensics" = SKILL_BASIC)
var/list/SKILL_FIRST_RESPONDER = list("field" = "Medical", "medical" = SKILL_ADEPT, "EVA" = SKILL_ADEPT, "mechpilot" = SKILL_BASIC, "anatomy" = SKILL_BASIC, "firstaid" = SKILL_ADEPT)
var/list/SKILL_DOCTOR = list("field" = "Medical", "medical" = SKILL_ADEPT, "anatomy" = SKILL_BASIC, "firstaid" = SKILL_ADEPT)
var/list/SKILL_SURGEON = list("field" = "Medical", "medical" = SKILL_ADEPT, "anatomy" = SKILL_ADEPT, "firstaid" = SKILL_ADEPT)
var/list/SKILL_PHARMACIST = list("field" = "Medical", "chemistry" = SKILL_ADEPT, "science" = SKILL_ADEPT, "medical" = SKILL_BASIC, "devices" = SKILL_BASIC)
var/list/SKILL_BRIDGE_CREW = list("field" = "Command", "command" = SKILL_BASIC, "shipweapons" = SKILL_ADEPT, "shipsystems" = SKILL_ADEPT, "weapons" = SKILL_BASIC)
var/list/SKILL_HANGAR_TECH = list("field" = "Misc", "mechpilot" = SKILL_ADEPT, "manuallabor" = SKILL_ADEPT, "shipweapons" = SKILL_BASIC)
var/list/SKILL_MINER = list("field" = "Misc", "mechpilot" = SKILL_ADEPT, "EVA" = SKILL_ADEPT, "manuallabor" = SKILL_ADEPT, "geology" = SKILL_BASIC)
var/list/SKILL_CHEF = list("field" = "Misc", "cook" = SKILL_ADEPT, "manuallabor" = SKILL_BASIC)
var/list/SKILL_BARTENDER = list("field" = "Misc", "bartending" = SKILL_ADEPT, "manuallabor" = SKILL_BASIC)
var/list/SKILL_JANITOR = list("field" = "Misc", "manuallabor" = SKILL_ADEPT)
var/list/SKILL_SCIENTIST = list("field" = "Science", "devices" = SKILL_BASIC, "telescience" = SKILL_ADEPT, "chemistry" = SKILL_ADEPT, "computer" = SKILL_BASIC, "science" = SKILL_ADEPT)
var/list/SKILL_XENO_ARCHEOLOGIST = list("field" = "Science", "EVA" = SKILL_ADEPT, "science" = SKILL_ADEPT, "geology" = SKILL_ADEPT, "archeology" = SKILL_ADEPT)
var/global/list/SKILL_PRE = list("Engineer" = SKILL_ENGINEER, "Atmospheric Technician" = SKILL_ATMOS_TECH, "Machinist" = SKILL_MACHINIST, "Security Officer" = SKILL_SECURITY_OFFICER, "Bridge Crew" = SKILL_BRIDGE_CREW,
									"First Responder" = SKILL_FIRST_RESPONDER, "Pharmacist" = SKILL_PHARMACIST, "Doctor" = SKILL_DOCTOR, "Surgeon" = SKILL_SURGEON, "Hangar Technician" = SKILL_HANGAR_TECH,
									"Shaft Miner" = SKILL_MINER, "Chef" = SKILL_CHEF, "Bartender" = SKILL_BARTENDER, "Janitor" = SKILL_JANITOR, "Scientist" = SKILL_SCIENTIST, "Xeno Archeologist" = SKILL_XENO_ARCHEOLOGIST)

datum/skill/management
	ID = "management"
	name = "Command"
	desc = "Your ability to manage and commandeer other crew members."

datum/skill/combat
	ID = "combat"
	name = "Close Combat"
	desc = "This skill describes your training in hand-to-hand combat or melee weapon usage. While expertise in this area is rare in the era of firearms, experts still exist among athletes."
	field = "Security"

datum/skill/weapons
	ID = "weapons"
	name = "Weapons Expertise"
	desc = "This skill describes your expertise with and knowledge of weapons. A low level in this skill implies knowledge of simple weapons, for example tazers and flashes. A high level in this skill implies knowledge of complex weapons, such as grenades, riot shields, pulse rifles or bombs. A low level in this skill is typical for security officers, a high level of this skill is typical for special agents and soldiers."
	field = "Security"

datum/skill/EVA
	ID = "EVA"
	name = "Extra-vehicular activity"
	desc = "This skill describes your skill and knowledge of space-suits and working in vacuum."
	field = "Engineering"
	secondary = TRUE

datum/skill/forensics
	ID = "forensics"
	name = "Forensics"
	desc = "Describes your skill at performing forensic examinations and identifying vital evidence. Does not cover analytical abilities, and as such isn't the only indicator for your investigation skill. Note that in order to perform autopsy, the surgery skill is also required."
	field = "Security"

datum/skill/construction
	ID = "construction"
	name = "Construction"
	desc = "Your ability to construct various buildings, such as walls, floors, tables and so on. Note that constructing devices such as APCs additionally requires the Electronics skill. A low level of this skill is typical for janitors, a high level of this skill is typical for engineers."
	field = "Engineering"

datum/skill/knowledge/law
	ID = "law"
	name = "Corporate Law"
	desc = "Your knowledge of corporate law and procedures. This includes Corporate Regulations, as well as general station rulings and procedures. A low level in this skill is typical for security officers, a high level in this skill is typical for captains."
	field = "Security"
	secondary = TRUE

datum/skill/devices
	ID = "devices"
	name = "Complex Devices"
	desc = "Describes the ability to assemble complex devices, such as computers, circuits, printers, robots or gas tank assemblies(bombs). Note that if a device requires electronics or programming, those skills are also required in addition to this skill."
	field = "Science"

datum/skill/electrical
	ID = "electrical"
	name = "Electrical Engineering"
	desc = "This skill describes your knowledge of electronics and the underlying physics. A low level of this skill implies you know how to lay out wiring and configure powernets, a high level of this skill is required for working complex electronic devices such as circuits or bots."
	field = "Engineering"

datum/skill/atmos
	ID = "atmos"
	name = "Atmospherics"
	desc = "Describes your knowledge of piping, air distribution and gas dynamics. Low skill allows you to understand how to pressurize the room in a very basic way. High level allows you to know how to mix gasses in a proper manner and configure equipment for it."
	field = "Engineering"

datum/skill/power_source
	ID = "powersource"
	name = "Power Generation"
	desc = "Describes your knowledge of the various power source types common on space stations, vessels such as the supermatter, tesla or anti-matter engines as well as basic generators."
	field = "Engineering"
	secondary = TRUE

datum/skill/computer
	ID = "computer"
	name = "Information Technology"
	desc = "Describes your understanding of computers, software and communication. Not a requirement for using computers, but definitely helps. Used in telecommunications and programming of computers and AIs."
	field = "Science"

datum/skill/ship_weapons
	ID = "shipweapons"
	name = "Ship Weapons"
	desc = "Describes your understanding of how to operate large weapon systems such as ship weapons. Used in operating or maintaning weapons on the ship."
	field = "Ship Operations"

datum/skill/ship_operations
	ID = "shipsystems"
	name = "Ship Operations"
	desc = "Describes your understanding of how to operate basic ship systems like sensors an helm. Used in piloting shuttles and larger vessels alike as well as using sensors."
	field = "Ship Operations"

datum/skill/mech_pilot
	ID = "mechpilot"
	name = "Mech Piloting"
	desc = "Describes your experience and understanding of operating heavy machinery, which includes mechs and other large exosuits. Used in piloting mechs."

datum/skill/first_aid
	ID = "firstaid"
	name = "First Aid"
	desc = "Describes your understand of how to perform first aid. At low level allows you to apply basic first aid such as bandages, and small ointments. At high level allows you to perform CPR well. Does not allow you to use medical devices or any other advanced medicine."
	field = "Medical"

datum/skill/medical
	ID = "medical"
	name = "Medicine"
	desc = "Covers an understanding of the human body and medicine. At a low level, this skill gives a basic understanding of applying common types of medicine, and a rough understanding of medical devices like the health analyzer. At a high level, this skill grants exact knowledge of all the medicine available on the station, as well as the ability to use complex medical devices like the body scanner or mass spectrometer."
	field = "Medical"

datum/skill/anatomy
	ID = "anatomy"
	name = "Anatomy"
	desc = "Gives you a detailed insight of the human body. A low skill allows you to examine a person and their injuries externally. A high skill in this is required to perform surgery. This skill may also help in examining alien biology."
	field = "Medical"

datum/skill/virology
	ID = "virology"
	name = "Virology"
	desc = "This skill implies an understanding of microorganisms and their effects on humans."
	field = "Medical"

datum/skill/telescience
	ID = "telescience"
	name = "Telescience"
	desc = "Describes an understanding in how telescience, teleporation and blue-space works."
	field = "Science"

datum/skill/chemistry
	ID = "chemistry"
	name = "Chemistry"
	desc = "Experience with mixing chemicals, and an understanding of what the effect will be. This doesn't cover an understanding of the effect of chemicals on the human body, as such the medical skill is also required for medical chemists."
	field = "Science"

datum/skill/botany
	ID = "botany"
	name = "Botany"
	desc = "Describes how good a character is at growing and maintaining plants."

datum/skill/literature
	ID = "literature"
	name = "Literature"
	desc = "Describes your knowledge of literature."

datum/skill/cooking
	ID = "cooking"
	name = "Cooking"
	desc = "Describes a character's skill at preparing meals and other consumable goods. This includes mixing alcoholic beverages."

datum/skill/bartending
	ID = "bartending"
	name = "Bartending"
	desc = "Describes your knowledge of recipes for different beverages, as well as your skills in mixing them. Used for creating drinks."

datum/skill/manuallabor
	ID = "manuallabor"
	name = "Manual Labor Training"
	desc = "Describes your ability to properly perform manual labor tasks such as carrying heavy things, mining, cleaning, etc. Whether you have been trained or not on how to do it properly without hurting yourself."

datum/skill/geology
	ID = "geology"
	name = "Geology"
	desc = "Describes your knowledge of Geology. Low level only gives you knowledge of natural resources, which is an ability to discover and distinguish resources used for mining as well as know how to process raw natural resources into refined type. High level adds knowledge of astrogeology, chronology, tectonics, sedimentology which are all used for studying and discovering artifacts in any celestial bodies."
	field = "Science"

datum/skill/archeology
	ID = "archeology"
	name = "Archeology"
	desc = "Describes your knowledge of Archeology. Used for Xeno Archeology."
	field = "Science"

datum/skill/science
	ID = "science"
	name = "Science"
	desc = "Your experience and knowledge with scientific methods and processes."
	field = "Science"

datum/attribute/var
	ID = "none"
	name = "None"
	desc = "This is a placeholder"


proc/setup_skills()
	if(SKILLS == null)
		SKILLS = list()
		for(var/T in (typesof(/datum/skill)-/datum/skill))
			var/datum/skill/S = new T
			if(S.ID != "none")
				if(!SKILLS.Find(S.field))
					SKILLS[S.field] = list()
				var/list/L = SKILLS[S.field]
				L += S


mob/living/carbon/human/proc/GetSkillClass(points)
	return CalculateSkillClass(points, age)

proc/show_skill_window(var/mob/user, var/mob/living/carbon/human/M)
	if(!istype(M)) return
	if(SKILLS == null)
		setup_skills()

	if(!M.skills || M.skills.len == 0)
		to_chat(user, "There are no skills to display.")
		return

	var/HTML = "<body>"
	HTML += "<b>Select your Skills</b><br>"
	HTML += "Current skill level: <b>[M.GetSkillClass(M.used_skillpoints)]</b> ([M.used_skillpoints])<br>"
	HTML += "<table>"
	for(var/V in SKILLS)
		HTML += "<tr><th colspan = 5><b>[V]</b>"
		HTML += "</th></tr>"
		for(var/datum/skill/S in SKILLS[V])
			var/level = M.skills[S.ID]
			HTML += "<tr style='text-align:left;'>"
			HTML += "<th>[S.name]</th>"
			HTML += "<th><font color=[(level == SKILL_NONE) ? "red" : "black"]>\[Untrained\]</font></th>"
			// secondary skills don't have an amateur level
			if(S.secondary)
				HTML += "<th></th>"
			else
				HTML += "<th><font color=[(level == SKILL_BASIC) ? "red" : "black"]>\[Amateur\]</font></th>"
			HTML += "<th><font color=[(level == SKILL_ADEPT) ? "red" : "black"]>\[Trained\]</font></th>"
			HTML += "<th><font color=[(level == SKILL_EXPERT) ? "red" : "black"]>\[Professional\]</font></th>"
			HTML += "</tr>"
	HTML += "</table>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=show_skills;size=600x800")
	return

mob/living/carbon/human/verb/show_skills()
	set category = "IC"
	set name = "Show Own Skills"

	show_skill_window(src, src)
