/spell/shadow_shroud
	name = "Shadow Shroud"
	desc = "This spell causes darkness at the point of the caster for a duration of time."
	feedback = "SS"
	school = "abjuration"
	spell_flags = 0
	invocation_type = SpI_EMOTE
	invocation = "mutters a chant, the light around them darkening."
	charge_max = 300 //30 seconds

	range = 5
	duration = 150 //15 seconds

	cast_sound = 'sound/effects/bamf.ogg'

	hud_state = "wiz_tajaran"

/spell/shadow_shroud/choose_targets()
	return list(get_turf(holder))

/spell/shadow_shroud/cast(var/list/targets, mob/user)
	var/turf/T = targets[1]

	if(!istype(T))
		return

	var/obj/O = new /obj(T)
	O.set_light(range, -10, "#FFFFFF")

	spawn(duration)
		qdel(O)


/spell/targeted/life_steal
	name = "Siphon Life"
	desc = "This spell steals the life essence of a target, healing the caster."
	feedback = "SL"
	school = "necromancy"
	charge_max = 300
	spell_flags = SELECTABLE
	invocation = "UMATHAR UF'KAL THENAR!"
	invocation_type = SpI_SHOUT
	range = 5
	max_targets = 1

	compatible_mobs = list(/mob/living/carbon/human)

	hud_state = "wiz_vampire"
	cast_sound = 'sound/magic/enter_blood.ogg'

	amt_dam_brute = 15
	amt_dam_fire = 15

	message = "You feel a sickening feeling as your body weakens."

/spell/targeted/life_steal/cast(var/list/targets, var/mob/living/carbon/human/caster)
	for(var/mob/M in targets)
		if(!(M.stat == DEAD))
			user << "There is no left life to steal."
			return
		if(isipc(target))
			user << "There is no life to steal."
			return
		M.visible_message("<span class='danger'>Blood flows from \the [M] into \the [caster]!</span>")
		caster.adjustBruteLoss(-15)
		caster.adjustFireLoss(-15)

		..()

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
			user << "This spell can't affect the living."
			return

		if(isskeleton(target))
			user << "This spell can't affect the undead."
			return

		if(islesserform(target))
			user << "This spell can't affect this lesser creature."
			return

		if(isipc(target))
			user << "This spell can't affect non-organics."
			return

		var/mob/living/carbon/human/skeleton/F = new(get_turf(target))
		target.visible_message("<span class='cult'>\The [target] explodes in a shower of gore, a skeleton emerges from the remains!</span>")
		target.gib()
		var/client/C = get_player()
		F.ckey = C.ckey
		F.faction = usr.faction
		if(C.mob && C.mob.mind)
			C.mob.mind.transfer_to(F)
		F << "<B>You are skeleton minion to [usr], he is your master. Aid your master don't matter what, you have no free will.</B>"

		//equips the skeleton war gear
		F.equip_to_slot_or_del(new /obj/item/clothing/under/gladiator(F), slot_w_uniform)
		F.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(F), slot_shoes)
		F.equip_to_slot_or_del(new /obj/item/weapon/material/twohanded/spear/bone(F), slot_back)
		F.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/bone(F), slot_head)
		F.equip_to_slot_or_del(new /obj/item/clothing/suit/bone(F), slot_wear_suit)

/spell/targeted/raise_dead/proc/get_player()
	for(var/mob/O in dead_mob_list)
		if(O.client)
			var/getResponse = alert(O,"A wizard is requesting a skeleton minion. Would you like to play as one?", "Skeleton minion summons","Yes","No")
			if(getResponse == "Yes")
				return O.client
	return null

/spell/targeted/lichdom
	name = "Lichdom"
	desc = "Trade your life and soul for immortality and power."
	feedback = "LID"
	range = 0
	school = "necromancy"
	charge_max = 10000
	spell_flags = Z2NOCAST | NEEDSCLOTHES | INCLUDEUSER
	invocation_type = SpI_EMOTE
	invocation = "entones an obscure chant..."
	max_targets = 1

	hud_state = "wiz_lich"

/spell/targeted/lichdom/cast(mob/target,var/mob/living/carbon/human/user as mob)
	if(isskeleton(target))
		user << "You have no soul or life to offer."
		return

	user.visible_message("<span class='cult'>\The [user]'s skin sloughs off bone, their blood boils and guts turn to dust!</span>")
	new /obj/effect/gibspawner/human
	user.verbs += /mob/living/carbon/proc/immortality
	user.set_species("Skeleton")
	user.unEquip(user.wear_suit)
	user.unEquip(user.head)
	user.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe/black(user), slot_wear_suit)
	user.equip_to_slot_or_del(new /obj/item/clothing/head/wizard/black(user), slot_head)
