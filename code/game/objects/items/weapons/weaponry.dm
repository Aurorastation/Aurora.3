/obj/item/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	throwforce = 0
	force = 0
	var/net_type = /obj/effect/energy_net

/obj/item/energy_net/dropped()
	spawn(10)
		if(src) qdel(src)

/obj/item/energy_net/throw_impact(atom/hit_atom)
	..()

	var/mob/living/M = hit_atom

	if(!istype(M) || locate(/obj/effect/energy_net) in M.loc)
		qdel(src)
		return 0

	var/turf/T = get_turf(M)
	if(T)
		var/obj/effect/energy_net/net = new net_type(T)
		net.layer = M.layer+1
		M.captured = 1
		net.affecting = M
		T.visible_message("[M] was caught in an energy net!")
		qdel(src)

	// If we miss or hit an obstacle, we still want to delete the net.
	spawn(10)
		if(src) qdel(src)

/obj/effect/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"

	density = 1
	opacity = 0
	mouse_opacity = 1
	anchored = 1

	var/health = 25
	var/mob/living/affecting = null //Who it is currently affecting, if anyone.
	var/mob/living/master = null    //Who shot web. Will let this person know if the net was successful.
	var/countdown = -1

/obj/effect/energy_net/teleport
	countdown = 60

/obj/effect/energy_net/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/effect/energy_net/Destroy()

	if(affecting)
		var/mob/living/carbon/M = affecting
		M.anchored = initial(affecting.anchored)
		M.captured = 0
		to_chat(M, "You are free of the net!")

	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/energy_net/proc/healthcheck()

	if(health <=0)
		density = 0
		src.visible_message("The energy net is torn apart!")
		qdel(src)
	return

/obj/effect/energy_net/process()

	if(isnull(affecting) || affecting.loc != loc)
		qdel(src)
		return

	// Countdown begin set to -1 will stop the teleporter from firing.
	// Clientless mobs can be netted but they will not teleport or decrement the timer.
	var/mob/living/M = affecting
	if(countdown == -1 || (istype(M) && !M.client))
		return

	if(countdown > 0)
		countdown--
		return

	// TODO: consider removing or altering this; energy nets are useful on their own
	// merits and the teleportation was never properly implemented; it's halfassed.
	density = 0
	invisibility = 101 //Make the net invisible so all the animations can play out.
	health = INFINITY  //Make the net invincible so that an explosion/something else won't kill it during anims.

	playsound(affecting.loc, 'sound/effects/sparks4.ogg', 50, 1)
	anim(affecting.loc,affecting,'icons/mob/mob.dmi',,"phaseout",,affecting.dir)

	affecting.visible_message("[affecting] vanishes in a flare of light!")

	if(holdingfacility.len)
		affecting.forceMove(pick(holdingfacility))

	to_chat(affecting, "You appear in a strange place!")

	playsound(affecting.loc, 'sound/effects/phasein.ogg', 25, 1)
	playsound(affecting.loc, 'sound/effects/sparks2.ogg', 50, 1)
	anim(affecting.loc,affecting,'icons/mob/mob.dmi',,"phasein",,affecting.dir)

	qdel(src)

/obj/effect/energy_net/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	healthcheck()
	return 0

/obj/effect/energy_net/ex_act(var/severity = 2.0)
	health = 0
	healthcheck()

/obj/effect/energy_net/attack_hand(var/mob/user)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/mob/living/carbon/human/H = user
	if(istype(H))
		if(H.species.can_shred(H))
			playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
			health -= rand(10, 20)
		else
			health -= rand(1,3)

	else if (HULK in user.mutations)
		health = 0
	else
		health -= rand(5,8)

	to_chat(H, "<span class='danger'>You claw at the energy net.</span>")

	healthcheck()
	return

/obj/effect/energy_net/attackby(obj/item/W as obj, mob/user as mob)
	health -= W.force
	healthcheck()
	..()

/obj/item/canesword
	name = "thin sword"
	desc = "A thin, sharp blade with an elegant handle."
	icon = 'icons/obj/sword.dmi'
	icon_state = "canesword"
	item_state = "canesword"
	force = 20
	throwforce = 5
	w_class = 4
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'

/obj/item/sord
	name = "\improper SORD"
	desc = "This thing is so unspeakably shitty you are having a hard time even holding it."
	icon = 'icons/obj/sword.dmi'
	icon_state = "sord"
	item_state = "sord"
	slot_flags = SLOT_BELT
	force = 2
	throwforce = 1
	sharp = 1
	edge = 1
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

/obj/item/banhammer
	desc = "banhammer"
	name = "banhammer"
	icon = 'icons/obj/items.dmi'
	icon_state = "toyhammer"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = 2.0
	throw_speed = 7
	throw_range = 15
	attack_verb = list("banned")

/obj/item/banhammer/attack(mob/M as mob, mob/user as mob)
	to_chat(M, "<font color='red'><b> You have been banned FOR NO REISIN by [user]</b></font>")
	to_chat(user, "<font color='red'> You have <b>BANNED</b> [M]</font>")
	playsound(loc, 'sound/effects/adminhelp.ogg', 15)
