/obj/structure/bed/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "chair_preview"
	color = "#666666"
	base_icon = "chair"
	buckle_dir = 0
	buckle_lying = 0 //force people to sit up in chairs when buckled
	var/propelled = 0 // Check for fire-extinguisher-driven chairs

/obj/structure/bed/chair/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(!padding_material && istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		if(!SK.status)
			to_chat(user, "<span class='notice'>\The [SK] is not ready to be attached!</span>")
			return
		var/obj/structure/bed/chair/e_chair/E = new (src.loc, material.name)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.set_dir(dir)
		E.part = SK
		user.drop_from_inventory(SK,E)
		SK.master = E
		qdel(src)

/obj/structure/bed/chair/attack_tk(mob/user as mob)
	if(buckled_mob)
		..()
	else
		rotate()
	return

/obj/structure/bed/chair/post_buckle_mob()
	update_icon()

/obj/structure/bed/chair/update_icon()
	..()

	var/list/stool_cache = SSicon_cache.stool_cache

	var/cache_key = "[base_icon]-[material.name]-over"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image('icons/obj/furniture.dmi', "[base_icon]_over")
		if(apply_material_color)
			I.color = material.icon_colour
		I.layer = FLY_LAYER
		stool_cache[cache_key] = I
	add_overlay(stool_cache[cache_key])
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "[base_icon]-padding-[padding_material.name]-over"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "[base_icon]_padding_over")
			if(apply_material_color)
				I.color = padding_material.icon_colour
			I.layer = FLY_LAYER
			stool_cache[padding_cache_key] = I
		add_overlay(stool_cache[padding_cache_key])

	if(buckled_mob && padding_material)
		cache_key = "[base_icon]-armrest-[padding_material.name]"
		if(isnull(stool_cache[cache_key]))
			var/image/I = image(icon, "[base_icon]_armrest")
			I.layer = MOB_LAYER + 0.1
			if(apply_material_color)
				I.color = padding_material.icon_colour
			stool_cache[cache_key] = I
		add_overlay(stool_cache[cache_key])

/obj/structure/bed/chair/set_dir()
	. = ..()
	if(buckled_mob)
		buckled_mob.set_dir(dir)

/obj/structure/bed/chair/verb/rotate()
	set name = "Rotate Chair"
	set category = "Object"
	set src in oview(1)

	if(config.ghost_interaction)
		src.set_dir(turn(src.dir, 90))
		return
	else
		if(istype(usr,/mob/living/simple_animal/mouse))
			return
		if(!usr || !isturf(usr.loc))
			return
		if(usr.stat || usr.restrained())
			return

		src.set_dir(turn(src.dir, 90))
		return

// Leaving this in for the sake of compilation.
/obj/structure/bed/chair/comfy
	desc = "It's a chair. It looks comfy."
	icon_state = "comfychair_preview"

/obj/structure/bed/chair/comfy/brown/Initialize(mapload,var/newmaterial)
	. = ..(mapload,"steel","leather")

/obj/structure/bed/chair/comfy/red/Initialize(var/mapload,var/newmaterial)
	. = ..(mapload,"steel","carpet")

/obj/structure/bed/chair/comfy/teal/Initialize(var/mapload,var/newmaterial)
	. = ..(mapload,"steel","teal")

/obj/structure/bed/chair/comfy/black/Initialize(var/mapload,var/newmaterial)
	. = ..(mapload,"steel","black")

/obj/structure/bed/chair/comfy/green/Initialize(var/mapload,var/newmaterial)
	. = ..(mapload,"steel","green")

/obj/structure/bed/chair/comfy/purp/Initialize(var/mapload,var/newmaterial)
	. = ..(mapload,"steel","purple")

/obj/structure/bed/chair/comfy/blue/Initialize(var/mapload,var/newmaterial)
	. = ..(mapload,"steel","blue")

/obj/structure/bed/chair/comfy/beige/Initialize(var/mapload,var/newmaterial)
	. = ..(mapload,"steel","beige")

/obj/structure/bed/chair/comfy/lime/Initialize(var/mapload,var/newmaterial)
	. = ..(mapload,"steel","lime")

/obj/structure/bed/chair/office
	anchored = 0
	buckle_movable = 1

/obj/structure/bed/chair/office/update_icon()
	return

/obj/structure/bed/chair/office/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || W.iswirecutter())
		return
	..()

/obj/structure/bed/chair/office/Move()
	. = ..()
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

/obj/structure/bed/chair/office/Collide(atom/A)
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
		playsound(src.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
		if(istype(A, /mob/living))
			var/mob/living/victim = A
			def_zone = ran_zone()
			blocked = victim.run_armor_check(def_zone, "melee")
			victim.apply_effect(6, STUN, blocked)
			victim.apply_effect(6, WEAKEN, blocked)
			victim.apply_effect(6, STUTTER, blocked)
			victim.apply_damage(10, BRUTE, def_zone, blocked)
		occupant.visible_message("<span class='danger'>[occupant] crashed into \the [A]!</span>")

/obj/structure/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/bed/chair/office/dark
	icon_state = "officechair_dark"

/obj/structure/bed/chair/office/bridge
	name = "command chair"
	desc = "It exudes authority... and looks about as comfortable as a brick."
	icon_state = "bridge"
	anchored = 1

/obj/structure/bed/chair/office/Initialize()
	. = ..()
	var/image/I = image(icon, "[icon_state]_over")
	I.layer = FLY_LAYER
	add_overlay(I)

// Chair types
/obj/structure/bed/chair/wood
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."
	icon_state = "wooden_chair"

/obj/structure/bed/chair/wood/update_icon()
	return

/obj/structure/bed/chair/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || W.iswirecutter())
		return
	..()

/obj/structure/bed/chair/wood/Initialize(mapload)
	. = ..(mapload, "wood")
	var/image/I = image(icon, "[icon_state]_over")
	I.layer = FLY_LAYER
	add_overlay(I)

/obj/structure/bed/chair/wood/wings
	icon_state = "wooden_chair_wings"

/obj/structure/bed/chair/unmovable
	can_dismantle = 0

/obj/structure/bed/chair/shuttle
	icon_state = "shuttlechair"
	base_icon = "shuttlechair"
	can_dismantle = FALSE
	apply_material_color = FALSE
	anchored = TRUE

/obj/structure/bed/chair/shuttle/update_icon()
	cut_overlays()

	var/image/O = image(icon, "[icon_state]_over")
	O.layer = FLY_LAYER
	add_overlay(O)

	var/list/stool_cache = SSicon_cache.stool_cache

	var/cache_key = "[base_icon]_over"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image('icons/obj/furniture.dmi', "[base_icon]_over")
		if(apply_material_color)
			I.color = material.icon_colour
		I.layer = FLY_LAYER
		stool_cache[cache_key] = I
	add_overlay(stool_cache[cache_key])

	if(buckled_mob)
		icon_state = "[base_icon]_down"
		cache_key = "[base_icon]-armrest"
		if(isnull(stool_cache[cache_key]))
			var/image/I = image(icon, "[base_icon]_armrest")
			I.layer = MOB_LAYER + 0.1
			if(apply_material_color)
				I.color = padding_material.icon_colour
			stool_cache[cache_key] = I
		add_overlay(stool_cache[cache_key])

	else
		icon_state = initial(icon_state)