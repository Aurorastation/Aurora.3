/obj/item/scrying
	name = "scrying orb"
	desc = "An incandescent orb of otherworldly energy, staring into it gives you vision beyond mortal means."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	throw_speed = 3
	throw_range = 7
	throwforce = 10
	damtype = BURN
	force = 10
	hitsound = 'sound/items/welder_pry.ogg'

/obj/item/scrying/attack_self(mob/living/user as mob)
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/E = H.get_eyes(no_synthetic = TRUE)
			if (!E)
				to_chat(user, SPAN_NOTICE("You stare deep into the abyss... and nothing happens. What a letdown."))
				return

			to_chat(user, SPAN_WARNING("You stare deep into the abyss... and the abyss stares back."))
			sleep(10)
			to_chat(user, SPAN_WARNING("Your [E.name] fill with painful light, and you feel a sharp burning sensation in your head!"))
			user.custom_emote(2, "screams in horror!")
			playsound(user, 'sound/hallucinations/far_noise.ogg', 40, 1)
			user.drop_item()
			user.visible_message(SPAN_DANGER("Ashes pour out of [user]'s eye sockets!"))
			new /obj/effect/decal/cleanable/ash(get_turf(user))
			E.removed(user)
			qdel(E)
			H.adjustBrainLoss(50, 55)
			H.hallucination += 20
			return
	else
		to_chat(user, SPAN_INFO("You can see... everything!"))
		visible_message(SPAN_DANGER("[user] stares into [src], their eyes glazing over."))

		user.teleop = user.ghostize(1)
		announce_ghost_joinleave(user.teleop, 1, "You feel that they used a powerful artifact to [pick("invade","disturb","disrupt","infest","taint","spoil","blight")] this place with their presence.")
		return
