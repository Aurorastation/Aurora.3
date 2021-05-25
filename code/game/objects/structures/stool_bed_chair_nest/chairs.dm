/obj/structure/bed/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "chair_preview"
	base_icon = "chair"
	color = "#666666"

	build_amt = 1

	buckle_dir = 0
	buckle_lying = 0 //force people to sit up in chairs when buckled_to
	obj_flags = OBJ_FLAG_ROTATABLE_ANCHORED
	var/propelled = 0 // Check for fire-extinguisher-driven chairs

/obj/structure/bed/chair/do_simple_ranged_interaction(var/mob/user)
	if(!buckled && user)
		rotate(user)
	return TRUE

/obj/structure/bed/chair/post_buckle()
	update_icon()
	return ..()

/obj/structure/bed/chair/update_icon()
	..()

	var/list/stool_cache = SSicon_cache.stool_cache

	var/cache_key = "[base_icon]-[material.name]-over"
	if(!stool_cache[cache_key])
		var/image/I = image('icons/obj/furniture.dmi', "[base_icon]_over")
		if(material_alteration & MATERIAL_ALTERATION_COLOR)
			I.color = material.icon_colour
		I.layer = FLY_LAYER
		stool_cache[cache_key] = I
	add_overlay(stool_cache[cache_key])
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "[base_icon]-[padding_material.name]-padding-over"
		if(!stool_cache[padding_cache_key])
			var/image/I =  image(icon, "[base_icon]_padding_over")
			if(material_alteration & MATERIAL_ALTERATION_COLOR)
				I.color = padding_material.icon_colour
			I.layer = FLY_LAYER
			stool_cache[padding_cache_key] = I
		add_overlay(stool_cache[padding_cache_key])

	if(buckled)
		cache_key = "[base_icon]-[material.name]-armrest"
		if(!stool_cache[cache_key])
			var/image/I = image(icon, "[base_icon]_armrest")
			I.layer = FLY_LAYER
			if(material_alteration & MATERIAL_ALTERATION_COLOR)
				I.color = material.icon_colour
			stool_cache[cache_key] = I
		add_overlay(stool_cache[cache_key])
		if(padding_material)
			cache_key = "[base_icon]-[padding_material.name]-padding-armrest"
			if(!stool_cache[cache_key])
				var/image/I = image(icon, "[base_icon]_padding_armrest")
				I.layer = FLY_LAYER
				if(material_alteration & MATERIAL_ALTERATION_COLOR)
					I.color = padding_material.icon_colour
				stool_cache[cache_key] = I
			add_overlay(stool_cache[cache_key])

/obj/structure/bed/chair/set_dir()
	. = ..()
	if(buckled)
		buckled.set_dir(dir)

// Leaving this in for the sake of compilation.
/obj/structure/bed/chair/comfy
	name = "comfy chair"
	desc = "It's a chair. It looks comfy."
	icon_state = "comfychair_preview"
	base_icon = "comfychair"
	build_amt = 2

/obj/structure/bed/chair/comfy/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/chair/comfy/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/chair/comfy/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_TEAL)

/obj/structure/bed/chair/comfy/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLACK)

/obj/structure/bed/chair/comfy/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_GREEN)

/obj/structure/bed/chair/comfy/purp/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_PURPLE)

/obj/structure/bed/chair/comfy/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLUE)

/obj/structure/bed/chair/comfy/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BEIGE)

/obj/structure/bed/chair/comfy/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_LIME)

/obj/structure/bed/chair/comfy/sofa
	name = "sofa"
	desc = "A sofa, how nice!"
	icon_state = "sofamiddle_preview"
	base_icon = "sofamiddle"

/obj/structure/bed/chair/comfy/sofa/left
	icon_state = "sofaend_left_preview"
	base_icon = "sofaend_left"

/obj/structure/bed/chair/comfy/sofa/right
	icon_state = "sofaend_right_preview"
	base_icon = "sofaend_right"

/obj/structure/bed/chair/comfy/sofa/corner
	icon_state = "sofacorner_preview"
	base_icon = "sofacorner"

/obj/structure/bed/chair/office
	name = "office chair"
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC
	anchored = 0
	buckle_movable = 1
	build_amt = 5

/obj/structure/bed/chair/office/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || W.iswirecutter())
		return
	..()

/obj/structure/bed/chair/office/Move()
	. = ..()
	if(makes_rolling_sound)
		playsound(src, 'sound/effects/roll.ogg', 100, 1)
	if(buckled)
		var/mob/living/occupant = buckled
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

/obj/structure/bed/chair/office/Collide(atom/A)
	. = ..()
	if(!buckled)
		return

	if(propelled)
		var/mob/living/occupant = unbuckle()

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
		occupant.visible_message("<span class='danger'>[occupant] crashed into \the [A]!</span>")

/obj/structure/bed/chair/office/light
	icon_state = "officechair_white_preview"
	base_icon = "officechair_white"

/obj/structure/bed/chair/office/dark
	icon_state = "officechair_dark_preview"
	base_icon = "officechair_dark"

/obj/structure/bed/chair/office/bridge
	name = "command chair"
	desc = "It exudes authority... and looks about as comfortable as a brick."
	icon_state = "bridge_preview"
	base_icon = "bridge"
	anchored = 1

/obj/structure/bed/chair/office/bridge/legion
	name = "legion pilot seat"
	desc = "A comfortable seat for a pilot."
	icon_state = "bridge_legion_preview"
	base_icon = "bridge_legion"

/obj/structure/bed/chair/office/bridge/generic
	icon_state = "bridge_generic_preview"
	base_icon = "bridge_generic"

/obj/structure/bed/chair/office/bridge/pilot
	name = "pilot seat"
	desc = "A comfortable seat for a pilot."
	icon_state = "pilot_preview"
	base_icon = "pilot"

/obj/structure/bed/chair/office/hover
	name = "hoverchair"
	desc = "Adjusts itself to the sitter's weight resulting in a most comfortable sitting experience. Like floating on a cloud."
	icon_state = "hover_chair"
	makes_rolling_sound = FALSE
	can_dismantle = FALSE

/obj/structure/bed/chair/office/hover/Initialize()
	.=..()
	set_light(1,1,LIGHT_COLOR_CYAN)

/obj/structure/bed/chair/office/hover/command
	icon_state = "hover_command"

// Chair types
/obj/structure/bed/chair/plastic

/obj/structure/bed/chair/plastic/New(var/newloc)
	..(newloc, MATERIAL_PLASTIC)

/obj/structure/bed/chair/wood
	name = "classic chair"
	desc = "Old is never too old to not be in fashion."
	icon_state = "wooden_chair_preview"
	base_icon = "wooden_chair"
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC
	build_amt = 3

/obj/structure/bed/chair/wood/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || W.iswirecutter())
		return
	..()

/obj/structure/bed/chair/wood/New(var/newloc)
	..(newloc, MATERIAL_WOOD)

/obj/structure/bed/chair/wood/wings
	name = "winged chair"
	icon_state = "wooden_chair_wings_preview"
	base_icon = "wooden_chair_wings"

/obj/structure/bed/chair/unmovable
	can_dismantle = 0

/obj/structure/bed/chair/shuttle
	name = "shuttle chair"
	icon_state = "shuttlechair_preview"
	base_icon = "shuttlechair"
	buckling_sound = 'sound/effects/metal_close.ogg'
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC
	can_dismantle = FALSE
	anchored = TRUE

/obj/structure/bed/chair/shuttle/post_buckle()
	if(buckled)
		base_icon = "shuttlechair-b"
	else
		base_icon = "shuttlechair"
	..()

/obj/structure/bed/chair/shuttle/update_icon()
	..()
	if(!buckled)
		var/image/I = image(icon, "[base_icon]_special")
		I.layer = ABOVE_MOB_LAYER
		if(material_alteration & MATERIAL_ALTERATION_COLOR)
			I.color = material.icon_colour
		overlays |= I

// pool chair, to sit with your feet in the water. only works when facing south, because water overlays weirdly otherwise
/obj/structure/bed/chair/pool
	name = "pool chair"
	desc = "A simple plastic contraption that allows you to sit comfortably, dipping your feet into the pool."
	icon_state = "pool_chair"

/obj/structure/bed/chair/pool/update_icon()
	return

/obj/structure/bed/chair/pool/buckle(mob/living/M)
	if(!iscarbon(M))
		return FALSE
	return ..()

/obj/structure/bed/chair/pool/post_buckle(mob/living/M)
	. = ..()
	if(M == buckled)
		M.pixel_y = -6
	else
		M.pixel_y = initial(M.pixel_y)
