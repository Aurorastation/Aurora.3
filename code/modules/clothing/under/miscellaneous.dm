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
		"Vaurca Breeder" = 'icons/mob/species/breeder/suit.dmi'
		)

/obj/item/clothing/under/pj/blue
	name = "blue pyjamas"
	desc = "Slightly old-fashioned sleepwear."
	icon_state = "blue_pyjamas"
	worn_state = "blue_pyjamas"
	item_state = "w_suit"

/obj/item/clothing/under/captain_fly
	name = "rogue's uniform"
	desc = "For the man who doesn't care because he's still free."
	icon_state = "captain_fly"
	item_state = "r_suit"
	worn_state = "captain_fly"

/obj/item/clothing/under/scratch
	name = "white suit"
	desc = "A white suit, suitable for an excellent host"
	icon_state = "scratch"
	item_state = "scratch"
	worn_state = "scratch"

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

/obj/item/clothing/under/rank/mailman
	name = "mailman's jumpsuit"
	desc = "<i>'Special delivery!'</i>"
	icon_state = "mailman"
	item_state = "b_suit"
	worn_state = "mailman"

/obj/item/clothing/under/sexyclown
	name = "sexy-clown suit"
	desc = "It makes you look HONKable!"
	icon_state = "sexyclown"
	item_state = "clown"
	worn_state = "sexyclown"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/rank/vice
	name = "vice officer's jumpsuit"
	desc = "It's the standard issue pretty-boy outfit, as seen on Holo-Vision."
	icon_state = "vice"
	item_state = "gy_suit"
	worn_state = "vice"

//This set of uniforms looks fairly fancy and is generally used for high-ranking NT personnel from what I've seen, so lets give them appropriate ranks.
/obj/item/clothing/under/rank/centcom
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Captain.\""
	name = "officer's dress uniform"
	icon_state = "officer"
	item_state = "lawyer_black"
	worn_state = "officer"
	displays_id = 0

/obj/item/clothing/under/rank/centcom_officer
	name = "officer's dress uniform"
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Admiral.\""
	icon_state = "officer"
	item_state = "lawyer_black"
	worn_state = "officer"
	displays_id = 0

/obj/item/clothing/under/rank/centcom_captain
	name = "officer's dress uniform"
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Admiral-Executive.\""
	icon_state = "centcom"
	item_state = "lawyer_black"
	worn_state = "centcom"
	displays_id = 0

/obj/item/clothing/under/rank/fib
	name = "\improper FIB agent uniform"
	desc = "A formal uniform used by Federal Investigations Bureau agents."
	icon_state = "fib_uniform"
	worn_state = "fib_uniform"

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
	item_state = "lawyer_black"
	worn_state = "centcom"

/obj/item/clothing/under/space
	name = "\improper NASA jumpsuit"
	desc = "It has a NASA logo on it and is made of space-proofed materials."
	icon_state = "black"
	item_state = "bl_suit"
	worn_state = "black"
	w_class = 4//bulky item
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
	armor = list(melee = 100, bullet = 100, laser = 100,energy = 100, bomb = 100, bio = 100, rad = 100)
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/under/owl
	name = "owl uniform"
	desc = "A jumpsuit with owl wings. Photorealistic owl feathers! Twooooo!"
	icon_state = "owl"
	worn_state = "owl"
	item_state = "owl"

/obj/item/clothing/under/johnny
	name = "johnny~~ jumpsuit"
	desc = "Johnny~~"
	icon_state = "johnny"
	worn_state = "johnny"
	item_state = "johnny"

/obj/item/clothing/under/rainbow
	name = "rainbow"
	desc = "rainbow"
	icon_state = "rainbow"
	item_state = "rainbow"
	worn_state = "rainbow"

/obj/item/clothing/under/psysuit
	name = "dark undersuit"
	desc = "A thick, layered grey undersuit lined with power cables. Feels a little like wearing an electrical storm."
	icon_state = "psysuit"
	item_state = "bl_suit"
	worn_state = "psysuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/under/gentlesuit
	name = "gentlemans suit"
	desc = "A silk black shirt with a white tie and a matching gray vest and slacks. Feels proper."
	icon_state = "gentlesuit"
	item_state = "gy_suit"
	worn_state = "gentlesuit"

/obj/item/clothing/under/gimmick/rank/captain/suit
	name = "captain's suit"
	desc = "A green suit and yellow necktie. Exemplifies authority."
	icon_state = "green_suit"
	item_state = "dg_suit"
	worn_state = "green_suit"

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
	worn_state = "black_suit"

/obj/item/clothing/under/suit_jacket/female
	name = "executive suit"
	desc = "A formal trouser suit for women, intended for the station's finest."
	icon_state = "black_suit_fem"
	item_state = "lawyer_black"
	worn_state = "black_suit_fem"

/obj/item/clothing/under/suit_jacket/red
	name = "red suit"
	desc = "A red suit and blue tie. Somewhat formal."
	icon_state = "red_suit"
	item_state = "r_suit"
	worn_state = "red_suit"

/obj/item/clothing/under/overalls
	name = "laborer's overalls"
	desc = "A set of durable overalls for getting the job done."
	icon_state = "overalls"
	item_state = "lb_suit"
	worn_state = "overalls"

/obj/item/clothing/under/pirate
	name = "pirate outfit"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "sl_suit"
	worn_state = "pirate"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/soviet
	name = "soviet uniform"
	desc = "For the Motherland!"
	icon_state = "soviet"
	item_state = "gy_suit"
	worn_state = "soviet"

/obj/item/clothing/under/redcoat
	name = "redcoat uniform"
	desc = "Looks old."
	icon_state = "redcoat"
	item_state = "r_suit"
	worn_state = "redcoat"

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

/obj/item/clothing/under/dress/dress_saloon
	name = "saloon girl dress"
	desc = "A old western inspired gown for the girl who likes to drink."
	icon_state = "dress_saloon"
	item_state = "p_suit"
	worn_state = "dress_saloon"

/obj/item/clothing/under/dress/dress_evening
	name = "evening gown"
	desc = "A silky gown, leaves much to the imagination"
	icon_state = "red_evening_gown"
	item_state = "red_evening_gown"

/obj/item/clothing/under/dress/dress_cap
	name = "captain's dress uniform"
	desc = "Feminine fashion for the style concious captain."
	icon_state = "dress_cap"
	item_state = "b_suit"
	worn_state = "dress_cap"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/dress/dress_hop
	name = "head of personnel dress uniform"
	desc = "Feminine fashion for the style concious HoP."
	icon_state = "dress_hop"
	item_state = "b_suit"
	worn_state = "dress_hop"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/dress/dress_hr
	name = "human resources director uniform"
	desc = "Superior class for the nosy H.R. Director."
	icon_state = "huresource"
	item_state = "y_suit"
	worn_state = "huresource"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

//wedding stuff
/obj/item/clothing/under/wedding/
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/wedding/bride_orange
	name = "orange wedding dress"
	desc = "A big and puffy orange dress."
	icon_state = "bride_orange"
	item_state = "y_suit"
	worn_state = "bride_orange"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_purple
	name = "purple wedding dress"
	desc = "A big and puffy purple dress."
	icon_state = "bride_purple"
	item_state = "p_suit"
	worn_state = "bride_purple"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_blue
	name = "blue wedding dress"
	desc = "A big and puffy blue dress."
	icon_state = "bride_blue"
	item_state = "b_suit"
	worn_state = "bride_blue"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_red
	name = "red wedding dress"
	desc = "A big and puffy red dress."
	icon_state = "bride_red"
	item_state = "r_suit"
	worn_state = "bride_red"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_white
	name = "silky wedding dress"
	desc = "A white wedding gown made from the finest silk."
	icon_state = "bride_white"
	item_state = "nursesuit"
	worn_state = "bride_white"
	flags_inv = HIDESHOES
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/sundress
	name = "sundress"
	desc = "Makes you want to frolic in a field of daisies."
	icon_state = "sundress"
	item_state = "bl_suit"
	worn_state = "sundress"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

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

/obj/item/clothing/under/dress/westernbustle
	name = "western bustle"
	desc = "A western bustle dress from somewhere in the ancient history of Earth."
	icon_state = "westernbustle"

/obj/item/clothing/under/dress/blacktango
	name = "black tango dress"
	desc = "An earthen black tango dress."
	icon_state = "black_tango"

/obj/item/clothing/under/dress/blacktango/alt
	icon_state = "black_tango_alt"

/obj/item/clothing/under/dress/offworlder
	name = "\improper CR dress"
	desc = "A very tight form-fitting padded suit that looks extremely comfortable to wear, made of strong woven spider-silk. This variant seems to be tailored to resemble a dress, revealing much more skin."
	icon_state = "crdress"
	worn_state = "crdress"

/obj/item/clothing/under/captainformal
	name = "captain's formal uniform"
	desc = "A captain's formal-wear, for special occasions."
	icon_state = "captain_formal"
	item_state = "b_suit"
	worn_state = "captain_formal"

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

/obj/item/clothing/under/assistantformal
	name = "assistant's formal uniform"
	desc = "An assistant's formal-wear. Why an assistant needs formal-wear is still unknown."
	icon_state = "assistant_formal"
	item_state = "gy_suit"
	worn_state = "assistant_formal"

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

/obj/item/clothing/under/serviceoveralls
	name = "workman outfit"
	desc = "The very image of a working man. Not that you're probably doing work."
	icon_state = "mechanic"
	item_state = "lb_suit"
	worn_state = "mechanic"

/obj/item/clothing/under/sweater
	desc = "A warm looking sweater and a pair of dark blue slacks."
	name = "sweater"
	icon_state = "turtleneck"
	worn_state = "turtleneck"

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

/obj/item/clothing/under/blazer
	name = "blue blazer"
	desc = "A bold but yet conservative outfit, red corduroys, navy blazer and a tie."
	icon_state = "blue_blazer"
	item_state = "blue_blazer"
	worn_state = "blue_blazer"

//stripper
/obj/item/clothing/under/stripper
	body_parts_covered = 0

/obj/item/clothing/under/stripper/stripper_pink
	name = "pink swimsuit"
	desc = "A rather skimpy pink swimsuit."
	icon_state = "stripper_p"
	siemens_coefficient = 1

/obj/item/clothing/under/stripper/stripper_green
	name = "green swimsuit"
	desc = "A rather skimpy green swimsuit."
	icon_state = "stripper_g"
	siemens_coefficient = 1

/obj/item/clothing/under/stripper/mankini
	name = "mankini"
	desc = "No honest man would wear this abomination"
	icon_state = "mankini"
	siemens_coefficient = 1

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

/obj/item/clothing/under/kimono
	name = "kimono"
	desc = "A traditional Japanese kimono."
	icon_state = "kimono"
	item_state = "kimono"

/obj/item/clothing/under/kimono/ronin
	name = "ronin kimono"
	desc = "A non-traditional Japanese kimono, it appears to be very gothic. Like, totally gothic."
	icon_state = "ronin_kimono"
	item_state = "ronin_kimono"

/obj/item/clothing/under/kimono/fancy
	name = "fancy kimono"
	desc = "A Japanese kimono, this one is very luxurious. It brings to mine iced tea cans."
	icon_state = "fancy_kimono"
	item_state = "fancy_kimono"

/obj/item/clothing/under/gov
	name = "green formal uniform"
	desc = "A neat proper uniform of someone on offical business. Plain, professional attire. The collar is <i>immaculately</i> starched."
	icon_state = "greensuit"
	item_state = "greensuit"
	worn_state = "greensuit"

/obj/item/clothing/under/medical_gown
	name = "medical gown"
	desc = "A loose pieces of clothing, commonly worn by medical patients."
	icon_state = "medicalgown"
	item_state = "medicalgown"
	has_sensor = 2
	sensor_mode = 3

/obj/item/clothing/under/medical_gown/white
	icon_state = "whitemedicalgown"
	worn_state = "whitemedicalgown"

/obj/item/clothing/under/legion
	name = "Tau Ceti Foreign Legion uniform"
	desc = "A blue field uniform used by the force of the Tau Ceti Foreign Legion forces."
	icon_state = "taucetilegion"
	item_state = "bl_suit"
	worn_state = "taucetilegion"
	siemens_coefficient = 0.7

/obj/item/clothing/under/legion/sentinel
	name = "Tau Ceti Foreign Legion sentinel uniform."
	desc = "A blue uniform with purple trimming, indicating that the wearer is a sentinel of the TCFL."
	worn_state = "taucetilegion_sentinel"

/obj/item/clothing/under/legion/legate
	name = "Legate uniform"
	desc = "A stark red uniform worn by senior officers of the Tau Ceti Foreign Legion."
	icon_state = "taucetilegion_legate"
	worn_state = "taucetilegion_legate"

/obj/item/clothing/under/legion/pilot
	name = "Tau Ceti Foreign Legion flightsuit"
	desc = "The uniform worn by Tau Ceti Foreign Legion pilots."
	icon_state = "taucetilegion_pilot"
	worn_state = "taucetilegion_pilot"

/obj/item/clothing/under/offworlder
	name = "\improper CR suit"
	desc = "A very tight form-fitting padded suit that looks extremely comfortable to wear."
	icon_state = "crsuit"
	worn_state = "crsuit"

/obj/item/clothing/under/tactical
	name = "tactical jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "swatunder"
	//item_state = "swatunder"
	worn_state = "swatunder"
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/rank/dispatch
	name = "dispatcher's uniform"
	desc = "A dress shirt and khakis with a security patch sewn on."
	icon_state = "dispatch"
	worn_state = "dispatch"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	siemens_coefficient = 0.7

/obj/item/clothing/under/lance
	name = "ceres lance fatigues"
	desc = "A set of drab fatigues meant to be worn by the Ceres' Lance Regiment, with their emblem found on the shoulder."
	icon_state = "lance_fatigues"
	item_state = "lance_fatigues"
	worn_state = "lance_fatigues"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
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


/obj/item/clothing/under/dress/bluedress
	name = "blue dress"
	desc = "A plain blue dress with a white belt."
	icon_state = "bluedress"
	item_state = "bluedress_s"
	worn_state = "bluedress"


/obj/item/clothing/under/dress/darkreddress
	name = "dark red dress"
	desc = "A short, red dress with a black belt. Fancy."
	icon_state = "darkreddress"
	item_state = "darkreddress_s"
	worn_state = "darkreddress"


/obj/item/clothing/under/cropdress
	name = "crop dress"
	desc = "A red skirt and longsleeved button-up crop top."
	icon_state = "cropdress"
	item_state = "cropdress_s"
	worn_state = "cropdress"


/obj/item/clothing/under/formalblouse
	name = "formal blouse"
	desc = "A formal, office-style blouse, with a black skirt in addition."
	icon_state = "formalblouse"
	item_state = "formalblouse_s"
	worn_state = "formalblouse"


/obj/item/clothing/under/croptop
	name = "crop top"
	desc = "Light shirt which shows the midsection of the wearer."
	icon_state = "croptop"
	item_state = "croptop_s"
	worn_state = "croptop"
