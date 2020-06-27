var/datum/antagonist/thrall/thralls = null

/datum/antagonist/thrall
	id = MODE_THRALL
	role_text = "Thrall"
	role_text_plural = "Thralls"
	bantype = "vampires"
	feedback_tag = "thrall_objective"
	restricted_jobs = list("AI", "Cyborg", "Chaplain")
	protected_jobs = list()
	restricted_species = list(
		"Baseline Frame",
		"Shell Frame",
		"Hephaestus G1 Industrial Frame",
		"Hephaestus G2 Industrial Frame",
		"Xion Industrial Frame",
		"Zeng-Hu Mobility Frame",
		"Bishop Accessory Frame"
	)
	welcome_text = "You are a vampire or psionic operant's thrall: a pawn to be commanded by them at will."
	antaghud_indicator = "hudthrall"

/datum/antagonist/thrall/New()
	..()

	thralls = src

/datum/antagonist/thrall/update_antag_mob(var/datum/mind/player)
	..()
	player.current.vampire_make_thrall()
