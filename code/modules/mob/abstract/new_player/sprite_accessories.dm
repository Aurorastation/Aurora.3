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

	// Restrict some styles to specific species
	var/list/species_allowed = list("Human")

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
		gender = MALE
		species_allowed = list("Human","Unathi")
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
		gender = MALE
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
		gender = FEMALE
		length = 2
		chatname = "long hair"

	averagejoe
		name = "Average Joe"
		icon_state = "hair_averagejoe"
		gender = MALE
		chatname = "short hair"

	baldingfade
		name = "Balding Fade"
		icon_state = "hair_baldingfade"
		gender = MALE
		length = 0
		chatname = "bald head"

	baldinghair
		name = "Balding Hair"
		icon_state = "hair_baldinghair" //hair_e
		gender = MALE // turnoff!
		length = 0
		chatname = "balding hair"

	bangs
		name = "Bangs"
		icon_state = "hair_bangs"
		gender = FEMALE
		length = 2
		chatname = "fringe"

	bangs_short
		name = "Bangs, Short"
		icon_state = "hair_bangs_short"
		gender = FEMALE
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
		gender = FEMALE
		length = 3
		chatname = "messy locks"

	beehive
		name = "Beehive"
		icon_state = "hair_beehive"
		gender = FEMALE
		length = 2
		chatname = "beehive hairdo"

	beehive2
		name = "Beehive 2"
		icon_state = "hair_beehive2"
		gender = FEMALE
		length = 2
		chatname = "beehive hairdo"

	beehive3
		name = "Beehive 3"
		icon_state = "hair_beehive3"
		gender = FEMALE
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

	big_bow
		name = "Big Bow"
		icon_state = "hair_big_bow"
		length = 4
		chatname = "hair rings"

	bob
		name = "Bob"
		icon_state = "hair_bob"
		gender = FEMALE
		species_allowed = list("Human","Unathi")
		chatname = "short hair"

	bob_chin
		name = "Bob, Chin Length"
		icon_state = "hair_bob_chin"
		gender = FEMALE
		chatname = "short hair"

	bob_kusanagi
		name = "Bob, Kusanagi"
		icon_state = "hair_bob_kusanagi"
		chatname = "short hair"

	bob_shoulder
		name = "Bob, Shoulder Length"
		icon_state = "hair_bob_shoulder"
		gender = FEMALE
		chatname = "short hair"

	bobcurl
		name = "Bobcurl"
		icon_state = "hair_bobcurl"
		gender = FEMALE
		species_allowed = list("Human","Unathi")
		chatname = "curls"

	bobcurl2
		name = "Bobcurl 2"
		icon_state = "hair_bobcurl2"
		gender = FEMALE
		chatname = "curls"

	bowl
		name = "Bowl"
		icon_state = "hair_bowlcut"
		gender = MALE
		chatname = "bowl cut"

	bowlcut2
		name = "Bowl 2"
		icon_state = "hair_bowlcut2"
		gender = MALE
		chatname = "bowl cut"

	bowlcut_birdnest
		name = "Bowl, Birdnest"
		icon_state = "hair_bowlcut_birdnest"
		gender = MALE
		length = 4
		chatname = "bowl cut"

	braid_floorlength
		name = "Braid, Floorlength"
		icon_state = "hair_braid_floorlength"
		gender = FEMALE
		length = 4
		chatname = "braid"

	braid_grande
		name = "Braid, Grande"
		icon_state = "hair_braid_grande"
		gender = FEMALE
		length = 3
		chatname = "braid"

	braid_medium
		name = "Braid, Medium"
		icon_state = "hair_braid_medium"
		gender = FEMALE
		length = 2
		chatname = "braid"

	braided
		name = "Braided"
		icon_state = "hair_braided"
		gender = FEMALE
		length = 3
		chatname = "braids"

	braided_alt
		name = "Braided, Alt"
		icon_state = "hair_braided_alt"
		gender = FEMALE
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
		gender = FEMALE
		length = 2
		chatname = "hair bun"

	bun_casual
		name = "Bun, Casual"
		icon_state = "hair_bun_casual"
		gender = FEMALE
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
		gender = FEMALE
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
		gender = MALE
		length = 2
		chatname = "manbun"

	bun_odango
		name = "Bun, Odango"
		icon_state = "hair_bun_odango"
		gender = FEMALE
		length = 2
		chatname = "hair buns"

	bun_odango2
		name = "Bun, Odango 2"
		icon_state = "hair_bun_odango2"
		gender = FEMALE
		length = 2
		chatname = "hair buns"

	bun_odango3
		name = "Bun, Odango 3"
		icon_state = "hair_bun_odango3"
		gender = FEMALE
		length = 3
		chatname = "hair buns"

	bun_odango4
		name = "Bun, Odango 4"
		icon_state = "hair_bun_odango4"
		gender = FEMALE
		length = 3
		chatname = "hair buns"

	bun_overeye
		name = "Bun, Overeye"
		icon_state = "hair_bun_overeye"
		gender = FEMALE
		length = 2
		chatname = "hair bun"

	bun_short
		name = "Bun, Short"
		icon_state = "hair_bun_short"
		length = 2
		chatname = "hair bun"

	bun_tight
		name = "Bun, Tight"
		icon_state = "hair_bun_tight"
		gender = FEMALE
		length = 2
		chatname = "hair bun"

	bun_topknot
		name = "Bun, Topknot"
		icon_state = "hair_bun_topknot"
		gender = MALE
		length = 2
		chatname = "hair bun"

	buzzcut
		name = "Buzzcut"
		icon_state = "hair_buzzcut"
		gender = MALE
		species_allowed = list("Human","Unathi")
		chatname = "unbuzzed hair"	//grabbing the grabbable hair

	buzzcut2
		name = "Buzzcut 2"
		icon_state = "hair_buzzcut2"
		gender = MALE
		species_allowed = list("Human","Unathi")
		chatname = "unbuzzed hair"

	chrono
		name = "Chrono"
		icon_state = "hair_chrono"
		gender = MALE
		length = 4
		chatname = "spiked hair"

	cia
		name = "CIA"
		icon_state = "hair_cia"
		gender = MALE
		chatname = "short hair"

	coffeehouse
		name = "Coffee House Cut"
		icon_state = "hair_coffeehouse"
		gender = MALE
		chatname = "coffee house haircut"

	coffeehouse_shave
		name = "Coffee House Shave"
		icon_state = "hair_coffeehouse_shave"
		gender = MALE
		chatname = "coffee house haircut"

	combover
		name = "Combover"
		icon_state = "hair_combover"
		gender = MALE
		chatname = "groomed hair"

	country
		name = "Country"
		icon_state = "hair_country"
		gender = FEMALE
		chatname = "ponytail"

	crew
		name = "Crewcut"
		icon_state = "hair_crewcut"
		gender = MALE
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

	drills_celes
		name = "Drills, Celes"
		icon_state = "hair_drills_celes"
		length = 3
		chatname = "hair drills"

	drills_drillruru
		name = "Drills, Drillruru"
		icon_state = "hair_drills_drillruru"
		gender = FEMALE
		length = 2
		chatname = "hair drills"

	drills_drillruru_long
		name = "Drills, Drillruru Long"
		icon_state = "hair_drills_drillruru_long"
		gender = FEMALE
		length = 3
		chatname = "hair drills"

	duelist
		name = "Duelist"
		icon_state = "hair_duelist"
		length = 4
		chatname = "spiked hair"

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
		gender = FEMALE
		length = 3
		chatname = "long fringe"

	fade_high
		name = "Fade, High"
		icon_state = "hair_fade_high"
		gender = MALE
		chatname = "unshaved hair"

	fade_low
		name = "Fade, Low"
		icon_state = "hair_fade_low"
		gender = MALE
		chatname = "short hair"

	fade_medium
		name = "Fade, Medium"
		icon_state = "hair_fade_medium"
		gender = MALE
		chatname = "unshaved hair"

	fade_none
		name = "Fade, None"
		icon_state = "hair_fade_none"
		gender = MALE
		chatname = "short hair"

	familyman
		name = "Family Man, The"
		icon_state = "hair_familyman"
		gender = MALE
		chatname = "homely hairdo"
		length = 2

	father
		name = "Father"
		icon_state = "hair_father"
		gender = MALE
		chatname = "short hair"

	feather
		name = "Feather"
		icon_state = "hair_feather"
		length = 2
		chatname = "short hair"

	flat_top
		name = "Flat Top"
		icon_state = "hair_flattop"
		gender = MALE
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
		gender = FEMALE
		length = 2
		chatname = "gelled-back hair"

	gentle
		name = "Gentle"
		icon_state = "hair_gentle"
		gender = FEMALE
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
		gender = FEMALE
		length = 3
		chatname = "long hair"

	himecut_alt
		name = "Hime Cut, Alt"
		icon_state = "hair_himecut_alt"
		gender = FEMALE
		length = 3
		chatname = "long hair"

	himecut_alt2
		name = "Hime Cut, Alt 2"
		icon_state = "hair_himecut_alt2"
		gender = FEMALE
		length = 3
		chatname = "long hair"

	himecut_long
		name = "Hime Cut, Long"
		icon_state = "hair_himecut_long"
		gender = FEMALE
		length = 3
		chatname = "long hair"

	himecut_long_ponytail
		name = "Hime Cut, Long Ponytail"
		icon_state = "hair_himecut_long_ponytail"
		gender = FEMALE
		length = 3
		chatname = "long hair"

	himecut_ponytail
		name = "Hime Cut, Ponytail"
		icon_state = "hair_himecut_ponytail"
		gender = FEMALE
		length = 3
		chatname = "long hair"

	himecut_ponytail_up
		name = "Hime Cut, Ponytail Up"
		icon_state = "hair_himecut_ponytail_up"
		gender = FEMALE
		length = 2
		chatname = "long hair"

	himecut_short
		name = "Hime Cut, Short"
		icon_state = "hair_himecut_short"
		gender = FEMALE
		chatname = "short hair"

	hitop
		name = "Hitop"
		icon_state = "hair_hitop"
		gender = MALE
		chatname = "hitop"

	jade
		name = "Jade"
		icon_state = "hair_jade"
		length = 2
		chatname = "messy hair"

	jensen
		name = "Jensen Hair"  // Removing Videogame References
		icon_state = "hair_jensen"
		gender = MALE
		chatname = "short hair"

	joestar
		name = "Joestar"
		icon_state = "hair_joestar"
		gender = MALE
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
		chatname = "messy hair"

	messy2
		name = "Messy 2"
		icon_state = "hair_messy2"
		chatname = "messy hair"

	messy3
		name = "Messy 3"
		icon_state = "hair_messy3"
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
		gender = MALE
		chatname = "mohawk"

	mohawk_naomi
		name = "Mohawk, Naomi"
		icon_state = "hair_mohawk_naomi" //slightly longer on the side icons, in case you were wondering
		chatname = "mohawk"

	mohawk_reverse
		name = "Mohawk, Reverse"
		icon_state = "hair_mohawk_reverse"
		gender = MALE
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
		gender = MALE
		chatname = "short hair"

	neat
		name = "Neat"
		icon_state = "hair_neat"
		gender = FEMALE
		chatname = "groomed hair"

	neatlong
		name = "Neat (Long)"
		icon_state = "hair_neatlong"
		gender = FEMALE
		length = 2
		chatname = "long hair"

	newyou
		name = "New You"
		icon_state = "hair_newyou"
		gender = FEMALE
		length = 3
		chatname = "ponytail"

	nia
		name = "Nia"
		icon_state = "hair_nia"
		gender = FEMALE
		length = 3
		chatname = "long hair"

	ombre
		name = "Ombre"
		icon_state = "hair_ombre"
		gender = FEMALE
		length = 2
		chatname = "short hair"

	oneshoulder
		name = "One Shoulder"
		icon_state = "hair_oneshoulder"
		gender = FEMALE
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
		gender = FEMALE
		length = 2
		chatname = "pigtails"

	pigtails_low
		name = "Pigtails, Low"
		icon_state = "hair_pigtails_low"
		gender = FEMALE
		length = 2
		chatname = "pigtails"

	pigtails_nitori
		name = "Pigtails, Nitori"
		icon_state = "hair_pigtails_nitori"
		gender = FEMALE
		length = 2
		chatname = "pigtails"

	pigtails_twintail
		name = "Pigtails, Twintail"
		icon_state = "hair_pigtails_twintail"
		gender = FEMALE
		length = 2
		chatname = "pigtails"

	pigtails_twintail_ombre
		name = "Pigtails, Twintail Ombre"
		icon_state = "hair_pigtails_twintail_ombre"
		gender = FEMALE
		length = 2
		chatname = "pigtails"

	pigtails_twintail_ombre_alt
		name = "Pigtails, Twintail Ombre Alt"
		icon_state = "hair_pigtails_twintail_ombre_alt"
		gender = FEMALE
		length = 3
		chatname = "pigtails"

	pompadour
		name = "Pompadour"
		icon_state = "hair_pompadour"
		gender = MALE
		length = 3
		chatname = "pompadour"

	pompadour_dandy
		name = "Pompadour, Dandy"
		icon_state = "hair_pompadour_dandy"
		gender = MALE
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
		gender = FEMALE
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
		gender = FEMALE
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
		gender = FEMALE
		length = 2
		chatname = "ponytail"

	ponytail7
		name = "Ponytail 7"
		icon_state = "hair_ponytail7"
		gender = FEMALE
		length = 2
		chatname = "ponytail"

	ponytail8
		name = "Ponytail 8"
		icon_state = "hair_ponytail8"
		gender = FEMALE
		length = 2
		chatname = "ponytail"

	ponytail9
		name = "Ponytail 9"
		icon_state = "hair_ponytail9"
		length = 2
		chatname = "ponytail"

	ponytail_fringetail
		name = "Ponytail, Fringetail"
		icon_state = "hair_ponytail_fringetail"
		gender = FEMALE
		length = 2
		chatname = "ponytail"

	ponytail_high
		name = "Ponytail, High"
		icon_state = "hair_ponytail_high"
		gender = FEMALE
		length = 2
		chatname = "ponytail"

	ponytail_side
		name = "Ponytail, Side"
		icon_state = "hair_ponytail_side"
		gender = FEMALE
		length = 2
		chatname = "ponytail"

	ponytail_side2
		name = "Ponytail, Side 2"
		icon_state = "hair_ponytail_side2"
		gender = FEMALE
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
		gender = FEMALE
		length = 4
		chatname = "ponytail"

	ponytail_wisp
		name = "Ponytail, Wisp"
		icon_state = "hair_ponytail_wisp"
		gender = FEMALE
		length = 3
		chatname = "ponytail"

	ponytail_zieglertail
		name = "Ponytail, Zieglertail"
		icon_state = "hair_ponytail_ziegler"
		gender = FEMALE
		length = 2
		chatname = "ponytail"

	poofy
		name = "Poofy"
		icon_state = "hair_poofy"
		gender = FEMALE
		length = 2
		chatname = "poofy hair"

	poofy2
		name = "Poofy 2"
		icon_state = "hair_poofy2"
		gender = FEMALE
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

	punk_chelseafringe_bighawk
		name = "Punk Shave, Chelsea Fringe Big Hawk"
		icon_state = "hair_punk_chelseafringe_bighawk"
		chatname = "mohawk"

	punk_chelseafringe_smallhawk
		name = "Punk Shave, Chelsea Fringe Small Hawk"
		icon_state = "hair_punk_chelseafringe_smallhawk"
		chatname = "mohawk"

	punk_chelseafringe_ponytail
		name = "Punk Shave, Chelsea Fringe Ponytail"
		icon_state = "hair_punk_chelseafringe_ponytail"
		chatname = "ponytail"

	punk_halfshaved
		name = "Punk Shave, Half-Shaved"
		icon_state = "hair_punk_halfshaved"
		chatname = "unshaved hair"		// grabbing the parts that can be grabbed

	punk_halfshaved_bun
		name = "Punk Shave, Half-Shaved Bun"
		icon_state = "hair_punk_halfshaved_bun"
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
		gender = MALE
		length = 2
		chatname = "quiff"

	ronin
		name = "Ronin"
		icon_state = "hair_ronin"
		gender = MALE
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
		gender = FEMALE
		chatname = "short hair"

	shaved
		name = "Shaved"
		icon_state = "hair_shaved"
		gender = MALE
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
		species_allowed = list("Human","Unathi")
		chatname = "mighty spikes"

	straightlong
		name = "Straight Long"
		icon_state = "hair_straightlong"
		length = 3
		chatname = "long hair"

	thinning
		name = "Thinning"
		icon_state = "hair_thinning"
		gender = MALE
		chatname = "short hair"

	thinningback
		name = "Thinning Back"
		icon_state = "hair_thinningback"
		gender = MALE
		chatname = "short hair"

	thinningfront
		name = "Thinning Front"
		icon_state = "hair_thinningfront"
		gender = MALE
		chatname = "short hair"

	tresshoulder
		name = "Tress Shoulder"
		icon_state = "hair_tressshoulder"
		gender = FEMALE
		length = 2
		chatname = "curls"

	trimmed
		name = "Trimmed"
		icon_state = "hair_trimmed"
		gender = MALE
		chatname = "trimmed hair"

	trimmedflat
		name = "Trimmed Flat Top"
		icon_state = "hair_trimmedflat"
		gender = MALE
		chatname = "trimmed hair"

	twincurls
		name = "Twincurls"
		icon_state = "hair_twincurls"
		gender = FEMALE
		length = 2
		chatname = "curls"

	twincurls2
		name = "Twincurls 2"
		icon_state = "hair_twincurls2"
		gender = FEMALE
		length = 2
		chatname = "curls"

	undercut
		name = "Undercut"
		icon_state = "hair_undercut"
		gender = MALE
		chatname = "unshaved hair"

	undercut2
		name = "Undercut 2"
		icon_state = "hair_undercut2"
		gender = MALE
		chatname = "undercut"

	undercut3
		chatname = "unshaved hair"
		name = "Undercut 3"
		icon_state = "hair_undercut3"
		gender = MALE
		chatname = "unshaved hair"

	undercut4
		name = "Undercut 4"
		icon_state = "hair_undercut4"
		gender = MALE
		chatname = "unshaved hair"

	undercut5
		name = "Undercut 5"
		icon_state = "hair_undercut5"
		gender = MALE
		chatname = "unshaved hair"

	unkept
		name = "Unkept"
		icon_state = "hair_unkept"
		length = 3
		chatname = "unkept hairdo"

	updo
		name = "Updo"
		icon_state = "hair_updo"
		gender = FEMALE
		length = 2
		chatname = "updo"

	vegeta
		name = "Vegeta"
		icon_state = "hair_vegeta"
		gender = MALE
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
		gender = FEMALE
		chatname = "short hair"

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
			gender = FEMALE
			length = 3
			chatname = "long hair"

		nia3
			name = "Nia 3"
			icon_state = "hair_nia3"
			gender = FEMALE
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
		species_allowed = list("Human","Unathi","Tajara","Skrell","Vox")

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
		species_allowed = list("Human","Unathi")

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

	brokenman
		icon = 'icons/mob/human_face/facial_hair_multiply.dmi'
		name = "Broken Man"
		icon_state = "facial_brokenman"
		icon_blend_mode = ICON_MULTIPLY

		chinstrap2
			name = "Chinstrap, Alt"
			icon_state = "facial_chinstrap_ii"

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
		species_allowed = list("Unathi")
		length = 0
		chatname = "frills"

		una_bighorns
			name = "Unathi Big Horns"
			icon_state = "unathi_bighorn"
			length = 5
			chatname = "horns"

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

//skrell tentacles

	skr_tentacle_m
		icon = 'icons/mob/human_face/skrell_hair.dmi'
		name = "Skrell Short Tentacles"
		icon_state = "skrell_hair_m"
		species_allowed = list("Skrell")
		length = 6
		chatname = "Short Tentacles"

		skr_tentacle_f
			name = "Skrell Average Tentacles"
			icon_state = "skrell_hair_f"
			length = 6
			chatname = "Average Tentacles"

		skr_tentacle_short
			name = "Skrell Very Short Tentacles"
			icon_state = "veryshort_s"
			length = 6
			chatname = "Short Tentacles"

		skr_tentacle_long
			name = "Skrell Very Long Tentacles"
			icon_state = "verylong_s"
			length = 6
			chatname = "Very Long Tentacles"


//tajaran hair

	taj_ears
		icon = 'icons/mob/human_face/tajara_hair.dmi'
		name = "Tajaran Ears"
		icon_state = "ears_plain"
		species_allowed = list("Tajara")

		taj_ears_bangs
			name = "Tajara Bangs"
			icon_state = "hair_bangs"
			chatname = "bangs"

		taj_ears_bob
			name = "Tajara Bob"
			icon_state = "hair_bob"
			chatname = "groomed short mane"

		taj_ears_braid
			name = "Tajara Braid"
			icon_state = "hair_braid"
			chatname = "braid"

		taj_ears_clean
			name = "Tajara Clean"
			icon_state = "hair_clean"
			chatname = "short mane"

		taj_ears_curls
			name = "Tajara Curly"
			icon_state = "hair_curly"
			chatname = "curly mane"

		taj_ears_fingercurl
			name = "Tajara Finger Curls"
			icon_state = "hair_fingerwave"
			chatname = "curls"

		taj_ears_pompadour
			name = "Tajara Greaser"
			icon_state = "hair_greaser"
			chatname = "pompadour"

		taj_ears_housewife
			name = "Tajara Housewife"
			icon_state = "hair_housewife"
			chatname = "long mane"

		taj_ears_long
			name = "Tajara Long"
			icon_state = "hair_long"
			chatname = "long mane"

		taj_ears_messy
			name = "Tajara Messy"
			icon_state = "hair_messy"
			chatname = "messy mane"

		taj_ears_mohawk
			name = "Tajara Mohawk"
			icon_state = "hair_mohawk"
			chatname = "mohawk"

		taj_ears_plait
			name = "Tajara Plait"
			icon_state = "hair_plait"
			chatname = "braid"

		taj_ears_rattail
			name = "Tajara Rat Tail"
			icon_state = "hair_rattail"
			chatname = "thin ponytail"

		taj_ears_shaggy
			name = "Tajara Shaggy"
			icon_state = "hair_shaggy"
			chatname = "messy mane"

		taj_ears_straight
			name = "Tajara Straight"
			icon_state = "hair_straight"
			chatname = "short mane"

		taj_ears_spiky
			name = "Tajara Spiky"
			icon_state = "hair_spiky"
			chatname = "spiky mane"

		taj_ears_victory
			name = "Tajara Victory Curls"
			icon_state = "hair_victory"
			chatname = "curls"

//vox hair

	vox_quills_kingly
		icon = 'icons/mob/human_face/vox_hair.dmi'
		name = "Kingly Vox Quills"
		icon_state = "vox_kingly"
		species_allowed = list("Vox")
		chatname = "quills"

		vox_braid_long
			name = "Vox Braid Long"
			icon_state = "vox_braid_long"
			chatname = "quills"

		vox_braid_short
			name = "Vox Braid Short"
			icon_state = "vox_braid_short"
			chatname = "quills"

		vox_quills_short
			name = "Short Vox Quills"
			icon_state = "vox_shortquills"
			chatname = "quills"

		vox_quills_mohawk
			name = "Quill Mohawk"
			icon_state = "vox_mohawk"
			chatname = "quills"

		vox_stubble
			name = "Vox Stubble"
			icon_state = "vox_stubble"
			chatname = "quills"

//vaurca antennae

	vaurca_classic
		icon = 'icons/mob/human_face/vaurca_hair.dmi'
		name = "Classic Antennae"
		icon_state = "vaurca_classic"
		species_allowed = list("Vaurca")
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

/datum/sprite_accessory/facial_hair
	taj_goatee
		icon = 'icons/mob/human_face/tajara_facial_hair.dmi'
		name = "Tajara Goatee"
		icon_state = "facial_goatee"
		species_allowed = list("Tajara")

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

//unathi horn beards and the like

	una_aquaticfrill
		icon = 'icons/mob/human_face/unathi_hair.dmi'
		name = "Unathi Aquatic Frills"
		icon_state = "facial_aquaticfrills"
		species_allowed = list("Unathi")
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

//ipc screens

	ipc_screen_blank
		icon = 'icons/mob/human_face/ipc_screens.dmi'
		name = "blank IPC screen"
		icon_state = "ipc_blank"
		species_allowed = list("Machine")
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

	diona_eye
		icon = 'icons/mob/human_face/dionae_hair.dmi'
		name = "Mono Eye"
		icon_state = "monoeye"
		species_allowed = list("Diona")
		gender = NEUTER
		do_colouration = FALSE

		diona_eye_trioptics
			name = "Trioptics"
			icon_state = "trioptics"

		diona_eye_lopsided
			name = "Lopsided Eyes"
			icon_state = "lopsided"

		diona_eye_helmethead
			name = "Helmethead"
			icon_state = "helmethead"

		diona_eye_eyestalk
			name = "Eyestalk"
			icon_state = "eyestalk"

/*
////////////////////////////
/  =--------------------=  /
/  ==  Body Markings   ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/marking
	icon = 'icons/mob/human_races/markings.dmi'
	do_colouration = 1 //Almost all of them have it, COLOR_ADD

	species_allowed = list()

	var/body_parts = list() //A list of bodyparts this covers, TODO: port defines for organs someday
	var/is_genetic = TRUE	// If TRUE, the marking is considered genetic and is embedded into DNA.
	var/is_painted = FALSE	// If TRUE, the marking can be put on prosthetics/robolimbs.

	tiger_stripes
		name = "Tiger Stripes (Tajara)"
		icon_state = "tiger"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_GROIN)
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	taj_paw_socks
		name = "Socks Coloration (Tajara)"
		icon_state = "taj_pawsocks"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	una_paw_socks
		name = "Socks Coloration (Unathi)"
		icon_state = "una_pawsocks"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
		species_allowed = list("Unathi")

	belly_hands_feet
		name = "Hands,Feet,Belly Color (Minor)"
		icon_state = "bellyhandsfeetsmall"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	patches
		name = "Color Patches"
		icon_state = "patches"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN)
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	patchesface
		name = "Color Patches (Face)"
		icon_state = "patchesface"
		body_parts = list(BP_HEAD)
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	bands
		name = "Color Bands"
		icon_state = "bands"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN)
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara", "Unathi")

	bandsface
		name = "Color Bands (Face)"
		icon_state = "bandsface"
		body_parts = list(BP_HEAD)
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara", "Unathi")

	tigerhead
		name = "Tiger Stripes (Head, Minor)"
		icon_state = "tigerhead"
		body_parts = list(BP_HEAD)
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	tigerface
		name = "Tiger Stripes (Head, Major)"
		icon_state = "tigerface"
		body_parts = list(BP_HEAD)
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	backstripe
		name = "Back Stripe"
		icon_state = "backstripe"
		body_parts = list(BP_CHEST)
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara", "Unathi")

	taj_nose
		name = "Nose Color"
		icon_state = "taj_nose"
		body_parts = list(BP_HEAD)
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	taj_muzzle
		name = "Muzzle Color"
		icon_state = "taj_muzzle"
		body_parts = list(BP_HEAD)
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	taj_face
		name = "Cheeks Color"
		icon_state = "taj_face"
		body_parts = list(BP_HEAD)
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	taj_all
		name = "All Tajara Head"
		icon_state = "taj_all"
		body_parts = list(BP_HEAD)
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	una_face
		name = "Face Color"
		icon_state = "una_face"
		body_parts = list(BP_HEAD)
		species_allowed = list("Unathi")

	una_facelow
		name = "Face Color Low"
		icon_state = "una_facelow"
		body_parts = list(BP_HEAD)
		species_allowed = list("Unathi")

	una_scutes
		name = "Scutes"
		icon_state = "una_scutes"
		body_parts = list(BP_CHEST)
		species_allowed = list("Unathi")

	una_maswaist
		name = "Masculine Waist (For Females)"
		icon_state = "una_maswaist"
		body_parts = list(BP_CHEST)
		species_allowed = list("Unathi")

	una_clawshand
		name = "Claws (Hands)"
		icon_state = "una_claws"
		body_parts = list(BP_L_HAND,BP_R_HAND)
		species_allowed = list("Unathi")

	una_clawsfoot
		name = "Claws (Feet)"
		icon_state = "una_claws"
		body_parts = list(BP_L_FOOT,BP_R_FOOT)
		species_allowed = list("Unathi")

	spelunker
		name = "Spelunker"
		icon_state = "spelunker"
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_GROIN,BP_HEAD)
		species_allowed = list("Vaurca")

	delver
		name = "Delver"
		icon_state = "delver"
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_GROIN,BP_HEAD)
		species_allowed = list("Vaurca")

	skr_tears
		name = "Tear Stains"
		icon_state = "skr_tears"
		body_parts = list(BP_HEAD)
		species_allowed = list("Skrell")
		do_colouration = 0

	skr_arms
		name = "Skrell Arms"
		icon_state = "skrell_arms"
		body_parts = list(BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
		species_allowed = list("Skrell")

	diona_leaves
		name = "Diona Leaves"
		icon = 'icons/mob/human_races/markings_diona.dmi'
		icon_state = "diona_leaves"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_GROIN,BP_HEAD)
		species_allowed = list("Diona")

	bishop_lights
		name = "Lights Colour"
		icon = 'icons/mob/human_races/markings_bishop.dmi'
		icon_state = "bishop_lights"
		icon_blend_mode = ICON_MULTIPLY
		is_painted = TRUE
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_HEAD)
		species_allowed = list("Bishop Accessory Frame")

		bishop_mask
			name = "Face Mask"
			icon_state = "bishop_mask"
			do_colouration = FALSE
			body_parts = list(BP_HEAD)

			bishop_triangular_mask
				name = "Triangular Face Mask"
				icon_state = "bishop_triangular_mask"

/*
	zenghu
		icon = 'icons/mob/human_races/markings_zenghu.dmi'
		icon_state = "outer"
		icon_blend_mode = ICON_MULTIPLY
		name = "Outer Finish"
		body_parts = list(BP_HEAD)
		species_allowed = list("Zeng-Hu Mobility Frame")
		is_painted = TRUE

		inner
			name = "Inner Finish"
			icon_state = "inner"
			body_parts = list(BP_L_FOOT, BP_R_FOOT, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG)

			l_foot
				name = "Inner Finish (Left Leg)"
				body_parts = list(BP_L_FOOT, BP_L_LEG)

			r_foot
				name = "Inner Finish (Right Leg)"
				body_parts = list(BP_R_FOOT, BP_R_LEG)

			l_hand
				name = "Inner Finish (Left Arm)"
				body_parts = list(BP_L_HAND, BP_L_ARM)

			r_hand
				name = "Inner Finish (Right Arm)"
				body_parts = list(BP_R_HAND, BP_R_ARM)

		crest_leser
			name = "Head Coloration (Lesser)"
			icon_state = "lesser"

		crest_greater
			name = "Head Coloration (Greater)"
			icon_state = "greater"
*/
