/obj/random/belt
	name = "random belt"
	icon_state = "toolbelt"
	problist = list(
		/obj/item/storage/belt/utility = 1,
		/obj/item/storage/belt/medical = 0.4,
		/obj/item/storage/belt/medical/paramedic = 0.4,
		/obj/item/storage/belt/medical/paramedic/combat = 0.1,
		/obj/item/storage/belt/security/tactical = 0.1,
		/obj/item/storage/belt/military = 0.1,
		/obj/item/storage/belt/custodial = 0.4
	)

// Spawns a random backpack.
// Novelty and rare backpacks have lower weights.
/obj/random/backpack
	name = "random backpack"
	icon_state = "backpack"
	problist = list(
		/obj/item/storage/backpack = 3,
		/obj/item/storage/backpack/cultpack = 2,
		/obj/item/storage/backpack/medic = 3,
		/obj/item/storage/backpack/security = 3,
		/obj/item/storage/backpack/captain = 2,
		/obj/item/storage/backpack/industrial = 3,
		/obj/item/storage/backpack/toxins = 3,
		/obj/item/storage/backpack/hydroponics = 3,
		/obj/item/storage/backpack/pharmacy = 3,
		/obj/item/storage/backpack/cloak = 2,
		/obj/item/storage/backpack/syndie = 1,
		/obj/item/storage/backpack/satchel = 3,
		/obj/item/storage/backpack/satchel/leather = 3,
		/obj/item/storage/backpack/satchel/eng = 3,
		/obj/item/storage/backpack/satchel/med = 3,
		/obj/item/storage/backpack/satchel/pharm = 3,
		/obj/item/storage/backpack/satchel/tox = 3,
		/obj/item/storage/backpack/satchel/sec = 3,
		/obj/item/storage/backpack/satchel/hyd = 3,
		/obj/item/storage/backpack/satchel/cap = 1,
		/obj/item/storage/backpack/satchel/syndie = 1,
		/obj/item/storage/backpack/ert = 1,
		/obj/item/storage/backpack/ert/security = 1,
		/obj/item/storage/backpack/ert/engineer = 1,
		/obj/item/storage/backpack/ert/medical = 1,
		/obj/item/storage/backpack/duffel = 3,
		/obj/item/storage/backpack/duffel/cap = 1,
		/obj/item/storage/backpack/duffel/hyd = 3,
		/obj/item/storage/backpack/duffel/med = 3,
		/obj/item/storage/backpack/duffel/eng = 3,
		/obj/item/storage/backpack/duffel/tox = 3,
		/obj/item/storage/backpack/duffel/sec = 3,
		/obj/item/storage/backpack/duffel/pharm = 3,
		/obj/item/storage/backpack/duffel/syndie = 1,
		/obj/item/storage/backpack/messenger = 2,
		/obj/item/storage/backpack/messenger/pharm = 2,
		/obj/item/storage/backpack/messenger/med = 2,
		/obj/item/storage/backpack/messenger/tox = 2,
		/obj/item/storage/backpack/messenger/com = 1,
		/obj/item/storage/backpack/messenger/engi = 2,
		/obj/item/storage/backpack/messenger/hyd = 2,
		/obj/item/storage/backpack/messenger/sec = 2,
		/obj/item/storage/backpack/messenger/syndie = 1,
	)

/obj/random/colored_jumpsuit
	name = "random colored jumpsuit"
	desc = "This is a random colored jumpsuit."
	icon_state = "uniform"
	spawnlist = list(
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/under/color/blue,
		/obj/item/clothing/under/color/green,
		/obj/item/clothing/under/color/grey,
		/obj/item/clothing/under/color/orange,
		/obj/item/clothing/under/color/pink,
		/obj/item/clothing/under/color/red,
		/obj/item/clothing/under/color/white,
		/obj/item/clothing/under/color/yellow,
		/obj/item/clothing/under/color/lightblue,
		/obj/item/clothing/under/color/aqua,
		/obj/item/clothing/under/color/purple,
		/obj/item/clothing/under/color/lightpurple,
		/obj/item/clothing/under/color/lightgreen,
		/obj/item/clothing/under/color/lightbrown,
		/obj/item/clothing/under/color/brown,
		/obj/item/clothing/under/color/yellowgreen,
		/obj/item/clothing/under/color/darkblue,
		/obj/item/clothing/under/color/lightred,
		/obj/item/clothing/under/color/darkred
	)

/obj/random/suit
	name = "random suit"
	desc = "This is a random suit."
	icon_state = "uniform"
	spawnlist = list(
		/obj/item/clothing/under/suit_jacket/charcoal,
		/obj/item/clothing/under/suit_jacket/navy,
		/obj/item/clothing/under/suit_jacket/burgundy,
		/obj/item/clothing/under/suit_jacket/checkered,
		/obj/item/clothing/under/suit_jacket/tan,
		/obj/item/clothing/under/sl_suit,
		/obj/item/clothing/under/suit_jacket,
		/obj/item/clothing/under/suit_jacket/really_black,
		/obj/item/clothing/under/suit_jacket/red,
		/obj/item/clothing/under/suit_jacket/white
	)

/obj/random/chameleon
	name = "random possible chameleon item"
	desc = "A random possible chameleon item. What could possibly go wrong?"
	icon_state = "uniform"
	problist = list(

		/obj/item/clothing/gloves/chameleon = 1,
		/obj/item/clothing/gloves/black = 10,

		/obj/item/clothing/head/chameleon = 0.5,
		/obj/item/clothing/head/softcap = 5,

		/obj/item/clothing/mask/chameleon = 1,
		/obj/item/clothing/mask/gas = 10,

		/obj/item/clothing/shoes/chameleon = 0.5,
		/obj/item/clothing/shoes/sneakers/black = 5,

		/obj/item/clothing/suit/chameleon = 0.1,
		/obj/item/clothing/suit/armor/vest = 1,

		/obj/item/clothing/under/chameleon = 0.75,
		/obj/item/clothing/under/color/black = 7.5,

		/obj/item/gun/energy/chameleon = 0.1,
		/obj/item/gun/bang/deagle = 0.1,

		/obj/item/storage/backpack/chameleon = 1,
		/obj/item/storage/backpack = 10,

		/obj/item/clothing/glasses/chameleon = 1
	)

/obj/random/gloves
	name = "random gloves"
	desc = "Random gloves, assorted usefulness."
	icon_state = "gloves"
	problist = list(
		/obj/item/clothing/gloves/black = 1,
		/obj/item/clothing/gloves/black_leather = 0.5,
		/obj/item/clothing/gloves/botanic_leather = 0.7,
		/obj/item/clothing/gloves/boxing = 0.3,
		/obj/item/clothing/gloves/boxing/green = 0.3,
		/obj/item/clothing/gloves/captain = 0.1,
		/obj/item/clothing/gloves/combat = 0.2,
		/obj/item/clothing/gloves/yellow/budget = 1.2,
		/obj/item/clothing/gloves/latex = 0.5,
		/obj/item/clothing/gloves/latex/nitrile = 0.4,
		/obj/item/clothing/gloves/yellow = 0.9
	)

/obj/random/watches
	name = "random watches"
	desc = "Random watches, probably able to tell the time."
	icon_state = "watch"
	problist = list(
		/obj/item/clothing/wrists/watch = 1,
		/obj/item/clothing/wrists/watch/silver = 0.7,
		/obj/item/clothing/wrists/watch/gold = 0.5,
		/obj/item/clothing/wrists/watch/spy = 0.3,
	)

/obj/random/hoodie
	name = "random winter coat"
	desc = "This is a random winter coat."
	icon_state = "wintercoat"
	problist = list(
		/obj/item/clothing/suit/storage/hooded/wintercoat = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hydro = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/cargo = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/miner = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/captain = 1
	)

/obj/random/bandana
	name = "random bandana"
	desc = "This is a random bandana."
	icon_state = "bandana"
	problist = list(
		/obj/item/clothing/head/bandana/colorable/random = 5,
		/obj/item/clothing/head/bandana/engineering = 3,
		/obj/item/clothing/head/bandana/atmos = 3,
		/obj/item/clothing/head/bandana/medical = 3,
		/obj/item/clothing/head/bandana/science = 3,
		/obj/item/clothing/head/bandana/hydro = 3,
		/obj/item/clothing/head/bandana/cargo = 3,
		/obj/item/clothing/head/bandana/miner = 3,
		/obj/item/clothing/head/bandana/security = 2,
		/obj/item/clothing/head/bandana/captain = 1
	)

/obj/random/softcap
	name = "random softcap"
	desc = "This is a random softcap."
	icon_state = "softcap"
	problist = list(
		/obj/item/clothing/head/softcap/colorable/random = 5,
		/obj/item/clothing/head/softcap/engineering = 3,
		/obj/item/clothing/head/softcap/atmos = 3,
		/obj/item/clothing/head/softcap/medical = 3,
		/obj/item/clothing/head/softcap/science = 3,
		/obj/item/clothing/head/softcap/hydro = 3,
		/obj/item/clothing/head/softcap/cargo = 3,
		/obj/item/clothing/head/softcap/miner = 3,
		/obj/item/clothing/head/softcap/security = 2,
		/obj/item/clothing/head/softcap/captain = 1
	)

/obj/random/beret
	name = "random beret"
	desc = "This is a random beret."
	icon_state = "beret"
	problist = list(
		/obj/item/clothing/head/beret/colorable/random = 5,
		/obj/item/clothing/head/beret/engineering = 3,
		/obj/item/clothing/head/beret/atmos = 3,
		/obj/item/clothing/head/beret/medical = 3,
		/obj/item/clothing/head/beret/science = 3,
		/obj/item/clothing/head/beret/hydro = 3,
		/obj/item/clothing/head/beret/cargo = 3,
		/obj/item/clothing/head/beret/miner = 3,
		/obj/item/clothing/head/beret/security = 2,
		/obj/item/clothing/head/beret/captain = 1
	)

/obj/random/hardhat
	name = "random hardhat"
	desc = "This is a random hardhat."
	icon_state = "hardhat"
	problist = list(
		/obj/item/clothing/head/hardhat = 1,
		/obj/item/clothing/head/hardhat/orange = 1,
		/obj/item/clothing/head/hardhat/red = 1,
		/obj/item/clothing/head/hardhat/green = 1,
		/obj/item/clothing/head/hardhat/dblue = 1,
		/obj/item/clothing/head/hardhat/white = 0.5,
		/obj/item/clothing/head/hardhat/atmos = 0.1,
		/obj/item/clothing/head/hardhat/paramedic = 0.1,
		/obj/item/clothing/head/hardhat/firefighter = 0.1
	)

/obj/random/wizard_dressup
	name = "random wizard clothes"
	desc = "This is a random piece of fake wizard clothing."
	icon_state = "wizardstaff"
	has_postspawn = TRUE

/obj/random/wizard_dressup/spawn_item()
	var/obj/item/clothing/suit/wizrobe/W = pick(typesof(/obj/item/clothing/suit/wizrobe))
	. = new W(loc)

/obj/random/wizard_dressup/post_spawn(obj/thing)
	var/obj/item/clothing/head/wizard/H = pick(typesof(/obj/item/clothing/head/wizard))
	new H(loc)
