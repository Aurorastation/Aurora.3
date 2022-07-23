/obj/structure/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) brand mirror! The leading technology in hair salon products, utilizing nano-machinery to style your hair just right."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = 0
	anchored = 1
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

	entered_event.register(loc, reflection, /obj/effect/reflection/proc/check_vampire_enter)
	exited_event.register(loc, reflection, /obj/effect/reflection/proc/check_vampire_exit)

/obj/structure/mirror/Destroy()
	var/obj/effect/reflection/reflection = ref.resolve()
	if(istype(reflection))
		entered_event.unregister(loc, reflection)
		exited_event.unregister(loc, reflection)
		qdel(reflection)
		ref = null
	return ..()

/obj/structure/mirror/attack_hand(mob/user as mob)
	if(shattered)
		return

	if(user.mind)
		var/datum/vampire/vampire = user.mind.antag_datums[MODE_VAMPIRE]
		if(vampire && !(vampire.status & VAMP_ISTHRALL))
			to_chat(user, "<span class='notice'>Your reflection appears distorted on the surface of \the [src].</span>")

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.change_appearance(APPEARANCE_ALL_HAIR, H, FALSE, ui_state = default_state, state_object = src)

/obj/structure/mirror/proc/shatter()
	if(shattered)	return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, /decl/sound_category/glass_break_sound, 70, 1)
	desc = "Oh no, seven years of bad luck!"

	var/obj/effect/reflection/reflection = ref.resolve()
	if(istype(reflection))
		reflection.alpha_icon_state = "mirror_mask_broken"
		reflection.update_mirror_filters()


/obj/structure/mirror/bullet_act(var/obj/item/projectile/Proj)
	if(prob(Proj.get_structure_damage() * 2))
		if(!shattered)
			shatter()
		else
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
	..()

/obj/structure/mirror/attackby(obj/item/I as obj, mob/user as mob)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return

	if(prob(I.force * 2))
		visible_message("<span class='warning'>[user] smashes [src] with [I]!</span>")
		shatter()
	else
		visible_message("<span class='warning'>[user] hits [src] with [I]!</span>")
		playsound(src.loc, 'sound/effects/glass_hit.ogg', 70, 1)

/obj/structure/mirror/attack_generic(var/mob/user, var/damage)

	user.do_attack_animation(src)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return 0

	if(damage)
		user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
		shatter()
	else
		user.visible_message("<span class='danger'>[user] hits [src] and bounces off!</span>")
	return 1

/obj/effect/reflection
	name = "reflection"
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE
	mouse_opacity = 0
	vis_flags = VIS_HIDE
	layer = ABOVE_OBJ_LAYER
	var/alpha_icon = 'icons/obj/watercloset.dmi'
	var/alpha_icon_state = "mirror_mask"
	var/obj/mirror
	desc = "Why are you locked in the bathroom?"
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

	vis_contents += get_turf(mirror)

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

/obj/item/mirror/attack_self(mob/user as mob)
	if(user.mind)
		var/datum/vampire/vampire = user.mind.antag_datums[MODE_VAMPIRE]
		if(vampire && !(vampire.status & VAMP_ISTHRALL))
			to_chat(user, "<span class='notice'>Your reflection appears distorted on the surface of \the [src].</span>")

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.change_appearance(APPEARANCE_HAIR, H, FALSE, ui_state = default_state, state_object = src)
