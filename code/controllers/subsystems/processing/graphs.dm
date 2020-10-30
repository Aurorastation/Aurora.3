var/datum/controller/subsystem/processing/graphs/SSgraphs_process
/datum/controller/subsystem/processing/graphs
	name = "Graphs (Process)"
	init_order = SS_INIT_GRAPHS
	priority = SS_PRIORITY_GRAPH

/datum/controller/subsystem/processing/graphs/New()
	NEW_SS_GLOBAL(SSgraphs_process)