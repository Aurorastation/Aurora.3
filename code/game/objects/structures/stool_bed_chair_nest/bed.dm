/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	desc_info = "Click and drag yourself (or anyone) to this to buckle in. Click on this with an empty hand to undo the buckles.<br>\
	Anyone with restraints, such as handcuffs, will not be able to unbuckle themselves. They must use the Resist button, or verb, to break free of \
	the buckles, instead."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "bed"
	anchored = TRUE
	can_buckle = TRUE
	buckle_dir = SOUTH
	buckle_lying = 1
	var/material/padding_material
	var/base_icon = "bed"
	var/can_dismantle = TRUE
	gfi_layer_rotation = GFI_ROTATION_DEFDIR
	var/apply_material_color = TRUE
	var/makes_rolling_sound = TRUE
	var/buckle_sound = 'sound/effects/buckle.ogg'

/obj/structure/bed/Initialize(mapload, var/new_material, var/new_padding_material)
	. = ..()
	color = null
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = SSmaterials.get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	if(new_padding_material)
		padding_material = SSmaterials.get_material_by_name(new_padding_material)
	update_icon()

/obj/structure/bed/buckle_mob(mob/living/M)
	. = ..()
	if(. && buckle_sound)
		playsound(src, buckle_sound, 20)

// Reuse the cache/code from stools, todo maybe unify.
/obj/structure/bed/update_icon()
	// Prep icon.
	icon_state = ""
	cut_overlays()
	var/list/stool_cache = SSicon_cache.stool_cache
	// Base icon.
	var/cache_key = "[base_icon]-[material.name]"
	if(!stool_cache[cache_key])
		var/image/I = image('icons/obj/furniture.dmi', base_icon)
		if(apply_material_color)
			I.color = material.icon_colour
		stool_cache[cache_key] = I
	add_overlay(stool_cache[cache_key])
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "[base_icon]-padding-[padding_material.name]"
		if(!stool_cache[padding_cache_key])
			var/image/I =  image(icon, "[base_icon]_padding")
			if(apply_material_color)
				I.color = padding_material.icon_colour
			stool_cache[padding_cache_key] = I
		add_overlay(stool_cache[padding_cache_key])

	// Strings.
	desc = initial(desc)
	if(padding_material)
		name = "[padding_material.display_name] [initial(name)]" //this is not perfect but it will do for now.
		desc += " It's made of [material.use_name] and covered with [padding_material.use_name]."
	else
		name = "[material.display_name] [initial(name)]"
		desc += " It's made of [material.use_name]."

/obj/structure/bed/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return ..()

/obj/structure/bed/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return

/obj/structure/bed/attackby(obj/item/W as obj, mob/user as mob)
	if(W.iswrench())
		if(can_dismantle)
			playsound(src.loc, W.usesound, 50, 1)
			dismantle()
			qdel(src)
	else if(istype(W,/obj/item/stack))
		if(padding_material)
			to_chat(user, "\The [src] is already padded.")
			return
		var/obj/item/stack/C = W
		if(C.get_amount() < 1) // How??
			qdel(C)
			return
		var/padding_type //This is awful but it needs to be like this until tiles are given a material var.
		if(istype(W,/obj/item/stack/tile/carpet))
			padding_type = "carpet"
		else if(istype(W,/obj/item/stack/material))
			var/obj/item/stack/material/M = W
			if(M.material && (M.material.flags & MATERIAL_PADDING))
				padding_type = "[M.material.name]"
		if(!padding_type)
			to_chat(user, "You cannot pad \the [src] with that.")
			return
		C.use(1)
		if(!istype(src.loc, /turf))
			user.drop_from_inventory(src)
			src.forceMove(get_turf(src))
		to_chat(user, "You add padding to \the [src].")
		add_padding(padding_type)
		return

	else if (W.iswirecutter())
		if(!padding_material)
			to_chat(user, "\The [src] has no padding to remove.")
			return
		to_chat(user, "You remove the padding from \the [src].")
		playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
		remove_padding()

	else if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		var/mob/living/affecting = G.affecting
		user.visible_message("<span class='notice'>[user] attempts to buckle [affecting] into \the [src]!</span>")
		if(do_after(user, 20))
			affecting.forceMove(loc)
			spawn(0)
				if(buckle_mob(affecting))
					affecting.visible_message(\
						"<span class='danger'>[affecting.name] is buckled to [src] by [user.name]!</span>",\
						"<span class='danger'>You are buckled to [src] by [user.name]!</span>",\
						"<span class='notice'>You hear metal clanking.</span>")
			qdel(W)

	else if(!istype(W, /obj/item/bedsheet))
		..()

/obj/structure/bed/proc/remove_padding()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_icon()

/obj/structure/bed/proc/add_padding(var/padding_type)
	padding_material = SSmaterials.get_material_by_name(padding_type)
	update_icon()

/obj/structure/bed/proc/dismantle()
	material.place_sheet(get_turf(src))
	if(padding_material)
		padding_material.place_sheet(get_turf(src))

/obj/structure/bed/psych
	name = "psychiatrist's couch"
	desc = "For prime comfort during psychiatric evaluations."
	icon_state = "psychbed"
	base_icon = "psychbed"

/obj/structure/bed/psych/New(var/newloc)
	..(newloc, MATERIAL_WOOD, MATERIAL_LEATHER)

/obj/structure/bed/padded/New(var/newloc)
	..(newloc, MATERIAL_PLASTIC, MATERIAL_COTTON)

/obj/structure/bed/aqua
	name = "aquabed"
	icon_state = "aquabed"

/obj/structure/bed/aqua/Initialize()
	.=..()
	set_light(1,1,LIGHT_COLOR_CYAN)

/obj/structure/bed/aqua/update_icon()
	return

/*
 * Roller beds
 */
/obj/structure/bed/roller
	name = "roller bed"
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "standard_down"
	anchored = FALSE
	var/base_state = "standard"
	var/item_bedpath = /obj/item/roller
	var/obj/item/reagent_containers/beaker
	var/iv_attached = 0
	var/iv_stand = TRUE

/obj/structure/bed/roller/update_icon()
	overlays.Cut()
	if(density)
		icon_state = "[base_state]_up"
	else
		icon_state = "[base_state]_down"
	if(beaker)
		var/image/iv = image(icon, "iv[iv_attached]")
		var/percentage = round((beaker.reagents.total_volume / beaker.volume) * 100, 25)
		var/image/filling = image(icon, "iv_filling[percentage]")
		filling.color = beaker.reagents.get_color()
		iv.overlays += filling
		if(percentage < 25)
			iv.overlays += image(icon, "light_low")
		if(density)
			iv.pixel_y = 6
		overlays += iv

/obj/structure/bed/roller/attackby(obj/item/I, mob/user)
	if(iswrench(I) || istype(I, /obj/item/stack) || iswirecutter(I))
		return 1
	if(iv_stand && !beaker && istype(I, /obj/item/reagent_containers))
		if(!user.unEquip(I, target = src))
			return
		to_chat(user, SPAN_NOTICE("You attach \the [I] to \the [src]."))
		beaker = I
		update_icon()
		return 1
	..()

/obj/structure/bed/roller/attack_hand(mob/living/user)
	if(beaker && !buckled_mob)
		remove_beaker(user)
	else
		..()

/obj/structure/bed/roller/proc/collapse()
	visible_message("<b>[usr]</b> collapses \the [src].")
	new item_bedpath(get_turf(src))
	qdel(src)

/obj/structure/bed/roller/process()
	if(!iv_attached || !buckled_mob || !beaker)
		return PROCESS_KILL

	if(SSprocessing.times_fired % 2)
		return

	if(beaker.volume > 0)
		beaker.reagents.trans_to_mob(buckled_mob, beaker.amount_per_transfer_from_this, CHEM_BLOOD)
		update_icon()

/obj/structure/bed/roller/proc/remove_beaker(mob/user)
	to_chat(user, SPAN_NOTICE("You detach \the [beaker] from \the [src]."))
	iv_attached = FALSE
	beaker.dropInto(loc)
	beaker = null
	update_icon()

/obj/structure/bed/roller/proc/attach_iv(mob/living/carbon/human/target, mob/user)
	if(!beaker)
		return
	if(do_mob(user, target, 1 SECOND))
		visible_message("<b>[user]</b> attaches [target] to the IV on \the [src].")
		iv_attached = TRUE
		update_icon()
		START_PROCESSING(SSprocessing, src)

/obj/structure/bed/roller/proc/detach_iv(mob/living/carbon/human/target, mob/user)
	visible_message("<b>[user]</b> takes [target] off the IV on \the [src].")
	iv_attached = FALSE
	update_icon()
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/bed/roller/MouseDrop(over_object, src_location, over_location)
	..()
	if(use_check(usr) || !Adjacent(usr))
		return
	if(!(ishuman(usr) || isrobot(usr)))
		return
	if(over_object == buckled_mob && beaker)
		if(iv_attached)
			detach_iv(buckled_mob, usr)
		else
			attach_iv(buckled_mob, usr)
		return
	if(ishuman(over_object))
		if(user_buckle_mob(over_object, usr))
			attach_iv(buckled_mob, usr)
			return
	if(beaker)
		remove_beaker(usr)
		return
	if(buckled_mob)
		return
	collapse()

/obj/structure/bed/roller/Move()
	..()
	if(makes_rolling_sound)
		playsound(src, 'sound/effects/roll.ogg', 100, 1)
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.forceMove(src.loc)
		else
			buckled_mob = null

/obj/structure/bed/roller/post_buckle_mob(mob/living/M)
	. = ..()
	if(M == buckled_mob)
		density = TRUE
		M.pixel_y = 6
		M.old_y = 6
		update_icon()
	else
		density = FALSE
		M.pixel_y = 0
		M.old_y = 0
		if(iv_attached)
			detach_iv(M, usr)
		update_icon()

/obj/structure/bed/roller/hover
	name = "medical hoverbed"
	icon_state = "hover_down"
	base_state = "hover"
	makes_rolling_sound = FALSE
	item_bedpath = /obj/item/roller/hover

/obj/structure/bed/roller/hover/Initialize()
	.=..()
	set_light(2,1,LIGHT_COLOR_CYAN)

/obj/item/roller
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "standard_folded"
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'
	center_of_mass = list("x" = 17,"y" = 7)
	var/bedpath = /obj/structure/bed/roller
	w_class = 4.0 // Can't be put in backpacks. Oh well.

/obj/item/roller/hover
	name = "medical hoverbed"
	desc = "A collapsed hoverbed that can be carried around."
	icon_state = "hover_folded"
	bedpath = /obj/structure/bed/roller/hover

/obj/item/roller/attack_self(mob/user)
		var/obj/structure/bed/roller/R = new bedpath(user.loc)
		R.add_fingerprint(user)
		qdel(src)

/obj/item/roller/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W,/obj/item/roller_holder))
		var/obj/item/roller_holder/RH = W
		if(!RH.held)
			to_chat(user, "<span class='notice'>You collect the roller bed.</span>")
			src.forceMove(RH)
			RH.held = src
			return

	..()

/obj/item/roller_holder
	name = "roller bed rack"
	desc = "A rack for carrying a collapsed roller bed."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "standard_folded"
	var/obj/item/roller/held

/obj/item/roller_holder/New()
	..()
	held = new /obj/item/roller(src)

/obj/item/roller_holder/attack_self(mob/user as mob)

	if(!held)
		to_chat(user, "<span class='notice'>The rack is empty.</span>")
		return

	to_chat(user, "<span class='notice'>You deploy the roller bed.</span>")
	var/obj/structure/bed/roller/R = new /obj/structure/bed/roller(user.loc)
	R.add_fingerprint(user)
	qdel(held)
	held = null
