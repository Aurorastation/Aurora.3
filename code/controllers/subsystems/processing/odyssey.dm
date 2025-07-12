SUBSYSTEM_DEF(odyssey)
	name = "Odyssey"
	init_order = INIT_ORDER_ODYSSEY
	runlevels = RUNLEVELS_PLAYING
	can_fire = FALSE //We process only if we are running an odyssey scenario, this is set to TRUE by `pick_odyssey()`

	/// The selected scenario singleton.
	var/singleton/scenario/scenario
	/// The z-levels that the odyssey takes place in.
	var/list/scenario_zlevels = list()
	/// This is the site the odyssey takes place on. If null, then the mission takes place on a non-site zlevel.
	/// Should only be changed through set_scenario_site().
	var/datum/map_template/ruin/away_site/scenario_site
	/// A list of currently spawned actors for easy access.
	var/list/mob/living/carbon/human/actors
	/// A list of currently spawned storytellers for easy access.
	var/list/mob/abstract/ghost/storyteller/storytellers
	/// Whether or not we've sent the odyssey's roundstart report yet.
	var/has_sent_roundstart_announcement = FALSE
	/// The current station map's overmap object. We keep it here for convenience.
	var/obj/effect/overmap/visitable/ship/main_map
	/// If ships can dock on the Odyssey site. True by default, edited by the scenario.
	var/site_landing_restricted = TRUE

/datum/controller/subsystem/odyssey/Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/odyssey/Recover()
	scenario = SSodyssey.scenario
	scenario_site = SSodyssey.scenario_site
	scenario_zlevels = SSodyssey.scenario_zlevels
	actors = SSodyssey.actors
	storytellers = SSodyssey.storytellers

/datum/controller/subsystem/odyssey/fire()
	if(!has_sent_roundstart_announcement)
		// First of all, notify the Horizon.
		addtimer(CALLBACK(scenario, TYPE_PROC_REF(/singleton/scenario, send_main_map_message), main_map), rand(4 MINUTES, 6 MINUTES))
		addtimer(CALLBACK(scenario, TYPE_PROC_REF(/singleton/scenario, unrestrict_landing_and_message_horizon), main_map), 40 MINUTES)

		var/obj/effect/overmap/odyssey_site = get_odyssey_overmap_effect()

		if(odyssey_site)
			// Next, notify the offships - these announcements can happen earlier to potentially give them a bit of an edge in reaching the objective area.
			addtimer(CALLBACK(scenario, TYPE_PROC_REF(/singleton/scenario, notify_offships), odyssey_site), rand(20 MINUTES, 50 MINUTES))

		has_sent_roundstart_announcement = TRUE

/**
 * Returns the current scenario's overmap effect. Returns null if there isn't any.
 */
/datum/controller/subsystem/odyssey/proc/get_odyssey_overmap_effect()
	var/obj/effect/overmap/odyssey_site
	for(var/z in scenario_zlevels)
		odyssey_site = GLOB.map_sectors["[z]"]
		if(!istype(odyssey_site))
			continue
	return odyssey_site

/**
 * Picks a random odyssey while keeping in mind sector requirements.
 * If successful, makes the SS start firing.
 */
/datum/controller/subsystem/odyssey/proc/pick_odyssey()
	var/list/singleton/scenario/all_scenarios = GET_SINGLETON_SUBTYPE_LIST(/singleton/scenario)
	var/list/possible_scenarios = list()
	for(var/singleton/scenario/S as anything in all_scenarios)
		if((SSatlas.current_sector.name in S.sector_whitelist) || !length(S.sector_whitelist))
			possible_scenarios[S] = S.weight

	if(!length(possible_scenarios))
		log_subsystem_odyssey("CRITICAL ERROR: No available odyssey for sector [SSatlas.current_sector.name]!")
		log_and_message_admins(SPAN_DANGER(FONT_HUGE("CRITICAL ERROR: NO SITUATIONS ARE AVAILABLE FOR THIS SECTOR!")))
		return FALSE

	scenario = pickweight(possible_scenarios)
	setup_scenario_variables()
	var/list/possible_station_levels = SSmapping.levels_by_all_traits(list(ZTRAIT_STATION))
	main_map = GLOB.map_sectors["[pick(possible_station_levels)]"]

	// Now that we actually have an odyssey, the subsystem can fire!
	can_fire = TRUE

	return TRUE

/**
 * This proc overrides the gamemode variables for the amount of actors and takes care of overriding any other variables the scenario might set on external things.
 * Note that Storytellers spawn through a ghost role.
 */
/datum/controller/subsystem/odyssey/proc/setup_scenario_variables()
	var/datum/game_mode/odyssey/ody_gamemode = GLOB.gamemode_cache["odyssey"]
	if(scenario)
		ody_gamemode.required_players = scenario.min_player_amount
		ody_gamemode.required_enemies = scenario.min_actor_amount

		//Setting the scenario_type variable for use here in UI info and chat notices.
		if(!length(scenario.possible_scenario_types))
			scenario.scenario_type = SCENARIO_TYPE_NONCANON
		else if(SSatlas.current_sector in ALL_EVENT_ONLY_SECTORS) // If we are in an exclusive event area for an arc (EG. The Horizon finds itself isolated and alone), we may not want canon odysseys spawning.
			scenario.scenario_type = SCENARIO_TYPE_NONCANON // Noncanon odysseys are fine though!
		else
			scenario.scenario_type = pick(scenario.possible_scenario_types)

	site_landing_restricted = scenario.site_landing_restricted

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
/datum/controller/subsystem/odyssey/proc/add_storyteller(mob/abstract/ghost/storyteller/S)
	LAZYDISTINCTADD(storytellers, S)

/**
 * Removes an actor from the subsystem actor list.
 */
/datum/controller/subsystem/odyssey/proc/remove_actor(mob/living/carbon/human/H)
	LAZYREMOVE(actors, H)

/**
 * Removes a storyteller from the subsystem storyteller list.
 */
/datum/controller/subsystem/odyssey/proc/remove_storyteller(mob/abstract/ghost/storyteller/S)
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
		data["is_storyteller"] = isstoryteller(user) || check_rights(R_ADMIN, FALSE, user)

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
	if(.)
		return

	var/mob/odyssey_user = ui.user
	if(!ismob(odyssey_user))
		return

	var/is_admin = check_rights(R_ADMIN, FALSE, odyssey_user)

	switch(action)
		if("equip_outfit")
			if(!ishuman(odyssey_user))
				return

			var/mob/living/carbon/human/player = odyssey_user
			if(player.incapacitated())
				return

			if(!((player.z in SSodyssey.scenario_zlevels) || (isAdminLevel(player.z))))
				to_chat(player, SPAN_WARNING("You can only equip outfits on the odyssey scenario z-level, or the actor prep area!"))
				return

			var/outfit_type = text2path(params["outfit_type"])
			if(ispath(outfit_type, /obj/outfit))
				player.delete_inventory(TRUE)
				player.preEquipOutfit(outfit_type, FALSE)
				player.equipOutfit(outfit_type, FALSE)
				return TRUE

		if("edit_scenario_name")
			if(!isstoryteller(odyssey_user) && !is_admin)
				return

			var/new_scenario_name = tgui_input_text(usr, "Insert the new name for your scenario. Remember that this will be visible for anyone in the Stat Panel.", "Odyssey Panel", max_length = MAX_NAME_LEN)
			if(!new_scenario_name)
				return

			log_and_message_admins("has changed the scenario name from [SSodyssey.scenario.name] to [new_scenario_name]", odyssey_user)
			SSodyssey.scenario.name = new_scenario_name
			return TRUE

		if("edit_scenario_desc")
			if(!isstoryteller(odyssey_user) && !is_admin)
				return

			var/new_scenario_desc = tgui_input_text(odyssey_user, "Insert the new description for your scenario. This is visible only in the Odyssey Panel.", "Odyssey Panel", max_length = MAX_MESSAGE_LEN)
			if(!new_scenario_desc)
				return

			log_and_message_admins("has changed the scenario description", odyssey_user)
			SSodyssey.scenario.desc = new_scenario_desc
			return TRUE

		if("edit_role")
			if(!isstoryteller(odyssey_user) && !is_admin)
				return

			var/role_path = text2path(params["role_type"])
			if(!role_path || !ispath(role_path, /singleton/role))
				to_chat(odyssey_user, SPAN_WARNING("Invalid or inexisting role!"))
				return

			var/singleton/role/role_to_edit = GET_SINGLETON(role_path)
			var/editing_name = params["new_name"]
			var/editing_desc = params["new_desc"]
			var/editing_outfit = params["edit_outfit"]

			if(editing_name)
				var/new_name = tgui_input_text(odyssey_user, "Insert the new name for this role.", "Odyssey Panel", max_length = MAX_NAME_LEN)
				if(new_name)
					log_and_message_admins("has changed the [role_to_edit.name] role's name to [new_name]", odyssey_user)
					role_to_edit.name = new_name
					return TRUE

			if(editing_desc)
				var/new_desc = tgui_input_text(odyssey_user, "Insert the new description for this role.", "Odyssey Panel", max_length = MAX_MESSAGE_LEN)
				if(new_desc)
					log_and_message_admins("has changed the [role_to_edit.name] role's description", odyssey_user)
					role_to_edit.desc = new_desc
					return TRUE

			if(editing_outfit)
				var/chosen_outfit = tgui_input_list(odyssey_user, "Select the new outfit for this role.", "Odyssey Panel", GLOB.outfit_cache)
				if(chosen_outfit)
					var/obj/outfit/new_outfit = GLOB.outfit_cache[chosen_outfit]
					if(new_outfit)
						log_and_message_admins("has changed the [role_to_edit.name] role's outfit from [role_to_edit.outfit] to [new_outfit]", odyssey_user)
						role_to_edit.outfit = new_outfit.type
						return TRUE


