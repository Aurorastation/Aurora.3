/spell/rune_write
	name = "Scribe a Rune"
	desc = "Let's you instantly manifest a working rune."

	school = "evocation"
	charge_max = 100
	charge_type = Sp_RECHARGE
	invocation_type = SpI_NONE

	spell_flags = CONSTRUCT_CHECK

	hud_state = "const_rune"

	smoke_amt = 1

/spell/rune_write/choose_targets(mob/user = usr)
	return list(user)

/spell/rune_write/cast(null, mob/user = usr)
	if(!isturf(user.loc))
		to_chat(user, span("warning", "You do not have enough space to write a proper rune."))

	var/rune = input(user, "Choose a rune to scribe", "Rune Scribing") as null|anything in SScult.runes_by_name//not cancellable.
	if(locate(/obj/effect/rune) in get_turf(user))
		to_chat(user, span("warning", "There is already a rune in this location."))
		return

	if(!rune)
		return

	var/RD = SScult.runes_by_name[rune]
	var/obj/effect/rune/R = new(get_turf(user), RD)
	R.color = "#A10808"

	var/area/A = get_area(R)
	log_and_message_admins("created \an [rune] rune at \the [A.name] - [user.loc.x]-[user.loc.y]-[user.loc.z].", user)

	for(var/obj/O in range(1,user))
		O.cultify()
	for(var/turf/T in range(1,user))
		var/atom/movable/overlay/animation = new /atom/movable/overlay(T)
		animation.name = "conjure"
		animation.density = 0
		animation.anchored = 1
		animation.icon = 'icons/effects/effects.dmi'
		animation.layer = 3
		animation.master = T
		if(istype(T,/turf/simulated/wall))
			animation.icon_state = "cultwall"
			flick("cultwall", animation)
		else
			animation.icon_state = "cultfloor"
			flick("cultfloor", animation)
		QDEL_IN(animation, 10)
		T.cultify()
