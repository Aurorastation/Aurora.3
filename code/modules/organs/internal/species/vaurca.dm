/obj/item/organ/internal/eyes/night/vaurca
	name = "vaurcaesian eyes"
	desc = "A set of four vaurcaesian eyes, adapted to the low or no light tunnels of Sedantis."
	icon = 'icons/obj/organs/vaurca_organs.dmi'
	robotic_sprite = FALSE
	vision_color = /datum/client_color/vaurca
	vision_mechanical_color = /datum/client_color/monochrome
	eye_emote = "'s eyes gently shift."

/obj/item/organ/internal/eyes/night/vaurca/surgical_fix(mob/user)
	..()
	if(damage < min_broken_damage && owner.sdisabilities & BLIND)
		owner.sdisabilities -= BLIND

/obj/item/organ/internal/eyes/night/vaurca/flash_act()
	if(!owner)
		return

	to_chat(owner, SPAN_WARNING("Your eyes burn with the intense light of the flash!"))
	disable_night_vision()
	owner.last_special = world.time + 10 SECONDS
	owner.Weaken(10)
	take_damage(rand(10, 11))
	if(damage > 12)
		owner.eye_blurry += rand(3,6)

	if(damage >= min_broken_damage)
		owner.sdisabilities |= BLIND
	else if(damage >= min_bruised_damage)
		owner.eye_blind = 5
		owner.eye_blurry = 5
		owner.disabilities |= NEARSIGHTED
		addtimer(CALLBACK(owner, /mob/.proc/reset_nearsighted), 100)

/obj/item/organ/internal/eyes/night/vaurca/robotic_check()
	return TRUE