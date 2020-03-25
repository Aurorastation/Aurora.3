/obj/item/clothing/head/helmet/space/void/wizard
	name = "gem-encrusted voidsuit helmet"
	desc = "A bizarre gem-encrusted helmet that radiates magical energies."
	icon_state = "rig0-wiz"
	item_state_slots = list(
		slot_l_hand_str = "wiz_helm",
		slot_r_hand_str = "wiz_helm"
		)
	unacidable = 1 //No longer shall our kind be foiled by lone chemists with spray bottles!
	armor = list(melee = 40, bullet = 20, laser = 20,energy = 20, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.35
	wizard_garb = 1
	species_restricted = list("Human", "Heavy Machine", "Skeleton", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame")

/obj/item/clothing/head/helmet/space/void/wizard/equipped(var/mob/living/user)
	if(!user.is_wizard())
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/LH = H.get_organ(BP_L_HAND)
		var/obj/item/organ/external/RH = H.get_organ(BP_R_HAND)
		var/active_hand = H.hand
		to_chat(user, "<span class='warning'>Your hand passes through the [src] with a flash of searing heat!</span>")
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
	item_state_slots = list(
		slot_l_hand_str = "wiz_hardsuit",
		slot_r_hand_str = "wiz_hardsuit"
	)
	slowdown = 1
	w_class = 3
	unacidable = 1
	armor = list(melee = 40, bullet = 20, laser = 20,energy = 20, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.35
	wizard_garb = 1
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/teleportation_scroll,/obj/item/scrying,/obj/item/spellbook,/obj/item/device/soulstone,/obj/item/material/knife/ritual)
	species_restricted = list("Human", "Skrell", "Heavy Machine", "Skeleton", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame")

/obj/item/clothing/suit/space/void/wizard/equipped(var/mob/living/user)
	if(!user.is_wizard())
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/LH = H.get_organ(BP_L_HAND)
		var/obj/item/organ/external/RH = H.get_organ(BP_R_HAND)
		var/active_hand = H.hand
		to_chat(user, "<span class='warning'>Your hand passes through the [src] with a flash of searing heat!</span>")
		playsound(user, 'sound/effects/sparks4.ogg', 40, 1)
		user.drop_item()
		if(active_hand)
			LH.droplimb(0,DROPLIMB_BURN)
		else
			RH.droplimb(0,DROPLIMB_BURN)
		return
	else
		..()