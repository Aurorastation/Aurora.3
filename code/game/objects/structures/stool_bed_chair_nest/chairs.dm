/obj/structure/bed/stool/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "chair_preview"
	base_icon = "chair"
	held_item = /obj/item/material/stool/chair // if null it can't be picked up. Automatically applies materials.
	obj_flags = OBJ_FLAG_ROTATABLE_ANCHORED
	can_buckle = TRUE
	var/propelled = 0 // Check for fire-extinguisher-driven chairs

/obj/structure/bed/stool/chair/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(!padding_material && istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		if(!SK.status)
			to_chat(user, SPAN_NOTICE("The [SK] is not ready to be attached!"))
			return
		var/obj/structure/bed/stool/chair/e_chair/E = new (src.loc, material.name)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.set_dir(dir)
		E.part = SK
		user.drop_from_inventory(SK,E)
		SK.master = E
		qdel(src)

/obj/structure/bed/stool/chair/do_simple_ranged_interaction(var/mob/user)
	if(!buckled_mob && user)
		rotate(user)
	return TRUE

/obj/structure/bed/stool/chair/post_buckle_mob()
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

	if(buckled_mob)
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
	if(buckled_mob)
		buckled_mob.set_dir(dir)

// Leaving this in for the sake of compilation.
/obj/structure/bed/stool/chair/comfy
	desc = "It's a chair. It looks comfy."
	icon_state = "comfychair_preview"
	base_icon = "comfychair"
	build_amt = 2
	held_item = null

/obj/structure/bed/stool/chair/comfy/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/chair/comfy/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/chair/comfy/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_TEAL)

/obj/structure/bed/stool/chair/comfy/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLACK)

/obj/structure/bed/stool/chair/comfy/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_GREEN)

/obj/structure/bed/stool/chair/comfy/purp/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_PURPLE)

/obj/structure/bed/stool/chair/comfy/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLUE)

/obj/structure/bed/stool/chair/comfy/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BEIGE)

/obj/structure/bed/stool/chair/comfy/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_LIME)

/obj/structure/bed/stool/chair/office
	name = "office chair"
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC
	makes_rolling_sound = TRUE
	anchored = 0
	buckle_movable = 1
	build_amt = 5
	held_item = null

/obj/structure/bed/stool/chair/office/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || W.iswirecutter())
		return
	..()

/obj/structure/bed/stool/chair/office/Move()
	. = ..()
	if(makes_rolling_sound)
		playsound(src, 'sound/effects/roll.ogg', 100, 1)
	if(buckled_mob)
		var/mob/living/occupant = buckled_mob
		occupant.buckled = null
		occupant.Move(src.loc)
		occupant.buckled = src
		if (occupant && (src.loc != occupant.loc))
			if (propelled)
				for (var/mob/O in src.loc)
					if (O != occupant)
						Collide(O)
			else
				unbuckle_mob()

/obj/structure/bed/stool/chair/office/Collide(atom/A)
	. = ..()
	if(!buckled_mob)
		return

	if(propelled)
		var/mob/living/occupant = unbuckle_mob()

		var/def_zone = ran_zone()
		var/blocked = occupant.run_armor_check(def_zone, "melee")
		occupant.throw_at(A, 3, propelled)
		occupant.apply_effect(6, STUN, blocked)
		occupant.apply_effect(6, WEAKEN, blocked)
		occupant.apply_effect(6, STUTTER, blocked)
		occupant.apply_damage(10, BRUTE, def_zone, blocked)
		playsound(src.loc, "punch", 50, 1, -1)
		if(istype(A, /mob/living))
			var/mob/living/victim = A
			def_zone = ran_zone()
			blocked = victim.run_armor_check(def_zone, "melee")
			victim.apply_effect(6, STUN, blocked)
			victim.apply_effect(6, WEAKEN, blocked)
			victim.apply_effect(6, STUTTER, blocked)
			victim.apply_damage(10, BRUTE, def_zone, blocked)
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
	anchored = 1

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

/obj/structure/bed/stool/chair/wood/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || W.iswirecutter())
		return
	..()

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

/obj/structure/bed/stool/chair/shuttle/post_buckle_mob()
	if(buckled_mob)
		base_icon = "shuttlechair-b"
	else
		base_icon = "shuttlechair"
	..()

/obj/structure/bed/stool/chair/shuttle/update_icon()
	..()
	if(!buckled_mob)
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

/obj/structure/bed/stool/chair/pool/buckle_mob(mob/living/M)
	if(!iscarbon(M))
		return FALSE
	return ..()

/obj/structure/bed/stool/chair/pool/post_buckle_mob(mob/living/M)
	. = ..()
	if(M == buckled_mob)
		M.pixel_y = -6
	else
		M.pixel_y = initial(M.pixel_y)

/obj/item/material/stool/chair
	name = "chair"
	desc = "Bar brawl essential. Now all that's missing is a ragtime piano."
	desc_info = "Click it while in hand to right it."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "chair_toppled"
	item_state = "chair"
	base_icon = "chair"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_chairs.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_chairs.dmi',
		)
	w_class = ITEMSIZE_HUGE
	force_divisor = 0.5
	use_material_name = FALSE
	applies_material_colour = FALSE
	material = DEFAULT_WALL_MATERIAL
	origin_type = /obj/structure/bed/stool/chair

// Because wood chairs are snowflake sprites.
/obj/item/material/stool/chair/wood
	icon_state = "wooden_chair_toppled"
	item_state = "woodenchair"
	base_icon = "wooden_chair"
	origin_type = /obj/structure/bed/stool/chair/wood
	applies_material_colour = FALSE

/obj/item/material/stool/chair/wood/wings
	icon_state = "wooden_chair_wings_toppled"
	item_state = "woodenchair"
	base_icon= "wooden_chair_wings"
	origin_type = /obj/structure/bed/stool/chair/wood/wings
