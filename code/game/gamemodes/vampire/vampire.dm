/datum/game_mode/vampire
	name = "Vampire"
	round_description = "There are Vampires from Space Transylvania on the station, keep your blood close and neck safe!"
	extended_round_description = "Life always finds a way. However, life can sometimes take a more disturbing route. Humanity's extensive knowledge of xeno-biological specimens has made them confident and arrogant. Yet something slipped past their eyes. Something dangerous. Something alive. Most frightening of all, however, is that this something is someone. An unknown alien specimen has incorporated itself into the crew of the NSS Exodus. No one knows where it came from. No one knows who it is or what it wants. One thing is for certain though... there is never just one of them. Good luck."
	config_tag = "vampire"
	required_players = 1
	required_enemies = 1
	end_on_antag_death = 1
	antag_scaling_coeff = 8
	antag_tags = list(MODE_VAMPIRE)

/datum/game_mode/vampire/verb/vampire_help()
	set category = "Vampire"
	set name = "Display Help"
	set desc = "Opens help window with overview of available powers and other important information."
	var/mob/living/carbon/human/user = usr

	var/help = file2text('ingame_manuals/vampire.html')
	if(!help)
		help = "Error loading help (file /ingame_manuals/vampire.html is probably missing). Please report this to server administration staff."

	user << browse(help, "window=vampire_help;size=600x500")
