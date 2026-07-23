/obj/structure/machinery/kinetic_harvester
	name = "kinetic harvester"
	desc = "A complicated mechanism for harvesting rapidly moving particles from a fusion toroid and condensing them into a usable form."
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_IDLE
	icon = 'icons/obj/kinetic_harvester.dmi'
	icon_state = "off"
	manufacturer = "hephaestus"
	var/initial_id_tag
	var/list/stored =      list()
	var/list/harvesting =  list()
	var/list/can_harvest = list()
	var/obj/structure/machinery/power/fusion_core/harvest_from

/obj/structure/machinery/kinetic_harvester/Initialize()
	can_harvest = list(
		MATERIAL_GOLD = TRUE,
		MATERIAL_SILVER = TRUE,
		MATERIAL_LEAD = TRUE,
		MATERIAL_PLATINUM = TRUE,
		MATERIAL_URANIUM = TRUE,
		MATERIAL_OSMIUM = TRUE,
		MATERIAL_GLASS_PHORON = TRUE
	)
	AddComponent(/datum/component/local_network_member, initial_id_tag)
	find_core()
	queue_icon_update()
	. = ..()

/obj/structure/machinery/kinetic_harvester/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	ui_interact(user)
	return TRUE

/obj/structure/machinery/kinetic_harvester/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour == TOOL_MULTITOOL)
		var/datum/component/local_network_member/lanm = GetComponent(/datum/component/local_network_member)
		if(lanm.get_new_tag(user))
			find_core()
		return
	return ..()

/obj/structure/machinery/kinetic_harvester/proc/find_core()
	harvest_from = null
	var/datum/component/local_network_member/lanm = GetComponent(/datum/component/local_network_member)
	var/datum/local_network/lan = lanm.get_local_network()

	if(lan)
		var/list/fusion_cores = lan.get_devices(/obj/structure/machinery/power/fusion_core)
		if(fusion_cores && length(fusion_cores))
			harvest_from = fusion_cores[1]
	return harvest_from

/obj/structure/machinery/kinetic_harvester/proc/get_harvest_material(var/mat)
	return SSmaterials.get_material_by_id(mat, FALSE)

/obj/structure/machinery/kinetic_harvester/proc/get_harvest_material_path(var/mat)
	return SSmaterials.material_to_path(mat, FALSE)

/obj/structure/machinery/kinetic_harvester/proc/normalize_harvest_storage()
	SSmaterials.normalize_material_amounts(stored)

	var/list/normalized_harvesting = list()
	for(var/mat in harvesting)
		var/material_path = get_harvest_material_path(mat)
		if(material_path && can_harvest[material_path])
			normalized_harvesting[material_path] = TRUE
	harvesting = normalized_harvesting

/obj/structure/machinery/kinetic_harvester/proc/sync_harvestable_reactants()
	normalize_harvest_storage()
	if(!harvest_from || !harvest_from.owned_field)
		return

	for(var/reactant in harvest_from.owned_field.reactants)
		var/material_path = get_harvest_material_path(reactant)
		if(material_path && can_harvest[material_path] && isnull(stored[material_path]))
			stored[material_path] = 0

/obj/structure/machinery/kinetic_harvester/proc/get_reactant_key(var/material_path)
	if(!harvest_from || !harvest_from.owned_field || !material_path)
		return

	for(var/reactant in harvest_from.owned_field.reactants)
		if(get_harvest_material_path(reactant) == material_path)
			return reactant

/obj/structure/machinery/kinetic_harvester/ui_interact(mob/user, datum/tgui/ui)

	if(!harvest_from && !find_core())
		to_chat(user, SPAN_WARNING("This machine cannot locate a fusion core. Please ensure the machine is correctly configured to share a fusion plant network."))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "KineticHarvester", "Kinetic Harvester")
		ui.open()

/obj/structure/machinery/kinetic_harvester/ui_data(mob/user)
	. = ..()
	var/datum/component/local_network_member/fusion = GetComponent(/datum/component/local_network_member)
	var/datum/local_network/plant = fusion.get_local_network()
	var/list/data = list()
	sync_harvestable_reactants()

	data["manufacturer"] = manufacturer
	data["id"] = plant ? plant.id_tag : null
	data["status"] = (use_power >= POWER_USE_ACTIVE)
	data["materials"] = list()
	for(var/mat in stored)
		var/singleton/material/material = get_harvest_material(mat)
		if(material)
			var/sheets = FLOOR(stored[mat]/(SHEET_MATERIAL_AMOUNT * 2), 1)
			data["materials"] += list(list("id" = "[material.type]", "material" = SSmaterials.material_display_name(mat), "rawamount" = stored[mat], "amount" = sheets, "harvest" = harvesting[mat]))
	return data

/obj/structure/machinery/kinetic_harvester/process()
	if(harvest_from && get_dist(src, harvest_from) > 10)
		harvest_from = null

	if(use_power >= POWER_USE_ACTIVE)
		if(harvest_from && harvest_from.owned_field)
			sync_harvestable_reactants()
			for(var/mat in harvest_from.owned_field.reactants)
				var/material_path = get_harvest_material_path(mat)
				if(material_path && can_harvest[material_path] && isnull(stored[material_path]))
					stored[material_path] = 0
			for(var/mat in harvesting)
				if(can_harvest[mat])
					var/reactant = get_reactant_key(mat)
					if(!isnull(reactant))
						var/harvest = min(harvest_from.owned_field.reactants[reactant], rand(100,200))
						// Leave a few counts of the reactant to avoid deactivating harvest mode
						harvest_from.owned_field.reactants[reactant] -= (harvest - rand(0,5))
						if(harvest_from.owned_field.reactants[reactant] <= 0)
							harvest_from.owned_field.reactants -= reactant
						stored[mat] += harvest
		else
			harvesting.Cut()

/obj/structure/machinery/kinetic_harvester/update_icon()
	if(!operable())
		icon_state = "broken"
	else if(use_power >= POWER_USE_ACTIVE)
		icon_state = "on"
	else
		icon_state = "off"

/obj/structure/machinery/kinetic_harvester/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("remove_mat")
			var/mat = get_harvest_material_path(params["remove_mat"])
			if(!mat || !can_harvest[mat])
				return
			var/singleton/material/material = get_harvest_material(mat)
			if(material)
				var/sheet_cost = (SHEET_MATERIAL_AMOUNT * 1.5)
				var/stored_amount = stored[mat] || 0
				var/sheets = min(FLOOR(stored_amount/sheet_cost, 1), 50)
				if(sheets > 0)
					var/obj/item/stack/material/M = new material.stack_type(get_turf(src), sheets)
					M.update_icon()
					stored[mat] -= sheets * sheet_cost
					if(stored[mat] <= 0)
						stored -= mat
					return TRUE

		if("toggle_power")
			use_power = (use_power >= POWER_USE_ACTIVE ? POWER_USE_IDLE : POWER_USE_ACTIVE)
			if(use_power >= POWER_USE_ACTIVE)
				sync_harvestable_reactants()
			queue_icon_update()
			return TRUE

		if("toggle_harvest")
			var/mat = get_harvest_material_path(params["toggle_harvest"])
			if(!mat || !can_harvest[mat])
				return
			if(harvesting[mat])
				harvesting -= mat
			else
				harvesting[mat] = TRUE
				if(!(mat in stored))
					stored[mat] = 0
			return TRUE
