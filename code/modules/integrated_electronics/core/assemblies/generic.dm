/*
 * core/assemblies/generic.dm
 * Generic handheld, large, wall-mounted, and specialty electronic assembly variants.
 */

// Generic subtypes without a lot of special code.

// Anchored pickup protection.
// This prevents anchored electronic assemblies from being picked up like normal items.
// Anchored assemblies still pass ordinary hand interaction through attack_self(), so closed
// assemblies expose their external inputs and opened assemblies expose the circuit UI.

/obj/item/electronic_assembly
	var/supports_builtin_powernet = FALSE
	var/supports_builtin_locomotion = FALSE
	var/max_components_tiny_assembly = 12
	var/max_complexity_tiny_assembly = 30
	var/max_components_medium_assembly = 55
	var/max_complexity_medium_assembly = 140
	var/max_components_large_assembly = 110
	var/max_complexity_large_assembly = 240
	var/max_components_drone = 38
	var/max_complexity_drone = 95
	var/max_components_wallmount = 55
	var/max_complexity_wallmount = 140

/obj/item/electronic_assembly/attack_hand(mob/user)
	if(anchored)
		if(!check_interactivity(user))
			return TRUE

		attack_self(user)
		return TRUE

	return ..()

/obj/item/electronic_assembly/mob_can_equip(mob/user, slot, disable_warning = FALSE, bypass_blocked_check = FALSE, is_overlay_check = FALSE)
	if(anchored)
		if(!disable_warning)
			to_chat(user, SPAN_WARNING("\The [src] is anchored in place."))
		return FALSE

	return ..(user, slot, disable_warning, bypass_blocked_check, is_overlay_check)

// Small assemblies.

/obj/item/electronic_assembly/default
	name = "basic small circuit case"

/obj/item/electronic_assembly/calc
	name = "calculator small circuit case"
	icon_state = "setup_small_calc"
	desc = "A case for building small electronic assemblies. This one resembles a pocket calculator."

/obj/item/electronic_assembly/clam
	name = "clamshell small circuit case"
	icon_state = "setup_small_clam"
	desc = "A case for building small electronic assemblies. This one has a clamshell design."

/obj/item/electronic_assembly/simple
	name = "compact small circuit case"
	icon_state = "setup_small_simple"
	desc = "A case for building small electronic assemblies. This one has a simple design."

/obj/item/electronic_assembly/hook
	name = "belt-clip small circuit case"
	icon_state = "setup_small_hook"
	desc = "A case for building small electronic assemblies. This one looks like it has a belt clip, but it's purely decorative."

/obj/item/electronic_assembly/pda
	name = "PDA-style small circuit case"
	icon_state = "setup_small_pda"
	desc = "A case for building small electronic assemblies. This one resembles a PDA."


// Tiny assemblies.

/obj/item/electronic_assembly/tiny
	name = "tiny circuit case"
	icon_state = "setup_device"
	desc = "A case for building tiny electronic assemblies."
	w_class = WEIGHT_CLASS_TINY
	max_components = /obj/item/electronic_assembly::max_components_tiny_assembly
	max_complexity = /obj/item/electronic_assembly::max_complexity_tiny_assembly

/obj/item/electronic_assembly/tiny/default
	name = "basic tiny circuit case"

/obj/item/electronic_assembly/tiny/cylinder
	name = "cylindrical tiny circuit case"
	icon_state = "setup_device_cylinder"
	desc = "A case for building tiny electronic assemblies. This one has a cylindrical design."

/obj/item/electronic_assembly/tiny/scanner
	name = "scanner tiny circuit case"
	icon_state = "setup_device_scanner"
	desc = "A case for building tiny electronic assemblies. This one has a scanner-like design."

/obj/item/electronic_assembly/tiny/hook
	name = "belt-clip tiny circuit case"
	icon_state = "setup_device_hook"
	desc = "A case for building tiny electronic assemblies. This one looks like it has a belt clip, but it's purely decorative."

/obj/item/electronic_assembly/tiny/box
	name = "boxy tiny circuit case"
	icon_state = "setup_device_box"
	desc = "A case for building tiny electronic assemblies. This one has a boxy design."


// Medium assemblies.

/obj/item/electronic_assembly/medium
	name = "medium circuit case"
	icon_state = "setup_medium"
	desc = "A case for building medium electronic assemblies."
	w_class = WEIGHT_CLASS_NORMAL
	var/max_components_anomaly_drill = 30
	var/max_complexity_anomaly_drill = 80
	max_components = /obj/item/electronic_assembly::max_components_medium_assembly
	max_complexity = /obj/item/electronic_assembly::max_complexity_medium_assembly

/obj/item/electronic_assembly/medium/default
	name = "basic medium circuit case"

/obj/item/electronic_assembly/medium/box
	name = "boxy medium circuit case"
	icon_state = "setup_medium_box"
	desc = "A case for building medium electronic assemblies. This one has a boxy design."

/obj/item/electronic_assembly/medium/clam
	name = "clamshell medium circuit case"
	icon_state = "setup_medium_clam"
	desc = "A case for building medium electronic assemblies. This one has a clamshell design."

/obj/item/electronic_assembly/medium/medical
	name = "medical medium circuit case"
	icon_state = "setup_medium_med"
	desc = "A case for building medium electronic assemblies. This one resembles some type of medical apparatus."

/obj/item/electronic_assembly/medium/gun
	name = "tool-shaped medium circuit case"
	icon_state = "setup_medium_gun"
	item_state = "circuitgun"
	desc = "A case for building medium electronic assemblies. This one resembles a gun, or some type of tool, \
	if you're feeling optimistic."

/obj/item/electronic_assembly/medium/radio
	name = "radio medium circuit case"
	icon_state = "setup_medium_radio"
	desc = "A case for building medium electronic assemblies. This one resembles an old radio."

/obj/item/electronic_assembly/medium/anomaly_drill
	name = "anomaly drill assembly"
	desc = "A prebuilt electronic assembly designed to drill toward anomaly sensor coordinates."
	icon_state = "setup_medium_drill"
	w_class = WEIGHT_CLASS_NORMAL
	max_components = /obj/item/electronic_assembly/medium::max_components_anomaly_drill
	max_complexity = /obj/item/electronic_assembly/medium::max_complexity_anomaly_drill
	can_anchor = FALSE

/obj/item/electronic_assembly/medium/anomaly_drill/Initialize(mapload, printed = FALSE)
	. = ..()

	var/obj/item/integrated_circuit/manipulation/xenoarch_precision_excavator/drill_controller = new(src)
	drill_controller.removable = FALSE
	drill_controller.assembly = src
	force_add_circuit(drill_controller)


// Large assemblies.
// These get a built-in, non-removable power network interface.

/obj/item/electronic_assembly/large
	name = "large circuit machine"
	icon_state = "setup_large"
	desc = "A case for building large electronic assemblies."
	w_class = WEIGHT_CLASS_BULKY
	max_components = /obj/item/electronic_assembly::max_components_large_assembly
	max_complexity = /obj/item/electronic_assembly::max_complexity_large_assembly
	can_anchor = TRUE
	supports_builtin_powernet = TRUE

/obj/item/electronic_assembly/large/Initialize(mapload, printed = FALSE)
	. = ..()
	add_builtin_powernet()

/obj/item/electronic_assembly/large/default
	name = "basic large circuit machine"

/obj/item/electronic_assembly/large/scope
	name = "oscilloscope large circuit machine"
	icon_state = "setup_large_scope"
	desc = "A case for building large electronic assemblies. This one resembles an oscilloscope."

/obj/item/electronic_assembly/large/terminal
	name = "terminal large circuit machine"
	icon_state = "setup_large_terminal"
	desc = "A case for building large electronic assemblies. This one resembles a computer terminal."

/obj/item/electronic_assembly/large/arm
	name = "robotic arm large circuit machine"
	icon_state = "setup_large_arm"
	desc = "A case for building large electronic assemblies. This one resembles a robotic arm."

/obj/item/electronic_assembly/large/tall
	name = "tall large circuit machine"
	icon_state = "setup_large_tall"
	desc = "A case for building large electronic assemblies. This one has a tall design."

/obj/item/electronic_assembly/large/industrial
	name = "industrial large circuit machine"
	icon_state = "setup_large_industrial"
	desc = "A case for building large electronic assemblies. This one resembles some kind of industrial machinery."


// Drone assemblies, which can move with the locomotion circuit.

/obj/item/electronic_assembly/drone
	name = "circuit drone"
	icon_state = "setup_drone"
	desc = "A mobile case for building electronic assemblies."
	w_class = WEIGHT_CLASS_NORMAL
	max_components = /obj/item/electronic_assembly::max_components_drone
	max_complexity = /obj/item/electronic_assembly::max_complexity_drone
	can_anchor = FALSE
	supports_builtin_locomotion = TRUE

/obj/item/electronic_assembly/drone/Initialize(mapload, printed = FALSE)
	. = ..()
	add_builtin_locomotion()

/obj/item/electronic_assembly/drone/can_move()
	return TRUE

/obj/item/electronic_assembly/drone/default
	name = "basic circuit drone"

/obj/item/electronic_assembly/drone/arms
	name = "armed circuit drone"
	icon_state = "setup_drone_arms"
	desc = "A mobile case for building weapon-capable electronic assemblies."

/obj/item/electronic_assembly/drone/medbot
	name = "medical circuit drone"
	icon_state = "setup_drone_medbot"
	desc = "A mobile case for building electronic assemblies. This one resembles a Medibot."

/obj/item/electronic_assembly/drone/genbot
	name = "utility circuit drone"
	icon_state = "setup_drone_genbot"
	desc = "A mobile case for building electronic assemblies. This one has a generic bot design."

/obj/item/electronic_assembly/drone/android
	name = "android circuit drone"
	icon_state = "setup_drone_android"
	desc = "A mobile case for building electronic assemblies. This one has a hominoid design."


// Wall mounted assemblies.
// These get a built-in, non-removable power network interface.

/obj/item/electronic_assembly/wallmount
	name = "medium wall-mounted circuit case"
	icon_state = "setup_wallmount_medium"
	desc = "A case for building medium electronic assemblies. It has a magnetized \
	backing to allow it to stick to walls."
	w_class = WEIGHT_CLASS_NORMAL
	var/max_components_wallmount_heavy = 110
	var/max_complexity_wallmount_heavy = 240
	var/max_components_wallmount_light = IC_COMPONENTS_BASE
	var/max_complexity_wallmount_light = IC_COMPLEXITY_BASE
	var/max_components_wallmount_tiny = 12
	var/max_complexity_wallmount_tiny = 30
	max_components = /obj/item/electronic_assembly::max_components_wallmount
	max_complexity = /obj/item/electronic_assembly::max_complexity_wallmount
	can_anchor = TRUE
	supports_builtin_powernet = TRUE

/obj/item/electronic_assembly/wallmount/Initialize(mapload, printed = FALSE)
	. = ..()
	add_builtin_powernet()

/obj/item/electronic_assembly/wallmount/proc/mount_assembly(turf/on_wall, mob/user)
	if(get_dist(on_wall, user) > 1)
		return

	var/ndir = get_dir(on_wall, user)
	if(!(ndir in GLOB.cardinals))
		return

	var/turf/T = get_turf(user)
	if(!istype(T, /turf/simulated/floor))
		to_chat(user, SPAN_WARNING("You cannot place \the [src] on this spot!"))
		return

	playsound(src.loc, 'sound/machines/click.ogg', 75, 1)

	user.visible_message(
		"\The [user] attaches \the [src] to the wall.",
		SPAN_NOTICE("You attach \the [src] to the wall."),
		"<span class='italics'>You hear clicking.</span>"
	)

	if(isrobot(user)) // Robots cannot unequip/drop items, for safety reasons.
		forceMove(T)
	else
		user.drop_item(T)

	anchored = TRUE
	on_anchored()
	set_pixel_offsets()

/obj/item/electronic_assembly/wallmount/on_unanchored()
	pixel_x = 0
	pixel_y = 0
	..()

/obj/item/electronic_assembly/wallmount/set_pixel_offsets()
	pixel_x = DIR2PIXEL_X(dir)
	pixel_y = DIR2PIXEL_Y(dir)

/obj/item/electronic_assembly/wallmount/heavy
	name = "large wall-mounted circuit machine"
	icon_state = "setup_wallmount_large"
	desc = "A case for building large electronic assemblies. It has a magnetized backing \
	to allow it to stick to walls."
	w_class = WEIGHT_CLASS_BULKY
	max_components = /obj/item/electronic_assembly/wallmount::max_components_wallmount_heavy
	max_complexity = /obj/item/electronic_assembly/wallmount::max_complexity_wallmount_heavy

/obj/item/electronic_assembly/wallmount/light
	name = "small wall-mounted circuit case"
	icon_state = "setup_wallmount_small"
	desc = "A case for building small electronic assemblies. It has a magnetized backing \
	to allow it to stick to walls."
	w_class = WEIGHT_CLASS_SMALL
	max_components = /obj/item/electronic_assembly/wallmount::max_components_wallmount_light
	max_complexity = /obj/item/electronic_assembly/wallmount::max_complexity_wallmount_light

/obj/item/electronic_assembly/wallmount/tiny
	name = "tiny wall-mounted circuit case"
	icon_state = "setup_wallmount_tiny"
	desc = "A case for building tiny electronic assemblies. It has a magnetized backing \
	to allow it to stick to walls."
	w_class = WEIGHT_CLASS_TINY
	max_components = /obj/item/electronic_assembly/wallmount::max_components_wallmount_tiny
	max_complexity = /obj/item/electronic_assembly/wallmount::max_complexity_wallmount_tiny


// Built-in circuits.

/obj/item/electronic_assembly/proc/add_builtin_powernet()
	if(!supports_builtin_powernet)
		return

	for(var/obj/item/integrated_circuit/passive/power/powernet/P in contents)
		return

	var/obj/item/integrated_circuit/passive/power/powernet/builtin/P = new(src)
	P.removable = FALSE
	P.assembly = src
	force_add_circuit(P)

/obj/item/electronic_assembly/proc/add_builtin_locomotion()
	if(!supports_builtin_locomotion)
		return

	for(var/obj/item/integrated_circuit/manipulation/locomotion/builtin/L in contents)
		return

	var/obj/item/integrated_circuit/manipulation/locomotion/builtin/L = new(src)
	L.removable = FALSE
	L.assembly = src
	force_add_circuit(L)

/obj/item/electronic_assembly/proc/get_assembly_holder()
	return src
