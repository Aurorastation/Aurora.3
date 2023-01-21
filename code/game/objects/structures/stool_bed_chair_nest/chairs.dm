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

	generate_overlay_cache(material, CACHE_TYPE_OVER, FLY_LAYER) // Generate overlay for backrest
	// Padding overlay.
	if(padding_material)
		generate_overlay_cache(padding_material, CACHE_TYPE_PADDING_OVER, FLY_LAYER, TRUE) // Generate padding overlay for backrest

	if(buckled)
		generate_overlay_cache(material, CACHE_TYPE_ARMREST, FLY_LAYER) // Generate armrests
		if(padding_material)
			generate_overlay_cache(padding_material, CACHE_TYPE_PADDING_ARMREST, FLY_LAYER, TRUE) // Generate padding overlay for armrest

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
	if(anchored && padding_material)
		if(mover?.density && isliving(mover) && (reverse_dir[dir] & angle2dir(Get_Angle(src, mover))))
			return FALSE
	return ..()

/obj/structure/bed/stool/chair/padded/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/chair/padded/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_DARK_GRAY)

/obj/structure/bed/stool/chair/padded/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_BEIGE)

/obj/structure/bed/stool/chair/padded/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/chair/padded/orange/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_ORANGE)

/obj/structure/bed/stool/chair/padded/yellow/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_YELLOW)

/obj/structure/bed/stool/chair/padded/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_GREEN)

/obj/structure/bed/stool/chair/padded/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_LIME)

/obj/structure/bed/stool/chair/padded/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_BLUE)

/obj/structure/bed/stool/chair/padded/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_TEAL)

/obj/structure/bed/stool/chair/padded/purple/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_PURPLE)

/obj/structure/bed/stool/chair/padded/violet/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_VIOLET)

/obj/structure/bed/stool/chair/sofa
	name = "sofa"
	desc = "A sofa, how nice!"
	icon_state = "sofamiddle_preview"
	base_icon = "sofamiddle"

/obj/structure/bed/stool/chair/sofa/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/chair/sofa/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_DARK_GRAY)

/obj/structure/bed/stool/chair/sofa/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_BEIGE)

/obj/structure/bed/stool/chair/sofa/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/chair/sofa/orange/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_ORANGE)

/obj/structure/bed/stool/chair/sofa/yellow/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_YELLOW)

/obj/structure/bed/stool/chair/sofa/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_GREEN)

/obj/structure/bed/stool/chair/sofa/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_LIME)

/obj/structure/bed/stool/chair/sofa/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_BLUE)

/obj/structure/bed/stool/chair/sofa/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_TEAL)

/obj/structure/bed/stool/chair/sofa/purple/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_PURPLE)

/obj/structure/bed/stool/chair/sofa/violet/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_VIOLET)

/obj/structure/bed/stool/chair/sofa/left
	icon_state = "sofaend_left_preview"
	base_icon = "sofaend_left"

/obj/structure/bed/stool/chair/sofa/left/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/chair/sofa/left/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_DARK_GRAY)

/obj/structure/bed/stool/chair/sofa/left/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_BEIGE)

/obj/structure/bed/stool/chair/sofa/left/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/chair/sofa/left/orange/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_ORANGE)

/obj/structure/bed/stool/chair/sofa/left/yellow/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_YELLOW)

/obj/structure/bed/stool/chair/sofa/left/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_GREEN)

/obj/structure/bed/stool/chair/sofa/left/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_LIME)

/obj/structure/bed/stool/chair/sofa/left/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_BLUE)

/obj/structure/bed/stool/chair/sofa/left/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_TEAL)

/obj/structure/bed/stool/chair/sofa/left/purple/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_PURPLE)

/obj/structure/bed/stool/chair/sofa/left/violet/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_VIOLET)

/obj/structure/bed/stool/chair/sofa/right
	icon_state = "sofaend_right_preview"
	base_icon = "sofaend_right"

/obj/structure/bed/stool/chair/sofa/right/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/chair/sofa/right/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_DARK_GRAY)

/obj/structure/bed/stool/chair/sofa/right/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_BEIGE)

/obj/structure/bed/stool/chair/sofa/right/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/chair/sofa/right/orange/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_ORANGE)

/obj/structure/bed/stool/chair/sofa/right/yellow/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_YELLOW)

/obj/structure/bed/stool/chair/sofa/right/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_GREEN)

/obj/structure/bed/stool/chair/sofa/right/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_LIME)

/obj/structure/bed/stool/chair/sofa/right/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_BLUE)

/obj/structure/bed/stool/chair/sofa/right/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_TEAL)

/obj/structure/bed/stool/chair/sofa/right/purple/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_PURPLE)

/obj/structure/bed/stool/chair/sofa/right/violet/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_VIOLET)


/obj/structure/bed/stool/chair/sofa/corner
	icon_state = "sofacorner_preview"
	base_icon = "sofacorner"

/obj/structure/bed/stool/chair/sofa/corner/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/chair/sofa/corner/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_DARK_GRAY)

/obj/structure/bed/stool/chair/sofa/corner/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_BEIGE)

/obj/structure/bed/stool/chair/sofa/corner/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/chair/sofa/corner/orange/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_ORANGE)

/obj/structure/bed/stool/chair/sofa/corner/yellow/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_YELLOW)

/obj/structure/bed/stool/chair/sofa/corner/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_GREEN)

/obj/structure/bed/stool/chair/sofa/corner/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_LIME)

/obj/structure/bed/stool/chair/sofa/corner/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_BLUE)

/obj/structure/bed/stool/chair/sofa/corner/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_TEAL)

/obj/structure/bed/stool/chair/sofa/corner/purple/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_PURPLE)

/obj/structure/bed/stool/chair/sofa/corner/violet/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_VIOLET)


/obj/structure/bed/stool/chair/office // For the love of god, don't use this.
	name = "office chair"
	material_alteration = MATERIAL_ALTERATION_DESC
	makes_rolling_sound = TRUE
	anchored = FALSE
	buckle_movable = TRUE
	build_amt = 5
	held_item = null

	can_pad = FALSE

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
	held_item = null

/obj/structure/bed/stool/chair/shuttle
	name = "shuttle chair"
	icon_state = "shuttlechair_preview"
	base_icon = "shuttlechair"
	buckling_sound = 'sound/effects/metal_close.ogg'
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC
	can_dismantle = FALSE
	anchored = TRUE
	held_item = null

/obj/structure/bed/stool/chair/shuttle/post_buckle()
	if(buckled)
		base_icon = "shuttlechair-b"
	else
		base_icon = "shuttlechair"
	..()

/obj/structure/bed/stool/chair/shuttle/update_icon()
	..()
	if(!buckled)
		generate_overlay_cache(material, CACHE_TYPE_SPECIAL, ABOVE_MOB_LAYER)

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
	applies_material_colour = FALSE

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

//Maybe if you tried hard, you could sit on these too.
/obj/structure/bed/handrail
	name = "handrail"
	desc = "A railing that allows one to easily secure themselves via a series of straps and buckles."
	icon = 'icons/obj/handrail.dmi'
	icon_state = "handrail"
	base_icon = "handrail"
	buckle_dir = FALSE
	buckle_lying = FALSE
	can_dismantle = FALSE
	override_material_color = TRUE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED