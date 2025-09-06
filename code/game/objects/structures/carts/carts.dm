ABSTRACT_TYPE(/obj/structure/cart)
	name = "cart parent item"
	desc = DESC_PARENT
	icon_state = "cart"
	anchored = FALSE
	density = TRUE
	climbable = TRUE
	build_amt = 15
	material = DEFAULT_WALL_MATERIAL
	slowdown = 0
	var/movesound = 'sound/effects/roll.ogg'
	var/driving
	var/mob/living/pulling

/obj/structure/cart/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "\
		You can <b>CTRL-Click</b> to start dragging this cart. This object has a special dragging behaviour: when dragged, character's movement \
		directs the cart and the character is subsequently pulled by it. \
		"

/obj/structure/cart/disassembly_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "An empty cart can be taken apart with a <b>wrench</b> or a <b>welder</b>. Or a <b>plasma cutter</b>, if you're that hardcore."

/obj/structure/cart/proc/take_apart(var/mob/user = null, var/obj/I)
	if(user)
		if(iswelder(I))
			var/obj/item/welder = I
			welder.play_tool_sound(get_turf(src), 50)

		user.visible_message("<b>[user]</b> starts taking apart the [src]...", SPAN_NOTICE("You start disassembling the [src]..."))
		if (!do_after(user, 30, do_flags = DO_DEFAULT & ~DO_USER_SAME_HAND))
			return

	dismantle()

/obj/structure/cart/ex_act(severity)
	spill(100 / severity)
	..()

/obj/structure/cart/proc/spill(var/chance = 100)

/obj/structure/cart/proc/update_slowdown()

/obj/structure/cart/relaymove(mob/living/user, direction)
	. = ..()

	if(user.stat || user.stunned || user.weakened || user.paralysis || user.lying || user.restrained())
		if(user==pulling)
			pulling = null
			user.pulledby = null
			to_chat(user, SPAN_WARNING("You lost your grip!"))
		return
	if(user.pulling && (user == pulling))
		pulling = null
		user.pulledby = null
		return
	if(pulling && (get_dist(src, pulling) > 1))
		pulling = null
		user.pulledby = null
		if(user==pulling)
			return
	if(pulling && (get_dir(src.loc, pulling.loc) == direction))
		to_chat(user, SPAN_WARNING("You cannot go there."))
		return

	driving = 1
	var/turf/T = null
	if(pulling)
		T = pulling.loc
		if(get_dist(src, pulling) >= 1)
			step(pulling, get_dir(pulling.loc, src.loc))
	step(src, direction)
	set_dir(direction)
	if(pulling)
		if(pulling.loc == src.loc)
			pulling.forceMove(T)
		else
			spawn(0)
			if(get_dist(src, pulling) > 1)
				pulling = null
				user.pulledby = null
			pulling.set_dir(get_dir(pulling, src))
	driving = 0


/obj/structure/cart/Move()
	. = ..()
	if (pulling && (get_dist(src, pulling) > 1))
		pulling.pulledby = null
		to_chat(pulling, SPAN_WARNING("You lost your grip!"))
		pulling = null
	if(has_gravity())
		playsound(src, movesound, 50, 1)

/obj/structure/cart/CtrlClick(var/mob/user)
	if(in_range(src, user))
		if(!ishuman(user))	return
		if(!pulling)
			pulling = user
			user.pulledby = src
			if(user.pulling)
				user.stop_pulling()
			user.set_dir(get_dir(user, src))
			to_chat(user, SPAN_NOTICE("You grip \the [name]'s handles."))
		else
			to_chat(user, SPAN_NOTICE("You let go of \the [name]'s handles."))
			pulling.pulledby = null
			pulling = null
		return

/obj/structure/cart/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0))
		return TRUE
	if(mover?.movement_type & PHASING)
		return TRUE
	if(istype(mover) && mover.pass_flags & PASSTABLE)
		return TRUE
	if(istype(mover, /mob/living) && mover == pulling)
		return TRUE
	else
		if(istype(mover, /obj/projectile))
			return prob(20)
		else
			return !density

ABSTRACT_TYPE(/obj/structure/cart/storage)
	var/has_items = FALSE

	/// Used for displaying and handling radial menu. Collective list of every single item this object contains.
	var/list/storage_contents = list()

/obj/structure/cart/storage/proc/handle_storing(var/attacking_item, var/mob/user, var/should_store, var/storage_is_full)

/obj/structure/cart/storage/proc/get_storage_contents_list()

/obj/structure/cart/storage/take_apart(var/mob/user = null, var/obj/I)
	if(has_items)
		spill()
	. = ..()
