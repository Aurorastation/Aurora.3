/datum/technomancer/spell/pulsar
	name = "Pulsar"
	desc = "Emits electronic pulses to destroy, disable, or otherwise harm devices and machines.  Be sure to not hit yourself with this."
	cost = 100
	obj_path = /obj/item/spell/spawner/pulsar
	category = OFFENSIVE_SPELLS

/obj/item/spell/spawner/pulsar
	name = "pulsar"
	desc = "Be sure to not hit yourself!"
	icon_state = "radiance"
	cast_methods = CAST_RANGED | CAST_THROW
	aspect = ASPECT_EMP
	spawner_type = /obj/effect/temporary_effect/pulse/pulsar

/obj/item/spell/spawner/pulsar/New()
	..()
	set_light(3, 2, l_color = "#2ECCFA")

/obj/item/spell/spawner/pulsar/on_ranged_cast(atom/hit_atom, mob/user)
	if(within_range(hit_atom) && pay_energy(4000))
		adjust_instability(8)
		..()

/obj/item/spell/spawner/pulsar/on_throw_cast(atom/hit_atom, mob/user)
	empulse(hit_atom, 1, 1, 1, 1, log=1)

// Does something every so often. Deletes itself when pulses_remaining hits zero.
/obj/effect/temporary_effect/pulse
	var/pulses_remaining = 3
	var/pulse_delay = 2 SECONDS

/obj/effect/temporary_effect/pulse/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/temporary_effect/pulse/LateInitialize()
	pulse_loop()

/obj/effect/temporary_effect/pulse/proc/pulse_loop()
	set waitfor = FALSE
	
	while(pulses_remaining)
		sleep(pulse_delay)
		on_pulse()
		pulses_remaining--
	qdel(src)

// Override for specific effects.
/obj/effect/temporary_effect/pulse/proc/on_pulse()



/obj/effect/temporary_effect/pulse/pulsar
	name = "pulsar"
	desc = "Not a real pulsar, but still emits loads of EMP."
	icon_state = "shield2"
	time_to_die = null
	light_range = 4
	light_power = 5
	light_color = "#2ECCFA"
	pulses_remaining = 3

/obj/effect/temporary_effect/pulse/pulsar/on_pulse()
	empulse(src, 1, 1, 2, 2, log = 1)







