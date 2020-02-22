// Generic subtypes without a lot of special code.

// Small assemblies.

/obj/item/device/electronic_assembly/default
	name = "type-a electronic assembly"

/obj/item/device/electronic_assembly/calc
	name = "type-b electronic assembly"
	icon_state = "setup_small_calc"
	desc = "It's a case, for building small electronics with. This one resembles a pocket calculator."

/obj/item/device/electronic_assembly/clam
	name = "type-c electronic assembly"
	icon_state = "setup_small_clam"
	desc = "It's a case, for building small electronics with. This one has a clamshell design."

/obj/item/device/electronic_assembly/simple
	name = "type-d electronic assembly"
	icon_state = "setup_small_simple"
	desc = "It's a case, for building small electronics with. This one has a simple design."

/obj/item/device/electronic_assembly/hook
	name = "type-e electronic assembly"
	icon_state = "setup_small_hook"
	desc = "It's a case, for building small electronics with. This one looks like it has a belt clip, but it's purely decorative."

/obj/item/device/electronic_assembly/pda
	name = "type-f electronic assembly"
	icon_state = "setup_small_pda"
	desc = "It's a case, for building small electronics with. This one resembles a PDA."

// Tiny assemblies.

/obj/item/device/electronic_assembly/tiny
	name = "electronic device"
	icon_state = "setup_device"
	desc = "It's a case, for building tiny-sized electronics with."
	w_class = ITEMSIZE_TINY
	max_components = IC_COMPONENTS_BASE / 2
	max_complexity = IC_COMPLEXITY_BASE / 2

/obj/item/device/electronic_assembly/tiny/default
	name = "type-a electronic device"

/obj/item/device/electronic_assembly/tiny/cylinder
	name = "type-b electronic device"
	icon_state = "setup_device_cylinder"
	desc = "It's a case, for building tiny-sized electronics with. This one has a cylindrical design."

/obj/item/device/electronic_assembly/tiny/scanner
	name = "type-c electronic device"
	icon_state = "setup_device_scanner"
	desc = "It's a case, for building tiny-sized electronics with. This one has a scanner-like design."

/obj/item/device/electronic_assembly/tiny/hook
	name = "type-d electronic device"
	icon_state = "setup_device_hook"
	desc = "It's a case, for building tiny-sized electronics with. This one looks like it has a belt clip, but it's purely decorative."

/obj/item/device/electronic_assembly/tiny/box
	name = "type-e electronic device"
	icon_state = "setup_device_box"
	desc = "It's a case, for building tiny-sized electronics with. This one has a boxy design."

// Medium assemblies.

/obj/item/device/electronic_assembly/medium
	name = "electronic mechanism"
	icon_state = "setup_medium"
	desc = "It's a case, for building medium-sized electronics with."
	w_class = ITEMSIZE_NORMAL
	max_components = IC_COMPONENTS_BASE * 2
	max_complexity = IC_COMPLEXITY_BASE * 2

/obj/item/device/electronic_assembly/medium/default
	name = "type-a electronic mechanism"

/obj/item/device/electronic_assembly/medium/box
	name = "type-b electronic mechanism"
	icon_state = "setup_medium_box"
	desc = "It's a case, for building medium-sized electronics with. This one has a boxy design."

/obj/item/device/electronic_assembly/medium/clam
	name = "type-c electronic mechanism"
	icon_state = "setup_medium_clam"
	desc = "It's a case, for building medium-sized electronics with. This one has a clamshell design."

/obj/item/device/electronic_assembly/medium/medical
	name = "type-d electronic mechanism"
	icon_state = "setup_medium_med"
	desc = "It's a case, for building medium-sized electronics with. This one resembles some type of medical apparatus."

/obj/item/device/electronic_assembly/medium/gun
	name = "type-e electronic mechanism"
	icon_state = "setup_medium_gun"
	item_state = "circuitgun"
	desc = "It's a case, for building medium-sized electronics with. This one resembles a gun, or some type of tool, \
	if you're feeling optimistic."

/obj/item/device/electronic_assembly/medium/radio
	name = "type-f electronic mechanism"
	icon_state = "setup_medium_radio"
	desc = "It's a case, for building medium-sized electronics with. This one resembles an old radio."

// Large assemblies.

/obj/item/device/electronic_assembly/large
	name = "electronic machine"
	icon_state = "setup_large"
	desc = "It's a case, for building large electronics with."
	w_class = ITEMSIZE_LARGE
	max_components = IC_COMPONENTS_BASE * 4
	max_complexity = IC_COMPLEXITY_BASE * 4
	can_anchor = TRUE

/obj/item/device/electronic_assembly/large/default
	name = "type-a electronic machine"

/obj/item/device/electronic_assembly/large/scope
	name = "type-b electronic machine"
	icon_state = "setup_large_scope"
	desc = "It's a case, for building large electronics with. This one resembles an oscilloscope."

/obj/item/device/electronic_assembly/large/terminal
	name = "type-c electronic machine"
	icon_state = "setup_large_terminal"
	desc = "It's a case, for building large electronics with. This one resembles a computer terminal."

/obj/item/device/electronic_assembly/large/arm
	name = "type-d electronic machine"
	icon_state = "setup_large_arm"
	desc = "It's a case, for building large electronics with. This one resembles a robotic arm."

/obj/item/device/electronic_assembly/large/tall
	name = "type-e electronic machine"
	icon_state = "setup_large_tall"
	desc = "It's a case, for building large electronics with. This one has a tall design."

/obj/item/device/electronic_assembly/large/industrial
	name = "type-f electronic machine"
	icon_state = "setup_large_industrial"
	desc = "It's a case, for building large electronics with. This one resembles some kind of industrial machinery."

// Drone assemblies, which can move with the locomotion circuit.

/obj/item/device/electronic_assembly/drone
	name = "electronic drone"
	icon_state = "setup_drone"
	desc = "It's a case, for building mobile electronics with."
	w_class = ITEMSIZE_NORMAL
	max_components = IC_COMPONENTS_BASE * 1.5
	max_complexity = IC_COMPLEXITY_BASE * 1.5
	can_anchor = FALSE

/obj/item/device/electronic_assembly/drone/can_move()
	return TRUE

/obj/item/device/electronic_assembly/drone/default
	name = "type-a electronic drone"

/obj/item/device/electronic_assembly/drone/arms
	name = "type-b electronic drone"
	icon_state = "setup_drone_arms"
	desc = "It's a case, for building mobile electronics with. This one is armed and dangerous."

/obj/item/device/electronic_assembly/drone/secbot
	name = "type-c electronic drone"
	icon_state = "setup_drone_secbot"
	desc = "It's a case, for building mobile electronics with. This one resembles a Securitron."

/obj/item/device/electronic_assembly/drone/medbot
	name = "type-d electronic drone"
	icon_state = "setup_drone_medbot"
	desc = "It's a case, for building mobile electronics with. This one resembles a Medibot."

/obj/item/device/electronic_assembly/drone/genbot
	name = "type-e electronic drone"
	icon_state = "setup_drone_genbot"
	desc = "It's a case, for building mobile electronics with. This one has a generic bot design."

/obj/item/device/electronic_assembly/drone/android
	name = "type-f electronic drone"
	icon_state = "setup_drone_android"
	desc = "It's a case, for building mobile electronics with. This one has a hominoid design."

// Wall mounted assemblies.

/obj/item/device/electronic_assembly/wallmount
	name = "wall-mounted electronic assembly"
	icon_state = "setup_wallmount_medium"
	desc = "It's a case, for building medium-sized electronics with. It has a magnetized \
	backing to allow it to stick to walls."
	w_class = ITEMSIZE_NORMAL
	max_components = IC_COMPONENTS_BASE * 2
	max_complexity = IC_COMPLEXITY_BASE * 2
	can_anchor = TRUE

/obj/item/device/electronic_assembly/wallmount/proc/mount_assembly(turf/on_wall, mob/user)
	if(get_dist(on_wall,user) > 1)
		return
	var/ndir = get_dir(on_wall, user)
	if(!(ndir in cardinal))
		return
	var/turf/T = get_turf(user)
	if(!istype(T, /turf/simulated/floor))
		to_chat(user, "<span class='warning'>You cannot place \the [src] on this spot!</span>")
		return
	playsound(src.loc, 'sound/machines/click.ogg', 75, 1)
	user.visible_message("\The [user] attaches \the [src] to the wall.",
		"<span class='notice'>You attach \the [src] to the wall.</span>",
		"<span class='italics'>You hear clicking.</span>")
	if(isrobot(user)) //Robots cannot unequip/drop items, for Safety Reasons.
		forceMove(T)
	user.drop_item(T)
	anchored = TRUE
	on_anchored()
	pixel_x = DIR2PIXEL_X(ndir)
	pixel_y = DIR2PIXEL_Y(ndir)

/obj/item/device/electronic_assembly/wallmount/on_unanchored()
	pixel_x = 0
	pixel_y = 0
	..()

/obj/item/device/electronic_assembly/wallmount/heavy
	name = "heavy wall-mounted electronic assembly"
	icon_state = "setup_wallmount_large"
	desc = "It's a case, for building large electronics with. It has a magnetized backing \
	to allow it to stick to walls."
	w_class = ITEMSIZE_LARGE
	max_components = IC_COMPONENTS_BASE * 4
	max_complexity = IC_COMPLEXITY_BASE * 4

/obj/item/device/electronic_assembly/wallmount/light
	name = "light wall-mounted electronic assembly"
	icon_state = "setup_wallmount_small"
	desc = "It's a case, for building small electronics with. It has a magnetized backing \
	to allow it to stick to walls."
	w_class = ITEMSIZE_SMALL
	max_components = IC_COMPONENTS_BASE
	max_complexity = IC_COMPLEXITY_BASE

/obj/item/device/electronic_assembly/wallmount/tiny
	name = "tiny wall-mounted electronic assembly"
	icon_state = "setup_wallmount_tiny"
	desc = "It's a case, for building tiny electronics with. It has a magnetized backing \
	to allow it to stick to walls."
	w_class = ITEMSIZE_TINY
	max_components = IC_COMPONENTS_BASE / 2
	max_complexity = IC_COMPLEXITY_BASE / 2

/obj/item/device/electronic_assembly/proc/get_assembly_holder()
	return src