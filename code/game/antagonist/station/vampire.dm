var/datum/antagonist/vampire/vamp = null

/datum/antagonist/vampire
	id = MODE_VAMPIRE
	role_text = "Vampire"
	role_text_plural = "Vampires"
	bantype = "vampires"
	feedback_tag = "vampire_objective"
	restricted_jobs = list("AI", "Cyborg", "Chaplain", "Head of Security", "Captain", "Internal Affairs Agent")
	protected_jobs = list("Security Officer", "Security Cadet", "Warden", "Detective", "Forensic Technician")
	chance_restricted_jobs = list("Security Officer" = 50, "Security Cadet" = 75, "Warden" = 25, "Detective" = 25, "Forensic Technician" = 50, "Head of Personnel" = 25, "Chief Engineer" = 25, "Research Director" = 25, "Chief Medical Officer" = 25) //Second value is chance to be considered for antag. Unlisted roles here are 100 by default.

	restricted_species = list(
		"Baseline Frame",
		"Shell Frame",
		"Hephaestus G1 Industrial Frame",
		"Diona",
		"Hephaestus G2 Industrial Frame",
		"Xion Industrial Frame",
		"Zeng-Hu Mobility Frame",
		"Bishop Accessory Frame"
	)

	welcome_text = "You are a Vampire! Use the \"<b>Vampire Help</b>\" command to learn about the backstory and mechanics! Stay away from the Chaplain, and use the darkness to your advantage."
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	antaghud_indicator = "hudvampire"

/datum/antagonist/vampire/New()
	..()

	vamp = src

	for (var/type in vampirepower_types)
		vampirepowers += new type()

/datum/antagonist/vampire/update_antag_mob(var/datum/mind/player)
	..()
	player.current.make_vampire()
