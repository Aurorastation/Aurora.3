/spell/targeted/heal_target
	name = "Cure Light Wounds"
	desc = "A rudimentary spell used mainly by wizards to heal papercuts."
	feedback = "CL"
	school = "cleric"
	charge_max = 200
	spell_flags = INCLUDEUSER | SELECTABLE
	invocation = "Di'Nath"
	invocation_type = SpI_SHOUT
	range = 2
	max_targets = 1
	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 1, Sp_POWER = 2)
	cast_sound = 'sound/magic/Staff_Healing.ogg'

	cooldown_reduc = 50
	hud_state = "heal_minor"

	amt_dam_brute = -15
	amt_dam_fire = -15

	message = "You feel a pleasant rush of heat move through your body."

/spell/targeted/heal_target/empower_spell()
	if(!..())
		return 0
	amt_dam_brute -= 5
	amt_dam_fire -= 5

	return "[src] will now heal more."

/spell/targeted/heal_target/major
	name = "Cure Major Wounds"
	desc = "A spell used to fix others that cannot be fixed with regular medicine."
	feedback = "CM"
	charge_max = 300
	spell_flags = INCLUDEUSER | SELECTABLE | NEEDSCLOTHES
	invocation = "Borv Di'Nath"
	range = 1
	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 1, Sp_POWER = 1)
	cooldown_reduc = 100
	hud_state = "heal_major"

	amt_dam_brute = -35
	amt_dam_fire  = -35

	message = "Your body feels like a furnace."

/spell/targeted/heal_target/major/empower_spell()
	if(!..())
		return 0
	amt_dam_tox = -20
	amt_dam_oxy = -20

	return "[src] now heals oxygen loss and toxic damage."

/spell/targeted/heal_target/area
	name = "Cure Area"
	desc = "This spell heals everyone in an area."
	feedback = "HA"
	charge_max = 600
	spell_flags = INCLUDEUSER
	invocation = "Nal Di'Nath"
	range = 2
	max_targets = 0
	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 1, Sp_POWER = 1)
	cooldown_reduc = 300
	hud_state = "heal_area"

	amt_dam_brute = -10
	amt_dam_fire = -10

/spell/targeted/heal_target/area/empower_spell()
	if(!..())
		return 0
	amt_dam_brute -= 5
	amt_dam_fire -= 5
	range += 2

	return "[src] now heals more in a wider area."


/spell/targeted/heal_target/sacrifice
	name = "Sacrifice"
	desc = "This spell heals immensily. For a price."
	feedback = "SF"
	spell_flags = SELECTABLE
	invocation = "Ei'Nath Borv Di'Nath"
	charge_type = Sp_HOLDVAR
	holder_var_type = "bruteloss"
	holder_var_amount = 75
	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 0, Sp_POWER = 1)

	amt_dam_brute = -50
	amt_dam_fire = -50
	amt_dam_oxy = -50
	amt_dam_tox = -50

	hud_state = "gen_dissolve"

/spell/targeted/heal_target/sacrifice/empower_spell()
	if(!..())
		return 0

	holder_var_amount *= 2

	amt_dam_brute *= 2
	amt_dam_fire *= 2
	amt_dam_oxy *= 2
	amt_dam_tox *= 2



	return "You will now heal twice as much, but take twice as much damage. It will probably kill you."

/spell/targeted/mend
	name = "Mend Wounds"
	desc = "This spell heals internal wounds and broken bones."
	feedback = "MW"
	spell_flags = INCLUDEUSER | SELECTABLE | NEEDSCLOTHES
	invocation = "Ges'undh'eit"
	invocation_type = SpI_SHOUT

	school = "cleric"

	charge_max = 700

	cast_sound = 'sound/magic/Staff_Healing.ogg'

	hud_state = "wiz_revive"

	range = 1

	compatible_mobs = list(/mob/living/carbon/human)

/spell/targeted/mend/cast(list/targets, mob/user)
	..()
	for(var/mob/living/target in targets)
		if(isundead(target))
			user << "This spell can't affect the undead."
			return 0

		if(isipc(target))
			user << "This spell can't affect non-organics."
			return 0

		if(!ishuman(target))
			user << "<span class='warning'>\The [target]'s body is not complex enough to require healing of this kind.</span>"
			return 0

		var/mob/living/carbon/human/H = target
		var/obj/item/organ/external/E = H.get_organ(user.zone_sel.selecting)

		if(!E || E.is_stump())
			user << "<span class='warning'>They are missing that limb.</span>"
			return 0

		if(E.robotic >= ORGAN_ROBOT)
			user << "<span class='warning'>That limb is prosthetic.</span>"
			return 0

		user.visible_message("<span class='notice'>\The [user] rests a hand on \the [target]'s [E.name].</span>")
		target << "<span class='notice'>A healing warmth suffuses you.</span>"

		for(var/datum/wound/W in E.wounds)
			if(W.internal)
				user << "<span class='notice'>You painstakingly mend the torn veins in \the [E], stemming the internal bleeding.</span>"
				E.wounds -= W
				E.update_damages()
				return 1

			if(W.bleeding())
				user << "<span class='notice'>You knit together severed veins and broken flesh, stemming the bleeding.</span>"
				W.bleed_timer = 0
				E.status &= ~ORGAN_BLEEDING
				return 1

		if(E.status & ORGAN_BROKEN)
			user << "<span class='notice'>You coax shattered bones to come together and fuse, mending the break.</span>"
			E.status &= ~ORGAN_BROKEN
			E.stage = 0
			return 1

		for(var/obj/item/organ/I in E.internal_organs)
			if(I.robotic < ORGAN_ROBOT && I.damage > 0)
				user << "<span class='notice'>You encourage the damaged tissue of \the [I] to repair itself.</span>"
				I.damage = max(0, I.damage - rand(3,5))
				return 1

		user << "<span class='notice'>You can find nothing within \the [target]'s [E.name] to mend.</span>"
		return 1

/spell/targeted/resurrection
	name = "Resurrection"
	desc = "This spell brings someone back from the gates of death."
	feedback = "RES"
	spell_flags = NEEDSCLOTHES | SELECTABLE
	invocation = "Se'id Rev' Oreh"
	invocation_type = SpI_SHOUT

	school = "cleric"

	charge_max = 5000

	cast_sound = 'sound/magic/Staff_Healing.ogg'

	hud_state = "wiz_revive"

	range = 1

	compatible_mobs = list(/mob/living/carbon/human)

/spell/targeted/resurrection/cast(list/targets, mob/user)
	..()

	for(var/mob/living/target in targets)
		if(target.stat != DEAD && !(target.status_flags & FAKEDEATH))
			user << "<span class='warning'>\The [target] is still alive!</span>"
			return 0

		if(isundead(target))
			user << "This spell can't affect the undead."
			return 0

		if(isipc(target))
			user << "This spell can't affect non-organics."
			return 0

		if((world.time - target.timeofdeath) > 3000)
			user << "<span class='warning'>\The [target]'s soul is too far away from your grasp.</span>"
			return 0

		user.visible_message("<span class='notice'>\The [user] waves their hands over \the [target]'s body...</span>")

		if(!do_after(user, 30, target, 0, 1))
			user << "<span class='warning'>Your concentration is broken!</span>"
			return 0

		for(var/mob/abstract/observer/ghost in dead_mob_list)
			if(ghost.mind && ghost.mind.current == target && ghost.client)
				ghost << "<span class='notice'>Your body has been revived, <b>Re-Enter Corpse</b> to return to it.</span>"
				break

		target << "<span class='warning'>Eternal rest is stolen from you, you are cast back into the world of the living!</span>"
		target.visible_message("<span class='notice'>\The [target] shudders violently!</span>")

		if(target.status_flags & FAKEDEATH)
			target.changeling_revive()

		else
			target.adjustOxyLoss(-rand(15,20))
			target.revive()

		return 1

