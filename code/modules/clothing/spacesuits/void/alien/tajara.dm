/obj/item/clothing/suit/space/void/pra
	name = "kosmostrelki voidsuit"
	desc = "A tajaran voidsuit used by the crew of the Republican Orbital Fleet."
	desc_extended = "The People's Republic of Adhomai enjoys having the only militarized spaceships of all the factions on Adhomai. Initially they relied on contracting outside \
	protection from NanoTrasen and the Sol Alliance in order to defend their orbit from raiders. However, the Republican Navy has striven to become independent. With the help of \
	contracted engineers, access to higher education abroad and training from Sol Alliance naval advisers, the People's Republic has been able to commission and crew some of its own \
	ships. The Republican Navy's space-arm primarily conducts counter piracy operations in conjunction with fending off raiders."
	icon_state = "cosmo_suit"
	item_state = "cosmo_suit"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/melee/energy/sword,
		/obj/item/handcuffs
	)
	species_restricted = list(BODYTYPE_TAJARA)
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/pra
	name = "kosmostrelki voidsuit helmet"
	desc = "A tajaran helmet used by the crew of the Republican Orbital Fleet."
	desc_extended = "The People's Republic of Adhomai enjoys having the only militarized spaceships of all the factions on Adhomai. Initially they relied on contracting outside \
	protection from NanoTrasen and the Sol Alliance in order to defend their orbit from raiders. However, the Republican Navy has striven to become independent. With the help of \
	contracted engineers, access to higher education abroad and training from Sol Alliance naval advisers, the People's Republic has been able to commission and crew some of its own \
	ships. The Republican Navy's space-arm primarily conducts counter piracy operations in conjunction with fending off raiders."
	icon_state = "cosmo_suit"
	item_state = "cosmo_suit"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	species_restricted = list(BODYTYPE_TAJARA)
	refittable = FALSE

//okon suits

/obj/item/clothing/suit/space/void/okon
	name = "okon voidsuit"
	desc = "A colorful tajaran voidsuit used by the crew of Okon 001."
	desc_extended = "The first observation post built on the moon, originally constructed by the Nralakk Federation and named Site B2134. Its original purpose was to observe the Tajara people, \
	but after their rapid ascension to space age technology, the observation post was abandoned and sold to the PRA for a suspiciously low price. It was subsequently renamed to Okon 001, \
	which translates to Eye in Siik'maas."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "okonsuit-red"
	item_state = "okonsuit-red"
	contained_sprite = TRUE
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/melee/energy/sword,
		/obj/item/handcuffs
	)
	species_restricted = list(BODYTYPE_TAJARA)
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/okon
	name = "okon voidsuit helmet"
	desc = "A colorful tajaran helmet used by the crew of Okon 001."
	desc_extended = "The first observation post built on the moon, originally constructed by the Nralakk Federation and named Site B2134. Its original purpose was to observe the Tajara people, \
	but after their rapid ascension to space age technology, the observation post was abandoned and sold to the PRA for a suspiciously low price. It was subsequently renamed to Okon 001, \
	which translates to Eye in Siik'maas."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "okonhelmet-red"
	item_state = "okonhelmet-red"
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_TAJARA)
	refittable = FALSE

/obj/item/clothing/suit/space/void/okon/green
	icon_state = "okonsuit-green"
	item_state = "okonsuit-green"

/obj/item/clothing/head/helmet/space/void/okon/green
	icon_state = "okonhelmet-green"
	item_state = "okonhelmet-green"

/obj/item/clothing/suit/space/void/okon/blue
	icon_state = "okonsuit-blue"
	item_state = "okonsuit-blue"

/obj/item/clothing/head/helmet/space/void/okon/blue
	icon_state = "okonhelmet-blue"
	item_state = "okonhelmet-blue"

/obj/item/clothing/suit/space/void/okon/purple
	icon_state = "okonsuit-purple"
	item_state = "okonsuit-purple"

/obj/item/clothing/head/helmet/space/void/okon/purple
	icon_state = "okonhelmet-purple"
	item_state = "okonhelmet-purple"

/obj/item/clothing/suit/space/void/okon/yellow
	icon_state = "okonsuit-yellow"
	item_state = "okonsuit-yellow"

/obj/item/clothing/head/helmet/space/void/okon/yellow
	icon_state = "okonhelmet-yellow"
	item_state = "okonhelmet-yellow"

/obj/item/clothing/suit/space/void/nka
	name = "new kingdom mercantile voidsuit"
	desc = "An amalgamation of old civilian voidsuits and diving suits. This bulky space suit is used by the crew of the New Kingdom's mercantile navy."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "nkavoid"
	item_state = "nkavoid"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/melee/energy/sword,
		/obj/item/handcuffs
	)
	species_restricted = list(BODYTYPE_TAJARA)
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/nka
	name = "new kingdom mercantile voidsuit helmet"
	desc = "An amalgamation of old civilian voidsuits and diving suits. This bulky space suit is used by the crew of the New Kingdom's mercantile navy."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "nkavoidhelm"
	item_state = "nkavoidhelm"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	species_restricted = list(BODYTYPE_TAJARA)
	refittable = FALSE

/obj/item/clothing/suit/space/void/dpra
	name = "people's volunteer spacer militia voidsuit"
	desc = "A refitted, sturdy voidsuit created from Hegemony models acquired during the liberation of Gakal'zaal. These armored models are issued to the People's Volunteer Spacer Militia."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "DPRA_voidsuit"
	item_state = "DPRA_voidsuit"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/melee/energy/sword,
		/obj/item/handcuffs
	)
	species_restricted = list(BODYTYPE_TAJARA)
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/dpra
	name = "people's volunteer spacer militia voidsuit helmet"
	desc = "A refitted, sturdy voidsuit created from Hegemony models acquired during the liberation of Gakal'zaal. These armored models are issued to the People's Volunteer Spacer Militia."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "DPRA_voidsuit_helmet"
	item_state = "DPRA_voidsuit_helmet"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	species_restricted = list(BODYTYPE_TAJARA)
	refittable = FALSE
