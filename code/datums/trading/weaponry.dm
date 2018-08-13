/datum/trader/ship/gunshop
	name = "Gun Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Gun Shop"
	possible_origins = list("Rooty Tootie's Point-n-Shooties", "Bang-Bang Shop", "Wild-Wild-West Shop", "Jacobs", "Vladof", "Keleshnikov", "Hunting Depot", "Big Game Hunters")
	speech = list(
		"hail_generic"      = "Hello hello! I hope you have your permit, oh who are we kidding, you're welcome anyways!",
		"hail_deny"         = "Law dictates that you can fuck off.",
		"trade_complete"    = "Thanks for buying your guns from ORIGIN!",
		"trade_blacklist"   = "We may deal in guns, but that doesn't mean we'll trade for illegal goods...",
		"trade_no_goods"    = "Cash for guns, thats the deal.",
		"trade_not_enough"  = "Guns are expensive! Give us more if you REALLY want it.",
		"how_much"          = "Well, I'd love to give this little beauty to you for VALUE.",
		"compliment_deny"   = "If we were in the same room right now, I'd probably punch you.",
		"compliment_accept" = "Ha! Good one!",
		"insult_good"       = "I expected better from you. I suppose in that, I was wrong.",
		"insult_bad"        = "If I had my gun I'd shoot you!"
	)

	possible_trading_items = list(
		/obj/item/weapon/gun/projectile/pistol               = TRADER_ALL,
		/obj/item/weapon/gun/projectile/colt                 = TRADER_ALL,
		/obj/item/weapon/gun/projectile/sec                  = TRADER_ALL,
		/obj/item/weapon/gun/projectile/shotgun/pump         = TRADER_ALL,
		/obj/item/weapon/gun/projectile/shotgun/doublebarrel = TRADER_ALL,
		/obj/item/weapon/gun/projectile/tanto                = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/projectile/revolver/detective   = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/projectile/revolver/deckard     = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/projectile/leyon                = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/projectile/automatic/x9         = TRADER_THIS_TYPE,
		/obj/item/ammo_magazine/c45m                         = TRADER_ALL,
		/obj/item/ammo_magazine/c45m/empty                   = TRADER_BLACKLIST,
		/obj/item/ammo_magazine/t40                          = TRADER_ALL,
		/obj/item/ammo_magazine/t40/empty                    = TRADER_BLACKLIST,
		/obj/item/ammo_magazine/c38                          = TRADER_ALL,
		/obj/item/ammo_magazine/leyon                        = TRADER_THIS_TYPE,
		/obj/item/ammo_magazine/c45x                         = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/box/beanbags                = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/box/shotgunammo             = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/box/shotgunshells           = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/box/haywireshells           = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/box/incendiaryshells        = TRADER_THIS_TYPE,
		/obj/item/clothing/accessory/holster                 = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/accessory/holster/thigh/fluff     = TRADER_BLACKLIST_ALL
	)

/datum/trader/ship/egunshop
	name = "Energy Gun Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "EGun Shop"
	possible_origins = list("The Emperor's Lasgun Shop", "Hypireon", "Milawan", "Future-Guns", "Solar-Army")
	speech = list(
		"hail_generic"      = "Welcome to the future of warfare! ORIGIN, your one-stop-shop for energy weaponry.",
		"hail_deny"         = "I'm sorry, your communication channel has been blacklisted.",
		"trade_complete"    = "Thank you, your purchase has been logged and you have automatically liked our Spacebook page.",
		"trade_blacklist"   = "I'm sorry, is that a joke?",
		"trade_no_goods"    = "We deal in cash.",
		"trade_not_enough"  = "State of the art weaponry costs more than that.",
		"how_much"          = "All our quality weapons are priceless, but I'd give that to you for VALUE.",
		"compliment_deny"   = "If I was dumber I probably would have believed you.",
		"compliment_accept" = "Yes, I am very smart.",
		"insult_good"       = "Energy weapons are TWICE the gun bullet-based guns are!",
		"insult_bad"        = "Thats... very mean. I won't think twice about blacklisting your channel, so stop."
	)

	possible_trading_items = list(
		/obj/item/weapon/gun/energy/taser                 = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/energy/stunrevolver          = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/energy/xray                  = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/energy/rifle                 = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/energy/rifle/laser           = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/energy/gun                   = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/energy/pistol                = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/energy/gun/nuclear           = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/energy/laser/shotgun         = TRADER_THIS_TYPE,
		/obj/item/clothing/accessory/holster              = TRADER_ALL,
		/obj/item/clothing/accessory/holster/thigh/fluff  = TRADER_BLACKLIST_ALL
	)

/datum/trader/ship/illegalgun
	name = "Comrade Sergei"
	origin = "Comrade Sergei's Humble Shop"
	speech = list(
		"hail_generic"      = "Grrreetings, comrrrade! Sergei hopes they can enjoy his selection of goods, nothing herrre was smuggled!",
		"hail_deny"         = "The shop is closed, comrrrade!",
		"trade_complete"    = "Many thanks, comrrrade, enjoy it!",
		"trade_blacklist"   = "No, no, nothing of this in his shop!",
		"trade_no_goods"    = "He only deals with crrredits, comrrrade!",
		"trade_not_enough"  = "Give him a bit morrre, comrrrade!",
		"how_much"          = "Only VALUE, just forrr them, comrade!",
		"compliment_deny"   = "They arre speaking like a officerrr, arre they an officerrr?",
		"compliment_accept" = "Pourrr one out for Al'marrri. His gun was on stun, bless his hearrrt.",
		"insult_good"       = "Good one, comrrrade!",
		"insult_bad"        = "Rrrracist!"
	)

	possible_trading_items = list(
		/obj/item/weapon/gun/projectile/shotgun/pump/rifle           = TRADER_ALL,
		/obj/item/weapon/gun/projectile/dragunov                     = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/projectile/silenced                     = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/projectile/automatic/tommygun           = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/projectile/automatic/mini_uzi           = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/projectile/improvised_handgun           = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/projectile/shotgun/improvised           = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/energy/retro                            = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/projectile/revolver/derringer           = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/projectile/pirate                       = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/projectile/contender                    = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/projectile/revolver/lemat               = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/projectile/shotgun/pump/rifle/vintage   = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/energy/rifle/icelance                   = TRADER_THIS_TYPE,
		/obj/item/clothing/accessory/storage/bayonet                 = TRADER_THIS_TYPE
	)


/datum/trader/ship/tactical
	name = "Tactical Gear Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Tactical Gear Shop"
	possible_origins = list("Mall Ninja. Co.", "Hephaestus Defense Supplies", "Tacticool Emporium", "The Redshirt", "The Harmbaton")
	speech = list(
		"hail_generic"      = "Welcome to ORIGIN, you will find everything you need to stay safe.",
		"hail_deny"         = "We refuse to make business with you.",
		"trade_complete"    = "Thank you, And stay safe.",
		"trade_blacklist"   = "I have no use for this",
		"trade_no_goods"    = "Credits or nothing..",
		"trade_not_enough"  = "Our gear is more valuable than this.",
		"how_much"          = "This fine piece will be yours for only VALUE.",
		"compliment_deny"   = "Are you going to buy something any time soon?",
		"compliment_accept" = "Thank you, no one has better tactical gear than us, ORIGIN.",
		"insult_good"       = "Stop, I am not paid to hear this.",
		"insult_bad"        = "Good luck staying safe without us then!"
	)

	possible_trading_items = list(
		/obj/item/clothing/suit/armor/riot                        = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/armor/bulletproof                 = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/armor/laserproof                  = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/armor/tactical                    = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/storage/vest                      = TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet                            = TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/riot                       = TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/ablative                   = TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/ballistic                  = TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/tactical                   = TRADER_THIS_TYPE,
		/obj/item/clothing/glasses/night                          = TRADER_THIS_TYPE,
		/obj/item/clothing/glasses/sunglasses/sechud/tactical     = TRADER_THIS_TYPE,
		/obj/item/clothing/gloves/swat                            = TRADER_THIS_TYPE,
		/obj/item/clothing/shoes/swat                             = TRADER_THIS_TYPE,
		/obj/item/clothing/under/tactical                         = TRADER_THIS_TYPE,
		/obj/item/clothing/mask/gas/tactical                      = TRADER_THIS_TYPE,
		/obj/item/weapon/shield/riot/tact                         = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/belt/security/tactical           = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/belt/bandolier                   = TRADER_THIS_TYPE
	)
