/*
Destructive Analyzer

It is used to destroy hand-held objects and advance technological research. Controls are in the linked R&D console.

Note: Must be placed within 3 tiles of the R&D Console
*/

/obj/machinery/r_n_d/destructive_analyzer
	name = "destructive analyzer"
	desc = "A cutting-edge research device that allows scientists to discover and further knowledge in fields that were used in the manufacture of certain objects."
	icon_state = "d_analyzer"
	var/obj/item/loaded_item = null
	var/decon_mod = 0

	use_power = 1
	idle_power_usage = 30
	active_power_usage = 2500

	component_types = list(
		/obj/item/circuitboard/destructive_analyzer,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/micro_laser
	)

/obj/machinery/r_n_d/destructive_analyzer/RefreshParts()
	var/T = 0

	for(var/obj/item/stock_parts/S in component_parts)
		T += S.rating
	decon_mod = T * 0.1

/obj/machinery/r_n_d/destructive_analyzer/update_icon()
	if(panel_open)
		icon_state = "d_analyzer_t"
	else if(loaded_item)
		icon_state = "d_analyzer_l"
	else
		icon_state = "d_analyzer"

/obj/machinery/r_n_d/destructive_analyzer/attackby(var/obj/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy right now.</span>")
		return
	if(loaded_item)
		to_chat(user, "<span class='notice'>There is something already loaded into \the [src].</span>")
		return 1
	if(default_deconstruction_screwdriver(user, O))
		if(linked_console)
			linked_console.linked_destroy = null
			linked_console = null
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(panel_open)
		to_chat(user, "<span class='notice'>You can't load \the [src] while it's opened.</span>")
		return 1
	if(!linked_console)
		to_chat(user, "<span class='notice'>\The [src] must be linked to an R&D console first.</span>")
		return
	if(istype(O, /obj/item) && !loaded_item)
		if(!O.dropsafety()) //Don't put your module items in there!
			return
		if(!O.origin_tech)
			to_chat(user, "<span class='notice'>This doesn't seem to have a tech origin.</span>")
			return
		if(O.origin_tech.len == 0)
			to_chat(user, "<span class='notice'>You cannot deconstruct this item.</span>")
			return
		busy = 1
		loaded_item = O
		user.drop_from_inventory(O,src)
		to_chat(user, "<span class='notice'>You add \the [O] to \the [src].</span>")
		flick("d_analyzer_la", src)
		spawn(10)
			update_icon()
			busy = 0
		if(linked_console.screen == 2.1)
			linked_console.screen = 2.2
			linked_console.updateUsrDialog()
		return 1
	return
