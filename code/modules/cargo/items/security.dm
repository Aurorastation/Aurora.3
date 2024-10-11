//Basic sec items

/singleton/cargo_item/stunbaton
	category = "security"
	name = "stunbaton"
	supplier = "nanotrasen"
	description = "A stun baton for incapacitating people with."
	price = 120
	items = list(
		/obj/item/melee/baton
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/flash
	category = "security"
	name = "flash"
	supplier = "nanotrasen"
	description = "Used for blinding and being an asshole."
	price = 135
	items = list(
		/obj/item/device/flash
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/uvlight
	category = "security"
	name = "UV light"
	supplier = "nanotrasen"
	description = "A small handheld black light."
	price = 115
	items = list(
		/obj/item/device/uv_light
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1
/singleton/cargo_item/shelltagimplanter
	category = "security"
	name = "IPC tag implanter"
	supplier = "nanotrasen"
	description = "A special implanter used for implanting synthetics with a special tag."
	price = 400
	items = list(
		/obj/item/implanter/ipc_tag
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/maglight
	category = "security"
	name = "maglight"
	supplier = "nanotrasen"
	description = "A heavy flashlight designed for security personnel."
	price = 20
	items = list(
		/obj/item/device/flashlight/maglight
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/doorlock_security
	category = "security"
	name = "magnetic door lock - security"
	supplier = "nanotrasen"
	description = "A large, ID locked device used for completely locking down airlocks. It is painted with Security colors."
	price = 135
	items = list(
		/obj/item/device/magnetic_lock/security
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/zipties_box
	category = "security"
	name = "box of zipties"
	supplier = "nanotrasen"
	description = "A box full of zipties."
	price = 145
	items = list(
		/obj/item/storage/box/zipties
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/shieldgenerator
	category = "security"
	name = "Shield Generator"
	supplier = "nanotrasen"
	description = "A shield generator."
	price = 1500
	items = list(
		/obj/machinery/shieldwallgen
	)
	access = 10
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/pepperspraygrenades_box
	category = "security"
	name = "box of pepperspray grenades"
	supplier = "nanotrasen"
	description = "A box containing 7 tear gas grenades. A gas mask is printed on the label.<br> WARNING:</br> Exposure carries risk of serious injuries"
	price = 1050
	items = list(
		/obj/item/storage/box/teargas
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/flashbangs_box
	category = "security"
	name = "box of flashbangs"
	supplier = "nanotrasen"
	description = "A box containing 7 antipersonnel flashbang grenades.<br> WARNING:</br> These devices are extremely dangerous and can cause blindness"
	price = 520
	items = list(
		/obj/item/storage/box/flashbangs
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/empgrenades_box
	category = "security"
	name = "box of emp grenades"
	supplier = "nanotrasen"
	description = "A box containing 5 military grade EMP grenades.<br> WARNING:</br> Do not use near unshielded electronics or biomechanical augmentations"
	price = 4395
	items = list(
		/obj/item/storage/box/emps
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/deployablebarrier
	category = "security"
	name = "deployable barrier"
	supplier = "zavodskoi"
	description = "A deployable barrier. Swipe your ID card to lock/unlock it."
	price = 750
	items = list(
		/obj/machinery/deployable/barrier
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

//Armor and clothing

/singleton/cargo_item/armor
	category = "security"
	name = "armored vest"
	supplier = "zavodskoi"
	description = "An armored vest that protects against some damage."
	price = 250
	items = list(
		/obj/item/clothing/suit/armor/vest
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/tacticalhelmet
	category = "security"
	name = "tactical helmet"
	supplier = "zavodskoi"
	description = "A surplus tactical helmet."
	price = 3000
	items = list(
		/obj/item/clothing/head/helmet/tactical
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/tacticalarmor
	category = "security"
	name = "tactical armor"
	supplier = "zavodskoi"
	description = "Surplus tactical armor."
	price = 6000
	items = list(
		/obj/item/clothing/suit/armor/tactical
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/ablativehelmet
	category = "security"
	name = "ablative helmet"
	supplier = "zavodskoi"
	description = "A helmet made from advanced materials which protects against concentrated energy weapons."
	price = 550
	items = list(
		/obj/item/clothing/head/helmet/ablative
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/platecarrier_ablative
	category = "security"
	name = "plate carrier - ablative"
	supplier = "zavodskoi"
	description = "A plate carrier equipped with ablative armor plates"
	price = 1550
	items = list(
		/obj/item/clothing/suit/armor/carrier/ablative
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/ballistichelmet
	category = "security"
	name = "ballistic helmet"
	supplier = "zavodskoi"
	description = "A helmet with reinforced plating to protect against ballistic projectiles."
	price = 550
	items = list(
		/obj/item/clothing/head/helmet/ballistic
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/platecarrier_ballistic
	category = "security"
	name = "plate carrier - ballistic"
	supplier = "zavodskoi"
	description = "A plate carrier equipped with ballistic armor plates"
	price = 1450
	items = list(
		/obj/item/clothing/suit/armor/carrier/ballistic
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/riothelmet
	category = "security"
	name = "riot helmet"
	supplier = "zavodskoi"
	description = "It's a helmet specifically designed to protect against close range attacks."
	price = 750
	items = list(
		/obj/item/clothing/head/helmet/riot
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/platecarrier_riot
	category = "security"
	name = "plate carrier - riot"
	supplier = "zavodskoi"
	description = "A plate carrier equipped with riot armor plates"
	price = 1050
	items = list(
		/obj/item/clothing/suit/armor/carrier/riot
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/riotshield
	category = "security"
	name = "riot shield"
	supplier = "zavodskoi"
	description = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	price = 225
	items = list(
		/obj/item/shield/riot
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/securityvoidsuit
	category = "security"
	name = "security voidsuit"
	supplier = "zavodskoi"
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
	supplier = "zavodskoi"
	description = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	price = 3000
	items = list(
		/obj/item/clothing/head/helmet/space/void/security
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/tacticalhud
	category = "security"
	name = "tactical hud"
	supplier = "zharkov"
	description = "A tactical hud for tactical operations that ensures they proceed tactically."
	price = 200
	items = list(
		/obj/item/clothing/glasses/sunglasses/sechud/tactical
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1
/singleton/cargo_item/blackgloves
	category = "security"
	name = "black gloves"
	supplier = "nanotrasen"
	description = "Black gloves that are somewhat fire resistant."
	price = 70
	items = list(
		/obj/item/clothing/gloves/black
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/bandolier
	category = "security"
	name = "bandolier"
	supplier = "zharkov"
	description = "A pocketed belt designated to hold shotgun shells."
	price = 300
	items = list(
		/obj/item/clothing/accessory/storage/bandolier
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/combatbelt
	category = "security"
	name = "combat belt"
	supplier = "zharkov"
	description = "The only utility belt you will ever need."
	price = 300
	items = list(
		/obj/item/storage/belt/security/tactical
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/tacticaljumpsuit
	category = "security"
	name = "tactical jumpsuit"
	supplier = "zharkov"
	description = "Tactical fatigues guaranteed to bring out the space marine in you"
	price = 200
	items = list(
		/obj/item/clothing/under/tactical
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/jackboots
	category = "security"
	name = "jack boots"
	supplier = "zavodskoi"
	description = "Classic law enforcement footwear, comes with handy knife holder for when you need to enforce law up close."
	price = 100
	items = list(
		/obj/item/clothing/shoes/jackboots
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/bayonet
	category = "security"
	name = "bayonet"
	supplier = "zharkov"
	description = "A sharp military knife, can be attached to a rifle."
	price = 300
	items = list(
		/obj/item/clothing/accessory/storage/bayonet
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

//Weapons//

/singleton/cargo_item/pistol45
	category = "security"
	name = ".45 pistol"
	supplier = "nanotrasen"
	description = "NanoTrasen Mk58 .45-caliber pistol. Inexpensive, reliable, and ubiquitous among security forces galaxy-wide."
	price = 400
	items = list(
		/obj/item/gun/projectile/sec
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/disruptorpistol
	category = "security"
	name = "disruptor pistol"
	supplier = "nanotrasen"
	description = "A nanotrasen designed blaster pistol with two settings: stun and lethal."
	price = 500
	items = list(
		/obj/item/gun/energy/disruptorpistol
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1
/singleton/cargo_item/tasergun
	category = "security"
	name = "taser gun"
	supplier = "nanotrasen"
	description = "The NT Mk30 NL is a small, low capacity gun used for non-lethal takedowns."
	price = 150
	items = list(
		/obj/item/gun/energy/taser
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/machinepistol45
	category = "security"
	name = ".45 machine pistol"
	supplier = "zavodskoi"
	description = "A lightweight, fast firing gun."
	price = 1150
	items = list(
		/obj/item/gun/projectile/automatic/mini_uzi
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/ballisticcarbine
	category = "security"
	name = "ballistic carbine"
	supplier = "virgo"
	description = "A durable, rugged looking semi-automatic weapon of a make popular on the frontier worlds. Uses 5.56mm rounds."
	price = 5800
	items = list(
		/obj/item/gun/projectile/automatic/rifle/carbine
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/bullpupassaultcarbine
	category = "security"
	name = "Z8 bullpup assault carbine"
	supplier = "zavodskoi"
	description = "The ZI Bulldog 5.56mm bullpup assault carbine, Zavodskoi Industries' answer to any problem that can be solved by an assault rifle."
	price = 8650
	items = list(
		/obj/item/gun/projectile/automatic/rifle/z8
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/combatshotgun
	category = "security"
	name = "combat shotgun"
	supplier = "hephaestus"
	description = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders"
	price = 8250
	items = list(
		/obj/item/gun/projectile/shotgun/pump/combat
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/machinepistol
	category = "security"
	name = "machine pistol"
	supplier = "zavodskoi"
	description = "The ZI 550 Saber is a cheap self-defense weapon, mass-produced by Zavodskoi Interstellar for paramilitary and private use."
	price = 1300
	items = list(
		/obj/item/gun/projectile/automatic/wt550
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/energycarbine
	category = "security"
	name = "energy carbine"
	supplier = "nanotrasen"
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
	supplier = "nanotrasen"
	description = "A basic energy-based pistol gun with two settings: Stun and kill."
	price = 1800
	items = list(
		/obj/item/gun/energy/pistol
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/ionrifle
	category = "security"
	name = "ion rifle"
	supplier = "nanotrasen"
	description = "The NT Mk60 EW Halicon is a man portable anti-armor weapon designed to disable mechanical threats, produced by NT."
	price = 3000
	items = list(
		/obj/item/gun/energy/rifle/ionrifle
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1
/singleton/cargo_item/marksmanenergyrifle
	category = "security"
	name = "marksman energy rifle"
	supplier = "hephaestus"
	description = "The HI L.W.A.P. is an older design of Hephaestus Industries. A designated marksman rifle capable of shooting powerful ionized b愀猀琀猀"
	price = 9600
	items = list(
		/obj/item/gun/energy/sniperrifle
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/laserrifle
	category = "security"
	name = "laser rifle"
	supplier = "nanotrasen"
	description = "A common laser weapon, designed to kill with concentrated energy blasts."
	price = 2250
	items = list(
		/obj/item/gun/energy/rifle/laser
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1


/singleton/cargo_item/retrolaser
	category = "security"
	name = "retro laser"
	supplier = "zharkov"
	description = "Popular with space pirates and people who think they are space pirates."
	price = 1000
	items = list(
		/obj/item/gun/energy/retro
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/peac
	category = "security"
	name = "point entry anti-materiel cannon"
	supplier = "nanotrasen"
	description = "An SCC-designed, man-portable cannon meant to neutralize mechanized threats."
	price = 1200
	items = list(
		/obj/item/gun/projectile/peac
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/adhomianrecoillessrifle
	category = "security"
	name = "adhomian recoilless rifle"
	supplier = "zharkov"
	description = "An inexpensive, one use anti-tank weapon."
	price = 500
	items = list(
		/obj/item/gun/projectile/recoilless_rifle
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/boltactionrifle
	category = "security"
	name = "bolt action rifle"
	supplier = "zharkov"
	description = "If only it came with a scope."
	price = 850
	items = list(
		/obj/item/gun/projectile/shotgun/pump/rifle
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/derringer
	category = "security"
	name = "derringer"
	supplier = "zharkov"
	description = "A blast from the past that can fit in your pocket."
	price = 1250
	items = list(
		/obj/item/gun/projectile/revolver/derringer
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/silencedpistol
	category = "security"
	name = "silenced pistol"
	supplier = "zharkov"
	description = "Internally silenced for stealthy operations."
	price = 950
	items = list(
		/obj/item/gun/projectile/silenced
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/zipgun
	category = "security"
	name = "zip gun"
	supplier = "zharkov"
	description = "Recommended for raiders 12 and up."
	price = 550
	items = list(
		/obj/item/gun/projectile/pirate
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

//Ammunition

/singleton/cargo_item/ammunitionbox_beanbag
	category = "security"
	name = "ammunition box (beanbag shells)"
	supplier = "zavodskoi"
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
	supplier = "zavodskoi"
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
	supplier = "zavodskoi"
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
	supplier = "zavodskoi"
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
	supplier = "zavodskoi"
	description = "A magazine for some kind of gun."
	price = 500
	items = list(
		/obj/item/storage/box/shotgunammo
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/illuminationshells_box
	category = "security"
	name = "box of illumination shells"
	supplier = "zavodskoi"
	description = "It has a picture of a gun and several warning symbols on the front.<br>WARNING:</br> Live ammunition. Misuse may result in serious injury and death"
	price = 97
	items = list(
		/obj/item/storage/box/flashshells
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/anti_materiel_cannon_cartridge
	category = "security"
	name = "anti-materiel cannon cartridge"
	supplier = "zavodskoi"
	description = "A single use cartridge for an anti-materiel cannon."
	price = 300
	items = list(
		/obj/item/ammo_casing/peac
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/apcarbinemagazine_556
	category = "security"
	name = "ap carbine magazine (5.56mm)"
	supplier = "zavodskoi"
	description = "An AP 5.56 ammo magazine fit for a carbine, not an assault rifle."
	price = 450
	items = list(
		/obj/item/ammo_magazine/a556/carbine/ap
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/carbinemagazine_556
	category = "security"
	name = "carbine magazine (5.56mm)"
	supplier = "zavodskoi"
	description = "A 5.56 ammo magazine fit for a carbine, not an assault rifle."
	price = 250
	items = list(
		/obj/item/ammo_magazine/a556/carbine
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/magazine_556
	category = "security"
	name = "magazine (5.56mm)"
	supplier = "nanotrasen"
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
	supplier = "zharkov"
	description = "A magazine for some kind of gun."
	price = 70
	items = list(
		/obj/item/ammo_magazine/d762
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/magazine_9
	category = "security"
	name = "magazine (9mm)"
	supplier = "nanotrasen"
	description = "A magazine for some kind of gun."
	price = 40
	items = list(
		/obj/item/ammo_magazine/mc9mm
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/magazine_45
	category = "security"
	name = "magazine (.45)"
	supplier = "nanotrasen"
	description = "A magazine for some kind of gun."
	price = 200
	items = list(
		/obj/item/ammo_magazine/c45m
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/magazine_45flash
	category = "security"
	name = "magazine (.45 flash)"
	supplier = "nanotrasen"
	description = "A magazine for some kind of gun."
	price = 10
	items = list(
		/obj/item/ammo_magazine/c45m/flash
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/compacttungstenslug
	category = "security"
	name = "compact tungsten slug"
	supplier = "virgo"
	description = "A box with several compact tungsten slugs, aimed for use in gauss carbines."
	price = 500
	items = list(
		/obj/item/storage/box/tungstenslugs
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/electronicfiringpin
	category = "security"
	name = "electronic firing pin"
	supplier = "nanotrasen"
	description = "A small authentication device, to be inserted into a firearm receiver to allow operation."
	price = 2000
	items = list(
		/obj/item/device/firing_pin
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/holographicammodisplay
	category = "security"
	name = "holographic ammo display"
	supplier = "nanotrasen"
	description = "A device that can be attached to most firearms, providing a holographic display of the remaining ammunition to the user."
	price = 200
	items = list(
		/obj/item/ammo_display
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/topmountedmagazine_9mmrubber
	category = "security"
	name = "top mounted magazine (9mm rubber)"
	supplier = "nanotrasen"
	description = "A magazine for some kind of gun."
	price = 25
	items = list(
		/obj/item/ammo_magazine/mc9mmt/rubber
	)
	access = 2
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/tranquilizerdarts_50cal_pps
	category = "security"
	name = "tranquilizer darts (.50 cal PPS)"
	supplier = "nanotrasen"
	description = "A magazine for some kind of gun."
	price = 45
	items = list(
		/obj/item/storage/box/tranquilizer
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

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
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/luminolbottle
	category = "security"
	name = "luminol bottle"
	supplier = "nanotrasen"
	description = "A bottle containing an odourless, colorless liquid."
	price = 115
	items = list(
		/obj/item/reagent_containers/spray/luminol
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/microscopeslidebox
	category = "security"
	name = "microscope slide box"
	supplier = "nanotrasen"
	description = "It's just an ordinary box."
	price = 35
	items = list(
		/obj/item/storage/box/slides
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/fibercollectionkit
	category = "security"
	name = "fiber collection kit"
	supplier = "nanotrasen"
	description = "A magnifying glass and tweezers. Used to lift suit fibers."
	price = 115
	items = list(
		/obj/item/forensics/sample_kit
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/fingerprintpowder
	category = "security"
	name = "fingerprint powder"
	supplier = "nanotrasen"
	description = "A jar containing aluminum powder and a specialized brush."
	price = 75
	items = list(
		/obj/item/forensics/sample_kit/powder
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1

/singleton/cargo_item/swabkits_box
	category = "security"
	name = "box of swab kits"
	supplier = "nanotrasen"
	description = "Sterilized equipment within. Do not contaminate."
	price = 25
	items = list(
		/obj/item/storage/box/swabs
	)
	access = 3
	container_type = "crate"
	groupable = 1
	item_mul = 1
