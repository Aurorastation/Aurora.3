
#define TEA_MODE_PROCESS 0
#define TEA_MODE_BLEND 1

/obj/machinery/teamatic
	name = "Tea-o-matic"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "teamatic"
	layer = 2.9
	density = 1
	anchored = 0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 1000
	flags = OPENCONTAINER | NOREACT
	var/operating = 0 
	var/mode = 0
	var/static/list/acceptable_items 
	var/static/list/acceptable_reagents 
	var/static/max_n_of_items = 5
	var/appliancetype = TEAMATIC

#undef TEA_MODE_PROCESS
#undef TEA_MODE_BLEND