/obj/machinery/optable/adhomai
	name = "operating table"
	desc = "Hope it's sterilized..."
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "table2-idle"

/obj/item/stack/medical/bruise_pack/adhomai
	icon = 'icons/adhomai/items.dmi'
	icon_state = "brutepack"

/obj/item/stack/medical/ointment/adhomai
	icon = 'icons/adhomai/items.dmi'
	icon_state = "ointment"

/obj/item/stack/medical/advanced/ointment/adhomai
	icon = 'icons/adhomai/items.dmi'
	icon_state = "burnkit"

/obj/item/stack/medical/advanced/bruise_pack/adhomai
	icon = 'icons/adhomai/items.dmi'
	icon_state = "traumakit"

/obj/item/weapon/grenade/frag/nka
	icon = 'icons/adhomai/items.dmi'
	icon_state = "frag"

/obj/item/weapon/grenade/smokebomb/nka
	icon = 'icons/adhomai/items.dmi'
	icon_state = "smoke"

/obj/item/weapon/storage/firstaid/regular/adhomai
	icon = 'icons/adhomai/items.dmi'
	icon_state = "firstaid"

/obj/item/weapon/storage/firstaid/regular/adhomai/fill()
	new /obj/item/stack/medical/bruise_pack/adhomai(src)
	new /obj/item/stack/medical/bruise_pack/adhomai(src)
	new /obj/item/stack/medical/bruise_pack/adhomai(src)
	new /obj/item/stack/medical/ointment/adhomai(src)
	new /obj/item/stack/medical/ointment/adhomai(src)
	return

/obj/structure/siren
	name = "air raid siren"
	desc = "Rotate it to sound the alarm."
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "siren"
	layer = MOB_LAYER + 1
	anchored = TRUE
	density = TRUE
	var/cooldown = FALSE
	var/health = 270
	var/maxhealth = 270


/obj/structure/siren/attack_hand(mob/user)
	if ((cooldown < world.time - 1200) || (world.time < 1200))
		to_chat(user, "<span class='notice'>You turn the [src], creating an ear-splitting noise!</span>")
		playsound(user, 'sound/misc/siren.ogg', 100, TRUE)
		cooldown = world.time
	return //It's just a loudspeaker

/obj/structure/window_frame
	desc = "A good old window frame."
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "windownew_frame"
	layer = MOB_LAYER + 0.01
	anchored = TRUE

/obj/structure/window_frame/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/stack/material/glass))
		var/obj/item/stack/S = W
		if (S.amount >= 3)
			visible_message("<span class = 'notice'>[user] starts to add glass to the window frame...</span>")
			if (do_after(user, 50, src))
				new/obj/structure/window/classic(get_turf(src))
				visible_message("<span class = 'notice'>[user] adds glass to the window frame.</span>")
				S.use(3)
				qdel(src)
		else
			to_chat(user, "<span class = 'warning'>You need at least 3 sheets of glass.</span>")

/obj/structure/window/classic
	desc = "A good old window."
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "windownew"
	basestate = "windownew"
	glasstype = /obj/item/stack/material/glass
	maximal_heat = T0C + 100
	damage_per_fire_tick = 5.0
	maxhealth = 20.0
	layer = MOB_LAYER + 0.02

/obj/structure/window/classic/reinforced
	reinf = TRUE

/obj/structure/window/classic/is_full_window()
	return TRUE

/obj/structure/window/classic/take_damage(damage)
	if (damage > 12 || (damage > 5 && prob(damage * 5)))
		if (!reinf || (reinf && prob(20)))
			shatter()
	else return

/obj/structure/window/classic/hitby(AM as mob|obj)
	..()
	visible_message("<span class='danger'>[src] was hit by [AM].</span>")
	var/tforce = FALSE
	if (ismob(AM))
		tforce = 40
	else if (isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	if (reinf) tforce *= 0.25
	take_damage(tforce)

/obj/structure/window/classic/bullet_act(var/obj/item/projectile/P)
	if (!P || !P.nodamage)
		shatter()
		return PROJECTILE_CONTINUE

/obj/structure/window/classic/shatter(var/display_message = TRUE)
	var/myturf = get_turf(src)
	spawn new/obj/structure/window_frame(myturf)
	..(display_message)

/obj/structure/window/classic/update_icon()
	return

/obj/structure/window/classic/update_nearby_icons()
	return

/obj/machinery/media/jukebox/record
	name = "record player"
	desc = "Play that funky music..."
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "record"
	state_base = "record"

	anchored = 1

/obj/machinery/media/jukebox/record/update_icon()
	cut_overlays()
	icon_state = state_base
	if(playing)
		add_overlay("[state_base]-running")