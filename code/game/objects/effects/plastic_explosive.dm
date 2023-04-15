/obj/effect/plastic_explosive
	name = "plastic explosives"
	desc = "Used to put holes in specific areas without too much extra hole."
	gender = PLURAL
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "plastic-explosive2"
	anchored = TRUE
	density = FALSE
	var/obj/item/plastique/parent

/obj/effect/plastic_explosive/Initialize(var/atom/owner_pos, var/atom/target, var/obj/item/plastique/c4)
	. = ..()
	parent = c4
	parent.effect_overlay = src
	parent.forceMove(src)
	name = parent.name
	desc = parent.desc
	set_position(get_dir(src, target))

/obj/effect/plastic_explosive/Destroy()
	QDEL_NULL(parent)
	return ..()

/obj/effect/plastic_explosive/proc/set_position(var/dir)
	var/dir_text = uppertext(dir2text(dir))
	var/list/dir_to_pixel = list(
		"NORTH" = list(0, 32),
		"NORTHEAST" = list(32, 32),
		"EAST" = list(32, 0),
		"SOUTHEAST" = list(32, -32),
		"SOUTH" = list(0, -32),
		"SOUTHWEST" = list(-32, -32),
		"WEST" = list(-32, 0),
		"NORTHWEST" = list(-32, 32)
	)
	var/list/pixel_shifts = dir_to_pixel[dir_text]
	pixel_x = pixel_shifts[1]
	pixel_y = pixel_shifts[2]

/obj/effect/plastic_explosive/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		to_chat(user, SPAN_WARNING("It is set to blow in [round((parent.detonate_time - world.time) / 10)] seconds."))

/obj/effect/plastic_explosive/attack_hand(mob/living/user)
	to_chat(user, SPAN_WARNING("\The [src] is solidly attached, it doesn't budge!"))

/obj/effect/plastic_explosive/attackby(var/obj/item/I, var/mob/user)
	return parent.attackby(I, user)
