/obj/structure/bed/stool/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete // Not anymore. - Wezzy
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "chair_preview"
	base_icon = "chair"
	anchored = TRUE
	build_amt = 1
	buckle_dir = 0
	buckle_lying = 0 //force people to sit up in chairs when buckled_to
	obj_flags = OBJ_FLAG_ROTATABLE_ANCHORED
	var/propelled = 0 // Check for fire-extinguisher-driven chairs
	held_item = /obj/item/material/stool/chair/

/obj/structure/bed/stool/chair/Initialize()
	. = ..()
	LAZYADD(can_buckle, /mob/living)

/obj/structure/bed/stool/chair/do_simple_ranged_interaction(var/mob/user)
	if(!buckled && user)
		rotate(user)
	return TRUE

/obj/structure/bed/stool/chair/post_buckle()
	update_icon()
	return ..()

/obj/structure/bed/stool/chair/update_icon()
	..()	// This handles all chair-specific funky stuff, such as chair backrests, armrests, padding and buckles.

	var/list/furniture_cache = SSicon_cache.furniture_cache

	var/cache_key = "[base_icon]-[material.name]-over"
	if(!furniture_cache[cache_key])
		var/image/I = image('icons/obj/furniture.dmi', "[base_icon]_over")
		if(material_alteration & MATERIAL_ALTERATION_COLOR)
			I.color = material.icon_colour
		I.layer = FLY_LAYER
		furniture_cache[cache_key] = I
	add_overlay(furniture_cache[cache_key])
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "[base_icon]-[padding_material.name]-padding-over"
		if(!furniture_cache[padding_cache_key])
			var/image/I =  image(icon, "[base_icon]_padding_over")
			if(material_alteration & MATERIAL_ALTERATION_COLOR)
				I.color = padding_material.icon_colour
			I.layer = FLY_LAYER
			furniture_cache[padding_cache_key] = I
		add_overlay(furniture_cache[padding_cache_key])

	if(buckled)
		cache_key = "[base_icon]-[material.name]-armrest"
		if(!furniture_cache[cache_key])
			var/image/I = image(icon, "[base_icon]_armrest")
			I.layer = FLY_LAYER
			if(material_alteration & MATERIAL_ALTERATION_COLOR)
				I.color = material.icon_colour
			furniture_cache[cache_key] = I
		add_overlay(furniture_cache[cache_key])
		if(padding_material)
			cache_key = "[base_icon]-[padding_material.name]-padding-armrest"
			if(!furniture_cache[cache_key])
				var/image/I = image(icon, "[base_icon]_padding_armrest")
				I.layer = FLY_LAYER
				if(material_alteration & MATERIAL_ALTERATION_COLOR)
					I.color = padding_material.icon_colour
				furniture_cache[cache_key] = I
			add_overlay(furniture_cache[cache_key])

/obj/structure/bed/stool/chair/set_dir()
	. = ..()
	if(buckled)
		buckled.set_dir(dir)

/obj/structure/bed/stool/chair/MouseDrop_T(mob/target, mob/user)
	if(target == user && user.loc != loc && (reverse_dir[dir] & angle2dir(Get_Angle(src, user))))
		user.visible_message("<b>[user]</b> starts climbing over the back of \the [src]...", SPAN_NOTICE("You start climbing over the back of \the [src]..."))
		if(do_after(user, 2 SECONDS))
			user.forceMove(loc)
		return
	return ..()

/obj/structure/bed/stool/chair/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(anchored)
		if(mover.density && isliving(mover) && (reverse_dir[dir] & angle2dir(Get_Angle(src, mover))))
			return FALSE
	return ..()

/obj/structure/bed/stool/chair/padded/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/chair/padded/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/chair/padded/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_TEAL)

/obj/structure/bed/stool/chair/padded/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLACK)

/obj/structure/bed/stool/chair/padded/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_GREEN)

/obj/structure/bed/stool/chair/padded/purp/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_PURPLE)

/obj/structure/bed/stool/chair/padded/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLUE)

/obj/structure/bed/stool/chair/padded/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BEIGE)

/obj/structure/bed/stool/chair/padded/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_LIME)

/obj/structure/bed/stool/chair/sofa
	name = "sofa"
	desc = "A sofa, how nice!"
	icon_state = "sofamiddle_preview"
	base_icon = "sofamiddle"

/obj/structure/bed/stool/chair/sofa/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/chair/sofa/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/chair/sofa/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_TEAL)

/obj/structure/bed/stool/chair/sofa/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLACK)

/obj/structure/bed/stool/chair/sofa/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_GREEN)

/obj/structure/bed/stool/chair/sofa/purp/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_PURPLE)

/obj/structure/bed/stool/chair/sofa/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLUE)

/obj/structure/bed/stool/chair/sofa/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH)

/obj/structure/bed/stool/chair/sofa/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_LIME)

/obj/structure/bed/stool/chair/sofa/left
	icon_state = "sofaend_left_preview"
	base_icon = "sofaend_left"

/obj/structure/bed/stool/chair/sofa/left/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/chair/sofa/left/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/chair/sofa/left/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_TEAL)

/obj/structure/bed/stool/chair/sofa/left/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLACK)

/obj/structure/bed/stool/chair/sofa/left/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_GREEN)

/obj/structure/bed/stool/chair/sofa/left/purp/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_PURPLE)

/obj/structure/bed/stool/chair/sofa/left/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLUE)

/obj/structure/bed/stool/chair/sofa/left/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH)

/obj/structure/bed/stool/chair/sofa/left/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_LIME)

/obj/structure/bed/stool/chair/sofa/right
	icon_state = "sofaend_right_preview"
	base_icon = "sofaend_right"

/obj/structure/bed/stool/chair/sofa/right/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/chair/sofa/right/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/chair/sofa/right/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_TEAL)

/obj/structure/bed/stool/chair/sofa/right/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLACK)

/obj/structure/bed/stool/chair/sofa/right/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_GREEN)

/obj/structure/bed/stool/chair/sofa/right/purp/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_PURPLE)

/obj/structure/bed/stool/chair/sofa/right/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLUE)

/obj/structure/bed/stool/chair/sofa/right/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH)

/obj/structure/bed/stool/chair/sofa/right/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_LIME)

/obj/structure/bed/stool/chair/sofa/corner
	icon_state = "sofacorner_preview"
	base_icon = "sofacorner"

/obj/structure/bed/stool/chair/sofa/corner/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/chair/sofa/corner/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/chair/sofa/corner/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_TEAL)

/obj/structure/bed/stool/chair/sofa/corner/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLACK)

/obj/structure/bed/stool/chair/sofa/corner/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_GREEN)

/obj/structure/bed/stool/chair/sofa/corner/purp/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_PURPLE)

/obj/structure/bed/stool/chair/sofa/corner/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLUE)

/obj/structure/bed/stool/chair/sofa/corner/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH)

/obj/structure/bed/stool/chair/sofa/corner/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_LIME)


/obj/structure/bed/stool/chair/office // For the love of god, don't use this.
	name = "office chair"
	material_alteration = MATERIAL_ALTERATION_DESC
	makes_rolling_sound = TRUE
	anchored = FALSE
	buckle_movable = TRUE
	build_amt = 5
	held_item = null

	can_pad = FALSE

	var/driving = FALSE // Shit for wheelchairs. Doesn't really get used here, but it's for code cleanliness.
	var/mob/living/pulling = null

/obj/structure/bed/stool/chair/office/Move()
	. = ..()
	if(makes_rolling_sound)
		playsound(src, 'sound/effects/roll.ogg', 50, 1)
	if(buckled)
		var/mob/living/occupant = buckled
		if(!driving)
			occupant.buckled_to = null
			occupant.Move(src.loc)
			occupant.buckled_to = src
			if (occupant && (src.loc != occupant.loc))
				if (propelled)
					for (var/mob/O in src.loc)
						if (O != occupant)
							Collide(O)
				else
					unbuckle()
			if (pulling && (get_dist(src, pulling) > 1))
				pulling.pulledby = null
				to_chat(pulling, SPAN_WARNING("You lost your grip!"))
				pulling = null
		else
			if (occupant && (src.loc != occupant.loc))
				src.forceMove(occupant.loc) // Failsafe to make sure the wheelchair stays beneath the occupant after driving


/obj/structure/bed/stool/chair/office/Collide(atom/A)
	. = ..()
	if(!buckled)
		return

	if(propelled || (pulling && (pulling.a_intent == I_HURT)))
		var/mob/living/occupant = unbuckle()

		if (pulling && (pulling.a_intent == I_HURT))
			occupant.throw_at(A, 3, 3, pulling)
		else if (propelled)
			occupant.throw_at(A, 3, propelled)

		var/def_zone = ran_zone()
		occupant.throw_at(A, 3, propelled)
		occupant.apply_effect(6, STUN)
		occupant.apply_effect(6, WEAKEN)
		occupant.apply_effect(6, STUTTER)
		occupant.apply_damage(10, BRUTE, def_zone)
		playsound(src.loc, "punch", 50, 1, -1)
		if(isliving(A))
			var/mob/living/victim = A
			def_zone = ran_zone()
			victim.apply_effect(6, STUN)
			victim.apply_effect(6, WEAKEN)
			victim.apply_effect(6, STUTTER)
			victim.apply_damage(10, BRUTE, def_zone)

		if(pulling)
			occupant.visible_message(SPAN_DANGER("[pulling] has thrusted \the [name] into \the [A], throwing \the [occupant] out of it!"))
			pulling.attack_log += "\[[time_stamp()]\]<span class='warning'> Crashed [occupant.name]'s ([occupant.ckey]) [name] into \a [A]</span>"
			occupant.attack_log += "\[[time_stamp()]\]<font color='orange'> Thrusted into \a [A] by [pulling.name] ([pulling.ckey]) with \the [name]</font>"
			msg_admin_attack("[pulling.name] ([pulling.ckey]) has thrusted [occupant.name]'s ([occupant.ckey]) [name] into \a [A] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[pulling.x];Y=[pulling.y];Z=[pulling.z]'>JMP</a>)",ckey=key_name(pulling),ckey_target=key_name(occupant))
		else
			occupant.visible_message(SPAN_DANGER("[occupant] crashed into \the [A]!"))

/obj/structure/bed/stool/chair/office/light
	icon_state = "officechair_white_preview"
	base_icon = "officechair_white"

/obj/structure/bed/stool/chair/office/dark
	icon_state = "officechair_dark_preview"
	base_icon = "officechair_dark"

/obj/structure/bed/stool/chair/office/bridge
	name = "command chair"
	desc = "It exudes authority... and looks about as comfortable as a brick."
	icon_state = "bridge_preview"
	base_icon = "bridge"
	anchored = TRUE

/obj/structure/bed/stool/chair/office/bridge/legion
	name = "legion pilot seat"
	desc = "A comfortable seat for a pilot."
	icon_state = "bridge_legion_preview"
	base_icon = "bridge_legion"

/obj/structure/bed/stool/chair/office/bridge/generic
	icon_state = "bridge_generic_preview"
	base_icon = "bridge_generic"

/obj/structure/bed/stool/chair/office/bridge/pilot
	name = "pilot seat"
	desc = "A comfortable seat for a pilot."
	icon_state = "pilot_preview"
	base_icon = "pilot"

/obj/structure/bed/stool/chair/office/hover
	name = "hoverchair"
	desc = "Adjusts itself to the sitter's weight resulting in a most comfortable sitting experience. Like floating on a cloud."
	icon_state = "hover_chair_preview"
	base_icon = "hover_chair"
	makes_rolling_sound = FALSE
	can_dismantle = FALSE
	can_pad = TRUE
	held_item = null

/obj/structure/bed/stool/chair/office/hover/New(var/newloc)
	..(newloc, MATERIAL_SHUTTLE_SKRELL)
	set_light(1,1,LIGHT_COLOR_CYAN)

/obj/structure/bed/stool/chair/office/hover/command
	icon_state = "hover_command_preview"
	base_icon = "hover_command"

// Chair types
/obj/structure/bed/stool/chair/plastic

/obj/structure/bed/stool/chair/plastic/New(var/newloc)
	..(newloc, MATERIAL_PLASTIC)

/obj/structure/bed/stool/chair/wood
	name = "classic chair"
	desc = "Old is never too old to not be in fashion."
	icon_state = "wooden_chair_preview"
	base_icon = "wooden_chair"
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC
	build_amt = 3
	held_item = /obj/item/material/stool/chair/wood
	can_pad = FALSE

/obj/structure/bed/stool/chair/wood/New(var/newloc)
	..(newloc, MATERIAL_WOOD)

/obj/structure/bed/stool/chair/wood/wings
	name = "winged chair"
	icon_state = "wooden_chair_wings_preview"
	base_icon = "wooden_chair_wings"
	held_item = /obj/item/material/stool/chair/wood/wings

/obj/structure/bed/stool/chair/unmovable
	can_dismantle = FALSE

/obj/structure/bed/stool/chair/shuttle
	name = "shuttle chair"
	icon_state = "shuttlechair_preview"
	base_icon = "shuttlechair"
	buckling_sound = 'sound/effects/metal_close.ogg'
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC
	can_dismantle = FALSE
	anchored = TRUE

/obj/structure/bed/stool/chair/shuttle/post_buckle()
	if(buckled)
		base_icon = "shuttlechair-b"
	else
		base_icon = "shuttlechair"
	..()

/obj/structure/bed/stool/chair/shuttle/update_icon()
	..()
	if(!buckled)
		var/image/I = image(icon, "[base_icon]_special")
		I.layer = ABOVE_MOB_LAYER
		if(material_alteration & MATERIAL_ALTERATION_COLOR)
			I.color = material.icon_colour
		overlays |= I

// pool chair, to sit with your feet in the water. only works when facing south, because water overlays weirdly otherwise
/obj/structure/bed/stool/chair/pool
	name = "pool chair"
	desc = "A simple plastic contraption that allows you to sit comfortably, dipping your feet into the pool."
	icon_state = "pool_chair"
	held_item = null

/obj/structure/bed/stool/chair/pool/update_icon()
	return

/obj/structure/bed/stool/chair/pool/buckle(mob/living/M)
	if(!iscarbon(M))
		return FALSE
	return ..()

/obj/structure/bed/stool/chair/pool/post_buckle(mob/living/M)
	. = ..()
	if(M == buckled)
		M.pixel_y = -6
	else
		M.pixel_y = initial(M.pixel_y)

/obj/structure/bed/stool/chair/folding
	name = "folding chair"
	desc = "Temporary seating perfect for your next office party and/or wrestling match."
	icon_state = "folding_chair_preview"
	base_icon = "folding_chair"
	held_item = /obj/item/material/stool/chair/folding

/obj/item/material/stool/chair
	name = "chair"
	desc = "Bar brawl essential. Now all that's missing is a ragtime piano."
	desc_info = "Click it while in hand to right it."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "chair_item"
	item_state = "chair"
	base_icon = "chair"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_chairs.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_chairs.dmi',
		)
	w_class = ITEMSIZE_HUGE
	force_divisor = 0.5
	origin_type = /obj/structure/bed/stool/chair

// Because wood chairs are snowflake sprites.
/obj/item/material/stool/chair/wood
	icon_state = "wooden_chair_item"
	item_state = "woodenchair"
	base_icon = "wooden_chair"
	origin_type = /obj/structure/bed/stool/chair/wood

/obj/item/material/stool/chair/wood/wings
	icon_state = "wooden_chair_wings_item"
	item_state = "woodenchair"
	base_icon = "wooden_chair_wings"
	origin_type = /obj/structure/bed/stool/chair/wood/wings

/obj/item/material/stool/chair/folding // Todo : "borrow" CM code for stacking and general tomfoolery.
	icon_state = "folding_chair_item"
	item_state = "folding_chair"
	base_icon = "folding_chair"
	origin_type = /obj/structure/bed/stool/chair/folding
