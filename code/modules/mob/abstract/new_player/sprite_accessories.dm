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

/datum/sprite_accessory/hair/bald
	name = "Bald"   // try to capitalize the names please~
	icon_state = "bald" // you do not need to define _s or _l sub-states, game automatically does this for you
	species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie,/datum/species/unathi,/datum/species/zombie/unathi,/datum/species/diona, /datum/species/diona/coeu, /datum/species/machine, /datum/species/machine/industrial, /datum/species/machine/industrial/hephaestus, /datum/species/machine/industrial/xion, /datum/species/machine/zenghu, /datum/species/machine/bishop)
	length = 0
	chatname = "bald head" //aim to keep these lowercase so they fit into the hair tugging message

/datum/sprite_accessory/hair/eighties
	name = "80's"
	icon_state = "hair_80s"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/eighties_ponytail
	name = "80's Ponytail"
	icon_state = "hair_80s_ponytail"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/eighties_ponytail_alt
	name = "80's Ponytail Alt"
	icon_state = "hair_80s_ponytail_alt"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/afro
	name = "Afro"
	icon_state = "hair_afro"
	length = 3
	chatname = "afro"

/datum/sprite_accessory/hair/afro2
	name = "Afro 2"
	icon_state = "hair_afro2"
	length = 3
	chatname = "afro"

/datum/sprite_accessory/hair/afro3
	name = "Afro, Big"
	icon_state = "hair_afrobig"
	length = 3
	chatname = "big afro"

/datum/sprite_accessory/hair/amanita
	name = "Amanita"
	icon_state = "hair_amanita"
	chatname = "short curls"

/datum/sprite_accessory/hair/amanita_long
	name = "Amanita, Long"
	icon_state = "hair_amanita_long"
	length = 3
	chatname = "long curls"

/datum/sprite_accessory/hair/amanita_long_alt
	name = "Amanita, Long Alt"
	icon_state = "hair_amanita_long_alt"
	length = 3
	chatname = "long curls"

/datum/sprite_accessory/hair/amazon
	name = "Amazon"
	icon_state = "hair_amazon"
	length = 2
	chatname = "long hair"

/datum/sprite_accessory/hair/averagejoe
	name = "Average Joe"
	icon_state = "hair_averagejoe"
	chatname = "short hair"

/datum/sprite_accessory/hair/baldingfade
	name = "Balding Fade"
	icon_state = "hair_baldingfade"
	length = 0
	chatname = "bald head"

/datum/sprite_accessory/hair/baldinghair
	name = "Balding Hair"
	icon_state = "hair_baldinghair" //hair_e
	length = 0
	chatname = "balding hair"

/datum/sprite_accessory/hair/bangs
	name = "Bangs"
	icon_state = "hair_bangs"
	length = 2
	chatname = "fringe"

/datum/sprite_accessory/hair/bangs_short
	name = "Bangs, Short"
	icon_state = "hair_bangs_short"
	chatname = "fringe"

/datum/sprite_accessory/hair/bangs_veryshort
	name = "Bangs, Very Short"
	icon_state = "hair_bangs_veryshort"
	chatname = "fringe"

/datum/sprite_accessory/hair/bedhead
	name = "Bedhead"
	icon_state = "hair_bedhead"
	chatname = "messy locks"

/datum/sprite_accessory/hair/bedhead2
	name = "Bedhead 2"
	icon_state = "hair_bedhead2"
	chatname = "messy locks"

/datum/sprite_accessory/hair/bedhead3
	name = "Bedhead 3"
	icon_state = "hair_bedhead3"
	chatname = "wavy hair"

/datum/sprite_accessory/hair/bedhead4
	name = "Bedhead 4"
	icon_state = "hair_bedhead4"
	length = 4
	chatname = "messy locks"

/datum/sprite_accessory/hair/beehive
	name = "Beehive"
	icon_state = "hair_beehive"
	length = 2
	chatname = "beehive hairdo"

/datum/sprite_accessory/hair/beehive2
	name = "Beehive 2"
	icon_state = "hair_beehive2"
	length = 2
	chatname = "beehive hairdo"

/datum/sprite_accessory/hair/beehive3
	name = "Beehive 3"
	icon_state = "hair_beehive3"
	length = 2
	chatname = "beehive hairdo"

/datum/sprite_accessory/hair/belenko
	name = "Belenko"
	icon_state = "hair_belenko"
	length = 2
	chatname = "messy hair"

/datum/sprite_accessory/hair/belenko_tied
	name = "Belenko (Tied)"
	icon_state = "hair_belenkotied"
	length = 2
	chatname = "messy ponytail"

/datum/sprite_accessory/hair/bob
	name = "Bob"
	icon_state = "hair_bob"
	species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie)
	chatname = "short hair"

/datum/sprite_accessory/hair/bob_chin
	name = "Bob, Chin Length"
	icon_state = "hair_bob_chin"
	chatname = "short hair"

/datum/sprite_accessory/hair/bob_kusanagi
	name = "Bob, Kusanagi"
	icon_state = "hair_bob_kusanagi"
	chatname = "short hair"

/datum/sprite_accessory/hair/bob_shoulder
	name = "Bob, Shoulder Length"
	icon_state = "hair_bob_shoulder"
	chatname = "short hair"

/datum/sprite_accessory/hair/bobcurl
	name = "Bobcurl"
	icon_state = "hair_bobcurl"
	species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie)
	chatname = "curls"

/datum/sprite_accessory/hair/bobcurl2
	name = "Bobcurl 2"
	icon_state = "hair_bobcurl2"
	chatname = "curls"

/datum/sprite_accessory/hair/bowl
	name = "Bowl"
	icon_state = "hair_bowlcut"
	chatname = "bowl cut"

/datum/sprite_accessory/hair/bowlcut2
	name = "Bowl 2"
	icon_state = "hair_bowlcut2"
	chatname = "bowl cut"

/datum/sprite_accessory/hair/bowlcut_birdnest
	name = "Bowl, Birdnest"
	icon_state = "hair_bowlcut_birdnest"
	length = 4
	chatname = "bowl cut"

/datum/sprite_accessory/hair/braid_grande
	name = "Braid, Grande"
	icon_state = "hair_braid_grande"
	length = 3
	chatname = "braid"

/datum/sprite_accessory/hair/braid_medium
	name = "Braid, Medium"
	icon_state = "hair_braid_medium"
	length = 2
	chatname = "braid"

/datum/sprite_accessory/hair/braided
	name = "Braided"
	icon_state = "hair_braided"
	length = 3
	chatname = "braids"

/datum/sprite_accessory/hair/braided_alt
	name = "Braided, Alt"
	icon_state = "hair_braided_alt"
	length = 3
	chatname = "braids"

/datum/sprite_accessory/hair/braided_hipster
	name = "Braided, Hipster"
	icon_state = "hair_braided_hipster"
	length = 3
	chatname = "braids"

/datum/sprite_accessory/hair/bun
	name = "Bun"
	icon_state = "hair_bun"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/bun_casual
	name = "Bun, Casual"
	icon_state = "hair_bun_casual"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/bun_donut
	name = "Bun, Donut"
	icon_state = "hair_bun_donut"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/bun_double
	name = "Bun, Double"
	icon_state = "hair_bun_double"
	length = 3
	chatname = "hair buns"

/datum/sprite_accessory/hair/bun_low
	name = "Bun, Low"
	icon_state = "hair_bun_low"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/bun_manbun
	name = "Bun, Manbun"
	icon_state = "hair_bun_manbun"
	length = 2
	chatname = "manbun"

/datum/sprite_accessory/hair/bun_odango
	name = "Bun, Odango"
	icon_state = "hair_bun_odango"
	length = 2
	chatname = "hair buns"

/datum/sprite_accessory/hair/bun_odango2
	name = "Bun, Odango 2"
	icon_state = "hair_bun_odango2"
	length = 2
	chatname = "hair buns"

/datum/sprite_accessory/hair/bun_odango3
	name = "Bun, Odango 3"
	icon_state = "hair_bun_odango3"
	length = 3
	chatname = "hair buns"

/datum/sprite_accessory/hair/bun_overeye
	name = "Bun, Overeye"
	icon_state = "hair_bun_overeye"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/bun_short
	name = "Bun, Short"
	icon_state = "hair_bun_short"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/bun_short2
	name = "Bun, Short 2"
	icon_state = "hair_bun_short2"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/bun_tight
	name = "Bun, Tight"
	icon_state = "hair_bun_tight"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/bun_topknot
	name = "Bun, Topknot"
	icon_state = "hair_bun_topknot"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/buzzcut
	name = "Buzzcut"
	icon_state = "hair_buzzcut"
	species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie)
	chatname = "unbuzzed hair"	//grabbing the grabbable hair

/datum/sprite_accessory/hair/buzzcut2
	name = "Buzzcut 2"
	icon_state = "hair_buzzcut2"
	species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie)
	chatname = "unbuzzed hair"

/datum/sprite_accessory/hair/chrono
	name = "Chrono"
	icon_state = "hair_chrono"
	length = 4
	chatname = "spiked hair"

/datum/sprite_accessory/hair/cia
	name = "CIA"
	icon_state = "hair_cia"
	chatname = "short hair"

/datum/sprite_accessory/hair/coffeehouse
	name = "Coffee House Cut"
	icon_state = "hair_coffeehouse"
	chatname = "coffee house haircut"

/datum/sprite_accessory/hair/coffeehouse_shave
	name = "Coffee House Shave"
	icon_state = "hair_coffeehouse_shave"
	chatname = "coffee house haircut"

/datum/sprite_accessory/hair/combover
	name = "Combover"
	icon_state = "hair_combover"
	chatname = "groomed hair"

/datum/sprite_accessory/hair/country
	name = "Country"
	icon_state = "hair_country"
	chatname = "ponytail"

/datum/sprite_accessory/hair/crew
	name = "Crewcut"
	icon_state = "hair_crewcut"
	chatname = "short hair"

/datum/sprite_accessory/hair/curls
	name = "Curls"
	icon_state = "hair_curls"
	chatname = "curls"

/datum/sprite_accessory/hair/cut
	name = "Cut Hair"
	icon_state = "hair_cuthair" //hair_c
	chatname = "short hair"

/datum/sprite_accessory/hair/devillock
	name = "Devil Lock"
	icon_state = "hair_devilock"
	chatname = "devil locks"

/datum/sprite_accessory/hair/dreadlocks
	name = "Dreadlocks"
	icon_state = "hair_dreads"
	length = 4
	chatname = "dreadlocks"

/datum/sprite_accessory/hair/drills_drillruru
	name = "Drills, Drillruru"
	icon_state = "hair_drills_drillruru"
	length = 2
	chatname = "hair drills"

/datum/sprite_accessory/hair/drills_drillruru_long
	name = "Drills, Drillruru Long"
	icon_state = "hair_drills_drillruru_long"
	length = 3
	chatname = "hair drills"

/datum/sprite_accessory/hair/emo
	name = "Emo"
	icon_state = "hair_emo"
	chatname = "fringe"

/datum/sprite_accessory/hair/emo_alt
	name = "Emo, Alt"
	icon_state = "hair_emo_alt"
	chatname = "fringe"

/datum/sprite_accessory/hair/emo_long
	name = "Emo, Long"
	icon_state = "hair_emo_long"
	chatname = "long fringe"
	length = 2

/datum/sprite_accessory/hair/emofringe
	name = "Emo Fringe"
	icon_state = "hair_emofringe"
	chatname = "fringe"

/datum/sprite_accessory/hair/emofringe_long
	name = "Emo Fringe Long"
	icon_state = "hair_emofringe_long"
	length = 3
	chatname = "long fringe"

/datum/sprite_accessory/hair/emofringe_longbun
	name = "Emo Fringe Long Bun"
	icon_state = "hair_emofringe_longbun"
	length = 3
	chatname = "hair bun"

/datum/sprite_accessory/hair/emorightfringe_long
	name = "Emo Right Fringe Long"
	icon_state = "hair_emofringe_long"
	length = 3
	chatname = "long fringe"

/datum/sprite_accessory/hair/emofringe_long_alt
	name = "Emo Fringe Long Alt"
	icon_state = "hair_emofringe_longalt"
	length = 3
	chatname = "long fringe"

/datum/sprite_accessory/hair/emorightfringe_long_alt
	name = "Emo Right Fringe Long Alt"
	icon_state = "hair_emorightfringe_longalt"
	length = 3
	chatname = "long fringe"

/datum/sprite_accessory/hair/fade_clean
	name = "Fade, Clean"
	icon_state = "hair_fade_clean"
	chatname = "short hair"

/datum/sprite_accessory/hair/fade_cleanlow
	name = "Fade, Clean Low"
	icon_state = "hair_fade_cleanlow"
	chatname = "short hair"

/datum/sprite_accessory/hair/fade_high
	name = "Fade, High"
	icon_state = "hair_fade_high"
	chatname = "unshaved hair"

/datum/sprite_accessory/hair/fade_low
	name = "Fade, Low"
	icon_state = "hair_fade_low"
	chatname = "short hair"

/datum/sprite_accessory/hair/fade_manbun
	name = "Fade, Manbun"
	icon_state = "hair_fade_manbun"
	chatname = "short hair"

/datum/sprite_accessory/hair/fade_medium
	name = "Fade, Medium"
	icon_state = "hair_fade_medium"
	chatname = "unshaved hair"

/datum/sprite_accessory/hair/fade_none
	name = "Fade, None"
	icon_state = "hair_fade_none"
	chatname = "short hair"

/datum/sprite_accessory/hair/father
	name = "Father"
	icon_state = "hair_father"
	chatname = "short hair"

/datum/sprite_accessory/hair/feather
	name = "Feather"
	icon_state = "hair_feather"
	length = 2
	chatname = "short hair"

/datum/sprite_accessory/hair/flat_top
	name = "Flat Top"
	icon_state = "hair_flattop"
	chatname = "flat top hair"

/datum/sprite_accessory/hair/flair
	name = "Flaired Hair"
	icon_state = "hair_flair"
	length = 2
	chatname = "flaired hair"

/datum/sprite_accessory/hair/flow
	name = "Flow Hair"
	icon_state = "hair_flow" //hair_f
	chatname = "short hair"

/datum/sprite_accessory/hair/gelled
	name = "Gelled Back"
	icon_state = "hair_gelled"
	length = 2
	chatname = "gelled-back hair"

/datum/sprite_accessory/hair/gentle
	name = "Gentle"
	icon_state = "hair_gentle"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/gentlealt
	name = "Gentle Alt"
	icon_state = "hair_gentlealt"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/gentle2
	name = "Gentle 2"
	icon_state = "hair_gentle2"
	length = 2
	chatname = "long hair"

/datum/sprite_accessory/hair/gentle2_alt
	name = "Gentle 2, Alt"
	icon_state = "hair_gentle2_alt"
	length = 2
	chatname = "long hair"

/datum/sprite_accessory/hair/gentle2_long
	name = "Gentle 2, Long"
	icon_state = "hair_gentle2_long"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/gentle2_longalt
	name = "Gentle 2, Long Alt"
	icon_state = "hair_gentle2_longalt"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/glossy
	name = "Glossy"
	icon_state = "hair_glossy"
	length = 2
	chatname = "short hair"

/datum/sprite_accessory/hair/halfbang
	name = "Half-banged Hair"
	icon_state = "hair_halfbang"
	chatname = "short hair"

/datum/sprite_accessory/hair/halfbangalt
	name = "Half-banged Hair, Alt"
	icon_state = "hair_halfbang_alt"
	chatname = "short hair"

/datum/sprite_accessory/hair/himecut
	name = "Hime Cut"
	icon_state = "hair_himecut"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/himecut_alt
	name = "Hime Cut, Alt"
	icon_state = "hair_himecut_alt"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/himecut_alt2
	name = "Hime Cut, Alt 2"
	icon_state = "hair_himecut_alt2"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/himecut_long
	name = "Hime Cut, Long"
	icon_state = "hair_himecut_long"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/himecut_long_ponytail
	name = "Hime Cut, Long Ponytail"
	icon_state = "hair_himecut_long_ponytail"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/himecut_ponytail
	name = "Hime Cut, Ponytail"
	icon_state = "hair_himecut_ponytail"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/himecut_ponytail_up
	name = "Hime Cut, Ponytail Up"
	icon_state = "hair_himecut_ponytail_up"
	length = 2
	chatname = "long hair"

/datum/sprite_accessory/hair/himecut_short
	name = "Hime Cut, Short"
	icon_state = "hair_himecut_short"
	chatname = "short hair"

/datum/sprite_accessory/hair/hitop
	name = "Hitop"
	icon_state = "hair_hitop"
	chatname = "hitop"

/datum/sprite_accessory/hair/jade
	name = "Jade"
	icon_state = "hair_jade"
	length = 2
	chatname = "messy hair"

/datum/sprite_accessory/hair/jensen
	name = "Jensen Hair"  // Removing Videogame References
	icon_state = "hair_jensen"
	chatname = "short hair"

/datum/sprite_accessory/hair/joestar
	name = "Joestar"
	icon_state = "hair_joestar"
	chatname = "short hair"

/datum/sprite_accessory/hair/longfringe
	name = "Long Fringe"
	icon_state = "hair_longfringe"
	length = 2
	chatname = "long hair"

/datum/sprite_accessory/hair/longfringe_longer
	name = "Long Fringe, Longer"
	icon_state = "hair_longfringe_longer"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/long
	name = "Long Hair"
	icon_state = "hair_long"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/long_alt
	name = "Long Hair, Alt"
	icon_state = "hair_long_alt"
	length = 2
	chatname = "long hair"

/datum/sprite_accessory/hair/long_shoulder
	name = "Long Hair, Shoulder-length"
	icon_state = "hair_long_shoulder" //hair_b
	length = 2
	chatname = "shoulder-length hair"

/datum/sprite_accessory/hair/long_verylong
	name = "Long Hair, Very Long"
	icon_state = "hair_long_verylong"
	length = 4
	chatname = "very long hair"

/datum/sprite_accessory/hair/marysue
	name = "Mary Sue"
	icon_state = "hair_marysue"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/messy
	name = "Messy"
	icon_state = "hair_messy"
	length = 2
	chatname = "messy hair"

/datum/sprite_accessory/hair/messy2
	name = "Messy 2"
	icon_state = "hair_messy2"
	length = 2
	chatname = "messy hair"

/datum/sprite_accessory/hair/messy3
	name = "Messy 3"
	icon_state = "hair_messy3"
	length = 2
	chatname = "messy hair"

/datum/sprite_accessory/hair/modern
	name = "Modern"
	icon_state = "hair_modern"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/mohawk
	name = "Mohawk"
	icon_state = "hair_mohawk"
	chatname = "mohawk"

/datum/sprite_accessory/hair/mohawk_big
	name = "Mohawk, Big"
	icon_state = "hair_mohawk_big"
	chatname = "mohawk"

/datum/sprite_accessory/hair/mohawk_high
	name = "Mohawk, High"
	icon_state = "hair_mohawk_high" //hair_d
	chatname = "mohawk"

/datum/sprite_accessory/hair/mohawk_hightight
	name = "Mohawk, High and Tight"
	icon_state = "hair_mohawk_hightight"
	chatname = "mohawk"

/datum/sprite_accessory/hair/mohawk_naomi
	name = "Mohawk, Naomi"
	icon_state = "hair_mohawk_naomi" //slightly longer on the side icons, in case you were wondering
	chatname = "mohawk"

/datum/sprite_accessory/hair/mohawk_reverse
	name = "Mohawk, Reverse"
	icon_state = "hair_mohawk_reverse"
	chatname = "short hair"

/datum/sprite_accessory/hair/mohawk_shaved
	name = "Mohawk, Shaved"
	icon_state = "hair_mohawk_shaved"
	chatname = "mohawk"

/datum/sprite_accessory/hair/mohawk_shavedlong
	name = "Mohawk, Shaved and Long"
	icon_state = "hair_mohawk_shavedlong"
	chatname = "mohawk"

/datum/sprite_accessory/hair/mohawk_shavedback
	name = "Mohawk, Shaved Back"
	icon_state = "hair_mohawk_shavedback"
	chatname = "mohawk"

/datum/sprite_accessory/hair/mohawk_shavedbacklong
	name = "Mohawk, Shaved Back and Long"
	icon_state = "hair_mohawk_shavedbacklong"
	chatname = "mohawk"

/datum/sprite_accessory/hair/mohawk_shavedtight
	name = "Mohawk, Shaved and Tight"
	icon_state = "hair_mohawk_shavedtight"
	chatname = "mohawk"

/datum/sprite_accessory/hair/mulder
	name = "Mulder"
	icon_state = "hair_mulder"
	chatname = "short hair"

/datum/sprite_accessory/hair/neat
	name = "Neat"
	icon_state = "hair_neat"
	chatname = "groomed hair"

/datum/sprite_accessory/hair/neatlong
	name = "Neat (Long)"
	icon_state = "hair_neatlong"
	length = 2
	chatname = "long hair"

/datum/sprite_accessory/hair/newyou
	name = "New You"
	icon_state = "hair_newyou"
	length = 3
	chatname = "ponytail"

/datum/sprite_accessory/hair/nia
	name = "Nia"
	icon_state = "hair_nia"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/ombre
	name = "Ombre"
	icon_state = "hair_ombre"
	length = 2
	chatname = "short hair"

/datum/sprite_accessory/hair/oneshoulder
	name = "One Shoulder"
	icon_state = "hair_oneshoulder"
	length = 2
	chatname = "one shoulder hairstyle"

/datum/sprite_accessory/hair/overeye_long
	name = "Overeye, Long"
	icon_state = "hair_overeye_long"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/overeye_short
	name = "Overeye, Short"
	icon_state = "hair_overeye_short"
	chatname = "long hair"
	length = 2

/datum/sprite_accessory/hair/overeye_verylong
	name = "Overeye, Very Long"
	icon_state = "hair_overeye_verylong"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/overeye_veryshort
	name = "Overeye, Very Short"
	icon_state = "hair_overeye_veryshort"
	chatname = "short hair"

/datum/sprite_accessory/hair/overeye_veryshort_alt
	name = "Overeye, Very Short Alt"
	icon_state = "hair_overeye_veryshort_alt"
	chatname = "short hair"

/datum/sprite_accessory/hair/oxton
	name = "Oxton"
	icon_state = "hair_oxton"
	chatname = "short hair"

/datum/sprite_accessory/hair/parted
	name = "Parted"
	icon_state = "hair_parted"
	chatname = "short hair"

/datum/sprite_accessory/hair/parted_alt
	name = "Parted, Alt"
	icon_state = "hair_parted_alt"
	chatname = "short hair"

/datum/sprite_accessory/hair/parted_swept
	name = "Parted, Swept"
	icon_state = "hair_parted_swept"
	chatname = "short hair"

/datum/sprite_accessory/hair/pigtails_belle
	name = "Pigtails, Belle"
	icon_state = "hair_pigtails_belle"
	gender = FEMALE
	length = 2
	chatname = "pigtails"

/datum/sprite_accessory/hair/pigtails_kagami
	name = "Pigtails, Kagami"
	icon_state = "hair_pigtails_kagami"
	length = 2
	chatname = "pigtails"

/datum/sprite_accessory/hair/pigtails_low
	name = "Pigtails, Low"
	icon_state = "hair_pigtails_low"
	length = 2
	chatname = "pigtails"

/datum/sprite_accessory/hair/pigtails_nitori
	name = "Pigtails, Nitori"
	icon_state = "hair_pigtails_nitori"
	length = 2
	chatname = "pigtails"

/datum/sprite_accessory/hair/pigtails_twintail
	name = "Pigtails, Twintail"
	icon_state = "hair_pigtails_twintail"
	length = 2
	chatname = "pigtails"

/datum/sprite_accessory/hair/pigtails_twintail_ombre
	name = "Pigtails, Twintail Ombre"
	icon_state = "hair_pigtails_twintail_ombre"
	length = 2
	chatname = "pigtails"

/datum/sprite_accessory/hair/pigtails_twintail_ombre_alt
	name = "Pigtails, Twintail Ombre Alt"
	icon_state = "hair_pigtails_twintail_ombre_alt"
	length = 3
	chatname = "pigtails"

/datum/sprite_accessory/hair/pompadour
	name = "Pompadour"
	icon_state = "hair_pompadour"
	length = 3
	chatname = "pompadour"

/datum/sprite_accessory/hair/pompadour_dandy
	name = "Pompadour, Dandy"
	icon_state = "hair_pompadour_dandy"
	length = 3
	chatname = "pompadour"

/datum/sprite_accessory/hair/ponytail1
	name = "Ponytail 1"
	icon_state = "hair_ponytail1"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail2
	name = "Ponytail 2"
	icon_state = "hair_ponytail2" //hair_pa
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail3
	name = "Ponytail 3"
	icon_state = "hair_ponytail3"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail4
	name = "Ponytail 4"
	icon_state = "hair_ponytail4"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail5
	name = "Ponytail 5"
	icon_state = "hair_ponytail5"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail6
	name = "Ponytail 6"
	icon_state = "hair_ponytail6"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail7
	name = "Ponytail 7"
	icon_state = "hair_ponytail7"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail8
	name = "Ponytail 8"
	icon_state = "hair_ponytail8"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail9
	name = "Ponytail 9"
	icon_state = "hair_ponytail9"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail_short
	name = "Ponytail, Short"
	icon_state = "hair_ponytail_short"
	length = 2
	chatname = "short ponytail"

/datum/sprite_accessory/hair/ponytail_short2
	name = "Ponytail, Short 2"
	icon_state = "hair_ponytail_short2"
	length = 2
	chatname = "short ponytail"

/datum/sprite_accessory/hair/ponytail_short3
	name = "Ponytail, Short 3"
	icon_state = "hair_ponytail_short3"
	length = 2
	chatname = "short ponytail"

/datum/sprite_accessory/hair/ponytail_short4
	name = "Ponytail, Short 4"
	icon_state = "hair_ponytail_short4"
	length = 2
	chatname = "short ponytail"

/datum/sprite_accessory/hair/ponytail_short5
	name = "Ponytail, Short 5"
	icon_state = "hair_ponytail_short5"
	length = 2
	chatname = "short ponytail"

/datum/sprite_accessory/hair/ponytail_fringetail
	name = "Ponytail, Fringetail"
	icon_state = "hair_ponytail_fringetail"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail_high
	name = "Ponytail, High"
	icon_state = "hair_ponytail_high"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail_side
	name = "Ponytail, Side"
	icon_state = "hair_ponytail_side"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail_side2
	name = "Ponytail, Side 2"
	icon_state = "hair_ponytail_side2"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail_side3
	name = "Ponytail, Side 3"
	icon_state = "hair_ponytail_side3"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail_side4
	name = "Ponytail, Side 4"
	icon_state = "hair_ponytail_side4"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail_spiky
	name = "Ponytail, Spiky"
	icon_state = "hair_ponytail_spiky"
	length = 4
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail_wisp
	name = "Ponytail, Wisp"
	icon_state = "hair_ponytail_wisp"
	length = 3
	chatname = "ponytail"

/datum/sprite_accessory/hair/ponytail_zieglertail
	name = "Ponytail, Zieglertail"
	icon_state = "hair_ponytail_ziegler"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/bunlarge2
	name = "Bun, Large 2"
	icon_state = "hair_bun_large2"
	length = 2
	chatname = "large bun"

/datum/sprite_accessory/hair/poofy
	name = "Poofy"
	icon_state = "hair_poofy"
	length = 2
	chatname = "poofy hair"

/datum/sprite_accessory/hair/poofy2
	name = "Poofy 2"
	icon_state = "hair_poofy2"
	length = 2
	chatname = "poofy hair"

/datum/sprite_accessory/hair/punk_chelsea
	name = "Punk Shave, Chelsea"
	icon_state = "hair_punk_chelsea"
	chatname = "fringe"

/datum/sprite_accessory/hair/punk_chelsea_bighawk
	name = "Punk Shave, Chelsea Big Hawk"
	icon_state = "hair_punk_chelsea_bighawk"
	chatname = "mohawk"

/datum/sprite_accessory/hair/punk_chelsea_smallhawk
	name = "Punk Shave, Chelsea Small Hawk"
	icon_state = "hair_punk_chelsea_smallhawk"
	chatname = "mohawk"

/datum/sprite_accessory/hair/punk_chelsea_ponytail
	name = "Punk Shave, Chelsea Ponytail"
	icon_state = "hair_punk_chelsea_ponytail"
	chatname = "ponytail"

/datum/sprite_accessory/hair/punk_chelseafringe
	name = "Punk Shave, Chelsea Fringe"
	icon_state = "hair_punk_chelseafringe"
	chatname = "fringe"

/datum/sprite_accessory/hair/punk_chelseafringealt
	name = "Punk Shave, Chelsea Fringe Alt"
	icon_state = "hair_punk_chelseafringe_alt"
	chatname = "fringe"

/datum/sprite_accessory/hair/punk_chelseafringe_bighawk
	name = "Punk Shave, Chelsea Big Hawk"
	icon_state = "hair_punk_chelseafringe_bighawk"
	chatname = "mohawk"

/datum/sprite_accessory/hair/punk_chelseafringe_smallhawk
	name = "Punk Shave, Chelsea Small Hawk"
	icon_state = "hair_punk_chelseafringe_smallhawk"
	chatname = "mohawk"

/datum/sprite_accessory/hair/punk_chelseafringe_ponytail
	name = "Punk Shave, Chelsea Ponytail"
	icon_state = "hair_punk_chelseafringe_ponytail"
	chatname = "ponytail"

/datum/sprite_accessory/hair/punk_halfshaved
	name = "Punk Shave, Half-Shaved"
	icon_state = "hair_punk_halfshaved"
	chatname = "unshaved hair"		// grabbing the parts that can be grabbed

/datum/sprite_accessory/hair/punk_halfshaved_alt
	name = "Punk Shave, Half-Shaved Alt"
	icon_state = "hair_punk_halfshaved_alt"
	chatname = "unshaved hair"

/datum/sprite_accessory/hair/punk_halfshaved_bun
	name = "Punk Shave, Half-Shaved Bun"
	icon_state = "hair_punk_halfshaved_bun"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/punk_halfshaved_bun_alt
	name = "Punk Shave, Half-Shaved Bun Alt"
	icon_state = "hair_punk_halfshaved_bun_alt"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/punk_halfshaved_emo
	name = "Punk Shave, Half-Shaved Emo"
	icon_state = "hair_punk_halfshaved_emo"
	length = 2
	chatname = "unshaved hair"

/datum/sprite_accessory/hair/punk_sidecut_left
	name = "Punk Shave, Sidecut Left"
	icon_state = "hair_punk_sideleft"
	length = 2
	chatname = "unshaved hair"

/datum/sprite_accessory/hair/punk_sidecut_right
	name = "Punk Shave, Sidecut Right"
	icon_state = "hair_punk_sideright"
	length = 2
	chatname = "unshaved hair"

/datum/sprite_accessory/hair/quiff
	name = "Quiff"
	icon_state = "hair_quiff"
	length = 2
	chatname = "quiff"

/datum/sprite_accessory/hair/ronin
	name = "Ronin"
	icon_state = "hair_ronin"
	length = 2
	chatname = "long hair"

/datum/sprite_accessory/hair/rosa
	name = "Rosa"
	icon_state = "hair_rosa"
	chatname = "short hair"

/datum/sprite_accessory/hair/rows
	name = "Rows"
	icon_state = "hair_rows"
	length = 2
	chatname = "cornrows"

/datum/sprite_accessory/hair/rows_braid
	name = "Rows, Braid"
	icon_state = "hair_rows_braid"
	length = 2
	chatname = "cornrows"

/datum/sprite_accessory/hair/rows_bun
	name = "Rows, Bun"
	icon_state = "hair_rows_bun"
	length = 2
	chatname = "cornrows"

/datum/sprite_accessory/hair/rows_dualtail
	name = "Rows, Dual Tail"
	icon_state = "hair_rows_dualtail"
	length = 2
	chatname = "cornrows"

/datum/sprite_accessory/hair/rows_long
	name = "Rows, Long"
	icon_state = "hair_rows_long"
	length = 2
	chatname = "cornrows"

/datum/sprite_accessory/hair/scully
	name = "Scully"
	icon_state = "hair_scully"
	chatname = "short hair"

/datum/sprite_accessory/hair/shaved
	name = "Shaved"
	icon_state = "hair_shaved"
	length = 0
	chatname = "shaved head"

/datum/sprite_accessory/hair/short
	name = "Short Hair"
	icon_state = "hair_shorthair" //hair_a
	chatname = "short hair"

/datum/sprite_accessory/hair/short2
	name = "Short Hair 2"
	icon_state = "hair_shorthair2"
	chatname = "short hair"

/datum/sprite_accessory/hair/short3
	name = "Short Hair 3"
	icon_state = "hair_shorthair3"
	chatname = "short hair"

/datum/sprite_accessory/hair/short4
	name = "Short Hair 4"
	icon_state = "hair_shorthair4"
	chatname = "short hair"

/datum/sprite_accessory/hair/sideswept
	name = "Sideswept Hair"
	icon_state = "hair_sideswept"
	chatname = "short hair"

/datum/sprite_accessory/hair/skinhead
	name = "Skinhead"
	icon_state = "hair_skinhead"
	chatname = "matted shaved hair"

/datum/sprite_accessory/hair/sleeze
	name = "Sleeze"
	icon_state = "hair_sleeze"
	chatname = "short hair"

/datum/sprite_accessory/hair/slick
	name = "Slick"
	icon_state = "hair_slick"
	chatname = "slicked hair"

/datum/sprite_accessory/hair/spiky
	name = "Spiky"
	icon_state = "hair_spiky"
	species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie)
	chatname = "mighty spikes"

/datum/sprite_accessory/hair/straightlong
	name = "Straight Long"
	icon_state = "hair_straightlong"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/thinning
	name = "Thinning"
	icon_state = "hair_thinning"
	chatname = "short hair"

/datum/sprite_accessory/hair/thinningback
	name = "Thinning Back"
	icon_state = "hair_thinningback"
	chatname = "short hair"

/datum/sprite_accessory/hair/thinningfront
	name = "Thinning Front"
	icon_state = "hair_thinningfront"
	chatname = "short hair"

/datum/sprite_accessory/hair/tresshoulder
	name = "Tress Shoulder"
	icon_state = "hair_tressshoulder"
	length = 2
	chatname = "curls"

/datum/sprite_accessory/hair/tresshoulderdouble
	name = "Tress Shoulder Double"
	icon_state = "hair_tressshoulder_double"
	length = 2
	chatname = "curls"

/datum/sprite_accessory/hair/trimmed
	name = "Trimmed"
	icon_state = "hair_trimmed"
	chatname = "trimmed hair"

/datum/sprite_accessory/hair/trimmedflat
	name = "Trimmed Flat Top"
	icon_state = "hair_trimmedflat"
	chatname = "trimmed hair"

/datum/sprite_accessory/hair/twincurls
	name = "Twincurls"
	icon_state = "hair_twincurls"
	length = 2
	chatname = "curls"

/datum/sprite_accessory/hair/twincurls2
	name = "Twincurls 2"
	icon_state = "hair_twincurls2"
	length = 2
	chatname = "curls"

/datum/sprite_accessory/hair/undercut
	name = "Undercut"
	icon_state = "hair_undercut"
	chatname = "unshaved hair"

/datum/sprite_accessory/hair/undercut2
	name = "Undercut 2"
	icon_state = "hair_undercut2"
	chatname = "undercut"

/datum/sprite_accessory/hair/undercut3
	chatname = "unshaved hair"
	name = "Undercut 3"
	icon_state = "hair_undercut3"
	chatname = "unshaved hair"

/datum/sprite_accessory/hair/undercut4
	name = "Undercut 4"
	icon_state = "hair_undercut4"
	chatname = "unshaved hair"

/datum/sprite_accessory/hair/undercut5
	name = "Undercut 5"
	icon_state = "hair_undercut5"
	chatname = "unshaved hair"

/datum/sprite_accessory/hair/unkept
	name = "Unkept"
	icon_state = "hair_unkept"
	length = 3
	chatname = "unkept hairdo"

/datum/sprite_accessory/hair/updo
	name = "Updo"
	icon_state = "hair_updo"
	length = 2
	chatname = "updo"

/datum/sprite_accessory/hair/vegeta
	name = "Vegeta"
	icon_state = "hair_vegeta"
	length = 4
	chatname = "mighty spikes"

/datum/sprite_accessory/hair/volaju
	name = "Volaju"
	icon_state = "hair_volaju"
	length = 2
	chatname = "long hair"

/datum/sprite_accessory/hair/wheeler
	name = "Wheeler"
	icon_state = "hair_wheeler"
	chatname = "short hair"

/datum/sprite_accessory/hair/fingerwave
	name = "Fingerwave"
	icon_state = "hair_fingercurl"
	chatname = "fluffy hair"

/datum/sprite_accessory/hair/bug_eyes
	icon = 'icons/mob/human_face/dionae_hair.dmi'
	name = "Bug Eyes"
	icon_state = "bugeyes"
	species_allowed = list(/datum/species/diona, /datum/species/diona/coeu)
	gender = NEUTER
	do_colouration = FALSE

/datum/sprite_accessory/hair/bug_eyes/human_eyes
	name = "Human Eyes"
	icon_state = "humaneyes"

/datum/sprite_accessory/hair/bug_eyes/skrell_eyes
	name = "Skrell Eyes"
	icon_state = "skrelleyes"

/datum/sprite_accessory/hair/bug_eyes/skrell_eyes_2
	name = "Skrell Eyes 2"
	icon_state = "skrelleyes2"

/datum/sprite_accessory/hair/bug_eyes/small_horns
	name = "Small Horns"
	icon_state = "smallhorns"

/datum/sprite_accessory/hair/bug_eyes/horny
	name = "Horny"
	icon_state = "horny"

/datum/sprite_accessory/hair/bug_eyes/headtails
	name = "Head tails"
	icon_state = "headtails"

/datum/sprite_accessory/hair/bug_eyes/headtails_2
	name = "Head tails 2"
	icon_state = "headtails2"

/datum/sprite_accessory/hair/bug_eyes/tiny_eye
	name = "Tiny Eye"
	icon_state = "tinyeye"

/datum/sprite_accessory/hair/bug_eyes/eyebrow
	name = "Eyebrow"
	icon_state = "eyebrow"

/datum/sprite_accessory/hair/bug_eyes/bullhorn
	name = "Bullhorn"
	icon_state = "bullhorn"

/datum/sprite_accessory/hair/bug_eyes/blinkinghelmethead
	name = "Blinking Helmethead"
	icon_state = "blinkinghelmethead"

/datum/sprite_accessory/hair/bug_eyes/periscope
	name = "Periscope"
	icon_state = "periscope"

/datum/sprite_accessory/hair/bug_eyes/glorp
	name = "Glorp"
	icon_state = "glorp"

/datum/sprite_accessory/hair/bug_eyes/mellow_cap
	name = "Mellow Cap"
	icon_state = "mellowcap"

/datum/sprite_accessory/hair/bug_eyes/red_cap
	name = "Red Cap"
	icon_state = "redcap"

/datum/sprite_accessory/hair/bug_eyes/fun_guy
	name = "Fun Guy"
	icon_state = "funguy"

/datum/sprite_accessory/hair/bug_eyes/spanish_moss
	name = "Spanish Moss"
	icon_state = "spanishmoss"

/datum/sprite_accessory/hair/bug_eyes/shelflife
	name = "Shelflife"
	icon_state = "shelflife"
	do_colouration = TRUE

/datum/sprite_accessory/hair/bug_eyes/oak
	name = "Oak"
	icon_state = "oak"

/datum/sprite_accessory/hair/bug_eyes/thorns
	name = "Thorns"
	icon_state = "thorns"

/datum/sprite_accessory/hair/bug_eyes/stump
	name = "Stump"
	icon_state = "stump"

// TG-format hair - uses ICON_MULTIPLY instead of ICON_ADD
/datum/sprite_accessory/hair/balding
	icon = 'icons/mob/human_face/hair_multiply.dmi'
	icon_blend_mode = ICON_MULTIPLY
	name = "Balding"
	icon_state = "hair_balding"
	length = 0
	chatname = "balding hair"

/datum/sprite_accessory/hair/balding/balding_boddicker
	name = "Balding, Boddicker"
	icon_state = "hair_balding_boddicker"
	length = 1
	chatname = "balding hair"

/datum/sprite_accessory/hair/balding/bangs_light
	name = "Bangs, Light"
	icon_state = "hair_bangs_light"
	length = 2
	chatname = "long hair"

/datum/sprite_accessory/hair/balding/bob_alt
	name = "Bob, Alt"
	icon_state = "hair_bob_alt"
	length = 1
	chatname = "short hair"

/datum/sprite_accessory/hair/balding/braided_tail
	name = "Braided, Tail"
	icon_state = "hair_braided_tail"
	length = 2
	chatname = "braids"

/datum/sprite_accessory/hair/balding/bun_large
	name = "Bun, Large"
	icon_state = "hair_bun_large"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/balding/bun_librarian
	name = "Bun, Librarian"
	icon_state = "hair_bun_librarian"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/balding/bun_quad
	name = "Bun, Quad"
	icon_state = "hair_bun_quad"
	length = 2
	chatname = "hair buns"

/datum/sprite_accessory/hair/balding/bun_uniter
	name = "Bun, Uniter"
	icon_state = "hair_bun_uniter"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/balding/business
	name = "Business"
	icon_state = "hair_business"
	length = 1
	chatname = "short hair"

/datum/sprite_accessory/hair/balding/business2
	name = "Business 2"
	icon_state = "hair_business2"
	length = 1
	chatname = "short hair"

/datum/sprite_accessory/hair/balding/business3
	name = "Business 3"
	icon_state = "hair_business3"
	length = 1
	chatname = "short hair"

/datum/sprite_accessory/hair/balding/business4
	name = "Business 4"
	icon_state = "hair_business4"
	length = 1
	chatname = "short hair"

/datum/sprite_accessory/hair/balding/cactus
	name = "Cactus"
	icon_state = "hair_cactus"
	length = 3
	chatname = "very long hair"

/datum/sprite_accessory/hair/balding/choppy
	name = "Choppy"
	icon_state = "hair_choppy"
	length = 1
	chatname = "choppy hair"

/datum/sprite_accessory/hair/balding/fade
	name = "Fade"
	icon_state = "hair_fade"
	length = 1
	chatname = "groomed hair"

/datum/sprite_accessory/hair/balding/fade_grown
	name = "Fade, Grown"
	icon_state = "hair_fade_grown"
	length = 1
	chatname = "groomed hair"

/datum/sprite_accessory/hair/balding/floof
	name = "Floof"
	icon_state = "hair_floof"
	length = 2
	chatname = "fluffy hair"

/datum/sprite_accessory/hair/balding/floof_short
	name = "Floof, Short"
	icon_state = "hair_floof_short"
	length = 1
	chatname = "fluffy hair"

/datum/sprite_accessory/hair/balding/hair_antenna
	name = "Hair Antenna"
	icon_state = "hair_hairantenna"
	length = 2
	chatname = "long hair"

/datum/sprite_accessory/hair/balding/hedgehog
	name = "Hedgehog"
	icon_state = "hair_hedgehog"
	length = 1
	chatname = "short hair"

/datum/sprite_accessory/hair/balding/keanu
	name = "Keanu"
	icon_state = "hair_keanu"
	length = 1
	chatname = "short hair"

/datum/sprite_accessory/hair/balding/krewcut
	name = "Krewcut"
	icon_state = "hair_krewcut"
	length = 1
	chatname = "fringe"

/datum/sprite_accessory/hair/balding/messy4
	name = "Messy 4"
	icon_state = "hair_messy4"
	length = 1
	chatname = "messy hair"

/datum/sprite_accessory/hair/balding/nia2
	name = "Nia 2"
	icon_state = "hair_nia2"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/balding/nia3
	name = "Nia 3"
	icon_state = "hair_nia3"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/balding/parted_short
	name = "Parted, Short"
	icon_state = "hair_parted_short"
	length = 1
	chatname = "short hair"

/datum/sprite_accessory/hair/balding/pigtails_simple
	name = "Pigtails, Simple"
	icon_state = "hair_pigtails_simple"
	length = 2
	chatname = "pigtails"

/datum/sprite_accessory/hair/balding/pixie
	name = "Pixie"
	icon_state = "hair_pixie"
	length = 1
	chatname = "short hair"

/datum/sprite_accessory/hair/balding/pompadour_iii
	name = "Pompadour, Pomp III"
	icon_state = "hair_pomp_iii"
	length = 3
	chatname = "pompadour"

/datum/sprite_accessory/hair/balding/ponytail_high2
	name = "Ponytail, High 2"
	icon_state = "hair_ponytail_high2"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/balding/ponytail_jenjen
	name = "Ponytail, Jenjen"
	icon_state = "hair_ponytail_jenjen"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/balding/ponytail_side5
	name = "Ponytail, Side 5"
	icon_state = "hair_ponytail_side5"
	length  = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/balding/ponytail_side6
	name = "Ponytail, Side 6"
	icon_state = "hair_ponytail_side6"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/balding/ponytail_side7
	name = "Ponytail, Side 7"
	icon_state = "hair_ponytail_side7"
	length = 2
	chatname = "braided ponytail"

/datum/sprite_accessory/hair/balding/ponytail_straight
	name = "Ponytail, Straight"
	icon_state = "hair_ponytail_straight"
	length = 2
	chatname = "ponytail"

/datum/sprite_accessory/hair/balding/protagonist
	name = "Protagonist"
	icon_state = "hair_protagonist"
	length = 1
	chatname = "short hair"

/datum/sprite_accessory/hair/balding/punk_sideshaved
	name = "Punk Shave, Sideshaved"
	icon_state = "hair_punk_sideshaved"
	length = 1
	chatname = "unshaved hair"		//in reference to tugging the unshaved parts

/datum/sprite_accessory/hair/balding/short_spiked
	name = "Short Spiked"
	icon_state = "hair_short_spiked"
	length = 1
	chatname = "spiked hair"

/datum/sprite_accessory/hair/balding/sidepart
	name = "Sidepart"
	icon_state = "hair_sidepart"
	length = 1
	chatname = "short hair"

/datum/sprite_accessory/hair/balding/sidepart_long
	name = "Sidepart, Long"
	icon_state = "hair_sidepart_long"
	length = 3
	chatname = "long hair"

/datum/sprite_accessory/hair/balding/swept
	name = "Swept"
	icon_state = "hair_swept"
	length = 1
	chatname = "short hair"

/datum/sprite_accessory/hair/balding/swept_short
	name = "Swept, Short"
	icon_state = "hair_swept_short"
	length = 1
	chatname = "short hair"

/datum/sprite_accessory/hair/balding/swept_back
	name = "Swept, Back"
	icon_state = "hair_swept_back"
	length = 1
	chatname = "short hair"

/datum/sprite_accessory/hair/balding/superbowl
	name = "Bowl, Superbowl"
	icon_state = "hair_bowlcut_superbowl"
	length = 1
	chatname = "bowl cut"

/datum/sprite_accessory/hair/balding/waxed
	name = "Waxed"
	icon_state = "hair_waxed"
	chatname = "bald head"

/datum/sprite_accessory/hair/balding/wavyshoulder
	name = "Wavy Shoulder (Down)"
	icon_state = "hair_wavyshoulder_down"
	length = 2
	chatname = "wavy hair"

/datum/sprite_accessory/hair/balding/wavyshoulder_pt
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

/datum/sprite_accessory/hair_gradients/none
	name = "None"
	icon_state = "none"
	species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie,/datum/species/unathi,/datum/species/zombie/unathi,
		/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara,/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell, /datum/species/bug,
		/datum/species/bug/type_b)

/datum/sprite_accessory/hair_gradients/none_48
	name = "None (Vaurca Type C/E)"
	icon = "icons/mob/base_48.dmi"
	icon_state = "none"
	species_allowed = list(/datum/species/bug/type_e, /datum/species/bug/type_c)

/datum/sprite_accessory/hair_gradients/fade_up
	name = "Fade (Up)"
	icon_state = "fadeup"

/datum/sprite_accessory/hair_gradients/fade_down
	name = "Fade (Down)"
	icon_state = "fadedown"

/datum/sprite_accessory/hair_gradients/fade_right
	name = "Fade (Right)"
	icon_state = "faderight"

/datum/sprite_accessory/hair_gradients/fade_left
	name = "Fade (Left)"
	icon_state = "fadeleft"

/datum/sprite_accessory/hair_gradients/vertical_split_right
	name = "Vertical Split (Right)"
	icon_state = "vsplit_right"

/datum/sprite_accessory/hair_gradients/vertical_split_left
	name = "Vertical Split (Left)"
	icon_state = "vsplit_left"

/datum/sprite_accessory/hair_gradients/horizontal
	name = "Horizontal Split"
	icon_state = "hsplit"

/datum/sprite_accessory/hair_gradients/taj_inner_ear_fur
	name = "Inner Ear Fur"
	icon_state = "taj_innerearfur"
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan, /datum/species/zombie/tajara)

/datum/sprite_accessory/hair_gradients/taj_msai_inner_ear_fur
	name = "M'sai Inner Ear Fur"
	icon_state = "taj_msai_innerearfur"
	species_allowed = list(/datum/species/tajaran/m_sai)

/datum/sprite_accessory/hair_gradients/skrell_spots
	name = "Skrell Spots"
	icon_state = "skrell_gradient_spots"
	species_allowed = list(/datum/species/skrell, /datum/species/skrell/axiori, /datum/species/zombie/skrell)

/datum/sprite_accessory/hair_gradients/skrell_stripes
	name = "Skrell Headtail Blotches"
	icon_state = "skr_headtail_stripes"
	species_allowed = list(/datum/species/skrell, /datum/species/skrell/axiori, /datum/species/zombie/skrell)

/datum/sprite_accessory/hair_gradients/skrell_headtail_middle
	name = "Skrell Headtail Middle"
	icon_state = "skr_headtail_mid"
	species_allowed = list(/datum/species/skrell, /datum/species/skrell/axiori, /datum/species/zombie/skrell)

/datum/sprite_accessory/hair_gradients/skrell_headtail_hfade
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

/datum/sprite_accessory/facial_hair/shaved
	name = "Shaved"
	icon_state = "bald"
	gender = NEUTER
	species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie,/datum/species/unathi,/datum/species/zombie/unathi,
		/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/tajaran/tesla_body,/datum/species/zombie/tajara,/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell,/datum/species/diona,
		/datum/species/diona/coeu, /datum/species/bug/type_b)

/datum/sprite_accessory/facial_hair/threeOclock
	name = "3 O'clock Shadow"
	icon_state = "facial_3oclock"

/datum/sprite_accessory/facial_hair/threeOclockstache
	name = "3 O'clock Shadow and Moustache"
	icon_state = "facial_3oclockmoustache"

/datum/sprite_accessory/facial_hair/fiveOclock
	name = "5 O'clock Shadow"
	icon_state = "facial_5oclock"

/datum/sprite_accessory/facial_hair/fiveOclockstache
	name = "5 O'clock Shadow and Moustache"
	icon_state = "facial_5oclockmoustache"

/datum/sprite_accessory/facial_hair/sevenOclock
	name = "7 O'clock Shadow"
	icon_state = "facial_7oclock"

/datum/sprite_accessory/facial_hair/sevenOclockstache
	name = "7 O'clock Shadow and Moustache"
	icon_state = "facial_7oclockmoustache"

/datum/sprite_accessory/facial_hair/abe
	name = "Abraham Lincoln Beard"
	icon_state = "facial_abe"

/datum/sprite_accessory/facial_hair/biker
	name = "Biker Beard"
	icon_state = "facial_biker"

/datum/sprite_accessory/facial_hair/britstache
	name = "Britstache"
	icon_state = "facial_britstache"

/datum/sprite_accessory/facial_hair/chaplin
	name = "Square Mustache"
	icon_state = "facial_chaplin"

/datum/sprite_accessory/facial_hair/chinless
	name = "Chinless Beard"
	icon_state = "facial_chinlessbeard"

/datum/sprite_accessory/facial_hair/chinstrap
	name = "Chinstrap"
	icon_state = "facial_chinstrap"

/datum/sprite_accessory/facial_hair/croppedbeard
	name = "Full Cropped Beard"
	icon_state = "facial_croppedfullbeard"

/datum/sprite_accessory/facial_hair/dwarf
	name = "Dwarf Beard"
	icon_state = "facial_dwarf"

/datum/sprite_accessory/facial_hair/elvis
	name = "Elvis Sideburns"
	icon_state = "facial_elvis"
	species_allowed = list(/datum/species/human,/datum/species/human/offworlder,/datum/species/machine/shell,/datum/species/machine/shell/rogue,/datum/species/zombie)

/datum/sprite_accessory/facial_hair/fullbeard
	name = "Full Beard"
	icon_state = "facial_fullbeard"

/datum/sprite_accessory/facial_hair/gt
	name = "Goatee"
	icon_state = "facial_gt"

/datum/sprite_accessory/facial_hair/gt2
	name = "Goatee 2"
	icon_state = "facial_gt2"

/datum/sprite_accessory/facial_hair/gt3
	name = "Goatee 3"
	icon_state = "facial_gt3"

/datum/sprite_accessory/facial_hair/hip
	name = "Hipster Beard"
	icon_state = "facial_hip"

/datum/sprite_accessory/facial_hair/hogan
	name = "Hulk Hogan Mustache"
	icon_state = "facial_hogan" //-Neek

/datum/sprite_accessory/facial_hair/horseshoe
	name = "Horseshoe Mustache"
	icon_state = "facial_horseshoe"

/datum/sprite_accessory/facial_hair/jensen
	name = "Jensen Beard"
	icon_state = "facial_jensen"

/datum/sprite_accessory/facial_hair/longbeard
	name = "Long Beard"
	icon_state = "facial_longbeard"

/datum/sprite_accessory/facial_hair/lumberjack
	name = "Lumberjack"
	icon_state = "facial_lumberjack"

/datum/sprite_accessory/facial_hair/martial_artist
	name = "Martial Artist"
	icon_state = "facial_martialartist"

/datum/sprite_accessory/facial_hair/moonshiner
	name = "Moonshiner"
	icon_state = "facial_moonshiner"

/datum/sprite_accessory/facial_hair/mutton
	name = "Mutton Chops"
	icon_state = "facial_mutton"

/datum/sprite_accessory/facial_hair/muttonstache
	name = "Mutton Chops and Moustache"
	icon_state = "facial_muttonmus"

/datum/sprite_accessory/facial_hair/neckbeard
	name = "Neckbeard"
	icon_state = "facial_neckbeard"

/datum/sprite_accessory/facial_hair/seadog
	name = "Sea Dog"
	icon_state = "facial_seadog"

/datum/sprite_accessory/facial_hair/selleck
	name = "Selleck Mustache"
	icon_state = "facial_selleck"

/datum/sprite_accessory/facial_hair/sideburns
	name = "Sideburns"
	icon_state = "facial_sideburns"

/datum/sprite_accessory/facial_hair/tribeard
	name = "Tribeard"
	icon_state = "facial_tribeard"

/datum/sprite_accessory/facial_hair/volaju
	name = "Volaju"
	icon_state = "facial_volaju"

/datum/sprite_accessory/facial_hair/walrus
	name = "Walrus Moustache"
	icon_state = "facial_walrus"

/datum/sprite_accessory/facial_hair/watson
	name = "Watson Mustache"
	icon_state = "facial_watson"

/datum/sprite_accessory/facial_hair/wise
	name = "Wise Beard"
	icon_state = "facial_wise"

/datum/sprite_accessory/facial_hair/chinstrap2
	icon = 'icons/mob/human_face/facial_hair_multiply.dmi'
	name = "Chinstrap, Alt"
	icon_state = "facial_chinstrap_ii"
	icon_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/facial_hair/chinstrap2/stark
	name = "Stark"
	icon_state = "facial_stark"

/datum/sprite_accessory/facial_hair/chinstrap2/swire
	name = "Swire"
	icon_state = "facial_swire"

/datum/sprite_accessory/facial_hair/chinstrap2/vandyke
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


/datum/sprite_accessory/hair/una_aquaticfrill
	icon = 'icons/mob/human_face/unathi_hair.dmi'
	name = "Unathi Aquatic Frills"
	icon_state = "unathi_aquaticfrills"
	species_allowed = list(/datum/species/unathi,/datum/species/zombie/unathi)
	length = 0
	chatname = "frills"

/datum/sprite_accessory/hair/una_aquaticfrill/una_bighorns
	name = "Unathi Big Horns"
	icon_state = "unathi_bighorn"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_bighorns/una_bighorns_noside
	name = "Unathi Big Horns (No Sides)"
	icon_state = "unathi_bighorn_nosides"

/datum/sprite_accessory/hair/una_aquaticfrill/una_chinhorn
	name = "Unathi Chin Horn"
	icon_state = "unathi_chinhorns"
	length = 0
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_curlhorn
	name = "Unathi Curled Horns"
	icon_state = "unathi_curledhorn"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_dorsalfrill
	name = "Unathi Dorsal Frill"
	icon_state = "unathi_dorsalfrill"
	length = 0
	chatname = "frills"

/datum/sprite_accessory/hair/una_aquaticfrill/una_dracfrills
	name = "Unathi Draconic Frills"
	icon_state = "unathi_dracfrills"
	length = 0
	chatname = "frills"

/datum/sprite_accessory/hair/una_aquaticfrill/una_drachorn
	name = "Unathi Draconic Horns"
	icon_state = "unathi_drachorn"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_elvis
	name = "Elvis Sideburns"
	icon_state = "unathi_elvis"
	length = 0
	chatname = "sideburns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_hornadorns
	name = "Unathi Horn Adorns"
	icon_state = "unathi_hornadorns"
	length = 0
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_longdorsal
	name = "Unathi Long Dorsal Frill"
	icon_state = "unathi_longdorsal"
	length = 0
	chatname = "frills"

/datum/sprite_accessory/hair/una_aquaticfrill/una_longfrill
	name = "Unathi Long Frills"
	icon_state = "unathi_longfrills"
	length = 0
	chatname = "frills"

/datum/sprite_accessory/hair/una_aquaticfrill/una_longfrill2
	name = "Unathi Long Frills 2"
	icon_state = "unathi_longfrills2"
	length = 0
	chatname = "frills"

/datum/sprite_accessory/hair/una_aquaticfrill/una_longspines
	name = "Unathi Long Spines"
	icon_state = "unathi_longspines"
	length = 0
	chatname = "spines"

/datum/sprite_accessory/hair/una_aquaticfrill/una_lowerhorn
	name = "Unathi Lower Horns"
	icon_state = "unathi_lowerhorn"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_mohawk
	name = "Unathi Mohawk"
	icon_state = "unathi_mohawk"
	length = 5
	chatname = "mohawk"

/datum/sprite_accessory/hair/una_aquaticfrill/una_ramhornshort
	name = "Unathi Short Ram Horns"
	icon_state = "unathi_ramhorn"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_ramhornlong
	name = "Unathi Long Ram Horns"
	icon_state = "unathi_ramhorn2"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_shortfrill
	name = "Unathi Short Frills"
	icon_state = "unathi_shortfrills"
	length = 0
	chatname = "frills"

/datum/sprite_accessory/hair/una_aquaticfrill/una_shortfrill2
	name = "Unathi Short Frills 2"
	icon_state = "unathi_shortfrills2"
	length = 0
	chatname = "frills"

/datum/sprite_accessory/hair/una_aquaticfrill/una_shorthorn
	name = "Unathi Short Horns"
	icon_state = "unathi_shorthorn"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_shortspines
	name = "Unathi Short Spines"
	icon_state = "unathi_shortspines"
	length = 0
	chatname = "spines"

/datum/sprite_accessory/hair/una_aquaticfrill/una_sidefrills
	name = "Unathi Side Frills"
	icon_state = "unathi_sidefrills"
	length = 0
	chatname = "frills"

/datum/sprite_accessory/hair/una_aquaticfrill/una_horns
	name = "Unathi Horns"
	icon_state = "unathi_simplehorn"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_smallhorns
	name = "Unathi Small Horns"
	icon_state = "unathi_smallhorn"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_spikehorn
	name = "Unathi Spike Horns"
	icon_state = "unathi_spikehorn"
	length = 5
	chatname = "spiked horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_swepthorns
	name = "Unathi Swept-Forward Horns"
	icon_state = "unathi_swepthorn"
	length = 0
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_swepthorns2
	name = "Unathi Swept-Forward Horns 2"
	icon_state = "unathi_swepthorn2"
	length = 0
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_demonforward
	name = "Unathi Forward Demon Horns"
	icon_state = "unathi_demonforward"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_bullhorns
	name = "Unathi Bull Horns"
	icon_state = "unathi_bullhorn"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_longhorns
	name = "Unathi Long Bull Horns"
	icon_state = "unathi_longhorn"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_faun
	name = "Unathi Faun Horns"
	icon_state = "unathi_faun"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_double
	name = "Unathi Double Horns"
	icon_state = "unathi_dubhorns"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_hood
	name = "Unathi Cobra Hood"
	icon_state = "unathi_hood"
	length = 5
	chatname = "hood"

/datum/sprite_accessory/hair/una_aquaticfrill/una_skewers
	name = "Unathi Super Long Horns"
	icon_state = "unathi_skewers"
	length = 6
	chatname = "huge horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_chameleon
	name = "Unathi Chameleon Horns"
	icon_state = "unathi_chameleon"
	length = 3
	chatname = "small horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_dilocrest
	name = "Unathi Dilo Crest"
	icon_state = "dilocrest"
	length = 0
	chatname = "crests"

/datum/sprite_accessory/hair/una_aquaticfrill/una_monocrest
	name = "Unathi Mono Crest"
	icon_state = "monocrest"
	length = 0
	chatname = "crest"

/datum/sprite_accessory/hair/una_aquaticfrill/una_cryocrest
	name = "Unathi Cryo Crest"
	icon_state = "cryocrest"
	length = 0
	chatname = "crest"

/datum/sprite_accessory/hair/una_aquaticfrill/una_corycrest
	name = "Unathi Cory Crest"
	icon_state = "corycrest"
	length = 0
	chatname = "crest"

/datum/sprite_accessory/hair/una_aquaticfrill/una_albertahorns
	name = "Unathi Alberta Horns"
	icon_state = "albertahorns"
	length = 5
	chatname = "small horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_styrahorn
	name = "Unathi Styra Horn"
	icon_state = "styrahorn"
	length = 5
	chatname = "massive horn"

/datum/sprite_accessory/hair/una_aquaticfrill/una_styracrest
	name = "Unathi Styra Frill"
	icon_state = "styrafrill"
	length = 0
	chatname = "frill"

/datum/sprite_accessory/hair/una_aquaticfrill/una_pachyboss
	name = "Unathi Pachy Boss"
	icon_state = "pachylump"
	length = 0
	chatname = "lump"

/datum/sprite_accessory/hair/una_aquaticfrill/una_droopy
	name = "Unathi Droopy Dorsal Frill"
	icon_state = "unathi_droopydorsal"
	length = 0
	chatname = "droopy frill"

/datum/sprite_accessory/hair/una_aquaticfrill/una_regal
	name = "Unathi Regal Frills"
	icon_state = "unathi_regalfrills"
	length = 6
	chatname = "massive frills"

/datum/sprite_accessory/hair/una_aquaticfrill/una_hornsbusted
	name = "Unathi Horns-Busted"
	icon_state = "unathi_simplehornbusted"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_ramhornshortbusted
	name = "Unathi Short Ram Horns-Busted"
	icon_state = "unathi_ramhornbusted"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_shorthornbusted
	name = "Unathi Short Horns-Busted"
	icon_state = "unathi_shorthornbusted"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_drachornbusted
	name = "Unathi Draconic Horns-Busted"
	icon_state = "unathi_drachornbusted"
	length = 5
	chatname = "horns"

/datum/sprite_accessory/hair/una_aquaticfrill/una_shortfrill2busted
	name = "Unathi Short Frills 2-Busted"
	icon_state = "unathi_shortfrills2busted"
	length = 0
	chatname = "frills"

/datum/sprite_accessory/hair/una_aquaticfrill/una_styrahornbusted
	name = "Unathi Styra Horn-Busted"
	icon_state = "styrahornbusted"
	length = 2
	chatname = "horn stub"

//skrell tentacles

/datum/sprite_accessory/hair/skr_tentacle_damaged_long_r
	icon = 'icons/mob/human_face/skrell_hair.dmi'
	name = "Long Headtails, damaged (right)"
	icon_state = "verylong_s_dmg_r"
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)
	length = 6
	chatname = "long headtails"

/datum/sprite_accessory/hair/skr_tentacle_damaged_long_l
	icon = 'icons/mob/human_face/skrell_hair.dmi'
	name = "Long Headtails, damaged (left)"
	icon_state = "verylong_s_dmg_l"
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)
	length = 6
	chatname = "long headtails"

/datum/sprite_accessory/hair/skr_tentacle_damaged_r
	icon = 'icons/mob/human_face/skrell_hair.dmi'
	name = "Headtails, damaged (right)"
	icon_state = "skrell_hair_f_dmg_r"
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)
	length = 4
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_damaged_l
	icon = 'icons/mob/human_face/skrell_hair.dmi'
	name = "Headtails, damaged (left)"
	icon_state = "skrell_hair_f_dmg_l"
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)
	length = 4
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_damaged_b_r
	icon = 'icons/mob/human_face/skrell_hair.dmi'
	name = "Headtails, damaged behind (right)"
	icon_state = "skrell_both_behind_dmg_r"
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)
	length = 4
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_damaged_b_l
	icon = 'icons/mob/human_face/skrell_hair.dmi'
	name = "Headtails, damaged behind (left)"
	icon_state = "skrell_both_behind_dmg_l"
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)
	length = 4
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_damaged_blong_l
	icon = 'icons/mob/human_face/skrell_hair.dmi'
	name = "Long Headtails, damaged behind (left)"
	icon_state = "skrell_both_behind_long_dmg_l"
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)
	length = 6
	chatname = "long headtails"

/datum/sprite_accessory/hair/skr_tentacle_damaged_blong_r
	icon = 'icons/mob/human_face/skrell_hair.dmi'
	name = "Long Headtails, damaged behind (right)"
	icon_state = "skrell_both_behind_long_dmg_r"
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)
	length = 6
	chatname = "long headtails"

/datum/sprite_accessory/hair/skr_tentacle_m
	icon = 'icons/mob/human_face/skrell_hair.dmi'
	name = "Short Headtails"
	icon_state = "skrell_hair_m"
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)
	length = 2
	chatname = "short headtails"
	var/scrunchy_style = "seaweed" // seaweed fits the normal tentacles pretty well

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_f
	name = "Headtails"
	icon_state = "skrell_hair_f"
	length = 4
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_short
	name = "Very Short Headtails"
	icon_state = "veryshort_s"
	length = 1
	chatname = "short headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_long
	name = "Long Headtails"
	icon_state = "verylong_s"
	length = 6
	chatname = "long headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_doubletail
	name = "Headtails, ponytail (hoop)"
	icon_state = "skrell_hoop"
	length = 5
	chatname = "headtails"
	scrunchy_style = "hoop"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_flb
	name = "Headtails, ponytail (reef)"
	icon_state = "skrell_reef"
	length = 5
	chatname = "headtails"
	scrunchy_style = "reef"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_backwater
	name = "Headtails, ponytail (backwater)"
	icon_state = "skrell_backwater"
	length = 5
	chatname = "headtails"
	scrunchy_style = "backwater"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_braided
	name = "Headtails, braided"
	icon_state = "skrell_loose_braid"
	length = 5
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_reserved
	name = "Expressive Headtails, reserved"
	icon_state = "skrell_reserved"
	length = 6
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_reserved_long
	name = "Expressive Headtails, reserved (long)"
	icon_state = "skrell_reserved_long"
	length = 6
	chatname = "long headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_excited
	name = "Expressive Headtails, excited"
	icon_state = "skrell_excited"
	length = 6
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_excited_long
	name = "Expressive Headtails, excited (long)"
	icon_state = "skrell_excited_long"
	length = 6
	chatname = "long headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_insulted
	name = "Expressive Headtails, insulted"
	icon_state = "skrell_insulted"
	length = 6
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_insulted_long
	name = "Expressive Headtails, insulted (long)"
	icon_state = "skrell_insulted_long"
	length = 6
	chatname = "long headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_tucked
	name = "Short Headtails, tucked"
	icon_state = "skrell_tucked"
	length = 2
	chatname = "short headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_bun_short
	name = "Short Headtails, bun"
	icon_state = "skrell_short_mid_bun"
	length = 3
	chatname = "short headtails"
	scrunchy_style = "short bun"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_bun
	name = "Headtails, bun"
	icon_state = "skrell_mid_bun"
	length = 4
	chatname = "headtails"
	scrunchy_style = "bun"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_bun_long
	name = "Long Headtails, bun"
	icon_state = "skrell_long_mid_bun"
	length = 6
	chatname = "long headtails"
	scrunchy_style = "long bun"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_low_bun
	name = "Headtails, low bun"
	icon_state = "skrell_low_bun"
	length = 4
	chatname = "headtails"
	scrunchy_style = "low bun"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_tuux_wavy
	name = "Headtails, wavy tuux"
	icon_state = "skrell_long_tuux"
	length = 5
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_tuux_straight
	name = "Headtails, straight tuux"
	icon_state = "skrell_straight_tuux"
	length = 5
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_tuux_short
	name = "Short Headtails, tuux"
	icon_state = "skrell_short_tuux"
	length = 3
	chatname = "short headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_tuux_straight_l
	name = "Long Headtails, tuux"
	icon_state = "skrell_straight_tuux_long"
	length = 6
	chatname = "long headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_slicked
	name = "Short Headtails, slicked"
	icon_state = "skrell_slicked"
	length = 2
	chatname = "short headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_mullet
	name = "Headtails, mullet"
	icon_state = "skrell_mullet"
	length = 4
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_behind_r
	name = "Headtails, behind (right)"
	icon_state = "skrell_right_behind"
	length = 4
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_behind_l
	name = "Headtails, behind (left)"
	icon_state = "skrell_left_behind"
	length = 4
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_behind_b
	name = "Headtails, behind"
	icon_state = "skrell_both_behind"
	length = 4
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_behind_b_s
	name = "Short Headtails, behind"
	icon_state = "skrell_both_behind_short"
	length = 2
	chatname = "short headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_behind_b_l
	name = "Long Headtails, behind"
	icon_state = "skrell_both_behind_long"
	length = 6
	chatname = "long headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_behind_l_l
	name = "Long Headtails, behind (left)"
	icon_state = "skrell_left_behind_long"
	length = 6
	chatname = "long headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_behind_r_l
	name = "Long Headtails, behind (right)"
	icon_state = "skrell_right_behind_long"
	length = 6
	chatname = "long headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_reef
	name = "Short Headtails, ponytail (reef)"
	icon_state = "skrell_reef_short"
	length = 3
	chatname = "short headtails"
	scrunchy_style = "reef_short"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_emo_l_l
	name = "Long Headtails, emo (left)"
	icon_state = "skrell_left_emo_long"
	length = 6
	chatname = "long headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_emo_r_l
	name = "Long Headtails, emo (right)"
	icon_state = "skrell_right_emo_long"
	length = 6
	chatname = "long headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_emo_l
	name = "Headtails, emo (left)"
	icon_state = "skrell_left_emo"
	length = 4
	chatname = "headtails"

/datum/sprite_accessory/hair/skr_tentacle_m/skr_tentacle_emo_r
	name = "Headtails, emo (right)"
	icon_state = "skrell_right_emo"
	length = 4
	chatname = "headtails"


//tajaran hair

/datum/sprite_accessory/hair/taj_ears
	icon = 'icons/mob/human_face/tajara_hair.dmi'
	name = "Tajaran Ears"
	icon_state = "ears_plain"
	length = 1
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/zombie/tajara)

/datum/sprite_accessory/hair/taj_ears/taj_ears_bangs
	name = "Tajara Bangs"
	icon_state = "hair_bangs"
	length = 3
	chatname = "bangs"

/datum/sprite_accessory/hair/taj_ears/taj_ears_bangs_alt
	name = "Tajara Bangs Alt"
	icon_state = "hair_bangs_alt"
	length = 3
	chatname = "short bangs"

/datum/sprite_accessory/hair/taj_ears/taj_ears_shortfringe
	name = "Tajara Short Fringe"
	icon_state = "hair_shortfringe"
	length = 2
	chatname = "short fringe"

/datum/sprite_accessory/hair/taj_ears/taj_ears_bob
	name = "Tajara Bob"
	icon_state = "hair_bob"
	length = 2
	chatname = "groomed short mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_braid
	name = "Tajara Braid"
	icon_state = "hair_braid"
	length = 3
	chatname = "braid"

/datum/sprite_accessory/hair/taj_ears/taj_ears_braid_alt
	name = "Tajara Braid Alt"
	icon_state = "hair_braid_alt"
	length = 3
	chatname = "braid"

/datum/sprite_accessory/hair/taj_ears/taj_ears_clean
	name = "Tajara Clean"
	icon_state = "hair_clean"
	length = 1
	chatname = "short mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_curls
	name = "Tajara Curly"
	icon_state = "hair_curly"
	length = 3
	chatname = "curly mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_curlsalt
	name = "Tajara Curly Alt"
	icon_state = "hair_curlyalt"
	length = 3
	chatname = "curly mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_fingercurl
	name = "Tajara Finger Curls"
	icon_state = "hair_fingerwave"
	length = 2
	chatname = "curls"

/datum/sprite_accessory/hair/taj_ears/taj_ears_pompadour
	name = "Tajara Greaser"
	icon_state = "hair_greaser"
	length = 2
	chatname = "pompadour"

/datum/sprite_accessory/hair/taj_ears/taj_ears_housewife
	name = "Tajara Housewife"
	icon_state = "hair_housewife"
	length = 2
	chatname = "long mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_long
	name = "Tajara Long"
	icon_state = "hair_long"
	length = 3
	chatname = "long mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_messy
	name = "Tajara Messy"
	icon_state = "hair_messy"
	length = 1
	chatname = "messy mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_mohawk
	name = "Tajara Mohawk"
	icon_state = "hair_mohawk"
	length = 1
	chatname = "mohawk"

/datum/sprite_accessory/hair/taj_ears/taj_ears_plait
	name = "Tajara Plait"
	icon_state = "hair_plait"
	length = 1
	chatname = "braid"

/datum/sprite_accessory/hair/taj_ears/taj_ears_rattail
	name = "Tajara Rat Tail"
	icon_state = "hair_rattail"
	length = 2
	chatname = "thin ponytail"

/datum/sprite_accessory/hair/taj_ears/taj_ears_shaggy
	name = "Tajara Shaggy"
	icon_state = "hair_shaggy"
	length = 1
	chatname = "messy mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_straight
	name = "Tajara Straight"
	icon_state = "hair_straight"
	length = 3
	chatname = "short mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_spiky
	name = "Tajara Spiky"
	icon_state = "hair_spiky"
	length = 1
	chatname = "spiky mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_victory
	name = "Tajara Victory Curls"
	icon_state = "hair_victory"
	length = 3
	chatname = "curls"

/datum/sprite_accessory/hair/taj_ears/taj_ears_mane
	name = "Tajara Mane"
	icon_state = "hair_mane"
	length = 3
	gender = MALE
	chatname = "long mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_sidepony
	name = "Tajara Side Ponytail"
	icon_state = "hair_sidepony"
	length = 3
	chatname = "sideponytail"

/datum/sprite_accessory/hair/taj_ears/taj_ears_governmentman
	name = "Tajara Government Man"
	icon_state = "hair_gman"
	length = 1
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_bun
	name = "Tajara Bun"
	icon_state = "hair_bun"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/taj_ears/taj_ears_smallbun
	name = "Tajara Bun (Small)"
	icon_state = "hair_bunsmall"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/taj_ears/taj_ears_lowbun
	name = "Tajara Bun (Low)"
	icon_state = "hair_lowbun"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/taj_ears/taj_ears_smalllowbun
	name = "Tajara Bun (Low, Small)"
	icon_state = "hair_lowbunsmall"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/taj_ears/taj_ears_bunshort
	name = "Tajara Bun (Short)"
	icon_state = "hair_bunshort"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/taj_ears/taj_ears_wedge
	name = "Tajara Wedge"
	icon_state = "hair_wedge"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_tresses
	name = "Tajara Tresses"
	icon_state = "hair_tresses"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_shoulderparted
	name = "Tajara Shoulder Parted"
	icon_state = "hair_shoulderparted"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_shoulderpartedsmall
	name = "Tajara Shoulder Parted Small"
	icon_state = "hair_shoulderpartedsmall"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_shoulderpartedlong
	name = "Tajara Shoulder Parted Long"
	icon_state = "hair_shoulderpartedlong"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_shoulderlength
	name = "Tajara Shoulderlength"
	icon_state = "hair_shoulderlength"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_shoulderlengthalt
	name = "Tajara Shoulderlength Alt"
	icon_state = "hair_shoulderlengthalt"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_sidepartedleft
	name = "Tajara Sideparted Left"
	icon_state = "hair_sidepartedleft"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_sidepartedright
	name = "Tajara Sideparted Right"
	icon_state = "hair_sidepartedright"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_fringeup
	name = "Tajara Fringe Up"
	icon_state = "hair_fringeup"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_cascading
	name = "Tajara Cascading"
	icon_state = "hair_cascading"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_cascadingalt
	name = "Tajara Cascading Alt"
	icon_state = "hair_cascadingalt"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_swoop
	name = "Tajara Swoop"
	icon_state = "hair_swoop"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_swoop_alt
	name = "Tajara Swoop Alt"
	icon_state = "hair_swoop_alt"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_swoop_bangs
	name = "Tajara Swoop Bangs"
	icon_state = "hair_swoop_bangs"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_swoop_long
	name = "Tajara Swoop Long"
	icon_state = "hair_longswoop"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/taj_ears/taj_ears_swoop_long_alt
	name = "Tajara Swoop Long Alt"
	icon_state = "hair_longswoop_alt"
	length = 3
	chatname = "styled mane"

//msai hair, longer ears
/datum/sprite_accessory/hair/msai_ears
	icon = 'icons/mob/human_face/msai_hair.dmi'
	name = "M'sai Ears"
	icon_state = "msai_plain"
	length = 1
	species_allowed = list(/datum/species/tajaran/m_sai)

/datum/sprite_accessory/hair/msai_ears/msai_ears_bangs
	name = "M'sai Bangs"
	icon_state = "msai_bangs"
	length = 3
	chatname = "bangs"

/datum/sprite_accessory/hair/msai_ears/msai_ears_bangs_alt
	name = "M'sai Bangs Alt"
	icon_state = "msai_bangs_alt"
	length = 3
	chatname = "smallbangs"

/datum/sprite_accessory/hair/msai_ears/msai_ears_shortfringe
	name = "M'sai Short Fringe"
	icon_state = "msai_shortfringe"
	length = 2
	chatname = "short fringe"

/datum/sprite_accessory/hair/msai_ears/msai_ears_bob
	name = "M'sai Bob"
	icon_state = "msai_bob"
	length = 2
	chatname = "groomed short mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_braid
	name = "M'sai Braid"
	icon_state = "msai_braid"
	length = 3
	chatname = "braid"

/datum/sprite_accessory/hair/msai_ears/msai_ears_braid_alt
	name = "M'sai Braid Alt"
	icon_state = "msai_braid_alt"
	length = 3
	chatname = "braid"

/datum/sprite_accessory/hair/msai_ears/msai_ears_clean
	name = "M'sai Clean"
	icon_state = "msai_clean"
	length = 1
	chatname = "short mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_curls
	name = "M'sai Curly"
	icon_state = "msai_curly"
	length = 3
	chatname = "curly mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_curls
	name = "M'sai Curly Alt"
	icon_state = "msai_curlyalt"
	length = 3
	chatname = "curly mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_fingercurl
	name = "M'sai Finger Curls"
	icon_state = "msai_fingerwave"
	length = 2
	chatname = "curls"

/datum/sprite_accessory/hair/msai_ears/msai_ears_pompadour
	name = "M'sai Greaser"
	icon_state = "msai_greaser"
	length = 2
	chatname = "pompadour"

/datum/sprite_accessory/hair/msai_ears/msai_ears_housewife
	name = "M'sai Housewife"
	icon_state = "msai_housewife"
	length = 2
	chatname = "long mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_long
	name = "M'sai Long"
	icon_state = "msai_long"
	length = 3
	chatname = "long mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_messy
	name = "M'sai Messy"
	icon_state = "msai_messy"
	length = 1
	chatname = "messy mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_mohawk
	name = "M'sai Mohawk"
	icon_state = "msai_mohawk"
	length = 1
	chatname = "mohawk"

/datum/sprite_accessory/hair/msai_ears/msai_ears_plait
	name = "M'sai Plait"
	icon_state = "msai_plait"
	length = 1
	chatname = "braid"

/datum/sprite_accessory/hair/msai_ears/msai_ears_rattail
	name = "M'sai Rat Tail"
	icon_state = "msai_rattail"
	length = 2
	chatname = "thin ponytail"

/datum/sprite_accessory/hair/msai_ears/msai_ears_shaggy
	name = "M'sai Shaggy"
	icon_state = "msai_shaggy"
	length = 1
	chatname = "messy mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_straight
	name = "M'sai Straight"
	icon_state = "msai_straight"
	length = 3
	chatname = "short mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_spiky
	name = "M'sai Spiky"
	icon_state = "msai_spiky"
	length = 1
	chatname = "spiky mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_victory
	name = "M'sai Victory Curls"
	icon_state = "msai_victory"
	length = 2
	chatname = "curls"

/datum/sprite_accessory/hair/msai_ears/msai_ears_mane
	name = "M'sai Mane"
	icon_state = "msai_mane"
	length = 3
	gender = MALE
	chatname = "long mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_sidepony
	name = "M'sai Side Ponytail"
	icon_state = "msai_sidepony"
	length = 3
	chatname = "sideponytail"

/datum/sprite_accessory/hair/msai_ears/msai_ears_governmentman
	name = "M'sai Government Man"
	icon_state = "msai_gman"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_bun
	name = "M'sai Bun"
	icon_state = "msai_bun"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/msai_ears/taj_ears_smallbun
	name = "M'sai Bun (Small)"
	icon_state = "msai_bunsmall"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/msai_ears/msai_ears_lowbun
	name = "M'sai Bun (Low)"
	icon_state = "msai_lowbun"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/msai_ears/msai_ears_lowsmallbun
	name = "M'sai Bun (Low, Small)"
	icon_state = "msai_lowbunsmall"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/msai_ears/msai_ears_bunshort
	name = "M'sai Bun (Short)"
	icon_state = "msai_bunshort"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/msai_ears/msai_ears_wedge
	name = "M'sai Wedge"
	icon_state = "msai_wedge"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_tresses
	name = "M'sai Tresses"
	icon_state = "msai_tresses"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_shoulderparted
	name = "M'sai Shoulderparted"
	icon_state = "msai_shoulderparted"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_shoulderpartedsmall
	name = "M'sai Shoulderparted Small"
	icon_state = "msai_shoulderpartedsmall"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_shoulderpartedlong
	name = "M'sai Shoulderparted Long"
	icon_state = "msai_shoulderpartedlong"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_sidepartedleft
	name = "M'sai Sideparted Left"
	icon_state = "msai_sidepartedleft"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_sidepartedright
	name = "M'sai Sideparted Right"
	icon_state = "msai_sidepartedright"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_shoulderlength
	name = "M'sai Shoulderlength"
	icon_state = "msai_shoulderlength"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_shoulderlengthalt
	name = "M'sai Shoulderlength Alt"
	icon_state = "msai_shoulderlengthalt"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_fringeup
	name = "M'sai Fringe Up"
	icon_state = "msai_fringeup"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_cascading
	name = "M'sai Cascading"
	icon_state = "msai_cascading"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_cascadingalt
	name = "M'sai Cascading Alt"
	icon_state = "msai_cascadingalt"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_swoop
	name = "M'sai Swoop"
	icon_state = "msai_swoop"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_swoop_alt
	name = "M'sai Swoop Alt"
	icon_state = "msai_swoop_alt"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_swoop_bangs
	name = "M'sai Swoop Bangs"
	icon_state = "msai_swoop_bangs"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_swoop_long
	name = "M'sai Swoop Long"
	icon_state = "msai_longswoop"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/msai_ears/msai_ears_swoop_long_alt
	name = "M'sai Swoop Long Alt"
	icon_state = "msai_longswoop_alt"
	length = 3
	chatname = "styled mane"

//tesla rejuvenation suit hair
/datum/sprite_accessory/hair/tesla_ears
	icon = 'icons/mob/human_face/tesla_body_hair.dmi'
	name = "Tesla Rejuvenation Suit Ears"
	icon_state = "ears_plain"
	length = 1
	species_allowed = list(/datum/species/tajaran/tesla_body)

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_bangs
	name = "Tesla Rejuvenation Suit Bangs"
	icon_state = "hair_bangs"
	length = 3
	chatname = "bangs"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_bangs_alt
	name = "Tesla Rejuvenation Suit Bangs Alt"
	icon_state = "hair_bangs_alt"
	length = 3
	chatname = "short bangs"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_shortfringe
	name = "Tesla Rejuvenation Suit Short Fringe"
	icon_state = "hair_shortfringe"
	length = 2
	chatname = "short fringe"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_bob
	name = "Tesla Rejuvenation Suit Bob"
	icon_state = "hair_bob"
	length = 2
	chatname = "groomed short mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_braid
	name = "Tesla Rejuvenation Suit Braid"
	icon_state = "hair_braid"
	length = 3
	chatname = "braid"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_braid_alt
	name = "Tesla Rejuvenation Suit Braid Alt"
	icon_state = "hair_braid_alt"
	length = 3
	chatname = "braid"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_clean
	name = "Tesla Rejuvenation Suit Clean"
	icon_state = "hair_clean"
	length = 1
	chatname = "short mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_curls
	name = "Tesla Rejuvenation Suit Curly"
	icon_state = "hair_curly"
	length = 3
	chatname = "curly mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_curlsalt
	name = "Tesla Rejuvenation Suit Curly Alt"
	icon_state = "hair_curlyalt"
	length = 3
	chatname = "curly mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_fingercurl
	name = "Tesla Rejuvenation Suit Finger Curls"
	icon_state = "hair_fingerwave"
	length = 2
	chatname = "curls"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_housewife
	name = "Tesla Rejuvenation Suit Housewife"
	icon_state = "hair_housewife"
	length = 2
	chatname = "long mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_long
	name = "Tesla Rejuvenation Suit Long"
	icon_state = "hair_long"
	length = 3
	chatname = "long mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_messy
	name = "Tesla Rejuvenation Suit Messy"
	icon_state = "hair_messy"
	length = 1
	chatname = "messy mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_mohawk
	name = "Tesla Rejuvenation Suit Mohawk"
	icon_state = "hair_mohawk"
	length = 1
	chatname = "mohawk"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_plait
	name = "Tesla Rejuvenation Suit Plait"
	icon_state = "hair_plait"
	length = 1
	chatname = "braid"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_rattail
	name = "Tesla Rejuvenation Suit Rat Tail"
	icon_state = "hair_rattail"
	length = 2
	chatname = "thin ponytail"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_shaggy
	name = "Tesla Rejuvenation Suit Shaggy"
	icon_state = "hair_shaggy"
	length = 1
	chatname = "messy mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_straight
	name = "Tesla Rejuvenation Suit Straight"
	icon_state = "hair_straight"
	length = 3
	chatname = "short mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_spiky
	name = "Tesla Rejuvenation Suit Spiky"
	icon_state = "hair_spiky"
	length = 1
	chatname = "spiky mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_victory
	name = "Tesla Rejuvenation Suit Victory Curls"
	icon_state = "hair_victory"
	length = 3
	chatname = "curls"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_mane
	name = "Tesla Rejuvenation Suit Mane"
	icon_state = "hair_mane"
	length = 3
	gender = MALE
	chatname = "long mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_sidepony
	name = "Tesla Rejuvenation Suit Side Ponytail"
	icon_state = "hair_sidepony"
	length = 3
	chatname = "sideponytail"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_governmentman
	name = "Tesla Rejuvenation Suit Government Man"
	icon_state = "hair_gman"
	length = 1
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_bun
	name = "Tesla Rejuvenation Suit Bun"
	icon_state = "hair_bun"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_smallbun
	name = "Tesla Rejuvenation Suit Bun (Small)"
	icon_state = "hair_bunsmall"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_lowbun
	name = "Tesla Rejuvenation Suit Bun (Low)"
	icon_state = "hair_lowbun"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_smalllowbun
	name = "Tesla Rejuvenation Suit Bun (Low, Small)"
	icon_state = "hair_lowbunsmall"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_bunshort
	name = "Tesla Rejuvenation Suit Bun (Short)"
	icon_state = "hair_bunshort"
	length = 2
	chatname = "hair bun"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_wedge
	name = "Tesla Rejuvenation Suit Wedge"
	icon_state = "hair_wedge"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_tresses
	name = "Tesla Rejuvenation Suit Tresses"
	icon_state = "hair_tresses"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_shoulderparted
	name = "Tesla Rejuvenation Suit Shoulder Parted"
	icon_state = "hair_shoulderparted"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_shoulderpartedsmall
	name = "Tesla Rejuvenation Suit Shoulder Parted Small"
	icon_state = "hair_shoulderpartedsmall"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_shoulderpartedlong
	name = "Tesla Rejuvenation Suit Shoulder Parted Long"
	icon_state = "hair_shoulderpartedlong"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_shoulderlength
	name = "Tesla Rejuvenation Suit Shoulderlength"
	icon_state = "hair_shoulderlength"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_shoulderlengthalt
	name = "Tesla Rejuvenation Suit Shoulderlength Alt"
	icon_state = "hair_shoulderlengthalt"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_sidepartedleft
	name = "Tesla Rejuvenation Suit Sideparted Left"
	icon_state = "hair_sidepartedleft"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_sidepartedright
	name = "Tesla Rejuvenation Suit Sideparted Right"
	icon_state = "hair_sidepartedright"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_fringeup
	name = "Tesla Rejuvenation Suit Fringe Up"
	icon_state = "hair_fringeup"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_cascading
	name = "Tesla Rejuvenation Suit Cascading"
	icon_state = "hair_cascading"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/taj_ears_cascadingalt
	name = "Tesla Rejuvenation Suit Cascading Alt"
	icon_state = "hair_cascadingalt"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/taj_ears_swoop
	name = "Tesla Rejuvenation Suit Swoop"
	icon_state = "hair_swoop"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_swoop_alt
	name = "Tesla Rejuvenation Suit Swoop Alt"
	icon_state = "hair_swoop_alt"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_swoop_bangs
	name = "Tesla Rejuvenation Suit Swoop Bangs"
	icon_state = "hair_swoop_bangs"
	length = 2
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_swoop_long
	name = "Tesla Rejuvenation Suit Swoop Long"
	icon_state = "hair_longswoop"
	length = 3
	chatname = "styled mane"

/datum/sprite_accessory/hair/tesla_ears/tesla_ears_swoop_long_alt
	name = "Tesla Rejuvenation Suit Swoop Long Alt"
	icon_state = "hair_longswoop_alt"
	length = 3
	chatname = "styled mane"

//vaurca antennae
/datum/sprite_accessory/hair/vaurca_classic
	icon = 'icons/mob/human_face/vaurca_hair.dmi'
	name = "Classic Antennae"
	icon_state = "vaurca_classic"
	species_allowed = list(/datum/species/bug,/datum/species/bug/type_b)
	gender = NEUTER
	chatname = "antennae"

/datum/sprite_accessory/hair/vaurca_classic/vaurca_braided
	name = "Braided Antennae"
	icon_state = "vaurca_braided"
	chatname = "antennae"
	length = 3

/datum/sprite_accessory/hair/vaurca_classic/vaurca_catfish
	name = "Catfish Antennae"
	icon_state = "vaurca_catfish"
	chatname = "antennae"
	length = 2

/datum/sprite_accessory/hair/vaurca_classic/vaurca_dipole
	name = "Dipole Antennae"
	icon_state = "vaurca_dipole"
	chatname = "antennae"
	length = 2

/datum/sprite_accessory/hair/vaurca_classic/vaurca_droop
	name = "Droopy Antennae"
	icon_state = "vaurca_droop"
	chatname = "antennae"
	length = 2

/datum/sprite_accessory/hair/vaurca_classic/vaurca_fla
	name = "Floor Length Antennae"
	icon_state = "vaurca_fla"
	chatname = "long antennae"
	length = 4

/datum/sprite_accessory/hair/vaurca_classic/vaurca_formic
	name = "Formic Antennae"
	icon_state = "vaurca_formic"
	chatname = "antennae"
	length = 2

/datum/sprite_accessory/hair/vaurca_classic/vaurca_damaged_left
	name = "Injured Antenna, Left"
	icon_state = "vaurca_inj_left"
	chatname = "antenna"
	length = 1

/datum/sprite_accessory/hair/vaurca_classic/vaurca_damaged_right
	name = "Injured Antenna, Right"
	icon_state = "vaurca_inj_right"
	chatname = "antenna"
	length = 1

/datum/sprite_accessory/hair/vaurca_classic/vaurca_knight
	name = "Knight Antennae"
	icon_state = "vaurca_knight"
	chatname = "antennae"
	length = 2

/datum/sprite_accessory/hair/vaurca_classic/vaurca_mid
	name = "Mid Length Antennae"
	icon_state = "vaurca_mid"
	chatname = "antennae"
	length = 2

/datum/sprite_accessory/hair/vaurca_classic/vaurca_parabolic
	name = "Parabolic Antennae"
	icon_state = "vaurca_parabolic"
	chatname = "antennae"
	length = 2

/datum/sprite_accessory/hair/vaurca_classic/vaurca_zappy
	name = "Zappy Antennae"
	icon_state = "vaurca_zappy"
	chatname = "antennae"
	length = 2

//Bulwark antennae
/datum/sprite_accessory/hair/bulwark_classic
	icon = 'icons/mob/human_face/bulwark_hair.dmi'
	name = "Bulwark Classic Antennae"
	icon_state = "bully_classic"
	species_allowed = list(/datum/species/bug/type_e)
	gender = NEUTER
	chatname = "antennae"

/datum/sprite_accessory/hair/bulwark_classic/bulwark_damaged_left
	name = "Bulwark Injured Antenna, Left"
	icon_state = "bully_inj_left"
	chatname = "antenna"
	length = 1

/datum/sprite_accessory/hair/bulwark_classic/bulwark_damaged_right
	name = "Bulwark Injured Antenna, Right"
	icon_state = "bully_inj_right"
	chatname = "antenna"
	length = 1

/datum/sprite_accessory/hair/bulwark_classic/bulwark_knight
	name = "Bulwark Knight Antennae"
	icon_state = "bully_knight"
	chatname = "antennae"
	length = 2

/datum/sprite_accessory/hair/bulwark_classic/bulwark_pointy
	name = "Pointy Antennae"
	icon_state = "bully_pointy"
	chatname = "antennae"
	length = 2

/datum/sprite_accessory/hair/bulwark_classic/bulwark_original
	name = "Original Antennae"
	icon_state = "bully_original"
	chatname = "antennae"
	length = 2

/datum/sprite_accessory/hair/bulwark_classic/bulwark_islero
	name = "Islero Antennae"
	icon_state = "bully_islero"
	chatname = "antennae"
	length = 3

/datum/sprite_accessory/hair/bulwark_classic/bulwark_tall
	name = "Tall Antennae"
	icon_state = "bully_tall"
	chatname = "antennae"
	length = 4

/datum/sprite_accessory/hair/bulwark_classic/bulwark_stag
	name = "Stag Antennae"
	icon_state = "bully_stag"
	chatname = "antennae"
	length = 5

/datum/sprite_accessory/hair/bulwark_classic/bulwark_rhino
	name = "Rhinoceros Antenna"
	icon_state = "bully_rhino"
	chatname = "antenna"
	length = 5

/datum/sprite_accessory/hair/bulwark_classic/bulwark_ladybug
	name = "Ladybug Antennae"
	icon_state = "bully_ladybug"
	chatname = "antennae"
	length = 6

//Breeder antennae
/datum/sprite_accessory/hair/breeder_standard
	icon = 'icons/mob/human_face/breeder_hair.dmi'
	name = "Breeder Standard Antennae"
	icon_state = "breeder_standard"
	species_allowed = list(/datum/species/bug/type_c)
	gender = NEUTER
	chatname = "antennae"
	length = 3

/datum/sprite_accessory/hair/breeder_standard/breeder_quad
	name = "Breeder Quad Antennae"
	icon_state = "breeder_quad"
	length = 3

/datum/sprite_accessory/hair/breeder_standard/breeder_crownedcrest
	name = "Breeder Crowned Crest"
	icon_state = "breeder_crownedcrest"
	length = 1

/datum/sprite_accessory/hair/breeder_standard/breeder_hammerhead
	name = "Breeder Hammerhead"
	icon_state = "breeder_hammerhead"
	length = 1

/datum/sprite_accessory/hair/breeder_standard/breeder_princess
	name = "Breeder Princess Antennae"
	icon_state = "breeder_princess"
	length = 2

/datum/sprite_accessory/facial_hair/taj_goatee
	icon = 'icons/mob/human_face/tajara_facial_hair.dmi'
	name = "Tajara Goatee"
	icon_state = "facial_goatee"
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/facial_hair/taj_goatee/taj_goatee_faded
	name = "Tajara Goatee Faded"
	icon_state = "facial_goatee_faded"

/datum/sprite_accessory/facial_hair/taj_goatee/taj_moustache
	name = "Tajara Moustache"
	icon_state = "facial_moustache"

/datum/sprite_accessory/facial_hair/taj_goatee/taj_mutton
	name = "Tajara Mutton"
	icon_state = "facial_mutton"

/datum/sprite_accessory/facial_hair/taj_goatee/taj_pencilstache
	name = "Tajara Pencilstache"
	icon_state = "facial_pencilstache"

/datum/sprite_accessory/facial_hair/taj_goatee/taj_sideburns
	name = "Tajara Sideburns"
	icon_state = "facial_sideburns"

/datum/sprite_accessory/facial_hair/taj_goatee/taj_smallstache
	name = "Tajara Smallsatche"
	icon_state = "facial_smallstache"


/datum/sprite_accessory/facial_hair/tesla_body_goatee
	icon = 'icons/mob/human_face/tesla_body_facial_hair.dmi'
	name = "Tesla Rejuvenation Suit Goatee"
	icon_state = "facial_goatee"
	species_allowed = list(/datum/species/tajaran/tesla_body)

/datum/sprite_accessory/facial_hair/tesla_body_goatee/tesla_body_goatee_faded
	name = "Tesla Rejuvenation Suit Goatee Faded"
	icon_state = "facial_goatee_faded"

/datum/sprite_accessory/facial_hair/tesla_body_goatee/tesla_body_moustache
	name = "Tesla Rejuvenation Suit Moustache"
	icon_state = "facial_moustache"

/datum/sprite_accessory/facial_hair/tesla_body_goatee/tesla_body_mutton
	name = "Tesla Rejuvenation Suit Mutton"
	icon_state = "facial_mutton"

/datum/sprite_accessory/facial_hair/tesla_body_goatee/tesla_body_pencilstache
	name = "Tesla Rejuvenation Suit Pencilstache"
	icon_state = "facial_pencilstache"

/datum/sprite_accessory/facial_hair/tesla_body_goatee/tesla_body_sideburns
	name = "Tesla Rejuvenation Suit Sideburns"
	icon_state = "facial_sideburns"

/datum/sprite_accessory/facial_hair/tesla_body_goatee/tesla_body_smallstache
	name = "Tesla Rejuvenation Suit Smallsatche"
	icon_state = "facial_smallstache"

//unathi horn beards and the like

/datum/sprite_accessory/facial_hair/una_aquaticfrill
	icon = 'icons/mob/human_face/unathi_hair.dmi'
	name = "Unathi Aquatic Frills"
	icon_state = "facial_aquaticfrills"
	species_allowed = list(/datum/species/unathi,/datum/species/zombie/unathi)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_bighorns
	name = "Unathi Big Horns"
	icon_state = "facial_bighorn"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_bob
	name = "Bob"
	icon_state = "facial_bob"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_bobcurl
	name = "Bobcurl"
	icon_state = "facial_bobcurl"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_buzzcut
	name = "Buzzcut"
	icon_state = "facial_buzzcut"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_buzzcut2
	name = "Buzzcut 2"
	icon_state = "facial_buzzcut2"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_chinhorn
	name = "Unathi Chin Horn"
	icon_state = "facial_chinhorns"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_curlhorn
	name = "Unathi Curled Horns"
	icon_state = "facial_curledhorn"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_dorsalfrill
	name = "Unathi Dorsal Frill"
	icon_state = "facial_dorsalfrill"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_dracfrills
	name = "Unathi Draconic Frills"
	icon_state = "facial_dracfrills"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_drachorn
	name = "Unathi Draconic Horns"
	icon_state = "facial_drachorn"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_hornadorns
	name = "Unathi Horn Adorns"
	icon_state = "facial_hornadorns"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_longdorsal
	name = "Unathi Long Dorsal Frill"
	icon_state = "facial_longdorsal"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_longfrill
	name = "Unathi Long Frills"
	icon_state = "facial_longfrills"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_longfrill2
	name = "Unathi Long Frills 2"
	icon_state = "facial_longfrills2"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_longspines
	name = "Unathi Long Spines"
	icon_state = "facial_longspines"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_lowerhorn
	name = "Unathi Lower Horns"
	icon_state = "facial_lowerhorn"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_mohawk
	name = "Unathi Mohawk"
	icon_state = "facial_mohawk"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_ramhornshort
	name = "Unathi Short Ram Horns"
	icon_state = "facial_ramhorn"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_ramhornlong
	name = "Unathi Long Ram Horns"
	icon_state = "facial_ramhorn2"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_shortfrill
	name = "Unathi Short Frills"
	icon_state = "facial_shortfrills"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_shortfrill2
	name = "Unathi Short Frills 2"
	icon_state = "facial_shortfrills2"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_shorthorn
	name = "Unathi Short Horns"
	icon_state = "facial_shorthorn"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_shortspines
	name = "Unathi Short Spines"
	icon_state = "facial_shortspines"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_sidefrills
	name = "Unathi Side Frills"
	icon_state = "facial_sidefrills"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_spiky
	name = "Spiky"
	icon_state = "facial_spiky"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_horns
	name = "Unathi Horns"
	icon_state = "facial_simplehorn"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_smallhorns
	name = "Unathi Small Horns"
	icon_state = "facial_smallhorn"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_spikehorn
	name = "Unathi Spike Horns"
	icon_state = "facial_spikehorn"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_swepthorns
	name = "Unathi Swept-Forward Horns"
	icon_state = "facial_swepthorn"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_swepthorns2
	name = "Unathi Swept-Forward Horns 2"
	icon_state = "facial_swepthorn2"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_demonforward
	name = "Unathi Forward Demon Horns"
	icon_state = "facial_demonforward"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_bullhorns
	name = "Unathi Bull Horns"
	icon_state = "facial_bullhorn"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_longhorns
	name = "Unathi Long Bull Horns"
	icon_state = "facial_longhorn"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_faun
	name = "Unathi Faun Horns"
	icon_state = "facial_faun"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_double
	name = "Unathi Double Horns"
	icon_state = "facial_dubhorns"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_hood
	name = "Unathi Cobra Hood"
	icon_state = "facial_hood"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_skewers
	name = "Unathi Super Long Horns"
	icon_state = "facial_skewers"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_chameleon
	name = "Unathi Chameleon Horns"
	icon_state = "facial_chameleon"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_dilocrest
	name = "Unathi Dilo Crest"
	icon_state = "dilocrest"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_monocrest
	name = "Unathi Mono Crest"
	icon_state = "monocrest"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_cryocrest
	name = "Unathi Cryo Crest"
	icon_state = "cryocrest"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_corycrest
	name = "Unathi Cory Crest"
	icon_state = "corycrest"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_albertahorns
	name = "Unathi Alberta Horns"
	icon_state = "albertahorns"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_styrahorn
	name = "Unathi Styra Horn"
	icon_state = "styrahorn"
/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_styracrest
	name = "Unathi Styra Frill"
	icon_state = "styrafrill"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_pachyboss
	name = "Unathi Pachy Boss"
	icon_state = "pachylump"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_droopy
	name = "Unathi Droopy Dorsal Frill"
	icon_state = "unathi_droopydorsal"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_regal
	name = "Unathi Regal Frills"
	icon_state = "unathi_regalfrills"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_hornsbusted
	name = "Unathi Horns-Busted"
	icon_state = "unathi_simplehornbusted"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_ramhornshortbusted
	name = "Unathi Short Ram Horns-Busted"
	icon_state = "unathi_ramhornbusted"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_shorthornbusted
	name = "Unathi Short Horns-Busted"
	icon_state = "unathi_shorthornbusted"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_drachornbusted
	name = "Unathi Draconic Horns-Busted"
	icon_state = "unathi_drachornbusted"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_shortfrill2busted
	name = "Unathi Short Frills 2-Busted"
	icon_state = "unathi_shortfrills2busted"

/datum/sprite_accessory/facial_hair/una_aquaticfrill/una_styrahornbusted
	name = "Unathi Styra Horn-Busted"
	icon_state = "styrahornbusted"

//ipc screens

/datum/sprite_accessory/facial_hair/ipc_screen_blank
	icon = 'icons/mob/human_face/ipc_screens.dmi'
	name = "blank IPC screen"
	icon_state = "ipc_blank"
	species_allowed = list(/datum/species/machine)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_blue
	name = "blue IPC screen"
	icon_state = "ipc_blue"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_breakout
	name = "breakout IPC screen"
	icon_state = "ipc_breakout"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_cancel
	name = "cancel IPC screen"
	icon_state = "ipc_cancel"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_console
	name = "console IPC screen"
	icon_state = "ipc_console"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_database
	name = "database IPC screen"
	icon_state = "ipc_database"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_eight
	name = "eight IPC screen"
	icon_state = "ipc_eight"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_eye
	name = "eye IPC screen"
	icon_state = "ipc_eye"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_goggles
	name = "goggles IPC screen"
	icon_state = "ipc_goggles"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_gol_glider
	name = "GoL glider IPC screen"
	icon_state = "ipc_gol_glider"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_green
	name = "green IPC screen"
	icon_state = "ipc_green"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_heart
	name = "heart IPC screen"
	icon_state = "ipc_heart"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_heartrate
	name = "heartrate IPC screen"
	icon_state = "ipc_heartrate"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_lumi_eyes
	name = "lumi eyes IPC screen"
	icon_state = "ipc_lumi_eyes"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_monoeye
	name = "monoeye IPC screen"
	icon_state = "ipc_monoeye"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_scren_music
	name = "music IPC screen"
	icon_state = "ipc_music"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_nature
	name = "nature IPC screen"
	icon_state = "ipc_nature"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_orange
	name = "orange IPC screen"
	icon_state = "ipc_orange"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_pink
	name = "pink IPC screen"
	icon_state = "ipc_pink"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_purple
	name = "purple IPC screen"
	icon_state = "ipc_purple"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_rainbow
	name = "rainbow IPC screen"
	icon_state = "ipc_rainbow"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_red
	name = "red IPC screen"
	icon_state = "ipc_red"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_rgb
	name = "RGB IPC screen"
	icon_state = "ipc_rgb"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_scroll
	name = "scroll IPC screen"
	icon_state = "ipc_scroll"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_shower
	name = "shower IPC screen"
	icon_state = "ipc_shower"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_smiley
	name = "smiley IPC screen"
	icon_state = "ipc_smiley"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_static
	name = "static IPC screen"
	icon_state = "ipc_static"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_static2
	name = "static2 IPC screen"
	icon_state = "ipc_static2"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_static3
	name = "static3 IPC screen"
	icon_state = "ipc_static3"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_testcard
	name = "testcard IPC screen"
	icon_state = "ipc_testcard"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_waiting
	name = "waiting IPC screen"
	icon_state = "ipc_waiting"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_yellow
	name = "yellow IPC screen"
	icon_state = "ipc_yellow"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_nanotrasen
	name = "nanotrasen IPC screen"
	icon_state = "ipc_nt"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_hephaestus
	name = "hephaestus IPC screen"
	icon_state = "ipc_heph"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_idris
	name = "idris IPC screen"
	icon_state = "ipc_idris"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_zavodskoi
	name = "zavodskoi IPC screen"
	icon_state = "ipc_zavod"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_zenghu
	name = "zeng-hu IPC screen"
	icon_state = "ipc_zenghu"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_scc
	name = "scc IPC screen"
	icon_state = "ipc_scc"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_biesel
	name = "republic of biesel IPC screen"
	icon_state = "ipc_biesel"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_sol
	name = "sol alliance IPC screen"
	icon_state = "ipc_sol"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_coalition
	name = "coalition of colonies IPC screen"
	icon_state = "ipc_coc"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_elyra
	name = "republic of elyra IPC screen"
	icon_state = "ipc_elyra"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_eridani
	name = "eridani IPC screen"
	icon_state = "ipc_eridani"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_burzsia
	name = "burzsia IPC screen"
	icon_state = "ipc_burzsia"

/datum/sprite_accessory/facial_hair/ipc_screen_blank/ipc_screen_tp
	name = "trinary perfection IPC screen"
	icon_state = "ipc_tp"

/datum/sprite_accessory/facial_hair/diona_eye
	icon = 'icons/mob/human_face/dionae_hair.dmi'
	name = "Mono Eye"
	icon_state = "monoeye"
	species_allowed = list(/datum/species/diona, /datum/species/diona/coeu)
	gender = NEUTER
	do_colouration = FALSE

/datum/sprite_accessory/facial_hair/diona_eye/trioptics
	name = "Trioptics"
	icon_state = "trioptics"

/datum/sprite_accessory/facial_hair/diona_eye/lopsided
	name = "Lopsided Eyes"
	icon_state = "lopsided"

/datum/sprite_accessory/facial_hair/diona_eye/helmethead
	name = "Helmethead"
	icon_state = "helmethead"

/datum/sprite_accessory/facial_hair/diona_eye/eyestalk
	name = "Eyestalk"
	icon_state = "eyestalk"

/datum/sprite_accessory/facial_hair/diona_eye/treebeard
	name = "Treebeard"
	icon_state = "treebeard"

/datum/sprite_accessory/facial_hair/diona_eye/bug_eyes
	name = "Bug Eyes"
	icon_state = "bugeyes"

/datum/sprite_accessory/facial_hair/diona_eye/human_eyes
	name = "Human Eyes"
	icon_state = "humaneyes"

/datum/sprite_accessory/facial_hair/diona_eye/skrell_eyes
	name = "Skrell Eyes"
	icon_state = "skrelleyes"

/datum/sprite_accessory/facial_hair/diona_eye/skrell_eyes_2
	name = "Skrell Eyes 2"
	icon_state = "skrelleyes2"

/datum/sprite_accessory/facial_hair/diona_eye/tiny_eye
	name = "Tiny Eye"
	icon_state = "tinyeye"

/datum/sprite_accessory/facial_hair/diona_eye/eyebrow
	name = "Eyebrow"
	icon_state = "eyebrow"

/datum/sprite_accessory/facial_hair/diona_eye/blinkinghelmethead
	name = "Blinking Helmethead"
	icon_state = "blinkinghelmethead"

/datum/sprite_accessory/facial_hair/diona_eye/periscope
	name = "Periscope"
	icon_state = "periscope"

/datum/sprite_accessory/facial_hair/diona_eye/glorp
	name = "Glorp"
	icon_state = "glorp"

/datum/sprite_accessory/facial_hair/tuux_whiskers
	icon = 'icons/mob/human_face/skrell_beards.dmi'
	name = "Tuux Tentacle Whiskers"
	icon_state = "Tuux_Whiskers"
	species_allowed = list(/datum/species/skrell, /datum/species/skrell/axiori)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/tuux_whiskers_chin
	icon = 'icons/mob/human_face/skrell_beards.dmi'
	name = "Tuux Tentacle Whiskers w/Chin"
	icon_state = "Tuux_Whiskers_Chin"
	species_allowed = list(/datum/species/skrell, /datum/species/skrell/axiori)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/tuux_patch
	icon = 'icons/mob/human_face/skrell_beards.dmi'
	name = "Tuux Chin Patch"
	icon_state = "Tuux_Patch"
	species_allowed = list(/datum/species/skrell, /datum/species/skrell/axiori)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_goatee
	name = "Tuux Goatee"
	icon_state = "Tuux_Goatee"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_tri_point
	name = "Tuux Tri-Point"
	icon_state = "Tuux_Tri-Point"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_strap
	name = "Tuux Chin Strap"
	icon_state = "Tuux_Strap"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_monotail
	name = "Tuux Monotail"
	icon_state = "Tuux_Monotail"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_monotail_long
	name = "Tuux Monotail (Long)"
	icon_state = "Tuux_Monotail_Long"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_full
	name = "Tuux Full Beard"
	icon_state = "Tuux_Full"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_chops
	name = "Tuux Chops"
	icon_state = "Tuux_Chops"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_chops_big
	name = "Tuux Chops (Big)"
	icon_state = "Tuux_Chops_Big"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_adorns
	name = "Tuux Face Adorns"
	icon_state = "Tuux_Adorns"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_handlebar
	name = "Tuux Handlebar"
	icon_state = "Tuux_Handlebar"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_fumanchu
	name = "Tuux FuManChu"
	icon_state = "Tuux_FuManChu"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_overeye_left
	name = "Tuux Overeye (Left)"
	icon_state = "Tuux_Overeye_Left"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_overeye_right
	name = "Tuux Overeye (Right)"
	icon_state = "Tuux_Overeye_Right"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_mustache
	name = "Tuux Stache"
	icon_state = "Tuux_Mustache"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_overgrown
	name = "Tuux Overgrown"
	icon_state = "Tuux_Overgrown"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_braided
	name = "Tuux Braided"
	icon_state = "Tuux_Braided"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_braided_long
	name = "Tuux Braided (Long)"
	icon_state = "Tuux_Braided_Long"

/datum/sprite_accessory/facial_hair/tuux_patch/tuux_braided_double
	name = "Tuux Braided (Double)"
	icon_state = "Tuux_Braided_Double"

//Vaurca mandibles
/datum/sprite_accessory/facial_hair/clicky
	icon = 'icons/mob/human_face/vaurca_facial_hair.dmi'
	name = "Clicky Mandibles"
	icon_state = "vaurca_clicky"
	species_allowed = list(/datum/species/bug/type_b)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/clicky/clacky
	name = "Clacky Mandibles"
	icon_state = "vaurca_clacky"

/datum/sprite_accessory/facial_hair/clicky/bulldog
	name = "Bulldog Mandibles"
	icon_state = "vaurca_bulldog"

/datum/sprite_accessory/facial_hair/clicky/mantis
	name = "Mantis Mandibles"
	icon_state = "vaurca_mantis"

/datum/sprite_accessory/facial_hair/clicky/stag
	name = "Stag Mandibles"
	icon_state = "vaurca_stag"

/datum/sprite_accessory/facial_hair/clicky/ectatomma
	name = "Ectatomma Mandibles"
	icon_state = "vaurca_ectatomma"

/datum/sprite_accessory/facial_hair/clicky/horridus
	name = "Horridus Mandibles"
	icon_state = "vaurca_horridus"

/datum/sprite_accessory/facial_hair/clicky/tusks
	name = "Tusk Mandibles"
	icon_state = "vaurca_tusks"

/datum/sprite_accessory/facial_hair/clicky/acanthognathus
	name = "Acanthognathus Mandibles"
	icon_state = "vaurca_acanthognathus"

/datum/sprite_accessory/facial_hair/clicky/myrmoteras
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

/datum/sprite_accessory/marking/bandage_head
	name = "Bandage, head 1"
	icon_state = "bandage1"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
	is_genetic = FALSE

/datum/sprite_accessory/marking/bandage_head/head_2
	name = "Bandage, head 2"
	icon_state= "bandage2"

/datum/sprite_accessory/marking/bandage_head/head_3
	name = "Bandage, head 3"
	icon_state= "bandage3"

/datum/sprite_accessory/marking/bandage_chest
	name = "Bandage, chest 1"
	icon_state = "bandage1"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
	is_genetic = FALSE

/datum/sprite_accessory/marking/bandage_chest/chest_2
	name= "Bandage, chest 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage_chest/chest_3
	name= "Bandage, chest 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage_groin
	name = "Bandage, groin 1"
	icon_state = "bandage1"
	body_parts = list(BP_GROIN)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
	is_genetic = FALSE

/datum/sprite_accessory/marking/bandage_groin/groin_2
	name= "Bandage, groin 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage_groin/groin_3
	name= "Bandage, groin 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage_l_arm
	name = "Bandage, left arm 1"
	icon_state = "bandage1"
	body_parts = list(BP_L_ARM)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
	is_genetic = FALSE

/datum/sprite_accessory/marking/bandage_l_arm/l_arm_2
	name= "Bandage, left arm 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage_l_arm/l_arm_3
	name= "Bandage, left arm 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage_l_hand
	name = "Bandage, left hand 1"
	icon_state = "bandage1"
	body_parts = list(BP_L_HAND)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
	is_genetic = FALSE

/datum/sprite_accessory/marking/bandage_l_hand/l_hand_2
	name= "Bandage, left hand 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage_l_hand/l_hand_3
	name= "Bandage, left hand 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage_r_arm
	name = "Bandage, right arm 1"
	icon_state = "bandage1"
	body_parts = list(BP_R_ARM)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
	is_genetic = FALSE

/datum/sprite_accessory/marking/bandage_r_arm/r_arm_2
	name= "Bandage, right arm 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage_r_arm/r_arm_3
	name= "Bandage, right arm 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage_r_hand
	name = "Bandage, right hand 1"
	icon_state = "bandage1"
	body_parts = list(BP_R_HAND)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
	is_genetic = FALSE

/datum/sprite_accessory/marking/bandage_r_hand/r_hand_2
	name= "Bandage, right hand 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage_r_hand/r_hand_3
	name= "Bandage, right hand 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage_l_leg
	name = "Bandage, left leg 1"
	icon_state = "bandage1"
	body_parts = list(BP_L_LEG)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
	is_genetic = FALSE

/datum/sprite_accessory/marking/bandage_l_leg/l_leg_2
	name= "Bandage, left leg 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage_l_leg/l_leg_3
	name= "Bandage, left leg 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage_l_foot
	name = "Bandage, left foot 1"
	icon_state = "bandage1"
	body_parts = list(BP_L_FOOT)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
	is_genetic = FALSE

/datum/sprite_accessory/marking/bandage_l_foot/l_foot_2
	name= "Bandage, left foot 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage_l_foot/l_foot_3
	name= "Bandage, left foot 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage_r_leg
	name = "Bandage, right leg 1"
	icon_state = "bandage1"
	body_parts = list(BP_R_LEG)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
	is_genetic = FALSE

/datum/sprite_accessory/marking/bandage_r_leg/r_leg_2
	name= "Bandage, right leg 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage_r_leg/r_leg_3
	name= "Bandage, right leg 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage_r_foot
	name = "Bandage, right foot 1"
	icon_state = "bandage1"
	body_parts = list(BP_R_FOOT)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/skrell, /datum/species/skrell/axiori)
	is_genetic = FALSE

/datum/sprite_accessory/marking/bandage_r_foot/r_foot_2
	name= "Bandage, right foot 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage_r_foot/r_foot_3
	name= "Bandage, right foot 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/heterochromia
	name = "Heterochromia (Right eye)"
	icon_state = "heterochromia"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/aug_scalpports
	name = "Augment (Scalp Ports)"
	icon_state = "aug_scalpports"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/aug_scalpports/vertex_left
	name = "Augment (Scalp Port, Vertex Left)"
	icon_state = "aug_vertexport_l"

/datum/sprite_accessory/marking/aug_scalpports/vertex_right
	name = "Augment (Scalp Port, Vertex Right)"
	icon_state = "aug_vertexport_r"

/datum/sprite_accessory/marking/aug_scalpports/occipital_left
	name = "Augment (Scalp Port, Occipital Left)"
	icon_state = "aug_occipitalport_l"

/datum/sprite_accessory/marking/aug_scalpports/occipital_right
	name = "Augment (Scalp Port, Occipital Right)"
	icon_state = "aug_occipitalport_r"

/datum/sprite_accessory/marking/aug_scalpportsdiode
	name = "Augment (Scalp Ports Diode)"
	icon_state = "aug_scalpportsdiode"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/aug_scalpportsdiode/vertex_left
	name = "Augment (Scalp Port Diode, Vertex Left )"
	icon_state = "aug_vertexportdiode_l"

/datum/sprite_accessory/marking/aug_scalpportsdiode/vertex_right
	name = "Augment (Scalp Port Diode, Vertex Right)"
	icon_state = "aug_vertexportdiode_r"

/datum/sprite_accessory/marking/aug_scalpportsdiode/occipital_left
	name = "Augment (Scalp Port Diode, Occipital Left)"
	icon_state = "aug_occipitalportdiode_l"

/datum/sprite_accessory/marking/aug_scalpportsdiode/occipital_right
	name = "Augment (Scalp Port Diode, Occipital Right)"
	icon_state = "aug_occipitalportdiode_r"

/datum/sprite_accessory/marking/aug_backside_left
	name = "Augment (Backside Left, Head)"
	icon_state = "aug_backside_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/aug_backside_left/side_diode
	name = "Augment (Backside Left Diode, Head)"
	icon_state = "aug_sidediode_l"

/datum/sprite_accessory/marking/aug_backside_right
	name = "Augment (Backside Right, Head)"
	icon_state = "aug_backside_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/aug_backside_right/side_diode
	name = "Augment (Backside Right Diode, Head)"
	icon_state = "aug_sidediode_r"

/datum/sprite_accessory/marking/aug_side_deunan_left
	name = "Augment (Deunan, Side Left)"
	icon_state = "aug_sidedeunan_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/aug_side_deunan_right
	name = "Augment (Deunan, Side Right)"
	icon_state = "aug_sidedeunan_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/aug_side_kuze_left
	name = "Augment (Kuze, Side Left)"
	icon_state = "aug_sidekuze_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/aug_side_kuze_left/side_diode
	name = "Augment (Kuze Diode, Side Left)"
	icon_state = "aug_sidekuzediode_l"

/datum/sprite_accessory/marking/aug_side_kuze_right
	name = "Augment (Kuze, Side Right)"
	icon_state = "aug_sidekuze_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/aug_side_kuze_right/side_diode
	name = "Augment (Kuze Diode, Side Right)"
	icon_state = "aug_sidekuzediode_r"

/datum/sprite_accessory/marking/aug_side_kinzie_left
	name = "Augment (Kinzie, Side Left)"
	icon_state = "aug_sidekinzie_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/aug_side_kinzie_right
	name = "Augment (Kinzie, Side Right)"
	icon_state = "aug_sidekinzie_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/aug_side_shelly_left
	name = "Augment (Shelly, Side Left)"
	icon_state = "aug_sideshelly_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/aug_side_shelly_right
	name = "Augment (Shelly, Side Right)"
	icon_state = "aug_sideshelly_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/aug_chestports
	name = "Augment (Chest Ports)"
	icon_state = "aug_chestports"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

/datum/sprite_accessory/marking/aug_abdomenports
	name = "Augment (Abdomen Ports)"
	icon_state = "aug_abdomenports"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

/datum/sprite_accessory/marking/aug_lowerjaw
	name = "Augment (Lower Jaw)"
	icon_state = "aug_lowerjaw"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/skrell,/datum/species/skrell/axiori,/datum/species/unathi)

/datum/sprite_accessory/marking/aug_headcase
	name = "Augment (Headcase)"
	icon_state = "aug_headcase"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/aug_headcaselight
	name = "Augment (Headcase, Light)"
	icon_state = "aug_headcaselight"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/vaurca_augs
	name = "Mecha Chest"
	icon = 'icons/mob/human_races/markings_vaurca.dmi'
	icon_state = "mecha_chest"
	do_colouration = FALSE
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/bug, /datum/species/bug/type_b)

/datum/sprite_accessory/marking/vaurca_augs/mecha_abdomen
	name = "Mecha Abdomen"
	icon_state = "mecha_abdomen"

/datum/sprite_accessory/marking/vaurca_augs/mecha_spine
	name = "Mecha Spine"
	icon_state = "mecha_spine"
	body_parts = list(BP_HEAD, BP_CHEST)

/datum/sprite_accessory/marking/vaurca_augs/chest_tubes
	name = "Chest Tubes"
	icon_state = "chest_tubes"

/datum/sprite_accessory/marking/vaurca_augs/chest_wires
	name = "Chest Wires"
	icon_state = "chest_wires"

/datum/sprite_accessory/marking/vaurca_augs/mecha_eye_b
	name = "Mecha Eye (Blue, Right)"
	icon_state = "mecha_eye_b_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vaurca_augs/mecha_eye_b/mecha_eye_b_l
	name = "Mecha Eye (Blue, Left)"
	icon_state = "mecha_eye_b_l"

/datum/sprite_accessory/marking/vaurca_augs/mecha_eye_b/mecha_eye_r_l
	name = "Mecha Eye (Red, Left)"
	icon_state = "mecha_eye_r_l"

/datum/sprite_accessory/marking/vaurca_augs/mecha_eye_b/mecha_eye_r_r
	name = "Mecha Eye (Red, Right)"
	icon_state = "mecha_eye_r_r"

/datum/sprite_accessory/marking/vaurca_augs/mecha_eye_b/mecha_eye_y_l
	name = "Mecha Eye (Yellow, Left)"
	icon_state = "mecha_eye_y_l"

/datum/sprite_accessory/marking/vaurca_augs/mecha_eye_b/mecha_eye_y_r
	name = "Mecha Eye (Yellow, Right)"
	icon_state = "mecha_eye_y_r"

/datum/sprite_accessory/marking/vaurca_augs/mecha_eye_b/mandible
	name = "Mecha Mandibles"
	icon_state = "mecha_mandibles"

/datum/sprite_accessory/marking/vaurca_augs/hand_panel_r
	name = "Hand Panel (Right)"
	icon_state = "hand_panel_r"
	body_parts = list(BP_R_HAND)

/datum/sprite_accessory/marking/vaurca_augs/hand_panel_l
	name = "Hand Panel (Left)"
	icon_state = "hand_panel_l"
	body_parts = list(BP_L_HAND)

/datum/sprite_accessory/marking/bulwark_augs
	icon = 'icons/mob/human_races/markings_vaurcae.dmi'
	name = "Mecha Eye L"
	icon_state = "mechaeyebully_l"
	do_colouration = FALSE
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/bug/type_e)

/datum/sprite_accessory/marking/bulwark_augs/mechaeyebully_r
	name = "Mecha Eye R"
	icon_state = "mechaeyebully_r"

/datum/sprite_accessory/marking/bulwark_augs/mechaeyeoverlaybully_l
	name = "Mecha Eye Overlay L"
	icon_state = "mechaeyeoverlaybully_l"

/datum/sprite_accessory/marking/bulwark_augs/mechaeyeoverlaybully_r
	name = "Mecha Eye Overlay R"
	icon_state = "mechaeyeoverlaybully_r"

/datum/sprite_accessory/marking/bulwark_augs/mechamandiblesbully
	name = "Mecha Mandibles (Bulwark)"
	icon_state = "mechamandiblesbully"

/datum/sprite_accessory/marking/bulwark_augs/mechamandiblesoverlaybully
	name = "Mecha Mandibles Overlay"
	icon_state = "mechamandiblesoverlaybully"

/datum/sprite_accessory/marking/bulwark_augs/visorbully
	name = "Visor"
	icon_state = "visorbully"

/datum/sprite_accessory/marking/bulwark_augs/visorbullyoverlay
	name = "Visor Overlay"
	icon_state = "visorbullyoverlay"

/datum/sprite_accessory/marking/bulwark_augs/spidereyesbully
	name = "Spider Eyes"
	icon_state = "spidereyesbully"

/datum/sprite_accessory/marking/bulwark_augs/spidereyesbullyoverlay
	name = "Spider Eyes Overlay"
	icon_state = "spidereyesbullyoverlay"

/datum/sprite_accessory/marking/bulwark_augs/mechamonoculusbully
	name = "Mecha Monoculus"
	icon_state = "mechamonoculusbully"

/datum/sprite_accessory/marking/bulwark_augs/mechamonoculusbullyoverlay
	name = "Mecha Monoculus Overlay"
	icon_state = "mechamonoculusbullyoverlay"

/datum/sprite_accessory/marking/bullybackmeter
	icon = 'icons/mob/human_races/markings_vaurcae.dmi'
	name = "Back Meter (Bulwark)"
	icon_state = "bullybackmeter"
	do_colouration = FALSE
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/bug/type_e)

/datum/sprite_accessory/marking/bullybackmeter/bullybackmeteroverlay
	name = "Back Meter Overlay"
	icon_state = "bullybackmeteroverlay"

/datum/sprite_accessory/marking/bullybackmeter/mechahorn_l
	name = "Mecha Horn L"
	icon_state = "mechahorn_l"

/datum/sprite_accessory/marking/bullybackmeter/mechahorn_r
	name = "Mecha Horn R"
	icon_state = "mechahorn_r"

/datum/sprite_accessory/marking/bullybackmeter/bullybackwires
	name = "Back Wires (Bulwark)"
	icon_state = "bullybackwires"

/datum/sprite_accessory/marking/bullybackmeter/bullybacktubes
	name = "Back Tubes (Bulwark)"
	icon_state = "bullybacktubes"

/datum/sprite_accessory/marking/bullybackmeter/ventsbully
	name = "Vents (Bulwark)"
	icon_state = "ventsbully"

/datum/sprite_accessory/marking/bullybackmeter/shellpanelbully
	name = "Shell Panel"
	icon_state = "shellpanelbully"

/datum/sprite_accessory/marking/mechakneesbully_l
	icon = 'icons/mob/human_races/markings_vaurcae.dmi'
	name = "Mecha Knees L"
	icon_state = "mechakneesbully_l"
	do_colouration = FALSE
	body_parts = list(BP_L_LEG)
	species_allowed = list(/datum/species/bug/type_e)

/datum/sprite_accessory/marking/mechakneesbully_r
	icon = 'icons/mob/human_races/markings_vaurcae.dmi'
	name = "Mecha Knees R"
	icon_state = "mechakneesbully_r"
	do_colouration = FALSE
	body_parts = list(BP_R_LEG)
	species_allowed = list(/datum/species/bug/type_e)

/datum/sprite_accessory/marking/mechaabdomenbully
	icon = 'icons/mob/human_races/markings_vaurcae.dmi'
	name = "Mecha Abdomen (Bulwark)"
	icon_state = "mechaabdomenbully"
	do_colouration = FALSE
	body_parts = list(BP_GROIN)
	species_allowed = list(/datum/species/bug/type_e)

/datum/sprite_accessory/marking/mechapelvisbully
	icon = 'icons/mob/human_races/markings_vaurcae.dmi'
	name = "Mecha Pelvis (Bulwark)"
	icon_state = "mechapelvisbully"
	do_colouration = FALSE
	body_parts = list(BP_GROIN)
	species_allowed = list(/datum/species/bug/type_e)

/datum/sprite_accessory/marking/handpanelbully_l
	icon = 'icons/mob/human_races/markings_vaurcae.dmi'
	name = "Hand Panel L"
	icon_state = "handpanelbully_l"
	do_colouration = FALSE
	body_parts = list(BP_L_HAND)
	species_allowed = list(/datum/species/bug/type_e)

/datum/sprite_accessory/marking/handpanelbully_r
	icon = 'icons/mob/human_races/markings_vaurcae.dmi'
	name = "Hand Panel R"
	icon_state = "handpanelbully_r"
	do_colouration = FALSE
	body_parts = list(BP_R_HAND)
	species_allowed = list(/datum/species/bug/type_e)

/datum/sprite_accessory/marking/handpanelbully_loverlay
	icon = 'icons/mob/human_races/markings_vaurcae.dmi'
	name = "Hand Panel L Overlay"
	icon_state = "handpanelbully_loverlay"
	do_colouration = FALSE
	body_parts = list(BP_L_HAND)
	species_allowed = list(/datum/species/bug/type_e)

/datum/sprite_accessory/marking/handpanelbully_roverlay
	icon = 'icons/mob/human_races/markings_vaurcae.dmi'
	name = "Hand Panel R Overlay"
	icon_state = "handpanelbully_roverlay"
	do_colouration = FALSE
	body_parts = list(BP_R_HAND)
	species_allowed = list(/datum/species/bug/type_e)

/datum/sprite_accessory/marking/armwirebully_l
	icon = 'icons/mob/human_races/markings_vaurcae.dmi'
	name = "Arm Wires L"
	icon_state = "armwirebully_l"
	do_colouration = FALSE
	body_parts = list(BP_L_ARM)
	species_allowed = list(/datum/species/bug/type_e)

/datum/sprite_accessory/marking/armwirebully_r
	icon = 'icons/mob/human_races/markings_vaurcae.dmi'
	name = "Arm Wires R"
	icon_state = "armwirebully_r"
	do_colouration = FALSE
	body_parts = list(BP_R_ARM)
	species_allowed = list(/datum/species/bug/type_e)

/datum/sprite_accessory/marking/armwirebullyhand_l
	icon = 'icons/mob/human_races/markings_vaurcae.dmi'
	name = "Hand Wires L"
	icon_state = "handwirebully_l"
	do_colouration = FALSE
	body_parts = list(BP_L_HAND)
	species_allowed = list(/datum/species/bug/type_e)

/datum/sprite_accessory/marking/armwiresbullyhand_r
	icon = 'icons/mob/human_races/markings_vaurcae.dmi'
	name = "Hand Wires R"
	icon_state = "handwirebully_r"
	do_colouration = FALSE
	body_parts = list(BP_R_HAND)
	species_allowed = list(/datum/species/bug/type_e)

/datum/sprite_accessory/marking/backstripe
	name = "Back Stripe"
	icon_state = "backstripe"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/backstripe/spinemarks
	name = "Back Stripe Marks"
	icon_state = "backstripemarks"

/datum/sprite_accessory/marking/bands
	name = "Color Bands (All)"
	icon_state = "bands"
	body_parts = list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_GROIN, BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/diona, /datum/species/diona/coeu, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/bands/chest
	name = "Color Bands (Torso)"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/bands/groin
	name = "Color Bands (Groin)"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/bands/left_arm
	name = "Color Bands (Left Arm)"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/bands/right_arm
	name = "Color Bands (Right Arm)"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/bands/left_hand
	name = "Color Bands (Left Hand)"
	body_parts = list(BP_L_HAND)

/datum/sprite_accessory/marking/bands/right_hand
	name = "Color Bands (Right Hand)"
	body_parts = list(BP_R_HAND)

/datum/sprite_accessory/marking/bands/left_leg
	name = "Color Bands (Left Leg)"
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/bands/right_leg
	name = "Color Bands (Right Leg)"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/bands/left_foot
	name = "Color Bands (Left Foot)"
	body_parts = list(BP_L_FOOT)
	species_allowed = list(/datum/species/unathi)

/datum/sprite_accessory/marking/bands/left_foot_human
	name = "Color Bands (Left Foot)"
	icon_state = "bandshuman"
	body_parts = list(BP_L_FOOT)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell)

/datum/sprite_accessory/marking/bands/right_foot
	name = "Color Bands (Right Foot)"
	body_parts = list(BP_R_FOOT)
	species_allowed = list(/datum/species/unathi)

/datum/sprite_accessory/marking/bands/right_foot_human
	name = "Color Bands (Right Foot)"
	icon_state = "bandshuman"
	body_parts = list(BP_R_FOOT)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell)

/datum/sprite_accessory/marking/bandsface
	name = "Color Bands (Face)"
	icon_state = "bandsface"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/bandsface_human
	name = "Color Bands (Face)"
	icon_state = "bandshumanface"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell)

/datum/sprite_accessory/marking/bindi
	name = "Bindi"
	icon_state = "bindi"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/machine/shell, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/blush
	name = "Blush"
	icon_state= "blush"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/cheekspot_left
	name = "Cheek Spot (Left Cheek)"
	icon_state = "cheekspot_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/cheekspot_right
	name = "Cheek Spot (Right Cheek)"
	icon_state = "cheekspot_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell,/datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/cheshire_left
	name = "Cheshire (Left Cheek)"
	icon_state = "cheshire_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori,)

/datum/sprite_accessory/marking/cheshire_right
	name = "Cheshire (Right Cheek)"
	icon_state = "cheshire_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori,)

/datum/sprite_accessory/marking/crow_left
	name = "Crow Mark (Left Eye)"
	icon_state = "crow_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/crow_right
	name = "Crow Mark (Right Eye)"
	icon_state = "crow_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/ear_left
	name = "Ear Cover (Left)"
	icon_state = "ear_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell)

/datum/sprite_accessory/marking/ear_right
	name = "Ear Cover (Right)"
	icon_state = "ear_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell)

/datum/sprite_accessory/marking/eyestripe
	name = "Eye Stripe"
	icon_state = "eyestripe"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/eyecorner_left
	name = "Eye Corner Left"
	icon_state = "eyecorner_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/eyecorner_right
	name = "Eye Corner Right"
	icon_state = "eyecorner_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/eyelash_left
	name = "Eyelash Left"
	icon_state = "eyelash_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/skrell/axiori, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/eyebrows
	name = "Eyebrows"
	icon_state = "eyebrows"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/skrell/axiori, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/unibrow
	name = "Unibrow"
	icon_state = "unibrow"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/skrell/axiori, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/eyelash_right
	name = "Eyelash Right"
	icon_state = "eyelash_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/skrell/axiori, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/lips
	name = "Lips"
	icon_state = "lips"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori)

/datum/sprite_accessory/marking/lipcorner_left
	name = "Lip Corner Left"
	icon_state = "lipcorner_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori)

/datum/sprite_accessory/marking/lipcorner_right
	name = "Lip Corner Right"
	icon_state = "lipcorner_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori)

/datum/sprite_accessory/marking/lowercheek_left
	name = "Lower Cheek Left"
	icon_state = "lowercheek_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori)

/datum/sprite_accessory/marking/lowercheek_right
	name = "Lower Cheek Right"
	icon_state = "lowercheek_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori,)

/datum/sprite_accessory/marking/neck
	name = "Neck Cover"
	icon_state = "neck"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/neckthick
	name = "Neck Cover (Thick)"
	icon_state = "neckthick"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/nosestripe
	name = "Nose Stripe"
	icon_state = "nosestripe"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

/datum/sprite_accessory/marking/nosetape
	name = "Nose Tape"
	icon_state = "nosetape"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/bug, /datum/species/bug/type_b)

/datum/sprite_accessory/marking/scar_chest
	name = "Scar, Chest"
	icon_state = "surgicalscar"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

/datum/sprite_accessory/marking/scar_chest_left
	name = "Scar, Chest Left"
	icon_state = "chestscar1"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

/datum/sprite_accessory/marking/scar_chest_right
	name = "Scar, Chest Right"
	icon_state = "chestscar2"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

/datum/sprite_accessory/marking/scratch_abdomen_left
	name = "Scratch, Abdomen Left"
	icon_state = "scratch_abdomen_l"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

/datum/sprite_accessory/marking/scratch_abdomen_right
	name = "Scratch, Abdomen Right"
	icon_state = "scratch_abdomen_r"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

/datum/sprite_accessory/marking/scratch_abdomen_small_left
	name = "Scratch, Abdomen Small Left"
	icon_state = "scratch_abdomensmall_l"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

/datum/sprite_accessory/marking/scratch_abdomen_small_right
	name = "Scratch, Abdomen Small Right"
	icon_state = "scratch_abdomensmall_r"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

/datum/sprite_accessory/marking/scratch_back
	name = "Scratch, Back"
	icon_state = "scratch_back"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi, /datum/species/bug, /datum/species/bug/type_b)

/datum/sprite_accessory/marking/scratch_chest_left
	name = "Scratch, Chest (Left)"
	icon_state = "scratch_chest_l"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/scratch_chest_right
	name = "Scratch, Chest (Right)"
	icon_state = "scratch_chest_r"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_belly
	name = "Tattoo (Belly)"
	icon_state = "tat_belly"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_campbell_leftarm
	name = "Tattoo (Campbell, Left Arm)"
	icon_state = "tat_campbell"
	body_parts = list(BP_L_ARM)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_campbell_rightarm
	name = "Tattoo (Campbell, Right Arm)"
	icon_state = "tat_campbell"
	body_parts= list(BP_R_ARM)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_campbell_leftleg
	name = "Tattoo (Campbell, Left Leg)"
	icon_state = "tat_campbell"
	body_parts= list(BP_L_LEG)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_campbell_rightleg
	name = "Tattoo (Campbell, Right Leg)"
	icon_state = "tat_campbell"
	body_parts= list(BP_R_LEG)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_circle_back
	name = "Tattoo (Circle, Back)"
	icon_state = "tat_circle"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_circle_big_back
	name = "Tattoo (Big Circle, Back)"
	icon_state = "tat_bigcircle"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_forrest_left
	name = "Tattoo (Forrest, Left Eye)"
	icon_state = "tat_forrest_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_forrest_right
	name = "Tattoo (Forrest, Right Eye)"
	icon_state = "tat_forrest_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_harness
	name = "Tattoo (Harness, Chest)"
	icon_state = "tat_harness"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_hive
	name = "Tattoo (Hive, Back)"
	icon_state = "tat_hive"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_heart_arm
	name = "Tattoo (Heart, Left Arm)"
	icon_state = "tat_lheart"
	body_parts = list(BP_L_ARM)
	species_allowed = list(/datum/species/human, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_heart_arm/right
	name = "Tattoo (Heart, Right Arm)"
	icon_state = "tat_rheart"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tat_heart_back
	name = "Tattoo (Heart, Lower Back)"
	icon_state = "tat_heartback"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell)

/datum/sprite_accessory/marking/tat_hunter_left
	name = "Tattoo (Hunter, Left Eye)"
	icon_state = "tat_hunter_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_hunter_right
	name = "Tattoo (Hunter, Right Eye)"
	icon_state = "tat_hunter_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_jaeger_left
	name = "Tattoo (Jaeger, Left Eye)"
	icon_state = "tat_jaeger_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_jaeger_right
	name = "Tattoo (Jaeger, Right Eye)"
	icon_state = "tat_jaeger_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_kater_left
	name = "Tattoo (Kater, Left Eye)"
	icon_state = "tat_kater_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_kater_right
	name = "Tattoo (Kater, Right Eye)"
	icon_state = "tat_kater_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_lujan_left
	name = "Tattoo (Lujan, Left Eye)"
	icon_state = "tat_lujan_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_lujan_right
	name = "Tattoo (Lujan, Right Eye)"
	icon_state = "tat_lujan_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_natasha_left
	name = "Tattoo (Natasha, Left Eye)"
	icon_state = "tat_natasha_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_natasha_right
	name = "Tattoo (Natasha, Right Eye)"
	icon_state = "tat_natasha_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_nightling
	name = "Tattoo (Nightling, Back)"
	icon_state = "tat_nightling"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_silverburgh_left
	name = "Tattoo (Silverburgh, Left Leg)"
	icon_state = "tat_silverburgh"
	body_parts = list(BP_L_LEG)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori,/datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_silverburgh_right
	name = "Tattoo (Silverburgh, Right Leg)"
	icon_state = "tat_silverburgh"
	body_parts = list(BP_R_LEG)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_spine_back
	name = "Tattoo (Spine, Back)"
	icon_state = "tat_spine"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_tamoko
	name = "Tattoo (Ta Moko, Face)"
	icon_state = "tat_tamoko"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori)

/datum/sprite_accessory/marking/tat_tiger
	name = "Tattoo (Tiger Stripes, All)"
	icon_state = "tat_tiger"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_tiger/chest
	name = "Tattoo (Tiger Stripes, Chest)"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/tat_tiger/groin
	name = "Tattoo (Tiger Stripes, Groin)"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/tat_tiger/left_arm
	name = "Tattoo (Tiger Stripes, Left Arm)"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/tat_tiger/right_arm
	name = "Tattoo (Tiger Stripes, Right Arm)"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tat_tiger/left_hand
	name = "Tattoo (Tiger Stripes, Left Hand)"
	body_parts = list(BP_L_HAND)

/datum/sprite_accessory/marking/tat_tiger/right_hand
	name = "Tattoo (Tiger Stripes, Right Hand)"
	body_parts = list(BP_R_HAND)

/datum/sprite_accessory/marking/tat_tiger/left_leg
	name = "Tattoo (Tiger Stripes, Left Leg)"
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/tat_tiger/right_leg
	name = "Tattoo (Tiger Stripes, Right Leg)"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/tat_tiger/left_foot
	name = "Tattoo (Tiger Stripes, Left Foot)"
	body_parts = list(BP_L_FOOT)

/datum/sprite_accessory/marking/tat_tiger/right_foot
	name = "Tattoo (Tiger Stripes, Right Foot)"
	body_parts = list(BP_R_FOOT)

/datum/sprite_accessory/marking/tat_toshi_left
	name = "Tattoo (Toshi, Left Eye)"
	icon_state = "tat_toshi_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_toshi_right
	name = "Tattoo (Volgin, Right Eye)"
	icon_state = "tat_toshi_r"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/tat_wings_back
	name = "Tattoo (Wings, Lower Back)"
	icon_state = "tat_wingsback"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell)

/datum/sprite_accessory/marking/tat_wings_back/big
	name = "Tattoo (Wings, Full Back)"
	icon_state = "tat_wingsbig"

/datum/sprite_accessory/marking/tat_face_ridge
	name = "Tattoo (Nose Ridge, Face)"
	icon_state = "tat_face_ridge"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_face_hunter
	name = "Tattoo (Hunter Marks, Face)"
	icon_state = "tat_face_hunter"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_armband
	name = "Tattoo (Forearm Band, R. Arm)"
	icon_state = "tat_armband"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tat_armband/left_arm
	name = "Tattoo (Forearm Band, L. Arm)"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/tat_knuckle
	name = "Tattoo (Knuckle Tats, R. Hand)"
	icon_state = "tat_knuckle"
	body_parts = list(BP_R_HAND)

/datum/sprite_accessory/marking/tat_knuckle/left_hand
	name = "Tattoo (Knuckle Tats, L. Hand)"
	body_parts = list(BP_L_HAND)

/datum/sprite_accessory/marking/tat_collarbone
	name = "Tattoo (Collarbone, Chest)"
	icon_state = "tat_laurel"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/tat_pecs
	name = "Tattoo (Pectoral Lines, Chest)"
	icon_state = "tat_pecs"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/tat_barcode
	name = "Tattoo (Barcode, Neck)"
	icon_state = "tat_neckcode"
	body_parts = list(BP_CHEST, BP_HEAD)
	species_allowed = list(/datum/species/machine/shell)

/datum/sprite_accessory/marking/tat_barcode/left_leg
	name = "Tattoo (Barcode, Left Leg)"
	icon_state = "tat_legcode"
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/tat_barcode/right_leg
	name = "Tattoo (Barcode, Right Leg)"
	icon_state = "tat_legcode"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/tat_moon
	name = "Tattoo (Moon, Left Chest)"
	icon_state = "tat_moonleft"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/tat_moon/right
	name = "Tattoo (Moon, Right Chest)"
	icon_state = "tat_moonright"

/datum/sprite_accessory/marking/tat_gang
	name = "Tattoo (Gang Mark, Upper Back)"
	icon_state = "tat_gang1"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/tat_gang/middle
	name = "Tattoo (Gang Mark, Middle Back)"
	icon_state = "tat_gang2"

/datum/sprite_accessory/marking/tat_gang/right
	name = "Tattoo (Gang Mark, Right Back)"
	icon_state = "tat_gang3"

/datum/sprite_accessory/marking/tat_snake
	name = "Tattoo (Snake Colorable, R. Arm)"
	icon_state = "tat_snake_col"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tat_snake/green
	name = "Tattoo (Snake Green, R. Arm)"
	icon_state = "tat_snake"
	do_colouration = FALSE

/datum/sprite_accessory/marking/tat_snake/left
	name = "Tattoo (Snake Colorable, L. Arm)"
	icon_state = "tat_snake_col"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/tat_snake/left/green
	name = "Tattoo (Snake Green, L. Arm)"
	icon_state = "tat_snake"
	do_colouration = FALSE

/datum/sprite_accessory/marking/tat_serpent
	name = "Tattoo (Red Serpent, Chest)"
	icon_state = "tat_serpent"
	body_parts = list(BP_CHEST, BP_GROIN)
	do_colouration = FALSE

/datum/sprite_accessory/marking/tat_rose
	name = "Tattoo (Roses, L. Leg)"
	icon_state = "tat_rose"
	body_parts = list(BP_L_LEG)
	do_colouration = FALSE

/datum/sprite_accessory/marking/tat_rose/right_leg
	name = "Tattoo (Roses, R. Leg)"
	icon_state = "tat_rose"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/tat_rose/left_arm
	name = "Tattoo (Roses, L. Arm)"
	icon_state = "tat_rose"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/tat_rose/right_arm
	name = "Tattoo (Roses, R. Arm)"
	icon_state = "tat_rose"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tat_nanotrasen
	name = "Tattoo (NanoTrasen, Chest)"
	icon_state = "tat_nt"
	body_parts = list(BP_CHEST)
	do_colouration = FALSE

/datum/sprite_accessory/marking/tat_heartbreak
	name = "Tattoo (Heart and Sword, Back)"
	icon_state = "tat_heartbreaker"
	body_parts = list(BP_CHEST, BP_GROIN)
	do_colouration = FALSE

/datum/sprite_accessory/marking/tat_heartthorn
	name = "Tattoo (Heart and Thorns, Back)"
	icon_state = "tat_thornheart"
	body_parts = list(BP_CHEST)
	do_colouration = FALSE

/datum/sprite_accessory/marking/tat_koi
	name = "Tattoo (Koi, Full Torso)"
	icon_state = "tat_koi"
	body_parts = list(BP_CHEST, BP_GROIN)
	do_colouration = FALSE

/datum/sprite_accessory/marking/tat_koi/back
	name = "Tattoo (Koi, Back)"
	icon_state = "tat_koi_back"

/datum/sprite_accessory/marking/tat_koi/left_leg
	name = "Tattoo (Koi, L. Leg)"
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/tat_koi/right_leg
	name = "Tattoo (Koi, R. Leg)"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/tat_koi/left_arm
	name = "Tattoo (Koi, L. Arm)"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/tat_koiright_arm
	name = "Tattoo (Koi, R. Arm)"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tat_sol
	name = "Tattoo (Solarian Flag)"
	icon_state = "tat_sol"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/machine/shell)

/datum/sprite_accessory/marking/tat_biesel
	name = "Tattoo (Biesellite Flag)"
	icon_state = "tat_biesel"
	body_parts = list(BP_CHEST)
	do_colouration = FALSE

/datum/sprite_accessory/marking/tigerhead
	name = "Tiger Stripes (Head, Minor)"
	icon_state = "tigerhead"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona, /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/backstripe
	name = "Back Stripe"
	icon_state = "backstripe"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara,/datum/species/unathi,/datum/species/zombie/unathi)

/datum/sprite_accessory/marking/una_paw_socks
	name = "Socks Coloration (Unathi)"
	icon = 'icons/mob/human_races/markings_unathi.dmi'
	icon_state = "una_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(/datum/species/unathi,/datum/species/zombie/unathi)

/datum/sprite_accessory/marking/bands
	name = "Color Bands"
	icon_state = "bands"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN)
	species_allowed = list(/datum/species/unathi,/datum/species/zombie/unathi)

/datum/sprite_accessory/marking/bandsface
	name = "Color Bands (Face)"
	icon_state = "bandsface"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara,/datum/species/unathi,/datum/species/zombie/unathi)

/datum/sprite_accessory/marking/una_face
	name = "Face Color"
	icon_state = "una_face"
	body_parts = list(BP_HEAD)
	icon = 'icons/mob/human_races/markings_unathi.dmi'
	species_allowed = list(/datum/species/unathi, /datum/species/zombie/unathi)

/datum/sprite_accessory/marking/una_face/paint
	name = "Face Paint"
	icon_state = "una_facepaint"

/datum/sprite_accessory/marking/una_face/una_facelow
	name = "Face Color Low"
	icon_state = "una_facelow"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/una_face/una_scutes
	name = "Scutes"
	icon_state = "una_scutes"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/una_face/una_maswaist
	name = "Masculine Waist (For Females)"
	icon_state = "una_maswaist"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/una_face/una_clawshand
	name = "Claws (Hands)"
	icon_state = "una_claws"
	body_parts = list(BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/una_face/una_clawsfoot
	name = "Claws (Feet)"
	icon_state = "una_claws"
	body_parts = list(BP_L_FOOT,BP_R_FOOT)

/datum/sprite_accessory/marking/spelunker
	name = "Spelunker"
	icon_state = "spelunker"
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_GROIN,BP_HEAD)
	species_allowed = list(/datum/species/bug,/datum/species/bug/type_b)

/datum/sprite_accessory/marking/delver
	name = "Delver"
	icon_state = "delver"
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_GROIN,BP_HEAD)
	species_allowed = list(/datum/species/bug,/datum/species/bug/type_b)

/datum/sprite_accessory/marking/skr_tears
	name = "Skrell Tear Stains (Xiialt)"
	icon = 'icons/mob/human_races/markings_skrell.dmi'
	icon_state = "skr_tears"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/skrell,/datum/species/zombie/skrell)

/datum/sprite_accessory/marking/skr_tears_axiori
	name = "Skrell Tear Stains (Axiori)"
	icon = 'icons/mob/human_races/markings_skrell.dmi'
	icon_state = "skr_tears_axiori"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

/datum/sprite_accessory/marking/skr_dart_frog
	name = "Skrell Dart Frog (Xiialt)"
	icon = 'icons/mob/human_races/markings_skrell.dmi'
	icon_state = "skr_dart_frog"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/skrell,/datum/species/zombie/skrell)

/datum/sprite_accessory/marking/skr_dart_frog_axiori
	name = "Skrell Dart Frog (Axiori)"
	icon = 'icons/mob/human_races/markings_skrell.dmi'
	icon_state = "skr_dart_frog_axiori"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

/datum/sprite_accessory/marking/skr_axiori_eyes
	name = "Axiori Eyes"
	icon = 'icons/mob/human_races/markings_skrell.dmi'
	icon_state = "skr_axiori_eyes"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/skrell,/datum/species/zombie/skrell)

/datum/sprite_accessory/marking/skr_arms
	name = "Skrell Arms"
	icon = 'icons/mob/human_races/markings_skrell.dmi'
	icon_state = "skr_arms"
	body_parts = list(BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

/datum/sprite_accessory/marking/skr_blotch_arms
	name = "Skrell Arm Blotches"
	icon = 'icons/mob/human_races/markings_skrell.dmi'
	icon_state = "skr_blotch_arms"
	body_parts = list(BP_L_ARM,BP_R_ARM)
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

/datum/sprite_accessory/marking/skr_blotch_leg
	name = "Skrell Leg Blotches"
	icon = 'icons/mob/human_races/markings_skrell.dmi'
	icon_state = "skr_blotch_legs"
	body_parts = list(BP_L_LEG,BP_R_LEG)
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

/datum/sprite_accessory/marking/skr_back_stripes
	name = "Skrell Back Stripes"
	icon = 'icons/mob/human_races/markings_skrell.dmi'
	icon_state = "skr_back_stripes"
	body_parts = list(BP_CHEST)
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

/datum/sprite_accessory/marking/skr_stomach
	name = "Skrell Stomach"
	icon = 'icons/mob/human_races/markings_skrell.dmi'
	icon_state = "skr_stomach"
	body_parts = list(BP_CHEST, BP_GROIN)
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

/datum/sprite_accessory/marking/skr_chin
	name = "Skrell Chin"
	icon = 'icons/mob/human_races/markings_skrell.dmi'
	icon_state = "skr_chin"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

/datum/sprite_accessory/marking/skr_gills
	name = "Skrell Gills"
	icon = 'icons/mob/human_races/markings_skrell.dmi'
	icon_state = "skr_gills"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

/datum/sprite_accessory/marking/skr_xibus
	name = "Skrell Xibus"
	icon = 'icons/mob/human_races/markings_skrell.dmi'
	icon_state = "skr_beak"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/skrell,/datum/species/skrell/axiori,/datum/species/zombie/skrell)

/datum/sprite_accessory/marking/diona_leaves
	name = "Diona Leaves"
	icon = 'icons/mob/human_races/markings_diona.dmi'
	icon_state = "diona_leaves"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_GROIN,BP_HEAD)
	species_allowed = list(/datum/species/diona, /datum/species/diona/coeu)

/datum/sprite_accessory/marking/diona_leaves/thorns_head
	name = "Diona Thorns (Head)"
	icon_state = "diona_thorns"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/diona_leaves/thorns_torso
	name = "Diona Thorns (Torso)"
	icon_state = "diona_thorns"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/diona_leaves/flowers_head
	name = "Diona Flowers (Head)"
	icon_state = "diona_flowers"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/diona_leaves/flowers_torso
	name = "Diona Flowers (Torso)"
	icon_state = "diona_flowers"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/diona_leaves/moss
	name = "Diona Moss"
	icon_state = "diona_moss"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/diona_leaves/mushroom
	name = "Diona Mushroom"
	icon_state = "diona_mushroom"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/diona_leaves/mushroom/antennae
	name = "Diona Antennae"
	icon_state = "diona_antennae"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes
	name = "Bug Eyes"
	icon_state = "bugeyes"
	body_parts = list(BP_HEAD)
	do_colouration = FALSE

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/human_eyes
	name = "Human Eyes"
	icon_state = "humaneyes"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/skrell_eyes
	name = "Skrell Eyes"
	icon_state = "skrelleyes"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/skrell_eyes_2
	name = "Skrell Eyes 2"
	icon_state = "skrelleyes2"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/small_horns
	name = "Small Horns"
	icon_state = "smallhorns"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/horny
	name = "Horny"
	icon_state = "horny"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/treebeard
	name = "Treebeard"
	icon_state = "treebeard"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/tinyeye
	name = "Tiny Eye"
	icon_state = "tinyeye"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/eyebrow
	name = "Eyebrow"
	icon_state = "eyebrow"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/bullhorn
	name = "Bullhorn"
	icon_state = "bullhorn"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/mono_eye
	name = "Mono Eye"
	icon_state = "monoeye"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/trioptics
	name = "Trioptics"
	icon_state = "trioptics"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/lopsided
	name = "Lopsided"
	icon_state = "lopsided"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/helmethead
	name = "Helmethead"
	icon_state = "helmethead"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/eyestalk
	name = "Eyestalk"
	icon_state = "eyestalk"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/periscope
	name = "Periscope"
	icon_state = "periscope"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/glorp
	name = "Glorp"
	icon_state = "glorp"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/oak
	name = "Oak"
	icon_state = "oak"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/thorns
	name = "Thorns"
	icon_state = "thorns"

/datum/sprite_accessory/marking/diona_leaves/bug_eyes/stump
	name = "Stump"
	icon_state = "stump"

/datum/sprite_accessory/marking/diona_leaves/pbody
	name = "P-Body"
	icon_state = "pbody"
	body_parts = list(BP_CHEST)
	do_colouration = FALSE

/datum/sprite_accessory/marking/diona_leaves/pbody/blinking
	name = "Blinking P-Body"
	icon_state = "blinkingpbody"

/datum/sprite_accessory/marking/diona_leaves/foot_eye
	name = "Foot Eye"
	icon_state = "footeye"
	body_parts = list(BP_L_FOOT)
	do_colouration = FALSE

/datum/sprite_accessory/marking/diona_leaves/hand_eyes
	name = "Hand Eyes"
	icon_state = "handeye"
	body_parts = list(BP_R_HAND, BP_L_HAND)
	do_colouration = FALSE

/datum/sprite_accessory/marking/diona_leaves/tail
	name = "Tail"
	icon_state = "dionatail"
	body_parts = list(BP_GROIN)
	do_colouration = FALSE

//bishop
/datum/sprite_accessory/marking/bishop_lights
	name = "Bishop - Lights Colour"
	icon = 'icons/mob/human_races/markings_bishop.dmi'
	icon_state = "bishop_lights"
	icon_blend_mode = ICON_MULTIPLY
	is_painted = TRUE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_HEAD)
	robotize_type_required = PROSTHETIC_BC

/datum/sprite_accessory/marking/bishop_lights/bishop_mask
	name = "Bishop - Face Mask"
	icon_state = "bishop_mask"
	do_colouration = FALSE
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/bishop_lights/bishop_mask/bishop_triangular_mask
	name = "Bishop - Triangular Face Mask"
	icon_state = "bishop_triangular_mask"

/datum/sprite_accessory/marking/bishop_lights/bishop_panels
	name = "Bishop - Full Body Panel Colors"
	icon_state = "bishop_panels"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_HEAD)

/datum/sprite_accessory/marking/bishop_lights/bishop_head
	name = "Bishop - Head Panel Colors"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/bishop_lights/bishop_legs
	name = "Bishop - Leg Panel Colors"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/bishop_lights/bishop_arms
	name = "Bishop - Arm Panel Colors"
	body_parts = list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM)

//hephaestus g1
/datum/sprite_accessory/marking/g1_panels
	name = "G1 - Full Panel Colors"
	icon = 'icons/mob/human_races/markings_industrial.dmi'
	icon_state = "g1_primary"
	icon_blend_mode = ICON_MULTIPLY
	is_painted = TRUE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM,BP_GROIN,BP_CHEST,BP_HEAD)
	robotize_type_required = PROSTHETIC_IND

/datum/sprite_accessory/marking/g1_panels/g1_head
	name = "G1 - Head Panel Colors"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/g1_panels/g1_legs
	name = "G1 - Leg Panel Colors"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/g1_panels/g1_arms
	name = "G1 - Arm Panel Colors"
	body_parts = list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM)

/datum/sprite_accessory/marking/g1_panels/g1_lights
	name = "G1 - Lights Color"
	icon_state = "g1_lights"
	body_parts = list(BP_CHEST,BP_HEAD)

//hephaestus g2
/datum/sprite_accessory/marking/g2_panels
	name = "G2 - Full Panel Colors"
	icon = 'icons/mob/human_races/markings_hephaestus.dmi'
	icon_state = "g2_primary"
	icon_blend_mode = ICON_MULTIPLY
	is_painted = TRUE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM,BP_GROIN,BP_CHEST,BP_HEAD)
	robotize_type_required = PROSTHETIC_HI

/datum/sprite_accessory/marking/g2_panels/g2_head
	name = "G2 - Head Panel Colors"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/g2_panels/g2_legs
	name = "G2 - Leg Panel Colors"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/g2_panels/g2_arms
	name = "G2 - Arm Panel Colors"
	body_parts = list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM)

/datum/sprite_accessory/marking/g2_panels/g2_lights
	name = "G2 - Lights Color"
	icon_state = "g2_lights"
	body_parts = list(BP_L_ARM,BP_R_ARM,BP_L_LEG,BP_R_LEG,BP_GROIN,BP_CHEST,BP_HEAD)

//zeng-hu mobility frame
/datum/sprite_accessory/marking/zeng_panels
	name = "Zeng-Hu - Full Panel Colors"
	icon = 'icons/mob/human_races/markings_zenghu.dmi'
	icon_state = "zeng_primary"
	icon_blend_mode = ICON_MULTIPLY
	is_painted = TRUE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM,BP_GROIN,BP_CHEST,BP_HEAD)
	robotize_type_required = PROSTHETIC_ZH

/datum/sprite_accessory/marking/zeng_panels/zeng_head
	name = "Zeng-Hu - Head Panel Colors"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/zeng_panels/zeng_legs
	name = "Zeng-Hu - Leg Panel Colors"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/zeng_panels/zeng_arms
	name = "Zeng-Hu - Arm Panel Colors"
	body_parts = list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM)

/datum/sprite_accessory/marking/zeng_panels/zeng_lights
	name = "Zeng-Hu - Lights Color"
	icon_state = "zeng_lights"
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_HEAD)

//xion
/datum/sprite_accessory/marking/xion_panels
	name = "Xion - Full Panel Colors"
	icon = 'icons/mob/human_races/markings_xion.dmi'
	icon_state = "xion_primary"
	icon_blend_mode = ICON_MULTIPLY
	is_painted = TRUE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM,BP_GROIN,BP_CHEST,BP_HEAD)
	robotize_type_required = PROSTHETIC_XMG

/datum/sprite_accessory/marking/xion_panels/xion_head
	name = "Xion - Head Panel Colors"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/xion_panels/xion_legs
	name = "Xion - Leg Panel Colors"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/xion_panels/xion_arms
	name = "Xion - Arm Panel Colors"
	body_parts = list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM)

/datum/sprite_accessory/marking/xion_panels/xion_lights
	name = "Xion - Lights Color"
	icon_state = "xion_lights"
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_HEAD)

//Tajara

/datum/sprite_accessory/marking/taj_tigerstripes
	name = "Tiger Stripes (Tajara)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "tiger"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_GROIN)
	species_allowed = list(/datum/species/unathi,/datum/species/zombie/unathi,/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_paw_socks
	name = "Socks Coloration (Tajara)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_pawsocks_alternate
	name = "Socks Coloration (Tajara Alternate)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_pawsocks_alternate"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_gloves
	name = "Socks Coloration (Gloves)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_pawsocks"
	body_parts = list(BP_L_HAND,BP_R_HAND)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_paws
	name = "Socks Coloration (Paws)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_glovesfull
	name = "Socks Coloration (Full Gloves)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_pawsocks"
	body_parts = list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_pawsfull
	name = "Socks Coloration (Full Paws)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_glovesfull_alt
	name = "Socks Coloration (Full Gloves Alt)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_pawsocks_alternate"
	body_parts = list(BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_pawsfull_alt
	name = "Socks Coloration (Full Paws Alt)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_pawsocks_alternate"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_glovesfull_alt2
	name = "Socks Coloration (Full Gloves Alt 2)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_bellyhandsfeet_minor"
	body_parts = list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_pawsfull_alt2
	name = "Socks Coloration (Full Paws Alt 2)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_bellyhandsfeet_minor"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_bands
	name = "Color Bands (Tajara)"
	icon_state = "bands"
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_tigerhead_veryminor
	name = "Tiger Stripes (Head, Very Minor)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "tigerheadminor"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/human, /datum/species/human/offworlder, /datum/species/diona,  /datum/species/diona/coeu, /datum/species/machine/shell, /datum/species/skrell, /datum/species/skrell/axiori, /datum/species/tajaran, /datum/species/tajaran/zhan_khazan, /datum/species/tajaran/m_sai, /datum/species/unathi)

/datum/sprite_accessory/marking/taj_tigerface
	name = "Tiger Stripes (Head, Major)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "tigerface"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_nose
	name = "Nose Color"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_nose"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_muzzle
	name = "Muzzle Color"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_muzzle"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_muzzle_female
	name = "Muzzle Color (Female)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_muzzle_female"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_face_minor
	name = "Cheeks Color (Minor)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_face_minor"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_face
	name = "Cheeks Color"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_face"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_all
	name = "All Tajara Head"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_all"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_belly_hands_feet_minor
	name = "Hands,Feet,Belly Color (Minor)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_bellyhandsfeet_minor"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_belly_hands_feet_minor_female
	name = "Hands,Feet,Belly Color (Female, Minor)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_bellyhandsfeet_minor_female"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_belly_male
	name = "Belly Color (Male)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_bellyhandsfeet_minor"
	body_parts = list(BP_GROIN,BP_CHEST)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_belly_female
	name = "Belly Color (Female)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_bellyhandsfeet_minor_female"
	body_parts = list(BP_GROIN,BP_CHEST)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_chest_male
	name = "Chest,Belly Coloration (Male)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_bellyhandsfeet"
	body_parts = list(BP_GROIN,BP_CHEST)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_chest_female
	name = "Chest,Belly Coloration (Female)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_bellyhandsfeet_female"
	body_parts = list(BP_GROIN,BP_CHEST)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_patches_full
	name = "Color Patches (Full)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_patches"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_patches_leftleg
	name = "Color Patches (Left Leg)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_patches"
	body_parts = list(BP_L_FOOT,BP_L_LEG)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_patches_rightleg
	name = "Color Patches (Right Leg)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_patches"
	body_parts = list(BP_R_FOOT,BP_R_LEG)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_patches_leftarm
	name = "Color Patches (Left Arm)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_patches"
	body_parts = list(BP_L_ARM,BP_L_HAND)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_patches_rightarm
	name = "Color Patches (Right Arm)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_patches"
	body_parts = list(BP_R_ARM,BP_R_HAND)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_patches_chest
	name = "Color Patches (Torso)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_patches"
	body_parts = list(BP_CHEST,BP_GROIN)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)

/datum/sprite_accessory/marking/taj_patchesface
	name = "Color Patches (Face)"
	icon = "icons/mob/human_races/markings_tajara.dmi"
	icon_state = "taj_patchesface"
	body_parts = list(BP_HEAD)
	species_allowed = list(/datum/species/tajaran,/datum/species/tajaran/zhan_khazan,/datum/species/tajaran/m_sai,/datum/species/zombie/tajara)
