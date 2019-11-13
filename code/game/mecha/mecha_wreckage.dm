///////////////////////////////////
////////  Mecha wreckage   ////////
///////////////////////////////////


/obj/effect/decal/mecha_wreckage
	name = "Exosuit wreckage"
	desc = "Remains of some unfortunate mecha. Completely unrepairable."
	icon = 'icons/mecha/mecha.dmi'
	density = 1
	anchored = 0
	opacity = 0
	var/list/welder_salvage = list(/obj/item/stack/material/plasteel,/obj/item/stack/material/steel,/obj/item/stack/rods)
	var/list/wirecutters_salvage = list(/obj/item/stack/cable_coil)
	var/list/crowbar_salvage
	var/salvage_num = 5

/obj/effect/decal/mecha_wreckage/New()
	..()
	crowbar_salvage = new
	return

/obj/effect/decal/mecha_wreckage/ex_act(severity)
	if(severity < 2)
		spawn
			qdel(src)
	return

/obj/effect/decal/mecha_wreckage/bullet_act(var/obj/item/projectile/Proj)
	return


/obj/effect/decal/mecha_wreckage/attackby(obj/item/W as obj, mob/user as mob)
	if(W.iswelder())
		var/obj/item/weldingtool/WT = W
		if(salvage_num <= 0)
			to_chat(user, "You don't see anything that can be cut with [W].")
			return
		if (!isemptylist(welder_salvage) && WT.remove_fuel(0,user))
			var/type = prob(70)?pick(welder_salvage):null
			if(type)
				var/N = new type(get_turf(user))
				user.visible_message("[user] cuts [N] from [src]", "You cut [N] from [src]", "You hear a sound of welder nearby")
				if(istype(N, /obj/item/mecha_parts/part))
					welder_salvage -= type
				salvage_num--
			else
				to_chat(user, "You failed to salvage anything valuable from [src].")
		else
			to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
			return
	if(W.iswirecutter())
		if(salvage_num <= 0)
			to_chat(user, "You don't see anything that can be cut with [W].")
			return
		else if(!isemptylist(wirecutters_salvage))
			var/type = prob(70)?pick(wirecutters_salvage):null
			if(type)
				var/N = new type(get_turf(user))
				user.visible_message("[user] cuts [N] from [src].", "You cut [N] from [src].")
				salvage_num--
			else
				to_chat(user, "You failed to salvage anything valuable from [src].")
	if(W.iscrowbar())
		if(!isemptylist(crowbar_salvage))
			var/obj/S = pick(crowbar_salvage)
			if(S)
				S.forceMove(get_turf(user))
				crowbar_salvage -= S
				user.visible_message("[user] pries [S] from [src].", "You pry [S] from [src].")
			return
		else
			to_chat(user, "You don't see anything that can be pried with [W].")
	else
		..()
	return


/obj/effect/decal/mecha_wreckage/gygax
	name = "Gygax wreckage"
	icon_state = "gygax-broken"

/obj/effect/decal/mecha_wreckage/gygax/New()
	..()
	var/list/parts = list(/obj/item/mecha_parts/part/gygax_torso,
								/obj/item/mecha_parts/part/gygax_head,
								/obj/item/mecha_parts/part/gygax_left_arm,
								/obj/item/mecha_parts/part/gygax_right_arm,
								/obj/item/mecha_parts/part/gygax_left_leg,
								/obj/item/mecha_parts/part/gygax_right_leg)
	for(var/i=0;i<2;i++)
		if(!isemptylist(parts) && prob(40))
			var/part = pick(parts)
			welder_salvage += part
			parts -= part
	return

/obj/effect/decal/mecha_wreckage/gygax/dark
	name = "Dark Gygax wreckage"
	icon_state = "darkgygax-broken"

/obj/effect/decal/mecha_wreckage/marauder
	name = "Marauder wreckage"
	icon_state = "marauder-broken"

/obj/effect/decal/mecha_wreckage/mauler
	name = "Mauler Wreckage"
	icon_state = "mauler-broken"
	desc = "The syndicate won't be very happy about this..."

/obj/effect/decal/mecha_wreckage/seraph
	name = "Seraph wreckage"
	icon_state = "seraph-broken"

/obj/effect/decal/mecha_wreckage/hermes
	name = "Hermes wreckage"
	icon_state = "hermes-broken"

/obj/effect/decal/mecha_wreckage/hermes/New()
	..()
	var/list/parts = list(
						  /obj/item/mecha_parts/part/hermes_torso,
						  /obj/item/mecha_parts/part/hermes_left_arm,
						  /obj/item/mecha_parts/part/hermes_right_arm,
						  /obj/item/mecha_parts/part/hermes_left_leg,
						  /obj/item/mecha_parts/part/hermes_right_leg
						  )
	for(var/i=0;i<2;i++)
		if(!isemptylist(parts) && prob(40))
			var/part = pick(parts)
			welder_salvage += part
			parts -= part
	return


/obj/effect/decal/mecha_wreckage/ripley
	name = "Ripley wreckage"
	icon_state = "ripley-broken"

/obj/effect/decal/mecha_wreckage/ripley/New()
	..()
	var/list/parts = list(/obj/item/mecha_parts/part/ripley_torso,
								/obj/item/mecha_parts/part/ripley_left_arm,
								/obj/item/mecha_parts/part/ripley_right_arm,
								/obj/item/mecha_parts/part/ripley_left_leg,
								/obj/item/mecha_parts/part/ripley_right_leg)
	for(var/i=0;i<2;i++)
		if(!isemptylist(parts) && prob(40))
			var/part = pick(parts)
			welder_salvage += part
			parts -= part
	return




/obj/effect/decal/mecha_wreckage/ripley/firefighter
	name = "Firefighter wreckage"
	icon_state = "firefighter-broken"

/obj/effect/decal/mecha_wreckage/ripley/firefighter/New()
	..()
	var/list/parts = list(/obj/item/mecha_parts/part/ripley_torso,
								/obj/item/mecha_parts/part/ripley_left_arm,
								/obj/item/mecha_parts/part/ripley_right_arm,
								/obj/item/mecha_parts/part/ripley_left_leg,
								/obj/item/mecha_parts/part/ripley_right_leg,
								/obj/item/clothing/suit/fire)
	for(var/i=0;i<2;i++)
		if(!isemptylist(parts) && prob(40))
			var/part = pick(parts)
			welder_salvage += part
			parts -= part
	return

/obj/effect/decal/mecha_wreckage/ripley/deathripley
	name = "Death-Ripley wreckage"
	icon_state = "deathripley-broken"

/obj/effect/decal/mecha_wreckage/durand
	name = "Durand wreckage"
	icon_state = "durand-broken"

/obj/effect/decal/mecha_wreckage/durand/New()
	..()
	var/list/parts = list(
								/obj/item/mecha_parts/part/durand_torso,
								/obj/item/mecha_parts/part/durand_head,
								/obj/item/mecha_parts/part/durand_left_arm,
								/obj/item/mecha_parts/part/durand_right_arm,
								/obj/item/mecha_parts/part/durand_left_leg,
								/obj/item/mecha_parts/part/durand_right_leg)
	for(var/i=0;i<2;i++)
		if(!isemptylist(parts) && prob(40))
			var/part = pick(parts)
			welder_salvage += part
			parts -= part
	return

/obj/effect/decal/mecha_wreckage/phazon
	name = "Phazon wreckage"
	icon_state = "phazon-broken"


/obj/effect/decal/mecha_wreckage/odysseus
	name = "Odysseus wreckage"
	icon_state = "odysseus-broken"

/obj/effect/decal/mecha_wreckage/odysseus/New()
	..()
	var/list/parts = list(
								/obj/item/mecha_parts/part/odysseus_torso,
								/obj/item/mecha_parts/part/odysseus_head,
								/obj/item/mecha_parts/part/odysseus_left_arm,
								/obj/item/mecha_parts/part/odysseus_right_arm,
								/obj/item/mecha_parts/part/odysseus_left_leg,
								/obj/item/mecha_parts/part/odysseus_right_leg)
	for(var/i=0;i<2;i++)
		if(!isemptylist(parts) && prob(40))
			var/part = pick(parts)
			welder_salvage += part
			parts -= part
	return

/obj/effect/decal/mecha_wreckage/hoverpod
	name = "Hover pod wreckage"
	icon_state = "engineering_pod-broken"

/obj/effect/decal/mecha_wreckage/tank
	name = "adhomian light tank wreckage"
	desc = "Remains of some unfortunate armored vehicle. Completely unrepairable."
	icon = 'icons/mecha/mecha_64x64.dmi'
	icon_state = "tank-broken"
	anchored = TRUE
	pixel_x = -16
	layer = ABOVE_MOB_LAYER

/obj/effect/decal/mecha_wreckage/tank/jotun
	name = "Jotun wreckage"
	icon = 'icons/mecha/mecha_114x59.dmi'
	icon_state = "jotun-broken"
	pixel_x = -41