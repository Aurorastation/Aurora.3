/obj/item/clothing/under/pj/red
	name = "red pyjamas"
	desc = "Slightly old-fashioned sleepwear."
	icon_state = "red_pyjamas"
	worn_state = "red_pyjamas"
	item_state = "w_suit"

/obj/item/clothing/under/gearharness
	name = "gear harness"
	desc = "Tight fitting gear harness."
	icon_state = "harness"
	worn_state = "harness"
	item_state = "w_suit"
	body_parts_covered = 0
	species_restricted = null
	sprite_sheets = list(
		BODYTYPE_VAURCA_BREEDER = 'icons/mob/species/breeder/uniform.dmi',
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/uniform.dmi'
		)

/obj/item/clothing/under/pj/blue
	name = "blue pyjamas"
	desc = "Slightly old-fashioned sleepwear."
	icon_state = "blue_pyjamas"
	worn_state = "blue_pyjamas"
	item_state = "w_suit"

/obj/item/clothing/under/suit_jacket/white
	name = "white suit"
	desc = "A white suit, suitable for an excellent host"
	icon_state = "white_suit"
	item_state = "w_suit"
	worn_state = "white_suit"

/obj/item/clothing/under/sl_suit
	desc = "It's a very amish looking suit."
	name = "amish suit"
	icon_state = "sl_suit"
	worn_state = "sl_suit"
	item_state = "sl_suit"

/obj/item/clothing/under/waiter
	name = "waiter's outfit"
	desc = "It's a very smart uniform with a special pocket for tip."
	icon_state = "waiter"
	item_state = "waiter"
	worn_state = "waiter"

//This set of uniforms looks fairly fancy and is generally used for high-ranking NT personnel from what I've seen, so lets give them appropriate ranks.
/obj/item/clothing/under/rank/centcom
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Captain.\""
	name = "officer's dress uniform"
	icon_state = "officer"
	item_state = "bl_suit"
	worn_state = "officer"
	displays_id = 0

/obj/item/clothing/under/rank/centcom_officer
	name = "officer's dress uniform"
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Admiral.\""
	icon_state = "officer"
	item_state = "bl_suit"
	worn_state = "officer"
	displays_id = 0

/obj/item/clothing/under/rank/centcom_captain
	name = "officer's dress uniform"
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Admiral-Executive.\""
	icon_state = "centcom"
	item_state = "bl_suit"
	worn_state = "centcom"
	displays_id = 0

/obj/item/clothing/under/rank/bssb
	name = "\improper BSSB agent uniform"
	desc = "A formal uniform used by Biesel Security Services Bureau agents."
	icon_state = "bssb_uniform"
	worn_state = "bssb_uniform"

/obj/item/clothing/under/rank/scc
	name = "Stellar Corporate Conglomerate agent uniform"
	desc = "A formal blue uniform worn by agents of the Stellar Corporate Conglomerate."
	desc_extended = "The Stellar Corporate Conglomerate, also known as Chainlink, is a joint alliance between the NanoTrasen Corporation, Hephaestus Industries, Idris Incorporated, Zeng-Hu Pharmaceuticals and Zavodskoi Interstellar to exercise an undisputed economic dominance over the Orion Spur."
	icon = 'icons/clothing/under/uniforms/scc.dmi'
	icon_state = "scc_agent"
	item_state = "scc_agent"
	worn_state = "scc_agent"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/scc/executive
	name = "Stellar Corporate Conglomerate executive uniform"
	desc = "A stylish purple uniform worn by executive agents of the Stellar Corporate Conglomerate."
	icon_state = "scc_executive"
	item_state = "scc_executive"
	worn_state = "scc_executive"

/obj/item/clothing/under/ert
	name = "ERT tactical uniform"
	desc = "A short-sleeved black uniform, paired with grey digital-camo cargo pants. It looks very tactical."
	icon_state = "ert_uniform"
	item_state = "bl_suit"
	worn_state = "ert_uniform"
	siemens_coefficient = 0.7

/obj/item/clothing/under/ccpolice
	name = "ERT civil protection uniform"
	desc = "A sturdy navy uniform, carefully ironed and folded. Worn by specialist troopers on civil protection duties."
	icon_state = "civilprotection"
	worn_state = "civilprotection"

/obj/item/clothing/under/rank/centcom_commander
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Commander.\ It has a patch denoting a Pheonix on the sleeves."
	name = "\improper ERT commander's dress uniform"
	icon_state = "centcom"
	item_state = "bl_suit"
	worn_state = "centcom"

/obj/item/clothing/under/space
	name = "\improper NASA jumpsuit"
	desc = "It has a NASA logo on it and is made of space-proofed materials."
	icon_state = "black"
	item_state = "bl_suit"
	worn_state = "black"
	w_class = WEIGHT_CLASS_BULKY//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS //Needs gloves and shoes with cold protection to be fully protected.
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/under/acj
	name = "administrative cybernetic jumpsuit"
	icon_state = "syndicate"
	item_state = "bl_suit"
	worn_state = "syndicate"
	desc = "it's a cybernetically enhanced jumpsuit used for administrative duties."
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	armor = list(
			MELEE = ARMOR_MELEE_VERY_HIGH,
			BULLET = ARMOR_BALLISTIC_AP,
			LASER = ARMOR_LASER_HEAVY,
			ENERGY = ARMOR_ENERGY_SHIELDED,
			BOMB = ARMOR_BOMB_SHIELDED,
			BIO = ARMOR_BIO_SHIELDED,
			RAD = ARMOR_RAD_SHIELDED
			)
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/under/owl
	name = "owl uniform"
	desc = "A jumpsuit with owl wings. Photorealistic owl feathers! Twooooo!"
	icon_state = "owl"
	worn_state = "owl"
	item_state = "owl"

/obj/item/clothing/under/psysuit
	name = "dark undersuit"
	desc = "A thick, layered grey undersuit lined with power cables. Feels a little like wearing an electrical storm."
	icon_state = "psysuit"
	item_state = "bl_suit"
	worn_state = "psysuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/under/gimmick/rank/captain/suit
	name = "captain's suit"
	desc = "A green suit and yellow necktie. Exemplifies authority."
	icon_state = "green_suit"
	item_state = "dg_suit"
	worn_state = "green_suit"

/obj/item/clothing/under/overalls
	name = "laborer's overalls"
	desc = "A set of durable overalls for getting the job done."
	icon_state = "overalls"
	item_state = "lb_suit"
	worn_state = "overalls"

/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit
	name = "head of personnel's suit"
	desc = "A teal suit and yellow necktie. An authoritative yet tacky ensemble."
	icon_state = "teal_suit"
	item_state = "g_suit"
	worn_state = "teal_suit"

/obj/item/clothing/under/suit_jacket
	name = "black suit"
	desc = "A black suit and red tie. Very formal."
	icon_state = "black_suit"
	item_state = "bl_suit"
	worn_state = "black_suit"

/obj/item/clothing/under/suit_jacket/really_black
	name = "executive suit"
	desc = "A formal black suit and red tie, intended for the station's finest."
	icon_state = "really_black_suit"
	item_state = "jensensuit"
	worn_state = "really_black_suit"

/obj/item/clothing/under/suit_jacket/red
	name = "red suit"
	desc = "A red suit and blue tie. Somewhat formal."
	icon_state = "red_suit"
	item_state = "r_suit"
	worn_state = "red_suit"

/obj/item/clothing/under/suit_jacket/nt_skirtsuit
	name = "nanotrasen skirtsuit"
	desc = "A black coat with an NT blue kerchief accompanied by a swept skirt with a tasteful blue stripe. Works for every occasion."
	icon_state = "nt_skirtsuit"
	item_state = "bl_suit"
	worn_state = "nt_skirtsuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/kilt
	name = "kilt"
	desc = "Includes shoes and plaid"
	icon_state = "kilt"
	item_state = "kilt"
	worn_state = "kilt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|FEET

/obj/item/clothing/under/sexymime
	name = "sexy mime outfit"
	desc = "The only time when you DON'T enjoy looking at someone's rack."
	icon_state = "sexymime"
	item_state = "w_suit"
	worn_state = "sexymime"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/gladiator
	name = "gladiator uniform"
	desc = "Are you not entertained? Is that not why you are here?"
	icon_state = "gladiator"
	item_state = "o_suit"
	worn_state = "gladiator"
	body_parts_covered = LOWER_TORSO

//dress
/obj/item/clothing/under/dress
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/dress/dress_fire
	name = "flame dress"
	desc = "A small black dress with blue flames print on it."
	icon_state = "dress_fire"
	item_state = "bl_suit"
	worn_state = "dress_fire"

/obj/item/clothing/under/dress/dress_green
	name = "green dress"
	desc = "A simple, tight fitting green dress."
	icon_state = "dress_green"
	item_state = "g_suit"
	worn_state = "dress_green"

/obj/item/clothing/under/dress/dress_orange
	name = "orange dress"
	desc = "A fancy orange gown for those who like to show leg."
	icon_state = "dress_orange"
	item_state = "y_suit"
	worn_state = "dress_orange"

/obj/item/clothing/under/dress/dress_pink
	name = "pink dress"
	desc = "A simple, tight fitting pink dress."
	icon_state = "dress_pink"
	item_state = "p_suit"
	worn_state = "dress_pink"

/obj/item/clothing/under/dress/dress_yellow
	name = "yellow dress"
	desc = "A flirty, little yellow dress."
	icon_state = "dress_yellow"
	item_state = "y_suit"
	worn_state = "dress_yellow"

/obj/item/clothing/under/dress/dress_hop
	name = "head of personnel dress uniform"
	desc = "Feminine fashion for the style concious HoP."
	icon_state = "dress_hop"
	item_state = "b_suit"
	worn_state = "dress_hop"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/sundress
	name = "sundress"
	desc = "Makes you want to frolic in a field of daisies."
	icon_state = "sundress"
	item_state = "bl_suit"
	worn_state = "sundress"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	no_overheat = TRUE

/obj/item/clothing/under/sundress_white
	name = "white sundress"
	desc = "A white sundress decorated with purple lilies."
	icon_state = "sundress_white"
	item_state = "sundress_white"
	worn_state = "sundress_white"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/dress/stripeddress
	name = "striped dress"
	desc = "Fashion in space."
	icon_state = "striped_dress"

/obj/item/clothing/under/dress/sailordress
	name = "sailor dress"
	desc = "Formal wear for a leading lady."
	icon_state = "sailor_dress"

/obj/item/clothing/under/dress/white
	name = "white dress"
	desc = "A fancy white dress with a blue underdress."
	icon_state = "whitedress"
	flags_inv = HIDESHOES

/obj/item/clothing/under/dress/red_swept_dress
	name = "red swept dress"
	desc = "A red dress that sweeps to the side."
	icon_state = "red_swept_dress"

/obj/item/clothing/under/dress/blacktango
	name = "black tango dress"
	desc = "An earthen black tango dress."
	icon_state = "black_tango"

/obj/item/clothing/under/dress/blacktango/alt
	icon_state = "black_tango_alt"

/obj/item/clothing/under/dress/offworlder
	name = "\improper CR dress"
	desc = "A very tight form-fitting padded suit that looks extremely comfortable to wear, made of strong woven spider-silk. This variant seems to be tailored to resemble a dress, revealing much more skin."
	icon = 'icons/obj/item/clothing/accessory/offworlder.dmi'
	contained_sprite = TRUE
	icon_state = "crdress"
	item_state = "crdress"
	worn_state = "crdress"

/obj/item/clothing/under/dress/offworlder/skirt
	name = "\improper CR dress skirt"
	desc = "A very tight form-fitting padded suit that looks extremely comfortable to wear. This variant seems to have a poofy skirt and longer sleeves than normal."
	icon_state = "crskirt"
	item_state = "crskirt"
	worn_state = "crskirt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/hosformalmale
	name = "head of security's formal uniform"
	desc = "A male head of security's formal-wear, for special occasions."
	icon_state = "hos_formal_male"
	item_state = "r_suit"
	worn_state = "hos_formal_male"

/obj/item/clothing/under/hosformalfem
	name = "head of security's formal uniform"
	desc = "A female head of security's formal-wear, for special occasions."
	icon_state = "hos_formal_fem"
	item_state = "r_suit"
	worn_state = "hos_formal_fem"

/obj/item/clothing/under/suit_jacket/charcoal
	name = "charcoal suit"
	desc = "A charcoal suit and red tie. Very professional."
	icon_state = "charcoal_suit"
	item_state = "bl_suit"
	worn_state = "charcoal_suit"

/obj/item/clothing/under/suit_jacket/navy
	name = "navy suit"
	desc = "A navy suit and red tie, intended for the station's finest."
	icon_state = "navy_suit"
	item_state = "bl_suit"
	worn_state = "navy_suit"

/obj/item/clothing/under/suit_jacket/burgundy
	name = "burgundy suit"
	desc = "A burgundy suit and black tie. Somewhat formal."
	icon_state = "burgundy_suit"
	item_state = "r_suit"
	worn_state = "burgundy_suit"

/obj/item/clothing/under/suit_jacket/checkered
	name = "checkered suit"
	desc = "That's a very nice suit you have there. Shame if something were to happen to it, eh?"
	icon_state = "checkered_suit"
	item_state = "gy_suit"
	worn_state = "checkered_suit"

/obj/item/clothing/under/suit_jacket/tan
	name = "tan suit"
	desc = "A tan suit with a yellow tie. Smart, but casual."
	icon_state = "tan_suit"
	item_state = "lb_suit"
	worn_state = "tan_suit"

/obj/item/clothing/under/service_overalls
	name = "workman outfit"
	desc = "The very image of a working man. Not that you're probably doing work."
	icon_state = "mechanic"
	item_state = "lb_suit"
	worn_state = "mechanic"

/obj/item/clothing/under/cheongsam
	name = "white cheongsam"
	desc = "A Chinese dress that hugs the body. This one is white, embroidered with a bright golden dragon."
	icon = 'icons/obj/clothing/cheongsams.dmi'
	icon_state = "cheongsamwhite"
	item_state = "cheongsamwhite"
	worn_state = "cheongsamwhite"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	contained_sprite = 1

/obj/item/clothing/under/cheongsam/red
	name = "red cheongsam"
	desc = "A Chinese dress that hugs the body. This one is red, with a golden leaf trim that climbs up the garment."
	icon_state = "cheongsamred"
	item_state = "cheongsamred"
	worn_state = "cheongsamred"

/obj/item/clothing/under/cheongsam/blue
	name = "blue cheongsam"
	desc = "A Chinese dress that hugs the body. This one is blue, the fabric styled with flowering tree branches."
	icon_state = "cheongsamblue"
	item_state = "cheongsamblue"
	worn_state = "cheongsamblue"

/obj/item/clothing/under/cheongsam/green
	name = "green cheongsam"
	desc = "A Chinese dress that hugs the body. This one is green, patterned with overlapping jade fans."
	icon_state = "cheongsamgreen"
	item_state = "cheongsamgreen"
	worn_state = "cheongsamgreen"

/obj/item/clothing/under/cheongsam/purple
	name = "purple cheongsam"
	desc = "A Chinese dress that hugs the body. This one is purple, embroidered with plum blossoms."
	icon_state = "cheongsampurple"
	item_state = "cheongsampurple"

//swimsuit
/obj/item/clothing/under/swimsuit
	siemens_coefficient = 1
	body_parts_covered = 0

/obj/item/clothing/under/swimsuit/black
	name = "black swimsuit"
	desc = "An oldfashioned black swimsuit."
	icon_state = "swim_black"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/blue
	name = "blue swimsuit"
	desc = "An oldfashioned blue swimsuit."
	icon_state = "swim_blue"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/purple
	name = "purple swimsuit"
	desc = "An oldfashioned purple swimsuit."
	icon_state = "swim_purp"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/green
	name = "green swimsuit"
	desc = "An oldfashioned green swimsuit."
	icon_state = "swim_green"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/red
	name = "red swimsuit"
	desc = "An oldfashioned red swimsuit."
	icon_state = "swim_red"
	siemens_coefficient = 1

/obj/item/clothing/under/zhongshan
	name = "zhongshan"
	desc = "A type of tunic suit popular in Earth's Federal Republic of China."
	icon_state = "zhongshan"
	item_state = "zhongshan"

/obj/item/clothing/under/kimono
	name = "kimono"
	desc = "A traditional Japanese kimono."
	icon_state = "kimono"
	item_state = "kimono"
	icon = 'icons/clothing/under/uniforms/kimono.dmi'
	contained_sprite = TRUE

/obj/item/clothing/under/kimono/ronin
	name = "ronin kimono"
	desc = "A non-traditional Japanese kimono, it appears to be very gothic. Like, totally gothic."
	icon_state = "ronin_kimono"
	item_state = "ronin_kimono"

/obj/item/clothing/under/kimono/fancy
	name = "fancy kimono"
	desc = "A Japanese kimono, this one is very luxurious. It brings to mind iced tea cans."
	icon_state = "fancy_kimono"
	item_state = "fancy_kimono"

/obj/item/clothing/under/medical_gown
	name = "medical gown"
	desc = "A loose pieces of clothing, commonly worn by medical patients."
	icon_state = "medicalgown"
	item_state = "medicalgown"
	has_sensor = SUIT_LOCKED_SENSORS
	sensor_mode = SUIT_SENSOR_TRACKING

/obj/item/clothing/under/medical_gown/white
	icon_state = "whitemedicalgown"
	worn_state = "whitemedicalgown"

/obj/item/clothing/under/legion
	name = "Tau Ceti Foreign Legion uniform"
	desc = "A blue field uniform worn by Tau Ceti Foreign Legion forces."
	icon = 'icons/clothing/under/uniforms/tcfl_uniform.dmi'
	icon_state = "tauceti_volunteer"
	item_state = "tauceti_volunteer"
	worn_state = "tauceti_volunteer"
	contained_sprite = TRUE
	siemens_coefficient = 0.7
	armor = list(
		MELEE = ARMOR_MELEE_MINOR)

/obj/item/clothing/under/legion/sentinel
	name = "Tau Ceti Foreign Legion sentinel uniform"
	desc = "A blue field uniform with black trimming, indicating that the wearer is a sentinel of the TCFL."
	icon_state = "tauceti_sentinel"
	item_state = "tauceti_sentinel"
	worn_state = "tauceti_sentinel"

/obj/item/clothing/under/legion/legate
	name = "Tau Ceti Foreign Legion legate uniform"
	desc = "A stark red field uniform worn by senior officers of the Tau Ceti Foreign Legion."
	icon_state = "tauceti_legate"
	item_state = "tauceti_legate"
	worn_state = "tauceti_legate"

/obj/item/clothing/under/legion/pilot
	name = "Tau Ceti Foreign Legion flightsuit"
	desc = "A green flightsuit worn by Tau Ceti Foreign Legion pilots."
	icon_state = "tauceti_pilot"
	item_state = "tauceti_pilot"
	worn_state = "tauceti_pilot"

/obj/item/clothing/under/offworlder
	name = "\improper CR suit"
	desc = "A very tight form-fitting padded suit that looks extremely comfortable to wear."
	icon = 'icons/obj/item/clothing/accessory/offworlder.dmi'
	contained_sprite = TRUE
	icon_state = "crsuit"
	item_state = "crsuit"
	worn_state = "crsuit"

/obj/item/clothing/under/tactical
	name = "tactical jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "swatunder"
	//item_state = "swatunder"
	worn_state = "swatunder"
	armor = list(
		MELEE = ARMOR_MELEE_MINOR
		)
	siemens_coefficient = 0.7

/obj/item/clothing/under/lance
	name = "ceres lance fatigues"
	desc = "A set of drab fatigues meant to be worn by the Ceres' Lance Regiment, with their emblem found on the shoulder."
	icon_state = "lance_fatigues"
	item_state = "lance_fatigues"
	worn_state = "lance_fatigues"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(
		MELEE = ARMOR_MELEE_MINOR
		)
	siemens_coefficient = 0.7

/obj/item/clothing/under/dress/lance_dress
	name = "lance dress uniform"
	desc = "A dark black uniform indicative of a Ceres' Lance official with a badge atop the chest. This one seems tailored  to take on a more feminine look, with a long skirt."
	icon_state = "lance_dress_f"
	item_state = "lance_dress_f"
	worn_state = "lance_dress_f"

/obj/item/clothing/under/dress/lance_dress/male
	name = "lance dress uniform"
	desc = "A dark black uniform indicative of a Ceres' Lance official with a badge atop the chest."
	icon_state = "lance_dress_m"
	item_state = "lance_dress_m"
	worn_state = "lance_dress_m"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/under/qipao
	name = "qipao"
	desc = "A traditional Solarian women's garment, typically made of (synthetic) silk."
	icon_state = "qipao"
	item_state = "qipao"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/qipao2
	name = "slim qipao"
	desc = "A traditional Solarian women's garment, typically made of (synthetic) silk. This one is fairly slim."
	icon_state = "qipao2"
	item_state = "qipao2"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/rank/elyran_fatigues
	name = "elyran navy uniform"
	desc = "An utility uniform worn by Elyran navy staff serving aboard ships and in the field."
	icon_state = "elyran_fatigues"
	item_state = "elyran_fatigues"
	armor = list(
		MELEE = ARMOR_MELEE_SMALL,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MINOR
		)

/obj/item/clothing/under/rank/elyran_fatigues/commander
	name = "elyran navy officer uniform"
	desc = "An utility uniform worn by Elyran navy officers serving aboard ships and in the field."
	icon_state = "elyran_commander"
	item_state = "elyran_commander"

/obj/item/clothing/under/rank/konyang
	name = "konyang army uniform"
	desc = "A set of dark green fatigues issued to the soldiers of the Konyang Army. Its design is similar to the uniforms of the Solarian Army."
	icon = 'icons/clothing/under/uniforms/konyang_uniforms.dmi'
	icon_state = "konyang_army"
	item_state = "konyang_army"
	contained_sprite = TRUE
	armor = list(
		MELEE = ARMOR_MELEE_SMALL,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MINOR
		)

/obj/item/clothing/under/rank/konyang/officer
	name = "konyang army officer's uniform"
	desc = "A green service uniform worn by the officers of the Konyang Army. Its design is similar to the uniforms of the Solarian Army"
	icon_state = "konyang_army_officer"
	item_state = "konyang_army_officer"

/obj/item/clothing/under/rank/konyang/navy
	name = "konyang navy uniform"
	desc = "A blue utility uniform worn by the enlisted personnel of the Konyang Navy - often derided as more of a coast guard than a true armed force."
	icon_state = "konyang_navy"
	item_state = "konyang_navy"

/obj/item/clothing/under/rank/konyang/navy/officer
	name = "konyang navy officer's uniform"
	desc = "A white service uniform worn by the officers of the Konyang Navy - often derided as more of a coast guard than a true armed force."
	icon_state = "konyang_navy_officer"
	item_state = "konyang_navy_officer"

/obj/item/clothing/under/rank/konyang/space
	name = "konyang aerospace force uniform"
	desc = "A set of black coveralls worn by the soldiers of the Konyang Aerospace Forces, whether on-ship or in the field."
	icon_state = "konyang_space"
	item_state = "konyang_space"

/obj/item/clothing/under/rank/konyang/space/officer
	name = "konyang aerospace force officer's uniform"
	desc = "A military service uniform issued to officers of the Konyang Aerospace Forces."
	icon_state = "konyang_space_officer"
	item_state = "konyang_space_officer"

/obj/item/clothing/under/rank/konyang/mech_pilot
	name = "konyang mechatronic corps jumpsuit"
	desc = "A sky-blue jumpsuit worn by the exosuit pilots of the Konyang Army Mechatronic Corps - an elite exosuit unit that is often deployed abroad."
	icon_state = "mech_pilot"
	item_state = "mech_pilot"

/obj/item/clothing/under/rank/konyang/police
	name = "konyang national police uniform"
	desc = "A white shirt and blue tie, bearing the insignia of the Konyang National Police on the shoulders."
	icon_state = "police"
	item_state = "police"

/obj/item/clothing/under/rank/konyang/police/lieutenant
	name = "konyang national police lieutenant's uniform"
	desc = "A white shirt and blue tie, bearing the insignia of the Konyang National Police on the shoulders. This one is emblazoned with red, marking the wearer as a lieutenant."
	icon_state = "konyang_police_lieutenant"
	item_state = "konyang_police_lieutenant"

/obj/item/clothing/under/konyang/pirate
	name = "ragged konyanger clothing"
	desc = "A grey shirt and dark shorts in a Konyang style, accentuated with a red scarf. The clothes are dirty, torn, and ragged - evidently not well-maintained by their owner."
	icon = 'icons/clothing/under/uniforms/konyang_pirates.dmi'
	icon_state = "pirate"
	item_state = "pirate"
	armor = null

/obj/item/clothing/under/konyang/pirate/tanktop
	name = "disheveled konyanger clothing"
	desc = "A dark yellow outfit in a Konyang style, with the sleeves cut off. It is stained with dirt, grease and a splatter of what looks like blood."
	icon_state = "pirate1"
	item_state = "pirate1"
	armor = null

/obj/item/clothing/under/rank/konyang/krc
	name = "konyang robotics company uniform"
	desc = "A blue button-up shirt and brown trousers, with a red and white-striped tie. On the shirt, the logo of the Konyang Robotics Company is clearly displayed."
	icon_state = "krc"
	item_state = "krc"
	armor = null

/obj/item/clothing/under/rank/konyang/pachrom
	name = "PACHROM uniform"
	desc = "A well-worn and practical dark yellow jumpsuit, with the logo of PACHROM - a prominent Konyang corporation - emblazoned on the left arm."
	icon_state = "pachrom"
	item_state = "pachrom"
	armor = null

/obj/item/clothing/under/rank/konyang/burger
	name = "\improper UP! Burger uniform"
	desc = "An astoundingly bright orange uniform, worn by employees of UP! Burger (or Burger UP!, depending on preference), a Gwok Group subsidiary."
	icon_state = "upburger"
	item_state = "upburger"
	contained_sprite = TRUE
	has_sensor = SUIT_NO_SENSORS

//Galatea
/obj/item/clothing/under/galatea
	name = "\improper Galatean uniform"
	desc = "A pair of slacks and matching protected shirt in the traditional black and green colors of a Galatean worker, seeing use across their space for all matter of jobs. Has a small plate to protect against chemical spills and small stab wounds, though providing little actual protection. Traditionally, one's planet of origin is marked on the right side of its high collar while the Technocracy's flag is on the left side of the collar."
	icon = 'icons/clothing/under/uniforms/galatea.dmi'
	icon_state = "underglove"
	item_state = "underglove"
	contained_sprite = TRUE

//Xanu

/obj/item/clothing/under/xanu
	name = "xanu armed forces fatigues"
	desc = "Fireproof, kevlar-reinforced combat fatigues used by enlisted personnel of the All-Xanu Armed Forces."
	icon = 'icons/clothing/under/uniforms/xanu.dmi'
	icon_state = "xanu"
	item_state = "xanu"
	contained_sprite = TRUE
	siemens_coefficient = 0.5
	armor = list(
		MELEE = ARMOR_MELEE_KNIVES,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MINOR
		)

/obj/item/clothing/under/xanu/med
	name = "xanu armed forces medic fatigues"
	desc = "Fireproof, kevlar-reinforced combat fatigues used by medics of the All-Xanu Armed Forces."
	icon_state = "xanu_med"
	item_state = "xanu_med"

/obj/item/clothing/under/xanu/engi
	name = "xanu armed forces engineer fatigues"
	desc = "Fireproof, kevlar-reinforced combat fatigues used by engineers of the All-Xanu Armed Forces."
	icon_state = "xanu_engi"
	item_state = "xanu_engi"

/obj/item/clothing/under/xanu/maa
	name = "xanu armed forces master-at-arms fatigues"
	desc = "Fireproof, kevlar-reinforced combat fatigues used by masters-at-arms of the All-Xanu Armed Forces."
	icon_state = "xanu_maa"
	item_state = "xanu_maa"

/obj/item/clothing/under/xanu/pilot
	name = "xanu armed forces pilot fatigues"
	desc = "Fireproof, kevlar-reinforced combat fatigues used by pilots of the All-Xanu Armed Forces."
	icon_state = "xanu_pilot"
	item_state = "xanu_pilot"

/obj/item/clothing/under/xanu/officer
	name = "xanu armed forces officer coat"
	desc = "A shirt and tie underneath a shortcoat, used by commissioned officers of the All-Xanu Armed Forces."
	icon_state = "xanu_comm"
	item_state = "xanu_comm"

/obj/item/clothing/under/xanu/officer/senior
	name = "xanu armed forces senior officer coat"
	desc = "A shirt and tie underneath a shortcoat, used by high-ranking commissioned officers of the All-Xanu Armed Forces."
	icon_state = "xanu_cap"
	item_state = "xanu_cap"
