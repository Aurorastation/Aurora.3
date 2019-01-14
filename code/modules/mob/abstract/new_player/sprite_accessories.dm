/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

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


/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

/datum/sprite_accessory/hair
	icon = 'icons/mob/human_face/hair.dmi'	  // default icon for all hairs

	bald
		name = "Bald"
		icon_state = "bald"
		gender = MALE
		species_allowed = list("Human","Unathi")

	short
		name = "Short Hair"	  // try to capatilize the names please~
		icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you

	short2
		name = "Short Hair 2"
		icon_state = "hair_shorthair3"

	resomi
		name = "Resomi Plumage"
		icon_state = "resomi_default"
		species_allowed = list("Resomi")
		icon = 'icons/mob/human_face/resomi_hair.dmi'

		resomi_ears
			name = "Resomi Ears"
			icon_state = "resomi_ears"

		resomi_excited
			name = "Resomi Spiky"
			icon_state = "resomi_spiky"

	cut
		name = "Cut Hair"
		icon_state = "hair_c"

	flair
		name = "Flaired Hair"
		icon_state = "hair_flair"

	long
		name = "Shoulder-length Hair"
		icon_state = "hair_b"

	/*longish
		name = "Longer Hair"
		icon_state = "hair_b2"*/

	longer
		name = "Long Hair"
		icon_state = "hair_vlong"

	longeralt2
		name = "Long Hair Alt"
		icon_state = "hair_longeralt2"

	longest
		name = "Very Long Hair"
		icon_state = "hair_longest"

	longfringe
		name = "Long Fringe"
		icon_state = "hair_longfringe"

	longeralt
		name = "Longer Fringe"
		icon_state = "hair_vlongfringe"

	halfbang
		name = "Half-banged Hair"
		icon_state = "hair_halfbang"

	halfbangalt
		name = "Half-banged Hair Alt"
		icon_state = "hair_halfbang_alt"

	ponytail1
		name = "Ponytail 1"
		icon_state = "hair_ponytail"

	ponytail2
		name = "Ponytail 2"
		icon_state = "hair_pa"
		gender = FEMALE

	ponytail3
		name = "Ponytail 3"
		icon_state = "hair_ponytail3"

	ponytail4
		name = "Ponytail 4"
		icon_state = "hair_ponytail4"
		gender = FEMALE

	ponytail5
		name = "Ponytail 5"
		icon_state = "hair_ponytail5"

	ponytail6
		name = "Ponytail 6"
		icon_state = "hair_ponytail6"
		gender = FEMALE

	ponytail7
		name = "Ponytail 7"
		icon_state = "hair_ponytail7"
		gender = FEMALE

	sideponytail
		name = "Side Ponytail"
		icon_state = "hair_stail"
		gender = FEMALE

	sideponytail2
		name = "Side Ponytail 2"
		icon_state = "hair_ponytailf"
		gender = FEMALE

	oneshoulder
		name = "One Shoulder"
		icon_state = "hair_oneshoulder"
		gender = FEMALE

	tresshoulder
		name = "Tress Shoulder"
		icon_state = "hair_tressshoulder"
		gender = FEMALE

/*	wisp  ///disable until the coloring and sprite overall is not so awful
		name = "Wisp"
		icon_state = "hair_wisp"
		gender = FEMALE
*/
	parted
		name = "Parted"
		icon_state = "hair_parted"

	pompadour
		name = "Pompadour"
		icon_state = "hair_pompadour"
		gender = MALE

	quiff
		name = "Quiff"
		icon_state = "hair_quiff"
		gender = MALE

	bedhead
		name = "Bedhead"
		icon_state = "hair_bedhead"

	bedhead2
		name = "Bedhead 2"
		icon_state = "hair_bedheadv2"

	beehive
		name = "Beehive"
		icon_state = "hair_beehive"
		gender = FEMALE

	beehive2
		name = "Beehive 2"
		icon_state = "hair_beehive2"
		gender = FEMALE

	bobcurl
		name = "Bobcurl"
		icon_state = "hair_bobcurl"
		gender = FEMALE
		species_allowed = list("Human","Unathi")

	bob
		name = "Bob"
		icon_state = "hair_bobcut"
		gender = FEMALE
		species_allowed = list("Human","Unathi")

	bobcutalt
		name = "Chin Length Bob"
		icon_state = "hair_bobcutalt"
		gender = FEMALE

	bowl
		name = "Bowl"
		icon_state = "hair_bowlcut"
		gender = MALE

	buzz
		name = "Buzzcut"
		icon_state = "hair_buzzcut"
		gender = MALE
		species_allowed = list("Human","Unathi")

	crew
		name = "Crewcut"
		icon_state = "hair_crewcut"
		gender = MALE

	combover
		name = "Combover"
		icon_state = "hair_combover"
		gender = MALE

	reversemohawk
		name = "Reverse Mohawk"
		icon_state = "hair_reversemohawk"
		gender = MALE

	devillock
		name = "Devil Lock"
		icon_state = "hair_devilock"

	dreadlocks
		name = "Dreadlocks"
		icon_state = "hair_dreads"

	curls
		name = "Curls"
		icon_state = "hair_curls"

	afro
		name = "Afro"
		icon_state = "hair_afro"

	afro2
		name = "Afro 2"
		icon_state = "hair_afro2"

	afro_large
		name = "Big Afro"
		icon_state = "hair_bigafro"
		gender = MALE

	rows
		name = "Rows"
		icon_state = "hair_rows1"

	rows2
		name = "Rows 2"
		icon_state = "hair_rows2"

	sargeant
		name = "Flat Top"
		icon_state = "hair_sargeant"
		gender = MALE

	emo
		name = "Emo"
		icon_state = "hair_emo"

	longemo
		name = "Long Emo"
		icon_state = "hair_emolong"
		gender = FEMALE

	fringeemo
		name = "Emo Fringe"
		icon_state = "hair_emofringe"

	shortovereye
		name = "Overeye Short"
		icon_state = "hair_shortovereye"

	veryshortovereyealternate
		name = "Overeye Very Short, Alternate"
		icon_state = "hair_veryshortovereye"

	longovereye
		name = "Overeye Long"
		icon_state = "hair_longovereye"

	fag
		name = "Flow Hair"
		icon_state = "hair_f"

	feather
		name = "Feather"
		icon_state = "hair_feather"

	hitop
		name = "Hitop"
		icon_state = "hair_hitop"
		gender = MALE

	jensen
		name = "Adam Jensen Hair"
		icon_state = "hair_jensen"
		gender = MALE

	gelled
		name = "Gelled Back"
		icon_state = "hair_gelled"
		gender = FEMALE

	gentle
		name = "Gentle"
		icon_state = "hair_gentle"
		gender = FEMALE

	spiky
		name = "Spiky"
		icon_state = "hair_spikey"
		species_allowed = list("Human","Unathi")

	kusangi
		name = "Kusanagi Hair"
		icon_state = "hair_kusanagi"

	kagami
		name = "Pigtails"
		icon_state = "hair_kagami"
		gender = FEMALE

	himecut
		name = "Hime Cut"
		icon_state = "hair_himecut"
		gender = FEMALE

	himecut_alt
		name = "Hime Cut Alt"
		icon_state = "hair_himecut_alt"
		gender = FEMALE

	shorthime
		name = "Short Hime Cut"
		icon_state = "hair_shorthime"
		gender = FEMALE

	grandebraid
		name = "Grande Braid"
		icon_state = "hair_grande"
		gender = FEMALE

	braid
		name = "Floorlength Braid"
		icon_state = "hair_braid"
		gender = FEMALE

	mbraid
		name = "Medium Braid"
		icon_state = "hair_shortbraid"
		gender = FEMALE

	braid2
		name = "Long Braid"
		icon_state = "hair_hbraid"
		gender = FEMALE

	braidalt
		name = "Long Braid 2"
		icon_state = "hair_hbraidalt"
		gender = FEMALE

	odango
		name = "Odango"
		icon_state = "hair_odango"
		gender = FEMALE

	ombre
		name = "Ombre"
		icon_state = "hair_ombre"
		gender = FEMALE

	updo
		name = "Updo"
		icon_state = "hair_updo"
		gender = FEMALE

	skinhead
		name = "Skinhead"
		icon_state = "hair_skinhead"

	balding
		name = "Balding Hair"
		icon_state = "hair_e"
		gender = MALE // turnoff!

	familyman
		name = "The Family Man"
		icon_state = "hair_thefamilyman"
		gender = MALE

	mahdrills
		name = "Drillruru"
		icon_state = "hair_drillruru"
		gender = FEMALE

	fringetail
		name = "Fringetail"
		icon_state = "hair_fringetail"
		gender = FEMALE

	dandypomp
		name = "Dandy Pompadour"
		icon_state = "hair_dandypompadour"
		gender = MALE

	poofy
		name = "Poofy"
		icon_state = "hair_poofy"
		gender = FEMALE

	crono
		name = "Chrono"
		icon_state = "hair_toriyama"
		gender = MALE

	vegeta
		name = "Vegeta"
		icon_state = "hair_toriyama2"
		gender = MALE

	cia
		name = "CIA"
		icon_state = "hair_cia"
		gender = MALE

	mulder
		name = "Mulder"
		icon_state = "hair_mulder"
		gender = MALE

	scully
		name = "Scully"
		icon_state = "hair_scully"
		gender = FEMALE

	wheeler
		name = "Wheeler"
		icon_state = "hair_wheeler"
		gender = FEMALE

	nitori
		name = "Nitori"
		icon_state = "hair_nitori"
		gender = FEMALE

	joestar
		name = "Joestar"
		icon_state = "hair_joestar"
		gender = MALE

	volaju
		name = "Volaju"
		icon_state = "hair_volaju"

	bald
		name = "Bald"
		icon_state = "bald"

	eighties
		name = "80's"
		icon_state = "hair_80s"
		gender = FEMALE

	nia
		name = "Nia"
		icon_state = "hair_nia"
		gender = FEMALE

	unkept
		name = "Unkept"
		icon_state = "hair_unkept"

	modern
		name = "Modern"
		icon_state = "hair_modern"

	bald
		name = "Bald"
		icon_state = "bald"

	bun
		name = "Bun"
		icon_state = "hair_bun"
		gender = FEMALE

	buncasual
		name = "Casual Bun"
		icon_state = "hair_bun2"
		gender = FEMALE

	doublebun
		name = "Double-Bun"
		icon_state = "hair_doublebun"
		gender = FEMALE

	bangshuman
		name = "Bangs"
		icon_state = "hair_hbangs"
		gender = FEMALE

	bangshumanalt
		name = "Bangs Short"
		icon_state = "hair_hbangs_alt"
		gender = FEMALE

	shortbangs
		name = "Short Bangs"
		icon_state = "hair_shortbangs"

	sleeze
		name = "Sleeze"
		icon_state = "hair_sleeze"

	fringetail
		name = "Fringetail"
		icon_state = "hair_fringetail"

	lowfade
		name = "Low Fade"
		icon_state = "hair_lowfade"
		gender = MALE

	medfade
		name = "Medium Fade"
		icon_state = "hair_medfade"

	highfade
		name = "High Fade"
		icon_state = "hair_highfade"
		gender = MALE

	baldfade
		name = "Balding Fade"
		icon_state = "hair_baldfade"
		gender = MALE

	nofade
		name = "No Fade"
		icon_state = "hair_nofade"
		gender = MALE

	trimflat
		name = "Trimmed Flat Top"
		icon_state = "hair_trimflat"
		gender = MALE

	shaved
		name = "Shaved"
		icon_state = "hair_shaved"
		gender = MALE

	trimmed
		name = "Trimmed"
		icon_state = "hair_trimmed"
		gender = MALE

	tightbun
		name = "Tight Bun"
		icon_state = "hair_tightbun"
		gender = FEMALE

	coffeehouse
		name = "Coffee House Cut"
		icon_state = "hair_coffeehouse"
		gender = MALE

	undercut
		name = "Undercut"
		icon_state = "hair_undercut"
		gender = MALE

	hightight
		name = "High and Tight"
		icon_state = "hair_hightight"
		gender = MALE

	topknot
		name = "Topknot"
		icon_state = "hair_topknot"
		gender = MALE

	ronin
		name = "Ronin"
		icon_state = "hair_ronin"
		gender = MALE

	bowlcut2
		name = "Bowl2"
		icon_state = "hair_bowlcut2"
		gender = MALE

	thinning
		name = "Thinning"
		icon_state = "hair_thinning"
		gender = MALE

	thinningfront
		name = "Thinning Front"
		icon_state = "hair_thinningfront"
		gender = MALE

	thinningback
		name = "Thinning Back"
		icon_state = "hair_thinningrear"
		gender = MALE

	manbun
		name = "Manbun"
		icon_state = "hair_manbun"
		gender = MALE

	shavedbun
		name = "Shaved Bun"
		icon_state = "hair_shavedbun"

	halfshaved
		name = "Half-Shaved"
		icon_state = "hair_halfshaved"

	halfshavedemo
		name = "Half-Shaved Emo"
		icon_state = "hair_halfshavedemo"

	longsideemo
		name = "Long Side Emo"
		icon_state = "hair_longsideemo"

	sideswept
		name = "Sideswept Hair"
		icon_state = "hair_sideswept"

	mohawkshaved
		name = "Shaved Mohawk"
		icon_state = "hair_mohawkshaved"

	mohawkshaved2
		name = "Tight Shaved Mohawk"
		icon_state = "hair_mohawkshaved2"

	mohawkshavednaomi
		name = "Naomi Mohawk"
		icon_state = "hair_mohawkshavednaomi"

	leftsidecut
		name = "Left Sidecut"
		icon_state = "hair_leftside"

	rightsidecut
		name = "Right Sidecut"
		icon_state = "hair_rightside"

	gentle2
		name = "Gentle 2"
		icon_state = "hair_gentle2"

	gentle2long
		name = "Gentle 2 (Long)"
		icon_state = "hair_gentle2long"

	donutbun
		name = "Donut Bun"
		icon_state = "hair_donutbun"

	gentle2alt
		name = "Gentle 2, Alternative"
		icon_state = "hair_gentle2alt"

	gentle2longalt
		name = "Gentle 2, Alternative (Long)"
		icon_state = "hair_gentle2longalt"

	neat
		name = "Neat"
		icon_state = "hair_neat"
		gender = FEMALE

	neatlong
		name = "Neat (Long)"
		icon_state = "hair_neatlong"
		gender = FEMALE

	bobcuteven
		name = "Shoulder Bob"
		icon_state = "hair_bobcuteven"
		gender = FEMALE

	shortmess
		name = "Messy"
		icon_state = "hair_shortmess"

	remohawk
		name = "Mohawk"
		icon_state = "hair_mohawk"

	celes
		name = "Drills, Side"
		icon_state = "hair_celes"


	// TG-format hair - uses ICON_MULTIPLY instead of ICON_ADD
	uniter
		icon = 'icons/mob/human_face/hair_multiply.dmi'
		icon_blend_mode = ICON_MULTIPLY
		name = "Uniter"
		icon_state = "hair_uniter"

		balding
			name = "Balding"
			icon_state = "hair_balding"

		bun
			name = "Librarian Bun"
			icon_state = "hair_bun"

		fade
			name = "Fade"
			icon_state = "hair_fade"

		floof
			name = "Floof"
			icon_state = "hair_floof"

		krewcut
			name = "Krewcut"
			icon_state = "hair_krewcut"

		pomp
			name = "Pomp III"
			icon_state = "hair_pomp_iii"

		shortchoppy
			name = "Choppy (Short)"
			icon_state = "hair_shortchoppy"

		shortfloof
			name = "Floof (Short)"
			icon_state = "hair_shortfloof"

		sideshave
			name = "Sideshave"
			icon_state = "hair_sideshaved"

		superb_owl
			name = "Superbowl"
			icon_state = "hair_superbowl"

		waxed
			name = "Waxed"
			icon_state = "hair_waxed"

		cactus
			name = "Cactus"
			icon_state = "hair_whatdoinamethiscactus"

		wavyshoulder
			name = "Wavy Shoulder (Down)"
			icon_state = "wavyshoulder_down"

		wavyshoulder_pt
			name = "Wavy Shoulder (Ponytail)"
			icon_state = "wavyshoulder_up"

		jenjen
			name = "Jenjen"
			icon_state = "hair_jenjen"

		fade_grown
			name = "Fade (Grown)"
			icon_state = "hair_fade_grown"

		swept
			name = "Swept"
			icon_state = "hair_shortswept"

		spiked
			name = "Spiked"
			icon_state = "hair_short_spike"


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

	watson
		name = "Watson Mustache"
		icon_state = "facial_watson"

	hogan
		name = "Hulk Hogan Mustache"
		icon_state = "facial_hogan" //-Neek

	vandyke
		name = "Van Dyke Mustache"
		icon_state = "facial_vandyke"

	chaplin
		name = "Square Mustache"
		icon_state = "facial_chaplin"

	selleck
		name = "Selleck Mustache"
		icon_state = "facial_selleck"

	neckbeard
		name = "Neckbeard"
		icon_state = "facial_neckbeard"

	fullbeard
		name = "Full Beard"
		icon_state = "facial_fullbeard"

	longbeard
		name = "Long Beard"
		icon_state = "facial_longbeard"

	vlongbeard
		name = "Very Long Beard"
		icon_state = "facial_wise"

	elvis
		name = "Elvis Sideburns"
		icon_state = "facial_elvis"
		species_allowed = list("Human","Unathi")

	abe
		name = "Abraham Lincoln Beard"
		icon_state = "facial_abe"

	chinstrap
		name = "Chinstrap"
		icon_state = "facial_chin"

	hip
		name = "Hipster Beard"
		icon_state = "facial_hip"

	gt
		name = "Goatee"
		icon_state = "facial_gt"

	jensen
		name = "Adam Jensen Beard"
		icon_state = "facial_jensen"

	volaju
		name = "Volaju"
		icon_state = "facial_volaju"

	dwarf
		name = "Dwarf Beard"
		icon_state = "facial_dwarf"

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

	mutton
		name = "Mutton Chops"
		icon_state = "facial_mutton"

	muttonstache
		name = "Mutton Chops and Moustache"
		icon_state = "facial_muttonmus"

	walrus
		name = "Walrus Moustache"
		icon_state = "facial_walrus"

	croppedbeard
		name = "Full Cropped Beard"
		icon_state = "facial_croppedfullbeard"

	chinless
		name = "Chinless Beard"
		icon_state = "facial_chinlessbeard"

	stark
		icon = 'icons/mob/human_face/facial_hair_multiply.dmi'
		name = "Stark"
		icon_state = "beard_stark"
		icon_blend_mode = ICON_MULTIPLY

		chinstrap2
			name = "Chinstrap (Alt)"
			icon_state = "beard_chinstrap_ii"

		swire
			name = "Swire"
			icon_state = "beard_swire"

/*
///////////////////////////////////
/  =---------------------------=  /
/  == Alien Style Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/hair

//unathi hair

	una_spines_long
		icon = 'icons/mob/human_face/unathi_hair.dmi'
		name = "Long Unathi Spines"
		icon_state = "unathi_longspines"
		species_allowed = list("Unathi")

		una_spines_short
			name = "Short Unathi Spines"
			icon_state = "unathi_shortspines"

		una_frills_long
			name = "Long Unathi Frills"
			icon_state = "unathi_longfrills"

		una_frills_short
			name = "Short Unathi Frills"
			icon_state = "unathi_shortfrills"

		una_horns
			name = "Unathi Horns"
			icon_state = "unathi_simplehorn"

		una_bighorns
			name = "Unathi Big Horns"
			icon_state = "unathi_bighorn"

		una_smallhorns
			name = "Unathi Small Horns"
			icon_state = "unathi_smallhorn"

		una_swepthorns
			name = "Unathi Swept-Forward Horns"
			icon_state = "unathi_swepthorn"

		una_sidefrills
			name = "Unathi Side Frills"
			icon_state = "unathi_sidefrills"

		una_mohawk
			name = "Unathi Mohawk"
			icon_state = "hair_d"

		una_drachorn
			name = "Unathi Draconic Horns"
			icon_state = "unathi_drachorn"

		una_lowerhorn
			name = "Unathi Lower Horns"
			icon_state = "unathi_lowerhorn"

		una_spikehorn
			name = "Unathi Spike Horns"
			icon_state = "unathi_spikehorn"

		una_shorthorn
			name = "Unathi Short Horns"
			icon_state = "unathi_shorthorn"

		una_curlhorn
			name = "Unathi Curled Horns"
			icon_state = "unathi_curledhorn"

		una_ramhornshort
			name = "Unathi Short Ram Horns"
			icon_state = "unathi_ramhorn"

		una_ramhornlong
			name = "Unathi Long Ram Horns"
			icon_state = "unathi_ramhorn2"

//skrell tentacles

	skr_tentacle_m
		icon = 'icons/mob/human_face/skrell_hair.dmi'
		name = "Skrell Short Tentacles"
		icon_state = "skrell_hair_m"
		species_allowed = list("Skrell")

		skr_tentacle_f
			name = "Skrell Average Tentacles"
			icon_state = "skrell_hair_f"

		skr_tentacle_short
			name = "Skrell Very Short Tentacles"
			icon_state = "veryshort_s"

		skr_tentacle_long
			name = "Skrell Very Long Tentacles"
			icon_state = "verylong_s"


//tajaran hair

	taj_ears
		icon = 'icons/mob/human_face/tajara_hair.dmi'
		name = "Tajaran Ears"
		icon_state = "ears_plain"
		species_allowed = list("Tajara")

		taj_ears_clean
			name = "Tajara Clean"
			icon_state = "hair_clean"

		taj_ears_bangs
			name = "Tajara Bangs"
			icon_state = "hair_bangs"

		taj_ears_braid
			name = "Tajara Braid"
			icon_state = "hair_tbraid"

		taj_ears_shaggy
			name = "Tajara Shaggy"
			icon_state = "hair_shaggy"

		taj_ears_mohawk
			name = "Tajaran Mohawk"
			icon_state = "hair_mohawk"

		taj_ears_plait
			name = "Tajara Plait"
			icon_state = "hair_plait"

		taj_ears_straight
			name = "Tajara Straight"
			icon_state = "hair_straight"

		taj_ears_long
			name = "Tajara Long"
			icon_state = "hair_long"

		taj_ears_rattail
			name = "Tajara Rat Tail"
			icon_state = "hair_rattail"

		taj_ears_spiky
			name = "Tajara Spiky"
			icon_state = "hair_tajspiky"

		taj_ears_messy
			name = "Tajara Messy"
			icon_state = "hair_messy"

		taj_ears_curls
			name = "Tajara Curly"
			icon_state = "hair_curly"

		taj_ears_wife
			name = "Tajara Housewife"
			icon_state = "hair_wife"

		taj_ears_victory
			name = "Tajara Victory Curls"
			icon_state = "hair_victory"

		taj_ears_bob
			name = "Tajara Bob"
			icon_state = "hair_tbob"

		taj_ears_fingercurl
			name = "Tajara Finger Curls"
			icon_state = "hair_fingerwave"

		taj_ears_pompadour
			name = "Tajara Greaser"
			icon_state = "hair_greaser"

//vox hair

	vox_quills_short
		icon = 'icons/mob/human_face/vox_hair.dmi'
		name = "Short Vox Quills"
		icon_state = "vox_shortquills"
		species_allowed = list("Vox")

		vox_quills_kingly
			name = "Kingly Vox Quills"
			icon_state = "vox_kingly"

		vox_quills_mohawk
			name = "Quill Mohawk"
			icon_state = "vox_mohawk"

//vaurca antennae

	vaurca_classic
		icon = 'icons/mob/human_face/vaurca_hair.dmi'
		name = "Classic Antennae"
		icon_state = "vaurca_classic"
		species_allowed = list("Vaurca")
		gender = NEUTER

		vaurca_mid
			name = "Mid Length Antennae"
			icon_state = "vaurca_mid"

		vaurca_fla
			name = "Floor Length Antennae"
			icon_state = "vaurca_fla"

		vaurca_droop
			name = "Droopy Antennae"
			icon_state = "vaurca_droop"

		vaurca_zappy
			name = "Zappy Antennae"
			icon_state = "vaurca_zappy"

		vaurca_braided
			name = "Braided Antennae"
			icon_state = "vaurca_braided"

/datum/sprite_accessory/facial_hair
	taj_sideburns
		icon = 'icons/mob/human_face/tajara_facial_hair.dmi'
		name = "Tajara Sideburns"
		icon_state = "facial_sideburns"
		species_allowed = list("Tajara")

		taj_mutton
			name = "Tajara Mutton"
			icon_state = "facial_mutton"

		taj_pencilstache
			name = "Tajara Pencilstache"
			icon_state = "facial_pencilstache"

		taj_moustache
			name = "Tajara Moustache"
			icon_state = "facial_moustache"

		taj_goatee
			name = "Tajara Goatee"
			icon_state = "facial_goatee"

		taj_smallstache
			name = "Tajara Smallsatche"
			icon_state = "facial_smallstache"

//unathi horn beards and the like

	una_chinhorn
		icon = 'icons/mob/human_face/unathi_facial_hair.dmi'
		name = "Unathi Chin Horn"
		icon_state = "facial_chinhorns"
		species_allowed = list("Unathi")
		gender = NEUTER

		una_hornadorns
			name = "Unathi Horn Adorns"
			icon_state = "facial_hornadorns"

		una_dorsalfrill
			name = "Unathi Dorsal Frill"
			icon_state = "facial_dorsalfrill"

		una_aquaticfrill
			name = "Unathi Aquatic Frills"
			icon_state = "facial_aquaticfrills"

		una_longfrill
			name = "Unathi Long Frills"
			icon_state = "facial_longfrills"

		una_shortfrill
			name = "Unathi Short Frills"
			icon_state = "facial_shortfrills"

		una_longdorsal
			name = "Unathi Long Dorsal Frill"
			icon_state = "facial_longdorsal"

		una_dracfrills
			name = "Unathi Draconic Frills"
			icon_state = "facial_dracfrills"

//ipc screens

	ipc_screen_pink
		icon = 'icons/mob/human_face/ipc_screens.dmi'
		name = "pink IPC screen"
		icon_state = "ipc_pink"
		species_allowed = list("Machine")
		gender = NEUTER

		ipc_screen_red
			name = "red IPC screen"
			icon_state = "ipc_red"

		ipc_screen_green
			name = "green IPC screen"
			icon_state = "ipc_green"

		ipc_screen_blue
			name = "blue IPC screen"
			icon_state = "ipc_blue"

		ipc_screen_breakout
			name = "breakout IPC screen"
			icon_state = "ipc_breakout"

		ipc_screen_eight
			name = "eight IPC screen"
			icon_state = "ipc_eight"

		ipc_screen_goggles
			name = "goggles IPC screen"
			icon_state = "ipc_goggles"

		ipc_screen_heart
			name = "heart IPC screen"
			icon_state = "ipc_heart"

		ipc_screen_monoeye
			name = "monoeye IPC screen"
			icon_state = "ipc_monoeye"

		ipc_screen_nature
			name = "nature IPC screen"
			icon_state = "ipc_nature"

		ipc_screen_orange
			name = "orange IPC screen"
			icon_state = "ipc_orange"

		ipc_screen_purple
			name = "purple IPC screen"
			icon_state = "ipc_purple"

		ipc_screen_shower
			name = "shower IPC screen"
			icon_state = "ipc_shower"

		ipc_screen_static
			name = "static IPC screen"
			icon_state = "ipc_static"

		ipc_screen_yellow
			name = "yellow IPC screen"
			icon_state = "ipc_yellow"

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
		body_parts = list("l_foot","r_foot","l_leg","r_leg","l_arm","r_arm","chest","groin")
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	taj_paw_socks
		name = "Socks Coloration (Tajara)"
		icon_state = "taj_pawsocks"
		body_parts = list("l_foot","r_foot","l_leg","r_leg","l_arm","r_arm","l_hand","r_hand")
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	una_paw_socks
		name = "Socks Coloration (Unathi)"
		icon_state = "una_pawsocks"
		body_parts = list("l_foot","r_foot","l_leg","r_leg","l_arm","r_arm","l_hand","r_hand")
		species_allowed = list("Unathi")

	belly_hands_feet
		name = "Hands,Feet,Belly Color (Minor)"
		icon_state = "bellyhandsfeetsmall"
		body_parts = list("l_foot","r_foot","l_leg","r_leg","l_arm","r_arm","l_hand","r_hand","groin","chest")
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	patches
		name = "Color Patches"
		icon_state = "patches"
		body_parts = list("l_foot","r_foot","l_leg","r_leg","l_arm","r_arm","l_hand","r_hand","chest","groin")
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	patchesface
		name = "Color Patches (Face)"
		icon_state = "patchesface"
		body_parts = list("head")
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	bands
		name = "Color Bands"
		icon_state = "bands"
		body_parts = list("l_foot","r_foot","l_leg","r_leg","l_arm","r_arm","l_hand","r_hand","chest","groin")
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara", "Unathi")

	bandsface
		name = "Color Bands (Face)"
		icon_state = "bandsface"
		body_parts = list("head")
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara", "Unathi")

	tigerhead
		name = "Tiger Stripes (Head, Minor)"
		icon_state = "tigerhead"
		body_parts = list("head")
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	tigerface
		name = "Tiger Stripes (Head, Major)"
		icon_state = "tigerface"
		body_parts = list("head")
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	backstripe
		name = "Back Stripe"
		icon_state = "backstripe"
		body_parts = list("chest")
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara", "Unathi")

	taj_nose
		name = "Nose Color"
		icon_state = "taj_nose"
		body_parts = list("head")
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	taj_muzzle
		name = "Muzzle Color"
		icon_state = "taj_muzzle"
		body_parts = list("head")
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	taj_face
		name = "Cheeks Color"
		icon_state = "taj_face"
		body_parts = list("head")
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	taj_all
		name = "All Tajara Head"
		icon_state = "taj_all"
		body_parts = list("head")
		species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

	una_face
		name = "Face Color"
		icon_state = "una_face"
		body_parts = list("head")
		species_allowed = list("Unathi")

	una_facelow
		name = "Face Color Low"
		icon_state = "una_facelow"
		body_parts = list("head")
		species_allowed = list("Unathi")

	una_scutes
		name = "Scutes"
		icon_state = "una_scutes"
		body_parts = list("chest")
		species_allowed = list("Unathi")

// Branded IPC markings - disabled for now, some layering issues.
/*
	bishop
		icon = 'icons/mob/human_races/markings_bishop.dmi'
		icon_state = "face_lights"
		icon_blend_mode = ICON_MULTIPLY
		name = "Face Color"
		body_parts = list("head")
		species_allowed = list("Bishop Accessory Frame")
		is_painted = TRUE

		monoeye
			name = "Eye"
			icon_state = "monoeye"

		plating
			name = "Plating (Full)"
			icon_state = "plating"
			body_parts = list("chest", "l_arm", "r_arm", "l_leg", "r_leg")

			l_arm
				name = "Plating (Left arm)"
				body_parts = list("l_arm")

			r_arm
				name = "Plating (Right arm)"
				body_parts = list("r_arm")

			l_leg
				name = "Plating (Left leg)"
				body_parts = list("l_leg")

			r_leg
				name = "Plating (Right leg)"
				body_parts = list("r_leg")

			chest
				name = "Plating (Chest)"
				body_parts = list("chest")

	zenghu
		icon = 'icons/mob/human_races/markings_zenghu.dmi'
		icon_state = "outer"
		icon_blend_mode = ICON_MULTIPLY
		name = "Outer Finish"
		body_parts = list("head")
		species_allowed = list("Zeng-Hu Mobility Frame")
		is_painted = TRUE

		inner
			name = "Inner Finish"
			icon_state = "inner"
			body_parts = list("l_foot", "r_foot", "l_hand", "r_hand", "l_leg", "r_leg")

			l_foot
				name = "Inner Finish (Left Leg)"
				body_parts = list("l_foot", "l_leg")

			r_foot
				name = "Inner Finish (Right Leg)"
				body_parts = list("r_foot", "r_leg")

			l_hand
				name = "Inner Finish (Left Arm)"
				body_parts = list("l_hand", "l_arm")

			r_hand
				name = "Inner Finish (Right Arm)"
				body_parts = list("r_hand", "r_arm")

		crest_leser
			name = "Head Coloration (Lesser)"
			icon_state = "lesser"

		crest_greater
			name = "Head Coloration (Greater)"
			icon_state = "greater"
*/
