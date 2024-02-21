/obj/item/storage/belt
	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"
	force = 2
	storage_slots = 7
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = 28
	slot_flags = SLOT_BELT
	attack_verb = list("whipped", "lashed", "disciplined")
	drop_sound = 'sound/items/drop/toolbelt.ogg'
	pickup_sound = 'sound/items/pickup/toolbelt.ogg'
	var/flipped = FALSE
	var/show_above_suit = FALSE
	var/content_overlays = FALSE //If this is true, the belt will gain overlays based on what it's holding

/obj/item/storage/belt/proc/update_clothing_icon()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_belt()

/obj/item/storage/belt/update_icon()
	cut_overlays()
	if(content_overlays)
		for(var/obj/item/I in contents)
			add_overlay(I.get_belt_overlay())
	..()

/obj/item/storage/belt/build_additional_parts(H, mob_icon, slot)
	var/image/I = ..()
	if(!I)
		I = image(null)
	for(var/obj/item/i in contents)
		var/c_state
		var/c_icon
		if(i.contained_sprite)
			c_state = "[UNDERSCORE_OR_NULL(i.icon_species_tag)][i.item_state][WORN_BELT]"
			c_icon = icon_override || icon
		else
			c_icon = INV_BELT_DEF_ICON
			c_state = i.item_state || i.icon_state
		var/image/belt_item_image = image(c_icon, c_state)
		belt_item_image.color = i.color
		belt_item_image.appearance_flags = RESET_ALPHA
		I.add_overlay(belt_item_image)
	return I

/obj/item/storage/belt/verb/toggle_layer()
	set name = "Switch Belt Layer"
	set category = "Object"
	set src in usr

	if(show_above_suit == -1)
		to_chat(usr, SPAN_NOTICE("\The [src] cannot be worn above your suit!"))
		return
	show_above_suit = !show_above_suit
	update_clothing_icon()

/obj/item/storage/belt/Initialize()
	. = ..()
	update_flip_verb()

/obj/item/storage/belt/fill()
	. = ..()
	update_icon()

/obj/item/storage/belt/proc/update_flip_verb()
	if(("[initial(icon_state)]_flip") in icon_states(icon)) // Check for whether it has a flipped icon. Prevents invisible sprites.
		verbs += /obj/item/storage/belt/proc/flipbelt

/obj/item/storage/belt/proc/flipbelt(mob/user, var/self = TRUE)
	set category = "Object"
	set name = "Flip Belt"
	set src in usr

	if(self)
		if(use_check_and_message(user))
			return
	else
		if(use_check_and_message(user, self ? USE_ALLOW_NON_ADJACENT : 0))
			return

	flipped = !flipped
	icon_state = "[initial(icon_state)][flipped ? "_flip" : ""]"
	item_state = "[initial(item_state)][flipped ? "_flip" : ""]"
	to_chat(usr, SPAN_NOTICE("You change \the [src] to be [src.flipped ? "behind" : "in front of"] you."))
	update_clothing_icon()

/obj/item/storage/belt/utility
	name = "tool belt"
	desc = "A sturdy belt for holding various tools and equipment."
	icon_state = "utilitybelt"
	item_state = "utility"
	equip_sound = 'sound/items/equip/toolbelt.ogg'
	can_hold = list(
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/hammer,
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
		/obj/item/device/debugger,
		/obj/item/device/eftpos,
		/obj/item/tape_roll,
		/obj/item/device/geiger
	)
	content_overlays = TRUE

/obj/item/storage/belt/utility/ce
	icon_state = "utilitybelt_ce"
	item_state = "utility_ce"

	starts_with = list(
		/obj/item/weldingtool/largetank = 1, // industrial welding tool
		/obj/item/crowbar = 1,
		/obj/item/wirecutters/toolbelt = 1,
		/obj/item/stack/cable_coil/random = 1,
		/obj/item/powerdrill = 1
	)

/obj/item/storage/belt/utility/full
	starts_with = list(
		/obj/item/screwdriver = 1,
		/obj/item/wrench = 1,
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters/toolbelt = 1,
		/obj/item/stack/cable_coil/random = 1,
		/obj/item/hammer = 1
	)

/obj/item/storage/belt/utility/very_full
	starts_with = list(
		/obj/item/weldingtool/largetank = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters/toolbelt = 1,
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
		/obj/item/storage/box/fancy/cigarettes,
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
		/obj/item/device/radio,
		/obj/item/taperoll/medical,
		/obj/item/storage/box/fancy/med_pouch
		)

/obj/item/storage/belt/medical/first_responder
	name = "first responder utility belt"
	desc = "A sturdy black webbing belt with attached pouches."
	icon_state = "emsbelt"
	item_state = "emsbelt"

/obj/item/storage/belt/medical/first_responder/combat
	name = "tactical medical belt"
	desc = "A sturdy black webbing belt with attached pouches. This one is designed for medical professionals who expect to enter conflict zones on the daily. It has increased storage and utility."
	storage_slots = 9
	max_storage_space = 28
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
		/obj/item/storage/box/fancy/cigarettes,
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
		/obj/item/device/radio,
		/obj/item/taperoll/medical,
		/obj/item/handcuffs,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_magazine,
		/obj/item/device/flash,
		/obj/item/device/flashlight/maglight,
		/obj/item/device/flashlight/flare,
		/obj/item/material/knife,
		/obj/item/stack/telecrystal,
		/obj/item/melee/baton,
		/obj/item/shield/riot/tact,
		/obj/item/grenade,
		/obj/item/reagent_containers/blood
		)

/obj/item/storage/belt/medical/first_responder/combat/full
		starts_with = list(
		/obj/item/reagent_containers/hypospray/cmo = 1,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 1,
		/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
		/obj/item/reagent_containers/glass/bottle/butazoline = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1
	)

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
		/obj/item/reagent_containers/food/snacks/donut, // kek
		/obj/item/melee/baton,
		/obj/item/gun/energy/taser,
		/obj/item/flame/lighter,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/device/flashlight/maglight,
		/obj/item/device/flashlight/flare,
		/obj/item/modular_computer/handheld,
		/obj/item/device/radio/headset,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/melee,
		/obj/item/gun/projectile/sec,
		/obj/item/gun/energy/disruptorpistol,
		/obj/item/taperoll/police,
		/obj/item/material/knife/trench,
		/obj/item/shield/energy,
		/obj/item/shield/riot/tact,
		/obj/item/device/holowarrant,
		/obj/item/device/radio
		)
	content_overlays = TRUE

/obj/item/storage/belt/security/full
	starts_with = list(
		/obj/item/melee/baton/loaded = 1,
		/obj/item/reagent_containers/spray/pepper = 1,
		/obj/item/handcuffs = 1,
		/obj/item/device/flash = 1,
		/obj/item/device/holowarrant = 1
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
		/obj/item/clothing/mask/luchador
		)

/obj/item/storage/belt/security/tactical
	name = "combat belt"
	desc = "Can hold security gear like handcuffs and flashes, with more pouches for more storage."
	icon_state = "swatbelt"
	item_state = "swatbelt"
	storage_slots = 9
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = 28

/obj/item/storage/belt/military
	name = "military belt"
	desc = "A lightweight, quick to use, military belt. Designed to be comfortably worn even during lengthy military operations."
	icon_state = "militarybelt"
	item_state = "militarybelt"
	storage_slots = 9 //same as a combat belt now
	max_w_class = ITEMSIZE_NORMAL
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
		/obj/item/modular_computer/handheld,
		/obj/item/device/radio/headset,
		/obj/item/melee,
		/obj/item/shield/energy,
		/obj/item/pinpointer,
		/obj/item/plastique,
		/obj/item/gun/projectile/pistol,
		/obj/item/gun/projectile/silenced,
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
	desc = "A red military belt designed to be used by boarding parties and SWAT teams."
	icon_state = "militarybelt_syndie"
	item_state = "militarybelt_syndie"

/obj/item/storage/belt/custodial
	name = "custodial belt"
	desc = "A utility belt designed for custodial use."
	desc_extended = "A custodial belt is similar to most utility belts, but designed with pockets and attachment points that can hold common custodial tools."
	icon_state = "custodialbelt"
	item_state = "custodialbelt"
	storage_slots = 12
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/device/flashlight,
		/obj/item/extinguisher/mini,
		/obj/item/device/radio,
		/obj/item/clothing/gloves,
		/obj/item/clothing/glasses,
		/obj/item/reagent_containers/spray,
		/obj/item/grenade/chem_grenade,
		/obj/item/device/lightreplacer,
		/obj/item/soap,
		/obj/item/storage/bag/trash,
		/obj/item/reagent_containers/glass/rag,
		/obj/item/gun/energy/mousegun,
		/obj/item/device/gps,
		/obj/item/taperoll/custodial
	)

/obj/item/storage/belt/mining
	name = "explorer's belt"
	desc = "A versatile chest rig, cherished by miners and hunters alike."
	icon_state = "explorer"
	item_state = "explorer"
	storage_slots = 9
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_LARGE //Pickaxes are big.
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
		/obj/item/storage/box/fancy/cigarettes,
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
		/obj/item/gun/custom_ka,
		/obj/item/device/orbital_dropper,
		/obj/item/ore_detector
		)

/obj/item/storage/belt/hydro
	name = "hydrobelt"
	desc = "A utility belt to store and provide easy access to your floral utilities."
	icon_state = "growbelt"
	item_state = "growbelt"
	storage_slots = 9
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_LARGE
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
	max_w_class = ITEMSIZE_LARGE
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
		/obj/item/modular_computer/handheld,
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
	name = "fannypack"
	desc = "A dorky fannypack for keeping small items in."
	icon = 'icons/clothing/belts/fannypacks.dmi'
	icon_state = "fannypack"
	item_state = "fannypack"
	max_w_class = ITEMSIZE_SMALL
	contained_sprite = TRUE
	storage_slots = null
	max_storage_space = 8

/obj/item/storage/belt/fannypack/recolorable
	icon_state = "fannypack_colorable"
	item_state = "fannypack_colorable"

/obj/item/storage/belt/fannypack/recolorable/random/Initialize()
	. = ..()
	color = get_random_colour(TRUE)

/obj/item/storage/belt/fannypack/component
	name = "component pouch"
	desc = "A dorky fannypack for keeping small items in. Also stores magickal components!"
	starts_with = list(/obj/item/toy/snappop/syndi = 3, /obj/item/reagent_containers/glass/beaker/vial/random/toxin = 2, /obj/item/storage/pill_bottle/dice = 1)
	max_storage_space = 14

/obj/item/storage/belt/shumaila_buckle
	name = "hammer buckle belt"
	desc = "A leather belt adorned by a hammer shaped buckle, worn by priesthood and worshippers of Shumaila."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "hammerbelt"
	item_state = "hammerbelt"
	contained_sprite = TRUE
	storage_slots = 1
	max_w_class = ITEMSIZE_SMALL
	desc_extended = "Shumaila is the sister of Mata'ke and the goddess of fortification, chastity, and building. She is the head of the town watch and the architect for all of the \
	Holy Village's most important buildings. When Mata'ke's original hunting party had done battle with the King of Rraknarr, her beloved was killed in the fighting. Ever since then \
	she has resolved to be eternally chaste in dedication to him. She is an M'sai who is depicted wearing modest dresses and carrying a hammer on a belt. She is not known for having \
	much combat prowess despite her position as head of the town watch but is a capable commander for defensive tactics."

/obj/item/storage/belt/generic
	name = "belt"
	desc = "Only useful for holding up your pants." // Useless belt is useless.
	icon = 'icons/obj/item/clothing/belts/generic_belts.dmi'
	icon_state = "belt"
	item_state = "belt"
	contained_sprite = TRUE
	storage_slots = 1
	max_w_class = ITEMSIZE_TINY

/obj/item/storage/belt/generic/thin
	name = "thin elastic belt"
	icon_state = "thin_belt"
	item_state = "thin_belt"

/obj/item/storage/belt/generic/thick
	name = "wide waist belt"
	icon_state = "thick_belt"
	item_state = "thick_belt"

/obj/item/storage/belt/generic/buckle
	name = "buckle belt"
	desc = "A belt secured by a large golden buckle."
	icon_state = "belt_b"
	item_state = "belt_b"
	build_from_parts = TRUE
	worn_overlay = "buckle"
