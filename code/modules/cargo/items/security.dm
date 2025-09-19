//Basic sec items

/singleton/cargo_item/stunbaton
	category = "security"
	name = "stunbaton"
	supplier = "nanotrasen"
	description = "A stun baton for incapacitating people with."
	price = 320
	items = list(
		/obj/item/melee/baton
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/flash
	category = "security"
	name = "flash"
	supplier = "nanotrasen"
	description = "Used for blinding and being an asshole."
	price = 235
	items = list(
		/obj/item/device/flash
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/uvlight
	category = "security"
	name = "UV light"
	supplier = "nanotrasen"
	description = "A small handheld black light."
	price = 115
	items = list(
		/obj/item/device/uv_light
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/ipcimplanter
	category = "security"
	name = "IPC tag implanter"
	supplier = "nanotrasen"
	description = "A special implanter used for implanting synthetics with a special tag."
	price = 400
	items = list(
		/obj/item/implanter/ipc_tag
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/maglight
	category = "security"
	name = "maglight"
	supplier = "nanotrasen"
	description = "A heavy flashlight designed for security personnel."
	price = 75
	items = list(
		/obj/item/device/flashlight/maglight
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/doorlock_security
	category = "security"
	name = "magnetic door lock - security"
	supplier = "nanotrasen"
	description = "A large, ID locked device used for completely locking down airlocks. It is painted with Security colors."
	price = 50
	items = list(
		/obj/item/device/magnetic_lock/security
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/handcuffs_box
	category = "security"
	name = "box of handcuffs"
	supplier = "nanotrasen"
	description = "A box full of handcuffs."
	price = 145
	items = list(
		/obj/item/storage/box/handcuffs
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/zipties_box
	category = "security"
	name = "box of zipties"
	supplier = "nanotrasen"
	description = "A box full of zipties."
	price = 88
	items = list(
		/obj/item/storage/box/zipties
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/shieldgenerator
	category = "security"
	name = "Shield Generator"
	supplier = "nanotrasen"
	description = "A shield generator."
	price = 550
	items = list(
		/obj/machinery/shieldwallgen
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/pepperspraygrenades_box
	category = "security"
	name = "box of pepperspray grenades"
	supplier = "zavodskoi"
	description = "A box containing 7 tear gas grenades. A gas mask is printed on the label. WARNING: Exposure carries risk of serious injuries."
	price = 450
	items = list(
		/obj/item/storage/box/teargas
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/flashbangs_box
	category = "security"
	name = "box of flashbangs"
	supplier = "zavodskoi"
	description = "A box containing 7 antipersonnel flashbang grenades. WARNING: Can cause permanent vision or hearing loss. Use with caution."
	price = 520
	items = list(
		/obj/item/storage/box/flashbangs
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/empgrenades_box
	category = "security"
	name = "box of EMP grenades"
	supplier = "zavodskoi"
	description = "A box containing 5 military grade EMP grenades. WARNING: Do not use near unshielded electronics or biomechanical augmentations."
	price = 1450
	items = list(
		/obj/item/storage/box/emps
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/deployablebarrier
	category = "security"
	name = "deployable barrier"
	supplier = "zavodskoi"
	description = "A deployable barrier. Swipe your ID card to lock/unlock it."
	price = 440
	items = list(
		/obj/machinery/deployable/barrier
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

//Armor and clothing

/singleton/cargo_item/armor
	category = "security"
	name = "armored vest"
	supplier = "zavodskoi"
	description = "An armored vest that protects against some damage."
	price = 350
	items = list(
		/obj/item/clothing/suit/armor/vest
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/tacticalhelmet
	category = "security"
	name = "standard helmet"
	supplier = "zavodskoi"
	description = "An armored helmet, for keeping that head of yours intact."
	price = 280
	items = list(
		/obj/item/clothing/head/helmet
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/tacticalarmor
	category = "security"
	name = "standard plate carrier"
	supplier = "zavodskoi"
	description = "A plate carrier with basic accessories and an armor plate."
	price = 800
	items = list(
		/obj/item/clothing/suit/armor/carrier/officer
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/ablativehelmet
	category = "security"
	name = "ablative helmet"
	supplier = "zavodskoi"
	description = "A helmet made from advanced materials which protects against concentrated energy weapons."
	price = 320
	items = list(
		/obj/item/clothing/head/helmet/ablative
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/platecarrier_ablative
	category = "security"
	name = "plate carrier - ablative"
	supplier = "zavodskoi"
	description = "A plate carrier equipped with ablative armor plates."
	price = 875
	items = list(
		/obj/item/clothing/suit/armor/carrier/ablative
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/ballistichelmet
	category = "security"
	name = "ballistic helmet"
	supplier = "zavodskoi"
	description = "A helmet with reinforced plating to protect against ballistic projectiles."
	price = 360
	items = list(
		/obj/item/clothing/head/helmet/ballistic
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/platecarrier_ballistic
	category = "security"
	name = "plate carrier - ballistic"
	supplier = "zavodskoi"
	description = "A plate carrier equipped with ballistic armor plates."
	price = 850
	items = list(
		/obj/item/clothing/suit/armor/carrier/ballistic
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/riothelmet
	category = "security"
	name = "riot helmet"
	supplier = "zavodskoi"
	description = "It's a helmet specifically designed to protect against close range attacks."
	price = 750
	items = list(
		/obj/item/clothing/head/helmet/riot
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/platecarrier_riot
	category = "security"
	name = "plate carrier - riot"
	supplier = "zavodskoi"
	description = "A plate carrier equipped with riot armor plates."
	price = 1050
	items = list(
		/obj/item/clothing/suit/armor/carrier/riot
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/riotshield
	category = "security"
	name = "riot shield"
	supplier = "zavodskoi"
	description = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	price = 225
	items = list(
		/obj/item/shield/riot
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/securityvoidsuit
	category = "security"
	name = "security voidsuit"
	supplier = "zavodskoi"
	description = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	price = 900
	items = list(
		/obj/item/clothing/suit/space/void/security
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/securityvoidsuithelmet
	category = "security"
	name = "security voidsuit helmet"
	supplier = "zavodskoi"
	description = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	price = 550
	items = list(
		/obj/item/clothing/head/helmet/space/void/security
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/tacticalhud
	category = "security"
	name = "tactical hud"
	supplier = "zharkov"
	description = "A tactical hud for tactical operations that ensures they proceed tactically."
	price = 200
	items = list(
		/obj/item/clothing/glasses/sunglasses/sechud/tactical
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
/singleton/cargo_item/blackgloves
	category = "security"
	name = "black gloves"
	supplier = "nanotrasen"
	description = "Black gloves that are somewhat fire resistant."
	price = 70
	items = list(
		/obj/item/clothing/gloves/black
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/bandolier
	category = "security"
	name = "bandolier"
	supplier = "zharkov"
	description = "A pocketed belt designated to hold shotgun shells."
	price = 300
	items = list(
		/obj/item/clothing/accessory/storage/bandolier
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/combatbelt
	category = "security"
	name = "combat belt"
	supplier = "zharkov"
	description = "The only utility belt you will ever need."
	price = 300
	items = list(
		/obj/item/storage/belt/security/tactical
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/tacticaljumpsuit
	category = "security"
	name = "tactical jumpsuit"
	supplier = "zharkov"
	description = "Tactical fatigues guaranteed to bring out the space marine in you."
	price = 200
	items = list(
		/obj/item/clothing/under/tactical
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/jackboots
	category = "security"
	name = "jack boots"
	supplier = "zavodskoi"
	description = "Classic law enforcement footwear, comes with handy knife holder for when you need to enforce law up close."
	price = 100
	items = list(
		/obj/item/clothing/shoes/jackboots
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/bayonet
	category = "security"
	name = "bayonet"
	supplier = "zharkov"
	description = "A sharp military knife, can be attached to a rifle."
	price = 300
	items = list(
		/obj/item/clothing/accessory/storage/bayonet
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/electronicfiringpin
	category = "security"
	name = "electronic firing pin"
	supplier = "nanotrasen"
	description = "A small authentication device, to be inserted into a firearm receiver to allow operation."
	price = 2000
	items = list(
		/obj/item/device/firing_pin
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/holographicammodisplay
	category = "security"
	name = "holographic ammo display"
	supplier = "nanotrasen"
	description = "A device that can be attached to most firearms, providing a holographic display of the remaining ammunition to the user."
	price = 200
	items = list(
		/obj/item/ammo_display
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

//Forensics

/singleton/cargo_item/crimescenekit
	category = "security"
	name = "empty crime scene kit"
	supplier = "nanotrasen"
	description = "A stainless steel-plated carrycase for all of your forensic needs. This one is empty."
	price = 145
	items = list(
		/obj/item/storage/briefcase/crimekit
	)
	access = ACCESS_FORENSICS_LOCKERS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/luminolbottle
	category = "security"
	name = "luminol bottle"
	supplier = "nanotrasen"
	description = "A bottle containing an odourless, colorless liquid."
	price = 115
	items = list(
		/obj/item/reagent_containers/spray/luminol
	)
	access = ACCESS_FORENSICS_LOCKERS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/microscopeslidebox
	category = "security"
	name = "microscope slide box"
	supplier = "nanotrasen"
	description = "It's just an ordinary box."
	price = 35
	items = list(
		/obj/item/storage/box/slides
	)
	access = ACCESS_FORENSICS_LOCKERS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/fibercollectionkit
	category = "security"
	name = "fiber collection kit"
	supplier = "nanotrasen"
	description = "A magnifying glass and tweezers. Used to lift suit fibers."
	price = 115
	items = list(
		/obj/item/forensics/sample_kit
	)
	access = ACCESS_FORENSICS_LOCKERS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/fingerprintpowder
	category = "security"
	name = "fingerprint powder"
	supplier = "nanotrasen"
	description = "A jar containing aluminum powder and a specialized brush."
	price = 75
	items = list(
		/obj/item/forensics/sample_kit/powder
	)
	access = ACCESS_FORENSICS_LOCKERS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/swabkits_box
	category = "security"
	name = "box of swab kits"
	supplier = "nanotrasen"
	description = "Sterilized equipment within. Do not contaminate."
	price = 25
	items = list(
		/obj/item/storage/box/swabs
	)
	access = ACCESS_FORENSICS_LOCKERS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
