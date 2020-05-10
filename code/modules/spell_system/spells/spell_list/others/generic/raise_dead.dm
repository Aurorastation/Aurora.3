/spell/targeted/raise_dead
	name = "Raise Dead"
	desc = "This spell turns a body into a skeleton servant."
	feedback = "RD"
	school = "necromancy"
	charge_max = 1000
	spell_flags = NEEDSCLOTHES | SELECTABLE
	invocation = "RY'SY FROH YER G'RVE!"
	invocation_type = SpI_SHOUT
	range = 3
	max_targets = 1

	compatible_mobs = list(/mob/living/carbon/human)

	hud_state = "wiz_skeleton"

/spell/targeted/raise_dead/cast(list/targets, mob/user)
	..()

	for(var/mob/living/target in targets)
		if(!(target.stat == DEAD))
			to_chat(user, "This spell can't affect the living.")
			return 0

		if(isundead(target))
			to_chat(user, "This spell can't affect the undead.")
			return 0

		if(islesserform(target))
			to_chat(user, "This spell can't affect this lesser creature.")
			return 0

		if(isipc(target))
			to_chat(user, "This spell can't affect non-organics.")
			return 0

		var/mob/living/carbon/human/skeleton/F = new(get_turf(target))
		target.visible_message("<span class='cult'>\The [target] explodes in a shower of gore, a skeleton emerges from the remains!</span>")
		target.gib()
		var/datum/ghosttrap/ghost = get_ghost_trap("skeleton minion")
		ghost.request_player(F,"A wizard is requesting a skeleton minion.", 60 SECONDS)
		spawn(600)
			if(F)
				if(!F.ckey || !F.client)
					F.visible_message("With no soul to keep \the [F] linked to this plane, it turns into dust.")
					F.dust()

			else
				to_chat(F, "<B>You are a skeleton minion to [usr], they are your master. Obey and protect your master at all costs, you have no free will.</B>")
				F.faction = usr.faction

		//equips the skeleton war gear
		F.equip_to_slot_or_del(new /obj/item/clothing/under/gladiator(F), slot_w_uniform)
		F.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(F), slot_shoes)
		F.equip_to_slot_or_del(new /obj/item/material/twohanded/spear/bone(F), slot_back)
		F.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/bone(F), slot_head)
		F.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bone(F), slot_wear_suit)

		return 1