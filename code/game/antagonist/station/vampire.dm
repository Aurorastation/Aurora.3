var/datum/antagonist/vampire/vamp = null

/datum/antagonist/vampire
	id = MODE_VAMPIRE
	role_text = "Vampire"
	role_text_plural = "Vampires"
	bantype = "vampires"
	feedback_tag = "vampire_objective"
	restricted_jobs = list("AI", "Cyborg", "Chaplain", "Head of Security", "Captain", "Internal Affairs Agent")
	protected_jobs = list("Security Officer", "Warden", "Detective")
	restricted_species = list("Machine", "Diona")
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
