var/datum/antagonist/vampire/vamp = null

/datum/antagonist/vampire
	id = MODE_VAMPIRE
	role_text = "Vampire"
	role_text_plural = "Vampires"
	bantype = "vampires"
	feedback_tag = "vampire_objective"
	restricted_jobs = list("AI", "Cyborg", "Chaplain", "Head of Security", "Captain", "Chief Engineer", "Research Director", "Chief Medical Officer", "Head of Personnel")

	protected_jobs = list("Security Officer", "Security Cadet", "Warden", "Detective", "Forensic Technician")
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
	required_age = 10

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
