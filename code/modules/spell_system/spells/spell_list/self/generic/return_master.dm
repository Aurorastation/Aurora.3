/spell/contract/return_master
	name = "Return to Master"
	desc = "Teleport back to your master"

	school = "abjuration"
	charge_max = 600
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	cooldown_min = 200

	smoke_spread = 1
	smoke_amt = 5

	hud_state = "wiz_tele"


/spell/contract/return_master/cast(mob/target, mob/user)
	target = ..(target,user)
	if(!target)
		return

	to_chat(user, SPAN_WARNING("\The [user] teleported to you!"))
	user.forceMove(get_turf(target))
	user.visible_message(SPAN_WARNING("\The [user] appears out of thin air!"))
	var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread
	smoke.set_up(5, 0, get_turf(user))
	smoke.attach(user)
	smoke.start()