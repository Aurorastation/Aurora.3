//Vox pinning weapon.
/obj/item/gun/launcher/spikethrower

	name = "spike thrower"
	desc = "A vicious alien projectile weapon. Parts of it quiver gelatinously, as though the thing is insectile and alive."

	var/last_regen = 0
	var/spike_gen_time = 100
	var/max_spikes = 3
	var/spikes = 3
	release_force = 30
	slot_flags = SLOT_BELT|SLOT_BACK
	icon = 'icons/obj/guns/spikethrower.dmi'
	icon_state = "spikethrower3"
	item_state = "spikethrower"
	fire_sound_text = "a strange noise"
	fire_sound = 'sound/weapons/bladeslice.ogg'
	needspin = FALSE

/obj/item/gun/launcher/spikethrower/Initialize()
	. = ..()
	last_regen = world.time

/obj/item/gun/launcher/spikethrower/Destroy()
	return ..()

/obj/item/gun/launcher/spikethrower/process()
	if(spikes < max_spikes && world.time > last_regen + spike_gen_time)
		spikes++
		last_regen = world.time
		update_icon()

/obj/item/gun/launcher/spikethrower/proc/regen_spike()
	spikes++
	update_icon()
	if (spikes < max_spikes)
		addtimer(CALLBACK(src, .proc/regen_spike), spike_gen_time, TIMER_UNIQUE)

/obj/item/gun/launcher/spikethrower/examine(mob/user)
	..(user)
	if(get_dist(src, user) > 1)
		return
	to_chat(user, "It has [spikes] spike\s remaining.")

/obj/item/gun/launcher/spikethrower/update_icon()
	icon_state = "spikethrower[spikes]"

/obj/item/gun/launcher/spikethrower/special_check(user)
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species && H.species.name != "Vox" && H.species.name != "Vox Armalis")
			to_chat(user, "<span class='warning'>\The [src] does not respond to you!</span>")
			return 0
	return ..()

/obj/item/gun/launcher/spikethrower/update_release_force()
	return

/obj/item/gun/launcher/spikethrower/consume_next_projectile()
	if(spikes < 1) return null
	spikes--
	addtimer(CALLBACK(src, .proc/regen_spike), spike_gen_time, TIMER_UNIQUE)
	return new /obj/item/spike(src)

//This gun only functions for armalis. The on-sprite is too huge to render properly on other sprites.
/obj/item/gun/energy/noisecannon
	name = "alien heavy cannon"
	desc = "It's some kind of enormous alien weapon, as long as a man is tall."

	icon = 'icons/obj/guns/noisecannon.dmi'
	icon_state = "noisecannon"
	item_state = "noisecannon"
	recoil = 1

	force = 10
	projectile_type = /obj/item/projectile/energy/sonic
	cell_type = /obj/item/cell/super
	fire_delay = 40
	fire_sound = 'sound/effects/basscannon.ogg'
	needspin = FALSE

	var/mode = 1

	sprite_sheets = list(
		"Vox Armalis" = 'icons/mob/species/armalis/held.dmi'
		)

/obj/item/gun/energy/noisecannon/attack_hand(mob/user as mob)
	if(loc != user)
		var/mob/living/carbon/human/H = user
		if(istype(H))
			if(H.species.name == "Vox Armalis")
				..()
				return
		to_chat(user, "<span class='warning'>\The [src] is far too large for you to pick up.</span>")
		return

/obj/item/gun/energy/noisecannon/update_icon()
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
