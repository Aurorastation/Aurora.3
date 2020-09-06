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
		SPECIES_IPC,
		SPECIES_IPC_SHELL,
		SPECIES_IPC_G1,
		SPECIES_IPC_G2,
		SPECIES_IPC_XION,
		SPECIES_IPC_ZENGHU,
		SPECIES_IPC_BISHOP
	)
	welcome_text = "You are a vampire or psionic operant's thrall: a pawn to be commanded by them at will."
	antaghud_indicator = "hudthrall"

/datum/antagonist/thrall/New()
	..()

	thralls = src

/datum/antagonist/thrall/update_antag_mob(var/datum/mind/player)
	..()
	player.current.vampire_make_thrall()
