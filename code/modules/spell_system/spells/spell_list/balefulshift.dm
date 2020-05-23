//basic transformation spell. Should work for most simple_animals

/spell/targeted/shapeshift
	name = "Shapeshift"
	desc = "This spell transforms the target into something else for a short while."

	school = "transmutation"

	charge_type = Sp_RECHARGE
	charge_max = 600

	duration = 0 //set to 0 for permanent.

	var/list/normal_transformations = list()
	var/list/big_transformations = list()
	var/list/newVars = list() //what the variables of the new created thing will be.

	cast_sound = 'sound/weapons/emitter2.ogg'
	var/revert_sound = 'sound/weapons/emitter.ogg' //the sound that plays when something gets turned back.
	var/share_damage = 1 //do we want the damage we take from our new form to move onto our real one? (Only counts for finite duration)
	var/drop_items = 1 //do we want to drop all our items when we transform?
	var/list/protected_roles = list() //which roles are immune to the spell

/mob/living
	var/datum/weakref/polymorph_origin

/proc/badpolymorph(mob/living/M, mob/user, share_damage = 1, drop_items = 0, revert_sound = 'sound/weapons/emitter.ogg', list/normal_transformations = list(), list/big_transformations = list(), duration = 0, list/newVars = list())
	if(M.buckled)
		M.buckled.unbuckle_mob()

	if (M.polymorph_origin)
		var/mob/living/origin = M.polymorph_origin.resolve()
		if (!origin)
			log_debug("shapeshift: target mob's origin no longer exists (deleted?), ignoring.")
			return

		origin.unshapeshift_from(M, revert_sound, share_damage)
		return
	var/new_mob = pick(prob(85) ? normal_transformations : big_transformations)
	var/mob/living/trans = new new_mob(get_turf(M))
	trans.polymorph_origin = WEAKREF(M)
	for(var/varName in newVars) 
		if(varName in trans.vars)
			trans.vars[varName] = newVars[varName]

	trans.name = "[trans.name]"
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
	QDEL_IN(effect, 10)
	if(!duration)
		qdel(M)
	else
		M.forceMove(trans) //move inside the new dude to hide him.
		M.status_flags |= GODMODE //dont want him to die or breathe or do ANYTHING
		addtimer(CALLBACK(M, /mob/living/.proc/unshapeshift_from, trans, revert_sound, share_damage), duration)

	if(trans)
		trans.post_transformation_prompt()

/mob/living/proc/post_transformation_prompt()
	to_chat(src, span("warning", "You feel brief pain as your body twists and shifts into a new shape, but quickly forget as your mind is locked away. You cannot remember your former life now, and your mind has become like that of \a [src]."))

/mob/living/simple_animal/hostile/faithless/wizard/post_transformation_prompt()
	to_chat(src, span("warning", "Your body shifts and becomes corrupted with dark energies as you take on a more nightmarish form..."))

/spell/targeted/shapeshift/cast(var/list/targets, mob/user)
	for(var/mob/living/M in targets)
		if (M.mind && M.mind.special_role in protected_roles)
			to_chat(user, "You can't shapeshift [M].")
			continue
		badpolymorph(M, user, share_damage, drop_items, revert_sound, normal_transformations, big_transformations, duration, newVars)
		
/mob/living/proc/unshapeshift_from(mob/living/holder_mob, revert_sound, share_damage)
	if (QDELETED(holder_mob))
		log_debug("unshapeshift_from: holder mob was already deleted, aborting")
		return

	status_flags &= ~GODMODE //no more godmode.
	var/ratio = holder_mob.health / holder_mob.maxHealth
	if(ratio <= 0) //if he dead dont bother transforming them.
		qdel(src)
		return
	if(share_damage)
		adjustBruteLoss(maxHealth - round(maxHealth * (holder_mob.health / holder_mob.maxHealth))) //basically I want the % hp to be the same afterwards
	if(holder_mob.mind)
		holder_mob.mind.transfer_to(src)
	else
		key = holder_mob.key
	src.untransform_prompt()
	playsound(get_turf(src), revert_sound, 50, 1)
	forceMove(get_turf(holder_mob))
	qdel(holder_mob)

/mob/living/proc/untransform_prompt(mob/holder_mob)
	to_chat(src, span("notice", "You suddenly find yourself a sapient being again, with vague memories of being \a [holder_mob] for a time."))

/mob/living/simple_animal/hostile/faithless/wizard/untransform_prompt()
	to_chat(src, span("notice", "You return to your normal form.")) 
