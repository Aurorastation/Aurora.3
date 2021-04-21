//wip wip wup
/obj/structure/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) brand mirror! The leading technology in hair salon products, utilizing nano-machinery to style your hair just right."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = 0
	anchored = 1
	var/shattered = 0

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