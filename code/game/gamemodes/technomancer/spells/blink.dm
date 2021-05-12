/datum/technomancer/spell/blink
	name = "Blink"
	desc = "Force the target to teleport a short distance away.  This target could be anything from something lying on the ground, \
	to someone trying to fight you, or even yourself.  Using this on someone next to you makes their potential distance after \
	teleportation greater.  Self casting has the greatest potential for distance, as well as the cheapest cost."
	enhancement_desc = "Blink distance is increased greatly."
	spell_power_desc = "Blink distance is scaled up with more spell power."
	cost = 50
	obj_path = /obj/item/spell/blink
	ability_icon_state = "tech_blink"
	category = UTILITY_SPELLS

/obj/item/spell/blink
	name = "blink"
	desc = "Teleports you or someone else a short distance away."
	icon_state = "blink"
	cast_methods = CAST_RANGED | CAST_MELEE | CAST_USE
	aspect = ASPECT_TELE

/proc/safe_blink(atom/movable/AM, var/range = 3)
	if(AM.anchored || !AM.loc)
		return
	var/list/targets = list()

	for(var/turf/simulated/T in range(AM, range))
		if(T.density || istype(T, /turf/simulated/mineral)) //Don't blink to vacuum or a wall
			continue
		for(var/atom/movable/stuff in T.contents)
			if(stuff.density)
				continue
		targets.Add(T)

	if(!targets.len)
		return
	var/turf/simulated/destination = null

	destination = pick(targets)

	if(destination)
		if(ismob(AM))
			var/mob/living/L = AM
			if(L.buckled_to)
				L.buckled_to.unbuckle()
		spark(AM, 5, 2)
		AM.forceMove(destination)
		AM.visible_message("<span class='notice'>\The [AM] vanishes!</span>")
		to_chat(AM, "<span class='notice'>You suddenly appear somewhere else!</span>")
	return

/obj/item/spell/blink/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /atom/movable))
		var/atom/movable/AM = hit_atom
		if(!within_range(AM))
			to_chat(user, "<span class='warning'>\The [AM] is too far away to blink.</span>")
			return
		if(!allowed_to_teleport())
			to_chat(user, "<span class='warning'>Teleportation doesn't seem to work here.</span>")
			return
		if(pay_energy(400))
			if(check_for_scepter())
				safe_blink(AM, calculate_spell_power(6))
			else
				safe_blink(AM, calculate_spell_power(3))
			adjust_instability(3)
			log_and_message_admins("has blinked [AM] away.")
		else
			to_chat(user, "<span class='warning'>You need more energy to blink [AM] away!</span>")

/obj/item/spell/blink/on_use_cast(mob/user)
	if(!allowed_to_teleport())
		to_chat(user, "<span class='warning'>Teleportation doesn't seem to work here.</span>")
		return
	if(pay_energy(200))
		if(check_for_scepter())
			safe_blink(user, calculate_spell_power(10))
		else
			safe_blink(user, calculate_spell_power(6))
		adjust_instability(1)
		log_and_message_admins("has blinked themselves away.")
	else
		to_chat(user, "<span class='warning'>You need more energy to blink yourself away!</span>")

/obj/item/spell/blink/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(istype(hit_atom, /atom/movable))
		var/atom/movable/AM = hit_atom
		if(!allowed_to_teleport())
			to_chat(user, "<span class='warning'>Teleportation doesn't seem to work here.</span>")
			return
		if(pay_energy(300))
			visible_message("<span class='danger'>\The [user] reaches out towards \the [AM] with a glowing hand.</span>")
			if(check_for_scepter())
				safe_blink(AM, 10)
			else
				safe_blink(AM, 6)
			adjust_instability(2)
			log_and_message_admins("has blinked [AM] away.")
		else
			to_chat(user, "<span class='warning'>You need more energy to blink [AM] away!</span>")