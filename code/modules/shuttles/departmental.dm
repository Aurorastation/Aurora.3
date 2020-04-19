/obj/machinery/computer/shuttle_control/mining
	name = "mining shuttle control console"
	shuttle_tag = "Mining"
	circuit = /obj/item/circuitboard/mining_shuttle

/obj/machinery/computer/shuttle_control/engineering
	name = "engineering shuttle control console"
	shuttle_tag = "Engineering"
	circuit = /obj/item/circuitboard/engineering_shuttle

/obj/machinery/computer/shuttle_control/research
	name = "research shuttle control console"
	shuttle_tag = "Research Shuttle"
	req_access = list(access_research)
	circuit = /obj/item/circuitboard/research_shuttle

/datum/shuttle/autodock/ferry/research_aurora
	var/triggered_away_sites = FALSE

/datum/shuttle/autodock/ferry/research_aurora/shuttle_moved()
	. = ..()
	if(!triggered_away_sites)
		for(var/s in SSghostroles.spawners)
			var/datum/ghostspawner/G = SSghostroles.spawners[s]
			if(G.away_site)
				G.enable()
		triggered_away_sites = TRUE

/obj/machinery/computer/shuttle_control/merchant
	name = "merchant shuttle control console"
	req_access = list(access_merchant)
	shuttle_tag = "Merchant Shuttle"