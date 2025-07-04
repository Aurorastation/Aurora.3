/obj/structure/bed/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/structure/chairs.dmi'
	icon_state = "stool_preview"
	base_icon = "stool"
	anchored = FALSE
	buckle_dir = 0
	buckle_lying = FALSE //force people to sit up in chairs when buckled
	build_amt = 2
	held_item = /obj/item/material/stool // if null it can't be picked up. Automatically applies materials.
	var/withdraw_verb = "grab"  //Self explanatory. Replace if necessary.

/obj/structure/bed/stool/Initialize()
	. = ..()
	can_buckle = FALSE // Some idiot decided can_buckle should be a list...

/obj/structure/bed/stool/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	. = ..()
	if(over == user && Adjacent(user))
		if(!held_item || use_check_and_message(user) || buckled || (anchored && padding_material)) // Make sure held_item = null if you don't want it to get picked up.
			return
		user.visible_message(SPAN_NOTICE("[user] [withdraw_verb]s \the [src.name]."), SPAN_NOTICE("You [withdraw_verb] \the [src.name]."))
		var/obj/item/material/stool/S = new held_item(src.loc, material.name, padding_material?.name, painted_colour) // Handles all the material code so you don't have to.
		if(material_alteration & MATERIAL_ALTERATION_COLOR) // For snowflakes like wood chairs.
			S.color = material.icon_colour
		if(material_alteration & MATERIAL_ALTERATION_NAME)
			S.name = name // Get the name and desc of the stool, rather. We already went through all the trouble in New in bed.dm
		if(material_alteration & MATERIAL_ALTERATION_DESC)
			S.desc = desc
		if(blood_DNA)
			S.blood_DNA |= blood_DNA // Transfer blood, if any.
			S.add_blood()
		S.dir = dir
		S.add_fingerprint(user)
		user.put_in_hands(S)
		S.update_icon()
		TransferComponents(S)
		if(istype(S, /obj/item/material/stool/chair/wheelchair))
			S.name = name
			S.desc = desc
			S.color = color
			S.update_held_icon()
		qdel(src)

/obj/structure/bed/stool/wood/New(var/newloc)
	..(newloc, MATERIAL_WOOD)

/obj/structure/bed/stool/padded
	icon_state = "stool_padded_preview" //set for the map

/obj/structure/bed/stool/padded/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/padded/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_DARK_GRAY)

/obj/structure/bed/stool/padded/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_BEIGE)

/obj/structure/bed/stool/padded/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/padded/orange/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_ORANGE)

/obj/structure/bed/stool/padded/yellow/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_YELLOW)

/obj/structure/bed/stool/padded/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_GREEN)

/obj/structure/bed/stool/padded/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_LIME)

/obj/structure/bed/stool/padded/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_BLUE)

/obj/structure/bed/stool/padded/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_TEAL)

/obj/structure/bed/stool/padded/purple/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_PURPLE)

/obj/structure/bed/stool/padded/violet/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_VIOLET)

/obj/structure/bed/stool/bar
	name = "bar stool"
	desc = "It has some unsavory stains on it..."
	icon_state = "bar_stool_preview"
	item_state = "bar_stool"
	base_icon = "bar_stool"
	held_item = /obj/item/material/stool/bar
	obj_flags = OBJ_FLAG_ROTATABLE_ANCHORED

/obj/structure/bed/stool/bar/wood/New(var/newloc)
	..(newloc, MATERIAL_WOOD)

/obj/structure/bed/stool/bar/padded
	icon_state = "bar_stool_padded_preview"

// ROYGBIV colors for convenience. Mappers can use custom hex codes or defines if they want special colors.


/obj/structure/bed/stool/bar/padded/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/bar/padded/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_DARK_GRAY)

/obj/structure/bed/stool/bar/padded/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_BEIGE)

/obj/structure/bed/stool/bar/padded/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/bar/padded/orange/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_ORANGE)

/obj/structure/bed/stool/bar/padded/yellow/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_YELLOW)

/obj/structure/bed/stool/bar/padded/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_GREEN)

/obj/structure/bed/stool/bar/padded/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_LIME)

/obj/structure/bed/stool/bar/padded/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_BLUE)

/obj/structure/bed/stool/bar/padded/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_TEAL)

/obj/structure/bed/stool/bar/padded/purple/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_PURPLE)

/obj/structure/bed/stool/bar/padded/violet/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH, COLOR_VIOLET)

/obj/structure/bed/stool/hover
	name = "hoverstool"
	desc = "As comfortable as a cloud."
	icon_state = "hover_stool"
	item_state = "hover_stool"
	base_icon = "hover_stool"
	can_dismantle = FALSE
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC
	held_item = /obj/item/material/stool/hover

/obj/structure/bed/stool/hover/New(var/newloc)
	..(newloc, MATERIAL_SHUTTLE_SKRELL)
	set_light(1,1,LIGHT_COLOR_CYAN)

/obj/structure/bed/chair/stool/bamboo
	name = "bamboo stool"
	desc = "A makeshift bamboo stool with a rustic look."
	icon_state = "bamboo_stool"
	item_state = "bamboo_stool_item"
	base_icon = "bamboo_stool"
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC
	held_item = /obj/item/material/stool/bamboo
	can_pad = FALSE

/obj/structure/bed/stool/bamboo/New(var/newloc)
	..(newloc, MATERIAL_BAMBOO)

// Stool Items

/obj/item/material/stool
	name = "stool"
	icon = 'icons/obj/structure/chairs.dmi'
	icon_state = "stool_item_preview"
	item_state = "stool"
	base_icon = "stool"
	desc_info = "Use in-hand or alt-click to right this."
	randpixel = 0
	center_of_mass = null
	force = 15	// Doesn't really matter. Will get overriden by set_material.
	throwforce = 10
	throw_range = 5
	force_divisor = 0.4
	w_class = WEIGHT_CLASS_HUGE
	contained_sprite = TRUE
	var/material/padding_material
	var/obj/structure/bed/stool/origin_type = /obj/structure/bed/stool
	var/deploy_verb = "right"
	var/painted_colour

/obj/item/material/stool/New(var/newloc, var/new_material, var/new_padding_material, var/new_painted_colour)
	..(newloc, new_material)	// new_material handled in material_weapons.dm
	if(new_padding_material)
		padding_material = SSmaterials.get_material_by_name(new_padding_material)
	if(new_painted_colour)
		painted_colour = new_painted_colour
	update_icon()

/obj/item/material/stool/attack_self(mob/user)
	deploy(user)

/obj/item/material/stool/AltClick(mob/user)
	deploy(user)

/obj/item/material/stool/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if((over && (!use_check(over))) && (over.contents.Find(src)) || in_range(src, over))
		if(!istype(over, /mob/living/carbon/slime) && !istype(over, /mob/living/simple_animal))
			var/mob/mouse_dropped_over = over
			if( !mouse_dropped_over.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
				if (H.hand)
					temp = H.organs_by_name["l_hand"]
				if(temp && !temp.is_usable())
					to_chat(H, SPAN_NOTICE("You try to move your [temp.name], but cannot!"))
					return
				to_chat(H, SPAN_NOTICE("You pick up \the [src]."))
				H.put_in_hands(src)
	return

/obj/item/material/stool/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(prob(300 / force)) // Weaker materials are more likely to shatter on people randomly.
		var/blocked = target.get_blocked_ratio(hit_zone, DAMAGE_BRUTE)
		target.Weaken(force * BLOCKED_MULT(blocked))
		target.apply_damage(force * 2, DAMAGE_BRUTE, hit_zone, blocked, src)
		user.visible_message(SPAN_DANGER("[user] [material.destruction_desc] \the [src] to pieces against \the [target]'s [hit_zone]!"), SPAN_DANGER("\The [src] [material.destruction_desc] to pieces against \the [target]'s [hit_zone]!"))
		use_material_shatter = FALSE
		shatter()

/obj/item/material/stool/proc/deploy(mob/user)
	for(var/obj/A in get_turf(loc))
		if(istype(A, /obj/structure/bed))
			to_chat(user, SPAN_DANGER("There is already a [A.name] here."))
			return
		if(A.density && !istype(A, /obj/structure/railing))
			to_chat(user, SPAN_DANGER("There is already something here."))
			return

	user.visible_message(SPAN_NOTICE("[user] [deploy_verb]s \the [src.name]."), SPAN_NOTICE("You [deploy_verb] \the [name]."))
	// playsound(src, deploy_sound ? deploy_sound : drop_sound, DROP_SOUND_VOLUME)
	user.drop_from_inventory(src)
	var/obj/structure/bed/stool/S = new origin_type(get_turf(loc), material?.name, padding_material?.name, painted_colour) // Fuck me.
	S.dir = user.dir // Plant it where the user's facing
	if(blood_DNA)
		S.blood_DNA |= blood_DNA // Transfer blood.
	S.update_icon()
	TransferComponents(S)
	if(istype(S, /obj/structure/bed/stool/chair/office/wheelchair))
		S.name = name
		S.desc = desc
		S.color = color
	qdel(src)

/obj/item/material/stool/update_icon()
	icon_state = "[base_icon]_item"
	ClearOverlays()
	if(padding_material)	// Handles padding overlay and inhand overlays.
		var/image/padding_overlay = image(icon, "[base_icon]_item_padding")
		padding_overlay.appearance_flags = RESET_COLOR
		build_from_parts = TRUE
		worn_overlay = "padding"
		if(painted_colour)
			padding_overlay.color = painted_colour
			worn_overlay_color = painted_colour
		else if(padding_material.icon_colour)
			padding_overlay.color = padding_material.icon_colour
			worn_overlay_color = padding_material.icon_colour
		AddOverlays(padding_overlay)
	else
		build_from_parts = FALSE
	update_held_icon()

/obj/item/material/stool/shatter()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_icon()
	..()

/obj/item/material/stool/ex_act(severity)
	switch(severity)
		if(1.0)
			shatter(src)
			return
		if(2.0)
			if(prob(50))
				shatter(src)
				return
		if(3.0)
			if(prob(5))
				shatter(src)
				return

/obj/item/material/stool/bar
	icon_state = "bar_stool_item_preview"
	item_state = "bar_stool"
	base_icon = "bar_stool"
	origin_type = /obj/structure/bed/stool/bar

/obj/item/material/stool/bar/New(var/newloc, new_material, new_padding_material, new_painted_colour)
	if(!new_material)
		new_material = MATERIAL_STEEL
	..(newloc, new_material, new_padding_material, new_painted_colour)

/obj/item/material/stool/hover
	icon_state = "hover_stool_item"
	item_state = "hover_stool"
	base_icon = "hover_stool"
	origin_type = /obj/structure/bed/stool/hover

/obj/item/material/stool/hover/New(var/newloc, new_material, new_padding_material, new_painted_colour)
	if(!new_material)
		new_material = MATERIAL_SHUTTLE_SKRELL
	..(newloc, new_material, new_padding_material, new_painted_colour)

/obj/item/material/stool/bamboo
	icon_state = "bamboo_stool_item"
	item_state = "bamboo_stool"
	base_icon = "bamboo_stool"
	origin_type = /obj/structure/bed/stool/bamboo

/obj/item/material/stool/bamboo/New(var/newloc, new_material, new_padding_material, new_painted_colour)
	if(!new_material)
		new_material = MATERIAL_BAMBOO
	..(newloc, new_material, new_padding_material, new_painted_colour)

/obj/structure/flora/log_bench
	name = "log bench"
	desc = "Apply butt."
	icon = 'icons/obj/wood.dmi'
	icon_state = "tree_log"
	anchored = FALSE
	density = FALSE

/obj/structure/flora/log_bench/fire_act(exposed_temperature, exposed_volume)
	. = ..()

	for(var/obj/structure/bonfire/B in get_turf(src))
		if(B.on_fire)
			B.fuel = min(B.max_fuel, B.fuel + 300)
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)
