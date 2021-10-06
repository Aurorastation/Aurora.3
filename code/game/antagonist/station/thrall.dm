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
	flags = ANTAG_NO_ROUNDSTART_SPAWN
	welcome_text = "You are a vampire or psionic operant's thrall: a pawn to be commanded by them at will."
	antaghud_indicator = "hudthrall"

/datum/antagonist/thrall/New()
	..()

	thralls = src

/datum/antagonist/thrall/handle_latelogin(var/mob/user)
	var/datum/mind/M = user.mind
	if(!M)
		return
	var/datum/vampire/vampire = M.antag_datums[MODE_VAMPIRE]
	if(vampire.master_image)
		user.client.images += vampire.master_image

/datum/antagonist/thrall/update_antag_mob(var/datum/mind/player)
	..()
	player.current.vampire_make_thrall()

/datum/antagonist/thrall/remove_antagonist(datum/mind/player, show_message, implanted)
	var/datum/vampire/vampire = player.antag_datums[MODE_VAMPIRE]
	vampire.lose_master(player.current)
	player.antag_datums -= MODE_VAMPIRE
	return ..()