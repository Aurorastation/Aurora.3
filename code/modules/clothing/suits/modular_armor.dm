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
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_PLATE, ACCESSORY_SLOT_ARM_GUARDS, ACCESSORY_SLOT_LEG_GUARDS, ACCESSORY_SLOT_ARMOR_POCKETS, ACCESSORY_SLOT_GENERIC, ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_CAPE, ACCESSORY_SLOT_UTILITY_MINOR)
	pockets = null

/obj/item/clothing/suit/armor/carrier/dominia
	name = "imperial army flak vest"
	desc = "Standard-issue body armor used by the Imperial Army. Has attachment points for a steel body armor plate."
	desc_extended = "While not offering the protection of an entire armor set, the Empire's flak vests protect the wearer from shrapnel, some ballistics, \
	and weak lasers. It is significantly more comfortable to wear than a full steel plate, and many soldiers on Sun Reach only wear their flak vests — \
	much to the dismay of officers."
	icon_state = "dom_carrier"
	icon_state = "dom_carrier"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SMALL
	)

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

/obj/item/clothing/suit/armor/carrier/scc
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/scc,
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

/obj/item/clothing/suit/armor/carrier/tcaf
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/tcaf,
		/obj/item/clothing/accessory/leg_guard/tcaf,
		/obj/item/clothing/accessory/arm_guard/tcaf,
		/obj/item/clothing/accessory/storage/chestpouch
	)

/obj/item/clothing/suit/armor/carrier/tcaf/tcaf_light
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/tcaf/tcaf_light,
		/obj/item/clothing/accessory/leg_guard/tcaf,
		/obj/item/clothing/accessory/storage/chest_gear
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

/obj/item/clothing/accessory/armor_plate/scc
	name = "scc armor plate"
	desc = "A light-weight kevlar armor plate in SCC corporate colors. Often issued to untrained personnel, to help with identification."
	icon_state = "plate_blue"
	item_state = "plate_scc"

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
		bullet = ARMOR_BALLISTIC_RIFLE,
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
		laser = ARMOR_LASER_MAJOR,
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
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_RIFLE,
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
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_RIFLE,
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

/obj/item/clothing/accessory/armor_plate/heavy/dominia
	name = "imperial army steel body armor"
	desc = "Standard-issue heavy body armor used by the Imperial Army of the Empire of Dominia. When the Goddess' protection is not enough on its own, this will serve."
	desc_extended = "The combat vests used by the Imperial Army protect well against lasers, ballistics, and shrapnel. They can easily turn a fatal injury into a mere \
	wound, and are worn throughout the Imperial Army. Despite the protection it offers this body armor is often hot and uncomfortable to wear due to its weight."
	icon_state = "dom_plate"
	item_state = "dom_plate"

/obj/item/clothing/accessory/armor_plate/tcaf
	name = "\improper TCAF legionnaire carapace"
	desc = "The blue carapace of the Tau Ceti Armed Forces. Polished and proud for Miranda Trasen's favorite soldiers."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "tcaf_plate"
	item_state = "tcaf_plate"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)
	slowdown = 0 // inherited the hacking from the scc

/obj/item/clothing/accessory/armor_plate/tcaf/tcaf_light
	name = "\improper TCAF legionnaire light carapace"
	desc = "A lighter version of the blue carapace of the Tau Ceti Armed Forces. Reserved for recruits, recon, and prissy officers in the field."
	icon_state = "tcaf_plate_light"
	item_state = "tcaf_plate_light"
	slowdown = 0

/obj/item/clothing/accessory/armor_plate/military/navy
	name = "konyang navy armor plate"
	desc = "A military-grade armor plate frequently seen in use by naval landing parties and sailors of the Konyang Navy."
	icon_state = "plate_navy"
	item_state = "plate_navy"

/obj/item/clothing/accessory/armor_plate/press
	name = "press armor plate"
	desc = "A light-weight kevlar armor plate in blue colors and a \"PRESS\" sticker included. Used by wartime correspondents."
	icon_state = "plate_press"
	item_state = "plate_press"

/obj/item/clothing/accessory/armor_plate/military/navy
	name = "konyang navy armor plate"
	desc = "A military-grade armor plate frequently seen in use by naval landing parties and sailors of the Konyang Navy."
	icon_state = "plate_navy"
	item_state = "plate_navy"

/obj/item/clothing/accessory/storage/chestpouch
	name = "chestpouch rig"
	desc = "A harness made to be worn over a set of armor. Comes with three pouches on the front, and a hidden pouch on the back for your snacks!"
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "tcaf_chestpouches"
	item_state = "tcaf_chestpouches"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_ARMOR_POCKETS
	slots = 4

/obj/item/clothing/accessory/storage/chest_gear
	name = "standard vest equipment"
	desc = "the standard pouch and commlink each Minuteman gets issued out of basic. This one has a bullet wedged in the radio, don't expect it to work anytime soon."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "tcaf_chest_gear"
	item_state = "tcaf_chest_gear"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_ARMOR_POCKETS
	slots = 2

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

/obj/item/clothing/accessory/armor_plate/heavy/sec
	name = "heavy corporate armor plate"
	desc = "A heavy and stylish armor plate with blue highlights. That prevents teamkills, right?"
	icon_state = "plate_sec_heavy"
	item_state = "plate_sec_heavy"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MAJOR,
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

/obj/item/clothing/head/helmet/security/scc
	name = "scc helmet"
	desc = "A helmet in SCC colors. Often issued to untrained personnel."
	icon_state = "helm_scc"
	item_state = "helm_scc"

/obj/item/clothing/head/helmet/security/generic
	name = "standard helmet"
	desc = "A shiny helmet in grey! Goes well with the respective plate carrier."
	icon_state = "helm_generic"
	item_state = "helm_generic"

/obj/item/clothing/head/helmet/security/press
	name = "press helmet"
	desc = "A helmet in blue colors with a prominent \"PRESS\" emblazoned in front. A common sight on journalists in the Wildlands."
	icon_state = "helm_press"
	item_state = "helm_press"

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
		bullet = ARMOR_BALLISTIC_MAJOR,
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
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)

/obj/item/clothing/head/helmet/dominia
	name = "imperial army helmet"
	desc = "A standard-issue helmet of the Imperial Army of Dominia. Wear on head for best results."
	desc_extended = "The distinctive outline of the Imperial Army's helmet has made it into a symbol of Dominian imperialism abroad. The helmets themselves protect well \
	against lasers, ballistics, and shrapnel."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	contained_sprite = TRUE
	icon_state = "dom_helmet"
	item_state = "dom_helmet"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)

/obj/item/clothing/head/helmet/dominia/nco
	name = "imperial army NCO helmet"
	desc = "The standard-issue helmet of a non-commissioned officer of the Imperial Army of Dominia. Offers no additional protection."
	icon_state = "dom_helmet_nco"
	item_state = "dom_helmet_nco"

/obj/item/clothing/head/helmet/tcaf
	name = "\improper TCAF legionnaire faceplate helmet"
	desc = "A carapace helmet in the traditional colors of the Tau Ceti Armed Forces. This one equipped with the signature faceplate."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	contained_sprite = TRUE
	icon_state = "tcaf_helm_face"
	item_state = "tcaf_helm_face"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)

/obj/item/clothing/head/helmet/tcaf/tcaf_novisor
	name = "\improper TCAF legionnaire helmet"
	desc = "A carapace helmet in the traditional colors of the Tau Ceti Armed Forces."
	icon_state = "tcaf_helm_novisor"
	item_state = "tcaf_helm_novisor"

/obj/item/clothing/head/helmet/tcaf/tcaf_visor
	name = "\improper TCAF legionnaire visored helmet"
	desc = "A carapace helmet in the traditional colors of the Tau Ceti Armed Forces. This one is equipped with a stylish visor."
	icon_state = "tcaf_helm_visor"
	item_state = "tcaf_helm_visor"

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
	icon_state = "flagpatch"
	item_state = "flagpatch"
	var/shading_state = "flagpatch"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_GENERIC
	flippable = TRUE

/obj/item/clothing/accessory/flagpatch/flip_message(mob/user)
	to_chat(user, "You change \the [src] to be on your [src.flipped ? "shoulder" : "chest"].")

/obj/item/clothing/accessory/flagpatch/Initialize()
	. = ..()
	var/icon/shading_icon
	var/icon/flagpatch_icon = new(icon, icon_state)
	if(shading_state)
		shading_icon = new(icon, shading_state)
		flagpatch_icon.Blend(shading_icon, ICON_MULTIPLY)
		add_overlay(flagpatch_icon)

/obj/item/clothing/accessory/flagpatch/rectangular
	shading_state = null

/obj/item/clothing/accessory/flagpatch/triangular
	icon_state = "flagpatch_triangular"
	item_state = "flagpatch_triangular"
	shading_state = null

/obj/item/clothing/accessory/flagpatch/circular
	icon_state = "flagpatch_circular"
	item_state = "flagpatch_circular"
	shading_state = null

/obj/item/clothing/accessory/flagpatch/square
	icon_state = "flagpatch_square"
	item_state = "flagpatch_square"
	shading_state = null

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
	desc = "A flagpatch representing Europa. It is a common tradition, which nobody really knows the origin of, to make these patches out of waterproof fabric then carry them on a dive, before displaying them on one's own clothes in order to gain good luck."
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

/obj/item/clothing/accessory/flagpatch/venus
	name = "venus flagpatch"
	desc = "A flagpatch representing Venus. While not trendy among people who have use for wearing patches to begin with, the \
	Venusian flag retains solidarity among Cythereans and Jintarians both."
	icon_state = "flagpatch_venus"
	item_state = "flagpatch_venus"

/obj/item/clothing/accessory/flagpatch/luna
	name = "luna flagpatch"
	desc = "A flagpatch representing Luna. The crescent represents Luna itself, and is meant to remind viewers of Selene's headpiece."
	icon_state = "flagpatch_luna"
	item_state = "flagpatch_luna"

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
	shading_state = "flagpatch_triangular"

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

/obj/item/clothing/accessory/flagpatch/nralakk
	name = "nralakk flagpatch"
	desc = "A flagpatch representing the Nralakk Federation. The free use of these patches is a contentious issue back home as \
	there is a fear that their wearers may misrepresent the nation."
	icon_state = "flagpatch_nralakk"
	item_state = "flagpatch_nralakk"

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

/obj/item/clothing/accessory/flagpatch/portantillia
	name = "port antillia flagpatch"
	desc = "A patch bearing the flag of the Union of Port Antillia. Often associated with veterans of the \
	Antillian Provincial Naval Fleets, these patches are a mark of resilience through hard times on the planet."
	icon_state = "flagpatch_portantillia"
	item_state = "flagpatch_portantillia"

/obj/item/clothing/accessory/flagpatch/zora
	name = "zo'ra hive flagpatch"
	desc = "A flagpatch representing the Zo'ra Hive. This flag depicts the Zo'rane capital world of Caprice, \
	bearing a torch representing their position within the Republic of Biesel."
	icon_state = "flagpatch_zora"
	item_state = "flagpatch_zora"

/obj/item/clothing/accessory/flagpatch/klax
	name = "k'lax hive flagpatch"
	desc = "A flagpatch representing the K'lax Hive. This flag depicts the K'laxian capital world of Tret, \
	bearing the quartered colours of the Izweski Hegemony to represent the Hive's vassalage."
	icon_state = "flagpatch_klax"
	item_state = "flagpatch_klax"

/obj/item/clothing/accessory/flagpatch/cthur
	name = "c'thur hive flagpatch"
	desc = "A flagpatch representing the C'thur Hive. This flag depicts the star borne by the Nralakk Federation's \
	own flag, representing the Hive's independence and gracious allegiance toward the Federation."
	icon_state = "flagpatch_cthur"
	item_state = "flagpatch_cthur"

/obj/item/clothing/accessory/flagpatch/sedantis
	name = "sedantis flagpatch"
	desc = "A flagpatch representing the gas giant Sedantis and it's orbiting bodies. Sedantis I, also known as \
	Vaur'avek'uyit, was the homeworld of the Vaurca. Symbolism involving it is often employed to represent greater \
	pan-Vaurcaesian interests over the interests of the individual Hives."
	icon_state = "flagpatch_sedantis"
	item_state = "flagpatch_sedantis"

// Wildlands

/obj/item/clothing/accessory/flagpatch/fsf
	name = "\improper Free Solarian Fleets flagpatch"
	desc = "A patch bearing the ensign of the Free Solarian Fleets, popular among the mercenary group's marines to \
	denote their loyalty."
	desc_extended = "Unique amongst the major successor states in the wildlands were the former Solarian battle fleets \
	of the Free Solarian Fleets. The reason for this uniqueness relate to the Fleets' origins and goals: while they, \
	like many successor states, were formerly a Solarian fleet group, the Free Solarian Fleets did not rule over any \
	planets or claim any greater goals beyond making money hand over fist as mercenaries in the Wildlands. They had \
	an utter disinterest in conquering and holding territory of their own, instead opting to serve as a mercenary fleet \
	for the highest bidder in the Wildlands. The group fought alongside the Middle Ring Shield Pact in the war in the \
	Northern Wildlands."
	icon_state = "flagpatch_fsf"
	item_state = "flagpatch_fsf"

/obj/item/clothing/accessory/flagpatch/league
	name = "\improper League of Independent Corporate-free Systems flagpatch"
	desc = "A patch bearing the ensign of the League of Independent Corporate-Free Systems. Wearing this \
	on a corporate vessel would probably be a bad idea."
	desc_extended = "Many radical political changes followed the retreat of the Solarian Alliance from its \
	Middle and Outer Rings. In most areas this political change was accompanied by a reckoning over what, \
	exactly, had caused the once-great Solarian Alliance to slowly atrophy, decay, and then abandon the majority \
	of its outlying territories. In the Human Wildlands close to the former Alliance Neutral Zone, a proposal \
	regarding this emerged: that the Alliance had collapsed due to the meddling of corporations and if only the \
	Alliance had stood against the forces of interstellar capitalism, it would have never collapsed. Thus from the \
	ashes of the Alliance's colonies emerged something truly unforeseen in the Orion Spur: a left-leaning, anti-corporate \
	successor state to the Alliance in the region. After its defeat in the war in the Northern Wildlands at the hands of the \
	Solarian Restoration Front, the former territories of the League were placed under the Northern Solarian Reconstruction \
	Mandate (NSRM), seeking to rebuild the war torn region."
	icon_state = "flagpatch_league"
	item_state = "flagpatch_league"

/obj/item/clothing/accessory/flagpatch/pact
	name = "\improper Middle Ring Shield Pact flagpatch"
	desc = "A patch bearing the ensign of the Middle Ring Shield Pact. These were popularised by soldiers \
	fighting in the Northern Wildlands from beyond San Colette."
	desc_extended = "Unfortunately located between the Solarian Restoration Front and the League of Independent \
	Corporate-Free Systems was a loosely-aligned cluster of fairly wealthy Middle Ring planets that banded \
	together to form what they referred to as the Middle Ring Shield Pact, a defensive alliance designed to protect \
	them from their neighbors. The Pact was formed shortly after the collapse of Solarian authority within the Middle Ring, \
	and it was one of the first powers to emerge in the warlordism following said retreat of Solarian authority. This, combined \
	with a robust (if arguably megacorporate-owned) local bureaucracy, led to the Pact becoming an island of relative \
	stability in the anarchy of the Northern Wildlands. The Pact was devastated by the war in the Northern Wildlands, being caught \
	between both the Solarian Restoration Front and the League of Independent Corporate-Free Systems, but emerged victorious with \
	the aid of the Alliance. Now it has formed the Northern Solarian Reconstruction Mandate (NSRM), seeking to rebuild the war torn \
	region."
	icon_state = "flagpatch_pact"
	item_state = "flagpatch_pact"

/obj/item/clothing/accessory/flagpatch/sfa
	name = "\improper Solarian Fleet Administration flagpatch"
	desc = "A patch bearing the ensign of the Solarian Fleet Administration. It is a rare sight to see anyone \
	loyal enough to the SFA to have one of these made."
	desc_extended = "Before the total collapse of Solarian authority in much of the Middle and Outer Rings, the Tenth Middle \
	Ring Battlegroup under the command of Fleet Admiral F.R. Beauchamp was considered to be the absolute bottom of the \
	Solarian Navy's figurative barrel. With much of its enlisted being made up of prisoners conscripted or enlisted into \
	the Navy for a reduced prison sentence and the vast majority of its officers being washouts deliberately reassigned to the \
	Tenth due to their failings, discipline was lax even before the phoron crisis. Despite doubts from many Solarian naval \
	officers, the Solarian collapse was a time of many surprises, including the Tenth's shocking rallying under Admiral \
	Beauchamp to form the so-called Southern Fleet Administration shortly after the general Solarian withdraw from the region \
	that would come to be known as the Southern Wildlands. The SFA were all but wiped out by the combined forces of the Southern \
	Solarian Military District and the Solarian Provisional Government, and have since become a loose band of bandits and pirates \
	operating in lawless regions of space throughout the Spur."
	icon_state = "flagpatch_sfa"
	item_state = "flagpatch_sfa"

/obj/item/clothing/accessory/flagpatch/spg
	name = "\improper Solarian Provisional Government flagpatch"
	desc = "A patch bearing the ensign of the Solarian Provisional Government, most commonly worn by the \
	Provisional Government's law enforcement."
	desc_extended = "In the Southern Human Wildlands lay the Solarian Provisional Government, the remnants of the Solarian \
	Alliance's massive bureaucratic apparatus that once lorded over the vast majority of the Middle Ring. While it was a mere rump \
	state compared to the titanic bureaucracy that once managed planets from Mictlan to New Hai Phong and most of its skilled bureaucrats \
	fled to the what remained of the Alliance, the SPG managed to hold onto a small amount of ground near the Solarian border with the \
	Wildlands thanks to the presence of the Sixth Middle Ring Battlegroup and unofficial support from the Alliance itself. The SPG aligned \
	itself closely with the Alliance and the Alliance responded by offering “humanitarian” aid to the region under the SPG's control. \
	In response the provisional government stated its clear intentions to rejoin the Alliance when the region around it stabilized. The \
	Provisional Government has since merged with the Southern Solarian Military District to form the Southern Solarian Reconstruction \
	Mandate (SSRM) shortly after the civil war in wake of the unrest and casualties that Szalai and MacPherson sought to undo."
	icon_state = "flagpatch_spg"
	item_state = "flagpatch_spg"

/obj/item/clothing/accessory/flagpatch/srf
	name = "\improper Solarian Restoration Front flagpatch"
	desc = "A patch bearing the ensign of the Solarian Restoration Front. Considering the near universal hatred \
	of the Front across the Spur, wearing this would be a bold move."
	desc_extended = "Extremely nationalistic even by the standards of the authoritarian Solarian Alliance, the Solarian \
	Restoration Front is often rightfully viewed as the most militaristic of the Solarian successor states that jockied for control \
	of the Wildlands that had made up the former Middle and Outer Rings of the Solarian Alliance. The Front believed that the Alliance's \
	third Tajara ban was both not enough and too soft on aliens in the Alliance, and they viewed this softness as the main cause for its collapse. \
	Thus the Front strived to create a highly-militarized, extremely authoritarian, and human-only state in the Wildlands as a basis for purifying \
	the Sol Alliance itself of degenerating alien influence, no matter the cost. Defeated by a surprise intervention in the Northern Wildlands by \
	the Alliance, the former territories of the Front were placed under the Northern Solarian Reconstruction Mandate (NSRM), seeking to rebuild the war torn region."
	icon_state = "flagpatch_srf"
	item_state = "flagpatch_srf"

/obj/item/clothing/accessory/flagpatch/ssmd
	name = "\improper Southern Solarian Military District flagpatch"
	desc = "A patch bearing the ensign of the Southern Solarian Military District. These patches are very common, \
	with most Military District marines being issued one upon enlisting."
	desc_extended = "While many of the fleets assigned to the area that would become the Southern Wildlands were considered second or even third-rate \
	organizations, one formation stood above the rest in terms of quality. The First Middle Ring Battlefleet - made up of the 103rd through 107th fleets \
	- under the command of Fleet Admiral Klaudia Szalai was considered to be the best fleet in the sector before it was lost during the chaos of the \
	Solarian collapse due to a lack of phoron for its dated engines. It came as quite a shock for many observers when, nearly a full month after the collapse, \
	Admiral Szalai finally reestablished communications with the outside world and declared that the First had formed the Southern Solarian Military District, \
	and was intent on stabilizing the Southern Wildlands pending their reintegration with the Alliance. The Southern District has since merged with the Solarian \
	Provisional Government to form the Southern Solarian Reconstruction Mandate (SSRM) shortly after the civil war in wake of the unrest and casualties that \
	Szalai and MacPherson sought to undo."
	icon_state = "flagpatch_ssmd"
	item_state = "flagpatch_ssmd"

/obj/item/clothing/accessory/tcaf_prefect_pauldron
	name = "\improper TCAF prefect pauldron"
	desc = "A bright red hard pauldron to indicate the wearer has the rank of Prefect in the Tau Ceti Armed Forces."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "tcaf_prefect_pauldron"
	item_state = "tcaf_prefect_pauldron"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_GENERIC
	flippable = FALSE

/obj/item/clothing/accessory/tcaf_senior_legion_pauldron
	name = "\improper TCAF senior legionnaire pauldron"
	desc = "A blue hard pauldron to indicate the wearer has the rank of Senior Legionnaire in the Tau Ceti Armed Forces."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "tcaf_senior_legion_pauldron"
	item_state = "tcaf_senior_legion_pauldron"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_GENERIC
	flippable = FALSE
