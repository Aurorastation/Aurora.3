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
	// Stores `supports_builtin_powernet` state used by this integrated electronics object.
	var/supports_builtin_powernet = FALSE

/// Implements `attack_hand` behavior for this integrated electronics type.
/obj/item/electronic_assembly/attack_hand(mob/user)
	if(anchored)
		if(!check_interactivity(user))
			return TRUE

		attack_self(user)
		return TRUE

	return ..()

/obj/item/electronic_assembly/mob_can_equip(mob/user, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(anchored)
		if(!disable_warning)
			to_chat(user, SPAN_WARNING("\The [src] is anchored in place."))
		return FALSE

	return ..()

// Small assemblies.

/obj/item/electronic_assembly/default
	name = "pocket circuit case"

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/calc
	name = "calculator circuit case"
	icon_state = "setup_small_calc"
	desc = "A case for building small electronic assemblies. This one resembles a pocket calculator."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/clam
	name = "clamshell circuit case"
	icon_state = "setup_small_clam"
	desc = "A case for building small electronic assemblies. This one has a clamshell design."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/simple
	name = "compact circuit case"
	icon_state = "setup_small_simple"
	desc = "A case for building small electronic assemblies. This one has a simple design."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/hook
	name = "belt-clip circuit case"
	icon_state = "setup_small_hook"
	desc = "A case for building small electronic assemblies. This one looks like it has a belt clip, but it's purely decorative."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/pda
	name = "PDA-style circuit case"
	icon_state = "setup_small_pda"
	desc = "A case for building small electronic assemblies. This one resembles a PDA."


// Tiny assemblies.

/obj/item/electronic_assembly/tiny
	name = "tiny circuit device"
	icon_state = "setup_device"
	desc = "A case for building tiny electronic assemblies."
	w_class = WEIGHT_CLASS_TINY
	max_components = IC_COMPONENTS_BASE / 2
	max_complexity = IC_COMPLEXITY_BASE / 2

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/tiny/default
	name = "tiny circuit case"

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/tiny/cylinder
	name = "cylindrical circuit device"
	icon_state = "setup_device_cylinder"
	desc = "A case for building tiny electronic assemblies. This one has a cylindrical design."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/tiny/scanner
	name = "scanner circuit device"
	icon_state = "setup_device_scanner"
	desc = "A case for building tiny electronic assemblies. This one has a scanner-like design."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/tiny/hook
	name = "tiny belt-clip circuit device"
	icon_state = "setup_device_hook"
	desc = "A case for building tiny electronic assemblies. This one looks like it has a belt clip, but it's purely decorative."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/tiny/box
	name = "boxy circuit device"
	icon_state = "setup_device_box"
	desc = "A case for building tiny electronic assemblies. This one has a boxy design."


// Medium assemblies.

/obj/item/electronic_assembly/medium
	name = "medium circuit mechanism"
	icon_state = "setup_medium"
	desc = "A case for building medium electronic assemblies."
	w_class = WEIGHT_CLASS_NORMAL
	max_components = IC_COMPONENTS_BASE * 2
	max_complexity = IC_COMPLEXITY_BASE * 2

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/medium/default
	name = "medium circuit case"

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/medium/box
	name = "boxy circuit mechanism"
	icon_state = "setup_medium_box"
	desc = "A case for building medium electronic assemblies. This one has a boxy design."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/medium/clam
	name = "clamshell circuit mechanism"
	icon_state = "setup_medium_clam"
	desc = "A case for building medium electronic assemblies. This one has a clamshell design."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/medium/medical
	name = "medical circuit mechanism"
	icon_state = "setup_medium_med"
	desc = "A case for building medium electronic assemblies. This one resembles some type of medical apparatus."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/medium/gun
	name = "tool-shaped circuit mechanism"
	icon_state = "setup_medium_gun"
	item_state = "circuitgun"
	desc = "A case for building medium electronic assemblies. This one resembles a gun, or some type of tool, \
	if you're feeling optimistic."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/medium/radio
	name = "radio circuit mechanism"
	icon_state = "setup_medium_radio"
	desc = "A case for building medium electronic assemblies. This one resembles an old radio."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/medium/anomaly_drill
	name = "anomaly drill assembly"
	desc = "A prebuilt electronic assembly designed to drill toward anomaly sensor coordinates."
	icon_state = "setup_medium_drill"
	w_class = WEIGHT_CLASS_NORMAL
	max_components = 30
	max_complexity = 80
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
	max_components = IC_COMPONENTS_BASE * 4
	max_complexity = IC_COMPLEXITY_BASE * 4
	can_anchor = TRUE
	supports_builtin_powernet = TRUE

/obj/item/electronic_assembly/large/Initialize(mapload, printed = FALSE)
	. = ..()
	add_builtin_powernet()

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/large/default
	name = "large circuit case"

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/large/scope
	name = "oscilloscope circuit machine"
	icon_state = "setup_large_scope"
	desc = "A case for building large electronic assemblies. This one resembles an oscilloscope."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/large/terminal
	name = "terminal circuit machine"
	icon_state = "setup_large_terminal"
	desc = "A case for building large electronic assemblies. This one resembles a computer terminal."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/large/arm
	name = "robotic arm circuit machine"
	icon_state = "setup_large_arm"
	desc = "A case for building large electronic assemblies. This one resembles a robotic arm."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/large/tall
	name = "tall circuit machine"
	icon_state = "setup_large_tall"
	desc = "A case for building large electronic assemblies. This one has a tall design."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/large/industrial
	name = "industrial circuit machine"
	icon_state = "setup_large_industrial"
	desc = "A case for building large electronic assemblies. This one resembles some kind of industrial machinery."


// Drone assemblies, which can move with the locomotion circuit.

/obj/item/electronic_assembly/drone
	name = "circuit drone"
	icon_state = "setup_drone"
	desc = "A mobile case for building electronic assemblies."
	w_class = WEIGHT_CLASS_NORMAL
	max_components = IC_COMPONENTS_BASE * 1.5
	max_complexity = IC_COMPLEXITY_BASE * 1.5
	can_anchor = FALSE

/// Checks whether `move` is allowed in the current state.
/obj/item/electronic_assembly/drone/can_move()
	return TRUE

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/drone/default
	name = "basic circuit drone"

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/drone/arms
	name = "armed circuit drone"
	icon_state = "setup_drone_arms"
	desc = "A mobile case for building weapon-capable electronic assemblies."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/drone/medbot
	name = "medical circuit drone"
	icon_state = "setup_drone_medbot"
	desc = "A mobile case for building electronic assemblies. This one resembles a Medibot."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/drone/genbot
	name = "utility circuit drone"
	icon_state = "setup_drone_genbot"
	desc = "A mobile case for building electronic assemblies. This one has a generic bot design."

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/drone/android
	name = "android circuit drone"
	icon_state = "setup_drone_android"
	desc = "A mobile case for building electronic assemblies. This one has a hominoid design."


// Wall mounted assemblies.
// These get a built-in, non-removable power network interface.

/obj/item/electronic_assembly/wallmount
	name = "wall-mounted circuit mechanism"
	icon_state = "setup_wallmount_medium"
	desc = "A case for building medium electronic assemblies. It has a magnetized \
	backing to allow it to stick to walls."
	w_class = WEIGHT_CLASS_NORMAL
	max_components = IC_COMPONENTS_BASE * 2
	max_complexity = IC_COMPLEXITY_BASE * 2
	can_anchor = TRUE
	supports_builtin_powernet = TRUE

/obj/item/electronic_assembly/wallmount/Initialize(mapload, printed = FALSE)
	. = ..()
	add_builtin_powernet()

/// Implements `mount_assembly` behavior for this integrated electronics type.
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

/// Implements `on_unanchored` behavior for this integrated electronics type.
/obj/item/electronic_assembly/wallmount/on_unanchored()
	pixel_x = 0
	pixel_y = 0
	..()

/// Sets `pixel_offsets` and performs any required follow-up bookkeeping.
/obj/item/electronic_assembly/wallmount/set_pixel_offsets()
	pixel_x = DIR2PIXEL_X(dir)
	pixel_y = DIR2PIXEL_Y(dir)

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/wallmount/heavy
	name = "heavy wall-mounted circuit machine"
	icon_state = "setup_wallmount_large"
	desc = "A case for building large electronic assemblies. It has a magnetized backing \
	to allow it to stick to walls."
	w_class = WEIGHT_CLASS_BULKY
	max_components = IC_COMPONENTS_BASE * 4
	max_complexity = IC_COMPLEXITY_BASE * 4

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/wallmount/light
	name = "light wall-mounted circuit case"
	icon_state = "setup_wallmount_small"
	desc = "A case for building small electronic assemblies. It has a magnetized backing \
	to allow it to stick to walls."
	w_class = WEIGHT_CLASS_SMALL
	max_components = IC_COMPONENTS_BASE
	max_complexity = IC_COMPLEXITY_BASE

/// Defines an electronic assembly subtype that stores and runs installed circuits.
/obj/item/electronic_assembly/wallmount/tiny
	name = "tiny wall-mounted circuit device"
	icon_state = "setup_wallmount_tiny"
	desc = "It's a case, for building tiny electronics with. It has a magnetized backing \
	to allow it to stick to walls."
	w_class = WEIGHT_CLASS_TINY
	max_components = IC_COMPONENTS_BASE / 2
	max_complexity = IC_COMPLEXITY_BASE / 2


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

/// Returns the current `assembly_holder` value or object used by this electronics code.
/obj/item/electronic_assembly/proc/get_assembly_holder()
	return src
