/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	Notice for novices: Don't use identical variables *twice*, the most recent one written
	in an indented string will overwrite all the other ones preceding it.

*/

/datum/sprite_accessory

	var/icon			// the icon file the accessory is located in
	var/icon_state		// the icon_state of the accessory
	var/preview_state	// a custom preview state for whatever reason

	var/name			// the preview name of the accessory

	// Determines if the accessory will be skipped or included in random hair generations
	var/gender = NEUTER

	// Restrict some styles to specific species. This requires the type path of the datum of the species in question, as well as all children of that datum if applicable.
	var/list/species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie)

	// Whether or not the accessory can be affected by colouration
	var/do_colouration = 1

	// The blend mode to use when blending this icon with its color. May not apply to all sprite_accessory types, and must be a ICON_* blend mode, not BLEND_*!
	var/icon_blend_mode = ICON_ADD

	//This is to provide safe names to use for hair/sprite to text. See Skrell tentacles for example
	var/chatname = null


/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////

Before you add any new hairstyles, make sure to define them in dna.dm in defines.
Follow by example and make good judgement based on length which list to include it in - Drago

0- No hair
1- Medium/semi short hair
2- Average Hair
3- Longish Hair
4- Very long hair
5- Unathi Horns
6- Skrell Tentacles


*/

/datum/sprite_accessory/hair
	icon = 'icons/mob/human_face/hair.dmi'	  // default icon for all hairs
	var/length = 1

	bald
		name = "Bald"   // try to capitalize the names please~
		icon_state = "bald" // you do not need to define _s or _l sub-states, game automatically does this for you
		species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie,/datum/species/unathi,/datum/species/zombie/unathi,/datum/species/diona, /datum/species/diona/coeu)
		length = 0
		chatname = "bald head" //aim to keep these lowercase so they fit into the hair tugging message

	eighties
		name = "80's"
		icon_state = "hair_80s"
		length = 3
		chatname = "long hair"

	eighties_ponytail
		name = "80's Ponytail"
		icon_state = "hair_80s_ponytail"
		length = 2
		chatname = "ponytail"

	eighties_ponytail_alt
		name = "80's Ponytail Alt"
		icon_state = "hair_80s_ponytail_alt"
		length = 2
		chatname = "ponytail"

	afro
		name = "Afro"
		icon_state = "hair_afro"
		length = 4
		chatname = "afro"

	afro2
		name = "Afro 2"
		icon_state = "hair_afro2"
		length = 4
		chatname = "afro"

	afro3
		name = "Afro, Big"
		icon_state = "hair_afrobig"
		length = 4
		chatname = "big afro"

	amanita
		name = "Amanita"
		icon_state = "hair_amanita"
		chatname = "short curls"

	amanita_long
		name = "Amanita, Long"
		icon_state = "hair_amanita_long"
		length = 3
		chatname = "long curls"

	amanita_long_alt
		name = "Amanita, Long Alt"
		icon_state = "hair_amanita_long_alt"
		length = 3
		chatname = "long curls"

	amazon
		name = "Amazon"
		icon_state = "hair_amazon"
		length = 2
		chatname = "long hair"

	averagejoe
		name = "Average Joe"
		icon_state = "hair_averagejoe"
		chatname = "short hair"

	baldingfade
		name = "Balding Fade"
		icon_state = "hair_baldingfade"
		length = 0
		chatname = "bald head"

	baldinghair
		name = "Balding Hair"
		icon_state = "hair_baldinghair" //hair_e
		length = 0
		chatname = "balding hair"

	bangs
		name = "Bangs"
		icon_state = "hair_bangs"
		length = 2
		chatname = "fringe"

	bangs_short
		name = "Bangs, Short"
		icon_state = "hair_bangs_short"
		chatname = "fringe"

	bangs_veryshort
		name = "Bangs, Very Short"
		icon_state = "hair_bangs_veryshort"
		chatname = "fringe"

	bedhead
		name = "Bedhead"
		icon_state = "hair_bedhead"
		chatname = "messy locks"

	bedhead2
		name = "Bedhead 2"
		icon_state = "hair_bedhead2"
		chatname = "messy locks"

	bedhead3
		name = "Bedhead 3"
		icon_state = "hair_bedhead3"
		chatname = "wavy hair"

	bedhead4
		name = "Bedhead 4"
		icon_state = "hair_bedhead4"
		length = 4
		chatname = "messy locks"

	beehive
		name = "Beehive"
		icon_state = "hair_beehive"
		length = 2
		chatname = "beehive hairdo"

	beehive2
		name = "Beehive 2"
		icon_state = "hair_beehive2"
		length = 2
		chatname = "beehive hairdo"

	beehive3
		name = "Beehive 3"
		icon_state = "hair_beehive3"
		length = 2
		chatname = "beehive hairdo"

	belenko
		name = "Belenko"
		icon_state = "hair_belenko"
		length = 2
		chatname = "messy hair"

	belenko_tied
		name = "Belenko (Tied)"
		icon_state = "hair_belenkotied"
		length = 2
		chatname = "messy ponytail"

	bob
		name = "Bob"
		icon_state = "hair_bob"
		species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie)
		chatname = "short hair"

	bob_chin
		name = "Bob, Chin Length"
		icon_state = "hair_bob_chin"
		chatname = "short hair"

	bob_kusanagi
		name = "Bob, Kusanagi"
		icon_state = "hair_bob_kusanagi"
		chatname = "short hair"

	bob_shoulder
		name = "Bob, Shoulder Length"
		icon_state = "hair_bob_shoulder"
		chatname = "short hair"

	bobcurl
		name = "Bobcurl"
		icon_state = "hair_bobcurl"
		species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie)
		chatname = "curls"

	bobcurl2
		name = "Bobcurl 2"
		icon_state = "hair_bobcurl2"
		chatname = "curls"

	bowl
		name = "Bowl"
		icon_state = "hair_bowlcut"
		chatname = "bowl cut"

	bowlcut2
		name = "Bowl 2"
		icon_state = "hair_bowlcut2"
		chatname = "bowl cut"

	bowlcut_birdnest
		name = "Bowl, Birdnest"
		icon_state = "hair_bowlcut_birdnest"
		length = 4
		chatname = "bowl cut"

	braid_grande
		name = "Braid, Grande"
		icon_state = "hair_braid_grande"
		length = 3
		chatname = "braid"

	braid_medium
		name = "Braid, Medium"
		icon_state = "hair_braid_medium"
		length = 2
		chatname = "braid"

	braided
		name = "Braided"
		icon_state = "hair_braided"
		length = 3
		chatname = "braids"

	braided_alt
		name = "Braided, Alt"
		icon_state = "hair_braided_alt"
		length = 3
		chatname = "braids"

	braided_hipster
		name = "Braided, Hipster"
		icon_state = "hair_braided_hipster"
		length = 3
		chatname = "braids"

	bun
		name = "Bun"
		icon_state = "hair_bun"
		length = 2
		chatname = "hair bun"

	bun_casual
		name = "Bun, Casual"
		icon_state = "hair_bun_casual"
		length = 2
		chatname = "hair bun"

	bun_donut
		name = "Bun, Donut"
		icon_state = "hair_bun_donut"
		length = 2
		chatname = "hair bun"

	bun_double
		name = "Bun, Double"
		icon_state = "hair_bun_double"
		length = 3
		chatname = "hair buns"

	bun_low
		name = "Bun, Low"
		icon_state = "hair_bun_low"
		length = 2
		chatname = "hair bun"

	bun_manbun
		name = "Bun, Manbun"
		icon_state = "hair_bun_manbun"
		length = 2
		chatname = "manbun"

	bun_odango
		name = "Bun, Odango"
		icon_state = "hair_bun_odango"
		length = 2
		chatname = "hair buns"

	bun_odango2
		name = "Bun, Odango 2"
		icon_state = "hair_bun_odango2"
		length = 2
		chatname = "hair buns"

	bun_odango3
		name = "Bun, Odango 3"
		icon_state = "hair_bun_odango3"
		length = 3
		chatname = "hair buns"

	bun_overeye
		name = "Bun, Overeye"
		icon_state = "hair_bun_overeye"
		length = 2
		chatname = "hair bun"

	bun_short
		name = "Bun, Short"
		icon_state = "hair_bun_short"
		length = 2
		chatname = "hair bun"

	bun_short2
		name = "Bun, Short 2"
		icon_state = "hair_bun_short2"
		length = 2
		chatname = "hair bun"

	bun_tight
		name = "Bun, Tight"
		icon_state = "hair_bun_tight"
		length = 2
		chatname = "hair bun"

	bun_topknot
		name = "Bun, Topknot"
		icon_state = "hair_bun_topknot"
		length = 2
		chatname = "hair bun"

	buzzcut
		name = "Buzzcut"
		icon_state = "hair_buzzcut"
		species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie)
		chatname = "unbuzzed hair"	//grabbing the grabbable hair

	buzzcut2
		name = "Buzzcut 2"
		icon_state = "hair_buzzcut2"
		species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie)
		chatname = "unbuzzed hair"

	chrono
		name = "Chrono"
		icon_state = "hair_chrono"
		length = 4
		chatname = "spiked hair"

	cia
		name = "CIA"
		icon_state = "hair_cia"
		chatname = "short hair"

	coffeehouse
		name = "Coffee House Cut"
		icon_state = "hair_coffeehouse"
		chatname = "coffee house haircut"

	coffeehouse_shave
		name = "Coffee House Shave"
		icon_state = "hair_coffeehouse_shave"
		chatname = "coffee house haircut"

	combover
		name = "Combover"
		icon_state = "hair_combover"
		chatname = "groomed hair"

	country
		name = "Country"
		icon_state = "hair_country"
		chatname = "ponytail"

	crew
		name = "Crewcut"
		icon_state = "hair_crewcut"
		chatname = "short hair"

	curls
		name = "Curls"
		icon_state = "hair_curls"
		chatname = "curls"

	cut
		name = "Cut Hair"
		icon_state = "hair_cuthair" //hair_c
		chatname = "short hair"

	devillock
		name = "Devil Lock"
		icon_state = "hair_devilock"
		chatname = "devil locks"

	dreadlocks
		name = "Dreadlocks"
		icon_state = "hair_dreads"
		length = 4
		chatname = "dreadlocks"

	drills_drillruru
		name = "Drills, Drillruru"
		icon_state = "hair_drills_drillruru"
		length = 2
		chatname = "hair drills"

	drills_drillruru_long
		name = "Drills, Drillruru Long"
		icon_state = "hair_drills_drillruru_long"
		length = 3
		chatname = "hair drills"

	emo
		name = "Emo"
		icon_state = "hair_emo"
		chatname = "fringe"

	emo_alt
		name = "Emo, Alt"
		icon_state = "hair_emo_alt"
		chatname = "fringe"

	emo_long
		name = "Emo, Long"
		icon_state = "hair_emo_long"
		chatname = "long fringe"
		length = 2

	emofringe
		name = "Emo Fringe"
		icon_state = "hair_emofringe"
		chatname = "fringe"

	emofringe_long
		name = "Emo Fringe Long"
		icon_state = "hair_emofringe_long"
		length = 3
		chatname = "long fringe"

		emofringe_longbun
		name = "Emo Fringe Long Bun"
		icon_state = "hair_emofringe_longbun"
		length = 3
		chatname = "hair bun"

	emorightfringe_long
		name = "Emo Right Fringe Long"
		icon_state = "hair_emofringe_long"
		length = 3
		chatname = "long fringe"

	emofringe_long_alt
		name = "Emo Fringe Long Alt"
		icon_state = "hair_emofringe_longalt"
		length = 3
		chatname = "long fringe"

	emorightfringe_long_alt
		name = "Emo Right Fringe Long Alt"
		icon_state = "hair_emorightfringe_longalt"
		length = 3
		chatname = "long fringe"

	fade_clean
		name = "Fade, Clean"
		icon_state = "hair_fade_clean"
		chatname = "short hair"

	fade_cleanlow
		name = "Fade, Clean Low"
		icon_state = "hair_fade_cleanlow"
		chatname = "short hair"

	fade_high
		name = "Fade, High"
		icon_state = "hair_fade_high"
		chatname = "unshaved hair"

	fade_low
		name = "Fade, Low"
		icon_state = "hair_fade_low"
		chatname = "short hair"

	fade_manbun
		name = "Fade, Manbun"
		icon_state = "hair_fade_manbun"
		chatname = "short hair"

	fade_medium
		name = "Fade, Medium"
		icon_state = "hair_fade_medium"
		chatname = "unshaved hair"

	fade_none
		name = "Fade, None"
		icon_state = "hair_fade_none"
		chatname = "short hair"

	father
		name = "Father"
		icon_state = "hair_father"
		chatname = "short hair"

	feather
		name = "Feather"
		icon_state = "hair_feather"
		length = 2
		chatname = "short hair"

	flat_top
		name = "Flat Top"
		icon_state = "hair_flattop"
		chatname = "flat top hair"

	flair
		name = "Flaired Hair"
		icon_state = "hair_flair"
		length = 2
		chatname = "flaired hair"

	flow
		name = "Flow Hair"
		icon_state = "hair_flow" //hair_f
		chatname = "short hair"

	gelled
		name = "Gelled Back"
		icon_state = "hair_gelled"
		length = 2
		chatname = "gelled-back hair"

	gentle
		name = "Gentle"
		icon_state = "hair_gentle"
		length = 3
		chatname = "long hair"

	gentlealt
		name = "Gentle Alt"
		icon_state = "hair_gentlealt"
		length = 3
		chatname = "long hair"

	gentle2
		name = "Gentle 2"
		icon_state = "hair_gentle2"
		length = 2
		chatname = "long hair"

	gentle2_alt
		name = "Gentle 2, Alt"
		icon_state = "hair_gentle2_alt"
		length = 2
		chatname = "long hair"

	gentle2_long
		name = "Gentle 2, Long"
		icon_state = "hair_gentle2_long"
		length = 3
		chatname = "long hair"

	gentle2_longalt
		name = "Gentle 2, Long Alt"
		icon_state = "hair_gentle2_longalt"
		length = 3
		chatname = "long hair"

	glossy
		name = "Glossy"
		icon_state = "hair_glossy"
		length = 2
		chatname = "short hair"

	halfbang
		name = "Half-banged Hair"
		icon_state = "hair_halfbang"
		chatname = "short hair"

	halfbangalt
		name = "Half-banged Hair, Alt"
		icon_state = "hair_halfbang_alt"
		chatname = "short hair"

	himecut
		name = "Hime Cut"
		icon_state = "hair_himecut"
		length = 3
		chatname = "long hair"

	himecut_alt
		name = "Hime Cut, Alt"
		icon_state = "hair_himecut_alt"
		length = 3
		chatname = "long hair"

	himecut_alt2
		name = "Hime Cut, Alt 2"
		icon_state = "hair_himecut_alt2"
		length = 3
		chatname = "long hair"

	himecut_long
		name = "Hime Cut, Long"
		icon_state = "hair_himecut_long"
		length = 3
		chatname = "long hair"

	himecut_long_ponytail
		name = "Hime Cut, Long Ponytail"
		icon_state = "hair_himecut_long_ponytail"
		length = 3
		chatname = "long hair"

	himecut_ponytail
		name = "Hime Cut, Ponytail"
		icon_state = "hair_himecut_ponytail"
		length = 3
		chatname = "long hair"

	himecut_ponytail_up
		name = "Hime Cut, Ponytail Up"
		icon_state = "hair_himecut_ponytail_up"
		length = 2
		chatname = "long hair"

	himecut_short
		name = "Hime Cut, Short"
		icon_state = "hair_himecut_short"
		chatname = "short hair"

	hitop
		name = "Hitop"
		icon_state = "hair_hitop"
		chatname = "hitop"

	jade
		name = "Jade"
		icon_state = "hair_jade"
		length = 2
		chatname = "messy hair"

	jensen
		name = "Jensen Hair"  // Removing Videogame References
		icon_state = "hair_jensen"
		chatname = "short hair"

	joestar
		name = "Joestar"
		icon_state = "hair_joestar"
		chatname = "short hair"

	longfringe
		name = "Long Fringe"
		icon_state = "hair_longfringe"
		length = 2
		chatname = "long hair"

	longfringe_longer
		name = "Long Fringe, Longer"
		icon_state = "hair_longfringe_longer"
		length = 3
		chatname = "long hair"

	long
		name = "Long Hair"
		icon_state = "hair_long"
		length = 3
		chatname = "long hair"

	long_alt
		name = "Long Hair, Alt"
		icon_state = "hair_long_alt"
		length = 2
		chatname = "long hair"

	long_shoulder
		name = "Long Hair, Shoulder-length"
		icon_state = "hair_long_shoulder" //hair_b
		length = 2
		chatname = "shoulder-length hair"

	long_verylong
		name = "Long Hair, Very Long"
		icon_state = "hair_long_verylong"
		length = 4
		chatname = "very long hair"

	marysue
		name = "Mary Sue"
		icon_state = "hair_marysue"
		length = 3
		chatname = "long hair"

	messy
		name = "Messy"
		icon_state = "hair_messy"
		length = 2
		chatname = "messy hair"

	messy2
		name = "Messy 2"
		icon_state = "hair_messy2"
		length = 2
		chatname = "messy hair"

	messy3
		name = "Messy 3"
		icon_state = "hair_messy3"
		length = 2
		chatname = "messy hair"

	modern
		name = "Modern"
		icon_state = "hair_modern"
		length = 3
		chatname = "long hair"

	mohawk
		name = "Mohawk"
		icon_state = "hair_mohawk"
		chatname = "mohawk"

	mohawk_big
		name = "Mohawk, Big"
		icon_state = "hair_mohawk_big"
		chatname = "mohawk"

	mohawk_high
		name = "Mohawk, High"
		icon_state = "hair_mohawk_high" //hair_d
		chatname = "mohawk"

	mohawk_hightight
		name = "Mohawk, High and Tight"
		icon_state = "hair_mohawk_hightight"
		chatname = "mohawk"

	mohawk_naomi
		name = "Mohawk, Naomi"
		icon_state = "hair_mohawk_naomi" //slightly longer on the side icons, in case you were wondering
		chatname = "mohawk"

	mohawk_reverse
		name = "Mohawk, Reverse"
		icon_state = "hair_mohawk_reverse"
		chatname = "short hair"

	mohawk_shaved
		name = "Mohawk, Shaved"
		icon_state = "hair_mohawk_shaved"
		chatname = "mohawk"

	mohawk_shavedlong
		name = "Mohawk, Shaved and Long"
		icon_state = "hair_mohawk_shavedlong"
		chatname = "mohawk"

	mohawk_shavedback
		name = "Mohawk, Shaved Back"
		icon_state = "hair_mohawk_shavedback"
		chatname = "mohawk"

	mohawk_shavedbacklong
		name = "Mohawk, Shaved Back and Long"
		icon_state = "hair_mohawk_shavedbacklong"
		chatname = "mohawk"

	mohawk_shavedtight
		name = "Mohawk, Shaved and Tight"
		icon_state = "hair_mohawk_shavedtight"
		chatname = "mohawk"

	mulder
		name = "Mulder"
		icon_state = "hair_mulder"
		chatname = "short hair"

	neat
		name = "Neat"
		icon_state = "hair_neat"
		chatname = "groomed hair"

	neatlong
		name = "Neat (Long)"
		icon_state = "hair_neatlong"
		length = 2
		chatname = "long hair"

	newyou
		name = "New You"
		icon_state = "hair_newyou"
		length = 3
		chatname = "ponytail"

	nia
		name = "Nia"
		icon_state = "hair_nia"
		length = 3
		chatname = "long hair"

	ombre
		name = "Ombre"
		icon_state = "hair_ombre"
		length = 2
		chatname = "short hair"

	oneshoulder
		name = "One Shoulder"
		icon_state = "hair_oneshoulder"
		length = 2
		chatname = "one shoulder hairstyle"

	overeye_long
		name = "Overeye, Long"
		icon_state = "hair_overeye_long"
		length = 3
		chatname = "long hair"

	overeye_short
		name = "Overeye, Short"
		icon_state = "hair_overeye_short"
		chatname = "long hair"
		length = 2

	overeye_verylong
		name = "Overeye, Very Long"
		icon_state = "hair_overeye_verylong"
		length = 3
		chatname = "long hair"

	overeye_veryshort
		name = "Overeye, Very Short"
		icon_state = "hair_overeye_veryshort"
		chatname = "short hair"

	overeye_veryshort_alt
		name = "Overeye, Very Short Alt"
		icon_state = "hair_overeye_veryshort_alt"
		chatname = "short hair"

	oxton
		name = "Oxton"
		icon_state = "hair_oxton"
		chatname = "short hair"

	parted
		name = "Parted"
		icon_state = "hair_parted"
		chatname = "short hair"

	parted_alt
		name = "Parted, Alt"
		icon_state = "hair_parted_alt"
		chatname = "short hair"

	parted_swept
		name = "Parted, Swept"
		icon_state = "hair_parted_swept"
		chatname = "short hair"

	pigtails_belle
		name = "Pigtails, Belle"
		icon_state = "hair_pigtails_belle"
		gender = FEMALE
		length = 2
		chatname = "pigtails"

	pigtails_kagami
		name = "Pigtails, Kagami"
		icon_state = "hair_pigtails_kagami"
		length = 2
		chatname = "pigtails"

	pigtails_low
		name = "Pigtails, Low"
		icon_state = "hair_pigtails_low"
		length = 2
		chatname = "pigtails"

	pigtails_nitori
		name = "Pigtails, Nitori"
		icon_state = "hair_pigtails_nitori"
		length = 2
		chatname = "pigtails"

	pigtails_twintail
		name = "Pigtails, Twintail"
		icon_state = "hair_pigtails_twintail"
		length = 2
		chatname = "pigtails"

	pigtails_twintail_ombre
		name = "Pigtails, Twintail Ombre"
		icon_state = "hair_pigtails_twintail_ombre"
		length = 2
		chatname = "pigtails"

	pigtails_twintail_ombre_alt
		name = "Pigtails, Twintail Ombre Alt"
		icon_state = "hair_pigtails_twintail_ombre_alt"
		length = 3
		chatname = "pigtails"

	pompadour
		name = "Pompadour"
		icon_state = "hair_pompadour"
		length = 3
		chatname = "pompadour"

	pompadour_dandy
		name = "Pompadour, Dandy"
		icon_state = "hair_pompadour_dandy"
		length = 3
		chatname = "pompadour"

	ponytail1
		name = "Ponytail 1"
		icon_state = "hair_ponytail1"
		length = 2
		chatname = "ponytail"

	ponytail2
		name = "Ponytail 2"
		icon_state = "hair_ponytail2" //hair_pa
		length = 2
		chatname = "ponytail"

	ponytail3
		name = "Ponytail 3"
		icon_state = "hair_ponytail3"
		length = 2
		chatname = "ponytail"

	ponytail4
		name = "Ponytail 4"
		icon_state = "hair_ponytail4"
		length = 2
		chatname = "ponytail"

	ponytail5
		name = "Ponytail 5"
		icon_state = "hair_ponytail5"
		length = 2
		chatname = "ponytail"

	ponytail6
		name = "Ponytail 6"
		icon_state = "hair_ponytail6"
		length = 2
		chatname = "ponytail"

	ponytail7
		name = "Ponytail 7"
		icon_state = "hair_ponytail7"
		length = 2
		chatname = "ponytail"

	ponytail8
		name = "Ponytail 8"
		icon_state = "hair_ponytail8"
		length = 2
		chatname = "ponytail"

	ponytail9
		name = "Ponytail 9"
		icon_state = "hair_ponytail9"
		length = 2
		chatname = "ponytail"

	ponytail_short
		name = "Ponytail, Short"
		icon_state = "hair_ponytail_short"
		length = 2
		chatname = "short ponytail"

	ponytail_short2
		name = "Ponytail, Short 2"
		icon_state = "hair_ponytail_short2"
		length = 2
		chatname = "short ponytail"

	ponytail_short3
		name = "Ponytail, Short 3"
		icon_state = "hair_ponytail_short3"
		length = 2
		chatname = "short ponytail"

	ponytail_short4
		name = "Ponytail, Short 4"
		icon_state = "hair_ponytail_short4"
		length = 2
		chatname = "short ponytail"

	ponytail_short5
		name = "Ponytail, Short 5"
		icon_state = "hair_ponytail_short5"
		length = 2
		chatname = "short ponytail"

	ponytail_fringetail
		name = "Ponytail, Fringetail"
		icon_state = "hair_ponytail_fringetail"
		length = 2
		chatname = "ponytail"

	ponytail_high
		name = "Ponytail, High"
		icon_state = "hair_ponytail_high"
		length = 2
		chatname = "ponytail"

	ponytail_side
		name = "Ponytail, Side"
		icon_state = "hair_ponytail_side"
		length = 2
		chatname = "ponytail"

	ponytail_side2
		name = "Ponytail, Side 2"
		icon_state = "hair_ponytail_side2"
		length = 2
		chatname = "ponytail"

	ponytail_side3
		name = "Ponytail, Side 3"
		icon_state = "hair_ponytail_side3"
		length = 2
		chatname = "ponytail"

	ponytail_side4
		name = "Ponytail, Side 4"
		icon_state = "hair_ponytail_side4"
		length = 2
		chatname = "ponytail"

	ponytail_spiky
		name = "Ponytail, Spiky"
		icon_state = "hair_ponytail_spiky"
		length = 4
		chatname = "ponytail"

	ponytail_wisp
		name = "Ponytail, Wisp"
		icon_state = "hair_ponytail_wisp"
		length = 3
		chatname = "ponytail"

	ponytail_zieglertail
		name = "Ponytail, Zieglertail"
		icon_state = "hair_ponytail_ziegler"
		length = 2
		chatname = "ponytail"

	bunlarge2
		name = "Bun, Large 2"
		icon_state = "hair_bun_large2"
		length = 2
		chatname = "large bun"

	poofy
		name = "Poofy"
		icon_state = "hair_poofy"
		length = 2
		chatname = "poofy hair"

	poofy2
		name = "Poofy 2"
		icon_state = "hair_poofy2"
		length = 2
		chatname = "poofy hair"

	punk_chelsea
		name = "Punk Shave, Chelsea"
		icon_state = "hair_punk_chelsea"
		chatname = "fringe"

	punk_chelsea_bighawk
		name = "Punk Shave, Chelsea Big Hawk"
		icon_state = "hair_punk_chelsea_bighawk"
		chatname = "mohawk"

	punk_chelsea_smallhawk
		name = "Punk Shave, Chelsea Small Hawk"
		icon_state = "hair_punk_chelsea_smallhawk"
		chatname = "mohawk"

	punk_chelsea_ponytail
		name = "Punk Shave, Chelsea Ponytail"
		icon_state = "hair_punk_chelsea_ponytail"
		chatname = "ponytail"

	punk_chelseafringe
		name = "Punk Shave, Chelsea Fringe"
		icon_state = "hair_punk_chelseafringe"
		chatname = "fringe"

	punk_chelseafringealt
		name = "Punk Shave, Chelsea Fringe Alt"
		icon_state = "hair_punk_chelseafringe_alt"
		chatname = "fringe"

	punk_chelseafringe_bighawk
		name = "Punk Shave, Chelsea Big Hawk"
		icon_state = "hair_punk_chelseafringe_bighawk"
		chatname = "mohawk"

	punk_chelseafringe_smallhawk
		name = "Punk Shave, Chelsea Small Hawk"
		icon_state = "hair_punk_chelseafringe_smallhawk"
		chatname = "mohawk"

	punk_chelseafringe_ponytail
		name = "Punk Shave, Chelsea Ponytail"
		icon_state = "hair_punk_chelseafringe_ponytail"
		chatname = "ponytail"

	punk_halfshaved
		name = "Punk Shave, Half-Shaved"
		icon_state = "hair_punk_halfshaved"
		chatname = "unshaved hair"		// grabbing the parts that can be grabbed

	punk_halfshaved_alt
		name = "Punk Shave, Half-Shaved Alt"
		icon_state = "hair_punk_halfshaved_alt"
		chatname = "unshaved hair"

	punk_halfshaved_bun
		name = "Punk Shave, Half-Shaved Bun"
		icon_state = "hair_punk_halfshaved_bun"
		length = 2
		chatname = "hair bun"

	punk_halfshaved_bun_alt
		name = "Punk Shave, Half-Shaved Bun Alt"
		icon_state = "hair_punk_halfshaved_bun_alt"
		length = 2
		chatname = "hair bun"

	punk_halfshaved_emo
		name = "Punk Shave, Half-Shaved Emo"
		icon_state = "hair_punk_halfshaved_emo"
		length = 2
		chatname = "unshaved hair"

	punk_sidecut_left
		name = "Punk Shave, Sidecut Left"
		icon_state = "hair_punk_sideleft"
		length = 2
		chatname = "unshaved hair"

	punk_sidecut_right
		name = "Punk Shave, Sidecut Right"
		icon_state = "hair_punk_sideright"
		length = 2
		chatname = "unshaved hair"

	quiff
		name = "Quiff"
		icon_state = "hair_quiff"
		length = 2
		chatname = "quiff"

	ronin
		name = "Ronin"
		icon_state = "hair_ronin"
		length = 2
		chatname = "long hair"

	rosa
		name = "Rosa"
		icon_state = "hair_rosa"
		chatname = "short hair"

	rows
		name = "Rows"
		icon_state = "hair_rows"
		length = 2
		chatname = "cornrows"

	rows_braid
		name = "Rows, Braid"
		icon_state = "hair_rows_braid"
		length = 2
		chatname = "cornrows"

	rows_bun
		name = "Rows, Bun"
		icon_state = "hair_rows_bun"
		length = 2
		chatname = "cornrows"

	rows_dualtail
		name = "Rows, Dual Tail"
		icon_state = "hair_rows_dualtail"
		length = 2
		chatname = "cornrows"

	rows_long
		name = "Rows, Long"
		icon_state = "hair_rows_long"
		length = 2
		chatname = "cornrows"

	scully
		name = "Scully"
		icon_state = "hair_scully"
		chatname = "short hair"

	shaved
		name = "Shaved"
		icon_state = "hair_shaved"
		length = 0
		chatname = "shaved head"

	short
		name = "Short Hair"
		icon_state = "hair_shorthair" //hair_a
		chatname = "short hair"

	short2
		name = "Short Hair 2"
		icon_state = "hair_shorthair2"
		chatname = "short hair"

	short3
		name = "Short Hair 3"
		icon_state = "hair_shorthair3"
		chatname = "short hair"

	short4
		name = "Short Hair 4"
		icon_state = "hair_shorthair4"
		chatname = "short hair"

	sideswept
		name = "Sideswept Hair"
		icon_state = "hair_sideswept"
		chatname = "short hair"

	skinhead
		name = "Skinhead"
		icon_state = "hair_skinhead"
		chatname = "matted shaved hair"

	sleeze
		name = "Sleeze"
		icon_state = "hair_sleeze"
		chatname = "short hair"

	slick
		name = "Slick"
		icon_state = "hair_slick"
		chatname = "slicked hair"

	spiky
		name = "Spiky"
		icon_state = "hair_spiky"
		species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie)
		chatname = "mighty spikes"

	straightlong
		name = "Straight Long"
		icon_state = "hair_straightlong"
		length = 3
		chatname = "long hair"

	thinning
		name = "Thinning"
		icon_state = "hair_thinning"
		chatname = "short hair"

	thinningback
		name = "Thinning Back"
		icon_state = "hair_thinningback"
		chatname = "short hair"

	thinningfront
		name = "Thinning Front"
		icon_state = "hair_thinningfront"
		chatname = "short hair"

	tresshoulder
		name = "Tress Shoulder"
		icon_state = "hair_tressshoulder"
		length = 2
		chatname = "curls"

	tresshoulderdouble
		name = "Tress Shoulder Double"
		icon_state = "hair_tressshoulder_double"
		length = 2
		chatname = "curls"

	trimmed
		name = "Trimmed"
		icon_state = "hair_trimmed"
		chatname = "trimmed hair"

	trimmedflat
		name = "Trimmed Flat Top"
		icon_state = "hair_trimmedflat"
		chatname = "trimmed hair"

	twincurls
		name = "Twincurls"
		icon_state = "hair_twincurls"
		length = 2
		chatname = "curls"

	twincurls2
		name = "Twincurls 2"
		icon_state = "hair_twincurls2"
		length = 2
		chatname = "curls"

	undercut
		name = "Undercut"
		icon_state = "hair_undercut"
		chatname = "unshaved hair"

	undercut2
		name = "Undercut 2"
		icon_state = "hair_undercut2"
		chatname = "undercut"

	undercut3
		chatname = "unshaved hair"
		name = "Undercut 3"
		icon_state = "hair_undercut3"
		chatname = "unshaved hair"

	undercut4
		name = "Undercut 4"
		icon_state = "hair_undercut4"
		chatname = "unshaved hair"

	undercut5
		name = "Undercut 5"
		icon_state = "hair_undercut5"
		chatname = "unshaved hair"

	unkept
		name = "Unkept"
		icon_state = "hair_unkept"
		length = 3
		chatname = "unkept hairdo"

	updo
		name = "Updo"
		icon_state = "hair_updo"
		length = 2
		chatname = "updo"

	vegeta
		name = "Vegeta"
		icon_state = "hair_vegeta"
		length = 4
		chatname = "mighty spikes"

	volaju
		name = "Volaju"
		icon_state = "hair_volaju"
		length = 2
		chatname = "long hair"

	wheeler
		name = "Wheeler"
		icon_state = "hair_wheeler"
		chatname = "short hair"

	fingerwave
		name = "Fingerwave"
		icon_state = "hair_fingercurl"
		chatname = "fluffy hair"

	bug_eyes
		icon = 'icons/mob/human_face/dionae_hair.dmi'
		name = "Bug Eyes"
		icon_state = "bugeyes"
		species_allowed = list(/datum/species/diona, /datum/species/diona/coeu)
		gender = NEUTER
		do_colouration = FALSE

		human_eyes
			name = "Human Eyes"
			icon_state = "humaneyes"

		skrell_eyes
			name = "Skrell Eyes"
			icon_state = "skrelleyes"

		skrell_eyes_2
			name = "Skrell Eyes 2"
			icon_state = "skrelleyes2"

		small_horns
			name = "Small Horns"
			icon_state = "smallhorns"

		horny
			name = "Horny"
			icon_state = "horny"

		headtails
			name = "Head tails"
			icon_state = "headtails"

		headtails_2
			name = "Head tails 2"
			icon_state = "headtails2"

		tiny_eye
			name = "Tiny Eye"
			icon_state = "tinyeye"

		eyebrow
			name = "Eyebrow"
			icon_state = "eyebrow"

		bullhorn
			name = "Bullhorn"
			icon_state = "bullhorn"

		blinkinghelmethead
			name = "Blinking Helmethead"
			icon_state = "blinkinghelmethead"

		periscope
			name = "Periscope"
			icon_state = "periscope"

		glorp
			name = "Glorp"
			icon_state = "glorp"

		mellow_cap
			name = "Mellow Cap"
			icon_state = "mellowcap"

		red_cap
			name = "Red Cap"
			icon_state = "redcap"

		fun_guy
			name = "Fun Guy"
			icon_state = "funguy"

		spanish_moss
			name = "Spanish Moss"
			icon_state = "spanishmoss"

		shelflife
			name = "Shelflife"
			icon_state = "shelflife"
			do_colouration = TRUE

		oak
			name = "Oak"
			icon_state = "oak"

		thorns
			name = "Thorns"
			icon_state = "thorns"

		stump
			name = "Stump"
			icon_state = "stump"

	// TG-format hair - uses ICON_MULTIPLY instead of ICON_ADD
	balding
		icon = 'icons/mob/human_face/hair_multiply.dmi'
		icon_blend_mode = ICON_MULTIPLY
		name = "Balding"
		icon_state = "hair_balding"
		length = 0
		chatname = "balding hair"

		balding_boddicker
			name = "Balding, Boddicker"
			icon_state = "hair_balding_boddicker"
			length = 1
			chatname = "balding hair"

		bangs_light
			name = "Bangs, Light"
			icon_state = "hair_bangs_light"
			length = 2
			chatname = "long hair"

		bob_alt
			name = "Bob, Alt"
			icon_state = "hair_bob_alt"
			length = 1
			chatname = "short hair"

		braided_tail
			name = "Braided, Tail"
			icon_state = "hair_braided_tail"
			length = 2
			chatname = "braids"

		bun_large
			name = "Bun, Large"
			icon_state = "hair_bun_large"
			length = 2
			chatname = "hair bun"

		bun_librarian
			name = "Bun, Librarian"
			icon_state = "hair_bun_librarian"
			length = 2
			chatname = "hair bun"

		bun_quad
			name = "Bun, Quad"
			icon_state = "hair_bun_quad"
			length = 2
			chatname = "hair buns"

		bun_uniter
			name = "Bun, Uniter"
			icon_state = "hair_bun_uniter"
			length = 2
			chatname = "hair bun"

		business
			name = "Business"
			icon_state = "hair_business"
			length = 1
			chatname = "short hair"

		business2
			name = "Business 2"
			icon_state = "hair_business2"
			length = 1
			chatname = "short hair"

		business3
			name = "Business 3"
			icon_state = "hair_business3"
			length = 1
			chatname = "short hair"

		business4
			name = "Business 4"
			icon_state = "hair_business4"
			length = 1
			chatname = "short hair"

		cactus
			name = "Cactus"
			icon_state = "hair_cactus"
			length = 3
			chatname = "very long hair"

		choppy
			name = "Choppy"
			icon_state = "hair_choppy"
			length = 1
			chatname = "choppy hair"

		fade
			name = "Fade"
			icon_state = "hair_fade"
			length = 1
			chatname = "groomed hair"

		fade_grown
			name = "Fade, Grown"
			icon_state = "hair_fade_grown"
			length = 1
			chatname = "groomed hair"

		floof
			name = "Floof"
			icon_state = "hair_floof"
			length = 2
			chatname = "fluffy hair"

		floof_short
			name = "Floof, Short"
			icon_state = "hair_floof_short"
			length = 1
			chatname = "fluffy hair"

		hair_antenna
			name = "Hair Antenna"
			icon_state = "hair_hairantenna"
			length = 2
			chatname = "long hair"

		hedgehog
			name = "Hedgehog"
			icon_state = "hair_hedgehog"
			length = 1
			chatname = "short hair"

		keanu
			name = "Keanu"
			icon_state = "hair_keanu"
			length = 1
			chatname = "short hair"

		krewcut
			name = "Krewcut"
			icon_state = "hair_krewcut"
			length = 1
			chatname = "fringe"

		messy4
			name = "Messy 4"
			icon_state = "hair_messy4"
			length = 1
			chatname = "messy hair"

		nia2
			name = "Nia 2"
			icon_state = "hair_nia2"
			length = 3
			chatname = "long hair"

		nia3
			name = "Nia 3"
			icon_state = "hair_nia3"
			length = 3
			chatname = "long hair"

		parted_short
			name = "Parted, Short"
			icon_state = "hair_parted_short"
			length = 1
			chatname = "short hair"

		pigtails_simple
			name = "Pigtails, Simple"
			icon_state = "hair_pigtails_simple"
			length = 2
			chatname = "pigtails"

		pixie
			name = "Pixie"
			icon_state = "hair_pixie"
			length = 1
			chatname = "short hair"

		pompadour_iii
			name = "Pompadour, Pomp III"
			icon_state = "hair_pomp_iii"
			length = 3
			chatname = "pompadour"

		ponytail_high2
			name = "Ponytail, High 2"
			icon_state = "hair_ponytail_high2"
			length = 2
			chatname = "ponytail"

		ponytail_jenjen
			name = "Ponytail, Jenjen"
			icon_state = "hair_ponytail_jenjen"
			length = 2
			chatname = "ponytail"

		ponytail_side5
			name = "Ponytail, Side 5"
			icon_state = "hair_ponytail_side5"
			length  = 2
			chatname = "ponytail"

		ponytail_side6
			name = "Ponytail, Side 6"
			icon_state = "hair_ponytail_side6"
			length = 2
			chatname = "ponytail"

		ponytail_side7
			name = "Ponytail, Side 7"
			icon_state = "hair_ponytail_side7"
			length = 2
			chatname = "braided ponytail"

		ponytail_straight
			name = "Ponytail, Straight"
			icon_state = "hair_ponytail_straight"
			length = 2
			chatname = "ponytail"

		protagonist
			name = "Protagonist"
			icon_state = "hair_protagonist"
			length = 1
			chatname = "short hair"

		punk_sideshaved
			name = "Punk Shave, Sideshaved"
			icon_state = "hair_punk_sideshaved"
			length = 1
			chatname = "unshaved hair"		//in reference to tugging the unshaved parts

		short_spiked
			name = "Short Spiked"
			icon_state = "hair_short_spiked"
			length = 1
			chatname = "spiked hair"

		sidepart
			name = "Sidepart"
			icon_state = "hair_sidepart"
			length = 1
			chatname = "short hair"

		sidepart_long
			name = "Sidepart, Long"
			icon_state = "hair_sidepart_long"
			length = 3
			chatname = "long hair"

		swept
			name = "Swept"
			icon_state = "hair_swept"
			length = 1
			chatname = "short hair"

		swept_short
			name = "Swept, Short"
			icon_state = "hair_swept_short"
			length = 1
			chatname = "short hair"

		swept_back
			name = "Swept, Back"
			icon_state = "hair_swept_back"
			length = 1
			chatname = "short hair"

		superbowl
			name = "Bowl, Superbowl"
			icon_state = "hair_bowlcut_superbowl"
			length = 1
			chatname = "bowl cut"

		waxed
			name = "Waxed"
			icon_state = "hair_waxed"
			chatname = "bald head"

		wavyshoulder
			name = "Wavy Shoulder (Down)"
			icon_state = "hair_wavyshoulder_down"
			length = 2
			chatname = "wavy hair"

		wavyshoulder_pt
			name = "Wavy Shoulder (Ponytail)"
			icon_state = "hair_wavyshoulder_up"
			length = 2
			chatname = "ponytail"

/*
/////////////////////////////////////
/  =-----------------------------=  /
/  == Hair Gradient Definitions ==  /
/  =-----------------------------=  /
/////////////////////////////////////
*/

/datum/sprite_accessory/hair_gradients
	icon = 'icons/mob/hair_gradients.dmi'
	species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie,
		/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara,
		/datum/species/skrell, /datum/species/skrell/axiori, /datum/species/zombie/skrell, /datum/species/bug, /datum/species/bug/type_b, /datum/species/unathi, /datum/species/zombie/unathi)

	none
		name = "None"
		icon_state = "none"
		species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie,/datum/species/unathi,/datum/species/zombie/unathi,
		/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara,/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell, /datum/species/bug,
		/datum/species/bug/type_b)

	none_48
		name = "None (Vaurca Type C/E)"
		icon = "icons/mob/base_48.dmi"
		icon_state = "none"
		species_allowed = list(/datum/species/bug/type_e, /datum/species/bug/type_c)

	fade_up
		name = "Fade (Up)"
		icon_state = "fadeup"

	fade_down
		name = "Fade (Down)"
		icon_state = "fadedown"

	fade_right
		name = "Fade (Right)"
		icon_state = "faderight"

	fade_left
		name = "Fade (Left)"
		icon_state = "fadeleft"

	vertical_split_right
		name = "Vertical Split (Right)"
		icon_state = "vsplit_right"

	vertical_split_left
		name = "Vertical Split (Left)"
		icon_state = "vsplit_left"

	horizontal
		name = "Horizontal Split"
		icon_state = "hsplit"

	taj_inner_ear_fur
		name = "Inner Ear Fur"
		icon_state = "taj_innerearfur"
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan, /datum/species/zombie/tajara)

	taj_msai_inner_ear_fur
		name = "M'sai Inner Ear Fur"
		icon_state = "taj_msai_innerearfur"
		species_allowed = list(/datum/species/tajaran/m_sai)

	skrell_spots
		name = "Skrell Spots"
		icon_state = "skrell_gradient_spots"
		species_allowed = list(/datum/species/skrell, /datum/species/skrell/axiori, /datum/species/zombie/skrell)

	skrell_stripes
		name = "Skrell Headtail Blotches"
		icon_state = "skr_headtail_stripes"
		species_allowed = list(/datum/species/skrell, /datum/species/skrell/axiori, /datum/species/zombie/skrell)

	skrell_headtail_middle
		name = "Skrell Headtail Middle"
		icon_state = "skr_headtail_mid"
		species_allowed = list(/datum/species/skrell, /datum/species/skrell/axiori, /datum/species/zombie/skrell)

	skrell_headtail_hfade
		name = "Skrell Headtail Hard Fade"
		icon_state = "skr_headtail_hfade"
		species_allowed = list(/datum/species/skrell, /datum/species/skrell/axiori, /datum/species/zombie/skrell)


/*
///////////////////////////////////
/  =---------------------------=  /
/  == Facial Hair Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/facial_hair
	icon = 'icons/mob/human_face/facial_hair.dmi'
	gender = MALE // barf (unless you're a dorf, dorfs dig chix /w beards :P)

	shaved
		name = "Shaved"
		icon_state = "bald"
		gender = NEUTER
		species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie,/datum/species/unathi,/datum/species/zombie/unathi,
		/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/tajaran/tesla_body,/datum/species/zombie/tajara,/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell,/datum/species/diona,
		/datum/species/diona/coeu, /datum/species/bug/type_b)

	threeOclock
		name = "3 O'clock Shadow"
		icon_state = "facial_3oclock"

	threeOclockstache
		name = "3 O'clock Shadow and Moustache"
		icon_state = "facial_3oclockmoustache"

	fiveOclock
		name = "5 O'clock Shadow"
		icon_state = "facial_5oclock"

	fiveOclockstache
		name = "5 O'clock Shadow and Moustache"
		icon_state = "facial_5oclockmoustache"

	sevenOclock
		name = "7 O'clock Shadow"
		icon_state = "facial_7oclock"

	sevenOclockstache
		name = "7 O'clock Shadow and Moustache"
		icon_state = "facial_7oclockmoustache"

	abe
		name = "Abraham Lincoln Beard"
		icon_state = "facial_abe"

	biker
		name = "Biker Beard"
		icon_state = "facial_biker"

	britstache
		name = "Britstache"
		icon_state = "facial_britstache"

	chaplin
		name = "Square Mustache"
		icon_state = "facial_chaplin"

	chinless
		name = "Chinless Beard"
		icon_state = "facial_chinlessbeard"

	chinstrap
		name = "Chinstrap"
		icon_state = "facial_chinstrap"

	croppedbeard
		name = "Full Cropped Beard"
		icon_state = "facial_croppedfullbeard"

	dwarf
		name = "Dwarf Beard"
		icon_state = "facial_dwarf"

	elvis
		name = "Elvis Sideburns"
		icon_state = "facial_elvis"
		species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie)

	fullbeard
		name = "Full Beard"
		icon_state = "facial_fullbeard"

	gt
		name = "Goatee"
		icon_state = "facial_gt"

	gt2
		name = "Goatee 2"
		icon_state = "facial_gt2"

	gt3
		name = "Goatee 3"
		icon_state = "facial_gt3"

	hip
		name = "Hipster Beard"
		icon_state = "facial_hip"

	hogan
		name = "Hulk Hogan Mustache"
		icon_state = "facial_hogan" //-Neek

	horseshoe
		name = "Horseshoe Mustache"
		icon_state = "facial_horseshoe"

	jensen
		name = "Jensen Beard"
		icon_state = "facial_jensen"

	longbeard
		name = "Long Beard"
		icon_state = "facial_longbeard"

	lumberjack
		name = "Lumberjack"
		icon_state = "facial_lumberjack"

	martial_artist
		name = "Martial Artist"
		icon_state = "facial_martialartist"

	moonshiner
		name = "Moonshiner"
		icon_state = "facial_moonshiner"

	mutton
		name = "Mutton Chops"
		icon_state = "facial_mutton"

	muttonstache
		name = "Mutton Chops and Moustache"
		icon_state = "facial_muttonmus"

	neckbeard
		name = "Neckbeard"
		icon_state = "facial_neckbeard"

	seadog
		name = "Sea Dog"
		icon_state = "facial_seadog"

	selleck
		name = "Selleck Mustache"
		icon_state = "facial_selleck"

	sideburns
		name = "Sideburns"
		icon_state = "facial_sideburns"

	tribeard
		name = "Tribeard"
		icon_state = "facial_tribeard"

	volaju
		name = "Volaju"
		icon_state = "facial_volaju"

	walrus
		name = "Walrus Moustache"
		icon_state = "facial_walrus"

	watson
		name = "Watson Mustache"
		icon_state = "facial_watson"

	wise
		name = "Wise Beard"
		icon_state = "facial_wise"

	chinstrap2
		icon = 'icons/mob/human_face/facial_hair_multiply.dmi'
		name = "Chinstrap, Alt"
		icon_state = "facial_chinstrap_ii"
		icon_blend_mode = ICON_MULTIPLY

		stark
			name = "Stark"
			icon_state = "facial_stark"

		swire
			name = "Swire"
			icon_state = "facial_swire"

		vandyke
			name = "Van Dyke Mustache"
			icon_state = "facial_vandyke"

/*
///////////////////////////////////
/  =---------------------------=  /
/  == Alien Style Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/hair

//unathi hair


	una_aquaticfrill
		icon = 'icons/mob/human_face/unathi_hair.dmi'
		name = "Unathi Aquatic Frills"
		icon_state = "unathi_aquaticfrills"
		species_allowed = list(/datum/species/unathi,/datum/species/zombie/unathi)
		length = 0
		chatname = "frills"

		una_bighorns
			name = "Unathi Big Horns"
			icon_state = "unathi_bighorn"
			length = 5
			chatname = "horns"

			una_bighorns_noside
				name = "Unathi Big Horns (No Sides)"
				icon_state = "unathi_bighorn_nosides"

		una_chinhorn
			name = "Unathi Chin Horn"
			icon_state = "unathi_chinhorns"
			length = 0
			chatname = "horns"

		una_curlhorn
			name = "Unathi Curled Horns"
			icon_state = "unathi_curledhorn"
			length = 5
			chatname = "horns"

		una_dorsalfrill
			name = "Unathi Dorsal Frill"
			icon_state = "unathi_dorsalfrill"
			length = 0
			chatname = "frills"

		una_dracfrills
			name = "Unathi Draconic Frills"
			icon_state = "unathi_dracfrills"
			length = 0
			chatname = "frills"

		una_drachorn
			name = "Unathi Draconic Horns"
			icon_state = "unathi_drachorn"
			length = 5
			chatname = "horns"

		una_elvis
			name = "Elvis Sideburns"
			icon_state = "unathi_elvis"
			length = 0
			chatname = "sideburns"

		una_hornadorns
			name = "Unathi Horn Adorns"
			icon_state = "unathi_hornadorns"
			length = 0
			chatname = "horns"

		una_longdorsal
			name = "Unathi Long Dorsal Frill"
			icon_state = "unathi_longdorsal"
			length = 0
			chatname = "frills"

		una_longfrill
			name = "Unathi Long Frills"
			icon_state = "unathi_longfrills"
			length = 0
			chatname = "frills"

		una_longfrill2
			name = "Unathi Long Frills 2"
			icon_state = "unathi_longfrills2"
			length = 0
			chatname = "frills"

		una_longspines
			name = "Unathi Long Spines"
			icon_state = "unathi_longspines"
			length = 0
			chatname = "spines"

		una_lowerhorn
			name = "Unathi Lower Horns"
			icon_state = "unathi_lowerhorn"
			length = 5
			chatname = "horns"

		una_mohawk
			name = "Unathi Mohawk"
			icon_state = "unathi_mohawk"
			length = 5
			chatname = "mohawk"

		una_ramhornshort
			name = "Unathi Short Ram Horns"
			icon_state = "unathi_ramhorn"
			length = 5
			chatname = "horns"

		una_ramhornlong
			name = "Unathi Long Ram Horns"
			icon_state = "unathi_ramhorn2"
			length = 5
			chatname = "horns"

		una_shortfrill
			name = "Unathi Short Frills"
			icon_state = "unathi_shortfrills"
			length = 0
			chatname = "frills"

		una_shortfrill2
			name = "Unathi Short Frills 2"
			icon_state = "unathi_shortfrills2"
			length = 0
			chatname = "frills"

		una_shorthorn
			name = "Unathi Short Horns"
			icon_state = "unathi_shorthorn"
			length = 5
			chatname = "horns"

		una_shortspines
			name = "Unathi Short Spines"
			icon_state = "unathi_shortspines"
			length = 0
			chatname = "spines"

		una_sidefrills
			name = "Unathi Side Frills"
			icon_state = "unathi_sidefrills"
			length = 0
			chatname = "frills"

		una_horns
			name = "Unathi Horns"
			icon_state = "unathi_simplehorn"
			length = 5
			chatname = "horns"

		una_smallhorns
			name = "Unathi Small Horns"
			icon_state = "unathi_smallhorn"
			length = 5
			chatname = "horns"

		una_spikehorn
			name = "Unathi Spike Horns"
			icon_state = "unathi_spikehorn"
			length = 5
			chatname = "spiked horns"

		una_swepthorns
			name = "Unathi Swept-Forward Horns"
			icon_state = "unathi_swepthorn"
			length = 0
			chatname = "horns"

		una_swepthorns2
			name = "Unathi Swept-Forward Horns 2"
			icon_state = "unathi_swepthorn2"
			length = 0
			chatname = "horns"

		una_demonforward
			name = "Unathi Forward Demon Horns"
			icon_state = "unathi_demonforward"
			length = 5
			chatname = "horns"

		una_bullhorns
			name = "Unathi Bull Horns"
			icon_state = "unathi_bullhorn"
			length = 5
			chatname = "horns"

		una_longhorns
			name = "Unathi Long Bull Horns"
			icon_state = "unathi_longhorn"
			length = 5
			chatname = "horns"

		una_faun
			name = "Unathi Faun Horns"
			icon_state = "unathi_faun"
			length = 5
			chatname = "horns"

		una_double
			name = "Unathi Double Horns"
			icon_state = "unathi_dubhorns"
			length = 5
			chatname = "horns"

		una_hood
			name = "Unathi Cobra Hood"
			icon_state = "unathi_hood"
			length = 5
			chatname = "hood"

		una_skewers
			name = "Unathi Super Long Horns"
			icon_state = "unathi_skewers"
			length = 6
			chatname = "huge horns"

		una_chameleon
			name = "Unathi Chameleon Horns"
			icon_state = "unathi_chameleon"
			length = 3
			chatname = "small horns"

		una_dilocrest
			name = "Unathi Dilo Crest"
			icon_state = "dilocrest"
			length = 0
			chatname = "crests"

		una_monocrest
			name = "Unathi Mono Crest"
			icon_state = "monocrest"
			length = 0
			chatname = "crest"

		una_cryocrest
			name = "Unathi Cryo Crest"
			icon_state = "cryocrest"
			length = 0
			chatname = "crest"

		una_corycrest
			name = "Unathi Cory Crest"
			icon_state = "corycrest"
			length = 0
			chatname = "crest"

		una_albertahorns
			name = "Unathi Alberta Horns"
			icon_state = "albertahorns"
			length = 5
			chatname = "small horns"

		una_styrahorn
			name = "Unathi Styra Horn"
			icon_state = "styrahorn"
			length = 5
			chatname = "massive horn"

		una_styracrest
			name = "Unathi Styra Frill"
			icon_state = "styrafrill"
			length = 0
			chatname = "frill"

		una_pachyboss
			name = "Unathi Pachy Boss"
			icon_state = "pachylump"
			length = 0
			chatname = "lump"

		una_droopy
			name = "Unathi Droopy Dorsal Frill"
			icon_state = "unathi_droopydorsal"
			length = 0
			chatname = "droopy frill"

		una_regal
			name = "Unathi Regal Frills"
			icon_state = "unathi_regalfrills"
			length = 6
			chatname = "massive frills"

		una_hornsbusted
			name = "Unathi Horns-Busted"
			icon_state = "unathi_simplehornbusted"
			length = 5
			chatname = "horns"

		una_ramhornshortbusted
			name = "Unathi Short Ram Horns-Busted"
			icon_state = "unathi_ramhornbusted"
			length = 5
			chatname = "horns"

		una_shorthornbusted
			name = "Unathi Short Horns-Busted"
			icon_state = "unathi_shorthornbusted"
			length = 5
			chatname = "horns"

		una_drachornbusted
			name = "Unathi Draconic Horns-Busted"
			icon_state = "unathi_drachornbusted"
			length = 5
			chatname = "horns"

		una_shortfrill2busted
			name = "Unathi Short Frills 2-Busted"
			icon_state = "unathi_shortfrills2busted"
			length = 0
			chatname = "frills"

		una_styrahornbusted
			name = "Unathi Styra Horn-Busted"
			icon_state = "styrahornbusted"
			length = 2
			chatname = "horn stub"

//skrell tentacles

	skr_tentacle_m
		icon = 'icons/mob/human_face/skrell_hair.dmi'
		name = "Short Headtails"
		icon_state = "skrell_hair_m"
		species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)
		length = 2
		chatname = "short headtails"
		var/scrunchy_style = "seaweed" // seaweed fits the normal tentacles pretty well

		skr_tentacle_f
			name = "Headtails"
			icon_state = "skrell_hair_f"
			length = 4
			chatname = "headtails"

		skr_tentacle_short
			name = "Very Short Headtails"
			icon_state = "veryshort_s"
			length = 1
			chatname = "short headtails"

		skr_tentacle_long
			name = "Long Headtails"
			icon_state = "verylong_s"
			length = 6
			chatname = "long headtails"

		skr_tentacle_doubletail
			name = "Headtails, ponytail (hoop)"
			icon_state = "skrell_hoop"
			length = 5
			chatname = "headtails"
			scrunchy_style = "hoop"

		skr_tentacle_flb
			name = "Headtails, ponytail (reef)"
			icon_state = "skrell_reef"
			length = 5
			chatname = "headtails"
			scrunchy_style = "reef"

		skr_tentacle_backwater
			name = "Headtails, ponytail (backwater)"
			icon_state = "skrell_backwater"
			length = 5
			chatname = "headtails"
			scrunchy_style = "backwater"

		skr_tentacle_reserved
			name = "Expressive Headtails, reserved"
			icon_state = "skrell_reserved"
			length = 6
			chatname = "headtails"

		skr_tentacle_excited
			name = "Expressive Headtails, excited"
			icon_state = "skrell_excited"
			length = 6
			chatname = "headtails"

		skr_tentacle_insulted
			name = "Expressive Headtails, insulted"
			icon_state = "skrell_insulted"
			length = 6
			chatname = "headtails"

		skr_tentacle_tucked
			name = "Short Headtails, tucked"
			icon_state = "skrell_tucked"
			length = 2
			chatname = "short headtails"

		skr_tentacle_tuux_l
			name = "Headtails, tuux"
			icon_state = "skrell_long_tuux"
			length = 5
			chatname = "headtails"

		skr_tentacle_tuux_s
			name = "Short Headtails, tuux"
			icon_state = "skrell_short_tuux"
			length = 3
			chatname = "short headtails"

		skr_tentacle_slicked
			name = "Short Headtails, slicked"
			icon_state = "skrell_slicked"
			length = 2
			chatname = "short headtails"

		skr_tentacle_behind_r
			name = "Headtails, behind (right)"
			icon_state = "skrell_right_behind"
			length = 4
			chatname = "headtails"

		skr_tentacle_behind_l
			name = "Headtails, behind (left)"
			icon_state = "skrell_left_behind"
			length = 4
			chatname = "headtails"

		skr_tentacle_behind_b
			name = "Headtails, behind"
			icon_state = "skrell_both_behind"
			length = 4
			chatname = "headtails"

		skr_tentacle_behind_b_s
			name = "Short Headtails, behind"
			icon_state = "skrell_both_behind_short"
			length = 2
			chatname = "short headtails"

		skr_tentacle_behind_b_l
			name = "Long Headtails, behind"
			icon_state = "skrell_both_behind_long"
			length = 6
			chatname = "long headtails"

		skr_tentacle_behind_l_l
			name = "Long Headtails, behind (left)"
			icon_state = "skrell_left_behind_long"
			length = 6
			chatname = "long headtails"

		skr_tentacle_behind_r_l
			name = "Long Headtails, behind (right)"
			icon_state = "skrell_right_behind_long"
			length = 6
			chatname = "long headtails"

		skr_tentacle_reef
			name = "Short Headtails, ponytail (reef)"
			icon_state = "skrell_reef_short"
			length = 3
			chatname = "short headtails"
			scrunchy_style = "reef_short"

		skr_tentacle_emo_l_l
			name = "Long Headtails, emo (left)"
			icon_state = "skrell_left_emo_long"
			length = 6
			chatname = "long headtails"

		skr_tentacle_emo_r_l
			name = "Long Headtails, emo (right)"
			icon_state = "skrell_right_emo_long"
			length = 6
			chatname = "long headtails"

		skr_tentacle_emo_l
			name = "Headtails, emo (left)"
			icon_state = "skrell_left_emo"
			length = 4
			chatname = "headtails"

		skr_tentacle_emo_r
			name = "Headtails, emo (right)"
			icon_state = "skrell_right_emo"
			length = 4
			chatname = "headtails"


//tajaran hair

	taj_ears
		icon = 'icons/mob/human_face/tajara_hair.dmi'
		name = "Tajaran Ears"
		icon_state = "ears_plain"
		length = 1
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/zombie/tajara)

		taj_ears_bangs
			name = "Tajara Bangs"
			icon_state = "hair_bangs"
			length = 3
			chatname = "bangs"

		taj_ears_bangs_alt
			name = "Tajara Bangs Alt"
			icon_state = "hair_bangs_alt"
			length = 3
			chatname = "short bangs"

		taj_ears_shortfringe
			name = "Tajara Short Fringe"
			icon_state = "hair_shortfringe"
			length = 2
			chatname = "short fringe"

		taj_ears_bob
			name = "Tajara Bob"
			icon_state = "hair_bob"
			length = 2
			chatname = "groomed short mane"

		taj_ears_braid
			name = "Tajara Braid"
			icon_state = "hair_braid"
			length = 3
			chatname = "braid"

		taj_ears_braid_alt
			name = "Tajara Braid Alt"
			icon_state = "hair_braid_alt"
			length = 3
			chatname = "braid"

		taj_ears_clean
			name = "Tajara Clean"
			icon_state = "hair_clean"
			length = 1
			chatname = "short mane"

		taj_ears_curls
			name = "Tajara Curly"
			icon_state = "hair_curly"
			length = 3
			chatname = "curly mane"

		taj_ears_curlsalt
			name = "Tajara Curly Alt"
			icon_state = "hair_curlyalt"
			length = 3
			chatname = "curly mane"

		taj_ears_fingercurl
			name = "Tajara Finger Curls"
			icon_state = "hair_fingerwave"
			length = 2
			chatname = "curls"

		taj_ears_pompadour
			name = "Tajara Greaser"
			icon_state = "hair_greaser"
			length = 2
			chatname = "pompadour"

		taj_ears_housewife
			name = "Tajara Housewife"
			icon_state = "hair_housewife"
			length = 2
			chatname = "long mane"

		taj_ears_long
			name = "Tajara Long"
			icon_state = "hair_long"
			length = 3
			chatname = "long mane"

		taj_ears_messy
			name = "Tajara Messy"
			icon_state = "hair_messy"
			length = 1
			chatname = "messy mane"

		taj_ears_mohawk
			name = "Tajara Mohawk"
			icon_state = "hair_mohawk"
			length = 1
			chatname = "mohawk"

		taj_ears_plait
			name = "Tajara Plait"
			icon_state = "hair_plait"
			length = 1
			chatname = "braid"

		taj_ears_rattail
			name = "Tajara Rat Tail"
			icon_state = "hair_rattail"
			length = 2
			chatname = "thin ponytail"

		taj_ears_shaggy
			name = "Tajara Shaggy"
			icon_state = "hair_shaggy"
			length = 1
			chatname = "messy mane"

		taj_ears_straight
			name = "Tajara Straight"
			icon_state = "hair_straight"
			length = 3
			chatname = "short mane"

		taj_ears_spiky
			name = "Tajara Spiky"
			icon_state = "hair_spiky"
			length = 1
			chatname = "spiky mane"

		taj_ears_victory
			name = "Tajara Victory Curls"
			icon_state = "hair_victory"
			length = 3
			chatname = "curls"

		taj_ears_mane
			name = "Tajara Mane"
			icon_state = "hair_mane"
			length = 3
			gender = MALE
			chatname = "long mane"

		taj_ears_sidepony
			name = "Tajara Side Ponytail"
			icon_state = "hair_sidepony"
			length = 3
			chatname = "sideponytail"

		taj_ears_governmentman
			name = "Tajara Government Man"
			icon_state = "hair_gman"
			length = 1
			chatname = "styled mane"

		taj_ears_bun
			name = "Tajara Bun"
			icon_state = "hair_bun"
			length = 2
			chatname = "hair bun"

		taj_ears_smallbun
			name = "Tajara Bun (Small)"
			icon_state = "hair_bunsmall"
			length = 2
			chatname = "hair bun"

		taj_ears_lowbun
			name = "Tajara Bun (Low)"
			icon_state = "hair_lowbun"
			length = 2
			chatname = "hair bun"

		taj_ears_smalllowbun
			name = "Tajara Bun (Low, Small)"
			icon_state = "hair_lowbunsmall"
			length = 2
			chatname = "hair bun"

		taj_ears_bunshort
			name = "Tajara Bun (Short)"
			icon_state = "hair_bunshort"
			length = 2
			chatname = "hair bun"

		taj_ears_wedge
			name = "Tajara Wedge"
			icon_state = "hair_wedge"
			length = 2
			chatname = "styled mane"

		taj_ears_tresses
			name = "Tajara Tresses"
			icon_state = "hair_tresses"
			length = 3
			chatname = "styled mane"

		taj_ears_shoulderparted
			name = "Tajara Shoulder Parted"
			icon_state = "hair_shoulderparted"
			length = 3
			chatname = "styled mane"

		taj_ears_shoulderpartedsmall
			name = "Tajara Shoulder Parted Small"
			icon_state = "hair_shoulderpartedsmall"
			length = 3
			chatname = "styled mane"

		taj_ears_shoulderpartedlong
			name = "Tajara Shoulder Parted Long"
			icon_state = "hair_shoulderpartedlong"
			length = 3
			chatname = "styled mane"

		taj_ears_shoulderlength
			name = "Tajara Shoulderlength"
			icon_state = "hair_shoulderlength"
			length = 2
			chatname = "styled mane"

		taj_ears_shoulderlengthalt
			name = "Tajara Shoulderlength Alt"
			icon_state = "hair_shoulderlengthalt"
			length = 2
			chatname = "styled mane"

		taj_ears_sidepartedleft
			name = "Tajara Sideparted Left"
			icon_state = "hair_sidepartedleft"
			length = 3
			chatname = "styled mane"

		taj_ears_sidepartedright
			name = "Tajara Sideparted Right"
			icon_state = "hair_sidepartedright"
			length = 3
			chatname = "styled mane"

		taj_ears_fringeup
			name = "Tajara Fringe Up"
			icon_state = "hair_fringeup"
			length = 2
			chatname = "styled mane"

		taj_ears_cascading
			name = "Tajara Cascading"
			icon_state = "hair_cascading"
			length = 3
			chatname = "styled mane"

		taj_ears_cascadingalt
			name = "Tajara Cascading Alt"
			icon_state = "hair_cascadingalt"
			length = 3
			chatname = "styled mane"

		taj_ears_swoop
			name = "Tajara Swoop"
			icon_state = "hair_swoop"
			length = 2
			chatname = "styled mane"

		taj_ears_swoop_alt
			name = "Tajara Swoop Alt"
			icon_state = "hair_swoop_alt"
			length = 2
			chatname = "styled mane"

		taj_ears_swoop_bangs
			name = "Tajara Swoop Bangs"
			icon_state = "hair_swoop_bangs"
			length = 2
			chatname = "styled mane"

		taj_ears_swoop_long
			name = "Tajara Swoop Long"
			icon_state = "hair_longswoop"
			length = 3
			chatname = "styled mane"

		taj_ears_swoop_long_alt
			name = "Tajara Swoop Long Alt"
			icon_state = "hair_longswoop_alt"
			length = 3
			chatname = "styled mane"

//msai hair, longer ears
	msai_ears
		icon = 'icons/mob/human_face/msai_hair.dmi'
		name = "M'sai Ears"
		icon_state = "msai_plain"
		length = 1
		species_allowed = list(/datum/species/tajaran/m_sai)

		msai_ears_bangs
			name = "M'sai Bangs"
			icon_state = "msai_bangs"
			length = 3
			chatname = "bangs"

		msai_ears_bangs_alt
			name = "M'sai Bangs Alt"
			icon_state = "msai_bangs_alt"
			length = 3
			chatname = "smallbangs"

		msai_ears_shortfringe
			name = "M'sai Short Fringe"
			icon_state = "msai_shortfringe"
			length = 2
			chatname = "short fringe"

		msai_ears_bob
			name = "M'sai Bob"
			icon_state = "msai_bob"
			length = 2
			chatname = "groomed short mane"

		msai_ears_braid
			name = "M'sai Braid"
			icon_state = "msai_braid"
			length = 3
			chatname = "braid"

		msai_ears_braid_alt
			name = "M'sai Braid Alt"
			icon_state = "msai_braid_alt"
			length = 3
			chatname = "braid"

		msai_ears_clean
			name = "M'sai Clean"
			icon_state = "msai_clean"
			length = 1
			chatname = "short mane"

		msai_ears_curls
			name = "M'sai Curly"
			icon_state = "msai_curly"
			length = 3
			chatname = "curly mane"

		msai_ears_curls
			name = "M'sai Curly Alt"
			icon_state = "msai_curlyalt"
			length = 3
			chatname = "curly mane"

		msai_ears_fingercurl
			name = "M'sai Finger Curls"
			icon_state = "msai_fingerwave"
			length = 2
			chatname = "curls"

		msai_ears_pompadour
			name = "M'sai Greaser"
			icon_state = "msai_greaser"
			length = 2
			chatname = "pompadour"

		msai_ears_housewife
			name = "M'sai Housewife"
			icon_state = "msai_housewife"
			length = 2
			chatname = "long mane"

		msai_ears_long
			name = "M'sai Long"
			icon_state = "msai_long"
			length = 3
			chatname = "long mane"

		msai_ears_messy
			name = "M'sai Messy"
			icon_state = "msai_messy"
			length = 1
			chatname = "messy mane"

		msai_ears_mohawk
			name = "M'sai Mohawk"
			icon_state = "msai_mohawk"
			length = 1
			chatname = "mohawk"

		msai_ears_plait
			name = "M'sai Plait"
			icon_state = "msai_plait"
			length = 1
			chatname = "braid"

		msai_ears_rattail
			name = "M'sai Rat Tail"
			icon_state = "msai_rattail"
			length = 2
			chatname = "thin ponytail"

		msai_ears_shaggy
			name = "M'sai Shaggy"
			icon_state = "msai_shaggy"
			length = 1
			chatname = "messy mane"

		msai_ears_straight
			name = "M'sai Straight"
			icon_state = "msai_straight"
			length = 3
			chatname = "short mane"

		msai_ears_spiky
			name = "M'sai Spiky"
			icon_state = "msai_spiky"
			length = 1
			chatname = "spiky mane"

		msai_ears_victory
			name = "M'sai Victory Curls"
			icon_state = "msai_victory"
			length = 2
			chatname = "curls"

		msai_ears_mane
			name = "M'sai Mane"
			icon_state = "msai_mane"
			length = 3
			gender = MALE
			chatname = "long mane"

		msai_ears_sidepony
			name = "M'sai Side Ponytail"
			icon_state = "msai_sidepony"
			length = 3
			chatname = "sideponytail"

		msai_ears_governmentman
			name = "M'sai Government Man"
			icon_state = "msai_gman"
			length = 2
			chatname = "styled mane"

		msai_ears_bun
			name = "M'sai Bun"
			icon_state = "msai_bun"
			length = 2
			chatname = "hair bun"

		taj_ears_smallbun
			name = "M'sai Bun (Small)"
			icon_state = "msai_bunsmall"
			length = 2
			chatname = "hair bun"

		msai_ears_lowbun
			name = "M'sai Bun (Low)"
			icon_state = "msai_lowbun"
			length = 2
			chatname = "hair bun"

		msai_ears_lowsmallbun
			name = "M'sai Bun (Low, Small)"
			icon_state = "msai_lowbunsmall"
			length = 2
			chatname = "hair bun"

		msai_ears_bunshort
			name = "M'sai Bun (Short)"
			icon_state = "msai_bunshort"
			length = 2
			chatname = "hair bun"

		msai_ears_wedge
			name = "M'sai Wedge"
			icon_state = "msai_wedge"
			length = 2
			chatname = "styled mane"

		msai_ears_tresses
			name = "M'sai Tresses"
			icon_state = "msai_tresses"
			length = 3
			chatname = "styled mane"

		msai_ears_shoulderparted
			name = "M'sai Shoulderparted"
			icon_state = "msai_shoulderparted"
			length = 3
			chatname = "styled mane"

		msai_ears_shoulderpartedsmall
			name = "M'sai Shoulderparted Small"
			icon_state = "msai_shoulderpartedsmall"
			length = 3
			chatname = "styled mane"

		msai_ears_shoulderpartedlong
			name = "M'sai Shoulderparted Long"
			icon_state = "msai_shoulderpartedlong"
			length = 3
			chatname = "styled mane"

		msai_ears_sidepartedleft
			name = "M'sai Sideparted Left"
			icon_state = "msai_sidepartedleft"
			length = 3
			chatname = "styled mane"

		msai_ears_sidepartedright
			name = "M'sai Sideparted Right"
			icon_state = "msai_sidepartedright"
			length = 3
			chatname = "styled mane"

		msai_ears_shoulderlength
			name = "M'sai Shoulderlength"
			icon_state = "msai_shoulderlength"
			length = 2
			chatname = "styled mane"

		msai_ears_shoulderlengthalt
			name = "M'sai Shoulderlength Alt"
			icon_state = "msai_shoulderlengthalt"
			length = 2
			chatname = "styled mane"

		msai_ears_fringeup
			name = "M'sai Fringe Up"
			icon_state = "msai_fringeup"
			length = 2
			chatname = "styled mane"

		msai_ears_cascading
			name = "M'sai Cascading"
			icon_state = "msai_cascading"
			length = 3
			chatname = "styled mane"

		msai_ears_cascadingalt
			name = "M'sai Cascading Alt"
			icon_state = "msai_cascadingalt"
			length = 3
			chatname = "styled mane"

		msai_ears_swoop
			name = "M'sai Swoop"
			icon_state = "msai_swoop"
			length = 2
			chatname = "styled mane"

		msai_ears_swoop_alt
			name = "M'sai Swoop Alt"
			icon_state = "msai_swoop_alt"
			length = 2
			chatname = "styled mane"

		msai_ears_swoop_bangs
			name = "M'sai Swoop Bangs"
			icon_state = "msai_swoop_bangs"
			length = 2
			chatname = "styled mane"

		msai_ears_swoop_long
			name = "M'sai Swoop Long"
			icon_state = "msai_longswoop"
			length = 3
			chatname = "styled mane"

		msai_ears_swoop_long_alt
			name = "M'sai Swoop Long Alt"
			icon_state = "msai_longswoop_alt"
			length = 3
			chatname = "styled mane"

//tesla rejuvenation suit hair
	tesla_ears
		icon = 'icons/mob/human_face/tesla_body_hair.dmi'
		name = "Tesla Rejuvenation Suit Ears"
		icon_state = "ears_plain"
		length = 1
		species_allowed = list(/datum/species/tajaran/tesla_body)

		tesla_ears_bangs
			name = "Tesla Rejuvenation Suit Bangs"
			icon_state = "hair_bangs"
			length = 3
			chatname = "bangs"

		tesla_ears_bangs_alt
			name = "Tesla Rejuvenation Suit Bangs Alt"
			icon_state = "hair_bangs_alt"
			length = 3
			chatname = "short bangs"

		tesla_ears_shortfringe
			name = "Tesla Rejuvenation Suit Short Fringe"
			icon_state = "hair_shortfringe"
			length = 2
			chatname = "short fringe"

		tesla_ears_bob
			name = "Tesla Rejuvenation Suit Bob"
			icon_state = "hair_bob"
			length = 2
			chatname = "groomed short mane"

		tesla_ears_braid
			name = "Tesla Rejuvenation Suit Braid"
			icon_state = "hair_braid"
			length = 3
			chatname = "braid"

		tesla_ears_braid_alt
			name = "Tesla Rejuvenation Suit Braid Alt"
			icon_state = "hair_braid_alt"
			length = 3
			chatname = "braid"

		tesla_ears_clean
			name = "Tesla Rejuvenation Suit Clean"
			icon_state = "hair_clean"
			length = 1
			chatname = "short mane"

		tesla_ears_curls
			name = "Tesla Rejuvenation Suit Curly"
			icon_state = "hair_curly"
			length = 3
			chatname = "curly mane"

		tesla_ears_curlsalt
			name = "Tesla Rejuvenation Suit Curly Alt"
			icon_state = "hair_curlyalt"
			length = 3
			chatname = "curly mane"

		tesla_ears_fingercurl
			name = "Tesla Rejuvenation Suit Finger Curls"
			icon_state = "hair_fingerwave"
			length = 2
			chatname = "curls"

		tesla_ears_housewife
			name = "Tesla Rejuvenation Suit Housewife"
			icon_state = "hair_housewife"
			length = 2
			chatname = "long mane"

		tesla_ears_long
			name = "Tesla Rejuvenation Suit Long"
			icon_state = "hair_long"
			length = 3
			chatname = "long mane"

		tesla_ears_messy
			name = "Tesla Rejuvenation Suit Messy"
			icon_state = "hair_messy"
			length = 1
			chatname = "messy mane"

		tesla_ears_mohawk
			name = "Tesla Rejuvenation Suit Mohawk"
			icon_state = "hair_mohawk"
			length = 1
			chatname = "mohawk"

		tesla_ears_plait
			name = "Tesla Rejuvenation Suit Plait"
			icon_state = "hair_plait"
			length = 1
			chatname = "braid"

		tesla_ears_rattail
			name = "Tesla Rejuvenation Suit Rat Tail"
			icon_state = "hair_rattail"
			length = 2
			chatname = "thin ponytail"

		tesla_ears_shaggy
			name = "Tesla Rejuvenation Suit Shaggy"
			icon_state = "hair_shaggy"
			length = 1
			chatname = "messy mane"

		tesla_ears_straight
			name = "Tesla Rejuvenation Suit Straight"
			icon_state = "hair_straight"
			length = 3
			chatname = "short mane"

		tesla_ears_spiky
			name = "Tesla Rejuvenation Suit Spiky"
			icon_state = "hair_spiky"
			length = 1
			chatname = "spiky mane"

		tesla_ears_victory
			name = "Tesla Rejuvenation Suit Victory Curls"
			icon_state = "hair_victory"
			length = 3
			chatname = "curls"

		tesla_ears_mane
			name = "Tesla Rejuvenation Suit Mane"
			icon_state = "hair_mane"
			length = 3
			gender = MALE
			chatname = "long mane"

		tesla_ears_sidepony
			name = "Tesla Rejuvenation Suit Side Ponytail"
			icon_state = "hair_sidepony"
			length = 3
			chatname = "sideponytail"

		tesla_ears_governmentman
			name = "Tesla Rejuvenation Suit Government Man"
			icon_state = "hair_gman"
			length = 1
			chatname = "styled mane"

		tesla_ears_bun
			name = "Tesla Rejuvenation Suit Bun"
			icon_state = "hair_bun"
			length = 2
			chatname = "hair bun"

		tesla_ears_smallbun
			name = "Tesla Rejuvenation Suit Bun (Small)"
			icon_state = "hair_bunsmall"
			length = 2
			chatname = "hair bun"

		tesla_ears_lowbun
			name = "Tesla Rejuvenation Suit Bun (Low)"
			icon_state = "hair_lowbun"
			length = 2
			chatname = "hair bun"

		tesla_ears_smalllowbun
			name = "Tesla Rejuvenation Suit Bun (Low, Small)"
			icon_state = "hair_lowbunsmall"
			length = 2
			chatname = "hair bun"

		tesla_ears_bunshort
			name = "Tesla Rejuvenation Suit Bun (Short)"
			icon_state = "hair_bunshort"
			length = 2
			chatname = "hair bun"

		tesla_ears_wedge
			name = "Tesla Rejuvenation Suit Wedge"
			icon_state = "hair_wedge"
			length = 2
			chatname = "styled mane"

		tesla_ears_tresses
			name = "Tesla Rejuvenation Suit Tresses"
			icon_state = "hair_tresses"
			length = 3
			chatname = "styled mane"

		tesla_ears_shoulderparted
			name = "Tesla Rejuvenation Suit Shoulder Parted"
			icon_state = "hair_shoulderparted"
			length = 3
			chatname = "styled mane"

		tesla_ears_shoulderpartedsmall
			name = "Tesla Rejuvenation Suit Shoulder Parted Small"
			icon_state = "hair_shoulderpartedsmall"
			length = 3
			chatname = "styled mane"

		tesla_ears_shoulderpartedlong
			name = "Tesla Rejuvenation Suit Shoulder Parted Long"
			icon_state = "hair_shoulderpartedlong"
			length = 3
			chatname = "styled mane"

		tesla_ears_shoulderlength
			name = "Tesla Rejuvenation Suit Shoulderlength"
			icon_state = "hair_shoulderlength"
			length = 2
			chatname = "styled mane"

		tesla_ears_shoulderlengthalt
			name = "Tesla Rejuvenation Suit Shoulderlength Alt"
			icon_state = "hair_shoulderlengthalt"
			length = 2
			chatname = "styled mane"

		tesla_ears_sidepartedleft
			name = "Tesla Rejuvenation Suit Sideparted Left"
			icon_state = "hair_sidepartedleft"
			length = 3
			chatname = "styled mane"

		tesla_ears_sidepartedright
			name = "Tesla Rejuvenation Suit Sideparted Right"
			icon_state = "hair_sidepartedright"
			length = 3
			chatname = "styled mane"

		tesla_ears_fringeup
			name = "Tesla Rejuvenation Suit Fringe Up"
			icon_state = "hair_fringeup"
			length = 2
			chatname = "styled mane"

		tesla_ears_cascading
			name = "Tesla Rejuvenation Suit Cascading"
			icon_state = "hair_cascading"
			length = 3
			chatname = "styled mane"

		taj_ears_cascadingalt
			name = "Tesla Rejuvenation Suit Cascading Alt"
			icon_state = "hair_cascadingalt"
			length = 3
			chatname = "styled mane"

		taj_ears_swoop
			name = "Tesla Rejuvenation Suit Swoop"
			icon_state = "hair_swoop"
			length = 2
			chatname = "styled mane"

		tesla_ears_swoop_alt
			name = "Tesla Rejuvenation Suit Swoop Alt"
			icon_state = "hair_swoop_alt"
			length = 2
			chatname = "styled mane"

		tesla_ears_swoop_bangs
			name = "Tesla Rejuvenation Suit Swoop Bangs"
			icon_state = "hair_swoop_bangs"
			length = 2
			chatname = "styled mane"

		tesla_ears_swoop_long
			name = "Tesla Rejuvenation Suit Swoop Long"
			icon_state = "hair_longswoop"
			length = 3
			chatname = "styled mane"

		tesla_ears_swoop_long_alt
			name = "Tesla Rejuvenation Suit Swoop Long Alt"
			icon_state = "hair_longswoop_alt"
			length = 3
			chatname = "styled mane"

//vaurca antennae
	vaurca_classic
		icon = 'icons/mob/human_face/vaurca_hair.dmi'
		name = "Classic Antennae"
		icon_state = "vaurca_classic"
		species_allowed = list(/datum/species/bug,/datum/species/bug/type_b)
		gender = NEUTER
		chatname = "antennae"

		vaurca_braided
			name = "Braided Antennae"
			icon_state = "vaurca_braided"
			chatname = "antennae"
			length = 3

		vaurca_catfish
			name = "Catfish Antennae"
			icon_state = "vaurca_catfish"
			chatname = "antennae"
			length = 2

		vaurca_dipole
			name = "Dipole Antennae"
			icon_state = "vaurca_dipole"
			chatname = "antennae"
			length = 2

		vaurca_droop
			name = "Droopy Antennae"
			icon_state = "vaurca_droop"
			chatname = "antennae"
			length = 2

		vaurca_fla
			name = "Floor Length Antennae"
			icon_state = "vaurca_fla"
			chatname = "long antennae"
			length = 4

		vaurca_formic
			name = "Formic Antennae"
			icon_state = "vaurca_formic"
			chatname = "antennae"
			length = 2

		vaurca_damaged_left
			name = "Injured Antenna, Left"
			icon_state = "vaurca_inj_left"
			chatname = "antenna"
			length = 1

		vaurca_damaged_right
			name = "Injured Antenna, Right"
			icon_state = "vaurca_inj_right"
			chatname = "antenna"
			length = 1

		vaurca_knight
			name = "Knight Antennae"
			icon_state = "vaurca_knight"
			chatname = "antennae"
			length = 2

		vaurca_mid
			name = "Mid Length Antennae"
			icon_state = "vaurca_mid"
			chatname = "antennae"
			length = 2

		vaurca_parabolic
			name = "Parabolic Antennae"
			icon_state = "vaurca_parabolic"
			chatname = "antennae"
			length = 2

		vaurca_zappy
			name = "Zappy Antennae"
			icon_state = "vaurca_zappy"
			chatname = "antennae"
			length = 2

//Bulwark antennae
	bulwark_classic
		icon = 'icons/mob/human_face/bulwark_hair.dmi'
		name = "Bulwark Classic Antennae"
		icon_state = "bully_classic"
		species_allowed = list(/datum/species/bug/type_e)
		gender = NEUTER
		chatname = "antennae"

		bulwark_damaged_left
			name = "Bulwark Injured Antenna, Left"
			icon_state = "bully_inj_left"
			chatname = "antenna"
			length = 1

		bulwark_damaged_right
			name = "Bulwark Injured Antenna, Right"
			icon_state = "bully_inj_right"
			chatname = "antenna"
			length = 1

		bulwark_knight
			name = "Bulwark Knight Antennae"
			icon_state = "bully_knight"
			chatname = "antennae"
			length = 2

		bulwark_pointy
			name = "Pointy Antennae"
			icon_state = "bully_pointy"
			chatname = "antennae"
			length = 2

		bulwark_original
			name = "Original Antennae"
			icon_state = "bully_original"
			chatname = "antennae"
			length = 2

		bulwark_islero
			name = "Islero Antennae"
			icon_state = "bully_islero"
			chatname = "antennae"
			length = 3

		bulwark_tall
			name = "Tall Antennae"
			icon_state = "bully_tall"
			chatname = "antennae"
			length = 4

		bulwark_stag
			name = "Stag Antennae"
			icon_state = "bully_stag"
			chatname = "antennae"
			length = 5

		bulwark_rhino
			name = "Rhinoceros Antenna"
			icon_state = "bully_rhino"
			chatname = "antenna"
			length = 5

		bulwark_ladybug
			name = "Ladybug Antennae"
			icon_state = "bully_ladybug"
			chatname = "antennae"
			length = 6

//Breeder antennae
	breeder_standard
		icon = 'icons/mob/human_face/breeder_hair.dmi'
		name = "Breeder Standard Antennae"
		icon_state = "breeder_standard"
		species_allowed = list(/datum/species/bug/type_c)
		gender = NEUTER
		chatname = "antennae"
		length = 3

		breeder_quad
			name = "Breeder Quad Antennae"
			icon_state = "breeder_quad"
			length = 3

		breeder_crownedcrest
			name = "Breeder Crowned Crest"
			icon_state = "breeder_crownedcrest"
			length = 1

		breeder_hammerhead
			name = "Breeder Hammerhead"
			icon_state = "breeder_hammerhead"
			length = 1

		breeder_princess
			name = "Breeder Princess Antennae"
			icon_state = "breeder_princess"
			length = 2

/datum/sprite_accessory/facial_hair
	taj_goatee
		icon = 'icons/mob/human_face/tajara_facial_hair.dmi'
		name = "Tajara Goatee"
		icon_state = "facial_goatee"
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

		taj_goatee_faded
			name = "Tajara Goatee Faded"
			icon_state = "facial_goatee_faded"

		taj_moustache
			name = "Tajara Moustache"
			icon_state = "facial_moustache"

		taj_mutton
			name = "Tajara Mutton"
			icon_state = "facial_mutton"

		taj_pencilstache
			name = "Tajara Pencilstache"
			icon_state = "facial_pencilstache"

		taj_sideburns
			name = "Tajara Sideburns"
			icon_state = "facial_sideburns"

		taj_smallstache
			name = "Tajara Smallsatche"
			icon_state = "facial_smallstache"

/datum/sprite_accessory/facial_hair
	tesla_body_goatee
		icon = 'icons/mob/human_face/tesla_body_facial_hair.dmi'
		name = "Tesla Rejuvenation Suit Goatee"
		icon_state = "facial_goatee"
		species_allowed = list(/datum/species/tajaran/tesla_body)

		tesla_body_goatee_faded
			name = "Tesla Rejuvenation Suit Goatee Faded"
			icon_state = "facial_goatee_faded"

		tesla_body_moustache
			name = "Tesla Rejuvenation Suit Moustache"
			icon_state = "facial_moustache"

		tesla_body_mutton
			name = "Tesla Rejuvenation Suit Mutton"
			icon_state = "facial_mutton"

		tesla_body_pencilstache
			name = "Tesla Rejuvenation Suit Pencilstache"
			icon_state = "facial_pencilstache"

		tesla_body_sideburns
			name = "Tesla Rejuvenation Suit Sideburns"
			icon_state = "facial_sideburns"

		tesla_body_smallstache
			name = "Tesla Rejuvenation Suit Smallsatche"
			icon_state = "facial_smallstache"

//unathi horn beards and the like

	una_aquaticfrill
		icon = 'icons/mob/human_face/unathi_hair.dmi'
		name = "Unathi Aquatic Frills"
		icon_state = "facial_aquaticfrills"
		species_allowed = list(/datum/species/unathi,/datum/species/zombie/unathi)
		gender = NEUTER

		una_bighorns
			name = "Unathi Big Horns"
			icon_state = "facial_bighorn"

		una_bob
			name = "Bob"
			icon_state = "facial_bob"

		una_bobcurl
			name = "Bobcurl"
			icon_state = "facial_bobcurl"

		una_buzzcut
			name = "Buzzcut"
			icon_state = "facial_buzzcut"

		una_buzzcut2
			name = "Buzzcut 2"
			icon_state = "facial_buzzcut2"

		una_chinhorn
			name = "Unathi Chin Horn"
			icon_state = "facial_chinhorns"

		una_curlhorn
			name = "Unathi Curled Horns"
			icon_state = "facial_curledhorn"

		una_dorsalfrill
			name = "Unathi Dorsal Frill"
			icon_state = "facial_dorsalfrill"

		una_dracfrills
			name = "Unathi Draconic Frills"
			icon_state = "facial_dracfrills"

		una_drachorn
			name = "Unathi Draconic Horns"
			icon_state = "facial_drachorn"

		una_hornadorns
			name = "Unathi Horn Adorns"
			icon_state = "facial_hornadorns"

		una_longdorsal
			name = "Unathi Long Dorsal Frill"
			icon_state = "facial_longdorsal"

		una_longfrill
			name = "Unathi Long Frills"
			icon_state = "facial_longfrills"

		una_longfrill2
			name = "Unathi Long Frills 2"
			icon_state = "facial_longfrills2"

		una_longspines
			name = "Unathi Long Spines"
			icon_state = "facial_longspines"

		una_lowerhorn
			name = "Unathi Lower Horns"
			icon_state = "facial_lowerhorn"

		una_mohawk
			name = "Unathi Mohawk"
			icon_state = "facial_mohawk"

		una_ramhornshort
			name = "Unathi Short Ram Horns"
			icon_state = "facial_ramhorn"

		una_ramhornlong
			name = "Unathi Long Ram Horns"
			icon_state = "facial_ramhorn2"

		una_shortfrill
			name = "Unathi Short Frills"
			icon_state = "facial_shortfrills"

		una_shortfrill2
			name = "Unathi Short Frills 2"
			icon_state = "facial_shortfrills2"

		una_shorthorn
			name = "Unathi Short Horns"
			icon_state = "facial_shorthorn"

		una_shortspines
			name = "Unathi Short Spines"
			icon_state = "facial_shortspines"

		una_sidefrills
			name = "Unathi Side Frills"
			icon_state = "facial_sidefrills"

		una_spiky
			name = "Spiky"
			icon_state = "facial_spiky"

		una_horns
			name = "Unathi Horns"
			icon_state = "facial_simplehorn"

		una_smallhorns
			name = "Unathi Small Horns"
			icon_state = "facial_smallhorn"

		una_spikehorn
			name = "Unathi Spike Horns"
			icon_state = "facial_spikehorn"

		una_swepthorns
			name = "Unathi Swept-Forward Horns"
			icon_state = "facial_swepthorn"

		una_swepthorns2
			name = "Unathi Swept-Forward Horns 2"
			icon_state = "facial_swepthorn2"

		una_demonforward
			name = "Unathi Forward Demon Horns"
			icon_state = "facial_demonforward"

		una_bullhorns
			name = "Unathi Bull Horns"
			icon_state = "facial_bullhorn"

		una_longhorns
			name = "Unathi Long Bull Horns"
			icon_state = "facial_longhorn"

		una_faun
			name = "Unathi Faun Horns"
			icon_state = "facial_faun"

		una_double
			name = "Unathi Double Horns"
			icon_state = "facial_dubhorns"

		una_hood
			name = "Unathi Cobra Hood"
			icon_state = "facial_hood"

		una_skewers
			name = "Unathi Super Long Horns"
			icon_state = "facial_skewers"

		una_chameleon
			name = "Unathi Chameleon Horns"
			icon_state = "facial_chameleon"

		una_dilocrest
			name = "Unathi Dilo Crest"
			icon_state = "dilocrest"

		una_monocrest
			name = "Unathi Mono Crest"
			icon_state = "monocrest"

		una_cryocrest
			name = "Unathi Cryo Crest"
			icon_state = "cryocrest"

		una_corycrest
			name = "Unathi Cory Crest"
			icon_state = "corycrest"

		una_albertahorns
			name = "Unathi Alberta Horns"
			icon_state = "albertahorns"

		una_styrahorn
			name = "Unathi Styra Horn"
			icon_state = "styrahorn"
		una_styracrest
			name = "Unathi Styra Frill"
			icon_state = "styrafrill"

		una_pachyboss
			name = "Unathi Pachy Boss"
			icon_state = "pachylump"

		una_droopy
			name = "Unathi Droopy Dorsal Frill"
			icon_state = "unathi_droopydorsal"

		una_regal
			name = "Unathi Regal Frills"
			icon_state = "unathi_regalfrills"

		una_hornsbusted
			name = "Unathi Horns-Busted"
			icon_state = "unathi_simplehornbusted"

		una_ramhornshortbusted
			name = "Unathi Short Ram Horns-Busted"
			icon_state = "unathi_ramhornbusted"

		una_shorthornbusted
			name = "Unathi Short Horns-Busted"
			icon_state = "unathi_shorthornbusted"

		una_drachornbusted
			name = "Unathi Draconic Horns-Busted"
			icon_state = "unathi_drachornbusted"

		una_shortfrill2busted
			name = "Unathi Short Frills 2-Busted"
			icon_state = "unathi_shortfrills2busted"

		una_styrahornbusted
			name = "Unathi Styra Horn-Busted"
			icon_state = "styrahornbusted"

//ipc screens

	ipc_screen_blank
		icon = 'icons/mob/human_face/ipc_screens.dmi'
		name = "blank IPC screen"
		icon_state = "ipc_blank"
		species_allowed = list(/datum/species/machine)
		gender = NEUTER

		ipc_screen_blue
			name = "blue IPC screen"
			icon_state = "ipc_blue"

		ipc_screen_breakout
			name = "breakout IPC screen"
			icon_state = "ipc_breakout"

		ipc_screen_cancel
			name = "cancel IPC screen"
			icon_state = "ipc_cancel"

		ipc_screen_console
			name = "console IPC screen"
			icon_state = "ipc_console"

		ipc_screen_database
			name = "database IPC screen"
			icon_state = "ipc_database"

		ipc_screen_eight
			name = "eight IPC screen"
			icon_state = "ipc_eight"

		ipc_screen_eye
			name = "eye IPC screen"
			icon_state = "ipc_eye"

		ipc_screen_goggles
			name = "goggles IPC screen"
			icon_state = "ipc_goggles"

		ipc_screen_gol_glider
			name = "GoL glider IPC screen"
			icon_state = "ipc_gol_glider"

		ipc_screen_green
			name = "green IPC screen"
			icon_state = "ipc_green"

		ipc_screen_heart
			name = "heart IPC screen"
			icon_state = "ipc_heart"

		ipc_screen_heartrate
			name = "heartrate IPC screen"
			icon_state = "ipc_heartrate"

		ipc_screen_lumi_eyes
			name = "lumi eyes IPC screen"
			icon_state = "ipc_lumi_eyes"

		ipc_screen_monoeye
			name = "monoeye IPC screen"
			icon_state = "ipc_monoeye"

		ipc_scren_music
			name = "music IPC screen"
			icon_state = "ipc_music"

		ipc_screen_nature
			name = "nature IPC screen"
			icon_state = "ipc_nature"

		ipc_screen_orange
			name = "orange IPC screen"
			icon_state = "ipc_orange"

		ipc_screen_pink
			name = "pink IPC screen"
			icon_state = "ipc_pink"

		ipc_screen_purple
			name = "purple IPC screen"
			icon_state = "ipc_purple"

		ipc_screen_rainbow
			name = "rainbow IPC screen"
			icon_state = "ipc_rainbow"

		ipc_screen_red
			name = "red IPC screen"
			icon_state = "ipc_red"

		ipc_screen_rgb
			name = "RGB IPC screen"
			icon_state = "ipc_rgb"

		ipc_screen_scroll
			name = "scroll IPC screen"
			icon_state = "ipc_scroll"

		ipc_screen_shower
			name = "shower IPC screen"
			icon_state = "ipc_shower"

		ipc_screen_smiley
			name = "smiley IPC screen"
			icon_state = "ipc_smiley"

		ipc_screen_static
			name = "static IPC screen"
			icon_state = "ipc_static"

		ipc_screen_static2
			name = "static2 IPC screen"
			icon_state = "ipc_static2"

		ipc_screen_static3
			name = "static3 IPC screen"
			icon_state = "ipc_static3"

		ipc_screen_testcard
			name = "testcard IPC screen"
			icon_state = "ipc_testcard"

		ipc_screen_waiting
			name = "waiting IPC screen"
			icon_state = "ipc_waiting"

		ipc_screen_yellow
			name = "yellow IPC screen"
			icon_state = "ipc_yellow"

		ipc_screen_nanotrasen
			name = "nanotrasen IPC screen"
			icon_state = "ipc_nt"

		ipc_screen_hephaestus
			name = "hephaestus IPC screen"
			icon_state = "ipc_heph"

		ipc_screen_idris
			name = "idris IPC screen"
			icon_state = "ipc_idris"

		ipc_screen_zavodskoi
			name = "zavodskoi IPC screen"
			icon_state = "ipc_zavod"

		ipc_screen_zenghu
			name = "zeng-hu IPC screen"
			icon_state = "ipc_zenghu"

		ipc_screen_scc
			name = "scc IPC screen"
			icon_state = "ipc_scc"

		ipc_screen_biesel
			name = "republic of biesel IPC screen"
			icon_state = "ipc_biesel"

		ipc_screen_sol
			name = "sol alliance IPC screen"
			icon_state = "ipc_sol"

		ipc_screen_coalition
			name = "coalition of colonies IPC screen"
			icon_state = "ipc_coc"

		ipc_screen_elyra
			name = "republic of elyra IPC screen"
			icon_state = "ipc_elyra"

		ipc_screen_eridani
			name = "eridani IPC screen"
			icon_state = "ipc_eridani"

		ipc_screen_burzsia
			name = "burzsia IPC screen"
			icon_state = "ipc_burzsia"

		ipc_screen_tp
			name = "trinary perfection IPC screen"
			icon_state = "ipc_tp"

	diona_eye
		icon = 'icons/mob/human_face/dionae_hair.dmi'
		name = "Mono Eye"
		icon_state = "monoeye"
		species_allowed = list(/datum/species/diona, /datum/species/diona/coeu)
		gender = NEUTER
		do_colouration = FALSE

		trioptics
			name = "Trioptics"
			icon_state = "trioptics"

		lopsided
			name = "Lopsided Eyes"
			icon_state = "lopsided"

		helmethead
			name = "Helmethead"
			icon_state = "helmethead"

		eyestalk
			name = "Eyestalk"
			icon_state = "eyestalk"

		treebeard
			name = "Treebeard"
			icon_state = "treebeard"

		bug_eyes
			name = "Bug Eyes"
			icon_state = "bugeyes"

		human_eyes
			name = "Human Eyes"
			icon_state = "humaneyes"

		skrell_eyes
			name = "Skrell Eyes"
			icon_state = "skrelleyes"

		skrell_eyes_2
			name = "Skrell Eyes 2"
			icon_state = "skrelleyes2"

		tiny_eye
			name = "Tiny Eye"
			icon_state = "tinyeye"

		eyebrow
			name = "Eyebrow"
			icon_state = "eyebrow"

		blinkinghelmethead
			name = "Blinking Helmethead"
			icon_state = "blinkinghelmethead"

		periscope
			name = "Periscope"
			icon_state = "periscope"

		glorp
			name = "Glorp"
			icon_state = "glorp"

	tuux_patch
		icon = 'icons/mob/human_face/skrell_beards.dmi'
		name = "Tuux Chin Patch"
		icon_state = "Tuux_Patch"
		species_allowed = list(/datum/species/skrell, /datum/species/skrell/axiori)
		gender = NEUTER

		tuux_goatee
			name = "Tuux Goatee"
			icon_state = "Tuux_Goatee"

		tuux_tri_point
			name = "Tuux Tri-Point"
			icon_state = "Tuux_Tri-Point"

		tuux_strap
			name = "Tuux Chin Strap"
			icon_state = "Tuux_Strap"

		tuux_monotail
			name = "Tuux Monotail"
			icon_state = "Tuux_Monotail"

		tuux_monotail_long
			name = "Tuux Monotail (Long)"
			icon_state = "Tuux_Monotail_Long"

		tuux_full
			name = "Tuux Full Beard"
			icon_state = "Tuux_Full"

		tuux_chops
			name = "Tuux Chops"
			icon_state = "Tuux_Chops"

		tuux_chops_big
			name = "Tuux Chops (Big)"
			icon_state = "Tuux_Chops_Big"

		tuux_adorns
			name = "Tuux Face Adorns"
			icon_state = "Tuux_Adorns"

		tuux_handlebar
			name = "Tuux Handlebar"
			icon_state = "Tuux_Handlebar"

		tuux_fumanchu
			name = "Tuux FuManChu"
			icon_state = "Tuux_FuManChu"

		tuux_overeye_left
			name = "Tuux Overeye (Left)"
			icon_state = "Tuux_Overeye_Left"

		tuux_overeye_right
			name = "Tuux Overeye (Right)"
			icon_state = "Tuux_Overeye_Right"

		tuux_mustache
			name = "Tuux Stache"
			icon_state = "Tuux_Mustache"

		tuux_overgrown
			name = "Tuux Overgrown"
			icon_state = "Tuux_Overgrown"

		tuux_braided
			name = "Tuux Braided"
			icon_state = "Tuux_Braided"

		tuux_braided_long
			name = "Tuux Braided (Long)"
			icon_state = "Tuux_Braided_Long"

		tuux_braided_double
			name = "Tuux Braided (Double)"
			icon_state = "Tuux_Braided_Double"

//Vaurca mandibles
	clicky
		icon = 'icons/mob/human_face/vaurca_facial_hair.dmi'
		name = "Clicky Mandibles"
		icon_state = "vaurca_clicky"
		species_allowed = list(/datum/species/bug/type_b)
		gender = NEUTER

		clacky
			name = "Clacky Mandibles"
			icon_state = "vaurca_clacky"

		bulldog
			name = "Bulldog Mandibles"
			icon_state = "vaurca_bulldog"

		mantis
			name = "Mantis Mandibles"
			icon_state = "vaurca_mantis"

		stag
			name = "Stag Mandibles"
			icon_state = "vaurca_stag"

		ectatomma
			name = "Ectatomma Mandibles"
			icon_state = "vaurca_ectatomma"

		horridus
			name = "Horridus Mandibles"
			icon_state = "vaurca_horridus"

		tusks
			name = "Tusk Mandibles"
			icon_state = "vaurca_tusks"

		acanthognathus
			name = "Acanthognathus Mandibles"
			icon_state = "vaurca_acanthognathus"

		myrmoteras
			name = "Myrmoteras Mandibles"
			icon_state = "vaurca_myrmoteras"

/*
////////////////////////////
/  =--------------------=  /
/  ==  Body Markings   ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/marking
	icon = 'icons/mob/human_races/markings.dmi'
	do_colouration = TRUE //Almost all of them have it, COLOR_ADD

	species_allowed = list()

	var/body_parts = list() //A list of bodyparts this covers, TODO: port defines for organs someday
	var/is_genetic = TRUE	// If TRUE, the marking is considered genetic and is embedded into DNA.
	var/is_painted = FALSE	// If TRUE, the marking can be put on prosthetics/robolimbs.

	var/robotize_type_required // if set, this marking will only apply when put on a valid robolimb type

	bandage_head
		name = "Bandage, head 1"
		icon_state = "bandage1"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
		is_genetic = FALSE

		head_2
			name = "Bandage, head 2"
			icon_state= "bandage2"

		head_3
			name = "Bandage, head 3"
			icon_state= "bandage3"

	bandage_chest
		name = "Bandage, chest 1"
		icon_state = "bandage1"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
		is_genetic = FALSE

		chest_2
			name= "Bandage, chest 2"
			icon_state = "bandage2"

		chest_3
			name= "Bandage, chest 3"
			icon_state = "bandage3"

	bandage_groin
		name = "Bandage, groin 1"
		icon_state = "bandage1"
		body_parts = list(BP_GROIN)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
		is_genetic = FALSE

		groin_2
			name= "Bandage, groin 2"
			icon_state = "bandage2"

		groin_3
			name= "Bandage, groin 3"
			icon_state = "bandage3"

	bandage_l_arm
		name = "Bandage, left arm 1"
		icon_state = "bandage1"
		body_parts = list(BP_L_ARM)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
		is_genetic = FALSE

		l_arm_2
			name= "Bandage, left arm 2"
			icon_state = "bandage2"

		l_arm_3
			name= "Bandage, left arm 3"
			icon_state = "bandage3"

	bandage_l_hand
		name = "Bandage, left hand 1"
		icon_state = "bandage1"
		body_parts = list(BP_L_HAND)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
		is_genetic = FALSE

		l_hand_2
			name= "Bandage, left hand 2"
			icon_state = "bandage2"

		l_hand_3
			name= "Bandage, left hand 3"
			icon_state = "bandage3"

	bandage_r_arm
		name = "Bandage, right arm 1"
		icon_state = "bandage1"
		body_parts = list(BP_R_ARM)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
		is_genetic = FALSE

		r_arm_2
			name= "Bandage, right arm 2"
			icon_state = "bandage2"

		r_arm_3
			name= "Bandage, right arm 3"
			icon_state = "bandage3"

	bandage_r_hand
		name = "Bandage, right hand 1"
		icon_state = "bandage1"
		body_parts = list(BP_R_HAND)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
		is_genetic = FALSE

		r_hand_2
			name= "Bandage, right hand 2"
			icon_state = "bandage2"

		r_hand_3
			name= "Bandage, right hand 3"
			icon_state = "bandage3"

	bandage_l_leg
		name = "Bandage, left leg 1"
		icon_state = "bandage1"
		body_parts = list(BP_L_LEG)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
		is_genetic = FALSE

		l_leg_2
			name= "Bandage, left leg 2"
			icon_state = "bandage2"

		l_leg_3
			name= "Bandage, left leg 3"
			icon_state = "bandage3"

	bandage_l_foot
		name = "Bandage, left foot 1"
		icon_state = "bandage1"
		body_parts = list(BP_L_FOOT)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
		is_genetic = FALSE

		l_foot_2
			name= "Bandage, left foot 2"
			icon_state = "bandage2"

		l_foot_3
			name= "Bandage, left foot 3"
			icon_state = "bandage3"

	bandage_r_leg
		name = "Bandage, right leg 1"
		icon_state = "bandage1"
		body_parts = list(BP_R_LEG)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
		is_genetic = FALSE

		r_leg_2
			name= "Bandage, right leg 2"
			icon_state = "bandage2"

		r_leg_3
			name= "Bandage, right leg 3"
			icon_state = "bandage3"

	bandage_r_foot
		name = "Bandage, right foot 1"
		icon_state = "bandage1"
		body_parts = list(BP_R_FOOT)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
		is_genetic = FALSE

		r_foot_2
			name= "Bandage, right foot 2"
			icon_state = "bandage2"

		r_foot_3
			name= "Bandage, right foot 3"
			icon_state = "bandage3"

	heterochromia
		name = "Heterochromia (Right eye)"
		icon_state = "heterochromia"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	aug_scalpports
		name = "Augment (Scalp Ports)"
		icon_state = "aug_scalpports"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

		vertex_left
			name = "Augment (Scalp Port, Vertex Left)"
			icon_state = "aug_vertexport_l"

		vertex_right
			name = "Augment (Scalp Port, Vertex Right)"
			icon_state = "aug_vertexport_r"

		occipital_left
			name = "Augment (Scalp Port, Occipital Left)"
			icon_state = "aug_occipitalport_l"

		occipital_right
			name = "Augment (Scalp Port, Occipital Right)"
			icon_state = "aug_occipitalport_r"

	aug_scalpportsdiode
		name = "Augment (Scalp Ports Diode)"
		icon_state = "aug_scalpportsdiode"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

		vertex_left
			name = "Augment (Scalp Port Diode, Vertex Left )"
			icon_state = "aug_vertexportdiode_l"

		vertex_right
			name = "Augment (Scalp Port Diode, Vertex Right)"
			icon_state = "aug_vertexportdiode_r"

		occipital_left
			name = "Augment (Scalp Port Diode, Occipital Left)"
			icon_state = "aug_occipitalportdiode_l"

		occipital_right
			name = "Augment (Scalp Port Diode, Occipital Right)"
			icon_state = "aug_occipitalportdiode_r"

	aug_backside_left
		name = "Augment (Backside Left, Head)"
		icon_state = "aug_backside_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

		side_diode
			name = "Augment (Backside Left Diode, Head)"
			icon_state = "aug_sidediode_l"

	aug_backside_right
		name = "Augment (Backside Right, Head)"
		icon_state = "aug_backside_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

		side_diode
			name = "Augment (Backside Right Diode, Head)"
			icon_state = "aug_sidediode_r"

	aug_side_deunan_left
		name = "Augment (Deunan, Side Left)"
		icon_state = "aug_sidedeunan_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	aug_side_deunan_right
		name = "Augment (Deunan, Side Right)"
		icon_state = "aug_sidedeunan_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	aug_side_kuze_left
		name = "Augment (Kuze, Side Left)"
		icon_state = "aug_sidekuze_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

		side_diode
			name = "Augment (Kuze Diode, Side Left)"
			icon_state = "aug_sidekuzediode_l"

	aug_side_kuze_right
		name = "Augment (Kuze, Side Right)"
		icon_state = "aug_sidekuze_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

		side_diode
			name = "Augment (Kuze Diode, Side Right)"
			icon_state = "aug_sidekuzediode_r"

	aug_side_kinzie_left
		name = "Augment (Kinzie, Side Left)"
		icon_state = "aug_sidekinzie_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	aug_side_kinzie_right
		name = "Augment (Kinzie, Side Right)"
		icon_state = "aug_sidekinzie_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	aug_side_shelly_left
		name = "Augment (Shelly, Side Left)"
		icon_state = "aug_sideshelly_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	aug_side_shelly_right
		name = "Augment (Shelly, Side Right)"
		icon_state = "aug_sideshelly_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	aug_chestports
		name = "Augment (Chest Ports)"
		icon_state = "aug_chestports"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

	aug_abdomenports
		name = "Augment (Abdomen Ports)"
		icon_state = "aug_abdomenports"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

	aug_lowerjaw
		name = "Augment (Lower Jaw)"
		icon_state = "aug_lowerjaw"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/skrell,/datum/species/skrell/axiori,/datum/species/unathi)

	aug_headcase
		name = "Augment (Headcase)"
		icon_state = "aug_headcase"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	aug_headcaselight
		name = "Augment (Headcase, Light)"
		icon_state = "aug_headcaselight"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	vaurca_augs
		name = "Mecha Chest"
		icon = 'icons/mob/human_races/markings_vaurca.dmi'
		icon_state = "mecha_chest"
		do_colouration = FALSE
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/bug, /datum/species/bug/type_b)

		mecha_abdomen
			name = "Mecha Abdomen"
			icon_state = "mecha_abdomen"

		mecha_spine
			name = "Mecha Spine"
			icon_state = "mecha_spine"
			body_parts = list(BP_HEAD, BP_CHEST)

		chest_tubes
			name = "Chest Tubes"
			icon_state = "chest_tubes"

		chest_wires
			name = "Chest Wires"
			icon_state = "chest_wires"

		mecha_eye_b
			name = "Mecha Eye (Blue, Right)"
			icon_state = "mecha_eye_b_r"
			body_parts = list(BP_HEAD)

			mecha_eye_b_l
				name = "Mecha Eye (Blue, Left)"
				icon_state = "mecha_eye_b_l"

			mecha_eye_r_l
				name = "Mecha Eye (Red, Left)"
				icon_state = "mecha_eye_r_l"

			mecha_eye_r_r
				name = "Mecha Eye (Red, Right)"
				icon_state = "mecha_eye_r_r"

			mecha_eye_y_l
				name = "Mecha Eye (Yellow, Left)"
				icon_state = "mecha_eye_y_l"

			mecha_eye_y_r
				name = "Mecha Eye (Yellow, Right)"
				icon_state = "mecha_eye_y_r"

			mandible
				name = "Mecha Mandibles"
				icon_state = "mecha_mandibles"

		hand_panel_r
			name = "Hand Panel (Right)"
			icon_state = "hand_panel_r"
			body_parts = list(BP_R_HAND)

		hand_panel_l
			name = "Hand Panel (Left)"
			icon_state = "hand_panel_l"
			body_parts = list(BP_L_HAND)

	bulwark_augs
		icon = 'icons/mob/human_races/markings_vaurcae.dmi'
		name = "Mecha Eye L"
		icon_state = "mechaeyebully_l"
		do_colouration = FALSE
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/bug/type_e)

		mechaeyebully_r
			name = "Mecha Eye R"
			icon_state = "mechaeyebully_r"

		mechaeyeoverlaybully_l
			name = "Mecha Eye Overlay L"
			icon_state = "mechaeyeoverlaybully_l"

		mechaeyeoverlaybully_r
			name = "Mecha Eye Overlay R"
			icon_state = "mechaeyeoverlaybully_r"

		mechamandiblesbully
			name = "Mecha Mandibles (Bulwark)"
			icon_state = "mechamandiblesbully"

		mechamandiblesoverlaybully
			name = "Mecha Mandibles Overlay"
			icon_state = "mechamandiblesoverlaybully"

		visorbully
			name = "Visor"
			icon_state = "visorbully"

		visorbullyoverlay
			name = "Visor Overlay"
			icon_state = "visorbullyoverlay"

		spidereyesbully
			name = "Spider Eyes"
			icon_state = "spidereyesbully"

		spidereyesbullyoverlay
			name = "Spider Eyes Overlay"
			icon_state = "spidereyesbullyoverlay"

		mechamonoculusbully
			name = "Mecha Monoculus"
			icon_state = "mechamonoculusbully"

		mechamonoculusbullyoverlay
			name = "Mecha Monoculus Overlay"
			icon_state = "mechamonoculusbullyoverlay"

	bullybackmeter
		icon = 'icons/mob/human_races/markings_vaurcae.dmi'
		name = "Back Meter (Bulwark)"
		icon_state = "bullybackmeter"
		do_colouration = FALSE
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/bug/type_e)

		bullybackmeteroverlay
			name = "Back Meter Overlay"
			icon_state = "bullybackmeteroverlay"

		mechahorn_l
			name = "Mecha Horn L"
			icon_state = "mechahorn_l"

		mechahorn_r
			name = "Mecha Horn R"
			icon_state = "mechahorn_r"

		bullybackwires
			name = "Back Wires (Bulwark)"
			icon_state = "bullybackwires"

		bullybacktubes
			name = "Back Tubes (Bulwark)"
			icon_state = "bullybacktubes"

		ventsbully
			name = "Vents (Bulwark)"
			icon_state = "ventsbully"

		shellpanelbully
			name = "Shell Panel"
			icon_state = "shellpanelbully"

	mechakneesbully_l
		icon = 'icons/mob/human_races/markings_vaurcae.dmi'
		name = "Mecha Knees L"
		icon_state = "mechakneesbully_l"
		do_colouration = FALSE
		body_parts = list(BP_L_LEG)
		species_allowed = list(/datum/species/bug/type_e)

	mechakneesbully_r
		icon = 'icons/mob/human_races/markings_vaurcae.dmi'
		name = "Mecha Knees R"
		icon_state = "mechakneesbully_r"
		do_colouration = FALSE
		body_parts = list(BP_R_LEG)
		species_allowed = list(/datum/species/bug/type_e)

	mechaabdomenbully
		icon = 'icons/mob/human_races/markings_vaurcae.dmi'
		name = "Mecha Abdomen (Bulwark)"
		icon_state = "mechaabdomenbully"
		do_colouration = FALSE
		body_parts = list(BP_GROIN)
		species_allowed = list(/datum/species/bug/type_e)

	mechapelvisbully
		icon = 'icons/mob/human_races/markings_vaurcae.dmi'
		name = "Mecha Pelvis (Bulwark)"
		icon_state = "mechapelvisbully"
		do_colouration = FALSE
		body_parts = list(BP_GROIN)
		species_allowed = list(/datum/species/bug/type_e)

	handpanelbully_l
		icon = 'icons/mob/human_races/markings_vaurcae.dmi'
		name = "Hand Panel L"
		icon_state = "handpanelbully_l"
		do_colouration = FALSE
		body_parts = list(BP_L_HAND)
		species_allowed = list(/datum/species/bug/type_e)

	handpanelbully_r
		icon = 'icons/mob/human_races/markings_vaurcae.dmi'
		name = "Hand Panel R"
		icon_state = "handpanelbully_r"
		do_colouration = FALSE
		body_parts = list(BP_R_HAND)
		species_allowed = list(/datum/species/bug/type_e)

	handpanelbully_loverlay
		icon = 'icons/mob/human_races/markings_vaurcae.dmi'
		name = "Hand Panel L Overlay"
		icon_state = "handpanelbully_loverlay"
		do_colouration = FALSE
		body_parts = list(BP_L_HAND)
		species_allowed = list(/datum/species/bug/type_e)

	handpanelbully_roverlay
		icon = 'icons/mob/human_races/markings_vaurcae.dmi'
		name = "Hand Panel R Overlay"
		icon_state = "handpanelbully_roverlay"
		do_colouration = FALSE
		body_parts = list(BP_R_HAND)
		species_allowed = list(/datum/species/bug/type_e)

	armwirebully_l
		icon = 'icons/mob/human_races/markings_vaurcae.dmi'
		name = "Arm Wires L"
		icon_state = "armwirebully_l"
		do_colouration = FALSE
		body_parts = list(BP_L_ARM)
		species_allowed = list(/datum/species/bug/type_e)

	armwirebully_r
		icon = 'icons/mob/human_races/markings_vaurcae.dmi'
		name = "Arm Wires R"
		icon_state = "armwirebully_r"
		do_colouration = FALSE
		body_parts = list(BP_R_ARM)
		species_allowed = list(/datum/species/bug/type_e)

	armwirebullyhand_l
		icon = 'icons/mob/human_races/markings_vaurcae.dmi'
		name = "Hand Wires L"
		icon_state = "handwirebully_l"
		do_colouration = FALSE
		body_parts = list(BP_L_HAND)
		species_allowed = list(/datum/species/bug/type_e)

	armwiresbullyhand_r
		icon = 'icons/mob/human_races/markings_vaurcae.dmi'
		name = "Hand Wires R"
		icon_state = "handwirebully_r"
		do_colouration = FALSE
		body_parts = list(BP_R_HAND)
		species_allowed = list(/datum/species/bug/type_e)

	backstripe
		name = "Back Stripe"
		icon_state = "backstripe"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

		spinemarks
			name = "Back Stripe Marks"
			icon_state = "backstripemarks"

	bands
		name = "Color Bands (All)"
		icon_state = "bands"
		body_parts = list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_GROIN, BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

		chest
			name = "Color Bands (Torso)"
			body_parts = list(BP_CHEST)

		groin
			name = "Color Bands (Groin)"
			body_parts = list(BP_GROIN)

		left_arm
			name = "Color Bands (Left Arm)"
			body_parts = list(BP_L_ARM)

		right_arm
			name = "Color Bands (Right Arm)"
			body_parts = list(BP_R_ARM)

		left_hand
			name = "Color Bands (Left Hand)"
			body_parts = list(BP_L_HAND)

		right_hand
			name = "Color Bands (Right Hand)"
			body_parts = list(BP_R_HAND)

		left_leg
			name = "Color Bands (Left Leg)"
			body_parts = list(BP_L_LEG)

		right_leg
			name = "Color Bands (Right Leg)"
			body_parts = list(BP_R_LEG)

		left_foot
			name = "Color Bands (Left Foot)"
			body_parts = list(BP_L_FOOT)
			species_allowed = list(/datum/species/unathi)

		left_foot_human
			name = "Color Bands (Left Foot)"
			icon_state = "bandshuman"
			body_parts = list(BP_L_FOOT)
			species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell)

		right_foot
			name = "Color Bands (Right Foot)"
			body_parts = list(BP_R_FOOT)
			species_allowed = list(/datum/species/unathi)

		right_foot_human
			name = "Color Bands (Right Foot)"
			icon_state = "bandshuman"
			body_parts = list(BP_R_FOOT)
			species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell)

	bandsface
		name = "Color Bands (Face)"
		icon_state = "bandsface"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	bandsface_human
		name = "Color Bands (Face)"
		icon_state = "bandshumanface"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell)

	bindi
		name = "Bindi"
		icon_state = "bindi"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/machine/shell, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	blush
		name = "Blush"
		icon_state= "blush"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	cheekspot_left
		name = "Cheek Spot (Left Cheek)"
		icon_state = "cheekspot_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	cheekspot_right
		name = "Cheek Spot (Right Cheek)"
		icon_state = "cheekspot_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	cheshire_left
		name = "Cheshire (Left Cheek)"
		icon_state = "cheshire_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori,)

	cheshire_right
		name = "Cheshire (Right Cheek)"
		icon_state = "cheshire_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori,)

	crow_left
		name = "Crow Mark (Left Eye)"
		icon_state = "crow_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	crow_right
		name = "Crow Mark (Right Eye)"
		icon_state = "crow_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	ear_left
		name = "Ear Cover (Left)"
		icon_state = "ear_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell)

	ear_right
		name = "Ear Cover (Right)"
		icon_state = "ear_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell)

	eyestripe
		name = "Eye Stripe"
		icon_state = "eyestripe"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	eyecorner_left
		name = "Eye Corner Left"
		icon_state = "eyecorner_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	eyecorner_right
		name = "Eye Corner Right"
		icon_state = "eyecorner_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	eyelash_left
		name = "Eyelash Left"
		icon_state = "eyelash_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/skrell/axiori, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	eyelash_right
		name = "Eyelash Right"
		icon_state = "eyelash_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/skrell/axiori, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	lips
		name = "Lips"
		icon_state = "lips"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori)

	lipcorner_left
		name = "Lip Corner Left"
		icon_state = "lipcorner_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori)

	lipcorner_right
		name = "Lip Corner Right"
		icon_state = "lipcorner_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori)

	lowercheek_left
		name = "Lower Cheek Left"
		icon_state = "lowercheek_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori)

	lowercheek_right
		name = "Lower Cheek Right"
		icon_state = "lowercheek_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori,)

	neck
		name = "Neck Cover"
		icon_state = "neck"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	neckthick
		name = "Neck Cover (Thick)"
		icon_state = "neckthick"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	nosestripe
		name = "Nose Stripe"
		icon_state = "nosestripe"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

	nosetape
		name = "Nose Tape"
		icon_state = "nosetape"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/bug, /datum/species/bug/type_b)

	scar_chest
		name = "Scar, Chest"
		icon_state = "surgicalscar"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

	scar_chest_left
		name = "Scar, Chest Left"
		icon_state = "chestscar1"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

	scar_chest_right
		name = "Scar, Chest Right"
		icon_state = "chestscar2"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

	scratch_abdomen_left
		name = "Scratch, Abdomen Left"
		icon_state = "scratch_abdomen_l"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

	scratch_abdomen_right
		name = "Scratch, Abdomen Right"
		icon_state = "scratch_abdomen_r"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

	scratch_abdomen_small_left
		name = "Scratch, Abdomen Small Left"
		icon_state = "scratch_abdomensmall_l"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

	scratch_abdomen_small_right
		name = "Scratch, Abdomen Small Right"
		icon_state = "scratch_abdomensmall_r"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

	scratch_back
		name = "Scratch, Back"
		icon_state = "scratch_back"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

	scratch_chest_left
		name = "Scratch, Chest (Left)"
		icon_state = "scratch_chest_l"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	scratch_chest_right
		name = "Scratch, Chest (Right)"
		icon_state = "scratch_chest_r"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_belly
		name = "Tattoo (Belly)"
		icon_state = "tat_belly"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_campbell_leftarm
		name = "Tattoo (Campbell, Left Arm)"
		icon_state = "tat_campbell"
		body_parts = list(BP_L_ARM)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_campbell_rightarm
		name = "Tattoo (Campbell, Right Arm)"
		icon_state = "tat_campbell"
		body_parts= list(BP_R_ARM)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_campbell_leftleg
		name = "Tattoo (Campbell, Left Leg)"
		icon_state = "tat_campbell"
		body_parts= list(BP_L_LEG)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_campbell_rightleg
		name = "Tattoo (Campbell, Right Leg)"
		icon_state = "tat_campbell"
		body_parts= list(BP_R_LEG)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_circle_back
		name = "Tattoo (Circle, Back)"
		icon_state = "tat_circle"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_circle_big_back
		name = "Tattoo (Big Circle, Back)"
		icon_state = "tat_bigcircle"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_forrest_left
		name = "Tattoo (Forrest, Left Eye)"
		icon_state = "tat_forrest_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_forrest_right
		name = "Tattoo (Forrest, Right Eye)"
		icon_state = "tat_forrest_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_harness
		name = "Tattoo (Harness, Chest)"
		icon_state = "tat_harness"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_hive
		name = "Tattoo (Hive, Back)"
		icon_state = "tat_hive"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_heart_arm
		name = "Tattoo (Heart, Left Arm)"
		icon_state = "tat_lheart"
		body_parts = list(BP_L_ARM)
		species_allowed = list(/datum/species/human, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

		right
			name = "Tattoo (Heart, Right Arm)"
			icon_state = "tat_rheart"
			body_parts = list(BP_R_ARM)

	tat_heart_back
		name = "Tattoo (Heart, Lower Back)"
		icon_state = "tat_heartback"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell)

	tat_hunter_left
		name = "Tattoo (Hunter, Left Eye)"
		icon_state = "tat_hunter_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_hunter_right
		name = "Tattoo (Hunter, Right Eye)"
		icon_state = "tat_hunter_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_jaeger_left
		name = "Tattoo (Jaeger, Left Eye)"
		icon_state = "tat_jaeger_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_jaeger_right
		name = "Tattoo (Jaeger, Right Eye)"
		icon_state = "tat_jaeger_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_kater_left
		name = "Tattoo (Kater, Left Eye)"
		icon_state = "tat_kater_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_kater_right
		name = "Tattoo (Kater, Right Eye)"
		icon_state = "tat_kater_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_lujan_left
		name = "Tattoo (Lujan, Left Eye)"
		icon_state = "tat_lujan_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_lujan_right
		name = "Tattoo (Lujan, Right Eye)"
		icon_state = "tat_lujan_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_natasha_left
		name = "Tattoo (Natasha, Left Eye)"
		icon_state = "tat_natasha_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_natasha_right
		name = "Tattoo (Natasha, Right Eye)"
		icon_state = "tat_natasha_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_nightling
		name = "Tattoo (Nightling, Back)"
		icon_state = "tat_nightling"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

		tat_silverburgh_left
		name = "Tattoo (Silverburgh, Left Leg)"
		icon_state = "tat_silverburgh"
		body_parts = list(BP_L_LEG)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori,/datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_silverburgh_right
		name = "Tattoo (Silverburgh, Right Leg)"
		icon_state = "tat_silverburgh"
		body_parts = list(BP_R_LEG)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_spine_back
		name = "Tattoo (Spine, Back)"
		icon_state = "tat_spine"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_tamoko
		name = "Tattoo (Ta Moko, Face)"
		icon_state = "tat_tamoko"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori)

	tat_tiger
		name = "Tattoo (Tiger Stripes, All)"
		icon_state = "tat_tiger"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

		chest
			name = "Tattoo (Tiger Stripes, Chest)"
			body_parts = list(BP_CHEST)

		groin
			name = "Tattoo (Tiger Stripes, Groin)"
			body_parts = list(BP_GROIN)

		left_arm
			name = "Tattoo (Tiger Stripes, Left Arm)"
			body_parts = list(BP_L_ARM)

		right_arm
			name = "Tattoo (Tiger Stripes, Right Arm)"
			body_parts = list(BP_R_ARM)

		left_hand
			name = "Tattoo (Tiger Stripes, Left Hand)"
			body_parts = list(BP_L_HAND)

		right_hand
			name = "Tattoo (Tiger Stripes, Right Hand)"
			body_parts = list(BP_R_HAND)

		left_leg
			name = "Tattoo (Tiger Stripes, Left Leg)"
			body_parts = list(BP_L_LEG)

		right_leg
			name = "Tattoo (Tiger Stripes, Right Leg)"
			body_parts = list(BP_R_LEG)

		left_foot
			name = "Tattoo (Tiger Stripes, Left Foot)"
			body_parts = list(BP_L_FOOT)

		right_foot
			name = "Tattoo (Tiger Stripes, Right Foot)"
			body_parts = list(BP_R_FOOT)

	tat_toshi_left
		name = "Tattoo (Toshi, Left Eye)"
		icon_state = "tat_toshi_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_toshi_right
		name = "Tattoo (Volgin, Right Eye)"
		icon_state = "tat_toshi_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	tat_wings_back
		name = "Tattoo (Wings, Lower Back)"
		icon_state = "tat_wingsback"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell)

	tigerhead
		name = "Tiger Stripes (Head, Minor)"
		icon_state = "tigerhead"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	backstripe
		name = "Back Stripe"
		icon_state = "backstripe"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara,/datum/species/unathi,/datum/species/zombie/unathi)

	una_paw_socks
		name = "Socks Coloration (Unathi)"
		icon = 'icons/mob/human_races/markings_unathi.dmi'
		icon_state = "una_pawsocks"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
		species_allowed = list(/datum/species/unathi,/datum/species/zombie/unathi)

	bands
		name = "Color Bands"
		icon_state = "bands"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN)
		species_allowed = list(/datum/species/unathi,/datum/species/zombie/unathi)

	bandsface
		name = "Color Bands (Face)"
		icon_state = "bandsface"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara,/datum/species/unathi,/datum/species/zombie/unathi)

	una_face
		name = "Face Color"
		icon_state = "una_face"
		body_parts = list(BP_HEAD)
		icon = 'icons/mob/human_races/markings_unathi.dmi'
		species_allowed = list(/datum/species/unathi, /datum/species/zombie/unathi)

		paint
			name = "Face Paint"
			icon_state = "una_facepaint"

		una_facelow
			name = "Face Color Low"
			icon_state = "una_facelow"
			body_parts = list(BP_HEAD)

		una_scutes
			name = "Scutes"
			icon_state = "una_scutes"
			body_parts = list(BP_CHEST)

		una_maswaist
			name = "Masculine Waist (For Females)"
			icon_state = "una_maswaist"
			body_parts = list(BP_CHEST)

		una_clawshand
			name = "Claws (Hands)"
			icon_state = "una_claws"
			body_parts = list(BP_L_HAND,BP_R_HAND)

		una_clawsfoot
			name = "Claws (Feet)"
			icon_state = "una_claws"
			body_parts = list(BP_L_FOOT,BP_R_FOOT)

	spelunker
		name = "Spelunker"
		icon_state = "spelunker"
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_GROIN,BP_HEAD)
		species_allowed = list(/datum/species/bug,/datum/species/bug/type_b)

	delver
		name = "Delver"
		icon_state = "delver"
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_GROIN,BP_HEAD)
		species_allowed = list(/datum/species/bug,/datum/species/bug/type_b)

	skr_tears
		name = "Skrell Tear Stains (Xiialt)"
		icon = 'icons/mob/human_races/markings_skrell.dmi'
		icon_state = "skr_tears"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/skrell,/datum/species/zombie/skrell)

	skr_tears_axiori
		name = "Skrell Tear Stains (Axiori)"
		icon = 'icons/mob/human_races/markings_skrell.dmi'
		icon_state = "skr_tears_axiori"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

	skr_dart_frog
		name = "Skrell Dart Frog (Xiialt)"
		icon = 'icons/mob/human_races/markings_skrell.dmi'
		icon_state = "skr_dart_frog"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/skrell,/datum/species/zombie/skrell)

	skr_dart_frog_axiori
		name = "Skrell Dart Frog (Axiori)"
		icon = 'icons/mob/human_races/markings_skrell.dmi'
		icon_state = "skr_dart_frog_axiori"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

	skr_axiori_eyes
		name = "Axiori Eyes"
		icon = 'icons/mob/human_races/markings_skrell.dmi'
		icon_state = "skr_axiori_eyes"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/skrell,/datum/species/zombie/skrell)

	skr_arms
		name = "Skrell Arms"
		icon = 'icons/mob/human_races/markings_skrell.dmi'
		icon_state = "skr_arms"
		body_parts = list(BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
		species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

	skr_blotch_arms
		name = "Skrell Arm Blotches"
		icon = 'icons/mob/human_races/markings_skrell.dmi'
		icon_state = "skr_blotch_arms"
		body_parts = list(BP_L_ARM,BP_R_ARM)
		species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

	skr_blotch_leg
		name = "Skrell Leg Blotches"
		icon = 'icons/mob/human_races/markings_skrell.dmi'
		icon_state = "skr_blotch_legs"
		body_parts = list(BP_L_LEG,BP_R_LEG)
		species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

	skr_back_stripes
		name = "Skrell Back Stripes"
		icon = 'icons/mob/human_races/markings_skrell.dmi'
		icon_state = "skr_back_stripes"
		body_parts = list(BP_CHEST)
		species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

	skr_stomach
		name = "Skrell Stomach"
		icon = 'icons/mob/human_races/markings_skrell.dmi'
		icon_state = "skr_stomach"
		body_parts = list(BP_CHEST, BP_GROIN)
		species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

	skr_chin
		name = "Skrell Chin"
		icon = 'icons/mob/human_races/markings_skrell.dmi'
		icon_state = "skr_chin"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

	skr_gills
		name = "Skrell Gills"
		icon = 'icons/mob/human_races/markings_skrell.dmi'
		icon_state = "skr_gills"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

	skr_xibus
		name = "Skrell Xibus"
		icon = 'icons/mob/human_races/markings_skrell.dmi'
		icon_state = "skr_beak"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

	diona_leaves
		name = "Diona Leaves"
		icon = 'icons/mob/human_races/markings_diona.dmi'
		icon_state = "diona_leaves"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_GROIN,BP_HEAD)
		species_allowed = list(/datum/species/diona, /datum/species/diona/coeu)

		thorns_head
			name = "Diona Thorns (Head)"
			icon_state = "diona_thorns"
			body_parts = list(BP_HEAD)

		thorns_torso
			name = "Diona Thorns (Torso)"
			icon_state = "diona_thorns"
			body_parts = list(BP_CHEST)

		flowers_head
			name = "Diona Flowers (Head)"
			icon_state = "diona_flowers"
			body_parts = list(BP_HEAD)

		flowers_torso
			name = "Diona Flowers (Torso)"
			icon_state = "diona_flowers"
			body_parts = list(BP_CHEST)

		moss
			name = "Diona Moss"
			icon_state = "diona_moss"
			body_parts = list(BP_CHEST)

		mushroom
			name = "Diona Mushroom"
			icon_state = "diona_mushroom"
			body_parts = list(BP_HEAD)

			antennae
				name = "Diona Antennae"
				icon_state = "diona_antennae"

		bug_eyes
			name = "Bug Eyes"
			icon_state = "bugeyes"
			body_parts = list(BP_HEAD)
			do_colouration = FALSE

			human_eyes
				name = "Human Eyes"
				icon_state = "humaneyes"

			skrell_eyes
				name = "Skrell Eyes"
				icon_state = "skrelleyes"

			skrell_eyes_2
				name = "Skrell Eyes 2"
				icon_state = "skrelleyes2"

			small_horns
				name = "Small Horns"
				icon_state = "smallhorns"

			horny
				name = "Horny"
				icon_state = "horny"

			treebeard
				name = "Treebeard"
				icon_state = "treebeard"

			tinyeye
				name = "Tiny Eye"
				icon_state = "tinyeye"

			eyebrow
				name = "Eyebrow"
				icon_state = "eyebrow"

			bullhorn
				name = "Bullhorn"
				icon_state = "bullhorn"

			mono_eye
				name = "Mono Eye"
				icon_state = "monoeye"

			trioptics
				name = "Trioptics"
				icon_state = "trioptics"

			lopsided
				name = "Lopsided"
				icon_state = "lopsided"

			helmethead
				name = "Helmethead"
				icon_state = "helmethead"

			eyestalk
				name = "Eyestalk"
				icon_state = "eyestalk"

			periscope
				name = "Periscope"
				icon_state = "periscope"

			glorp
				name = "Glorp"
				icon_state = "glorp"

			oak
				name = "Oak"
				icon_state = "oak"

			thorns
				name = "Thorns"
				icon_state = "thorns"

			stump
				name = "Stump"
				icon_state = "stump"

		pbody
			name = "P-Body"
			icon_state = "pbody"
			body_parts = list(BP_CHEST)
			do_colouration = FALSE

			blinking
				name = "Blinking P-Body"
				icon_state = "blinkingpbody"

		foot_eye
			name = "Foot Eye"
			icon_state = "footeye"
			body_parts = list(BP_L_FOOT)
			do_colouration = FALSE

		hand_eyes
			name = "Hand Eyes"
			icon_state = "handeye"
			body_parts = list(BP_R_HAND, BP_L_HAND)
			do_colouration = FALSE

		tail
			name = "Tail"
			icon_state = "dionatail"
			body_parts = list(BP_GROIN)
			do_colouration = FALSE

//bishop
	bishop_lights
		name = "Bishop - Lights Colour"
		icon = 'icons/mob/human_races/markings_bishop.dmi'
		icon_state = "bishop_lights"
		icon_blend_mode = ICON_MULTIPLY
		is_painted = TRUE
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_HEAD)
		robotize_type_required = PROSTHETIC_BC

		bishop_mask
			name = "Bishop - Face Mask"
			icon_state = "bishop_mask"
			do_colouration = FALSE
			body_parts = list(BP_HEAD)

			bishop_triangular_mask
				name = "Bishop - Triangular Face Mask"
				icon_state = "bishop_triangular_mask"

		bishop_panels
			name = "Bishop - Full Body Panel Colors"
			icon_state = "bishop_panels"
			body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_HEAD)

			bishop_head
				name = "Bishop - Head Panel Colors"
				body_parts = list(BP_HEAD)

			bishop_legs
				name = "Bishop - Leg Panel Colors"
				body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

			bishop_arms
				name = "Bishop - Arm Panel Colors"
				body_parts = list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM)

//hephaestus g1
	g1_panels
		name = "G1 - Full Panel Colors"
		icon = 'icons/mob/human_races/markings_industrial.dmi'
		icon_state = "g1_primary"
		icon_blend_mode = ICON_MULTIPLY
		is_painted = TRUE
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM,BP_GROIN,BP_CHEST,BP_HEAD)
		robotize_type_required = PROSTHETIC_IND

		g1_head
			name = "G1 - Head Panel Colors"
			body_parts = list(BP_HEAD)

		g1_legs
			name = "G1 - Leg Panel Colors"
			body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

		g1_arms
			name = "G1 - Arm Panel Colors"
			body_parts = list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM)

		g1_lights
			name = "G1 - Lights Color"
			icon_state = "g1_lights"
			body_parts = list(BP_CHEST,BP_HEAD)

//hephaestus g2
	g2_panels
		name = "G2 - Full Panel Colors"
		icon = 'icons/mob/human_races/markings_hephaestus.dmi'
		icon_state = "g2_primary"
		icon_blend_mode = ICON_MULTIPLY
		is_painted = TRUE
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM,BP_GROIN,BP_CHEST,BP_HEAD)
		robotize_type_required = PROSTHETIC_HI

		g2_head
			name = "G2 - Head Panel Colors"
			body_parts = list(BP_HEAD)

		g2_legs
			name = "G2 - Leg Panel Colors"
			body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

		g2_arms
			name = "G2 - Arm Panel Colors"
			body_parts = list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM)

		g2_lights
			name = "G2 - Lights Color"
			icon_state = "g2_lights"
			body_parts = list(BP_L_ARM,BP_R_ARM,BP_L_LEG,BP_R_LEG,BP_GROIN,BP_CHEST,BP_HEAD)

//zeng-hu mobility frame
	zeng_panels
		name = "Zeng-Hu - Full Panel Colors"
		icon = 'icons/mob/human_races/markings_zenghu.dmi'
		icon_state = "zeng_primary"
		icon_blend_mode = ICON_MULTIPLY
		is_painted = TRUE
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM,BP_GROIN,BP_CHEST,BP_HEAD)
		robotize_type_required = PROSTHETIC_ZH

		zeng_head
			name = "Zeng-Hu - Head Panel Colors"
			body_parts = list(BP_HEAD)

		zeng_legs
			name = "Zeng-Hu - Leg Panel Colors"
			body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

		zeng_arms
			name = "Zeng-Hu - Arm Panel Colors"
			body_parts = list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM)

		zeng_lights
			name = "Zeng-Hu - Lights Color"
			icon_state = "zeng_lights"
			body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_HEAD)

//xion
	xion_panels
		name = "Xion - Full Panel Colors"
		icon = 'icons/mob/human_races/markings_xion.dmi'
		icon_state = "xion_primary"
		icon_blend_mode = ICON_MULTIPLY
		is_painted = TRUE
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM,BP_GROIN,BP_CHEST,BP_HEAD)
		robotize_type_required = PROSTHETIC_XMG

		xion_head
			name = "Xion - Head Panel Colors"
			body_parts = list(BP_HEAD)

		xion_legs
			name = "Xion - Leg Panel Colors"
			body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

		xion_arms
			name = "Xion - Arm Panel Colors"
			body_parts = list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM)

		xion_lights
			name = "Xion - Lights Color"
			icon_state = "xion_lights"
			body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_HEAD)

//Tajara

	taj_tigerstripes
		name = "Tiger Stripes (Tajara)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "tiger"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_GROIN)
		species_allowed = list(/datum/species/unathi,/datum/species/zombie/unathi,/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_paw_socks
		name = "Socks Coloration (Tajara)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_pawsocks"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_pawsocks_alternate
		name = "Socks Coloration (Tajara Alternate)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_pawsocks_alternate"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_gloves
		name = "Socks Coloration (Gloves)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_pawsocks"
		body_parts = list(BP_L_HAND,BP_R_HAND)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_paws
		name = "Socks Coloration (Paws)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_pawsocks"
		body_parts = list(BP_L_FOOT,BP_R_FOOT)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_glovesfull
		name = "Socks Coloration (Full Gloves)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_pawsocks"
		body_parts = list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_pawsfull
		name = "Socks Coloration (Full Paws)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_pawsocks"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_glovesfull_alt
		name = "Socks Coloration (Full Gloves Alt)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_pawsocks_alternate"
		body_parts = list(BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_pawsfull_alt
		name = "Socks Coloration (Full Paws Alt)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_pawsocks_alternate"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_glovesfull_alt2
		name = "Socks Coloration (Full Gloves Alt 2)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_bellyhandsfeet_minor"
		body_parts = list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_pawsfull_alt2
		name = "Socks Coloration (Full Paws Alt 2)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_bellyhandsfeet_minor"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_bands
		name = "Color Bands (Tajara)"
		icon_state = "bands"
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_tigerhead_veryminor
		name = "Tiger Stripes (Head, Very Minor)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "tigerheadminor"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona,  /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

	taj_tigerface
		name = "Tiger Stripes (Head, Major)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "tigerface"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_nose
		name = "Nose Color"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_nose"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_muzzle
		name = "Muzzle Color"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_muzzle"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_muzzle_female
		name = "Muzzle Color (Female)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_muzzle_female"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_face_minor
		name = "Cheeks Color (Minor)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_face_minor"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_face
		name = "Cheeks Color"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_face"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_all
		name = "All Tajara Head"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_all"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_belly_hands_feet_minor
		name = "Hands,Feet,Belly Color (Minor)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_bellyhandsfeet_minor"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_belly_hands_feet_minor_female
		name = "Hands,Feet,Belly Color (Female, Minor)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_bellyhandsfeet_minor_female"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_belly_male
		name = "Belly Color (Male)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_bellyhandsfeet_minor"
		body_parts = list(BP_GROIN,BP_CHEST)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_belly_female
		name = "Belly Color (Female)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_bellyhandsfeet_minor_female"
		body_parts = list(BP_GROIN,BP_CHEST)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_chest_male
		name = "Chest,Belly Coloration (Male)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_bellyhandsfeet"
		body_parts = list(BP_GROIN,BP_CHEST)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_chest_female
		name = "Chest,Belly Coloration (Female)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_bellyhandsfeet_female"
		body_parts = list(BP_GROIN,BP_CHEST)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_patches_full
		name = "Color Patches (Full)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_patches"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_patches_leftleg
		name = "Color Patches (Left Leg)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_patches"
		body_parts = list(BP_L_FOOT,BP_L_LEG)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_patches_rightleg
		name = "Color Patches (Right Leg)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_patches"
		body_parts = list(BP_R_FOOT,BP_R_LEG)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_patches_leftarm
		name = "Color Patches (Left Arm)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_patches"
		body_parts = list(BP_L_ARM,BP_L_HAND)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_patches_rightarm
		name = "Color Patches (Right Arm)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_patches"
		body_parts = list(BP_R_ARM,BP_R_HAND)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_patches_chest
		name = "Color Patches (Torso)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_patches"
		body_parts = list(BP_CHEST,BP_GROIN)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

	taj_patchesface
		name = "Color Patches (Face)"
		icon = "icons/mob/human_races/markings_tajara.dmi"
		icon_state = "taj_patchesface"
		body_parts = list(BP_HEAD)
		species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)
