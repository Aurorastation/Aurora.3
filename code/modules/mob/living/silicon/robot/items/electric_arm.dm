/obj/item/borg/stun
	name = "electrified arm"
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"

/obj/item/borg/stun/apply_hit_effect(mob/living/M, mob/living/silicon/robot/user, var/hit_zone)
	if(!istype(user))
		return 0

	user.visible_message("<span class='danger'>\The [user] has prodded \the [M] with \a [src]!</span>")

	if(!user.cell || !user.cell.checked_use(1250)) //Slightly more than a baton.
		return 0

	playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

	M.apply_effect(5, STUTTER)
	M.stun_effect_act(0, 70, check_zone(hit_zone), src)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.forcesay(hit_appends)

	return 0