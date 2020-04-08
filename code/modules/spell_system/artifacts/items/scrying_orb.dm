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
	hitsound = 'sound/items/welder2.ogg'

/obj/item/scrying/attack_self(mob/living/user as mob)
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/E = H.get_eyes(no_synthetic = TRUE)
			if (!E)
				to_chat(user, "<span class='notice'>You stare deep into the abyss... and nothing happens. What a letdown.</span>")
				return

			to_chat(user, "<span class='warning'>You stare deep into the abyss... and the abyss stares back.</span>")
			sleep(10)
			to_chat(user, "<span class='warning'>Your [E.name] fill with painful light, and you feel a sharp burning sensation in your head!</span>")
			user.custom_emote(2, "screams in horror!")
			playsound(user, 'sound/hallucinations/far_noise.ogg', 40, 1)
			user.drop_item()
			user.visible_message("<span class='danger'>Ashes pour out of [user]'s eye sockets!</span>")
			new /obj/effect/decal/cleanable/ash(get_turf(user))
			E.removed(user)
			qdel(E)
			H.adjustBrainLoss(50, 55)
			H.hallucination += 20
			return
	else
		to_chat(user, "<span class='info'>You can see... everything!</span>")
		visible_message("<span class='danger'>[user] stares into [src], their eyes glazing over.</span>")

		user.teleop = user.ghostize(1)
		announce_ghost_joinleave(user.teleop, 1, "You feel that they used a powerful artifact to [pick("invade","disturb","disrupt","infest","taint","spoil","blight")] this place with their presence.")
		return