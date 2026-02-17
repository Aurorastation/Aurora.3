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
	atom_flags = CRITICAL_ATOM
	movable_flags = MOVABLE_FLAG_WHEELED
	var/movesound = 'sound/effects/roll.ogg'

/obj/structure/cart/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "<b>CTRL-Click</b> to start dragging this cart. This object has a special dragging behaviour: when dragged, character's movement \
		directs the cart and the character is subsequently pulled by it."

/obj/structure/cart/disassembly_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "An empty cart can be taken apart with a <b>wrench</b> or a <b>welder</b>. Or a <b>plasma cutter</b>, if you're that hardcore. If it contains anything when disassembled, these contents will spill onto the floor."
/obj/structure/cart/proc/take_apart(var/mob/user = null, var/obj/item/object)
	if(user)
		if(object.tool_behaviour == TOOL_WELDER)
			var/obj/item/welder = object
			welder.play_tool_sound(get_turf(src), 50)
		user.visible_message("<b>[user]</b> starts taking apart the [src]...", SPAN_NOTICE("You start disassembling the [src]..."))
		if(!do_after(user, 30, do_flags = DO_DEFAULT & ~DO_USER_SAME_HAND))
			return

	dismantle()

/obj/structure/cart/ex_act(severity)
	spill(100 / severity)
	..()

/obj/structure/cart/proc/spill(var/chance = 100)

/obj/structure/cart/proc/update_slowdown()

/obj/structure/cart/relaymove(mob/living/user, direction)
	. = ..()

	if(user.incapacitated())
		return

	user.glide_size = glide_size
	step(src, direction)
	set_dir(direction)

/obj/structure/cart/Move()
	. = ..()
	if(has_gravity())
		playsound(src, movesound, 50, 1)

/obj/structure/cart/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0))
		return TRUE
	if(mover?.movement_type & PHASING)
		return TRUE
	if(istype(mover) && mover.pass_flags & PASSTABLE)
		return TRUE
	if(istype(mover, /mob/living))
		for(var/obj/item/grab/G as anything in grabbed_by)
			if(G.grabber == mover)
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

/obj/structure/cart/storage/take_apart(var/mob/user = null, var/obj/object)
	if(has_items)
		spill()
	. = ..()
