	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"
	storage_slots = 7
	max_w_class = 3
	max_storage_space = 28
	slot_flags = SLOT_BELT
	attack_verb = list("whipped", "lashed", "disciplined")
	sprite_sheets = list("Resomi" = 'icons/mob/species/resomi/belt.dmi')

	var/show_above_suit = 0

	set name = "Switch Belt Layer"
	set category = "Object"

	if(show_above_suit == -1)
		usr << "<span class='notice'>\The [src] cannot be worn above your suit!</span>"
		return
	show_above_suit = !show_above_suit
	update_icon()

	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_belt()


	name = "tool-belt" //Carn: utility belt is nicer, but it bamboozles the text parsing.
	desc = "Can hold various tools."
	icon_state = "utilitybelt"
	item_state = "utility"
	can_hold = list(
		/obj/item/device/multitool,
		/obj/item/device/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer,
		/obj/item/taperoll/engineering,
		/obj/item/device/robotanalyzer,
		/obj/item/device/analyzer/plant_analyzer,
		)


	..()
	new /obj/item/stack/cable_coil(src,30,pick("red","yellow","orange"))


	..()
	new /obj/item/device/t_scanner(src)



	name = "medical belt"
	desc = "Can hold various medical equipment."
	icon_state = "medicalbelt"
	item_state = "medical"
	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/stack/medical,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/surgery,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/device/flashlight,
		)

	name = "EMT utility belt"
	desc = "A sturdy black webbing belt with attached pouches."
	icon_state = "emsbelt"
	item_state = "emsbelt"

	name = "security belt"
	desc = "Can hold security gear like handcuffs and flashes."
	icon_state = "securitybelt"
	item_state = "security"
	can_hold = list(
		/obj/item/device/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_magazine,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/device/flashlight/maglight,
		/obj/item/device/flashlight/flare,
		/obj/item/device/flashlight/glowstick,
		/obj/item/device/pda,
		/obj/item/device/radio/headset,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/taperoll/police,
		/obj/item/device/holowarrant
		)

	name = "soul stone belt"
	desc = "Designed for ease of access to the shards during a fight, as to not let a single enemy spirit slip away"
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"
	storage_slots = 6
	can_hold = list(
		/obj/item/device/soulstone
		)

	..()
	new /obj/item/device/soulstone(src)
	new /obj/item/device/soulstone(src)
	new /obj/item/device/soulstone(src)
	new /obj/item/device/soulstone(src)
	new /obj/item/device/soulstone(src)
	new /obj/item/device/soulstone(src)

	name = "championship belt"
	desc = "Proves to the world that you are the strongest!"
	icon_state = "championbelt"
	item_state = "champion"
	storage_slots = 1
	can_hold = list(
		"/obj/item/clothing/mask/luchador"
		)

	name = "combat belt"
	desc = "Can hold security gear like handcuffs and flashes, with more pouches for more storage."
	icon_state = "swatbelt"
	item_state = "swatbelt"
	storage_slots = 9
	max_w_class = 3
	max_storage_space = 28

	name = "military belt"
	desc = "A syndicate belt designed to be used by boarding parties. Its style is modeled after the hardsuits they wear."
	icon_state = "militarybelt"
	item_state = "militarybelt"
	storage_slots = 9 //same as a combat belt now
	max_w_class = 3
	max_storage_space  = 28
	can_hold = list(
		/obj/item/device/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_magazine,
		/obj/item/device/flashlight,
		/obj/item/device/pda,
		/obj/item/device/radio/headset,
		/obj/item/ammo_casing/a145,
		/obj/item/device/radio/uplink,
		/obj/item/device/multitool/hacktool,
		/obj/item/stack/telecrystal
		)

	name = "janibelt"
	desc = "A belt used to hold most janitorial supplies."
	icon_state = "janibelt"
	item_state = "janibelt"
	storage_slots = 6
	max_w_class = 3
	max_storage_space  = 28
	can_hold = list(
		/obj/item/device/lightreplacer,
		/obj/item/device/flashlight,
		)

	name = "wand belt"
	desc = "A belt designed to hold various rods of power."
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"
	storage_slots = 5
	max_w_class = 3
	max_storage_space  = 28
	can_hold = list(
		)

	..()

	name = "explorer's belt"
	desc = "A versatile chest rig, cherished by miners and hunters alike."
	icon_state = "explorer"
	item_state = "explorer"
	storage_slots = 9
	w_class = 4
	max_w_class = 4 //Pickaxes are big.
		/obj/item/device/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/stack/flag,
		/obj/item/device/wormhole_jaunter,
		/obj/item/device/analyzer,
		/obj/item/device/radio,
		/obj/item/clothing/gloves,
		/obj/item/clothing/glasses/material,
		/obj/item/stack/material/animalhide,
		/obj/item/stack/medical,
		/obj/item/device/gps,
		/obj/item/warp_core,
		)
