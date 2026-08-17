
/obj/effect/map_effect/marker/mining_conveyor
	name = "mining conveyor marker"
	desc = "See comments/documentation in code."
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "marker_mining_conveyor"

	/// If null, it will set the tag based on area.
	var/master_tag = null

/obj/effect/map_effect/marker/mining_conveyor/Initialize(mapload, ...)
	..()
	if(!master_tag)
		master_tag = "window tint control marker with area tag: [get_area(src)]"
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/marker/mining_conveyor/LateInitialize()
	if(!master_tag)
		return

	for(var/thing in loc)
		var/obj/structure/machinery/mineral/stacking_unit_console/stacking_unit_console = thing
		if(istype(stacking_unit_console))
			stacking_unit_console.id = master_tag
			continue
		var/obj/structure/machinery/mineral/stacking_machine/stacking_machine = thing
		if(istype(stacking_machine))
			stacking_machine.id = master_tag
			continue
		var/obj/structure/machinery/conveyor/conveyor = thing
		if(istype(conveyor))
			conveyor.id = master_tag
			continue
		var/obj/structure/machinery/mineral/processing_unit/processing_unit = thing
		if(istype(processing_unit))
			processing_unit.id = master_tag
			continue
		var/obj/structure/machinery/conveyor_switch/conveyor_switch = thing
		if(istype(conveyor_switch))
			conveyor_switch.id = master_tag
			continue
		var/obj/structure/machinery/mineral/processing_unit_console/processing_unit_console = thing
		if(istype(processing_unit_console))
			processing_unit_console.id = master_tag
			continue
