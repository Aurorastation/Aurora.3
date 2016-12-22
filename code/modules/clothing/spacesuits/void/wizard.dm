//Wizard Rig
/obj/item/clothing/head/helmet/space/void/wizard
	name = "gem-encrusted voidsuit helmet"
	desc = "A bizarre gem-encrusted helmet that radiates magical energies."
	icon_state = "rig0-wiz"
	item_state_slots = list(
		slot_l_hand_str = "wiz_helm",
		slot_r_hand_str = "wiz_helm",
		)
	unacidable = 1 //No longer shall our kind be foiled by lone chemists with spray bottles!
	armor = list(melee = 40, bullet = 20, laser = 20,energy = 20, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.3
	wizard_garb = 1

	equipped(var/mob/user)
		if(!(user.mind.assigned_role == "Space Wizard"))
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/LH = H.get_organ("l_hand")
			var/obj/item/organ/external/RH = H.get_organ("r_hand")
			var/active_hand = H.hand
			user << "\red Your hand passes through the [src] with a flash of searing heat!"
			playsound(user, 'sound/effects/sparks4.ogg', 40, 1)
			user.drop_item()
			if(active_hand)
				LH.droplimb(0,DROPLIMB_BURN)
			else
				RH.droplimb(0,DROPLIMB_BURN)
			return
		else
			..()


/obj/item/clothing/suit/space/void/wizard
	icon_state = "rig-wiz"
	name = "gem-encrusted voidsuit"
	desc = "A bizarre gem-encrusted suit that radiates magical energies."
	item_state = "wiz_voidsuit"
	slowdown = 1
	w_class = 3
	unacidable = 1
	armor = list(melee = 40, bullet = 20, laser = 20,energy = 20, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.3
	wizard_garb = 1
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/teleportation_scroll,/obj/item/weapon/scrying,/obj/item/weapon/spellbook,/obj/item/device/soulstone,/obj/item/weapon/material/knife/ritual)

	equipped(var/mob/user)
		if(!(user.mind.assigned_role == "Space Wizard"))
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/LH = H.get_organ("l_hand")
			var/obj/item/organ/external/RH = H.get_organ("r_hand")
			var/active_hand = H.hand
			user << "\red Your hand passes through the [src] with a flash of searing heat!"
			playsound(user, 'sound/effects/sparks4.ogg', 40, 1)
			user.drop_item()
			if(active_hand)
				LH.droplimb(0,DROPLIMB_BURN)
			else
				RH.droplimb(0,DROPLIMB_BURN)
			return
		else
			..()

