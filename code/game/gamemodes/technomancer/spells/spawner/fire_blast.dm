/datum/technomancer/spell/fire_blast
	name = "Fire Blast"
	desc = "Causes a disturbance on a targeted tile.  After two and a half seconds, it will explode in a small radius around it.  Be \
	sure to not be close to the disturbance yourself."
	cost = 175
	obj_path = /obj/item/spell/spawner/fire_blast
	category = OFFENSIVE_SPELLS

/obj/item/spell/spawner/fire_blast
	name = "fire blast"
	desc = "Leading your booms might be needed."
	icon_state = "fire_blast"
	cast_methods = CAST_RANGED
	aspect = ASPECT_FIRE
	spawner_type = /obj/effect/temporary_effect/fire_blast

/obj/item/spell/spawner/fire_blast/on_ranged_cast(atom/hit_atom, mob/user)
	if(within_range(hit_atom) && pay_energy(2000))
		adjust_instability(12)
		..() // Makes the booms happen.

/obj/effect/temporary_effect/fire_blast
	name = "fire blast"
	desc = "Run!"
	icon_state = "at_shield1"
	time_to_die = 2.5 SECONDS // After which we go boom.
	light_range = 4
	light_power = 5
	light_color = "#FF6A00"

/obj/effect/temporary_effect/fire_blast/Destroy()
	explosion(get_turf(src), -1, 1, 2, 5, adminlog = 1)
	..()