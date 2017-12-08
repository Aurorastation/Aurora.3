/obj/item/storage/belt
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

/obj/item/storage/belt/verb/toggle_layer()
	set name = "Switch Belt Layer"
	set category = "Object"

	if(show_above_suit == -1)
		usr << "<span class='notice'>\The [src] cannot be worn above your suit!</span>"
		return
	show_above_suit = !show_above_suit
	update_icon()

/obj/item/storage/update_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_belt()


/obj/item/storage/belt/utility
	name = "tool-belt" //Carn: utility belt is nicer, but it bamboozles the text parsing.
	desc = "Can hold various tools."
	icon_state = "utilitybelt"
	item_state = "utility"
	can_hold = list(
		///obj/item/combitool,
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/device/multitool,
		/obj/item/device/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer,
		/obj/item/taperoll/engineering,
		/obj/item/device/robotanalyzer,
		/obj/item/material/minihoe,
		/obj/item/material/hatchet,
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/extinguisher/mini
		)


/obj/item/storage/belt/utility/full/fill()
	..()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/wirecutters(src)
	new /obj/item/stack/cable_coil(src,30,pick("red","yellow","orange"))


/obj/item/storage/belt/utility/atmostech/fill()
	..()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/wirecutters(src)
	new /obj/item/device/t_scanner(src)



/obj/item/storage/belt/medical
	name = "medical belt"
	desc = "Can hold various medical equipment."
	icon_state = "medicalbelt"
	item_state = "medical"
	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/flame/lighter/zippo,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/surgery,
		/obj/item/clothing/gloves/latex,
		/obj/item/reagent_containers/hypospray,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/crowbar,
		/obj/item/device/flashlight,
		/obj/item/extinguisher/mini
		)

/obj/item/storage/belt/medical/emt
	name = "EMT utility belt"
	desc = "A sturdy black webbing belt with attached pouches."
	icon_state = "emsbelt"
	item_state = "emsbelt"

/obj/item/storage/belt/security
	name = "security belt"
	desc = "Can hold security gear like handcuffs and flashes."
	icon_state = "securitybelt"
	item_state = "security"
	can_hold = list(
		/obj/item/grenade,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/handcuffs,
		/obj/item/device/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_magazine,
		/obj/item/reagent_containers/food/snacks/donut/,
		/obj/item/melee/baton,
		/obj/item/gun/energy/taser,
		/obj/item/flame/lighter,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/device/flashlight/maglight,
		/obj/item/device/flashlight/flare,
		/obj/item/device/flashlight/glowstick,
		/obj/item/device/pda,
		/obj/item/device/radio/headset,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/melee,
		/obj/item/gun/projectile/sec,
		/obj/item/taperoll/police,
		/obj/item/material/sword/trench,
		/obj/item/shield/energy,
		/obj/item/shield/riot/tact,
		/obj/item/device/holowarrant
		)

/obj/item/storage/belt/soulstone
	name = "soul stone belt"
	desc = "Designed for ease of access to the shards during a fight, as to not let a single enemy spirit slip away"
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"
	storage_slots = 6
	can_hold = list(
		/obj/item/device/soulstone
		)

/obj/item/storage/belt/soulstone/full/fill()
	..()
	new /obj/item/device/soulstone(src)
	new /obj/item/device/soulstone(src)
	new /obj/item/device/soulstone(src)
	new /obj/item/device/soulstone(src)
	new /obj/item/device/soulstone(src)
	new /obj/item/device/soulstone(src)

/obj/item/storage/belt/champion
	name = "championship belt"
	desc = "Proves to the world that you are the strongest!"
	icon_state = "championbelt"
	item_state = "champion"
	storage_slots = 1
	can_hold = list(
		"/obj/item/clothing/mask/luchador"
		)

/obj/item/storage/belt/security/tactical
	name = "combat belt"
	desc = "Can hold security gear like handcuffs and flashes, with more pouches for more storage."
	icon_state = "swatbelt"
	item_state = "swatbelt"
	storage_slots = 9
	max_w_class = 3
	max_storage_space = 28

/obj/item/storage/belt/military
	name = "military belt"
	desc = "A syndicate belt designed to be used by boarding parties. Its style is modeled after the hardsuits they wear."
	icon_state = "militarybelt"
	item_state = "militarybelt"
	storage_slots = 9 //same as a combat belt now
	max_w_class = 3
	max_storage_space  = 28
	can_hold = list(
		/obj/item/grenade,
		/obj/item/handcuffs,
		/obj/item/device/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_magazine,
		/obj/item/melee/baton,
		/obj/item/device/flashlight,
		/obj/item/device/pda,
		/obj/item/device/radio/headset,
		/obj/item/melee,
		/obj/item/shield/energy,
		/obj/item/pinpointer,
		/obj/item/plastique,
		/obj/item/gun/projectile/pistol,
		/obj/item/gun/energy/crossbow,
		/obj/item/material/sword/trench,
		/obj/item/ammo_casing/a145,
		/obj/item/device/radio/uplink,
		/obj/item/card/emag,
		/obj/item/device/multitool/hacktool,
		/obj/item/reagent_containers/hypospray/combat,
		/obj/item/stack/telecrystal
		)

/obj/item/storage/belt/janitor
	name = "janibelt"
	desc = "A belt used to hold most janitorial supplies."
	icon_state = "janibelt"
	item_state = "janibelt"
	storage_slots = 6
	max_w_class = 3
	max_storage_space  = 28
	can_hold = list(
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/device/lightreplacer,
		/obj/item/device/flashlight,
		/obj/item/reagent_containers/spray,
		/obj/item/soap,
		/obj/item/storage/bag/trash
		)

/obj/item/storage/belt/wands
	name = "wand belt"
	desc = "A belt designed to hold various rods of power."
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"
	storage_slots = 5
	max_w_class = 3
	max_storage_space  = 28
	can_hold = list(
		/obj/item/gun/energy/wand
		)

/obj/item/storage/belt/wands/full/fill()
	..()
	new /obj/item/gun/energy/wand/fire(src)
	new /obj/item/gun/energy/wand/polymorph(src)
	new /obj/item/gun/energy/wand/teleport(src)
	new /obj/item/gun/energy/wand/force(src)
	new /obj/item/gun/energy/wand/animation(src)

/obj/item/storage/belt/mining
	name = "explorer's belt"
	desc = "A versatile chest rig, cherished by miners and hunters alike."
	icon_state = "explorer"
	item_state = "explorer"
	storage_slots = 9
	w_class = 4
	max_w_class = 4 //Pickaxes are big.
	can_hold = list(/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/resonator,
		/obj/item/oreportal,
		/obj/item/oremagnet,
		/obj/item/plastique/seismic,
		/obj/item/extraction_pack,
		/obj/item/ore_radar,
		/obj/item/device/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/stack/flag,
		/obj/item/device/wormhole_jaunter,
		/obj/item/device/analyzer,
		/obj/item/extinguisher/mini,
		/obj/item/device/radio,
		/obj/item/clothing/gloves,
		/obj/item/clothing/glasses/material,
		/obj/item/pickaxe,
		/obj/item/shovel,
		/obj/item/stack/material/animalhide,
		/obj/item/flame/lighter,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/reagent_containers/food/drinks/bottle,
		/obj/item/stack/medical,
		/obj/item/reagent_containers/hypospray,
		/obj/item/device/gps,
		/obj/item/storage/bag/ore,
		/obj/item/reagent_containers/pill,
		/obj/item/storage/pill_bottle,
		/obj/item/ore,
		/obj/item/reagent_containers/food/drinks,
		/obj/item/storage/bag/plants,
		/obj/item/warp_core,
		/obj/item/extraction_pack,
		/obj/item/rrf,
		/obj/item/gun/energy/kinetic_accelerator
		)
