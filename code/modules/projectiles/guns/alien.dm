
	name = "spike thrower"

	var/last_regen = 0
	var/spike_gen_time = 100
	var/max_spikes = 3
	var/spikes = 3
	release_force = 30
	icon = 'icons/obj/gun.dmi'
	icon_state = "spikethrower3"
	item_state = "spikethrower"
	fire_sound_text = "a strange noise"

	. = ..()
	last_regen = world.time

	return ..()

	if(spikes < max_spikes && world.time > last_regen + spike_gen_time)
		spikes++
		last_regen = world.time
		update_icon()

	spikes++
	update_icon()
	if (spikes < max_spikes)
		addtimer(CALLBACK(src, .proc/regen_spike), spike_gen_time, TIMER_UNIQUE)

	..(user)
	user << "It has [spikes] spike\s remaining."

	icon_state = "spikethrower[spikes]"

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species && H.species.name != "Vox" && H.species.name != "Vox Armalis")
			user << "<span class='warning'>\The [src] does not respond to you!</span>"
			return 0
	return ..()

	return

	if(spikes < 1) return null
	spikes--
	addtimer(CALLBACK(src, .proc/regen_spike), spike_gen_time, TIMER_UNIQUE)

//This gun only functions for armalis. The on-sprite is too huge to render properly on other sprites.
	name = "alien heavy cannon"

	icon = 'icons/obj/gun.dmi' //Actual on-sprite is handled by icon_override.
	icon_state = "noisecannon"
	item_state = "noisecannon"
	recoil = 1

	force = 10
	projectile_type = /obj/item/projectile/energy/sonic
	fire_delay = 40
	fire_sound = 'sound/effects/basscannon.ogg'

	var/mode = 1

	sprite_sheets = list(
		"Vox Armalis" = 'icons/mob/species/armalis/held.dmi'
		)

	if(loc != user)
		var/mob/living/carbon/human/H = user
		if(istype(H))
			if(H.species.name == "Vox Armalis")
				..()
				return
		user << "<span class='warning'>\The [src] is far too large for you to pick up.</span>"
		return

	return

//Projectile.
/obj/item/projectile/energy/sonic
	name = "distortion"
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	icon_state = "particle"
	damage = 60
	damage_type = BRUTE
	check_armour = "bullet"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE

	embed = 0
	weaken = 5
	stun = 5
