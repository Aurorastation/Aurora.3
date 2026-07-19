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
	/// If away sites are canon or not. It's a bit more complex than just that; see the relevant defines.
	var/away_site_canon
	/// If offships are canon or not. It's a bit more complex than just that; see the relevant defines.
	var/offship_canon

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

/singleton/canonicity/ui_static_data(mob/user)
	var/list/data = list()

	data["name"] = name
	data["desc"] = desc

	data["round_canon_info"] = round_canon_info()
	data["antagonist_actions_canon_info"] = antagonist_actions_canon_info()
	data["character_death_canon_info"] = character_death_canon_info()
	data["away_site_canon_info"] = away_site_canon_info()
	data["offship_canon_info"] = offship_canon_info()

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
			. += "Character deaths are limited during this round. If all involved parties agree, character deaths can be retconned. If you would like to contest a death, or determine if a party counts as involved, please adminhelp."
			. += "To count as involved, a player has to be an active participant of your death, meaning that they must have intentionally contributed to it. As an example, if you die to a carp on an expedition, you can retcon this death without asking others."
		if(FORCED_CHARACTER_DEATH)
			. += "Character deaths are forced canon during this round. All character deaths must go through headmins and loremasters to be retconned, no exceptions!"
			. += "All injuries sustained as part of this round are immediately and fully canon, and should be roleplayed to the best of your ability, both in this round and the following. \
				Do not ignore an injury you have obtained without explicit approval from administration. You are expected to roleplay its consequences believably, even extending to following rounds."
		if(NO_CHARACTER_DEATH)
			. += "Character deaths are not canon during this round."

/singleton/canonicity/proc/away_site_canon_info()
	. = list()
	switch(away_site_canon)
		if(AWAY_SITE_NOT_CANON)
			. += "Away sites are not canon this round."
		if(AWAY_SITE_CANON_LIMITED)
			. += "Away site canon is limited. This means that while it is canon that you go to an away site, the exact details of where you went are not. You can say that you went to a greimorian infested station, for example, \
				but you cannot remember the same away site across rounds."
		if(AWAY_SITE_CANON_FULL)
			. += "Away sites are canon, including the exact details."

/singleton/canonicity/proc/offship_canon_info()
	. = list()
	switch(offship_canon)
		if(OFFSHIP_NOT_CANON)
			. += "Offship actions are not canon during this round."
		if(OFFSHIP_CANON_LIMITED)
			. += "Offship action canon is limited. This means that offship actions are canon, barring hostile actions taken against the [SSatlas.current_map.full_name]. If anything is unclear, make sure to adminhelp."
		if(OFFSHIP_CANON_FULL)
			. += "Offship actions are canon during this round."

/singleton/canonicity/extended
	name = "Extended Canon"
	desc = "This type of canonicity is in place for Extended rounds or canon events."
	round_canon = ROUND_FULL_CANON
	antagonist_actions_canon = ANTAGONIST_ACTIONS_NOT_EXPECTED
	character_death_canon = LIMITED_CHARACTER_DEATH
	away_site_canon = AWAY_SITE_CANON_LIMITED
	offship_canon = OFFSHIP_CANON_LIMITED

/singleton/canonicity/odyssey
	name = "Odyssey Canon"
	desc = "This type of canonicity is in place for Odyssey rounds, where antagonists are present and their actions are considered canon."
	round_canon = ROUND_FULL_CANON
	antagonist_actions_canon = ANTAGONIST_ACTIONS_CANON
	character_death_canon = LIMITED_CHARACTER_DEATH
	away_site_canon = AWAY_SITE_CANON_LIMITED
	offship_canon = OFFSHIP_CANON_LIMITED

/singleton/canonicity/limited
	name = "Limited Canon"
	desc = "This type of canonicity is in place for Secret rounds or Odysseys where the antagonist actions are not considered canon."
	round_canon = ROUND_FULL_CANON
	antagonist_actions_canon = ANTAGONIST_ACTIONS_NOT_CANON
	character_death_canon = LIMITED_CHARACTER_DEATH
	away_site_canon = AWAY_SITE_CANON_LIMITED
	offship_canon = OFFSHIP_CANON_LIMITED

/singleton/canonicity/canon_event
	name = "Full Canon"
	desc = "This type of canonicity is in place for canon event rounds."
	round_canon = ROUND_FULL_CANON
	antagonist_actions_canon = ANTAGONIST_ACTIONS_CANON
	character_death_canon = FORCED_CHARACTER_DEATH
	away_site_canon = AWAY_SITE_CANON_FULL
	offship_canon = OFFSHIP_CANON_FULL

/singleton/canonicity/non_canon_event
	name = "Non-Canon Event"
	desc = "This type of canonicity is in place for non-canon events."
	round_canon = ROUND_NON_CANON
	antagonist_actions_canon = ANTAGONIST_ACTIONS_NOT_CANON
	character_death_canon = NO_CHARACTER_DEATH
	away_site_canon = AWAY_SITE_NOT_CANON
	offship_canon = OFFSHIP_NOT_CANON
