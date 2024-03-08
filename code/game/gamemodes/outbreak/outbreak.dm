/datum/game_mode/outbreak
	name = "Outbreak"
	config_tag = "outbreak"
	required_players = 0
	required_enemies = 0
	round_description = "Your survival is not guaranteed."
	extended_round_description = "Complete. Global. Saturation."
	antag_tags = list(MODE_OUTBREAK)
	votable = 0

/datum/game_mode/outbreak/ui_state(mob/user)
	return GLOB.admin_state

/datum/game_mode/outbreak/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/game_mode/outbreak/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Outbreak", "Outbreak Controller", 330, 720)
		ui.open()

/datum/game_mode/outbreak/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/obj/effect/landmark/outbreak_zombie
	name = "Simple Zombie Marker"

/obj/effect/landmark/outbreak_zombie/ipc
	name = "IPC Zombie Landmark"
