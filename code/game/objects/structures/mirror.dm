/obj/structure/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) brand mirror! The leading technology in hair salon products, utilizing nano-machinery to style your hair just right."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = 0
	anchored = 1
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/shattered = 0

	/// Visual object for handling the viscontents
	var/datum/weakref/ref
	vis_flags = VIS_HIDE
	var/timerid = null

/obj/structure/mirror/Initialize()
	. = ..()
	var/obj/effect/reflection/reflection = new(src.loc)
	reflection.setup_visuals(src)
	ref = WEAKREF(reflection)

	GLOB.entered_event.register(loc, reflection, TYPE_PROC_REF(/obj/effect/reflection, check_vampire_enter))
	GLOB.exited_event.register(loc, reflection, TYPE_PROC_REF(/obj/effect/reflection, check_vampire_exit))

/obj/structure/mirror/Destroy()
	var/obj/effect/reflection/reflection = ref.resolve()
	if(istype(reflection))
		GLOB.entered_event.unregister(loc, reflection)
		GLOB.exited_event.unregister(loc, reflection)
		qdel(reflection)
		ref = null
	return ..()

/obj/structure/mirror/attack_hand(mob/user as mob)
	if(shattered)
		return

	if(user.mind)
		var/datum/vampire/vampire = user.mind.antag_datums[MODE_VAMPIRE]
		if(vampire && !(vampire.status & VAMP_ISTHRALL))
			to_chat(user, SPAN_NOTICE("Your reflection appears distorted on the surface of \the [src]."))

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.change_appearance(APPEARANCE_ALL_HAIR, H, FALSE, ui_state = GLOB.default_state, state_object = src)

/obj/structure/mirror/proc/shatter()
	if(shattered)	return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, /singleton/sound_category/glass_break_sound, 70, 1)
	desc = "Oh no, seven years of bad luck!"

	var/obj/effect/reflection/reflection = ref.resolve()
	if(istype(reflection))
		reflection.alpha_icon_state = "mirror_mask_broken"
		reflection.update_mirror_filters()


/obj/structure/mirror/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	if(prob(hitting_projectile.get_structure_damage() * 2))
		if(!shattered)
			shatter()
		else
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)

/obj/structure/mirror/attackby(obj/item/attacking_item, mob/user)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return

	if(prob(attacking_item.force * 2))
		visible_message(SPAN_WARNING("[user] smashes [src] with [attacking_item]!"))
		shatter()
	else
		visible_message(SPAN_WARNING("[user] hits [src] with [attacking_item]!"))
		playsound(src.loc, 'sound/effects/glass_hit.ogg', 70, 1)

/obj/structure/mirror/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)

	user.do_attack_animation(src)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return 0

	if(damage)
		user.visible_message(SPAN_DANGER("[user] smashes [src]!"))
		shatter()
	else
		user.visible_message(SPAN_DANGER("[user] hits [src] and bounces off!"))
	return 1

/obj/effect/reflection
	name = "reflection"
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_HIDE
	layer = ABOVE_OBJ_LAYER
	var/alpha_icon = 'icons/obj/watercloset.dmi'
	var/alpha_icon_state = "mirror_mask"
	var/obj/mirror
	desc = "Why are you locked in the bathroom?"
	desc_extended = "You talking to me?"
	anchored = TRUE
	unacidable = TRUE

	var/blur_filter

/obj/effect/reflection/proc/setup_visuals(target)
	mirror = target

	if(mirror.pixel_x > 0)
		dir = WEST
	else if (mirror.pixel_x < 0)
		dir = EAST

	if(mirror.pixel_y > 0)
		dir = SOUTH
	else if (mirror.pixel_y < 0)
		dir = NORTH

	pixel_x = mirror.pixel_x
	pixel_y = mirror.pixel_y

	blur_filter = filter(type="blur", size = 1)

	update_mirror_filters()

/obj/effect/reflection/proc/update_mirror_filters()
	filters = null

	vis_contents = null

	if(!mirror)
		return

	var/matrix/M = matrix()
	if(dir == WEST || dir == EAST)
		M.Scale(-1, 1)
	else if(dir == SOUTH|| dir == NORTH)
		M.Scale(1, -1)
		pixel_y = mirror.pixel_y + 5

	transform = M

	filters += filter("type" = "alpha", "icon" = icon(alpha_icon, alpha_icon_state), "x" = 0, "y" = 0)
	for(var/mob/living/carbon/human/H in loc)
		check_vampire_enter(H.loc, H)

	add_vis_contents(get_turf(mirror))

/obj/effect/reflection/proc/check_vampire_enter(var/turf/T, var/mob/living/carbon/human/H)
	if(!istype(H))
		return
	var/datum/vampire/V = H.get_antag_datum(MODE_VAMPIRE)
	if(V)
		if(V.status & VAMP_ISTHRALL)
			filters += blur_filter
		else
			H.vis_flags |= VIS_HIDE

/obj/effect/reflection/proc/check_vampire_exit(var/turf/T, var/mob/living/carbon/human/H)
	if(!istype(H))
		return
	var/datum/vampire/V = H.get_antag_datum(MODE_VAMPIRE)
	if(V)
		if(V.status & VAMP_ISTHRALL)
			filters -= blur_filter
		else
			H.vis_flags &= ~VIS_HIDE

/obj/item/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) brand mirror! Now a portable version."
	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "mirror"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/mirror/attack_self(mob/user as mob)
	if(user.mind)
		var/datum/vampire/vampire = user.mind.antag_datums[MODE_VAMPIRE]
		if(vampire && !(vampire.status & VAMP_ISTHRALL))
			to_chat(user, SPAN_NOTICE("Your reflection appears distorted on the surface of \the [src]."))

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.change_appearance(APPEARANCE_HAIR, H, FALSE, ui_state = GLOB.default_state, state_object = src)
