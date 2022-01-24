/obj/item/borg/stun
	name = "electrified arm"
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"

/obj/item/borg/stun/apply_hit_effect(mob/living/M, mob/living/silicon/robot/user, var/hit_zone)
	if(!istype(user))
		return FALSE

	user.visible_message(SPAN_DANGER("\The [user] has prodded \the [M] with \a [src]!"), SPAN_DANGER("You prod \the [M] with \the [src]."))

	if(!user.cell || !user.cell.checked_use(1250)) //Slightly more than a baton.
		return FALSE

	playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

	M.apply_effect(5, STUTTER)
	M.stun_effect_act(0, 70, check_zone(hit_zone), src)

	return FALSE