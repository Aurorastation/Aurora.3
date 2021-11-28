/datum/technomancer/spell/destabilize
	name = "Destabilize"
	desc = "Creates an unstable disturbance at the targeted tile, which will afflict anyone nearby with instability who remains nearby.  This can affect you \
	and your allies as well.  The disturbance lasts for twenty seconds."
	cost = 100
	ability_icon_state = "wiz_shield"
	obj_path = /obj/item/spell/spawner/destabilize
	category = OFFENSIVE_SPELLS

/obj/item/spell/spawner/destabilize
	name = "Destabilize"
	desc = "Now your enemies can feel what you go through when you have too much fun."
	icon_state = "destabilize"
	cast_methods = CAST_RANGED
	aspect = ASPECT_UNSTABLE
	spawner_type = /obj/effect/temporary_effect/destabilize

/obj/item/spell/spawner/destabilize/New()
	..()
	set_light(3, 2, l_color = "#C26DDE")

/obj/item/spell/spawner/destabilize/on_ranged_cast(atom/hit_atom, mob/user)
	if(within_range(hit_atom) && pay_energy(2000))
		adjust_instability(15)
		..()

/obj/effect/temporary_effect/destabilize
	name = "destablizing disturbance"
	desc = "This can't be good..."
	icon_state = "blueshatter"
	time_to_die = null
	light_range = 6
	light_power = 20
	light_color = "#C26DDE"
	var/pulses_remaining = 40 // Lasts 20 seconds.
	var/instability_power = 5
	var/instability_range = 6

/obj/effect/temporary_effect/destabilize/Initialize()
	. = ..()
	radiate_loop()

/obj/effect/temporary_effect/destabilize/proc/radiate_loop()
	set waitfor = FALSE

	while(pulses_remaining)
		sleep(5)
		for(var/mob/living/L in range(src, instability_range) )
			var/radius = max(get_dist(L, src), 1)
			// Being farther away lessens the amount of instabity received.
			var/outgoing_instability = instability_power * ( 1 / (radius**2) )
			L.receive_radiated_instability(outgoing_instability)
		pulses_remaining--
	qdel(src)