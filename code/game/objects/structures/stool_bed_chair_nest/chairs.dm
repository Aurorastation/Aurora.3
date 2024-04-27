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
	held_item = /obj/item/material/stool/chair

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

	generate_overlay_cache(material, CACHE_TYPE_OVER, ABOVE_HUMAN_LAYER) // Generate overlay for backrest
	// Padding overlay.
	if(padding_material)
		generate_overlay_cache(padding_material, CACHE_TYPE_PADDING_OVER, ABOVE_HUMAN_LAYER, TRUE) // Generate padding overlay for backrest

	if(buckled)
		generate_overlay_cache(material, CACHE_TYPE_ARMREST, ABOVE_HUMAN_LAYER) // Generate armrests
		if(padding_material)
			generate_overlay_cache(padding_material, CACHE_TYPE_PADDING_ARMREST, ABOVE_HUMAN_LAYER, TRUE) // Generate padding overlay for armrest

/obj/structure/bed/stool/chair/set_dir()
	. = ..()
	if(buckled)
		buckled.set_dir(dir)

/obj/structure/bed/stool/chair/MouseDrop_T(atom/dropping, mob/user)
	if(dropping == user && user.loc != loc && (GLOB.reverse_dir[dir] & angle2dir(Get_Angle(src, user))))
		user.visible_message("<b>[user]</b> starts climbing over the back of \the [src]...", SPAN_NOTICE("You start climbing over the back of \the [src]..."))
		if(do_after(user, 2 SECONDS, do_flags = DO_UNIQUE))
			user.forceMove(loc)
		return
	return ..()

/obj/structure/bed/stool/chair/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(anchored && padding_material)
		if(mover?.density && isliving(mover) && (GLOB.reverse_dir[dir] & angle2dir(Get_Angle(src, mover))))
			return FALSE
	return ..()

/obj/structure/bed/stool/chair/fancy
	name = "fancy chair"
	desc = "The armrests give you a signature feeling of superiority."
	icon_state = "chair_fancy"
	base_icon = "chair_fancy"
	held_item = /obj/item/material/stool/chair/fancy

/obj/structure/bed/stool/chair/padded
	icon_state = "chair_padding"

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

/obj/structure/bed/stool/chair/office // For the love of god, don't use this.
	name = "office chair"
	desc = "The propulsion of any lazy office worker, it has wheels."
	icon_state = null
	material_alteration = MATERIAL_ALTERATION_DESC
	makes_rolling_sound = TRUE
	anchored = FALSE
	buckle_movable = TRUE
	build_amt = 5
	held_item = null

	can_pad = FALSE

/obj/structure/bed/stool/chair/office/light
	icon_state = "officechair_white"
	base_icon = "officechair_white"

/obj/structure/bed/stool/chair/office/dark
	icon_state = "officechair_dark"
	base_icon = "officechair_dark"

/obj/structure/bed/stool/chair/office/bridge
	name = "command chair"
	desc = "It exudes authority... and looks about as comfortable as a brick."
	icon_state = "bridge"
	base_icon = "bridge"
	anchored = TRUE

/obj/structure/bed/stool/chair/office/bridge/legion
	name = "legion pilot seat"
	desc = "A comfortable seat for a pilot."
	icon_state = "bridge_legion"
	base_icon = "bridge_legion"

/obj/structure/bed/stool/chair/office/bridge/generic
	icon_state = "bridge_generic"
	base_icon = "bridge_generic"

/obj/structure/bed/stool/chair/office/bridge/pilot
	name = "pilot seat"
	desc = "A comfortable seat for a pilot."
	icon_state = "pilot"
	base_icon = "pilot"

/obj/structure/bed/stool/chair/office/hover
	name = "hoverchair"
	desc = "Adjusts itself to the sitter's weight resulting in a most comfortable sitting experience. Like floating on a cloud."
	icon_state = "hover_chair"
	base_icon = "hover_chair"
	makes_rolling_sound = FALSE
	can_dismantle = FALSE
	can_pad = TRUE
	held_item = null

/obj/structure/bed/stool/chair/office/hover/New(var/newloc)
	..(newloc, MATERIAL_SHUTTLE_SKRELL)
	set_light(1,1,LIGHT_COLOR_CYAN)

/obj/structure/bed/stool/chair/office/hover/command
	icon_state = "hover_command"
	base_icon = "hover_command"

/obj/structure/bed/stool/chair/plastic
	name = "chair"
	desc = "The monobloc chair. You'll have to take it, whether you like it or not."
	icon_state = "plastic_chair"
	base_icon = "plastic_chair"
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC
	held_item = /obj/item/material/stool/chair/plastic
	can_pad = FALSE
	anchored = FALSE

/obj/structure/bed/stool/chair/plastic/New(var/newloc)
	..(newloc, MATERIAL_PLASTIC)

/obj/structure/bed/stool/chair/plastic/post_buckle(atom/movable/MA) //you do not want to see an angry spaceman speeding while holding dearly onto it
	. = ..()
	if(MA == buckled)
		anchored = TRUE
	else
		anchored = FALSE

/obj/structure/bed/stool/chair/wood
	name = "classic chair"
	desc = "Old is never too old to not be in fashion."
	icon_state = "wooden_chair"
	base_icon = "wooden_chair"
	build_amt = 3
	held_item = /obj/item/material/stool/chair/wood
	can_pad = FALSE

/obj/structure/bed/stool/chair/wood/New(var/newloc)
	..(newloc, MATERIAL_WOOD)

/obj/structure/bed/stool/chair/wood/wings
	name = "winged chair"
	icon_state = "wooden_chair_wings"
	base_icon = "wooden_chair_wings"
	held_item = /obj/item/material/stool/chair/wood/wings

/obj/structure/bed/stool/chair/unmovable
	can_dismantle = FALSE
	held_item = null

/obj/structure/bed/stool/chair/shuttle
	name = "shuttle chair"
	icon_state = "shuttlechair"
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
		generate_overlay_cache(material, CACHE_TYPE_SPECIAL, ABOVE_HUMAN_LAYER)

/obj/structure/bed/stool/chair/cockpit
	name = "cockpit seating"
	icon_state = "cockpit_preview"
	base_icon = "cockpit"
	buckling_sound = 'sound/effects/metal_close.ogg'
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC
	can_dismantle = FALSE
	anchored = TRUE
	held_item = null
	desc = "A heavy set of belts and buckles, completed by a hinging arm mechanism that surrounds the occupant. Perfect for flying shuttles."
	icon = 'icons/obj/spaceship/cockpit_chair.dmi'

/obj/structure/bed/stool/chair/cockpit/CanPass(atom/movable/mover, turf/target, height, air_group)
	return TRUE

/obj/structure/bed/stool/chair/cockpit/update_icon()
	..()
	if(buckled)
		generate_overlay_cache(material, CACHE_TYPE_SPECIAL, ABOVE_HUMAN_LAYER)

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
	icon_state = "folding_chair"
	base_icon = "folding_chair"
	held_item = /obj/item/material/stool/chair/folding

// Chair Items

/obj/item/material/stool/chair
	name = "chair"
	desc = "Bar brawl essential. Now all that's missing is a ragtime piano."
	desc_info = "Click it while in-hand to right it."
	icon = 'icons/obj/structure/chairs.dmi'
	icon_state = "chair_item"
	item_state = "chair"
	base_icon = "chair"
	w_class = ITEMSIZE_HUGE
	force_divisor = 0.5
	origin_type = /obj/structure/bed/stool/chair

/obj/item/material/stool/chair/New(var/newloc, new_material)
	if(!new_material)
		new_material = MATERIAL_STEEL
	..(newloc, new_material)

/obj/item/material/stool/chair/fancy
	name = "fancy chair"
	desc = "Meeting brawl essential. Now all that's missing is corporate ukulele."
	icon_state = "chair_fancy_item"
	item_state = "chair_fancy"
	base_icon = "chair_fancy"
	origin_type = /obj/structure/bed/stool/chair/fancy

/obj/item/material/stool/chair/wood
	name = "classic chair"
	icon_state = "wooden_chair_item"
	item_state = "woodenchair"
	base_icon = "wooden_chair"
	origin_type = /obj/structure/bed/stool/chair/wood

/obj/item/material/stool/chair/wood/New(var/newloc, new_material)
	if(!new_material)
		new_material = MATERIAL_WOOD
	..(newloc, new_material)

/obj/item/material/stool/chair/wood/wings
	name = "winged chair"
	icon_state = "wooden_chair_wings_item"
	item_state = "woodenchair"
	base_icon = "wooden_chair_wings"
	origin_type = /obj/structure/bed/stool/chair/wood/wings

/obj/item/material/stool/chair/folding // Todo : "borrow" CM code for stacking and general tomfoolery.
	icon_state = "folding_chair_item"
	item_state = "folding_chair"
	base_icon = "folding_chair"
	origin_type = /obj/structure/bed/stool/chair/folding

/obj/item/material/stool/chair/plastic
	icon_state = "plastic_chair_item"
	item_state = "plastic_chair"
	base_icon = "plastic_chair"
	origin_type = /obj/structure/bed/stool/chair/plastic

/obj/item/material/stool/chair/plastic/New(var/newloc, new_material)
	if(!new_material)
		new_material = MATERIAL_PLASTIC
	..(newloc, new_material)

//Maybe if you tried hard, you could sit on these too.
/obj/structure/bed/handrail
	name = "handrail"
	desc = "A railing that allows one to easily secure themselves via a series of straps and buckles."
	icon = 'icons/obj/handrail.dmi'
	icon_state = "handrail"
	base_icon = "handrail"
	material_alteration = MATERIAL_ALTERATION_NONE
	buckle_dir = FALSE
	buckle_lying = FALSE
	can_dismantle = FALSE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
