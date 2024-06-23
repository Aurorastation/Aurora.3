/datum/technomancer/spell/abjuration
	name = "Abjuration"
	desc = "This ability attempts to send summoned or teleported entities or anomalies to the place from whence they came, or at least \
	far away from the caster.  Failing that, it may inhibit those entities in some form."
	cost = 25
	ability_icon_state = "wiz_jaunt"
	obj_path = /obj/item/spell/abjuration
	category = UTILITY_SPELLS

/obj/item/spell/abjuration
	name = "abjuration"
	desc = "Useful for unruly minions, hostile summoners, or for fighting the horrors that may await you with your hubris."
	icon_state = "generic"
	cast_methods = CAST_RANGED
	aspect = ASPECT_TELE

/obj/item/spell/abjuration/on_ranged_cast(atom/hit_atom, mob/user)
	. = ..()
	if(istype(hit_atom, /mob/living) && pay_energy(500) && within_range(hit_atom))
		var/mob/living/L = hit_atom
		var/mob/living/simple_animal/SM = null

		//Bit of a roundabout typecheck, in order to test for two variables from two different mob types in one line.
		if(istype(L, /mob/living/simple_animal))
			SM = L
		if(L.summoned || (SM && SM.supernatural))
			if(L.client) // Player-controlled mobs are immune to being killed by this.
				to_chat(user, SPAN_WARNING("\The [L] resists your attempt to banish it!"))
				to_chat(L, SPAN_WARNING("\The [user] tried to teleport you far away, but failed."))
				return 0
			else
				visible_message(SPAN_NOTICE("\The [L] vanishes!"))
				qdel(L)
		else if(istype(L, /mob/living/simple_animal/construct))
			var/mob/living/simple_animal/construct/evil = L
			to_chat(evil, SPAN_DANGER("\The [user]'s abjuration purges your form!"))
			evil.purge = 3
		adjust_instability(5)
	// In case NarNar comes back someday.
	if(istype(hit_atom, /obj/singularity/narsie))
		to_chat(user, SPAN_DANGER("One does not simply abjurate Nar'sie away."))
		adjust_instability(200)
