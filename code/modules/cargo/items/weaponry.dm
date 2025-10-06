//Weapons//

/singleton/cargo_item/disruptorpistol
	category = "weaponry"
	name = "disruptor pistol"
	supplier = "nanotrasen"
	description = "A nanotrasen designed blaster pistol with two settings: stun and lethal."
	price = 500
	items = list(
		/obj/item/gun/energy/disruptorpistol
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
/singleton/cargo_item/tasergun
	category = "weaponry"
	name = "taser gun"
	supplier = "nanotrasen"
	description = "The NT Mk30 NL is a small, low capacity gun used for non-lethal takedowns."
	price = 310
	items = list(
		/obj/item/gun/energy/taser
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/pistol45
	category = "weaponry"
	name = ".45 pistol"
	supplier = "nanotrasen"
	description = "The NanoTrasen Mk58 .45-caliber pistol. Inexpensive, reliable, and ubiquitous among security forces galaxy-wide."
	price = 800
	items = list(
		/obj/item/gun/projectile/sec
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/machinepistol
	category = "weaponry"
	name = "machine pistol"
	supplier = "zavodskoi"
	description = "The ZI 550 Saber is a cheap self-defense weapon, mass-produced by Zavodskoi Interstellar for paramilitary and private use."
	price = 1200
	items = list(
		/obj/item/gun/projectile/automatic/wt550
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/ballisticcarbine
	category = "weaponry"
	name = "ballistic carbine"
	supplier = "virgo"
	description = "A durable, rugged looking semi-automatic weapon of a make popular on the frontier worlds. Uses 5.56mm rounds."
	price = 1500
	items = list(
		/obj/item/gun/projectile/automatic/rifle/carbine
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/bullpupassaultcarbine
	category = "weaponry"
	name = "Z8 bullpup assault carbine"
	supplier = "zavodskoi"
	description = "The ZI Bulldog 5.56mm bullpup assault carbine, Zavodskoi Industries' answer to any problem that can be solved by an assault rifle."
	price = 1750
	items = list(
		/obj/item/gun/projectile/automatic/rifle/z8
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/combatshotgun
	category = "weaponry"
	name = "combat shotgun"
	supplier = "hephaestus"
	description = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders."
	price = 1300
	items = list(
		/obj/item/gun/projectile/shotgun/pump/combat
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/energycarbine
	category = "weaponry"
	name = "energy carbine"
	supplier = "nanotrasen"
	description = "An energy-based carbine with two settings: Stun and kill."
	price = 1200
	items = list(
		/obj/item/gun/energy/gun
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/energypistol
	category = "weaponry"
	name = "energy pistol"
	supplier = "nanotrasen"
	description = "A basic energy-based pistol gun with two settings: Stun and kill."
	price = 750
	items = list(
		/obj/item/gun/energy/pistol
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/ionrifle
	category = "weaponry"
	name = "ion rifle"
	supplier = "nanotrasen"
	description = "The NT Mk60 EW Halicon is a man portable anti-armor weapon designed to disable mechanical threats."
	price = 1200
	items = list(
		/obj/item/gun/energy/rifle/ionrifle
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
/singleton/cargo_item/marksmanenergyrifle
	category = "weaponry"
	name = "marksman energy rifle"
	supplier = "hephaestus"
	description = "The HI L.W.A.P. is an older design of Hephaestus Industries. A designated marksman rifle capable of shooting powerful ionized bolts."
	price = 2100
	items = list(
		/obj/item/gun/energy/sniperrifle
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/laserrifle
	category = "weaponry"
	name = "laser rifle"
	supplier = "nanotrasen"
	description = "A common laser weapon, designed to kill with concentrated energy blasts."
	price = 1400
	items = list(
		/obj/item/gun/energy/rifle/laser
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/peac
	category = "weaponry"
	name = "point entry anti-materiel cannon"
	supplier = "nanotrasen"
	description = "An SCC-designed, man-portable cannon meant to neutralize mechanized threats. Spectacularly effective, though equally spectacularly unwieldy."
	price = 2200
	items = list(
		/obj/item/gun/projectile/peac
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/adhomianrecoillessrifle
	category = "weaponry"
	name = "adhomian recoilless rifle"
	supplier = "zharkov"
	description = "Shoulder-fired man-portable anti-tank recoilless rifle with a single shot. Relatively inexpensive and does its job."
	price = 1200
	items = list(
		/obj/item/gun/projectile/recoilless_rifle
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/boltactionrifle
	category = "weaponry"
	name = "bolt action rifle"
	supplier = "zharkov"
	description = "An Adhomian bolt-action rifle."
	price = 750
	items = list(
		/obj/item/gun/projectile/shotgun/pump/rifle
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/derringer
	category = "weaponry"
	name = "derringer"
	supplier = "zharkov"
	description = "A blast from the past that can fit in your pocket."
	price = 650
	items = list(
		/obj/item/gun/projectile/revolver/derringer
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/silencedpistol
	category = "weaponry"
	name = "silenced pistol"
	supplier = "zharkov"
	description = "Internally silenced for stealthy operations."
	price = 1350
	items = list(
		/obj/item/gun/projectile/silenced
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

//Ammunition

/singleton/cargo_item/ammunitionbox_beanbag
	category = "weaponry"
	name = "shotgun ammunition box (beanbag shells)"
	supplier = "zavodskoi"
	description = "A box of less-lethal beanbag shells."
	price = 65
	items = list(
		/obj/item/storage/box/beanbags
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/ammunitionbox_haywire
	category = "weaponry"
	name = "shotgun ammunition box (haywire shells)"
	supplier = "zavodskoi"
	description = "A box of EMP-inducing 'haywire' shotgun shells."
	price = 90
	items = list(
		/obj/item/storage/box/haywireshells
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/ammunitionbox_incendiary
	category = "weaponry"
	name = "shotgun ammunition box (incendiary shells)"
	supplier = "zavodskoi"
	description = "A box of incendiary shotgun shells."
	price = 95
	items = list(
		/obj/item/storage/box/incendiaryshells
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/ammunitionbox_shells
	category = "weaponry"
	name = "shotgun ammunition box (buckshot)"
	supplier = "zavodskoi"
	description = "A box of shotgun buckshot shells."
	price = 70
	items = list(
		/obj/item/storage/box/shotgunshells
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/ammunitionbox_slugs
	category = "weaponry"
	name = "shotgun ammunition box (slug)"
	supplier = "zavodskoi"
	description = "A box of shotgun slugs."
	price = 80
	items = list(
		/obj/item/storage/box/shotgunammo
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/illuminationshells_box
	category = "weaponry"
	name = "shotgun ammunition box (illumination)"
	supplier = "zavodskoi"
	description = "A box of illuminating shotgun shells."
	price = 65
	items = list(
		/obj/item/storage/box/flashshells
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/anti_materiel_cannon_cartridge
	category = "weaponry"
	name = "anti-materiel cannon cartridge"
	supplier = "zavodskoi"
	description = "A single use cartridge for a point-entry anti-materiel cannon."
	price = 300
	items = list(
		/obj/item/ammo_casing/peac
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/carbinemagazine_556
	category = "weaponry"
	name = "C-type carbine magazine (5.56mm)"
	supplier = "zavodskoi"
	description = "Civilian-issue 5.56mm magazine with reduced capacity. Fits most private-issue 5.56mm weapons."
	price = 45
	items = list(
		/obj/item/ammo_magazine/a556/carbine
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/apcarbinemagazine_556
	category = "weaponry"
	name = "C-type armor-piercing carbine magazine (5.56mm)"
	supplier = "zavodskoi"
	description = "Civilian-issue 5.56mm magazine with reduced capacity. Fits most private-issue 5.56mm weapons."
	price = 55
	items = list(
		/obj/item/ammo_magazine/a556/carbine/ap
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/magazine_556
	category = "weaponry"
	name = "M-type rifle magazine (5.56mm)"
	supplier = "zavodskoi"
	description = "A 5.56 ammo magazine for military assault rifles. Incompatible with weapons that take C-type magazines."
	price = 60
	items = list(
		/obj/item/ammo_magazine/a556
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/magazine_556/ap
	category = "weaponry"
	name = "M-type armor-piercing rifle magazine (5.56mm)"
	supplier = "zavodskoi"
	description = "A 5.56 AP ammo magazine for military assault rifles. Incompatible with weapons that take C-type magazines."
	price = 70
	items = list(
		/obj/item/ammo_magazine/a556/ap
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/magazine_762
	category = "weaponry"
	name = "rifle magazine (7.62mm)"
	supplier = "zharkov"
	description = "A 7.62mm rifle magazine."
	price = 65
	items = list(
		/obj/item/ammo_magazine/d762
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/magazine_9
	category = "weaponry"
	name = "pistol magazine (9mm)"
	supplier = "zharkov"
	description = "A 9mm pistol magazine."
	price = 25
	items = list(
		/obj/item/ammo_magazine/mc9mm
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/magazine_45
	category = "weaponry"
	name = "pistol magazine (.45)"
	supplier = "nanotrasen"
	description = "A .45-caliber pistol magazine."
	price = 30
	items = list(
		/obj/item/ammo_magazine/c45m
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/magazine_45flash
	category = "weaponry"
	name = "pistol magazine (.45 flash)"
	supplier = "nanotrasen"
	description = "A .45-caliber less-lethal flash magazine."
	price = 35
	items = list(
		/obj/item/ammo_magazine/c45m/flash
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/topmounted_9mm
	category = "weaponry"
	name = "top mounted magazine (9mm)"
	supplier = "zavodskoi"
	description = "A top-mounted 9mm magazine designed for the ZI 550 machine pistol. Contains lethal rounds."
	price = 40
	items = list(
		/obj/item/ammo_magazine/mc9mmt
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/topmounted_9mmrubber
	category = "weaponry"
	name = "top mounted magazine (9mm rubber)"
	supplier = "zavodskoi"
	description = "A top-mounted 9mm magazine designed for the ZI 550 machine pistol. Contains less-lethal rubber rounds."
	price = 35
	items = list(
		/obj/item/ammo_magazine/mc9mmt/rubber
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/tranquilizerdarts_50cal_pps
	category = "security"
	name = "tranquilizer darts (.50 cal PPS)"
	supplier = "nanotrasen"
	description = "A box of 50-caliber tranquilizer darts."
	price = 50
	items = list(
		/obj/item/storage/box/tranquilizer
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/compacttungstenslug
	category = "weaponry"
	name = "compact tungsten gauss slugs"
	supplier = "virgo"
	description = "A box with several compact tungsten slugs, aimed for use in gauss carbines."
	price = 125
	items = list(
		/obj/item/storage/box/tungstenslugs
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/franciscaapammo
	category = "weaponry"
	name = "francisca rotary cannon AP ammunition box"
	supplier = "zavodskoi"
	description = "A box of 40mm AP ammo for the francisca rotary cannon."
	price = 850
	items = list(
		/obj/item/ship_ammunition/grauwolf_bundle/ap
	)
	access = ACCESS_CARGO
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/franciscafmjammo
	category = "weaponry"
	name = "francisca rotary cannon FMJ ammunition box"
	supplier = "zavodskoi"
	description = "A box of 40mm FMJ ammo for a Francisca-type rotary cannon."
	price = 800
	items = list(
		/obj/item/ship_ammunition/grauwolf_bundle
	)
	access = ACCESS_CARGO
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/grauwolfapflak
	category = "weaponry"
	name = "grauwolf AP flak shells"
	supplier = "zavodskoi"
	description = "Armor-Piercing shells for a Grauwolf-type flak battery."
	price = 1800
	items = list(
		/obj/item/ship_ammunition/grauwolf_bundle/ap
	)
	access = ACCESS_CARGO
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/grauwolfheflak
	category = "weaponry"
	name = "grauwolf HE flak shells"
	supplier = "zavodskoi"
	description = "High-explosive shells for a Grauwolf-type flak battery."
	price = 1600
	items = list(
		/obj/item/ship_ammunition/grauwolf_bundle
	)
	access = ACCESS_CARGO
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/longbowcasing
	category = "weaponry"
	name = "longbow casing"
	supplier = "zavodskoi"
	description = "A casing for a 406mm warhead, designed for a Longbow-type cannon."
	price = 1000
	items = list(
		/obj/item/ship_ammunition/longbow
	)
	access = ACCESS_CARGO
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/longbowapwarhead
	category = "weaponry"
	name = "longbow AP warhead"
	supplier = "zavodskoi"
	description = "An armor-piercing 406mm warhead, designed for a Longbow-type cannon."
	price = 1800
	items = list(
		/obj/item/warhead/longbow/ap
	)
	access = ACCESS_CARGO
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/longbowepwarhead
	category = "weaponry"
	name = "longbow EP warhead"
	supplier = "zavodskoi"
	description = "A bunker-buster 406mm warhead, designed for a Longbow-type cannon."
	price = 2200
	items = list(
		/obj/item/warhead/longbow/bunker
	)
	access = ACCESS_CARGO
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/longbowhewarhead
	category = "weaponry"
	name = "longbow HE warhead"
	supplier = "zavodskoi"
	description = "A high-explosive 406mm warhead, designed for a Longbow-type cannon."
	price = 1650
	items = list(
		/obj/item/warhead/longbow
	)
	access = ACCESS_CARGO
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/highpowerlongbowprimer
	category = "weaponry"
	name = "high-power longbow primer"
	supplier = "zavodskoi"
	description = "A high-power primer for a 406mm warhead, designed for a Longbow-type cannon."
	price = 800
	items = list(
		/obj/item/primer/high
	)
	access = ACCESS_CARGO
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/longbowwarheadprimer
	category = "weaponry"
	name = "longbow warhead primer"
	supplier = "zavodskoi"
	description = "A standard primer for a 406mm warhead, designed for a Longbow-type cannon."
	price = 500
	items = list(
		/obj/item/primer
	)
	access = ACCESS_CARGO
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/lowpowerlongbowprimer
	category = "weaponry"
	name = "low-power longbow primer"
	supplier = "zavodskoi"
	description = "A low-power primer for a 406mm warhead, designed for a Longbow-type cannon."
	price = 350
	items = list(
		/obj/item/primer/low
	)
	access = ACCESS_CARGO
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
