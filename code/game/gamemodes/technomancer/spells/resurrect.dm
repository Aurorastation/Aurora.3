/datum/technomancer/spell/resurrect
	name = "Resurrect"
	desc = "This function injects various regenetive medical compounds and nanomachines, in an effort to restart the body, \
	however this must be done soon after they die, as this will have no effect on people who have died long ago.  It also doesn't \
	resolve whatever caused them to die originally."
	cost = 100
	obj_path = /obj/item/spell/resurrect
	ability_icon_state = "tech_resurrect"
	category = SUPPORT_SPELLS

/obj/item/spell/resurrect
	name = "resurrect"
	icon_state = "radiance"
	desc = "Perhaps this can save a trip to cloning?"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED

/obj/item/spell/resurrect/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		if(L == user)
			to_chat(user, "<span class='warning'>Clever as you may seem, this won't work on yourself while alive.</span>")
			return 0
		if(L.stat != DEAD)
			to_chat(user, "<span class='warning'>\The [L] isn't dead!</span>")
			return 0
		if(pay_energy(5000))
			if(L.tod > world.time + 30 MINUTES)
				to_chat(user, "<span class='danger'>\The [L]'s been dead for too long, even this function cannot replace cloning at this point.</span>")
				return 0
			to_chat(user, "<span class='notice'>You stab \the [L] with a hidden integrated hypo, attempting to bring them back...</span>")
			if(istype(L, /mob/living/simple_animal))
				var/mob/living/simple_animal/SM = L
				SM.rejuvenate()
				SM.health = SM.getMaxHealth() / 3
				adjust_instability(15)
			else if(ishuman(L))
				var/mob/living/carbon/human/H = L

				if(!H.client && H.mind) //Don't force the dead person to come back if they don't want to.
					for(var/mob/abstract/observer/ghost in player_list)
						if(ghost.mind == H.mind)
							sound_to(ghost, 'sound/effects/psi/power_feedback.ogg')
							to_chat(ghost, "The Technomancer [user.real_name] is trying to revive you. Re-enter your body if you want to be revived!")
							break

				H.adjustBruteLoss(-40)
				H.adjustFireLoss(-40)

				sleep(10 SECONDS)
				if(H.client)
					L.set_stat(CONSCIOUS) //Note that if whatever killed them in the first place wasn't fixed, they're likely to die again.
					dead_mob_list -= H
					living_mob_list += H
					H.timeofdeath = null
					visible_message("<span class='danger'>\The [H]'s eyes open!</span>")
					to_chat(user, "<span class='notice'>It's alive!</span>")
					adjust_instability(50)
					log_and_message_admins("has resurrected [H].")
				else
					to_chat(user, "<span class='warning'>The body of \the [H] doesn't seem to respond, perhaps you could try again?</span>")
					adjust_instability(10)