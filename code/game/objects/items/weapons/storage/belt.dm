/obj/item/storage/belt
	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"
	force = 2
	storage_slots = 7
	max_w_class = 3
	max_storage_space = 28
	slot_flags = SLOT_BELT
	attack_verb = list("whipped", "lashed", "disciplined")
	drop_sound = 'sound/items/drop/leather.ogg'

	var/show_above_suit = 0

/obj/item/storage/belt/verb/toggle_layer()
	set name = "Switch Belt Layer"
	set category = "Object"

	if(show_above_suit == -1)
		to_chat(usr, "<span class='notice'>\The [src] cannot be worn above your suit!</span>")
		return
	show_above_suit = !show_above_suit
	update_icon()

/obj/item/storage/update_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_belt()


/obj/item/storage/belt/utility
	name = "tool-belt" //Carn: utility belt is nicer, but it bamboozles the text parsing.
	desc = "A sturdy belt for holding various tools."
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
		/obj/item/extinguisher/mini,
		/obj/item/pipewrench,
		/obj/item/powerdrill,
		/obj/item/device/radio,
		/obj/item/device/debugger
		)


/obj/item/storage/belt/utility/full
	starts_with = list(
		/obj/item/screwdriver = 1,
		/obj/item/wrench = 1,
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters = 1,
		/obj/item/stack/cable_coil/random = 1,
		/obj/item/powerdrill = 1
	)

/obj/item/storage/belt/utility/very_full
	starts_with = list(
		/obj/item/weldingtool/largetank = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters = 1,
		/obj/item/stack/cable_coil/random = 1,
		/obj/item/powerdrill = 1,
		/obj/item/device/multitool = 1,
		/obj/item/device/radio = 1
	)


/obj/item/storage/belt/utility/atmostech
	starts_with = list(
		/obj/item/screwdriver = 1,
		/obj/item/wrench = 1,
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters = 1,
		/obj/item/device/t_scanner = 1
	)

/obj/item/storage/belt/utility/alt
	desc = "A sturdy belt for holding various tools. This one eschews pouches for tight loops to hold your tools."
	icon_state = "utilitybelt_alt"
	item_state = "utility_alt"

/obj/item/storage/belt/medical
	name = "medical belt"
	desc = "Can hold various medical equipment."
	icon_state = "medicalbelt"
	item_state = "medical"
	can_hold = list(
		/obj/item/device/breath_analyzer,
		/obj/item/device/healthanalyzer,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/inhaler,
		/obj/item/reagent_containers/personal_inhaler_cartridge,
		/obj/item/personal_inhaler,
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
		/obj/item/extinguisher/mini,
		/obj/item/device/antibody_scanner,
		/obj/item/device/radio
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
		/obj/item/device/flashlight/flare/glowstick,
		/obj/item/device/pda,
		/obj/item/device/radio/headset,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/melee,
		/obj/item/gun/projectile/sec,
		/obj/item/taperoll/police,
		/obj/item/material/knife/trench,
		/obj/item/shield/energy,
		/obj/item/shield/riot/tact,
		/obj/item/device/holowarrant,
		/obj/item/device/radio
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

/obj/item/storage/belt/soulstone/full
	starts_with = list(/obj/item/device/soulstone = 6)

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
	desc = "A lightweight, quick to use, military belt. Designed to be comfortably worn even during lengthy military operations."
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
		/obj/item/material/knife/trench,
		/obj/item/ammo_casing/a145,
		/obj/item/device/radio/uplink,
		/obj/item/card/emag,
		/obj/item/device/multitool/hacktool,
		/obj/item/reagent_containers/hypospray/combat,
		/obj/item/stack/telecrystal,
		/obj/item/device/radio,
		/obj/item/shield/riot/tact,
		/obj/item/material/knife/tacknife
		)

/obj/item/storage/belt/military/syndicate
	desc = "A syndicate belt designed to be used by boarding parties. Its style is modeled after the hardsuits they wear."
	icon_state = "militarybelt_syndie"
	item_state = "militarybelt_syndie"

/obj/item/storage/belt/janitor
	name = "janibelt"
	desc = "A belt used to hold most janitorial supplies."
	icon_state = "janibelt"
	item_state = "janibelt"
	storage_slots = 6
	w_class = 3
	max_w_class = 3
	can_hold = list(
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/device/flashlight,
		/obj/item/extinguisher/mini,
		/obj/item/device/radio,
		/obj/item/clothing/gloves,
		/obj/item/clothing/glasses/material,
		/obj/item/reagent_containers/spray,
		/obj/item/grenade/chem_grenade, //if I'm going to be doing a full allowance on one belt, I need to do the other.
		/obj/item/device/lightreplacer,
		/obj/item/soap,
		/obj/item/storage/bag/trash,
		/obj/item/reagent_containers/glass/rag,
		/obj/item/gun/energy/mousegun
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

/obj/item/storage/belt/wands/full
	starts_with = list(
		/obj/item/gun/energy/wand/fire = 1,
		/obj/item/gun/energy/wand/polymorph = 1,
		/obj/item/gun/energy/wand/teleport = 1,
		/obj/item/gun/energy/wand/force = 1,
		/obj/item/gun/energy/wand/animation = 1
	)

/obj/item/storage/belt/mining
	name = "explorer's belt"
	desc = "A versatile chest rig, cherished by miners and hunters alike."
	icon_state = "explorer"
	item_state = "explorer"
	storage_slots = 9
	w_class = 4
	max_w_class = 4 //Pickaxes are big.
	can_hold = list(
		/obj/item/crowbar,
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
		/obj/item/rfd/mining,
		/obj/item/gun/custom_ka
		)

/obj/item/storage/belt/hydro
	name = "hydrobelt"
	desc = "A utility belt to store and provide easy access to your floral utilities."
	icon_state = "growbelt"
	item_state = "growbelt"
	storage_slots = 9
	w_class = 3
	max_w_class = 4
	can_hold = list(
		/obj/item/reagent_containers/glass,
		/obj/item/grenade/chem_grenade, //weed killer grenades mostly, or water-pottassium if you grow the bannanas!
		/obj/item/bee_smoker, //will this ever get used? Probally not.
		/obj/item/plantspray/pests,
		/obj/item/storage/bag/plants,
		/obj/item/reagent_containers/food/snacks/grown,
		/obj/item/seeds,
		/obj/item/grown,
		/obj/item/material/minihoe,
		/obj/item/material/hatchet,
		/obj/item/wirecutters,
		/obj/item/reagent_containers/spray, //includes if you ever wish to get a spraybottle full of other chemicals, Like water
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/clothing/gloves/botanic_leather,
		/obj/item/device/radio
	)

/obj/item/storage/belt/ninja //credits to BurgerBB
	name = "advanced combat belt"
	desc = "A very robust belt that can hold various specialized gear such as swords, grenades, shurikens, and food rations."
	icon_state = "securitybelt"
	item_state = "security"
	storage_slots = 9
	max_w_class = 4
	max_storage_space = 28

	can_hold = list(
		/obj/item/grenade,
		/obj/item/handcuffs,
		/obj/item/device/flash,
		/obj/item/device/paicard,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_magazine,
		/obj/item/melee/baton,
		/obj/item/device/flashlight,
		/obj/item/device/pda,
		/obj/item/device/radio/headset,
		/obj/item/melee,
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/shield/energy,
		/obj/item/pinpointer,
		/obj/item/plastique,
		/obj/item/gun/projectile/pistol,
		/obj/item/gun/energy/crossbow,
		/obj/item/ammo_casing/a145,
		/obj/item/device/radio/uplink,
		/obj/item/card/emag,
		/obj/item/device/multitool/hacktool,
		/obj/item/reagent_containers,
		/obj/item/stack/telecrystal,
		/obj/item/material/sword,
		/obj/item/material/star,
		/obj/item/device/radio
	)

/obj/item/storage/belt/fannypack
	name = "leather fannypack"
	desc = "A dorky fannypack for keeping small items in."
	icon_state = "fannypack_leather"
	item_state = "fannypack_leather"
	max_w_class = 2
	storage_slots = null
	max_storage_space = 8

/obj/item/storage/belt/fannypack/black
 	name = "black fannypack"
 	icon_state = "fannypack_black"
 	item_state = "fannypack_black"

/obj/item/storage/belt/fannypack/blue
 	name = "blue fannypack"
 	icon_state = "fannypack_blue"
 	item_state = "fannypack_blue"

/obj/item/storage/belt/fannypack/cyan
 	name = "cyan fannypack"
 	icon_state = "fannypack_cyan"
 	item_state = "fannypack_cyan"

/obj/item/storage/belt/fannypack/green
 	name = "green fannypack"
 	icon_state = "fannypack_green"
 	item_state = "fannypack_green"

/obj/item/storage/belt/fannypack/orange
 	name = "orange fannypack"
 	icon_state = "fannypack_orange"
 	item_state = "fannypack_orange"

/obj/item/storage/belt/fannypack/purple
 	name = "purple fannypack"
 	icon_state = "fannypack_purple"
 	item_state = "fannypack_purple"

/obj/item/storage/belt/fannypack/red
 	name = "red fannypack"
 	icon_state = "fannypack_red"
 	item_state = "fannypack_red"

/obj/item/storage/belt/fannypack/white
 	name = "white fannypack"
 	icon_state = "fannypack_white"
 	item_state = "fannypack_white"

/obj/item/storage/belt/fannypack/yellow
 	name = "yellow fannypack"
 	icon_state = "fannypack_yellow"
 	item_state = "fannypack_yellow"

/obj/item/storage/belt/shumaila_buckle
	name = "hammer buckle belt"
	desc = "A leather belt adorned by a hammer shaped buckle, worn by priesthood and worshippers of Shumaila."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "hammerbelt"
	item_state = "hammerbelt"
	contained_sprite = TRUE
	storage_slots = 1
	max_w_class = 2
	description_fluff = "Shumaila is the sister of Mata'ke and the goddess of fortification, chastity, and building. She is the head of the town watch and the architect for all of the \
	Holy Village's most important buildings. When Mata'ke's original hunting party had done battle with the King of Rraknarr, her beloved was killed in the fighting. Ever since then \
	she has resolved to be eternally chaste in dedication to him. She is an M'sai who is depicted wearing modest dresses and carrying a hammer on a belt. She is not known for having \
	much combat prowess despite her position as head of the town watch but is a capable commander for defensive tactics."