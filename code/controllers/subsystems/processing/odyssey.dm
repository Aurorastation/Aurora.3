SUBSYSTEM_DEF(odyssey)
	name = "Odyssey"
	init_order = INIT_ORDER_ODYSSEY
	flags = SS_BACKGROUND|SS_NO_FIRE
	wait = 8

	/// The selected scenario singleton.
	var/singleton/scenario/scenario
	/// The z-levels that the odyssey takes place in. If null, it means that there are no loaded zlevels for this odyssey.
	/// It probably takes place on the Horizon in that case.
	var/scenario_zlevel
	/// This is the site the odyssey takes place on. If null, then the mission takes place on a non-site zlevel.
	/// Should only be changed through set_scenario_site().
	var/datum/map_template/ruin/away_site/scenario_site
	/// A list of currently spawned actors for easy access.
	var/list/actors
	/// A list of currently spawned storytellers for easy access.
	var/list/storytellers
	/// Whether or not we've sent the odyssey's roundstart report yet.
	var/has_sent_roundstart_announcement = FALSE
	/// The Horizon's overmap object. We keep it here for convenience.
	var/obj/effect/overmap/visitable/ship/horizon

/datum/controller/subsystem/odyssey/Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/odyssey/Recover()
	scenario = SSodyssey.scenario
	scenario_site = SSodyssey.scenario_site
	scenario_zlevel = SSodyssey.scenario_zlevel
	actors = SSodyssey.actors
	storytellers = SSodyssey.storytellers

/datum/controller/subsystem/odyssey/fire()
	. = ..()
	if(!has_sent_roundstart_announcement)
		addtimer(CALLBACK(scenario, TYPE_PROC_REF(/singleton/scenario, notify_horizon), horizon), rand(4 MINUTES, 5 MINUTES))

/**
 * Picks a random odyssey while keeping in mind sector requirements.
 * If successful, makes the SS start firing.
 */
/datum/controller/subsystem/odyssey/proc/pick_odyssey()
	var/list/all_scenarios = GET_SINGLETON_SUBTYPE_LIST(/singleton/scenario)
	var/list/possible_scenarios = list()
	for(var/singleton/scenario/S in all_scenarios)
		if((SSatlas.current_sector.name in S.sector_whitelist) || !length(S.sector_whitelist))
			possible_scenarios[S] = S.weight

	if(!length(possible_scenarios))
		log_debug("CRITICAL ERROR: No available odyssey for sector [SSatlas.current_sector.name]!")
		log_and_message_admins(SPAN_DANGER(FONT_HUGE("CRITICAL ERROR: NO SITUATIONS ARE AVAILABLE FOR THIS SECTOR! CHANGE THE GAMEMODE MANUALLY!")))
		return

	scenario = pickweight(possible_scenarios)
	gamemode_setup()
	/// Now that we actually have an odyssey, the subsystem can fire!
	flags &= ~SS_NO_FIRE
	horizon = SSshuttle.ship_by_type(/obj/effect/overmap/visitable/ship/sccv_horizon)

/**
 * This proc overrides the gamemode variables for the amount of actors.
 * Note that Storytellers spawn through a ghost role.
 */
/datum/controller/subsystem/odyssey/proc/gamemode_setup()
	SHOULD_CALL_PARENT(TRUE)
	var/datum/game_mode/odyssey/ody_gamemode = GLOB.gamemode_cache["odyssey"]
	/// There's a bit of an issue with this: essentially, due to the fact that odyssey map loading is done after voting, you can load a map and end up
	/// not having enough actors for it, so it boots you back to the voting screen. Now you have an useless zlevel and an extra storyteller spawner.
	/// The fix for this is, currently, making odyssey force itself to start by adding antag drafting for it. Not ideal, but deleting a zlevel is an even
	// worse solution, probably.
	if(scenario)
		ody_gamemode.required_players = scenario.min_player_amount
		ody_gamemode.required_enemies = scenario.min_actor_amount

/**
 * This is the proc that should be used to set the odyssey away site.
 */
/datum/controller/subsystem/odyssey/proc/set_scenario_site(datum/map_template/ruin/away_site/site)
	if(!istype(site))
		return

	scenario_site = site

/**
 * Adds an actor to the subsystem actor list.
 */
/datum/controller/subsystem/odyssey/proc/add_actor(mob/living/carbon/human/H)
	LAZYDISTINCTADD(actors, H)

/**
 * Adds a storyteller to the subsystem storyteller list.
 */
/datum/controller/subsystem/odyssey/proc/add_storyteller(mob/abstract/storyteller/S)
	LAZYDISTINCTADD(storytellers, S)

/**
 * Removes an actor from the subsystem actor list.
 */
/datum/controller/subsystem/odyssey/proc/remove_actor(mob/living/carbon/human/H)
	LAZYREMOVE(actors, H)

/**
 * Removes a storyteller from the subsystem storyteller list.
 */
/datum/controller/subsystem/odyssey/proc/remove_storyteller(mob/abstract/storyteller/S)
	LAZYREMOVE(storytellers, S)

/datum/controller/subsystem/odyssey/ui_state()
	return GLOB.always_state

/datum/controller/subsystem/odyssey/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OdysseyPanel", "Odyssey Panel")
		ui.open()

/datum/controller/subsystem/odyssey/ui_data(mob/user)
	var/list/data = list()
	if(scenario)
		data["scenario_name"] = SSodyssey.scenario.name
		data["scenario_desc"] = SSodyssey.scenario.desc
		data["scenario_canonicity"] = SSodyssey.scenario.scenario_type == SCENARIO_TYPE_CANON ? "Canon" : "Non-Canon"
		data["is_storyteller"] = isstoryteller(user)

		if(length(scenario.roles))
			data["scenario_roles"] = list()
			for(var/role_singleton in scenario.roles)
				var/singleton/role/scenario_role = GET_SINGLETON(role_singleton)
				data["scenario_roles"] += list(
					list(
						"name" = scenario_role.name,
						"desc" = scenario_role.desc,
						"outfit" = "[scenario_role.outfit]",
						"type" = scenario_role.type
					)
				)
	return data

/datum/controller/subsystem/odyssey/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	switch(action)
		if("equip_outfit")
			if(!ishuman(usr))
				return

			var/mob/living/carbon/human/player = usr
			if(player.incapacitated())
				return

			if(player.z != SSodyssey.scenario_zlevel)
				to_chat(player, SPAN_WARNING("You can't equip an outfit on a different z-level from the scenario's!"))
				return

			var/outfit_type = text2path(params["outfit_type"])
			if(ispath(outfit_type, /obj/outfit))
				player.delete_inventory(TRUE)
				player.preEquipOutfit(outfit_type, FALSE)
				player.equipOutfit(outfit_type, FALSE)
				return TRUE

		if("edit_scenario_name")
			if(!isstoryteller(usr))
				return

			var/new_scenario_name = tgui_input_text(usr, "Insert the new name for your scenario. Remember that this will be visible for anyone in the Stat Panel.", "Odyssey Panel", max_length = MAX_NAME_LEN)
			if(!new_scenario_name)
				return

			log_and_message_admins("has changed the scenario name from [SSodyssey.scenario.name] to [new_scenario_name]")
			SSodyssey.scenario.name = new_scenario_name
			return TRUE

		if("edit_scenario_desc")
			if(!isstoryteller(usr))
				return

			var/new_scenario_desc = tgui_input_text(usr, "Insert the new description for your scenario. This is visible only in the Odyssey Panel.", "Odyssey Panel", max_length = MAX_MESSAGE_LEN)
			if(!new_scenario_desc)
				return

			log_and_message_admins("has changed the scenario description")
			SSodyssey.scenario.desc = new_scenario_desc
			return TRUE

		if("edit_role")
			if(!isstoryteller(usr) && !check_rights(R_ADMIN))
				return

			var/role_path = text2path(params["role_type"])
			if(!role_path || !ispath(role_path, /singleton/role))
				to_chat(usr, SPAN_WARNING("Invalid or inexisting role!"))
				return

			var/singleton/role/role_to_edit = GET_SINGLETON(role_path)
			var/editing_name = params["new_name"]
			var/editing_desc = params["new_desc"]
			var/editing_outfit = params["edit_outfit"]

			if(editing_name)
				var/new_name = tgui_input_text(usr, "Insert the new name for this role.", "Odyssey Panel", max_length = MAX_NAME_LEN)
				if(new_name)
					log_and_message_admins("has changed the [role_to_edit.name] role's name to [new_name]")
					role_to_edit.name = new_name
					return TRUE

			if(editing_desc)
				var/new_desc = tgui_input_text(usr, "Insert the new description for this role.", "Odyssey Panel", max_length = MAX_MESSAGE_LEN)
				if(new_desc)
					log_and_message_admins("has changed the [role_to_edit.name] role's description")
					role_to_edit.desc = new_desc
					return TRUE

			if(editing_outfit)
				var/chosen_outfit = tgui_input_list(usr, "Select the new outfit for this role.", "Odyssey Panel", GLOB.outfit_cache)
				if(chosen_outfit)
					var/obj/outfit/new_outfit = GLOB.outfit_cache[chosen_outfit]
					if(new_outfit)
						log_and_message_admins("has changed the [role_to_edit.name] role's outfit from [role_to_edit.outfit] to [new_outfit]")
						role_to_edit.outfit = new_outfit.type
						return TRUE


