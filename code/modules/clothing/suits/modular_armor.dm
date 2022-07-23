/obj/item/clothing/suit/armor/carrier
	name = "plate carrier"
	desc = "A plate carrier that can be decked out with various armor plates and accessories."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	contained_sprite = TRUE
	icon_state = "plate_carrier"
	item_state = "plate_carrier"
	blood_overlay_type = "armor"
	w_class = ITEMSIZE_NORMAL
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMOR_PLATE, ACCESSORY_SLOT_ARM_GUARDS, ACCESSORY_SLOT_LEG_GUARDS, ACCESSORY_SLOT_ARMOR_POCKETS)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_PLATE, ACCESSORY_SLOT_ARM_GUARDS, ACCESSORY_SLOT_LEG_GUARDS, ACCESSORY_SLOT_ARMOR_POCKETS, ACCESSORY_SLOT_GENERIC, ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_CAPE)
	pockets = null

/obj/item/clothing/suit/armor/carrier/officer
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate,
		/obj/item/clothing/accessory/storage/modular_pouch
	)

/obj/item/clothing/suit/armor/carrier/hos
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate,
		/obj/item/clothing/accessory/storage/modular_pouch/large,
		/obj/item/clothing/accessory/sec_commander_stripes
	)

/obj/item/clothing/suit/armor/carrier/generic
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/generic,
		/obj/item/clothing/accessory/storage/modular_pouch
	)

/obj/item/clothing/suit/armor/carrier/riot
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/riot,
		/obj/item/clothing/accessory/leg_guard/riot,
		/obj/item/clothing/accessory/arm_guard/riot,
		/obj/item/clothing/accessory/storage/modular_pouch
	)

/obj/item/clothing/suit/armor/carrier/ballistic
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/ballistic,
		/obj/item/clothing/accessory/leg_guard/ballistic,
		/obj/item/clothing/accessory/arm_guard/ballistic,
		/obj/item/clothing/accessory/storage/modular_pouch/large
	)

/obj/item/clothing/suit/armor/carrier/ablative
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/ablative,
		/obj/item/clothing/accessory/leg_guard/ablative,
		/obj/item/clothing/accessory/arm_guard/ablative,
		/obj/item/clothing/accessory/storage/modular_pouch/large
	)

/obj/item/clothing/suit/armor/carrier/military
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/military,
		/obj/item/clothing/accessory/leg_guard/military,
		/obj/item/clothing/accessory/arm_guard/military,
		/obj/item/clothing/accessory/storage/modular_pouch/large
	)

/obj/item/clothing/suit/armor/carrier/heavy
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/heavy,
		/obj/item/clothing/accessory/leg_guard/heavy,
		/obj/item/clothing/accessory/arm_guard/heavy,
		/obj/item/clothing/accessory/storage/modular_pouch/large
	)

/obj/item/clothing/suit/armor/carrier/heavy/scc
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/heavy/scc,
		/obj/item/clothing/accessory/leg_guard/heavy/scc,
		/obj/item/clothing/accessory/arm_guard/heavy/scc,
		/obj/item/clothing/accessory/storage/modular_pouch/large,
		/obj/item/clothing/accessory/sleevepatch/scc
	)

/obj/item/clothing/suit/armor/carrier/heavy/sec
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/heavy/sec,
		/obj/item/clothing/accessory/leg_guard/heavy/sec,
		/obj/item/clothing/accessory/arm_guard/heavy/sec,
		/obj/item/clothing/accessory/storage/modular_pouch/large
	)

/obj/item/clothing/accessory/armor_plate
	name = "corporate armor plate"
	desc = "A particularly light-weight armor plate in stylish corporate black. Unfortunately, not very good if you hold it with your hands."
	desc_info = "These items must be hooked onto plate carriers for them to work!"
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "plate_sec"
	item_state = "plate_sec"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_ARMOR_PLATE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	w_class = ITEMSIZE_NORMAL
	armor = list(
		melee = ARMOR_MELEE_KEVLAR,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_KEVLAR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/armor_plate/generic
	name = "standard armor plate"
	desc = "A light-weight kevlar armor plate in drab black colors. A galactic favourite of Zavodskoi fans."
	icon_state = "plate_generic"
	item_state = "plate_generic"

/obj/item/clothing/accessory/armor_plate/hos
	name = "commander armor plate"
	desc = "A particularly light-weight armor plate with really cool gold bands. Even more stylish when the gold bands are covered in the blood of your goons!"
	icon_state = "plate_sec_commander"
	item_state = "plate_sec_commander"

/obj/item/clothing/accessory/armor_plate/ballistic
	name = "ballistic armor plate"
	desc = "A heavy alloy ballistic armor plate in gunmetal grey. Shockingly stylish, but also shockingly tiring to wear!"
	icon_state = "plate_ballistic"
	item_state = "plate_ballistic"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_AP,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
	slowdown = 1

/obj/item/clothing/accessory/armor_plate/riot
	name = "riot armor plate"
	desc = "A heavily padded riot armor plate. Many Biesellites wish they had these for Black Friday!"
	icon_state = "plate_riot"
	item_state = "plate_riot"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
	slowdown = 1

/obj/item/clothing/accessory/armor_plate/ablative
	name = "ablative armor plate"
	desc = "A heavy ablative armor plate. Shine like a diamond!"
	icon_state = "plate_ablative"
	item_state = "plate_ablative"
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_AP,
		energy = ARMOR_ENERGY_RESISTANT
	)
	slowdown = 1
	siemens_coefficient = 0

/obj/item/clothing/accessory/armor_plate/military
	name = "sol army armor plate"
	desc = "A heavy military armor plate. Standard-issue to the oft-forgotten Solarian Army."
	icon_state = "plate_military"
	item_state = "plate_military"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_REVOLVER,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)
	slowdown = 1

/obj/item/clothing/accessory/armor_plate/heavy
	name = "heavy armor plate"
	desc = "A heavy and menacing armor plate. Tan armor plates went out of style centuries ago!"
	icon_state = "plate_heavy"
	item_state = "plate_heavy"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_REVOLVER,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)
	slowdown = 1

/obj/item/clothing/accessory/armor_plate/heavy/scc
	name = "heavy SCC armor plate"
	desc = "A heavy and nondescript armor plate. You really get the idea they wanted these mooks to be unfeeling."
	icon_state = "plate_blue"
	item_state = "plate_blue"
	slowdown = 0 // the SCC is hacking

/obj/item/clothing/accessory/storage/modular_pouch
	name = "plate carrier pouches"
	desc = "A comfortable set of pouches that can be attached to a plate carrier, allowing the wearer to store some small items."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "modular_pouch"
	item_state = "modular_pouch"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_ARMOR_POCKETS
	slots = 2

/obj/item/clothing/accessory/storage/modular_pouch/large
	name = "large plate carrier pouches"
	desc = "A comfortable set of pouches that can be attached to a plate carrier, allowing the wearer to store some small items. This one uses advanced sewing techniques for additional storage capacity."
	icon_state = "modular_pouch_l"
	item_state = "modular_pouch_l"
	slots = 3

/obj/item/clothing/accessory/holster/modular
	name = "plate carrier holster"
	desc = "A special holster with rigging able to attach to modern modular plate carriers."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "modular_holster"
	item_state = "modular_holster"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_ARMOR_POCKETS
	flippable = FALSE

/obj/item/clothing/accessory/armor_plate/heavy/sec
	name = "heavy corporate armor plate"
	desc = "A heavy and stylish armor plate with blue highlights. That prevents teamkills, right?"
	icon_state = "plate_sec_heavy"
	item_state = "plate_sec_heavy"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_REVOLVER,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/head/helmet/security
	name = "corporate helmet"
	desc = "A shiny helmet in corporate black! Goes well with the respective plate carrier."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	contained_sprite = TRUE
	icon_state = "helm_sec"
	item_state = "helm_sec"

/obj/item/clothing/head/helmet/security/generic
	name = "standard helmet"
	desc = "A shiny helmet in grey! Goes well with the respective plate carrier."
	icon_state = "helm_generic"
	item_state = "helm_generic"

/obj/item/clothing/head/helmet/security/skrell
	name = "skrellmet"
	desc = "A helmet built for use by a Skrell. This one appears to be fairly standard and reliable."
	icon_state = "helm_skrell"
	item_state = "helm_skrell"
	valid_accessory_slots = null

/obj/item/clothing/head/helmet/security/heavy
	name = "corporate heavy helmet"
	desc = "A shiny and heavy helmet in corporate black! Goes well with the respective plate carrier."
	icon_state = "helm_sec_heavy"
	item_state = "helm_sec_heavy"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_REVOLVER,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)

/obj/item/clothing/head/helmet/military
	name = "sol army helmet"
	desc = "A helmet in drab olive. Standard-issue to the oft-forgotten Solarian Army. Comes with a fancy military HUDglass."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	contained_sprite = TRUE
	icon_state = "helm_military"
	item_state = "helm_military"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_REVOLVER,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)


//Cosmetic Accessories

/obj/item/clothing/accessory/sec_commander_stripes
	name = "head of security stripes"
	desc = "A set of high visibility inserts for use in armour. This one declares the wearer as a Head of Security."
	icon = 'icons/clothing/kit/modular_armor_accessories.dmi'
	icon_state = "sec_commander_stripes"
	item_state = "sec_commander_stripes"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_GENERIC
	flippable = FALSE

/obj/item/clothing/accessory/flagpatch
	name = "flagpatch"
	desc = "A simple strip of fabric attached to a vest or helmet typically used to denote the wearer's \
	organization or nationality."
	icon = 'icons/clothing/kit/modular_armor_accessories.dmi'
	icon_state = "flagpatch_colorable"
	item_state = "flagpatch_colorable"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_GENERIC
	flippable = FALSE

/obj/item/clothing/accessory/flagpatch/biesel
	name = "republic of biesel flagpatch"
	desc = "A flagpatch representing the Republic of Biesel. A common sight in the CRZ, they became incredibly popular \
	after the formation of the Tau Ceti Foreign Legion as a cheap way to quickly identify people and equipment as belonging \
	to the organization."
	icon_state = "flagpatch_biesel"
	item_state = "flagpatch_biesel"

/obj/item/clothing/accessory/flagpatch/valkyrie
	name = "valkyrie flagpatch"
	desc = "A flagpatch representing te Commonwealth of Valkyrie. Regarded as the gate to Tau Ceti, just as many foreigners as Valkyrians can be found wearing these patches."
	icon_state = "flagpatch_valkyrie"
	item_state = "flagpatch_valkyrie"

/obj/item/clothing/accessory/flagpatch/mictlan
	name = "mictlan flagpatch"
	desc = "A flagpatch representing Mictlan. These patches are not commonly worn as they are viewed as a flag imposed by a colonial government."
	icon_state = "flagpatch_mictlan"
	item_state = "flagpatch_mictlan"

/obj/item/clothing/accessory/flagpatch/newgibson
	name = "new gibson flagpatch"
	desc = "A flagpatch representing New Gibson. With the need for quick identification in the tunnels of the planet, these patches are often printed in reflective colors to be seen more \
	clearly."
	icon_state = "flagpatch_newgibson"
	item_state = "flagpatch_newgibson"

/obj/item/clothing/accessory/flagpatch/sol
	name = "sol alliance flagpatch"
	desc = "A flagpatch representing the Alliance of Sovereign Solarian Nations. Until the collapse of Sol, this flag used to represent the greatest collection of people within the Spur and many \
	still wear it in hope for a return to the glory days of the past."
	icon_state = "flagpatch_sol"
	item_state = "flagpatch_sol"

/obj/item/clothing/accessory/flagpatch/mars
	name = "mars flagpatch"
	desc = "A flagpatch representing the Provisional Government of Mars. The flag itself is wildly polarizing, with some viewing it as siding with those who destroyed the Martian people, \
	while others view it as the only choice left to save the planet."
	icon_state = "flagpatch_mars"
	item_state = "flagpatch_mars"

/obj/item/clothing/accessory/flagpatch/gus
	name = "\improper GUS! flagpatch"
	desc = "A flagpatch with the face of Gus Maldarth, a famous Martian whistleblower who exposed the Solarian government abuses in the \
	phoron crisis. After his assassination, 'Justice for Gus!' became a rallying cry for anti-Sol protests on the red planet."
	icon_state = "flagpatch_gus"
	item_state = "flagpatch_gus"

/obj/item/clothing/accessory/flagpatch/eridani
	name = "eridani corporate federation flagpatch"
	desc = "A flagpatch representing the Eridani Corporate Federation. These patches are often resistant to corrosion as a consequence of the toxic atmosphere, \
	not that this has stopped resourceful dregs from desecrating those they can get their hands on."
	icon_state = "flagpatch_eridani"
	item_state = "flagpatch_eridani"

/obj/item/clothing/accessory/flagpatch/europa
	name = "europa flagpatch"
	desc = "A flagpatch representing Europa. It is a common tradition that no one can place the origin of to make these patches out of waterproof fabric then carry \
	them on a dive before displaying them on one's clothes in order to gain good luck."
	icon_state = "flagpatch_europa"
	item_state = "flagpatch_europa"

/obj/item/clothing/accessory/flagpatch/newhaiphong
	name = "new hai phong flagpatch"
	desc = "A flagpatch representing New Hai Phong. With the haggling culture of the planet, the price of these patches can range from free to a thousand credits."
	icon_state = "flagpatch_newhaiphong"
	item_state = "flagpatch_newhaiphong"

/obj/item/clothing/accessory/flagpatch/pluto
	name = "pluto flagpatch"
	desc = "A flagpatch representing Pluto. As loyalty to the party is very important on the communist planet, \
    these patches have become a popular way for Plutonians to display their affiliation with their home."
	icon_state = "flagpatch_pluto"
	item_state = "flagpatch_pluto"

/obj/item/clothing/accessory/flagpatch/visegrad
	name = "visegrad flagpatch"
	desc = "A flagpatch representing Visegrad. You swear you saw this in a trial on the main Solarian news network once."
	icon_state = "flagpatch_visegrad"
	item_state = "flagpatch_visegrad"

/obj/item/clothing/accessory/flagpatch/silversun
	name = "silversun flagpatch"
	desc = "A flagpatch representing Silversun. As Silversun Expatriates are often more loyal to Idris, most wearers of these patches are Originals."
	icon_state = "flagpatch_silversun"
	item_state = "flagpatch_silversun"

/obj/item/clothing/accessory/flagpatch/callisto
	name = "callisto flagpatch"
	desc = "A flagpatch representing the Commonwealth of Callisto for you to like put on your like coat or vest. From the loving detail and choice materials used \
	it is clear that the moon garners a lot of respect from its inhabitants."
	icon_state = "flagpatch_callisto"
	item_state = "flagpatch_callisto"

/obj/item/clothing/accessory/flagpatch/coalition
	name = "coalition flagpatch"
	desc = "A flagpatch representing the Coalition of Colonies. Although used on many Coalition worlds, this flag has also come \
	to represent the Xanu Free League, the capital of the Coalition, in particular."
	icon_state = "flagpatch_coalition"
	item_state = "flagpatch_coalition"

/obj/item/clothing/accessory/flagpatch/elyra
	name = "elyran flagpatch"
	desc = "A flagpatch representing the Serene Republic of Elyra. Although uncommon out of their space, some Elyrans have adopted \
	holographic patches made of hardlight to make their affiliation clear no matter the conditions."
	icon_state = "flagpatch_elyra"
	item_state = "flagpatch_elyra"

/obj/item/clothing/accessory/flagpatch/konyang
	name = "konyang flagpatch"
	desc = "A flagpatch representing Konyang. In the wake of their independence, patches like these became very popular \
	across the planet, oftentimes accompanied by the burning of Solarian counterparts."
	icon_state = "flagpatch_konyang"
	item_state = "flagpatch_konyang"

/obj/item/clothing/accessory/flagpatch/himeo
	name = "himeo flagpatch"
	desc = "A flagpatch representing the United Syndicates of Himeo. For an offworld Himean, it is often not \
	enough to wear the patch of the nation, but often times, many Himeans carry something indicating the specific \
	syndicate they belong to."
	icon_state = "flagpatch_himeo"
	item_state = "flagpatch_himeo"

/obj/item/clothing/accessory/flagpatch/vysoka
	name = "vysoka flagpatch"
	desc = "A flagpatch from Vysoka. Commonly used in addition to the symbology of one's host or home city, \
	but typically only while offworld."
	icon_state = "flagpatch_vysoka"
	item_state = "flagpatch_vysoka"

/obj/item/clothing/accessory/flagpatch/gadpathur
	name = "gadpathur flagpatch"
	desc = "A flagpatch representing the United Planetary Defense Council of Gadpathur. Wearing a cadre patch square on the \
	center of one's chest is often frowned upon as it is viewed as a way of placing group above country."
	icon_state = "flagpatch_gadpathur"
	item_state = "flagpatch_gadpathur"

/obj/item/clothing/accessory/flagpatch/assunzione
	name = "assunzione flagpatch"
	desc = "A flagpatch representing the Republic of Assunzione. In keeping with their culture's love of light, \
	many of these patches are often inlaid with vine when concealment is not an issue to the wearer."
	icon_state = "flagpatch_assunzione"
	item_state = "flagpatch_assunzione"

/obj/item/clothing/accessory/flagpatch/dominia
	name = "dominia flagpatch"
	desc = "A flagpatch bearing the standard of House Keeser, representing the Empire of Dominia. As most imperial \
	forces have sigils engraved on their armor instead, accessories like these are usually privately commissioned."
	icon_state = "flagpatch_dominia"
	item_state = "flagpatch_dominia"

/obj/item/clothing/accessory/flagpatch/fisanduh
	name = "fisanduh flagpatch"
	desc = "A flagpatch representing the Confederated States of Fisanduh. As Fisanduh is also known as the Imperial Occupied Territory \
	of Fisanduh, possessing items like these is a major offense and is swiftly and harsly punished."
	icon_state = "flagpatch_fisanduh"
	item_state = "flagpatch_fisanduh"

/obj/item/clothing/accessory/flagpatch/jargon
	name = "jargon flagpatch"
	desc = "A flagpatch representing the Jargon Federation. The free use of these patches is a contentious issue back home as \
	there is a fear that their wearers may misrepresent the nation."
	icon_state = "flagpatch_jargon"
	item_state = "flagpatch_jargon"

/obj/item/clothing/accessory/flagpatch/pra
	name = "pra flagpatch"
	desc = "A flagpatch representing the People's Republic of Adhomai. As tajara abroad find themselves increasingly exposed \
	to human equipment, these patches have found themselves mass-produced by state-run corporations."
	icon_state = "flagpatch_pra"
	item_state = "flagpatch_pra"

/obj/item/clothing/accessory/flagpatch/dpra
	name = "dpra flagpatch"
	desc = "A flagpatch representing the Democratic People's Republic of Adhomai. The craftsmanship appears \
	excellent despite the materials appearing rudimentary."
	icon_state = "flagpatch_dpra"
	item_state = "flagpatch_dpra"

/obj/item/clothing/accessory/flagpatch/nka
	name = "nka flagpatch"
	desc = "A flagpatch representing the New Kingdom of Adhomai. In an attempt to proudly display their allegiance to \
	the monarchist state, these insignias are often marketed and cheaply sold to NKA tajara going abroad."
	icon_state = "flagpatch_nka"
	item_state = "flagpatch_nka"

/obj/item/clothing/accessory/flagpatch/freecouncil
	name = "free council flagpatch"
	desc = "A patch bearing the flag of the Free Tajaran Council, imported straight from Himeo."
	icon_state = "flagpatch_freecouncil"
	item_state = "flagpatch_freecouncil"

/obj/item/clothing/accessory/flagpatch/hegemony
	name = "hegemony flagpatch"
	desc = "A patch bearing the flag of the Izweski Hegemony. It is high-quality and appears to have the \
	insignia of a well known unathi drapers' guild stitched on the back."
	icon_state = "flagpatch_hegemony"
	item_state = "flagpatch_hegemony"
