/datum/technomancer/spell/energy_siphon
	name = "Energy Siphon"
	desc = "This creates a link to a target that drains electricity, converts it to energy that the Core can use, then absorbs it.  \
	Every second, electricity is stolen until the link is broken by the target moving too far away, or having no more energy left.  \
	Can drain from powercells, microbatteries, and other Cores.  The beam created by the siphoning is harmful to touch."
	enhancement_desc = "Rate of siphoning is doubled."
	spell_power_desc = "Rate of siphoning is scaled up based on spell power."
	cost = 100
	obj_path = /obj/item/spell/energy_siphon
	ability_icon_state = "tech_energysiphon"
	category = UTILITY_SPELLS

/obj/item/spell/energy_siphon
	name = "energy siphon"
	desc = "Now you are an energy vampire."
	icon_state = "energy_siphon"
	cast_methods = CAST_RANGED
	aspect = ASPECT_SHOCK
	var/atom/movable/siphoning = null // What the spell is currently draining.  Does nothing if null.
	var/list/things_to_siphon = list() //Things which are actually drained as a result of the above not being null.
	var/flow_rate = 1000 // Limits how much electricity can be drained per second.  Measured by default in god knows what.

/obj/item/spell/energy_siphon/New()
	..()
	START_PROCESSING(SSprocessing, src)

/obj/item/spell/energy_siphon/Destroy()
	stop_siphoning()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/spell/energy_siphon/process()
	if(!siphoning)
		return
	if(!pay_energy(100))
		to_chat(owner, "<span class='warning'>You can't afford to maintain the siphon link!</span>")
		stop_siphoning()
		return
	if(get_dist(siphoning, get_turf(src)) > 4)
		to_chat(owner, "<span class='warning'>\The [siphoning] is too far to drain from!</span>")
		stop_siphoning()
		return
	if(!(siphoning in view(owner)))
		to_chat(owner, "<span class='warning'>\The [siphoning] cannot be seen!</span>")
		stop_siphoning()
		return
	siphon(siphoning, owner)



/obj/item/spell/energy_siphon/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /atom/movable) && within_range(hit_atom, 4))
		var/atom/movable/AM = hit_atom
		populate_siphon_list(AM)
		if(!things_to_siphon.len)
			to_chat(user, "<span class='warning'>You cannot steal energy from \a [AM].</span>")
			return 0
		siphoning = AM
		update_icon()
		log_and_message_admins("is siphoning energy from \a [AM].")
	else
		stop_siphoning()

/obj/item/spell/energy_siphon/proc/populate_siphon_list(atom/movable/target) 
	things_to_siphon.Cut()
	things_to_siphon |= target.GetAllContents()
	for(var/atom/movable/AM in things_to_siphon)
		if(ishuman(AM)) // We can drain FBPs, so we can skip the test below.
			var/mob/living/carbon/human/H = AM
			if(H.isSynthetic())
				continue
		if(AM.drain_power(1) <= 0) // This checks if whatever's in the list can be drained from.
			things_to_siphon.Remove(AM)

/obj/item/spell/energy_siphon/proc/stop_siphoning()
	siphoning = null
	things_to_siphon.Cut()
	update_icon()

#define SIPHON_CELL_TO_ENERGY	0.5
#define SIPHON_FBP_TO_ENERGY	5.0
#define SIPHON_CORE_TO_ENERGY	0.5

// This is called every tick, so long as a link exists between the target and the Technomancer.
/obj/item/spell/energy_siphon/proc/siphon(atom/movable/siphoning, mob/living/user)
	var/list/things_to_drain = things_to_siphon // Temporary list copy of what we're gonna steal from.
	var/charge_to_give = 0 // How much energy to give to the Technomancer at the end.
	var/flow_remaining = calculate_spell_power(flow_rate)

	if(!siphoning)
		return 0

	update_icon()

	//playsound(source = src, soundin = 'TODO', vol = 30, vary = 0, extrarange = 0, falloff = 0, is_global = 0)

	if(check_for_scepter())
		flow_remaining = flow_remaining * 2

	// First, we drain normal batteries.
	if(things_to_drain.len)
		// Don't bother with empty stuff.
		for(var/atom/movable/AM in things_to_drain)
			if(AM.drain_power(1) <= 0)
				things_to_drain.Remove(AM)
		if(!things_to_drain.len)
			return
		var/charge_to_steal = round(flow_remaining / things_to_drain.len) // This is to drain all the cells evenly.
		for(var/atom/movable/AM in things_to_drain)
			var/big_number = AM.drain_power(0,0,charge_to_steal / CELLRATE) // This drains the cell, and leaves us with a big number.
			flow_remaining = flow_remaining - (big_number * CELLRATE) // Which we reduce to our needed number by multiplying.
			AM.update_icon() // So guns and batteries will display correctly.
		charge_to_give = charge_to_give + (flow_rate - flow_remaining) * SIPHON_CELL_TO_ENERGY
	// If we have 'leftover' flow, let's try to do more.
	if(round(flow_remaining))
		if(ishuman(siphoning))
			var/mob/living/carbon/human/H = siphoning
			// Let's drain from FBPs.  Note that it is possible for the caster to drain themselves if they are an FBP and desperate.
			if(H.isSynthetic())
				var/nutrition_to_steal = flow_remaining * 0.025 // Should steal about 25 nutrition per second by default.
				var/old_nutrition = H.nutrition
				H.nutrition = max(H.nutrition - nutrition_to_steal, 0)
				var/nutrition_delta = old_nutrition - H.nutrition
				charge_to_give += nutrition_delta * SIPHON_FBP_TO_ENERGY
				flow_remaining = flow_remaining - nutrition_to_steal / 0.025
			// Let's steal some energy from another Technomancer.
			if(istype(H.back, /obj/item/technomancer_core) && H != user)
				var/obj/item/technomancer_core/their_core = H.back
				if(their_core.pay_energy(flow_remaining / 2)) // Don't give energy from nothing.
					charge_to_give += flow_remaining * SIPHON_CORE_TO_ENERGY
					flow_remaining = 0

	if(charge_to_give) // Shock anyone standing in the beam.
		create_lightning(user, siphoning)

	// Now we can actually fill up the core.
	if(core.energy < core.max_energy)
		give_energy(charge_to_give)
		to_chat(user, "<span class='notice'>Stolen [charge_to_give * CELLRATE] kJ and converted to [charge_to_give] Core energy.</span>")
		if((core.max_energy - core.energy) < charge_to_give ) // We have some overflow, if this is true.
			if(user.isSynthetic() && ishuman(user)) // Let's do something with it, if we're a robot.
				var/mob/living/carbon/human/H = user
				charge_to_give = charge_to_give - (core.max_energy - core.energy)
				var/obj/item/organ/internal/cell/C = H.internal_organs_by_name[BP_CELL]
				var/obj/item/cell/potato = C.get_cell()
				potato.give(charge_to_give)
				to_chat(user, "<span class='notice'>Redirected energy to internal microcell.</span>")
	else
		to_chat(user, "<span class='notice'>Stolen [charge_to_give * CELLRATE] kJ.</span>")
	adjust_instability(2)

	if(flow_remaining == flow_rate) // We didn't drain anything.
		to_chat(user, "<span class='warning'>\The [siphoning] cannot be drained any further.</span>")
		stop_siphoning()

/obj/item/spell/energy_siphon/update_icon()
	..()
	if(siphoning)
		icon_state = "energy_siphon_drain"
	else
		icon_state = "energy_siphon"

/obj/item/spell/energy_siphon/proc/create_lightning(mob/user, atom/source)
	if(user && source && user != source)
		spawn(0)
			var/i = 7 // process() takes two seconds to tick, this ensures the appearance of a ongoing beam.
			while(i)
				var/obj/item/projectile/beam/lightning/energy_siphon/lightning = new(get_turf(source))
				lightning.firer = user
				lightning.old_style_target(user)
				lightning.fire()
				i--
				sleep(3)

/obj/item/projectile/beam/lightning/energy_siphon
	name = "energy stream"
	icon_state = "lightning"
	range = 6 // Backup plan in-case the effect somehow misses the Technomancer.
	power = 5 // This fires really fast, so this may add up if someone keeps standing in the beam.
	penetrating = 5

/obj/item/projectile/beam/lightning/energy_siphon/Bump(atom/A as mob|obj|turf|area, forced=0)
	if(A == firer) // For this, you CAN shoot yourself.
		on_impact(A)

		density = 0
		invisibility = 101

		qdel(src)
		return 1
	..()

/obj/item/projectile/beam/lightning/energy_siphon/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)
	if(target_mob == firer) // This shouldn't actually occur due to Bump(), but just in-case.
		return 1
	if(ishuman(target_mob)) // Otherwise someone else stood in the beam and is going to pay for it.
		var/mob/living/carbon/human/H = target_mob
		var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_CHEST))
		H.electrocute_act(power, src, H.get_siemens_coefficient_organ(affected), BP_CHEST, 0)
	else
		target_mob.electrocute_act(power, src, 0.75, BP_CHEST)
	return 0 // Since this is a continous beam, it needs to keep flying until it hits the Technomancer.


#undef SIPHON_CELL_TO_ENERGY
#undef SIPHON_FBP_TO_ENERGY
#undef SIPHON_CORE_TO_ENERGY
