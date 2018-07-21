//Wizard Rig
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
	siemens_coefficient = 0.3
	wizard_garb = 1
	species_restricted = list("Human", "Machine", "Heavy Machine", "Skeleton")

/obj/item/clothing/head/helmet/space/void/wizard/equipped(var/mob/living/user)
	if(!user.is_wizard())
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/LH = H.get_organ("l_hand")
		var/obj/item/organ/external/RH = H.get_organ("r_hand")
		var/active_hand = H.hand
		user << "<span class='warning'>As you pick it up, \the [src] flashes, and you feel a searing pain through your hand! You should put this down as soon as you can!</span>"
		playsound(user, 'sound/effects/sparks4.ogg', 40, 1)
		if(active_hand)
			LH.take_damage(15)
		else
			RH.take_damage(15)
		return
	else
		..()

/obj/item/clothing/head/helmet/space/void/wizard/mob_can_equip(mob/living/carbon/human/M, slot)
	if (!..())
		return 0

	if(!M.is_wizard())
		M << "<span class='danger'>As you try to put on \the [src], the gems studding it suddenly grow to spikes, stabbing into your head and neck until you yank it off and drop it!</span>"
		M.apply_damage(30, BRUTE, "head")
		playsound(M, 'sound/effects/splut.ogg', 40, 1)
		M.drop_item()
		return 0

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
	siemens_coefficient = 0.3
	wizard_garb = 1
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/teleportation_scroll,/obj/item/weapon/scrying,/obj/item/weapon/spellbook,/obj/item/device/soulstone,/obj/item/weapon/material/knife/ritual)
	species_restricted = list("Human", "Skrell", "Machine", "Heavy Machine", "Skeleton")

/obj/item/clothing/suit/space/void/wizard/equipped(var/mob/living/user)
	if(!user.is_wizard())
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/LH = H.get_organ("l_hand")
		var/obj/item/organ/external/RH = H.get_organ("r_hand")
		var/active_hand = H.hand
		user << "<span class='warning'>As you pick it up, \the [src] flashes, and you feel a searing pain through your hand! You should put this down as soon as you can!</span>"
		playsound(user, 'sound/effects/sparks4.ogg', 40, 1)
		if(active_hand)
			LH.take_damage(15)
		else
			RH.take_damage(15)
		return
	else
		..()

/obj/item/clothing/suit/space/void/wizard/mob_can_equip(mob/living/carbon/human/M, slot)
	if (!..())
		return 0

	if(!M.is_wizard())
		M << "<span class='danger'>As you try to put on \the [src], the gems studding it suddenly grow to spikes, stabbing into your body until you yank it off and drop it!</span>"
		M.apply_damage(30, BRUTE, "chest")
		playsound(M, 'sound/effects/splut.ogg', 40, 1)
		M.drop_item()
		return 0
