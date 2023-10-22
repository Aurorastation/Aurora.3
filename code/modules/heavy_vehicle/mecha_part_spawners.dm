/obj/effect/map_effect/mecha_part_spawner
	name = "mecha part spawner"
	icon_state = "beam_point"

	var/list/parts_to_spawn = list()

/obj/effect/map_effect/mecha_part_spawner/Initialize(mapload)
	..()
	parts_to_spawn = get_parts_to_spawn()
	spawn_parts()
	return INITIALIZE_HINT_LATEQDEL

/obj/effect/map_effect/mecha_part_spawner/proc/get_parts_to_spawn()
	return list()

/obj/effect/map_effect/mecha_part_spawner/proc/spawn_parts()
	for(var/thing in parts_to_spawn)
		new thing(loc)


/obj/effect/map_effect/mecha_part_spawner/manipulator
	name = "mecha manipulator spawner"

/obj/effect/map_effect/mecha_part_spawner/manipulator/get_parts_to_spawn()
	return subtypesof(/obj/item/mech_component/manipulators)

/obj/effect/map_effect/mecha_part_spawner/manipulator/spawn_parts()
	. = ..()
	new /obj/item/robot_parts/robot_component/actuator(loc)


/obj/effect/map_effect/mecha_part_spawner/propulsion
	name = "mecha propulsion spawner"

/obj/effect/map_effect/mecha_part_spawner/propulsion/get_parts_to_spawn()
	return subtypesof(/obj/item/mech_component/propulsion)

/obj/effect/map_effect/mecha_part_spawner/propulsion/spawn_parts()
	. = ..()
	new /obj/item/robot_parts/robot_component/actuator(loc)


/obj/effect/map_effect/mecha_part_spawner/sensors
	name = "mecha sensors spawner"

/obj/effect/map_effect/mecha_part_spawner/sensors/get_parts_to_spawn()
	return subtypesof(/obj/item/mech_component/sensors)

/obj/effect/map_effect/mecha_part_spawner/sensors/spawn_parts()
	. = ..()
	new /obj/item/robot_parts/robot_component/radio(loc)
	new /obj/item/robot_parts/robot_component/camera(loc)
	new /obj/item/mech_component/control_module(loc)

	var/list/softwares = subtypesof(/obj/item/circuitboard/exosystem)
	for(var/software in softwares)
		new software(loc)


/obj/effect/map_effect/mecha_part_spawner/chassis
	name = "mecha chassis spawner"

/obj/effect/map_effect/mecha_part_spawner/chassis/get_parts_to_spawn()
	return subtypesof(/obj/item/mech_component/chassis)

/obj/effect/map_effect/mecha_part_spawner/chassis/spawn_parts()
	. = ..()
	new /obj/item/robot_parts/robot_component/diagnosis_unit(loc)
	var/list/armors = typesof(/obj/item/robot_parts/robot_component/armor/mech)
	for(var/armor in armors)
		new armor(loc)
