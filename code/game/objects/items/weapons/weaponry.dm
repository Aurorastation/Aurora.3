/obj/item/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	throwforce = 0
	force = 0
	var/net_type = /obj/effect/energy_net

/obj/item/energy_net/dropped()
	. = ..()
	if(!QDELETED(src))
		QDEL_IN(src, 1)

/obj/item/energy_net/throw_impact(atom/hit_atom)
	..()

	var/mob/living/M = hit_atom
	if(!istype(M))
		qdel(src)
		return
	var/obj/effect/energy_net/EN = locate() in get_turf(M)
	if(EN)
		qdel(EN)

	var/turf/T = get_turf(M)
	if(T)
		var/obj/effect/energy_net/net = new net_type(T)
		net.layer = ABOVE_HUMAN_LAYER
		M.captured = TRUE
		M.update_canmove()
		net.affecting = M
		M.visible_message(SPAN_DANGER("\The [M] was caught in \the [net]!"), SPAN_DANGER("You get caught in \the [net]!"))
		qdel(src)

/obj/effect/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"

	density = TRUE
	opacity = FALSE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_ICON

	var/health = 50
	var/mob/living/affecting = null //Who it is currently affecting, if anyone.

/obj/effect/energy_net/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/effect/energy_net/Destroy()
	STOP_PROCESSING(SSprocessing, src)

	if(affecting)
		affecting.anchored = initial(affecting.anchored)
		affecting.captured = FALSE
		affecting.update_canmove()
		to_chat(affecting, SPAN_GOOD("You are free of the net!"))
		affecting = null

	return ..()

/obj/effect/energy_net/proc/health_check()
	if(health <= 0)
		density = FALSE
		src.visible_message(SPAN_WARNING("\The [src] is torn apart!"))
		qdel(src)

/obj/effect/energy_net/process()
	if(isnull(affecting) || get_turf(src) != get_turf(affecting))
		qdel(src)
		return

/obj/effect/energy_net/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	health_check()
	return FALSE

/obj/effect/energy_net/ex_act(var/severity = 2.0)
	health = 0
	health_check()

/obj/effect/energy_net/attack_hand(var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src, FIST_ATTACK_ANIMATION)
	if(user == affecting)
		to_chat(user, SPAN_WARNING("You can't claw at \the [src] while trapped inside it! You need to use a weapon."))
		return
	var/mob/living/carbon/human/H = user
	if(istype(H))
		if(H.species.can_shred(H))
			playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
			health -= rand(10, 20)
		else
			health -= rand(1, 3)
	else if ((user.mutations & HULK))
		health = 0
	else
		health -= rand(5, 8)

	user.visible_message(SPAN_WARNING("\The [user] claws at \the [src]!"), SPAN_WARNING("You claw at \the [src]!"))
	health_check()

/obj/effect/energy_net/attackby(obj/item/attacking_item, mob/user)
	user.do_attack_animation(src, attacking_item)
	var/attack_force = attacking_item.force
	if(user == affecting)
		attack_force /= 2
	health -= attack_force
	health_check()

/obj/item/canesword
	name = "thin sword"
	desc = "A thin, sharp blade with an elegant handle."
	icon = 'icons/obj/sword.dmi'
	icon_state = "canesword"
	item_state = "canesword"
	force = 25
	throwforce = 5
	w_class = ITEMSIZE_LARGE
	sharp = 1
	edge = TRUE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = /singleton/sound_category/sword_pickup_sound
	equip_sound = /singleton/sound_category/sword_equip_sound

/obj/item/banhammer
	desc = "banhammer"
	name = "banhammer"
	icon = 'icons/obj/items.dmi'
	icon_state = "toyhammer"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = ITEMSIZE_SMALL
	throw_speed = 7
	throw_range = 15
	attack_verb = list("banned")

/obj/item/banhammer/attack(mob/M as mob, mob/user as mob)
	to_chat(M, "<span class='warning'><b> You have been banned FOR NO REISIN by [user]</b></span>")
	to_chat(user, "<span class='warning'> You have <b>BANNED</b> [M]</span>")
	playsound(loc, 'sound/effects/adminhelp.ogg', 15)
