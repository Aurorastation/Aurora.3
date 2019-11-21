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
	message = "You feel a sickening feeling as your body weakens."

	amt_dam_brute = 15
	amt_dam_fire  = 15

/spell/targeted/life_steal/cast(list/targets, mob/living/user)
	for(var/mob/living/M in targets)
		if(M.stat == DEAD)
			to_chat(user, "There is no left life to steal.")
			return 0
		if(isipc(M))
			to_chat(user, "There is no life to steal.")
			return 0
		M.visible_message("<span class='danger'>Blood flows from \the [M] into \the [user]!</span>")
		gibs(M.loc)
		user.adjustBruteLoss(-15)
		user.adjustFireLoss(-15)

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
	level_max = list(Sp_TOTAL = 0, Sp_SPEED = 0, Sp_POWER = 0)

	cast_sound = 'sound/magic/pope_entry.ogg'

	hud_state = "wiz_lich"

/spell/targeted/lichdom/cast(mob/target,var/mob/living/carbon/human/user as mob)
	..()
	if(isundead(user))
		to_chat(user, "You have no soul or life to offer.")
		return 0

	user.visible_message("<span class='cult'>\The [user]'s skin sloughs off bone, their blood boils and guts turn to dust!</span>")
	gibs(user.loc)
	user.add_spell(new /spell/targeted/dark_resurrection)
	user.set_species("Skeleton")
	user.unEquip(user.wear_suit)
	user.unEquip(user.head)
	user.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe/black(user), slot_wear_suit)
	user.equip_to_slot_or_del(new /obj/item/clothing/head/wizard/black(user), slot_head)
	to_chat(user, "<span class='notice'>Your soul flee to the remains of your heart, turning it into your phylactery. Do not allow anyone to destroy it!</span>")
	var/obj/item/phylactery/G = new(get_turf(user))
	G.lich = user
	G.icon_state = "cursedheart-on"
	user.remove_spell(src)
	return 1

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
