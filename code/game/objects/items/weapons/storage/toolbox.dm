/obj/item/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/storage/toolbox.dmi'
	contained_sprite = TRUE
	icon_state = "red"
	item_state = "red"
	center_of_mass = list("x" = 16,"y" = 11)
	flags = CONDUCT
	force = 5
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = 14 //enough to hold all starting contents
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("robusted")
	use_sound = 'sound/items/storage/toolbox.ogg'
	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'

	var/stunhit = 0

/obj/item/storage/toolbox/Initialize()
	. = ..()
	update_force()

/obj/item/storage/toolbox/emergency
	name = "emergency toolbox"
	starts_with = list(
		/obj/item/crowbar/red = 1,
		/obj/item/extinguisher/mini = 1,
		/obj/item/device/radio = 1
	)

/obj/item/storage/toolbox/emergency/fill()
	. = ..()
	if(prob(50))
		new /obj/item/device/flashlight(src)
	else
		new /obj/item/device/flashlight/flare/glowstick/red(src)
	if(prob(30))
		new /obj/item/weldingtool/emergency(src)
		new /obj/item/clothing/glasses/welding/emergency(src)

/obj/item/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "blue"
	starts_with = list(\
		/obj/item/screwdriver = 1,\
		/obj/item/wrench = 1,\
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,\
		/obj/item/device/analyzer = 1,\
		/obj/item/wirecutters = 1\
	)

/obj/item/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "yellow"
	starts_with = list(\
		/obj/item/screwdriver = 1,\
		/obj/item/wirecutters = 1,\
		/obj/item/device/t_scanner = 1,\
		/obj/item/crowbar = 1\
	)

/obj/item/storage/toolbox/electrical/fill()
	. = ..()
	var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
	new /obj/item/stack/cable_coil(src,30,color)
	new /obj/item/stack/cable_coil(src,30,color)
	if(prob(5))
		new /obj/item/clothing/gloves/yellow(src)
	else
		new /obj/item/stack/cable_coil(src,30,color)

/obj/item/storage/toolbox/drill
	name = "drilling kit"
	desc = "A kit supplied to drill technicians, containing the tools required to set up a basic asteroid drilling operation."
	icon_state = "miningbox"
	item_state = "miningbox"
	contained_sprite = TRUE
	starts_with = list(
		/obj/item/crowbar = 1,
		/obj/item/powerdrill = 1,
		/obj/item/mining_scanner = 1,
		/obj/item/cell/high = 1,
		/obj/item/device/orbital_dropper/drill = 1
	)

/obj/item/storage/toolbox/ka
	name = "kinetic accelerator kit"
	desc = "A kit supplied to shaft miners, containing a few upgrades to standard issue kinetic accelerators."
	icon_state = "miningbox"
	item_state = "miningbox"
	contained_sprite = TRUE
	starts_with = list(
		/obj/item/crowbar = 1,
		/obj/item/wrench = 1,
		/obj/item/custom_ka_upgrade/upgrade_chips/damage = 1,
		/obj/item/custom_ka_upgrade/cells/cell02 = 1
	)

/obj/item/storage/toolbox/syndicate
	name = "suspicious looking toolbox"
	icon_state = "syndicate"
	item_state = "syndicate"
	origin_tech = list(TECH_COMBAT = 1, TECH_ILLEGAL = 1)
	force = 7.0
	starts_with = list(\
		/obj/item/clothing/gloves/yellow = 1,\
		/obj/item/screwdriver = 1,\
		/obj/item/wrench = 1,\
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,\
		/obj/item/wirecutters = 1,\
		/obj/item/device/multitool = 1,\
	)


/obj/item/storage/toolbox/proc/update_force()
	force = initial(force)
	for (var/obj/item/I in contents)
		force += I.w_class*1.5

/obj/item/storage/toolbox/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	if (..(W, prevent_warning))
		update_force()


/obj/item/storage/toolbox/attack(mob/living/M as mob, mob/user as mob, var/target_zone)
	update_force()
	if (..())
		if (contents.len)
			spill(3, get_turf(M))
			playsound(M, /decl/sound_category/tray_hit_sound, 100, 1)  //sound playin' again
			update_force()
			user.visible_message(SPAN_DANGER("[user] smashes the [src] into [M], causing it to break open and strew its contents across the area"))

/obj/item/storage/toolbox/lunchbox
	name = "rainbow lunchbox"
	icon = 'icons/obj/storage/lunchbox.dmi'
	force = 3
	throwforce = 5
	icon_state = "lunchbox_rainbow"
	item_state = "lunchbox_rainbow"
	desc = "A little lunchbox. This one is in the colors of the rainbow."
	attack_verb = list("lunched")
	w_class = ITEMSIZE_NORMAL
	max_storage_space = 8
	var/filled = FALSE

/obj/item/storage/toolbox/lunchbox/fill()
	..()
	if(filled)
		var/list/lunches = lunchables_lunches()
		var/lunch = lunches[pick(lunches)]
		new lunch(src)

		var/list/snacks = lunchables_snacks()
		var/snack = snacks[pick(snacks)]
		new snack(src)

		var/list/drinks = lunchables_drinks()
		var/drink = drinks[pick(drinks)]
		new drink(src)

/obj/item/storage/toolbox/lunchbox/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/heart
	name = "heart lunchbox"
	icon_state = "lunchbox_hearts"
	item_state = "lunchbox_hearts"
	desc = "A little lunchbox. This one has little hearts on it."

/obj/item/storage/toolbox/lunchbox/heart/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/cat
	name = "cat lunchbox"
	icon_state = "lunchbox_cat"
	item_state = "lunchbox_cat"
	desc = "A little lunchbox. This one has a cat stamp on it."

/obj/item/storage/toolbox/lunchbox/cat/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/nt
	name = "NanoTrasen brand lunchbox"
	icon_state = "lunchbox_nanotrasen"
	item_state = "lunchbox_nanotrasen"
	desc = "A little lunchbox. This one is branded with the NanoTrasen logo."

/obj/item/storage/toolbox/lunchbox/nt/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/idris
	name = "Idris Incorporated lunchbox"
	icon_state = "lunchbox_idris"
	item_state = "lunchbox_idris"
	desc = "A little lunchbox. This one features a durable holographic screen on the side that showcases the Idris logo."

/obj/item/storage/toolbox/lunchbox/idris/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/nymph
	name = "\improper diona nymph lunchbox"
	icon_state = "lunchbox_dionanymph"
	item_state = "lunchbox_dionanymph"
	desc = "A little lunchbox. This one has a diona nymph on the side."

/obj/item/storage/toolbox/lunchbox/nymph/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/syndicate
	name = "black and red lunchbox"
	icon_state = "lunchbox_syndie"
	item_state = "lunchbox_syndie"
	desc = "A little lunchbox. This one is a sleek black and red."

/obj/item/storage/toolbox/lunchbox/syndicate/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/schlorrgo
	name = "patriotic lunchbox"
	icon_state = "lunchbox_schlorrgo"
	item_state = "lunchbox_schlorrgo"
	desc = "A little lunchbox. This one has a Cool Schlorrgo stamp on \
	it, a famous Adhomian cartoon character. Approved by the People's Republic of Adhomai."

/obj/item/storage/toolbox/lunchbox/schlorrgo/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/scc
	name = "Stellar Corporate Conglomerate lunchbox"
	desc = "A little lunchbox. This one is branded with the Stellar Corporate Conglomerate logo."
	desc_extended = "The Stellar Corporate Conglomerate, also known as Chainlink, is a joint alliance between the NanoTrasen Corporation, Hephaestus Industries, Idris Incorporated, Zeng-Hu Pharmaceuticals and Zavodskoi Interstellar to exercise an undisputed economic dominance over the Orion Spur."
	icon_state = "lunchbox_scc"
	item_state = "lunchbox_scc"

/obj/item/storage/toolbox/lunchbox/scc/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/swimstars_axic
	name = "Swimstars Axic lunchbox"
	desc = "Created, and marketed, after the hit show, Swimstars!"
	icon_state = "swimstars_axic"
	item_state = "swimstars_axic"

/obj/item/storage/toolbox/lunchbox/swimstars_axic/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/swimstars_qill
	name = "Swimstars Qill lunchbox"
	desc = "Created, and marketed, after the hit show, Swimstars!"
	icon_state = "swimstars_qill"
	item_state = "swimstars_qill"

/obj/item/storage/toolbox/lunchbox/swimstars_qill/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/swimstars_xana
	name = "Swimstars Xana lunchbox"
	desc = "Created, and marketed, after the hit show, Swimstars!"
	icon_state = "swimstars_xana"
	item_state = "swimstars_xana"

/obj/item/storage/toolbox/lunchbox/swimstars_xana/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/sedantis
	name = "Sedantis lunchbox"
	desc = "A little lunchbox, displaying a proud Sedantis flag."
	icon_state = "lunchbox_sedantis"
	item_state = "lunchbox_sedantis"

/obj/item/storage/toolbox/lunchbox/sedantis/filled
	filled = TRUE
