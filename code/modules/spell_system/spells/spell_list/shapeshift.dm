//basic transformation spell. Should work for most simple_animals

/spell/targeted/shapeshift
	name = "Shapeshift"
	desc = "This spell transforms the target into something else for a short while."

	school = "transmutation"

	charge_type = Sp_RECHARGE
	charge_max = 600

	duration = 0 //set to 0 for permanent.

	var/list/possible_transformations = list()
	var/list/newVars = list() //what the variables of the new created thing will be.

	cast_sound = 'sound/weapons/emitter2.ogg'
	var/revert_sound = 'sound/weapons/emitter.ogg' //the sound that plays when something gets turned back.
	var/share_damage = 1 //do we want the damage we take from our new form to move onto our real one? (Only counts for finite duration)
	var/drop_items = 1 //do we want to drop all our items when we transform?
	var/list/protected_roles = list() //which roles are immune to the spell

/spell/targeted/shapeshift/cast(var/list/targets, mob/user)
	for(var/mob/living/M in targets)
		if(M.stat == DEAD)
			to_chat(user, "[name] can only transform living targets.")
			continue

		if(M.mind.special_role in protected_roles)
			to_chat(user, "Your spell has no effect on them.")
			continue

		if(M.buckled)
			M.buckled.unbuckle_mob()

		var/new_mob = pick(possible_transformations)

		var/mob/living/trans = new new_mob(get_turf(M))
		for(var/varName in newVars) //stolen shamelessly from Conjure
			if(varName in trans.vars)
				trans.vars[varName] = newVars[varName]

		trans.name = "[trans.name] ([M])"
		if(istype(M,/mob/living/carbon/human) && drop_items)
			for(var/obj/item/I in M.contents)
				if(istype(I,/obj/item/organ))
					continue
				M.drop_from_inventory(I)
		if(M.mind)
			M.mind.transfer_to(trans)
		else
			trans.key = M.key
		var/atom/movable/overlay/effect = new /atom/movable/overlay(get_turf(M))
		effect.density = 0
		effect.anchored = 1
		effect.icon = 'icons/effects/effects.dmi'
		effect.layer = 3
		flick("summoning",effect)
		spawn(10)
			qdel(effect)
		if(!duration)
			qdel(M)
		else
			M.forceMove(trans) //move inside the new dude to hide him.
			M.status_flags |= GODMODE //dont want him to die or breathe or do ANYTHING
			spawn(duration)
				M.status_flags &= ~GODMODE //no more godmode.
				var/ratio = trans.health/trans.maxHealth
				if(ratio <= 0) //if he dead dont bother transforming them.
					qdel(M)
					return
				if(share_damage)
					M.adjustBruteLoss(M.maxHealth - round(M.maxHealth*(trans.health/trans.maxHealth))) //basically I want the % hp to be the same afterwards
				if(trans.mind)
					trans.mind.transfer_to(M)
				else
					M.key = trans.key
				playsound(get_turf(M),revert_sound,50,1)
				M.forceMove(get_turf(trans))
				qdel(trans)