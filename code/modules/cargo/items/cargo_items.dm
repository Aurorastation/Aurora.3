/singleton/cargo_item
	var/category = "miscellaneous"
	var/name = "generic cargo item"
	var/supplier = "generic supplier"
	var/description = "A basic cargo item."
	var/price = 1
	var/list/items = list()
	var/access = 0 //req_access level required to order/open the crate
	var/container_type = "crate" //what container it spawns in
	var/groupable = 1 //whether or not this can be combined with other items in a crate
	var/item_mul = 1

/*
/singleton/cargo_item/machinepistol45
	category = "security"
	name = ".45 machine pistol"
	supplier = "Zharkov Shipping Company"
	description = "A lightweight, fast firing gun."
	price = 1150
	items = list(
		/obj/item/gun/projectile/automatic/mini_uzi
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/pistol45
	category = "security"
	name = ".45 pistol"
	supplier = "NanoTrasen"
	description = "A NanoTrasen designed sidearm, found pretty much everywhere humans are. Uses .45 rounds."
	price = 400
	items = list(
		/obj/item/gun/projectile/sec
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/ablativehelmet
	category = "security"
	name = "ablative helmet"
	supplier = "NanoTrasen"
	description = "A helmet made from advanced materials which protects against concentrated energy weapons."
	price = 550
	items = list(
		/obj/item/clothing/head/helmet/ablative
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/adhomianmeat
	category = "hospitality"
	name = "adhomian meat"
	supplier = "Zharkov Shipping Company"
	description = "A slab of meat native from Adhomian animals."
	price = 13
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/adhomian_phonograph
	name = "adhomian phonograph"
	supplier = "Zharkov Shipping Company"
	description = "An adhomian record player."
	price = 700
	items = list(
		/obj/machinery/media/jukebox/phonograph
	)
	access = 0
	container_type = "box"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/adhomianrecoillessrifle
	category = "security"
	name = "adhomian recoilless rifle"
	supplier = "Zharkov Shipping Company"
	description = "An inexpensive, one use anti-tank weapon."
	price = 500
	items = list(
		/obj/item/gun/projectile/recoilless_rifle
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/advancedfirstaidkit
	category = "medical"
	name = "advanced first-aid kit"
	supplier = "NanoTrasen"
	description = "Contains advanced medical treatments."
	price = 605
	items = list(
		/obj/item/storage/firstaid/adv
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/airtank
	category = "engineering"
	name = "air tank"
	supplier = "NanoTrasen"
	description = "Mixed anyone?"
	price = 65
	items = list(
		/obj/item/tank/air
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/alphaparticlegenerationarray
	category = "engineering"
	name = "Alpha Particle Generation Array"
	supplier = "NanoTrasen"
	description = "Part of a Particle Accelerator."
	price = 3000
	items = list(
		/obj/structure/particle_accelerator/end_cap
	)
	access = 56
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/ammoniabottle
	category = "hydroponics"
	name = "ammonia bottle"
	supplier = "Getmore Products"
	description = "A small bottle."
	price = 90
	items = list(
		/obj/item/reagent_containers/glass/bottle/ammonia
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/ammunitionbox_beanbag
	category = "security"
	name = "ammunition box (beanbag shells)"
	supplier = "NanoTrasen"
	description = "A magazine for some kind of gun."
	price = 45
	items = list(
		/obj/item/storage/box/beanbags
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/ammunitionbox_haywire
	category = "security"
	name = "ammunition box (haywire shells)"
	supplier = "NanoTrasen"
	description = "A magazine for some kind of gun."
	price = 600
	items = list(
		/obj/item/storage/box/haywireshells
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/ammunitionbox_incendiary
	category = "security"
	name = "ammunition box (incendiary shells)"
	supplier = "NanoTrasen"
	description = "A magazine for some kind of gun."
	price = 100
	items = list(
		/obj/item/storage/box/incendiaryshells
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/ammunitionbox_shells
	category = "security"
	name = "ammunition box (shell)"
	supplier = "NanoTrasen"
	description = "A magazine for some kind of gun."
	price = 450
	items = list(
		/obj/item/storage/box/shotgunshells
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/ammunitionbox_slugs
	category = "security"
	name = "ammunition box (slug)"
	supplier = "NanoTrasen"
	description = "A magazine for some kind of gun."
	price = 500
	items = list(
		/obj/item/storage/box/shotgunammo
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/anesthetictank
	category = "medical"
	name = "anesthetic tank"
	supplier = "NanoTrasen"
	description = "A tank with an N2O/O2 gas mix."
	price = 200
	items = list(
		/obj/item/tank/anesthetic
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/anti_materiel_cannon_cartridge
	category = "security"
	name = "anti-materiel cannon cartridge"
	supplier = "NanoTrasen"
	description = "A single use cartridge for an anti-materiel cannon."
	price = 300
	items = list(
		/obj/item/ammo_casing/peac
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/antifuelgrenade
	category = "engineering"
	name = "antifuel grenade"
	supplier = "NanoTrasen"
	description = "This grenade is loaded with a foaming antifuel compound -- the twenty-fifth century standard for eliminating industrial spills."
	price = 62
	items = list(
		/obj/item/grenade/chem_grenade/antifuel
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/antimattercontainmentjar
	category = "engineering"
	name = "antimatter containment jar"
	supplier = "een"
	description = "Holds antimatter. Warranty void if exposed to matter."
	price = 1000
	items = list(
		/obj/item/am_containment
	)
	access = 56
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/antimattercontrolunit
	category = "engineering"
	name = "antimatter control unit"
	supplier = "een"
	description = "The control unit for an antimatter reactor. Probably safe."
	price = 5500
	items = list(
		/obj/machinery/power/am_control_unit
	)
	access = 56
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/apcarbinemagazine_556
	category = "security"
	name = "ap carbine magazine (5.56mm)"
	supplier = "NanoTrasen"
	description = "An AP 5.56 ammo magazine fit for a carbine, not an assault rifle."
	price = 450
	items = list(
		/obj/item/ammo_magazine/a556/carbine/ap
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/apron
	category = "hydroponics"
	name = "apron"
	supplier = "Getmore Products"
	description = "A basic blue apron."
	price = 25
	items = list(
		/obj/item/clothing/accessory/apron/blue
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/armor
	category = "security"
	name = "armor"
	supplier = "NanoTrasen"
	description = "An armored vest that protects against some damage."
	price = 250
	items = list(
		/obj/item/clothing/suit/armor/vest
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/atmosvoidsuit
	category = "engineering"
	name = "atmos voidsuit"
	supplier = "NanoTrasen"
	description = "A special suit that protects against hazardous, low pressure environments. Has unmatched thermal protection and minor radiation"
	price = 4200
	items = list(
		/obj/item/clothing/suit/space/void/atmos
	)
	access = 24
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/atmosphericsvoidsuithelmet
	category = "engineering"
	name = "atmospherics voidsuit helmet"
	supplier = "NanoTrasen"
	description = "A special helmet designed for work in a hazardous, low pressure environments. Has unmatched thermal and minor radiation protect"
	price = 2850
	items = list(
		/obj/item/clothing/head/helmet/space/void/atmos
	)
	access = 24
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/autakhlimbs
	category = "operations"
	name = "autakh limbs"
	supplier = "NanoTrasen"
	description = "A box with various autakh limbs"
	price = 3000
	items = list(
		/obj/item/organ/external/hand/right/autakh/tool,
		/obj/item/organ/external/hand/right/autakh/tool/mining,
		/obj/item/organ/external/hand/right/autakh/medical
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 2

/singleton/cargo_item/auto_chisel
	category = "operations"
	name = "auto-chisel"
	supplier = "NanoTrasen"
	description = "With an integrated AI chip and hair-trigger precision, this baby makes sculpting almost automatic!"
	price = 500
	items = list(
		/obj/item/autochisel
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/ballisticcarbine
	category = "security"
	name = "ballistic carbine"
	supplier = "NanoTrasen"
	description = "A durable, rugged looking semi-automatic weapon of a make popular on the frontier worlds. Uses 5.56mm rounds."
	price = 5800
	items = list(
		/obj/item/gun/projectile/automatic/rifle/carbine
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/ballistichelmet
	category = "security"
	name = "ballistic helmet"
	supplier = "NanoTrasen"
	description = "A helmet with reinforced plating to protect against ballistic projectiles."
	price = 550
	items = list(
		/obj/item/clothing/head/helmet/ballistic
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/bandolier
	category = "security"
	name = "bandolier"
	supplier = "Zharkov Shipping Company"
	description = "A pocketed belt designated to hold shotgun shells."
	price = 300
	items = list(
		/obj/item/clothing/accessory/storage/bandolier
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/battlemonstersresupplycanister
	category = "operations"
	name = "battlemonsters resupply canister"
	supplier = "blm"
	description = "A vending machine restock cart."
	price = 500
	items = list(
		/obj/item/device/vending_refill/battlemonsters
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/bayonet
	category = "security"
	name = "bayonet"
	supplier = "Zharkov Shipping Company"
	description = "A sharp military knife, can be attached to a rifle."
	price = 300
	items = list(
		/obj/item/clothing/accessory/storage/bayonet
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/beenet
	category = "hydroponics"
	name = "bee net"
	supplier = "NanoTrasen"
	description = "A needed tool to maintain bee imprisonment."
	price = 55
	items = list(
		/obj/item/bee_net
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/beesmoker
	category = "hydroponics"
	name = "bee smoker"
	supplier = "NanoTrasen"
	description = "For when you need to show those bees whos boss."
	price = 120
	items = list(
		/obj/item/bee_smoker
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/beehiveassembly
	category = "hydroponics"
	name = "beehive assembly"
	supplier = "NanoTrasen"
	description = "Beehive frame, some assembly required."
	price = 75
	items = list(
		/obj/item/beehive_assembly
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 2

/singleton/cargo_item/beerkeg
	category = "hospitality"
	name = "beer keg"
	supplier = "Virgo Freight Carriers"
	description = "A beer keg."
	price = 200
	items = list(
		/obj/structure/reagent_dispensers/keg/beerkeg
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/bicaridineautoinjector
	category = "medical"
	name = "bicaridine autoinjector"
	supplier = "NanoTrasen"
	description = "An autoinjector designed to treat physical trauma."
	price = 1000
	items = list(
		/obj/item/reagent_containers/hypospray/autoinjector/bicaridine
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/blackgloves
	category = "security"
	name = "black gloves"
	supplier = "NanoTrasen"
	description = "Black gloves that are somewhat fire resistant."
	price = 70
	items = list(
		/obj/item/clothing/gloves/black
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/blackpaint
	category = "operations"
	name = "black paint"
	supplier = "NanoTrasen"
	description = "Black paint, the color of space."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/black
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/blankvaurcadrone
	category = "science"
	name = "Blank Vaurca Drone"
	supplier = "NanoTrasen"
	description = "A brain dead, generic vaucra drone"
	price = 300
	items = list(
		/mob/living/carbon/human/type_a/cargo
	)
	access = 47
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/bloodpack_ominus
	category = "medical"
	name = "blood pack O-"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A blood pack filled with O- Blood"
	price = 500
	items = list(
		/obj/item/reagent_containers/blood/OMinus
	)
	access = 5
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/bloodpacksbags
	category = "medical"
	name = "blood packs bags"
	supplier = "NanoTrasen"
	description = "This box contains blood packs."
	price = 55
	items = list(
		/obj/item/storage/box/bloodpacks
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/bluelasertagequipmentset
	category = "supply"
	name = "blue laser tag equipment set"
	supplier = "NanoTrasen"
	description = "A set of red laser blue equipment consisting of helmet, armor and gun"
	price = 200
	items = list(
		/obj/item/clothing/head/helmet/riot/laser_tag/blue,
		/obj/item/clothing/suit/armor/riot/laser_tag/blue,
		/obj/item/gun/energy/lasertag/blue
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/bluepaint
	category = "operations"
	name = "blue paint"
	supplier = "NanoTrasen"
	description = "Blue paint, for when you're on a mission from god."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/blue
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/bodybags
	category = "medical"
	name = "body bags"
	supplier = "NanoTrasen"
	description = "This box contains body bags."
	price = 255
	items = list(
		/obj/item/storage/box/bodybags
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/boltactionrifle
	category = "security"
	name = "bolt action rifle"
	supplier = "Zharkov Shipping Company"
	description = "If only it came with a scope."
	price = 850
	items = list(
		/obj/item/gun/projectile/shotgun/pump/rifle
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/bonegel
	category = "medical"
	name = "bone gel"
	supplier = "NanoTrasen"
	description = "A gel made from a mixture of Calcium and Science, but mostly Calcium."
	price = 495
	items = list(
		/obj/item/surgery/bone_gel
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/bonesetter
	category = "medical"
	name = "bone setter"
	supplier = "NanoTrasen"
	description = "Sets bones into place."
	price = 225
	items = list(
		/obj/item/surgery/bonesetter
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/boozeresupplycanister
	category = "operations"
	name = "booze resupply canister"
	supplier = "blm"
	description = "A vending machine restock cart."
	price = 500
	items = list(
		/obj/item/device/vending_refill/booze
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/box
	category = "supply"
	name = "box"
	supplier = "NanoTrasen"
	description = "It's just an ordinary box."
	price = 45
	items = list(
		/obj/item/storage/box
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 5

/singleton/cargo_item/crablegs_box
	category = "hospitality"
	name = "box of crab legs"
	supplier = "NanoTrasen"
	description = "A box filled with high-quality crab legs. Shipped to Aurora by popular demand!"
	price = 20
	items = list(
		/obj/item/storage/box/crabmeat
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/drinkingglasses_box
	category = "hospitality"
	name = "box of drinking glasses"
	supplier = "Virgo Freight Carriers"
	description = "It has a picture of drinking glasses on it."
	price = 21
	items = list(
		/obj/item/storage/box/drinkingglasses
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/empgrenades_box
	category = "security"
	name = "box of emp grenades"
	supplier = "NanoTrasen"
	description = "A box containing 5 military grade EMP grenades.<br> WARNING:</br> Do not use near unshielded electronics or biomechanical augmentations"
	price = 4395
	items = list(
		/obj/item/storage/box/emps
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/flashbangs_box
	category = "security"
	name = "box of flashbangs"
	supplier = "NanoTrasen"
	description = "A box containing 7 antipersonnel flashbang grenades.<br> WARNING:</br> These devices are extremely dangerous and can cause blindness"
	price = 520
	items = list(
		/obj/item/storage/box/flashbangs
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/illuminationshells_box
	category = "security"
	name = "box of illumination shells"
	supplier = "NanoTrasen"
	description = "It has a picture of a gun and several warning symbols on the front.<br>WARNING:</br> Live ammunition. Misuse may result in serious injury and death"
	price = 97
	items = list(
		/obj/item/storage/box/flashshells
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/injectors_box
	category = "medical"
	name = "box of injectors"
	supplier = "NanoTrasen"
	description = "Contains autoinjectors."
	price = 1168
	items = list(
		/obj/item/storage/box/autoinjectors
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/pepperspraygrenades_box
	category = "security"
	name = "box of pepperspray grenades"
	supplier = "NanoTrasen"
	description = "A box containing 7 tear gas grenades. A gas mask is printed on the label.<br> WARNING:</br> Exposure carries risk of serious injuries"
	price = 1050
	items = list(
		/obj/item/storage/box/teargas
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/rasvalclams_box
	category = "hospitality"
	name = "box of Ras'val clams"
	supplier = "Zharkov Shipping Company"
	description = "A box filled with clams from the Ras'val sea, imported from Adhomai."
	price = 200
	items = list(
		/obj/item/storage/box/clams
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/replacementlights_box
	category = "supply"
	name = "box of replacement lights"
	supplier = "blm"
	description = "This box is shaped on the inside so that only light tubes and bulbs fit."
	price = 100
	items = list(
		/obj/item/storage/box/lights/mixed
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/sterilegloves_box
	category = "medical"
	name = "box of sterile gloves"
	supplier = "NanoTrasen"
	description = "Contains sterile gloves."
	price = 98
	items = list(
		/obj/item/storage/box/gloves
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/sterilemasks_box
	category = "medical"
	name = "box of sterile masks"
	supplier = "NanoTrasen"
	description = "This box contains masks of sterility."
	price = 98
	items = list(
		/obj/item/storage/box/masks
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/swabkits_box
	category = "security"
	name = "box of swab kits"
	supplier = "NanoTrasen"
	description = "Sterilized equipment within. Do not contaminate."
	price = 25
	items = list(
		/obj/item/storage/box/swabs
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/syringes_box
	category = "medical"
	name = "box of syringes"
	supplier = "NanoTrasen"
	description = "A box full of syringes."
	price = 200
	items = list(
		/obj/item/storage/box/syringes
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/zipties_box
	category = "security"
	name = "box of zipties"
	supplier = "NanoTrasen"
	description = "A box full of zipties."
	price = 145
	items = list(
		/obj/item/storage/box/zipties
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/brownwebbingvest
	category = "engineering"
	name = "brown webbing vest"
	supplier = "NanoTrasen"
	description = "Worn brownish synthcotton vest with lots of pockets to unload your hands."
	price = 83
	items = list(
		/obj/item/clothing/accessory/storage/brown_vest
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/bucket
	category = "supply"
	name = "bucket"
	supplier = "blm"
	description = "It's a bucket."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/bucket
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/bullpupassaultcarbine
	category = "security"
	name = "bullpup assault carbine"
	supplier = "NanoTrasen"
	description = "The Z8 Bulldog bullpup carbine, made by the now defunct Zendai Foundries. Uses armor piercing 5.56mm rounds."
	price = 8650
	items = list(
		/obj/item/gun/projectile/automatic/rifle/z8
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/camera
	category = "operations"
	name = "camera"
	supplier = "NanoTrasen"
	description = "A polaroid camera. 10 photos left."
	price = 80
	items = list(
		/obj/item/device/camera
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/canister_air
	category = "engineering"
	name = "Canister (Air)"
	supplier = "NanoTrasen"
	description = "Holds gas. Has a built-in valve to allow for filling portable tanks."
	price = 1500
	items = list(
		/obj/machinery/portable_atmospherics/canister/air
	)
	access = 10
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/canister_bo
	category = "engineering"
	name = "Canister (boron)"
	supplier = "NanoTrasen"
	description = "Holds gas. Has a built-in valve to allow for filling portable tanks."
	price = 1500
	items = list(
		/obj/machinery/portable_atmospherics/canister/boron
	)
	access = 10
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/canister_co2
	category = "engineering"
	name = "Canister (CO2)"
	supplier = "NanoTrasen"
	description = "Holds gas. Has a built-in valve to allow for filling portable tanks."
	price = 1500
	items = list(
		/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	)
	access = 10
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/canister_h2
	category = "engineering"
	name = "Canister (Hydrogen)"
	supplier = "NanoTrasen"
	description = "Holds gas. Has a built-in valve to allow for filling portable tanks."
	price = 1500
	items = list(
		/obj/machinery/portable_atmospherics/canister/hydrogen
	)
	access = 10
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/canister_he
	category = "engineering"
	name = "Canister (Helium)"
	supplier = "NanoTrasen"
	description = "Holds gas. Has a built-in valve to allow for filling portable tanks."
	price = 1500
	items = list(
		/obj/machinery/portable_atmospherics/canister/helium
	)
	access = 10
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/canister_n2
	category = "engineering"
	name = "Canister (Nitrogen)"
	supplier = "NanoTrasen"
	description = "Holds gas. Has a built-in valve to allow for filling portable tanks."
	price = 1500
	items = list(
		/obj/machinery/portable_atmospherics/canister/nitrogen
	)
	access = 10
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/canister_n2o
	category = "engineering"
	name = "Canister (Nitrous Oxide)"
	supplier = "NanoTrasen"
	description = "Holds gas. Has a built-in valve to allow for filling portable tanks."
	price = 1500
	items = list(
		/obj/machinery/portable_atmospherics/canister/sleeping_agent
	)
	access = 10
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/canister_o2
	category = "engineering"
	name = "Canister (Oxygen)"
	supplier = "NanoTrasen"
	description = "Holds gas. Has a built-in valve to allow for filling portable tanks."
	price = 1500
	items = list(
		/obj/machinery/portable_atmospherics/canister/oxygen
	)
	access = 10
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/carbinemagazine_556
	category = "security"
	name = "carbine magazine (5.56mm)"
	supplier = "NanoTrasen"
	description = "A 5.56 ammo magazine fit for a carbine, not an assault rifle."
	price = 250
	items = list(
		/obj/item/ammo_magazine/a556/carbine
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/cardboardsheet
	category = "engineering"
	name = "cardboard sheet"
	supplier = "NanoTrasen"
	description = "A sheet of cardboard."
	price = 50
	items = list(
		/obj/item/stack/material/cardboard
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/cargotraintrolley
	category = "operations"
	name = "cargo train trolley"
	supplier = "NanoTrasen"
	description = "A cargo trolley for carrying cargo, NOT people."
	price = 1500
	items = list(
		/obj/vehicle/train/cargo/trolley
	)
	access = 31
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/cargotraintug
	category = "operations"
	name = "cargo train tug"
	supplier = "NanoTrasen"
	description = "A ridable electric car designed for pulling cargo trolleys."
	price = 500
	items = list(
		/obj/vehicle/train/cargo/engine
	)
	access = 31
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/carpet
	category = "engineering"
	name = "carpet"
	supplier = "NanoTrasen"
	description = "A piece of carpet. It is the same size as a normal floor tile!"
	price = 8
	items = list(
		/obj/item/stack/tile/carpet
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/cat
	category = "hydroponics"
	name = "cat"
	supplier = "Getmore Products"
	description = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	price = 300
	items = list(
		/mob/living/simple_animal/cat
	)
	access = 0
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/cautery
	category = "medical"
	name = "cautery"
	supplier = "NanoTrasen"
	description = "This stops bleeding."
	price = 165
	items = list(
		/obj/item/surgery/cautery
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chainsaw
	category = "hydroponics"
	name = "chainsaw"
	supplier = "NanoTrasen"
	description = "A portable mechanical saw commonly used to fell trees."
	price = 600
	items = list(
		/obj/item/material/twohanded/chainsaw
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge
	category = "science"
	name = "chemical cartridge"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is empty and thus, boring."
	price = 25
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_acetone
	category = "science"
	name = "chemical cartridge-acetone"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/acetone
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_ale
	category = "hospitality"
	name = "chemical cartridge-ale"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/ale
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_aluminum
	category = "science"
	name = "chemical cartridge-aluminum"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/aluminum
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_ammonia
	category = "science"
	name = "chemical cartridge-ammonia"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/ammonia
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_beer
	category = "hospitality"
	name = "chemical cartridge-beer"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/beer
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_carbon
	category = "science"
	name = "chemical cartridge-carbon"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/carbon
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_champagne
	category = "hospitality"
	name = "chemical cartridge-champagne"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/champagne
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_coffee
	category = "hospitality"
	name = "chemical cartridge-coffee"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/coffee
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_cognac
	category = "hospitality"
	name = "chemical cartridge-cognac"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/cognac
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_cola
	category = "hospitality"
	name = "chemical cartridge-cola"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/cola
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_copper
	category = "science"
	name = "chemical cartridge-copper"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/copper
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_cream
	category = "hospitality"
	name = "chemical cartridge-cream"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/cream
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_drgibb
	category = "hospitality"
	name = "chemical cartridge-dr gibb"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/dr_gibb
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_dylovene
	category = "medical"
	name = "chemical cartridge-dylovene"
	supplier = "Interstellar Aid Corps"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 200
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/dylovene
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_ethanol
	category = "science"
	name = "chemical cartridge-ethanol"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/ethanol
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_gin
	category = "hospitality"
	name = "chemical cartridge-gin"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/gin
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_hydrazine
	category = "science"
	name = "chemical cartridge-hydrazine"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/hydrazine
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_hydrochloricacid
	category = "science"
	name = "chemical cartridge-hydrochloric acid"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/hclacid
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_ice
	category = "hospitality"
	name = "chemical cartridge-ice"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/ice
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_icetea
	category = "hospitality"
	name = "chemical cartridge-ice tea"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/icetea
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_inaprovaline
	category = "medical"
	name = "chemical cartridge-inaprovaline"
	supplier = "Interstellar Aid Corps"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 200
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/inaprov
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_iron
	category = "science"
	name = "chemical cartridge-iron"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/iron
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_kahlua
	category = "hospitality"
	name = "chemical cartridge-kahlua"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/kahlua
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_lemonlime
	category = "hospitality"
	name = "chemical cartridge-lemon lime"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/lemon_lime
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_lime
	category = "hospitality"
	name = "chemical cartridge-lime"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/lime
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_lithium
	category = "science"
	name = "chemical cartridge-lithium"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/lithium
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_mead
	category = "hospitality"
	name = "chemical cartridge-mead"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/mead
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_mercury
	category = "science"
	name = "chemical cartridge-mercury"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/mercury
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_orange
	category = "hospitality"
	name = "chemical cartridge-orange"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/orange
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_phosphorus
	category = "science"
	name = "chemical cartridge-phosphorus"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/phosphorus
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_potassium
	category = "science"
	name = "chemical cartridge-potassium"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/potassium
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_radium
	category = "science"
	name = "chemical cartridge-radium"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/radium
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_rum
	category = "hospitality"
	name = "chemical cartridge-rum"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/rum
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_silicon
	category = "science"
	name = "chemical cartridge-silicon"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/silicon
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_smw
	category = "hospitality"
	name = "chemical cartridge-smw"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/smw
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_sodawater
	category = "hospitality"
	name = "chemical cartridge-sodawater"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/sodawater
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_sodium
	category = "science"
	name = "chemical cartridge-sodium"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/sodium
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_spaceup
	category = "hospitality"
	name = "chemical cartridge-spaceup"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/spaceup
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_sugar
	category = "science"
	name = "chemical cartridge-sugar"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/sugar
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_sulfur
	category = "science"
	name = "chemical cartridge-sulfur"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/sulfur
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_sulfuricacid
	category = "science"
	name = "chemical cartridge-sulfuric acid"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/sacid
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_tea
	category = "hospitality"
	name = "chemical cartridge-tea"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/tea
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_tequila
	category = "hospitality"
	name = "chemical cartridge-tequila"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/tequila
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_thetamycin
	category = "medical"
	name = "chemical cartridge-thetamycin"
	supplier = "Interstellar Aid Corps"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 800
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/thetamycin
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_tonic
	category = "hospitality"
	name = "chemical cartridge-tonic"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/tonic
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_tungsten
	category = "science"
	name = "chemical cartridge-tungsten"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/tungsten
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_vermouth
	category = "hospitality"
	name = "chemical cartridge-vermouth"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/vermouth
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_vodka
	category = "hospitality"
	name = "chemical cartridge-vodka"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/vodka
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_water
	category = "science"
	name = "chemical cartridge-water"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 55
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/water
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_watermelon
	category = "hospitality"
	name = "chemical cartridge-watermelon"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/watermelon
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_whiskey
	category = "hospitality"
	name = "chemical cartridge-whiskey"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/whiskey
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chemicalcartridge_wine
	category = "hospitality"
	name = "chemical cartridge-wine"
	supplier = "Getmore Products"
	description = "A square plastic cartridge, this one is filled with 500 units of liquid."
	price = 35
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/wine
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chestdrawer
	category = "supply"
	name = "chest drawer"
	supplier = "NanoTrasen"
	description = "A large cabinet with drawers."
	price = 45
	items = list(
		/obj/structure/filingcabinet/chestdrawer
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/chicken
	category = "hydroponics"
	name = "chicken"
	supplier = "Getmore Products"
	description = "Adorable! They make such a racket though."
	price = 150
	items = list(
		/mob/living/simple_animal/chick
	)
	access = 0
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/chipmultipackcrate
	category = "hospitality"
	name = "chip multipack crate"
	supplier = "Getmore Products"
	description = "A Getmore supply crate of multipack chip bags."
	price = 400
	items = list(
		/obj/item/storage/box/fancy/chips,
		/obj/item/storage/box/fancy/chips/cucumber,
		/obj/item/storage/box/fancy/chips/chicken,
		/obj/item/storage/box/fancy/chips/dirtberry,
		/obj/item/storage/box/fancy/chips/phoron,
		/obj/item/storage/box/fancy/chips/variety
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/circuitboard_bubbleshield
	category = "engineering"
	name = "circuit board (bubble shield generator)"
	supplier = "NanoTrasen"
	description = "Looks like a circuit. Probably is."
	price = 1500
	items = list(
		/obj/item/circuitboard/shield_gen
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/circuitboard_hullshield
	category = "engineering"
	name = "circuit board (hull shield generator)"
	supplier = "NanoTrasen"
	description = "Looks like a circuit. Probably is."
	price = 1500
	items = list(
		/obj/item/circuitboard/shield_gen_ex
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/circuitboard_shieldcapacitor
	category = "engineering"
	name = "circuit board (shield capacitor)"
	supplier = "NanoTrasen"
	description = "Looks like a circuit. Probably is."
	price = 1500
	items = list(
		/obj/item/circuitboard/shield_cap
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/circuitboard_solarcontrol
	category = "engineering"
	name = "circuit board (solar control console)"
	supplier = "NanoTrasen"
	description = "Looks like a circuit. Probably is."
	price = 1500
	items = list(
		/obj/item/circuitboard/solar_control
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/circularsaw
	category = "medical"
	name = "circular saw"
	supplier = "NanoTrasen"
	description = "For heavy duty cutting."
	price = 195
	items = list(
		/obj/item/surgery/circular_saw
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/circulator
	category = "engineering"
	name = "circulator"
	supplier = "NanoTrasen"
	description = "A gas circulator turbine and heat exchanger. Its outlet port is to the south."
	price = 3750
	items = list(
		/obj/machinery/atmospherics/binary/circulator
	)
	access = 10
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/mining/classakineticaccelerator
	name = "Class A Kinetic Accelerator"
	supplier = "blm"
	description = "Contains a tactical KA frame, an experimental core KA power converter, a recoil reloading KA cell, and a upgrade chip - damage increase."
	price = 7999
	items = list(
		/obj/item/gun/custom_ka/frame05/prebuilt
	)
	access = 48
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/mining/classbkineticaccelerator
	name = "Class B Kinetic Accelerator"
	supplier = "blm"
	description = "Contains a heavy KA frame, a planet core KA power converter, a uranium recharging KA cell, and a upgrade chip - efficiency increase."
	price = 5599
	items = list(
		/obj/item/gun/custom_ka/frame04/prebuilt
	)
	access = 48
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/mining/classckineticaccelerator
	name = "Class C Kinetic Accelerator"
	supplier = "blm"
	description = "Contains a medium KA frame, a meteor core KA power converter, a kinetic KA cell, and a upgrade chip - focusing"
	price = 3299
	items = list(
		/obj/item/gun/custom_ka/frame03/prebuilt
	)
	access = 48
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/mining/classdkineticaccelerator
	name = "Class D Kinetic Accelerator"
	supplier = "blm"
	description = "Contains a light KA frame, a professional core KA power converter, an advanced pump recharging KA cell, and a upgrade chip - firedelay increase."
	price = 2299
	items = list(
		/obj/item/gun/custom_ka/frame02/prebuilt
	)
	access = 48
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/mining/classekineticaccelerator
	name = "Class E Kinetic Accelerator"
	supplier = "blm"
	description = "Contains a compact KA frame, a standard core KA power converter, a pump recharging KA cell, and a upgrade chip - focusing."
	price = 1499
	items = list(
		/obj/item/gun/custom_ka/frame01/prebuilt
	)
	access = 48
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/cleanergrenade
	category = "supply"
	name = "cleaner grenade"
	supplier = "blm"
	description = "BLAM!-brand foaming space cleaner. In a special applicator for rapid cleaning of wide areas."
	price = 225
	items = list(
		/obj/item/grenade/chem_grenade/cleaner
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/clipboard
	category = "supply"
	name = "clipboard"
	supplier = "NanoTrasen"
	description = "The timeless prop for looking like your working."
	price = 23
	items = list(
		/obj/item/clipboard
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/coathanger
	category = "operations"
	name = "Coat Hanger"
	supplier = "NanoTrasen"
	description = "To hang your coat"
	price = 150
	items = list(
		/obj/structure/coatrack
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/coffeeresupplycanister
	category = "operations"
	name = "coffee resupply canister"
	supplier = "blm"
	description = "A vending machine restock cart."
	price = 500
	items = list(
		/obj/item/device/vending_refill/coffee
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/colaresupplycanister
	category = "operations"
	name = "cola resupply canister"
	supplier = "blm"
	description = "A vending machine restock cart."
	price = 500
	items = list(
		/obj/item/device/vending_refill/cola
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/combatbelt
	category = "security"
	name = "combat belt"
	supplier = "Zharkov Shipping Company"
	description = "The only utility belt you will ever need."
	price = 300
	items = list(
		/obj/item/storage/belt/security/tactical
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/combatshotgun
	category = "security"
	name = "combat shotgun"
	supplier = "NanoTrasen"
	description = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders"
	price = 8250
	items = list(
		/obj/item/gun/projectile/shotgun/pump/combat
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/compacttungstenslug
	category = "security"
	name = "compact tungsten slug"
	supplier = "Zharkov Shipping Company"
	description = "A box with several compact tungsten slugs, aimed for use in gauss carbines."
	price = 500
	items = list(
		/obj/item/storage/box/tungstenslugs
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/coolanttank
	category = "engineering"
	name = "coolant tank"
	supplier = "NanoTrasen"
	description = "A tank of industrial coolant"
	price = 45
	items = list(
		/obj/structure/reagent_dispensers/coolanttank
	)
	access = 10
	container_type = "box"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/corgi
	category = "hydroponics"
	name = "corgi"
	supplier = "NanoTrasen"
	description = "Studies have shown corgis are the most well adapted canines in space, for some reason."
	price = 400
	items = list(
		/obj/structure/largecrate/animal/corgi
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/cow
	category = "hydroponics"
	name = "cow"
	supplier = "Getmore Products"
	description = "Known for their milk, just don't tip them over."
	price = 500
	items = list(
		/mob/living/simple_animal/cow
	)
	access = 0
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/crimescenekit
	category = "security"
	name = "crime scene kit"
	supplier = "NanoTrasen"
	description = "A stainless steel-plated carrycase for all of your forensic needs. This one is empty."
	price = 145
	items = list(
		/obj/item/storage/briefcase/crimekit
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/cutleryresupplycanister
	category = "operations"
	name = "cutlery resupply canister"
	supplier = "blm"
	description = "A vending machine restock cart."
	price = 500
	items = list(
		/obj/item/device/vending_refill/cutlery
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/debugger
	category = "operations"
	name = "Debugger"
	supplier = "NanoTrasen"
	description = "Used to debug electronic equipment."
	price = 50
	items = list(
		/obj/item/device/debugger
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 2

/singleton/cargo_item/deployablebarrier
	category = "security"
	name = "deployable barrier"
	supplier = "NanoTrasen"
	description = "A deployable barrier. Swipe your ID card to lock/unlock it."
	price = 750
	items = list(
		/obj/machinery/deployable/barrier
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/derringer
	category = "security"
	name = "derringer"
	supplier = "Zharkov Shipping Company"
	description = "A blast from the past that can fit in your pocket."
	price = 1250
	items = list(
		/obj/item/gun/projectile/revolver/derringer
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/disposalpipedispenser
	category = "engineering"
	name = "Disposal Pipe Dispenser"
	supplier = "NanoTrasen"
	description = "It dispenses bigger pipes for things to travel through. No, the pipes aren't green."
	price = 150
	items = list(
		/obj/machinery/pipedispenser/disposal/orderable
	)
	access = 10
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/disruptorpistol
	category = "security"
	name = "disruptor pistol"
	supplier = "NanoTrasen"
	description = "A Nanotrasen designed blaster pistol with two settings: stun and lethal."
	price = 500
	items = list(
		/obj/item/gun/energy/disruptorpistol
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/dryrag
	category = "hospitality"
	name = "dry rag"
	supplier = "blm"
	description = "For cleaning up messes, you suppose."
	price = 2
	items = list(
		/obj/item/reagent_containers/glass/rag
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/dylovenebottle
	category = "medical"
	name = "dylovene bottle"
	supplier = "NanoTrasen"
	description = "A small bottle of dylovene. Counters poisons, and repairs damage. A wonder drug."
	price = 20
	items = list(
		/obj/item/reagent_containers/glass/bottle/antitoxin
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/eftposscanner
	category = "operations"
	name = "EFTPOS scanner"
	supplier = "NanoTrasen"
	description = "Swipe your ID card to make purchases electronically."
	price = 45
	items = list(
		/obj/item/device/eftpos
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/eggcarton
	category = "supply"
	name = "egg carton"
	supplier = "Getmore Products"
	description = "Eggs from mostly chicken."
	price = 15
	items = list(
		/obj/item/storage/box/fancy/egg_box
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/electricaltoolbox
	category = "engineering"
	name = "electrical toolbox"
	supplier = "NanoTrasen"
	description = "Danger. Very robust."
	price = 930
	items = list(
		/obj/item/storage/toolbox/electrical
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/electronicblinktoygame
	category = "supply"
	name = "electronic blink toy game"
	supplier = "NanoTrasen"
	description = "Blink.  Blink.  Blink. Ages 8 and up."
	price = 200
	items = list(
		/obj/item/toy/blink
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/electronicfiringpin
	category = "security"
	name = "electronic firing pin"
	supplier = "NanoTrasen"
	description = "A small authentication device, to be inserted into a firearm receiver to allow operation."
	price = 2000
	items = list(
		/obj/item/device/firing_pin
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/emaccelerationchamber
	category = "engineering"
	name = "EM Acceleration Chamber"
	supplier = "NanoTrasen"
	description = "Part of a Particle Accelerator."
	price = 3000
	items = list(
		/obj/structure/particle_accelerator/fuel_chamber
	)
	access = 56
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/emcontainmentgridcenter
	category = "engineering"
	name = "EM Containment Grid Center"
	supplier = "NanoTrasen"
	description = "Part of a Particle Accelerator."
	price = 3000
	items = list(
		/obj/structure/particle_accelerator/particle_emitter/center
	)
	access = 56
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/emcontainmentgridleft
	category = "engineering"
	name = "EM Containment Grid Left"
	supplier = "NanoTrasen"
	description = "Part of a Particle Accelerator."
	price = 3000
	items = list(
		/obj/structure/particle_accelerator/particle_emitter/left
	)
	access = 56
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/emcontainmentgridright
	category = "engineering"
	name = "EM Containment Grid Right"
	supplier = "NanoTrasen"
	description = "Part of a Particle Accelerator."
	price = 3000
	items = list(
		/obj/structure/particle_accelerator/particle_emitter/right
	)
	access = 56
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/emergencybluespacerelaycircuit
	category = "engineering"
	name = "emergency bluespace relay circuit"
	supplier = "NanoTrasen"
	description = "Looks like a circuit. Probably is."
	price = 3000
	items = list(
		/obj/item/circuitboard/bluespacerelay
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/emitter
	category = "engineering"
	name = "emitter"
	supplier = "NanoTrasen"
	description = "It is a heavy duty industrial laser."
	price = 1500
	items = list(
		/obj/machinery/power/emitter
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/emptyspraybottle
	category = "operations"
	name = "empty spray bottle"
	supplier = "blm"
	description = "A empty spray bottle"
	price = 50
	items = list(
		/obj/item/reagent_containers/spray
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/energycarbine
	category = "security"
	name = "energy carbine"
	supplier = "NanoTrasen"
	description = "An energy-based carbine with two settings: Stun and kill."
	price = 2250
	items = list(
		/obj/item/gun/energy/gun
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/energypistol
	category = "security"
	name = "energy pistol"
	supplier = "NanoTrasen"
	description = "A basic energy-based pistol gun with two settings: Stun and kill."
	price = 1800
	items = list(
		/obj/item/gun/energy/pistol
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/doorlock_engineering
	category = "engineering"
	name = "engineering magnetic door lock - engineering"
	supplier = "NanoTrasen"
	description = "A large, ID locked device used for completely locking down airlocks. It is painted with Engineering colors."
	price = 135
	items = list(
		/obj/item/device/magnetic_lock/engineering
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/engineeringvoidsuit
	category = "engineering"
	name = "engineering voidsuit"
	supplier = "NanoTrasen"
	description = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	price = 4200
	items = list(
		/obj/item/clothing/suit/space/void/engineering
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/engineeringvoidsuithelmet
	category = "engineering"
	name = "engineering voidsuit helmet"
	supplier = "NanoTrasen"
	description = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	price = 2850
	items = list(
		/obj/item/clothing/head/helmet/space/void/engineering
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/exosuitmodulecircuitboard_odysseus_central
	category = "science"
	name = "exosuit module circuit board (Odysseus central control)"
	supplier = "NanoTrasen"
	description = "Looks like a circuit. Probably is."
	price = 1500
	items = list(
		/obj/item/circuitboard/mecha/odysseus/main
	)
	access = 29
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/exosuitmodulecircuitboard_odysseus_peripheral
	category = "science"
	name = "exosuit module circuit board (Odysseus peripherals control)"
	supplier = "NanoTrasen"
	description = "Looks like a circuit. Probably is."
	price = 1500
	items = list(
		/obj/item/circuitboard/mecha/odysseus/peripherals
	)
	access = 29
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/exosuitmodulecircuitboard_ripley_central
	category = "science"
	name = "exosuit module circuit board (Ripley central control)"
	supplier = "NanoTrasen"
	description = "Looks like a circuit. Probably is."
	price = 1500
	items = list(
		/obj/item/circuitboard/mecha/ripley/main
	)
	access = 29
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/exosuitmodulecircuitboard_ripley_peripheral
	category = "science"
	name = "exosuit module circuit board (Ripley peripherals control)"
	supplier = "NanoTrasen"
	description = "Looks like a circuit. Probably is."
	price = 1500
	items = list(
		/obj/item/circuitboard/mecha/ripley/peripherals
	)
	access = 29
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/farwacubebox
	category = "hydroponics"
	name = "farwa cube box"
	supplier = "NanoTrasen"
	description = "Drymate brand farwa cubes, shipped from Adhomai. Just add water!"
	price = 55
	items = list(
		/obj/item/storage/box/monkeycubes/farwacubes
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/fatshouter
	category = "hydroponics"
	name = "fatshouter"
	supplier = "NanoTrasen"
	description = "A crate containing a fatshouter."
	price = 500
	items = list(
		/obj/structure/largecrate/animal/adhomai/fatshouter
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/faxmachine
	category = "operations"
	name = "fax machine"
	supplier = "NanoTrasen"
	description = "Needed office equipment for any space based corporation to function"
	price = 300
	items = list(
		/obj/machinery/photocopier/faxmachine
	)
	access = 0
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/fibercollectionkit
	category = "security"
	name = "fiber collection kit"
	supplier = "NanoTrasen"
	description = "A magnifying glass and tweezers. Used to lift suit fibers."
	price = 115
	items = list(
		/obj/item/forensics/sample_kit
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/fieldgenerator
	category = "engineering"
	name = "Field Generator"
	supplier = "NanoTrasen"
	description = "A large thermal battery that projects a high amount of energy when powered."
	price = 1500
	items = list(
		/obj/machinery/field_generator
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/filmcartridge
	category = "operations"
	name = "film cartridge"
	supplier = "NanoTrasen"
	description = "A camera film cartridge. Insert it into a camera to reload it."
	price = 15
	items = list(
		/obj/item/device/camera_film
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/fingerprintpowder
	category = "security"
	name = "fingerprint powder"
	supplier = "NanoTrasen"
	description = "A jar containing aluminum powder and a specialized brush."
	price = 75
	items = list(
		/obj/item/forensics/sample_kit/powder
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/firefirstaidkit
	category = "medical"
	name = "fire first-aid kit"
	supplier = "NanoTrasen"
	description = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	price = 167
	items = list(
		/obj/item/storage/firstaid/fire
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/fireaxe
	category = "engineering"
	name = "fireaxe"
	supplier = "NanoTrasen"
	description = "The fire axe is a wooden handled axe with a heavy steel head intended for firefighting use."
	price = 1500
	items = list(
		/obj/item/material/twohanded/fireaxe
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/firstaidkit
	category = "medical"
	name = "first-aid kit"
	supplier = "NanoTrasen"
	description = "It's an emergency medical kit for those serious boo-boos."
	price = 157
	items = list(
		/obj/item/storage/firstaid/regular
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/fishfillet
	category = "hospitality"
	name = "fish fillet"
	supplier = "Getmore Products"
	description = "A fillet of fish."
	price = 15
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/fishfillet
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/fixovein
	category = "medical"
	name = "FixOVein"
	supplier = "NanoTrasen"
	description = "When life gives you internal bleeding, FixOVein is there."
	price = 495
	items = list(
		/obj/item/surgery/fix_o_vein
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/flare
	category = "operations"
	name = "flare"
	supplier = "NanoTrasen"
	description = "Good for illuminating dark areas or burning someones face off."
	price = 80
	items = list(
		/obj/item/device/flashlight/flare
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/flash
	category = "security"
	name = "flash"
	supplier = "NanoTrasen"
	description = "Used for blinding and being an asshole."
	price = 135
	items = list(
		/obj/item/device/flash
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/flask
	category = "hospitality"
	name = "flask"
	supplier = "Virgo Freight Carriers"
	description = "For those who can't be bothered to hang out at the bar to drink."
	price = 25
	items = list(
		/obj/item/reagent_containers/food/drinks/flask/barflask
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/floradiskbox
	category = "hydroponics"
	name = "flora disk box"
	supplier = "NanoTrasen"
	description = "A box of flora data disks, apparently."
	price = 660
	items = list(
		/obj/item/storage/box/botanydisk
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/floursack
	category = "supply"
	name = "flour sack"
	supplier = "Getmore Products"
	description = "A big bag of flour. Good for baking!"
	price = 2
	items = list(
		/obj/item/reagent_containers/food/condiment/flour
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/foamdart
	category = "supply"
	name = "foam dart"
	supplier = "NanoTrasen"
	description = "It's nerf or nothing! Ages 8 and up."
	price = 100
	items = list(
		/obj/item/toy/ammo/crossbow
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 5

/singleton/cargo_item/foamdartcrossbow
	category = "supply"
	name = "foam dart crossbow"
	supplier = "NanoTrasen"
	description = "A weapon favored by many overactive children. Ages 8 and up."
	price = 200
	items = list(
		/obj/item/toy/crossbow
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/folder
	category = "supply"
	name = "folder"
	supplier = "NanoTrasen"
	description = "A blue folder."
	price = 8
	items = list(
		/obj/item/folder/blue
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/folderblue
	category = "supply"
	name = "folder blue"
	supplier = "NanoTrasen"
	description = "A yellow folder."
	price = 8
	items = list(
		/obj/item/folder/yellow
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/folderred
	category = "supply"
	name = "folder red"
	supplier = "NanoTrasen"
	description = "A red folder."
	price = 8
	items = list(
		/obj/item/folder/red
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/formalwearcrate
	category = "operations"
	name = "formal wear crate"
	supplier = "NanoTrasen"
	description = "Formalwear for the best occasions."
	price = 800
	items = list(
		/obj/item/clothing/head/bowler,
		/obj/item/clothing/head/that,
		/obj/item/clothing/under/suit_jacket,
		/obj/item/clothing/under/suit_jacket/really_black,
		/obj/item/clothing/under/suit_jacket/red,
		/obj/item/clothing/under/suit_jacket/navy,
		/obj/item/clothing/under/suit_jacket/burgundy,
		/obj/item/clothing/shoes/sneakers/black,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/laceup/grey,
		/obj/item/clothing/suit/wcoat
	)
	access = 0
	container_type = "crate"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/franciscaapammo
	category = "supply"
	name = "francisca AP ammo"
	supplier = "npi"
	description = "A box of 40mm AP ammo."
	price = 1200
	items = list(
		/obj/item/ship_ammunition/grauwolf_bundle/ap
	)
	access = 31
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/franciscafmjammo
	category = "supply"
	name = "francisca FMJ ammo"
	supplier = "npi"
	description = "A box of 40mm FMJ ammo."
	price = 1000
	items = list(
		/obj/item/ship_ammunition/grauwolf_bundle
	)
	access = 31
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/fueltank
	category = "engineering"
	name = "fuel tank"
	supplier = "NanoTrasen"
	description = "A tank filled with welding fuel."
	price = 45
	items = list(
		/obj/structure/reagent_dispensers/fueltank
	)
	access = 10
	container_type = "box"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/gasmask
	category = "engineering"
	name = "gas mask"
	supplier = "NanoTrasen"
	description = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air."
	price = 75
	items = list(
		/obj/item/clothing/mask/gas
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/giftwrappingpaper
	category = "operations"
	name = "gift wrapping paper"
	supplier = "NanoTrasen"
	description = "You can use this to wrap items in."
	price = 8
	items = list(
		/obj/item/stack/wrapping_paper
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/glasssheets
	category = "engineering"
	name = "glass sheets"
	supplier = "NanoTrasen"
	description = "50 sheets of glass."
	price = 75
	items = list(
		/obj/item/stack/material/glass
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/goat
	category = "hydroponics"
	name = "goat"
	supplier = "Getmore Products"
	description = "Not known for their pleasant disposition."
	price = 400
	items = list(
		/mob/living/simple_animal/hostile/retaliate/goat
	)
	access = 0
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/goldschlager
	category = "hospitality"
	name = "Gold Schlager"
	supplier = "Zharkov Shipping Company"
	description = "A gold laced drink imported from noble houses within S'rand'marr."
	price = 46
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/goldschlager
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 2

/singleton/cargo_item/grauwolfapflak
	category = "supply"
	name = "grauwolf AP flak"
	supplier = "npi"
	description = "Armor-Piercing shells for a flak battery."
	price = 2500
	items = list(
		/obj/item/ship_ammunition/grauwolf_bundle/ap
	)
	access = 31
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/grauwolfheflak
	category = "supply"
	name = "grauwolf HE flak"
	supplier = "npi"
	description = "High-explosive shells for a flak battery."
	price = 2000
	items = list(
		/obj/item/ship_ammunition/grauwolf_bundle
	)
	access = 31
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/gravitationalsingularitytoy
	category = "supply"
	name = "gravitational singularity toy"
	supplier = "NanoTrasen"
	description = "'Singulo' brand spinning toy."
	price = 200
	items = list(
		/obj/item/toy/spinningtoy
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/greenpaint
	category = "operations"
	name = "green paint"
	supplier = "NanoTrasen"
	description = "Green paint, a aesthetic replacement for grass."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/green
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/guitar
	category = "supply"
	name = "guitar"
	supplier = "NanoTrasen"
	description = "A plain guitar."
	price = 190
	items = list(
		/obj/item/device/synthesized_instrument/guitar
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/hakhma
	category = "hydroponics"
	name = "hakhma"
	supplier = "Getmore Products"
	description = "An oversized insect breed by Scarab colony ships, known for their milk."
	price = 600
	items = list(
		/mob/living/simple_animal/hakhma
	)
	access = 0
	container_type = "box"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/handlabeler
	category = "supply"
	name = "hand labeler"
	supplier = "NanoTrasen"
	description = "Yes, it has your name on it!"
	price = 8
	items = list(
		/obj/item/device/hand_labeler
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/hardhat
	category = "engineering"
	name = "hard hat"
	supplier = "NanoTrasen"
	description = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	price = 35
	items = list(
		/obj/item/clothing/head/hardhat
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/hazardvest
	category = "engineering"
	name = "hazard vest"
	supplier = "NanoTrasen"
	description = "A high-visibility vest used in work zones."
	price = 90
	items = list(
		/obj/item/clothing/suit/storage/hazardvest
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/hazmathood
	category = "science"
	name = "hazmat hood"
	supplier = "NanoTrasen"
	description = "This hood protects against biological hazards."
	price = 105
	items = list(
		/obj/item/clothing/head/hazmat/general
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/hazmatsuit
	category = "science"
	name = "hazmat suit"
	supplier = "NanoTrasen"
	description = "This suit protects against biological hazards."
	price = 105
	items = list(
		/obj/item/clothing/suit/hazmat/general
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/hemostat
	category = "medical"
	name = "hemostat"
	supplier = "NanoTrasen"
	description = "You think you have seen this before."
	price = 135
	items = list(
		/obj/item/surgery/hemostat
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/highcapacitypowercell
	category = "engineering"
	name = "high-capacity power cell"
	supplier = "NanoTrasen"
	description = "A rechargable electrochemical power cell."
	price = 240
	items = list(
		/obj/item/cell/high
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/highpowerlongbowprimer
	category = "supply"
	name = "high-power longbow primer"
	supplier = "npi"
	description = "A high-power primer for a 406mm warhead."
	price = 1500
	items = list(
		/obj/item/primer/high
	)
	access = 31
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/hmatrrafillet
	category = "operations"
	name = "Hma'trra fillet"
	supplier = "Zharkov Shipping Company"
	description = "A fillet of glacier worm meat."
	price = 45
	items = list(
		/obj/item/reagent_containers/food/snacks/hmatrrameat
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/hoistkit
	category = "engineering"
	name = "hoist kit"
	supplier = "NanoTrasen"
	description = "A setup kit for a hoist that can be used to lift things. The hoist will deploy in the direction you're facing."
	price = 225
	items = list(
		/obj/item/hoist_kit
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/holographicammodisplay
	category = "security"
	name = "holographic ammo display"
	supplier = "NanoTrasen"
	description = "A device that can be attached to most firearms, providing a holographic display of the remaining ammunition to the user."
	price = 200
	items = list(
		/obj/item/ammo_display
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/honeyextractor
	category = "hydroponics"
	name = "honey extractor"
	supplier = "NanoTrasen"
	description = "Needed equipment to extract sweet liquid gold."
	price = 300
	items = list(
		/obj/machinery/honey_extractor
	)
	access = 0
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/hydroresupplycanister
	category = "operations"
	name = "hydro resupply canister"
	supplier = "blm"
	description = "A vending machine restock cart."
	price = 500
	items = list(
		/obj/item/device/vending_refill/hydro
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/hydrogentank
	category = "engineering"
	name = "hydrogen tank"
	supplier = "Hephaestus Industries"
	description = "Contains gaseous hydrogen. Do not inhale. Warning: extremely flammable."
	price = 500
	items = list(
		/obj/item/tank/hydrogen
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/hydroponicstray
	category = "hydroponics"
	name = "hydroponics tray"
	supplier = "NanoTrasen"
	description = "A safe space to raise your plants"
	price = 45
	items = list(
		/obj/machinery/portable_atmospherics/hydroponics
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/hyronalinbottle
	category = "medical"
	name = "hyronalin bottle"
	supplier = "NanoTrasen"
	description = "A small bottle. Contains hyronalin - used to treat radiation poisoning."
	price = 1000
	items = list(
		/obj/item/reagent_containers/glass/bottle/hyronalin
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/icetunneler
	category = "hydroponics"
	name = "ice tunneler"
	supplier = "NanoTrasen"
	description = "A crate containing a ice tunneler."
	price = 300
	items = list(
		/obj/structure/largecrate/animal/adhomai
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/igniter
	category = "science"
	name = "igniter"
	supplier = "NanoTrasen"
	description = "A small electronic device able to ignite combustable substances."
	price = 23
	items = list(
		/obj/item/device/assembly/igniter
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/inaprovalinebottle
	category = "medical"
	name = "inaprovaline bottle"
	supplier = "NanoTrasen"
	description = "A small bottle. Contains inaprovaline - used to stabilize patients."
	price = 25
	items = list(
		/obj/item/reagent_containers/glass/bottle/inaprovaline
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/mining/industrialminingdrill
	name = "Industrial Mining Drill"
	supplier = "blm"
	description = "A large industrial drill. Its bore does not penetrate deep enough to access the sublevels."
	price = 4000
	items = list(
		/obj/machinery/mining/drill,
		/obj/machinery/mining/brace,
		/obj/machinery/mining/brace
	)
	access = 48
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/inflatablebarrierbox
	category = "engineering"
	name = "inflatable barrier box"
	supplier = "NanoTrasen"
	description = "Contains inflatable walls and doors."
	price = 360
	items = list(
		/obj/item/storage/bag/inflatable
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/inflatableduck
	category = "supply"
	name = "inflatable duck"
	supplier = "NanoTrasen"
	description = "No bother to sink or swim when you can just float!"
	price = 200
	items = list(
		/obj/item/inflatable_duck
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/insulatedgloves
	category = "engineering"
	name = "insulated gloves"
	supplier = "NanoTrasen"
	description = "These gloves will protect the wearer from electric shock."
	price = 450
	items = list(
		/obj/item/clothing/gloves/yellow
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/ionrifle
	category = "security"
	name = "ion rifle"
	supplier = "NanoTrasen"
	description = "The NT Mk60 EW Halicon is a man portable anti-armor weapon designed to disable mechanical threats, produced by NT."
	price = 3000
	items = list(
		/obj/item/gun/energy/rifle/ionrifle
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/operations/ipc/shelltagimplanter
	name = "IPC/Shell tag implanter"
	supplier = "NanoTrasen"
	description = "A special implanter used for implanting synthetics with a special tag."
	price = 120
	items = list(
		/obj/item/implanter/ipc_tag
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/jackboots
	category = "security"
	name = "jack boots"
	supplier = "NanoTrasen"
	description = "Classic law enforcement footwear, comes with handy knife holder for when you need to enforce law up close."
	price = 100
	items = list(
		/obj/item/clothing/shoes/jackboots
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/janitorialresupplyset
	category = "operations"
	name = "janitorial resupply set"
	supplier = "blm"
	description = "A set of items to restock the janitors closet"
	price = 2000
	items = list(
		/obj/structure/janitorialcart,
		/obj/structure/mopbucket,
		/obj/item/mop,
		/obj/item/storage/bag/trash,
		/obj/item/reagent_containers/spray/cleaner,
		/obj/item/reagent_containers/glass/rag,
		/obj/item/clothing/suit/caution,
		/obj/item/clothing/suit/caution,
		/obj/item/clothing/suit/caution,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/soap/nanotrasen
	)
	access = 0
	container_type = "crate"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/jukebox
	category = "operations"
	name = "juke box"
	supplier = "NanoTrasen"
	description = "A common sight in any modern space bar, this jukebox has all the space classics."
	price = 500
	items = list(
		/obj/machinery/media/jukebox
	)
	access = 0
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/kelotaneautoinjector
	category = "medical"
	name = "kelotane autoinjector"
	supplier = "NanoTrasen"
	description = "An autoinjector designed to treat burns."
	price = 1000
	items = list(
		/obj/item/reagent_containers/hypospray/autoinjector/kelotane
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/laserrifle
	category = "security"
	name = "laser rifle"
	supplier = "NanoTrasen"
	description = "A common laser weapon, designed to kill with concentrated energy blasts."
	price = 2250
	items = list(
		/obj/item/gun/energy/rifle/laser
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/leathergloves
	category = "hydroponics"
	name = "leather gloves"
	supplier = "Getmore Products"
	description = "These leather work gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	price = 9
	items = list(
		/obj/item/clothing/gloves/botanic_leather
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/lightreplacer
	category = "supply"
	name = "light replacer"
	supplier = "blm"
	description = "A device to automatically replace lights. Refill with working lightbulbs or sheets of glass."
	price = 135
	items = list(
		/obj/item/device/lightreplacer
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/loadbearingequipment
	category = "operations"
	name = "load bearing equipment"
	supplier = "NanoTrasen"
	description = "Used to hold things when you don't have enough hands."
	price = 83
	items = list(
		/obj/item/clothing/accessory/storage
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/longbowapwarhead
	category = "supply"
	name = "longbow AP warhead"
	supplier = "npi"
	description = "An armor-piercing 406mm warhead."
	price = 3500
	items = list(
		/obj/item/warhead/longbow/ap
	)
	access = 31
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/longbowcasing
	category = "supply"
	name = "longbow casing"
	supplier = "npi"
	description = "A casing for a 406mm warhead."
	price = 2000
	items = list(
		/obj/item/ship_ammunition/longbow
	)
	access = 31
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/longbowepwarhead
	category = "supply"
	name = "longbow EP warhead"
	supplier = "npi"
	description = "A bunker-buster 406mm warhead."
	price = 3500
	items = list(
		/obj/item/warhead/longbow/bunker
	)
	access = 31
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/longbowhewarhead
	category = "supply"
	name = "longbow HE warhead"
	supplier = "npi"
	description = "A high-explosive 406mm warhead."
	price = 3000
	items = list(
		/obj/item/warhead/longbow
	)
	access = 31
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/longbowwarheadprimer
	category = "supply"
	name = "longbow warhead primer"
	supplier = "npi"
	description = "A standard primer for a 406mm warhead."
	price = 1200
	items = list(
		/obj/item/primer
	)
	access = 31
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/lowpowerlongbowprimer
	category = "supply"
	name = "low-power longbow primer"
	supplier = "npi"
	description = "A low-power primer for a 406mm warhead."
	price = 1000
	items = list(
		/obj/item/primer/low
	)
	access = 31
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/luminolbottle
	category = "security"
	name = "luminol bottle"
	supplier = "NanoTrasen"
	description = "A bottle containing an odourless, colorless liquid."
	price = 115
	items = list(
		/obj/item/reagent_containers/spray/luminol
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/machinepistol
	category = "security"
	name = "machine pistol"
	supplier = "NanoTrasen"
	description = "The NI 550 Saber is a cheap self-defense weapon, mass-produced by Necropolis Industries for paramilitary and private use."
	price = 1300
	items = list(
		/obj/item/gun/projectile/automatic/wt550
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/magazine_45flash
	category = "security"
	name = "magazine (.45 flash)"
	supplier = "NanoTrasen"
	description = "A magazine for some kind of gun."
	price = 10
	items = list(
		/obj/item/ammo_magazine/c45m/flash
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/magazine_45
	category = "security"
	name = "magazine (.45)"
	supplier = "NanoTrasen"
	description = "A magazine for some kind of gun."
	price = 200
	items = list(
		/obj/item/ammo_magazine/c45m
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/magazine_556
	category = "security"
	name = "magazine (5.56mm)"
	supplier = "NanoTrasen"
	description = "A magazine for some kind of gun."
	price = 65
	items = list(
		/obj/item/ammo_magazine/a556
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/magazine_762
	category = "security"
	name = "magazine (7.62mm)"
	supplier = "Zharkov Shipping Company"
	description = "A magazine for some kind of gun."
	price = 70
	items = list(
		/obj/item/ammo_magazine/d762
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/magazine_9
	category = "security"
	name = "magazine (9mm)"
	supplier = "NanoTrasen"
	description = "A magazine for some kind of gun."
	price = 40
	items = list(
		/obj/item/ammo_magazine/mc9mm
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/maglight
	category = "security"
	name = "maglight"
	supplier = "NanoTrasen"
	description = "A heavy flashlight designed for security personnel."
	price = 20
	items = list(
		/obj/item/device/flashlight/maglight
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/magmale
	category = "hospitality"
	name = "Magm-ale"
	supplier = "Virgo Freight Carriers"
	description = "A true dorf's drink of choice."
	price = 12
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/small/ale
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/doorlock_security
	category = "security"
	name = "magnetic door lock - security"
	supplier = "NanoTrasen"
	description = "A large, ID locked device used for completely locking down airlocks. It is painted with Security colors."
	price = 135
	items = list(
		/obj/item/device/magnetic_lock/security
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/marksmanenergyrifle
	category = "security"
	name = "marksman energy rifle"
	supplier = "NanoTrasen"
	description = "The HI L.W.A.P. is an older design of Hephaestus Industries. A designated marksman rifle capable of shooting powerful ionized b愀猀琀猀"
	price = 9600
	items = list(
		/obj/item/gun/energy/sniperrifle
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/meadbarrel
	category = "hospitality"
	name = "mead barrel"
	supplier = "Virgo Freight Carriers"
	description = "A wooden mead barrel."
	price = 200
	items = list(
		/obj/structure/reagent_dispensers/keg/mead
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/meat
	category = "supply"
	name = "meat"
	supplier = "Getmore Products"
	description = "A slab of meat."
	price = 3
	items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/medicalaidset
	category = "medical"
	name = "medical aid set"
	supplier = "Interstellar Aid Corps"
	description = "A set of medical first aid kits"
	price = 2000
	items = list(
		/obj/item/storage/firstaid/regular,
		/obj/item/storage/firstaid/fire,
		/obj/item/storage/firstaid/toxin,
		/obj/item/storage/firstaid/o2,
		/obj/item/storage/firstaid/adv
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/medicalbelt
	category = "medical"
	name = "medical belt"
	supplier = "NanoTrasen"
	description = "Can hold various medical equipment."
	price = 75
	items = list(
		/obj/item/storage/belt/medical
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/medicalmask
	category = "medical"
	name = "medical mask"
	supplier = "NanoTrasen"
	description = "A close-fitting sterile mask that can be connected to an air supply."
	price = 105
	items = list(
		/obj/item/clothing/mask/breath/medical
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/medicalscrubs
	category = "medical"
	name = "medical scrubs"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "It's made of a special fiber that provides minor protection against biohazards. This one is in dark green."
	price = 75
	items = list(
		/obj/item/clothing/under/rank/medical/surgeon/zeng
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/medicalvoidsuit
	category = "medical"
	name = "medical voidsuit"
	supplier = "NanoTrasen"
	description = "A special suit that protects against hazardous, low pressure environments. Has minor radiation shielding."
	price = 4200
	items = list(
		/obj/item/clothing/suit/space/void/medical
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/medicalvoidsuithelmet
	category = "medical"
	name = "medical voidsuit helmet"
	supplier = "NanoTrasen"
	description = "A special helmet designed for work in a hazardous, low pressure environment. Has minor radiation shielding."
	price = 2850
	items = list(
		/obj/item/clothing/head/helmet/space/void/medical
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/medsresupplycanister
	category = "operations"
	name = "meds resupply canister"
	supplier = "blm"
	description = "A vending machine restock cart."
	price = 500
	items = list(
		/obj/item/device/vending_refill/meds
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/microscopeslidebox
	category = "security"
	name = "microscope slide box"
	supplier = "NanoTrasen"
	description = "It's just an ordinary box."
	price = 35
	items = list(
		/obj/item/storage/box/slides
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/mindshieldfiringpin
	category = "science"
	name = "mindshield firing pin"
	supplier = "NanoTrasen"
	description = "This implant-locked firing pin authorizes the weapon for only loyalty-implanted users."
	price = 2000
	items = list(
		/obj/item/device/firing_pin/implant/loyalty
	)
	access = 19
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/miningvoidsuit
	category = "supply"
	name = "mining voidsuit"
	supplier = "NanoTrasen"
	description = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating."
	price = 4200
	items = list(
		/obj/item/clothing/suit/space/void/mining
	)
	access = 48
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/miningvoidsuithelmet
	category = "supply"
	name = "mining voidsuit helmet"
	supplier = "NanoTrasen"
	description = "A special helmet designed for work in a hazardous, low pressure environment. Has reinforced plating."
	price = 2850
	items = list(
		/obj/item/clothing/head/helmet/space/void/mining
	)
	access = 48
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/moghresianmeat
	category = "hospitality"
	name = "moghresian meat"
	supplier = "Zharkov Shipping Company"
	description = "A slab of meat from an animal native to Moghes."
	price = 13
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/moghes
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/monkeycubebox
	category = "hydroponics"
	name = "monkey cube box"
	supplier = "NanoTrasen"
	description = "Drymate brand monkey cubes. Just add water!"
	price = 60
	items = list(
		/obj/item/storage/box/monkeycubes
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/mop
	category = "supply"
	name = "mop"
	supplier = "blm"
	description = "The world of janitalia wouldn't be complete without a mop."
	price = 8
	items = list(
		/obj/item/mop
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/mopbucket
	category = "supply"
	name = "mop bucket"
	supplier = "blm"
	description = "Fits onto a standard janitorial cart. Fill it with water, but don't forget a mop!"
	price = 40
	items = list(
		/obj/structure/mopbucket
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/nanopaste
	category = "medical"
	name = "nanopaste"
	supplier = "NanoTrasen"
	description = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	price = 2000
	items = list(
		/obj/item/stack/nanopaste
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/neaeracubebox
	category = "hydroponics"
	name = "neaera cube box"
	supplier = "NanoTrasen"
	description = "Drymate brand neaera cubes, shipped from Jargon 4. Just add water!"
	price = 65
	items = list(
		/obj/item/storage/box/monkeycubes/neaeracubes
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/oxygendeprivationfirstaid
	category = "medical"
	name = "oxygen deprivation first aid"
	supplier = "NanoTrasen"
	description = "A box full of oxygen goodies."
	price = 242
	items = list(
		/obj/item/storage/firstaid/o2
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/packagewrapper
	category = "operations"
	name = "package wrapper"
	supplier = "NanoTrasen"
	description = "A roll of paper used to enclose an object for delivery."
	price = 8
	items = list(
		/obj/item/stack/packageWrap
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/packagedantimatterreactorsection
	category = "engineering"
	name = "packaged antimatter reactor section"
	supplier = "een"
	description = "A section of antimatter reactor shielding. Do not eat."
	price = 1000
	items = list(
		/obj/item/device/am_shielding_container
	)
	access = 56
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/packetofdionanodes
	category = "hydroponics"
	name = "packet of diona nodes"
	supplier = "NanoTrasen"
	description = "It has a picture of replicant pods on the front."
	price = 15
	items = list(
		/obj/item/seeds/replicapod
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/packetofkudzuseeds
	category = "hydroponics"
	name = "packet of kudzu seeds"
	supplier = "NanoTrasen"
	description = "It has a picture of kudzu vines on the front."
	price = 15
	items = list(
		/obj/item/seeds/kudzuseed
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/packetofstrangeplantnodes
	category = "hydroponics"
	name = "packet of strange plant nodes"
	supplier = "NanoTrasen"
	description = "It has a picture of strange plants on the front."
	price = 15
	items = list(
		/obj/item/seeds/random
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/paintgun
	category = "engineering"
	name = "paint gun"
	supplier = "NanoTrasen"
	description = "Useful for designating areas and pissing off coworkers"
	price = 135
	items = list(
		/obj/item/device/paint_sprayer
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/paperbin
	category = "supply"
	name = "paper bin"
	supplier = "NanoTrasen"
	description = "A bin filled with paper"
	price = 8
	items = list(
		/obj/item/paper_bin
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/particleacceleratorcontrolcomputer
	category = "engineering"
	name = "Particle Accelerator Control Computer"
	supplier = "NanoTrasen"
	description = "This controls the density of the particles."
	price = 1500
	items = list(
		/obj/machinery/particle_accelerator/control_box
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/particlefocusingemlens
	category = "engineering"
	name = "Particle Focusing EM Lens"
	supplier = "NanoTrasen"
	description = "Part of a Particle Accelerator."
	price = 3000
	items = list(
		/obj/structure/particle_accelerator/power_box
	)
	access = 56
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/pda
	category = "operations"
	name = "PDA"
	supplier = "NanoTrasen"
	description = "The latest in portable microcomputer solutions from Thinktronic Systems, LTD."
	price = 90
	items = list(
		/obj/item/modular_computer/handheld/pda
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/pen
	category = "supply"
	name = "pen"
	supplier = "NanoTrasen"
	description = "It's a normal blue ink pen."
	price = 8
	items = list(
		/obj/item/pen/blue
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/penred
	category = "supply"
	name = "pen red"
	supplier = "NanoTrasen"
	description = "It's a normal red ink pen."
	price = 8
	items = list(
		/obj/item/pen/red
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/peppermill
	category = "supply"
	name = "pepper mill"
	supplier = "Getmore Products"
	description = "Often used to flavor food or make people sneeze."
	price = 1
	items = list(
		/obj/item/reagent_containers/food/condiment/shaker/peppermill
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/peridaxonautoinjector
	category = "medical"
	name = "peridaxon autoinjector"
	supplier = "NanoTrasen"
	description = "An autoinjector designed to treat minor organ damage."
	price = 1000
	items = list(
		/obj/item/reagent_containers/hypospray/autoinjector/peridaxon
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/photoalbum
	category = "operations"
	name = "Photo album"
	supplier = "NanoTrasen"
	description = "A place to store fond memories you made in space"
	price = 45
	items = list(
		/obj/item/storage/photo_album
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/photocopier
	category = "operations"
	name = "photo copier"
	supplier = "NanoTrasen"
	description = "When you're too lazy to write a copy yourself"
	price = 300
	items = list(
		/obj/machinery/photocopier
	)
	access = 0
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/piano
	category = "hospitality"
	name = "piano"
	supplier = "NanoTrasen"
	description = "Like a regular piano, but always in tune! Even if the musician isn't."
	price = 1200
	items = list(
		/obj/structure/synthesized_instrument/synthesizer/piano
	)
	access = 0
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/pianosoundsynthesizer
	category = "hospitality"
	name = "pianosound synthesizer"
	supplier = "NanoTrasen"
	description = "A sound synthesizer"
	price = 1900
	items = list(
		/obj/structure/synthesized_instrument/synthesizer
	)
	access = 0
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/pillbottles
	category = "medical"
	name = "pill bottles"
	supplier = "NanoTrasen"
	description = "A storage box containing pill bottles"
	price = 155
	items = list(
		/obj/item/storage/pill_bottle
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/pipedispenser
	category = "engineering"
	name = "Pipe Dispenser"
	supplier = "NanoTrasen"
	description = "It dispenses pipes, no idea how though."
	price = 150
	items = list(
		/obj/machinery/pipedispenser/orderable
	)
	access = 10
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/pipepainter
	category = "engineering"
	name = "pipe painter"
	supplier = "NanoTrasen"
	description = "Its said that green pipes are safe to travel through"
	price = 135
	items = list(
		/obj/item/device/pipe_painter
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/pizzabox_margherita
	category = "hospitality"
	name = "pizza box, margherita"
	supplier = "Virgo Freight Carriers"
	description = "A box suited for pizzas."
	price = 50
	items = list(
		/obj/item/pizzabox/margherita
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/pizzabox_meat
	category = "hospitality"
	name = "pizza box, meat"
	supplier = "Virgo Freight Carriers"
	description = "A box suited for pizzas."
	price = 50
	items = list(
		/obj/item/pizzabox/meat
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/pizzabox_mushroom
	category = "hospitality"
	name = "pizza box, mushroom"
	supplier = "Virgo Freight Carriers"
	description = "A box suited for pizzas."
	price = 50
	items = list(
		/obj/item/pizzabox/mushroom
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/pizzabox_pineapple
	category = "hospitality"
	name = "pizza box, pineapple"
	supplier = "Virgo Freight Carriers"
	description = "A box suited for pizzas."
	price = 50
	items = list(
		/obj/item/pizzabox/pineapple
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/pizzabox_random
	category = "hospitality"
	name = "pizza box, random"
	supplier = "Virgo Freight Carriers"
	description = "A box suited for pizzas."
	price = 40
	items = list(
		/obj/random/pizzabox
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/pizzabox_vegetable
	category = "hospitality"
	name = "pizza box, vegetable"
	supplier = "Virgo Freight Carriers"
	description = "A box suited for pizzas."
	price = 50
	items = list(
		/obj/item/pizzabox/vegetable
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/plantanalyzer
	category = "hydroponics"
	name = "plant analyzer"
	supplier = "Getmore Products"
	description = "A hand-held environmental scanner which reports current gas levels."
	price = 135
	items = list(
		/obj/item/device/analyzer/plant_analyzer
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/plant_b_gone
	category = "hydroponics"
	name = "Plant-B-Gone"
	supplier = "Getmore Products"
	description = "Kills those pesky weeds!"
	price = 200
	items = list(
		/obj/item/reagent_containers/spray/plantbgone
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/plasteelsheets
	category = "engineering"
	name = "plasteel sheets"
	supplier = "NanoTrasen"
	description = "50 sheets of plasteel."
	price = 75
	items = list(
		/obj/item/stack/material/plasteel
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/plasticsheets
	category = "engineering"
	name = "plastic sheets"
	supplier = "NanoTrasen"
	description = "50 sheets of plastic."
	price = 50
	items = list(
		/obj/item/stack/material/plastic
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/platecarrier_ablative
	category = "security"
	name = "plate carrier - ablative"
	supplier = "NanoTrasen"
	description = "A plate carrier equipped with ablative armor plates"
	price = 1550
	items = list(
		/obj/item/clothing/suit/armor/carrier/ablative
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/platecarrier_ballistic
	category = "security"
	name = "plate carrier - ballistic"
	supplier = "NanoTrasen"
	description = "A plate carrier equipped with ballistic armor plates"
	price = 1450
	items = list(
		/obj/item/clothing/suit/armor/carrier/ballistic
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/platecarrier_riot
	category = "security"
	name = "plate carrier - riot"
	supplier = "NanoTrasen"
	description = "A plate carrier equipped with riot armor plates"
	price = 1050
	items = list(
		/obj/item/clothing/suit/armor/carrier/riot
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/peac
	category = "security"
	name = "point entry anti-materiel cannon"
	supplier = "NanoTrasen"
	description = "An SCC-designed, man-portable cannon meant to neutralize mechanized threats."
	price = 1200
	items = list(
		/obj/item/gun/projectile/peac
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/polyguitar
	category = "supply"
	name = "polyguitar"
	supplier = "NanoTrasen"
	description = "A polyguitar, better than a plain guitar."
	price = 200
	items = list(
		/obj/item/device/synthesized_instrument/guitar/multi
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/portableladder
	category = "engineering"
	name = "portable ladder"
	supplier = "NanoTrasen"
	description = "A lightweight deployable ladder, which you can use to move up or down. Or alternatively, you can bash some faces in."
	price = 200
	items = list(
		/obj/item/ladder_mobile
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/positronicbrain
	category = "science"
	name = "positronic brain"
	supplier = "Hephaestus Industries"
	description = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	price = 2000
	items = list(
		/obj/item/device/mmi/digital/posibrain
	)
	access = 29
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/powercell
	category = "engineering"
	name = "power cell"
	supplier = "NanoTrasen"
	description = "A rechargable electrochemical power cell."
	price = 90
	items = list(
		/obj/item/cell
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/producebox
	category = "supply"
	name = "produce box"
	supplier = "NanoTrasen"
	description = "A large box of random, leftover produce."
	price = 50
	items = list(
		/obj/item/storage/box/produce
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/protohuman
	category = "science"
	name = "Proto-Human"
	supplier = "npi"
	description = "A brain dead, generic human clone"
	price = 2000
	items = list(
		/mob/living/carbon/human
	)
	access = 47
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/proto_skrell
	category = "science"
	name = "Proto-Skrell"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A brain dead, generic skrell clone"
	price = 2000
	items = list(
		/mob/living/carbon/human/skrell
	)
	access = 47
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/proto_tajara
	category = "science"
	name = "Proto-Tajara"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A brain dead, generic tajara clone"
	price = 2000
	items = list(
		/mob/living/carbon/human/tajaran
	)
	access = 47
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/proto_unathi
	category = "science"
	name = "Proto-Unathi"
	supplier = "npi"
	description = "A brain dead, generic unathi clone"
	price = 2000
	items = list(
		/mob/living/carbon/human/unathi
	)
	access = 47
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/proximitysensor
	category = "science"
	name = "proximity sensor"
	supplier = "NanoTrasen"
	description = "Used for scanning and alerting when someone enters a certain proximity."
	price = 75
	items = list(
		/obj/item/device/assembly/prox_sensor
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/purplepaint
	category = "operations"
	name = "purple paint"
	supplier = "NanoTrasen"
	description = "Purple paint, it makes you feel like royalty."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/purple
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/queenbeepack
	category = "hydroponics"
	name = "queen bee pack"
	supplier = "NanoTrasen"
	description = "Contains one queen bee, bee kingdom not included."
	price = 150
	items = list(
		/obj/item/bee_pack
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/radiationhood
	category = "engineering"
	name = "radiation Hood"
	supplier = "NanoTrasen"
	description = "A hood with radiation protective properties. Label: Made with lead, do not eat insulation"
	price = 375
	items = list(
		/obj/item/clothing/head/radiation
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/radiationsuit
	category = "engineering"
	name = "radiation suit"
	supplier = "NanoTrasen"
	description = "A suit that protects against radiation. Label: Made with lead, do not eat insulation."
	price = 675
	items = list(
		/obj/item/clothing/suit/radiation
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/randomplushies
	category = "supply"
	name = "random plushies"
	supplier = "NanoTrasen"
	description = "Four random plushies. Barely used."
	price = 800
	items = list(
		/obj/random/plushie
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 4

/singleton/cargo_item/redlasertagequipmentset
	category = "supply"
	name = "red laser tag equipment set"
	supplier = "NanoTrasen"
	description = "A set of red laser tag equipment consisting of helmet, armor and gun"
	price = 200
	items = list(
		/obj/item/clothing/head/helmet/riot/laser_tag,
		/obj/item/clothing/suit/armor/riot/laser_tag,
		/obj/item/gun/energy/lasertag/red
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/redlipstick
	category = "hospitality"
	name = "red lipstick"
	supplier = "NanoTrasen"
	description = "A generic brand of lipstick."
	price = 8
	items = list(
		/obj/item/lipstick/random
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/redpaint
	category = "operations"
	name = "red paint"
	supplier = "NanoTrasen"
	description = "Red paint, its not blood we promise."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/red
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/replicakatana
	category = "supply"
	name = "replica katana"
	supplier = "NanoTrasen"
	description = "A cheap plastic katana that luckily isn't sharp enough to accidentally cut your floor length braid. Woefully underpowered in D20."
	price = 200
	items = list(
		/obj/item/toy/katana
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/researchshuttleconsoleboard
	category = "engineering"
	name = "research shuttle console board"
	supplier = "NanoTrasen"
	description = "A replacement board for the research shuttle console, in case the original console is destroyed"
	price = 500
	items = list(
		/obj/item/circuitboard/research_shuttle
	)
	access = 1
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/retractor
	category = "medical"
	name = "retractor"
	supplier = "NanoTrasen"
	description = "Retracts stuff."
	price = 115
	items = list(
		/obj/item/surgery/retractor
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/retrolaser
	category = "security"
	name = "retro laser"
	supplier = "Zharkov Shipping Company"
	description = "Popular with space pirates and people who think they are space pirates."
	price = 1000
	items = list(
		/obj/item/gun/energy/retro
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/riothelmet
	category = "security"
	name = "riot helmet"
	supplier = "NanoTrasen"
	description = "It's a helmet specifically designed to protect against close range attacks."
	price = 750
	items = list(
		/obj/item/clothing/head/helmet/riot
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/riotshield
	category = "security"
	name = "riot shield"
	supplier = "NanoTrasen"
	description = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	price = 225
	items = list(
		/obj/item/shield/riot
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/robotoolsresupplycanister
	category = "operations"
	name = "robo-tools resupply canister"
	supplier = "blm"
	description = "A vending machine restock cart."
	price = 500
	items = list(
		/obj/item/device/vending_refill/robo
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/roesack
	category = "hospitality"
	name = "roe sack"
	supplier = "Getmore Products"
	description = "A fleshy organ filled with fish eggs."
	price = 16
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/roe
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/poster19
	category = "operations"
	name = "rolled-up poster - No. 19"
	supplier = "NanoTrasen"
	description = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	price = 38
	items = list(
		/obj/item/contraband/poster
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/saltshaker
	category = "supply"
	name = "salt shaker"
	supplier = "Getmore Products"
	description = "Salt. From space oceans, presumably."
	price = 1
	items = list(
		/obj/item/reagent_containers/food/condiment/shaker/salt
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/sampleoflibertycapspores
	category = "hydroponics"
	name = "sample of liberty cap spores"
	supplier = "NanoTrasen"
	description = "It's labelled as coming from liberty cap mushrooms."
	price = 15
	items = list(
		/obj/item/seeds/libertymycelium
	)
	access = 35
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/sampleofreishispores
	category = "hydroponics"
	name = "sample of reishi spores"
	supplier = "NanoTrasen"
	description = "It's labelled as coming from reishi."
	price = 15
	items = list(
		/obj/item/seeds/reishimycelium
	)
	access = 35
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/sarezhiwine
	category = "hospitality"
	name = "Sarezhi Wine"
	supplier = "Arizi Guild"
	description = "A premium Moghean wine made from Sareszhi berries. Bottled by the Arizi Guild for over 200 years."
	price = 60
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/scalpel
	category = "medical"
	name = "scalpel"
	supplier = "NanoTrasen"
	description = "Cut, cut, and once more cut."
	price = 100
	items = list(
		/obj/item/surgery/scalpel
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/schlorrgoegg
	category = "hydroponics"
	name = "schlorrgo egg"
	supplier = "Zharkov Shipping Company"
	description = "A large egg that will eventually grow into a Schlorrgo."
	price = 700
	items = list(
		/obj/item/reagent_containers/food/snacks/egg/schlorrgo
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/sculptingblock
	name = "sculpting block"
	supplier = "NanoTrasen"
	description = "A finely chiselled sculpting block, it is ready to be your canvas."
	price = 200
	items = list(
		/obj/structure/sculpting_block
	)
	access = 0
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/securityresupplycanister
	category = "operations"
	name = "security resupply canister"
	supplier = "blm"
	description = "A vending machine restock cart."
	price = 500
	items = list(
		/obj/item/device/vending_refill/robust
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/securityvoidsuit
	category = "security"
	name = "security voidsuit"
	supplier = "NanoTrasen"
	description = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	price = 4500
	items = list(
		/obj/item/clothing/suit/space/void/security
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/securityvoidsuithelmet
	category = "security"
	name = "security voidsuit helmet"
	supplier = "NanoTrasen"
	description = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	price = 3000
	items = list(
		/obj/item/clothing/head/helmet/space/void/security
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/shaker
	category = "hospitality"
	name = "shaker"
	supplier = "Virgo Freight Carriers"
	description = "A metal shaker to mix drinks in."
	price = 22
	items = list(
		/obj/item/reagent_containers/food/drinks/shaker
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/shieldgenerator
	category = "security"
	name = "Shield Generator"
	supplier = "NanoTrasen"
	description = "A shield generator."
	price = 1500
	items = list(
		/obj/machinery/shieldwallgen
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/shoulderholster
	category = "operations"
	name = "shoulder holster"
	supplier = "NanoTrasen"
	description = "A handgun holster."
	price = 23
	items = list(
		/obj/item/clothing/accessory/holster
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/silencedpistol
	category = "security"
	name = "silenced pistol"
	supplier = "Zharkov Shipping Company"
	description = "Internally silenced for stealthy operations."
	price = 950
	items = list(
		/obj/item/gun/projectile/silenced
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/singularitygenerator
	category = "engineering"
	name = "Singularity Generator"
	supplier = "NanoTrasen"
	description = "Used to generate a Singularity. It is not adviced to use this on the asteroid."
	price = 20000
	items = list(
		/obj/machinery/the_singularitygen
	)
	access = 19
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/smokesresupplycanister
	category = "operations"
	name = "smokes resupply canister"
	supplier = "blm"
	description = "A vending machine restock cart."
	price = 500
	items = list(
		/obj/item/device/vending_refill/smokes
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/snacksresupplycanister
	category = "operations"
	name = "snacks resupply canister"
	supplier = "blm"
	description = "A vending machine restock cart."
	price = 967
	items = list(
		/obj/item/device/vending_refill/snack
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/snappop
	category = "supply"
	name = "snap pop"
	supplier = "NanoTrasen"
	description = "A number of snap pops"
	price = 200
	items = list(
		/obj/item/toy/snappop
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 5

/singleton/cargo_item/solarpanelassembly
	category = "engineering"
	name = "solar panel assembly"
	supplier = "NanoTrasen"
	description = "A solar panel assembly kit, allows constructions of a solar panel, or with a tracking circuit board, a solar tracker"
	price = 1020
	items = list(
		/obj/item/solar_assembly
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 5

/singleton/cargo_item/soporificbottle
	category = "medical"
	name = "soporific bottle"
	supplier = "NanoTrasen"
	description = "A small bottle of soporific. Just the fumes make you sleepy."
	price = 55
	items = list(
		/obj/item/reagent_containers/glass/bottle/stoxin
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/soymilk
	category = "supply"
	name = "soymilk"
	supplier = "Getmore Products"
	description = "It's soy milk. White and nutritious goodness!"
	price = 10
	items = list(
		/obj/item/reagent_containers/food/drinks/carton/soymilk
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/supply/spacea/c
	name = "space A/C"
	supplier = "NanoTrasen"
	description = "Made by Space Amish using traditional space techniques, this A/C unit can heat or cool a room to your liking."
	price = 200
	items = list(
		/obj/machinery/space_heater
	)
	access = 0
	container_type = "box"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/spacebeer
	category = "hospitality"
	name = "space beer"
	supplier = "NanoTrasen"
	description = "Contains only water, malt and hops."
	price = 2
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/small/beer
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/spacecleaner
	category = "supply"
	name = "space cleaner"
	supplier = "blm"
	description = "BLAM!-brand non-foaming space cleaner!"
	price = 297
	items = list(
		/obj/item/reagent_containers/spray/cleaner
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/spacemilk
	category = "supply"
	name = "space milk"
	supplier = "Getmore Products"
	description = "It's milk. White and nutritious goodness!"
	price = 10
	items = list(
		/obj/item/reagent_containers/food/drinks/carton/milk
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/spacespices
	category = "supply"
	name = "space spices"
	supplier = "Getmore Products"
	description = "An exotic blend of spices for cooking. It must flow."
	price = 60
	items = list(
		/obj/item/reagent_containers/food/condiment/shaker/spacespice
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/space_bike
	category = "operations"
	name = "space-bike"
	supplier = "Zharkov Shipping Company"
	description = "Space wheelies! Woo!"
	price = 1200
	items = list(
		/obj/vehicle/bike
	)
	access = 0
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/squidmeat
	category = "hospitality"
	name = "squid meat"
	supplier = "Getmore Products"
	description = "Soylent squid is (not) people!"
	price = 15
	items = list(
		/obj/item/reagent_containers/food/snacks/squidmeat
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/stasisbag
	category = "medical"
	name = "stasis bag"
	supplier = "NanoTrasen"
	description = "A folded, non-reusable bag designed to prevent additional damage to an occupant at the cost of genetic damage."
	price = 900
	items = list(
		/obj/item/bodybag/cryobag
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/steelhatchet
	category = "hydroponics"
	name = "steel hatchet"
	supplier = "Getmore Products"
	description = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for choppin 洀攀愀琀"
	price = 36
	items = list(
		/obj/item/material/hatchet
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/steelminihoe
	category = "hydroponics"
	name = "steel mini hoe"
	supplier = "Getmore Products"
	description = "It's used for removing weeds or scratching your back."
	price = 15
	items = list(
		/obj/item/material/minihoe
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/steelsheets
	category = "engineering"
	name = "steel sheets"
	supplier = "NanoTrasen"
	description = "50 sheets of steel."
	price = 75
	items = list(
		/obj/item/stack/material/steel
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/stokcubebox
	category = "hydroponics"
	name = "stok cube box"
	supplier = "NanoTrasen"
	description = "Drymate brand stok cubes, shipped from Moghes. Just add water!"
	price = 60
	items = list(
		/obj/item/storage/box/monkeycubes/stokcubes
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/stunbaton
	category = "security"
	name = "stunbaton"
	supplier = "NanoTrasen"
	description = "A stun baton for incapacitating people with."
	price = 120
	items = list(
		/obj/item/melee/baton
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/superconductivemagneticcoil
	category = "engineering"
	name = "superconductive magnetic coil"
	supplier = "NanoTrasen"
	description = "Standard superconductive magnetic coil with average capacity and I/O rating."
	price = 3000
	items = list(
		/obj/item/smes_coil
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/supermattercore
	category = "engineering"
	name = "Supermatter Core"
	supplier = "NanoTrasen"
	description = "A highly advanced energy source. A warning label states that it may only be used on the Aurora"
	price = 30000
	items = list(
		/obj/machinery/power/supermatter
	)
	access = 19
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/surgeryresupplyset
	category = "medical"
	name = "surgery resupply set"
	supplier = "Interstellar Aid Corps"
	description = "A set of surgical tools in case the original ones have been lost or misplaced"
	price = 2000
	items = list(
		/obj/item/surgery/scalpel,
		/obj/item/surgery/hemostat,
		/obj/item/surgery/retractor,
		/obj/item/surgery/circular_saw,
		/obj/item/surgery/cautery,
		/obj/item/surgery/surgicaldrill,
		/obj/item/surgery/bone_gel,
		/obj/item/surgery/bonesetter,
		/obj/item/surgery/fix_o_vein,
		/obj/item/stack/medical/advanced/bruise_pack
	)
	access = 45
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/surgicalcap
	category = "medical"
	name = "surgical cap"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is dark green."
	price = 75
	items = list(
		/obj/item/clothing/head/surgery/zeng
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/surgicaldrill
	category = "medical"
	name = "surgical drill"
	supplier = "NanoTrasen"
	description = "You can drill using this item. You dig?"
	price = 195
	items = list(
		/obj/item/surgery/surgicaldrill
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/tacticalarmor
	category = "security"
	name = "tactical armor"
	supplier = "Zharkov Shipping Company"
	description = "Surplus tactical armor imported straight from Sol"
	price = 6000
	items = list(
		/obj/item/clothing/suit/armor/tactical
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/tacticalhelmet
	category = "security"
	name = "tactical helmet"
	supplier = "Zharkov Shipping Company"
	description = "A surplus tactical helmet imported straight from Sol"
	price = 3000
	items = list(
		/obj/item/clothing/head/helmet/tactical
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/tacticalhud
	category = "security"
	name = "tactical hud"
	supplier = "Zharkov Shipping Company"
	description = "A tactical hud for tactical operations that ensures they proceed tactically."
	price = 200
	items = list(
		/obj/item/clothing/glasses/sunglasses/sechud/tactical
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/tacticaljumpsuit
	category = "security"
	name = "tactical jumpsuit"
	supplier = "Zharkov Shipping Company"
	description = "Tactical fatigues guaranteed to bring out the space marine in you"
	price = 200
	items = list(
		/obj/item/clothing/under/tactical
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/tajaranelectricalgloves
	category = "supply"
	name = "tajaran electrical gloves"
	supplier = "Zharkov Shipping Company"
	description = "These gloves will protect the wearer from electric shock. Made special for Tajaran use."
	price = 250
	items = list(
		/obj/item/clothing/gloves/yellow/specialt
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/tajaranlatexgloves
	category = "medical"
	name = "tajaran latex gloves"
	supplier = "Zharkov Shipping Company"
	description = "Sterile latex gloves. Designed for Tajara use."
	price = 8
	items = list(
		/obj/item/clothing/gloves/latex/tajara
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/taperoll
	category = "supply"
	name = "tape roll"
	supplier = "NanoTrasen"
	description = "A roll of sticky tape. Possibly for taping ducks... or was that ducts?"
	price = 8
	items = list(
		/obj/item/tape_roll
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/tasergun
	category = "security"
	name = "taser gun"
	supplier = "NanoTrasen"
	description = "The NT Mk30 NL is a small, low capacity gun used for non-lethal takedowns."
	price = 150
	items = list(
		/obj/item/gun/energy/taser
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/testrange_firingpin
	category = "science"
	name = "test-range firing pin"
	supplier = "NanoTrasen"
	description = "This safety firing pin allows weapons to be fired within proximity to a firing range."
	price = 500
	items = list(
		/obj/item/device/firing_pin/test_range
	)
	access = 47
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/therapydoll
	category = "medical"
	name = "therapy doll"
	supplier = "NanoTrasen"
	description = "A toy for therapeutic and recreational purposes."
	price = 200
	items = list(
		/obj/item/toy/plushie/therapy
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/thermoelectricgenerator
	category = "engineering"
	name = "thermoelectric generator"
	supplier = "NanoTrasen"
	description = "It's a high efficiency thermoelectric generator. Rated for 500 kW."
	price = 1500
	items = list(
		/obj/machinery/power/generator
	)
	access = 10
	container_type = "box"
	groupable = 0
	item_mul = 1

/singleton/cargo_item/timer
	category = "science"
	name = "timer"
	supplier = "NanoTrasen"
	description = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	price = 75
	items = list(
		/obj/item/device/assembly/timer
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/tonercartridge
	category = "supply"
	name = "toner cartridge"
	supplier = "NanoTrasen"
	description = "Toner is the back bone of any space based litigation"
	price = 135
	items = list(
		/obj/item/device/toner
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 2

/singleton/cargo_item/toolbelt
	category = "engineering"
	name = "tool-belt"
	supplier = "NanoTrasen"
	description = "Can hold various tools."
	price = 500
	items = list(
		/obj/item/storage/belt/utility/full
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/toolsresupplycanister
	category = "operations"
	name = "tools resupply canister"
	supplier = "blm"
	description = "A vending machine restock cart."
	price = 500
	items = list(
		/obj/item/device/vending_refill/tools
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/topmountedmagazine_9mmrubber
	category = "security"
	name = "top mounted magazine (9mm rubber)"
	supplier = "NanoTrasen"
	description = "A magazine for some kind of gun."
	price = 25
	items = list(
		/obj/item/ammo_magazine/mc9mmt/rubber
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/torso_bishop
	category = "science"
	name = "Torso - Bishop Cybernetics"
	supplier = "Bishop Cybernetics"
	description = "A bishop cybernetics torso"
	price = 4000
	items = list(
		/obj/item/robot_parts/chest/bishop
	)
	access = 29
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/torso_g1
	category = "science"
	name = "Torso - Hephaestus G1 Industrial Frame"
	supplier = "Hephaestus Industries"
	description = "A torso for a Hephaestus G1 Industrial Frame"
	price = 3500
	items = list(
		/obj/item/robot_parts/chest/industrial
	)
	access = 29
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/torso_g2
	category = "science"
	name = "Torso - Hephaestus G2 Industrial Frame"
	supplier = "Hephaestus Industries"
	description = "A torso for a Hephaestus G2 Industrial Frame"
	price = 5000
	items = list(
		/obj/item/robot_parts/chest/hephaestus
	)
	access = 29
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/torso_heph
	category = "science"
	name = "Torso - Hephaestus Integrated"
	supplier = "Hephaestus Industries"
	description = "A torso for a Hephaestus Integrated Frame"
	price = 3000
	items = list(
		/obj/item/robot_parts/chest/ipc
	)
	access = 29
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/torso_synthskin
	category = "science"
	name = "Torso - Synthskin"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A synthskin torso"
	price = 9000
	items = list(
		/obj/item/robot_parts/chest/synthskin
	)
	access = 29
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/torso_xion
	category = "science"
	name = "Torso - Xion Manufacturing"
	supplier = "Xion Manufacturing"
	description = "A Xion Manufacturing torso"
	price = 4500
	items = list(
		/obj/item/robot_parts/chest/xion
	)
	access = 29
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/torso_zenghu
	category = "science"
	name = "Torso - Zeng-Hu Pharmaceuticals"
	supplier = "Zeng-Hu Pharmaceuticals"
	description = "A Zeng-Hu Pharmaceuticals torso"
	price = 3000
	items = list(
		/obj/item/robot_parts/chest/zenghu
	)
	access = 29
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/toxinfirstaid
	category = "medical"
	name = "toxin first aid"
	supplier = "NanoTrasen"
	description = "Used to treat when you have a high amount of toxins in your body."
	price = 212
	items = list(
		/obj/item/storage/firstaid/toxin
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/toysword
	category = "supply"
	name = "toy sword"
	supplier = "NanoTrasen"
	description = "A cheap, plastic replica of a blue energy sword. Realistic sounds and colors! Ages 8 and up."
	price = 200
	items = list(
		/obj/item/toy/sword
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/trackerelectronics
	category = "engineering"
	name = "tracker electronics"
	supplier = "NanoTrasen"
	description = "Electronic guidance systems for a solar array"
	price = 225
	items = list(
		/obj/item/tracker_electronics
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/tranquilizerdarts_50cal_pps
	category = "security"
	name = "tranquilizer darts (.50 cal PPS)"
	supplier = "NanoTrasen"
	description = "A magazine for some kind of gun."
	price = 45
	items = list(
		/obj/item/storage/box/tranquilizer
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/trashbag
	category = "supply"
	name = "trash bag"
	supplier = "blm"
	description = "It's the heavy-duty black polymer kind. Time to take out the trash!"
	price = 20
	items = list(
		/obj/item/storage/bag/trash
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/triglyceridebottle
	category = "medical"
	name = "triglyceride bottle"
	supplier = "Virgo Freight Carriers"
	description = "A small bottle. Contains triglyceride."
	price = 50
	items = list(
		/obj/item/reagent_containers/glass/bottle/triglyceride
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/trumpet
	category = "supply"
	name = "trumpet"
	supplier = "NanoTrasen"
	description = "An old trumpet."
	price = 300
	items = list(
		/obj/item/device/synthesized_instrument/trumpet
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/unathielectricalgloves
	category = "supply"
	name = "unathi electrical gloves"
	supplier = "Arizi Guild"
	description = "These gloves will protect the wearer from electric shock. Made special for Unathi use."
	price = 250
	items = list(
		/obj/item/clothing/gloves/yellow/specialu
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/unathilatexgloves
	category = "medical"
	name = "unathi latex gloves"
	supplier = "Arizi Guild"
	description = "Sterile latex gloves. Designed for Unathi use."
	price = 8
	items = list(
		/obj/item/clothing/gloves/latex/unathi
	)
	access = 5
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/universalenzyme
	category = "supply"
	name = "universal enzyme"
	supplier = "Getmore Products"
	description = "Used in cooking various dishes."
	price = 10
	items = list(
		/obj/item/reagent_containers/food/condiment/enzyme
	)
	access = 0
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/uvlight
	category = "security"
	name = "UV light"
	supplier = "NanoTrasen"
	description = "A small handheld black light."
	price = 115
	items = list(
		/obj/item/device/uv_light
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/violin
	category = "supply"
	name = "violin"
	supplier = "NanoTrasen"
	description = "A wooden musical instrument with four strings and a bow."
	price = 250
	items = list(
		/obj/item/device/synthesized_instrument/violin
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/vkrexicubebox
	category = "hydroponics"
	name = "vkrexi cube box"
	supplier = "NanoTrasen"
	description = "Drymate brand vkrexi cubes. Just add water!"
	price = 60
	items = list(
		/obj/item/storage/box/monkeycubes/vkrexicubes
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/waterballoons
	category = "supply"
	name = "water balloons"
	supplier = "NanoTrasen"
	description = "Five Empty translucent balloons"
	price = 200
	items = list(
		/obj/item/toy/balloon
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 5

/singleton/cargo_item/watertank
	category = "engineering"
	name = "watertank"
	supplier = "NanoTrasen"
	description = "A tank filled with water."
	price = 45
	items = list(
		/obj/structure/reagent_dispensers/watertank
	)
	access = 10
	container_type = "box"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/webbing
	category = "operations"
	name = "webbing"
	supplier = "NanoTrasen"
	description = "Sturdy mess of synthcotton belts and buckles, ready to share your burden."
	price = 83
	items = list(
		/obj/item/clothing/accessory/storage/webbing
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/weedkillergrenade
	category = "hydroponics"
	name = "weedkiller grenade"
	supplier = "Getmore Products"
	description = "Used for purging large areas of invasive plant species. Contents under pressure. Do not directly inhale contents."
	price = 225
	items = list(
		/obj/item/grenade/chem_grenade/antiweed
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/weldinghelmet
	category = "engineering"
	name = "welding helmet"
	supplier = "NanoTrasen"
	description = "A head-mounted face cover designed to protect the wearer completely from space-arc eye."
	price = 225
	items = list(
		/obj/item/clothing/head/welding
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/wetfloorsign
	category = "supply"
	name = "wet floor sign"
	supplier = "blm"
	description = "Caution! Wet Floor!"
	price = 15
	items = list(
		/obj/item/clothing/suit/caution
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/whitepaint
	category = "operations"
	name = "white paint"
	supplier = "NanoTrasen"
	description = "White paint, perfect for sterile boring lab environments."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/white
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/woodplanks
	category = "engineering"
	name = "wood planks"
	supplier = "NanoTrasen"
	description = "50 planks of wood."
	price = 80
	items = list(
		/obj/item/stack/material/wood
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/wormfillet
	category = "hospitality"
	name = "worm fillet"
	supplier = "NanoTrasen"
	description = "Meat from a cavern Dweller. Mildly toxic if prepared improperly."
	price = 16
	items = list(
		/obj/item/reagent_containers/food/snacks/dwellermeat
	)
	access = 28
	container_type = "freezer"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/wrappartistepatron
	category = "hospitality"
	name = "Wrapp Artiste patron"
	supplier = "Virgo Freight Carriers"
	description = "Silver laced tequilla, served in space night clubs across the galaxy."
	price = 41
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/patron
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/wulumunushaseed
	category = "hydroponics"
	name = "wulumunusha seed"
	supplier = "NanoTrasen"
	description = "A skrellian plant used in religious ceremonies and drinks."
	price = 100
	items = list(
		/obj/item/seeds/wulumunushaseed
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/xuizijuicekeg
	category = "hospitality"
	name = "xuizi juice keg"
	supplier = "Virgo Freight Carriers"
	description = "A keg full of Xuizi juice, blended flower buds from the Moghean Xuizi cactus. The export stamp of the Arizi Guild is imprinted on the side."
	price = 200
	items = list(
		/obj/structure/reagent_dispensers/keg/xuizikeg
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/yellowpaint
	category = "operations"
	name = "yellow paint"
	supplier = "NanoTrasen"
	description = "Yellow paint, for when you need to make eyes sore."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/yellow
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/zipgun
	category = "security"
	name = "zip gun"
	supplier = "Zharkov Shipping Company"
	description = "Recommended for raiders 12 and up."
	price = 550
	items = list(
		/obj/item/gun/projectile/pirate
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/zorasodaresupplycanister
	category = "operations"
	name = "zora soda resupply canister"
	supplier = "zra"
	description = "A vending machine restock cart."
	price = 800
	items = list(
		/obj/item/device/vending_refill/zora
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1
*/
