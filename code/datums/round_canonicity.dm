/// Actions taken during this round are canon. Antagonist actions are not considered here; see below.
#define ROUND_FULL_CANON				1
/// Nothing in the round is canon; such as in a non-canon event. Things are forgotten the next round.
#define ROUND_NON_CANON	 				2

/// Antagonist actions are not expected during this round.
#define ANTAGONIST_ACTIONS_NOT_EXPECTED 0
/// Antagonist actions are canon during this round.
#define ANTAGONIST_ACTIONS_CANON		1
/// Antagonist actions are NOT canon during this round.
#define ANTAGONIST_ACTIONS_NOT_CANON	2

/// If character deaths are limited, and thus can be retconned if all player parties agree.
#define LIMITED_CHARACTER_DEATH			1
/// If players are FORCED to keep character deaths canon. In this case, ALL CHARACTER DEATHS MUST GO THROUGH HEADMINS AND LOREMASTERS TO BE RETCONNED. THERE ARE NO EXCEPTIONS!
#define FORCED_CHARACTER_DEATH			2
/// Character deaths are automatically not-canon. Usually rhe case in non-canon events.
#define NO_CHARACTER_DEATH				3

/singleton/canonicity
	/// This is the name of the canonicity type.
	var/name = "Round Canonicity"
	/// The description. Should fill in the users about the details of the round canonicity.
	var/desc = "This is a base type, report this to a dev if it somehow happens to be used."
	/// If the round itself is canon or not. Non-canon rounds are things like non-canon events, where everything is "forgotten" the next round.
	var/round_canon
	/// If antagonist actions are canon during this round.
	var/antagonist_actions_canon
	/// If character deaths are canon during this round.
	var/character_death_canon

/**
 * This proc is automatically called on /datum/game_mode/proc/pre_game_setup().
 * See that proc for details.
 */
/singleton/canonicity/proc/pre_game_setup()
	return

/**
 * Called when someone clicks on the stat panel entry to open the canon panel TGUI.
 */
/singleton/canonicity/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CanonPanel", "Canon Panel")
		ui.open()

/singleton/canonicity/ui_state(mob/user)
	return GLOB.always_state

/singleton/canonicity/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/singleton/canonicity/ui_data(mob/user)
	var/list/data = list()
	data["name"] = name
	data["desc"] = desc
	data["round_canon_info"] = round_canon_info()
	data["antagonist_actions_canon_info"] = antagonist_actions_canon_info()
	data["character_death_canon_info"] = character_death_canon_info()

	data["is_storyteller"] = isstoryteller(user)
	data["is_admin"] = check_rights(R_ADMIN, FALSE, user)
	return data

/singleton/canonicity/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("edit_round_canon_type")
			var/singleton/canonicity/canon_types = GET_SINGLETON_SUBTYPE_LIST(/singleton/canonicity)
			var/singleton/canonicity/selected_canon = tgui_input_list(ui.user, "Select a new canonicity for this round.", "Canon Panel", canon_types)
			if(istype(selected_canon))
				var/changer = ui.user
				SSticker.set_round_canon(selected_canon.type, FALSE, TRUE)
				SStgui.close_all_uis(src)
				message_admins(SPAN_DANGER("[changer] has changed the round canonicity to [SSticker.round_canon.name]."))

/singleton/canonicity/proc/round_canon_info()
	. = list()
	switch(round_canon)
		if(ROUND_FULL_CANON)
			. += "This round is canon. All actions taken by non-antagonists during this round are considered canon."
		if(ROUND_NON_CANON)
			. += "This round is non-canon. All actions taken during this round are considered non-canon."

/singleton/canonicity/proc/antagonist_actions_canon_info()
	. = list()
	switch(antagonist_actions_canon)
		if(ANTAGONIST_ACTIONS_NOT_EXPECTED)
			. += "Antagonist actions are not expected during this round."
		if(ANTAGONIST_ACTIONS_CANON)
			. += "Antagonist actions are canon during this round. This includes event antagonists."
		if(ANTAGONIST_ACTIONS_NOT_CANON)
			. += "Antagonist actions are not canon during this round."
			. += "This includes actions by non-antagonists directly influenced by antagonists."

/singleton/canonicity/proc/character_death_canon_info()
	. = list()
	switch(character_death_canon)
		if(LIMITED_CHARACTER_DEATH)
			. += "Character deaths are limited during this round. If all involved parties agree, character deaths can be retconned."
			. += "To count as involved, a player has to be an active participant of your death, meaning that they must have intentionally contributed to it. As an example, if you die to a carp on an expedition, you can retcon this death without asking others."
		if(FORCED_CHARACTER_DEATH)
			. += "Character deaths are forced canon during this round. All character deaths must go through headmins and loremasters to be retconned. There are no exceptions to this!"
		if(NO_CHARACTER_DEATH)
			. += "Character deaths are not canon during this round."

/singleton/canonicity/extended
	name = "Extended Canon"
	desc = "This type of canonicity is in place for Extended rounds or canon events."
	round_canon = ROUND_FULL_CANON
	antagonist_actions_canon = ANTAGONIST_ACTIONS_NOT_EXPECTED
	character_death_canon = LIMITED_CHARACTER_DEATH

/singleton/canonicity/odyssey
	name = "Odyssey Canon"
	desc = "This type of canonicity is in place for Odyssey rounds, where antagonists are present and their actions are considered canon."
	round_canon = ROUND_FULL_CANON
	antagonist_actions_canon = ANTAGONIST_ACTIONS_CANON
	character_death_canon = LIMITED_CHARACTER_DEATH

/singleton/canonicity/limited
	name = "Limited Canon"
	desc = "This type of canonicity is in place for Secret rounds or Odysseys where the antagonist actions are not considered canon."
	round_canon = ROUND_FULL_CANON
	antagonist_actions_canon = ANTAGONIST_ACTIONS_NOT_CANON
	character_death_canon = LIMITED_CHARACTER_DEATH

/singleton/canonicity/canon_event
	name = "Full Canon"
	desc = "This type of canonicity is in place for canon event rounds."
	round_canon = ROUND_FULL_CANON
	antagonist_actions_canon = ANTAGONIST_ACTIONS_CANON
	character_death_canon = FORCED_CHARACTER_DEATH

/singleton/canonicity/non_canon_event
	name = "Non-Canon Event"
	desc = "This type of canonicity is in place for non-canon events."
	round_canon = ROUND_NON_CANON
	antagonist_actions_canon = ANTAGONIST_ACTIONS_NOT_CANON
	character_death_canon = NO_CHARACTER_DEATH
