/**********
* Medical *
**********/
/datum/uplink_item/item/medical
	category = /datum/uplink_category/medical

/datum/uplink_item/item/medical/sinpockets
	name = "Box of Sin-Pockets"
	bluecrystal_cost = 1
	path = /obj/item/storage/box/sinpockets

/datum/uplink_item/item/medical/lunchbox
	name = "Tactical Lunchbox"
	bluecrystal_cost = 1
	path = /obj/item/storage/toolbox/lunchbox/syndicate/filled

/datum/uplink_item/item/medical/sanasomnum
	name = "Sanasomnum Injector"
	bluecrystal_cost = 3
	item_limit = 2
	path = /obj/item/reagent_containers/hypospray/autoinjector/sanasomnum

/datum/uplink_item/item/medical/combathypo
	name = "Combat Hypospray"
	bluecrystal_cost = 2
	path = /obj/item/reagent_containers/hypospray/combat

/datum/uplink_item/item/medical/surgery
	name = "Surgery Kit"
	bluecrystal_cost = 1
	path = /obj/item/storage/firstaid/surgery

/datum/uplink_item/item/medical/combat
	name = "Combat Medical Kit"
	bluecrystal_cost = 2
	path = /obj/item/storage/firstaid/combat

/datum/uplink_item/item/medical/medicalbelt
	name = "Fully Loaded Combat Medical Belt"
	bluecrystal_cost = 3
	path = /obj/item/storage/belt/medical/first_responder/combat/full
	desc = "A fully loaded medical belt even Zeng-Hu's top First Responders would be dying to wear. It contains liquid medicines and a hypospray. Combat hypo sold separately."

/datum/uplink_item/item/medical/defib
	name = "Combat Defibrillator"
	bluecrystal_cost = 2
	path = /obj/item/shockpaddles/standalone/traitor
	desc = "A pair of fully autonomous shockpaddles powered by a miniaturised reactor. These can penetrate through armour, unlike commercial paddles."

/datum/uplink_item/item/medical/stimulants
	name = "Box of Combat Stimulants"
	bluecrystal_cost = 4
	path = /obj/item/storage/box/syndie_kit/stimulants

/datum/uplink_item/item/medical/stabilisation
	name = "Slimline Stabilisation Kit"
	desc = "A pocket-sized medkit filled with lifesaving equipment."
	bluecrystal_cost = 2
	path = /obj/item/storage/firstaid/sleekstab

/datum/uplink_item/item/medical/berserk_injectors
	name = "Box of Berserk Injectors"
	bluecrystal_cost = 4
	path = /obj/item/storage/box/syndie_kit/berserk_injectors
	desc = "Comes with 2x autoinjectors filled with Red Nightshade - used to induce a berserk state lasting ~2.5 minutes per injector. You cannot use advanced tools (guns/computer consoles/etc.) while berserk. Using both injectors will increase time berserk, but will lead to liver failure."

/datum/uplink_item/item/medical/sideeffectbegone
	name = "Box of Sideeffect-Be-Gone Injectors"
	bluecrystal_cost = 2
	path = /obj/item/storage/box/syndie_kit/sideeffectbegone

/datum/uplink_item/item/medical/firstaid
	name = "Standard First-Aid Kit"
	bluecrystal_cost = 1
	path = /obj/item/storage/firstaid/regular

/datum/uplink_item/item/medical/firstaid/free
	name = "Standard First-Aid Kit (Free)"
	telecrystal_cost = 0
	bluecrystal_cost = 0
	item_limit = 1
	path = /obj/item/storage/firstaid/regular
	desc = "You can claim this first-aid kit only once."

/datum/uplink_item/item/medical/advfirstaid
	name = "Advanced First-Aid Kit"
	bluecrystal_cost = 1
	path = /obj/item/storage/firstaid/adv
	desc = "Note: doesn't come with a medical scanner."

/datum/uplink_item/item/medical/bloodpack
	name = "O- blood pack"
	bluecrystal_cost = 1
	path = /obj/item/reagent_containers/blood/OMinus
	desc = "If transferring to self or others without a stand, hold firmly in hand, configure the transfer rate and attach the tubing carefully."
