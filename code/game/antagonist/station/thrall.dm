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
		SPECIES_SHELL_IPC,
		SPECIES_HEPHAESTUS_G1_IPC,
		SPECIES_HEPHAESTUS_G2_IPC,
		SPECIES_XION_IPC,
		SPECIES_ZENGHU_IPC,
		SPECIES_BISHOP_IPC
	)
	welcome_text = "You are a vampire or psionic operant's thrall: a pawn to be commanded by them at will."
	flags = 0
	antaghud_indicator = "hudthrall"

/datum/antagonist/thrall/New()
	..()

	thralls = src

/datum/antagonist/thrall/update_antag_mob(var/datum/mind/player)
	..()
	player.current.vampire_make_thrall()
