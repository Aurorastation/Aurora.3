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

/obj/machinery/appliance/cooker/oven/adhomai
	name = "potbelly stove"
	desc = "Borscht is ready."
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "ovenopen"

/obj/item/weapon/retractor/adhomai
	icon = 'icons/adhomai/items.dmi'
	icon_state =  "retractor-old"

/obj/item/weapon/bonesetter/adhomai
	icon = 'icons/adhomai/items.dmi'
	icon_state =  "retractor-old"

/obj/item/weapon/hemostat/adhomai
	icon = 'icons/adhomai/items.dmi'
	icon_state =  "hemostat-old"

/obj/item/weapon/scalpel/adhomai
	icon = 'icons/adhomai/items.dmi'
	icon_state =  "scalpel-old"

/obj/item/weapon/cautery/adhomai
	icon = 'icons/adhomai/items.dmi'
	icon_state =  "cautery-old"

/obj/item/weapon/circular_saw/adhomai
	name = "Bonesaw"
	desc = "A bonesaw. It's ready."
	icon = 'icons/adhomai/items.dmi'
	icon_state =  "saw-old"

/obj/item/weapon/storage/surgicalkit/regular/adhomai
	name = "surgical kit"
	desc = "A field surgical kit. It's perfect for amputations and bullet removals. Everything a dying cat needs but never wanted."
	icon = 'icons/adhomai/items.dmi'
	icon_state = "surgery"

/obj/item/weapon/storage/surgicalkit/regular/adhomai/fill()
	new /obj/item/weapon/bonesetter/adhomai(src)
	new /obj/item/weapon/hemostat/adhomai(src)
	new /obj/item/weapon/retractor/adhomai(src)
	new /obj/item/weapon/scalpel/adhomai(src)
	new /obj/item/weapon/cautery/adhomai(src)
	new /obj/item/weapon/circular_saw/adhomai(src)
	return

/obj/item/weapon/pickaxe/drill/mattock
	name = "mattock"
	desc = "It's a mattock."
	icon = 'icons/adhomai/items.dmi'
	icon_state = "mattock"
	item_state = "pickaxe"
	drill_verb = "excavating"
	autodrill = 0
	drill_sound = 'sound/weapons/chisel1.ogg'
	can_wield = 1
	excavation_amount = 30
	wielded = 0
	force_unwielded = 5.0
	force_wielded = 15.0
	digspeed_unwielded = 30
	digspeed_wielded = 10
	contained_sprite = 1

/obj/item/device/radio/intercom/basestation/adhomai/nka
	name = "basestation"
	desc = "An old basestation. Military in design."
	icon = 'icons/adhomai/radios.dmi'
	icon_state = "nka-base"

/obj/item/device/radio/adhomai/nka
	name = "handheld"
	desc = "An old radio, probably designed to link to a nearby basestation."
	icon = 'icons/adhomai/radios.dmi'
	icon_state = "nka"

/obj/item/device/radio/intercom/basestation/adhomai/pra
	name = "basestation"
	desc = "An old basestation. Military in design."
	icon = 'icons/adhomai/radios.dmi'
	icon_state = "pra-base"

/obj/item/device/radio/adhomai/pra
	name = "handheld"
	desc = "An old radio, probably designed to link to a nearby basestation."
	icon = 'icons/adhomai/radios.dmi'
	icon_state = "pra"

/obj/item/weapon/reagent_containers/food/drinks/flask/canteen/adhomian/nka
	name = "standard issue canteen"
	desc = "The standard issue canteen of the Imperial Adhomian Army. It has a leather strap for carrying, and clasp insignia depicting the entwining Suns, Messa and S'rrendar."
	icon = 'icons/adhomai/items.dmi'
	icon_state = "canteen_nka"

/obj/item/weapon/flame/lighter/adhomian/nka
	name = "standard issue lighter"
	desc = "The standard issue leather wrapped lighter of the Imperial Adhomian Army. It depicts the suns eclipsing in a silver embossing."
	icon = 'icons/adhomai/items.dmi'
	icon_state = "lighter_nka"

/obj/item/weapon/material/scythe
	name = "hand-scythe"
	desc = "A small curved gardening and farming tool. A symbol of communist governments everywhere."
	icon = 'icons/adhomai/items.dmi'
	icon_state = "hand-scythe"
	item_state = "hand_scythe"
	contained_sprite = 1
	w_class = 2

/obj/item/weapon/wirecutters/clippers/trimmers
	name = "trimmers"
	desc = "Large pair of shears. Real descriptive."
	icon = 'icons/adhomai/items.dmi'
	icon_state = "hedget"
	item_state = "hedget"
	contained_sprite = 1

/obj/item/weapon/autochisel/chisel
	name = "chisel"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick_hand"
	item_state = "syringe_0"
	w_class = 2
	origin_tech = list(TECH_MATERIAL = 1)
	desc = "A modern chisel. For the aspiring sculptor!"

