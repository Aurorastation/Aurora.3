/spell/targeted/dark_resurrection
	name = "Dark Resurrection"
	desc = "This spell brings the user back to life, as long their soul is stored in a phylactery."
	feedback = "DAR"
	range = 0
	school = "necromancy"
	spell_flags = GHOSTCAST | INCLUDEUSER
	charge_max = 600 //1 minute
	max_targets = 1

	invocation = ""
	invocation_type = SpI_NONE

	hud_state = "wiz_lich"

/spell/targeted/dark_resurrection/cast(mob/target,var/mob/living/carbon/human/user as mob)
	..()
	if(user.stat != DEAD)
		to_chat(user, "<span class='notice'>You're not dead yet!</span>")
		return 0

	var/obj/item/phylactery/P
	for(var/thing in world_phylactery)
		var/obj/item/phylactery/N = thing
		if (!QDELETED(N) && N.lich == user)
			P = N

	if(P)
		user.forceMove(get_turf(P))
		to_chat(user, "<span class='notice'>Your dead body returns to your phylactery, slowly rebuilding itself.</span>")
		if(prob(25))
			var/area/A = get_area(P)
			command_announcement.Announce("High levels of bluespace activity detected at \the [A]. Investigate it soon as possible.", "Bluespace Anomaly Report")

		addtimer(CALLBACK(src, .proc/post_dark_resurrection, user), rand(200, 400))
		return 1

	else
		to_chat(user, "<span class='danger'>Your phylactery was destroyed, your existence will face oblivion now.</span>")
		user.visible_message("<span class='cult'>As [user]'s body turns to dust, a twisted wail can be heard!</span>")
		playsound(get_turf(user), 'sound/hallucinations/wail.ogg', 50, 1)
		user.dust()
		return 0

/spell/targeted/dark_resurrection/proc/post_dark_resurrection(var/mob/living/carbon/human/user as mob)
	user.revive()
	to_chat(user, "<span class='danger'>You have returned to life!</span>")
	user.visible_message("<span class='cult'>[user] rises up from the dead!</span>")
	playsound(get_turf(user), 'sound/magic/pope_entry.ogg', 100, 1)
	user.update_canmove()
	return 1