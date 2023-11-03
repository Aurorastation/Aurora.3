/obj/machinery/kinetic_harvester
	name = "kinetic harvester"
	desc = "A complicated mechanism for harvesting rapidly moving particles from a fusion toroid and condensing them into a usable form."
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_IDLE
	icon = 'icons/obj/kinetic_harvester.dmi'
	icon_state = "off"
	manufacturer = "hephaestus"
	var/initial_id_tag
	var/list/stored =     list()
	var/list/harvesting = list()
	var/obj/machinery/power/fusion_core/harvest_from

/obj/machinery/kinetic_harvester/Initialize()
	AddComponent(/datum/component/local_network_member, initial_id_tag)
	find_core()
	queue_icon_update()
	. = ..()

/obj/machinery/kinetic_harvester/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	ui_interact(user)
	return TRUE

/obj/machinery/kinetic_harvester/attackby(obj/item/thing, mob/user)
	if(thing.ismultitool())
		var/datum/component/local_network_member/lanm = GetComponent(/datum/component/local_network_member)
		if(lanm.get_new_tag(user))
			find_core()
		return
	return ..()

/obj/machinery/kinetic_harvester/proc/find_core()
	harvest_from = null
	var/datum/component/local_network_member/lanm = GetComponent(/datum/component/local_network_member)
	var/datum/local_network/lan = lanm.get_local_network()

	if(lan)
		var/list/fusion_cores = lan.get_devices(/obj/machinery/power/fusion_core)
		if(fusion_cores && length(fusion_cores))
			harvest_from = fusion_cores[1]
	return harvest_from

/obj/machinery/kinetic_harvester/ui_interact(mob/user, datum/tgui/ui)

	if(!harvest_from && !find_core())
		to_chat(user, SPAN_WARNING("This machine cannot locate a fusion core. Please ensure the machine is correctly configured to share a fusion plant network."))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "KineticHarvester", "Kinetic Harvester")
		ui.open()

/obj/machinery/kinetic_harvester/ui_data(mob/user)
	. = ..()
	var/datum/component/local_network_member/fusion = GetComponent(/datum/component/local_network_member)
	var/datum/local_network/plant = fusion.get_local_network()
	var/list/data = list()

	data["manufacturer"] = manufacturer
	data["id"] = plant ? plant.id_tag : null
	data["status"] = (use_power >= POWER_USE_ACTIVE)
	data["materials"] = list()
	for(var/mat in stored)
		var/material/material = SSmaterials.get_material_by_name(mat)
		if(material)
			var/sheets = Floor(stored[mat]/(SHEET_MATERIAL_AMOUNT * 1.5))
			data["materials"] += list(list("material" = mat, "rawamount" = stored[mat], "amount" = sheets, "harvest" = harvesting[mat]))
	return data

/obj/machinery/kinetic_harvester/process()
	if(harvest_from && get_dist(src, harvest_from) > 10)
		harvest_from = null

	if(use_power >= POWER_USE_ACTIVE)
		if(harvest_from && harvest_from.owned_field)
			for(var/mat in harvest_from.owned_field.reactants)
				if(SSmaterials.materials_by_name[mat] && !stored[mat])
					stored[mat] = 0
			for(var/mat in harvesting)
				if(!SSmaterials.materials_by_name[mat] || !harvest_from.owned_field.reactants[mat])
					harvesting -= mat
				else
					var/harvest = min(harvest_from.owned_field.reactants[mat], rand(100,200))
					harvest_from.owned_field.reactants[mat] -= harvest
					if(harvest_from.owned_field.reactants[mat] <= 0)
						harvest_from.owned_field.reactants -= mat
					stored[mat] += harvest
		else
			harvesting.Cut()

/obj/machinery/kinetic_harvester/update_icon()
	if(inoperable())
		icon_state = "broken"
	else if(use_power >= POWER_USE_ACTIVE)
		icon_state = "on"
	else
		icon_state = "off"

/obj/machinery/kinetic_harvester/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("remove_mat")
			var/mat = params["remove_mat"]
			var/material/material = SSmaterials.get_material_by_name(mat)
			if(material)
				var/sheet_cost = (SHEET_MATERIAL_AMOUNT * 1.5)
				var/sheets = Floor(stored[mat]/sheet_cost)
				if(sheets > 0)
					var/obj/item/stack/material/M = new material.stack_type(get_turf(src), sheets)
					M.update_icon()
					stored[mat] -= sheets * sheet_cost
					if(stored[mat] <= 0)
						stored -= mat
					return TRUE

		if("toggle_power")
			use_power = (use_power >= POWER_USE_ACTIVE ? POWER_USE_IDLE : POWER_USE_ACTIVE)
			queue_icon_update()
			return TRUE

		if("toggle_harvest")
			var/mat = params["toggle_harvest"]
			if(harvesting[mat])
				harvesting -= mat
			else
				harvesting[mat] = TRUE
				if(!(mat in stored))
					stored[mat] = 0
			return TRUE
