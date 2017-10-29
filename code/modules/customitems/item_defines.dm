/// Aurora custom items ///
/*basic guidelines:
Custom items must be accepted at some point in the forums by the staff handling them.
Add custom items to this file, their sprites into their own dmi. in the icons/obj/custom_items.
All custom items with worn sprites must follow the contained sprite system: http://forums.aurorastation.org/viewtopic.php?f=23&t=6798
*/

/obj/item/clothing/accessory/fluff/antique_pocket_watch //Antique Pocket Watch - Eric Derringer - xelnagahunter
	name = "antique pocket watch"
	icon = 'icons/obj/custom_items/pocket_watch.dmi'
	icon_state = "pocket_watch_close"
	item_state = "gold"
	desc = "The design of this pocket watch signals its age, however it seems to retain its pristine quality. The cover is gold, and there appears to be an elegant crest on the outside of the lid."
	w_class = 2

/obj/item/clothing/accessory/fluff/antique_pocket_watch/attack_self(mob/user as mob)
	switch(icon_state)
		if("pocket_watch_open")
			icon_state = "pocket_watch_close"
			usr << "You close \the [src]."
			desc = "The design of this pocket watch signals its age, however it seems to retain its pristine quality. The cover is gold, and there appears to be an elegant crest on the outside of the lid."
		if("pocket_watch_close")
			icon_state = "pocket_watch_open"
			usr << "You open \the [src]."
			desc = "Inside the pocket watch, there is a collection of numbers, displaying '[worldtime2text()]'. On the inside of the lid, there is another sequence of numbers etched into the lid itself."


/obj/item/clothing/head/soft/sec/corp/fluff/mendoza_cap //Mendoza's cap - Chance Mendoza - loow
	name = "well-worn corporate security cap"
	desc = "A baseball hat in corporate colors.\"C. Mendoza\" is embroidered in fine print on the bill. On the underside of the cap, in dark ink, the phrase \"Gamble till you're Lucky!\" is written in loopy cursive handwriting."


/obj/item/clothing/head/fluff/ziva_bandana //Ziva's Bandana - Ziva Ta'Kim - sierrakomodo
	name = "old bandana"
	desc = "An old orange-ish-yellow bandana. It has a few stains from engine grease, and the color has been dulled."
	icon = 'icons/obj/custom_items/motaki_bandana.dmi'
	icon_state = "motaki_bandana"
	item_state = "motaki_bandana"
	contained_sprite = TRUE


/obj/item/clothing/suit/armor/vest/fluff/zubari_jacket //Fancy Jacket - Zubari Akenzua - filthyfrankster
	name = "fancy jacket"
	desc = "A well tailored unathi styled armored jacket, fitted for one too."
	icon = 'icons/obj/custom_items/zubari_jacket.dmi'
	icon_state = "zubari_jacket"
	item_state = "zubari_jacket"
	contained_sprite = TRUE


/obj/item/clothing/suit/unathi/mantle/fluff/yinzr_mantle //Heirloom Unathi Mantle - Sslazhir Yinzr - alberyk
	name = "heirloom unathi mantle"
	desc = "A withered mantle sewn from threshbeast's hides, the pauldrons that holds it on the shoulders seems to be the remains of some kind of old armor."
	icon = 'icons/obj/custom_items/yinzr_mantle.dmi'
	icon_state = "yinzr_mantle" //special thanks to Araskael
	item_state = "yinzr_mantle"
	species_restricted = list("Unathi") //forged for lizardmen
	contained_sprite = TRUE


/obj/item/clothing/glasses/fluff/nebula_glasses	//chich eyewear - Roxy Wallace - nebulaflare
	name = "chic eyewear"
	desc = "A stylish pair of glasses. They look custom made."
	icon = 'icons/obj/custom_items/nebula_glasses.dmi'
	icon_state = "nebula_glasses"
	item_state = "nebula_glasses"
	contained_sprite = TRUE
	var/obj/item/weapon/disk/chip

/obj/item/clothing/glasses/fluff/nebula_glasses/Initialize()
	. = ..()
	chip = new /obj/item/weapon/disk/fluff/nebula_chip()

/obj/item/clothing/glasses/fluff/nebula_glasses/Destroy()
	QDEL_NULL(chip)
	return ..()

/obj/item/clothing/glasses/fluff/nebula_glasses/attack_self(mob/user as mob)
	if(chip)
		user.put_in_hands(chip)
		user << "<span class='notice'>You eject a small, concealed data chip from a small slot in the frames of \the [src].</span>"
		chip = null

/obj/item/clothing/glasses/fluff/nebula_glasses/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/disk/fluff/nebula_chip) && !chip)
		//user.u_equip(W)
		user.drop_from_inventory(W)
		W.forceMove(src)
		chip = W
		W.add_fingerprint(user)
		add_fingerprint(user)
		user << "You slot the [W] back into its place in the frames of \the [src]."

/obj/item/weapon/disk/fluff/nebula_chip //data chip - Roxy Wallace - nebulaflare
	name = "data chip"
	desc = "A small green chip."
	icon = 'icons/obj/custom_items/nebula_chip.dmi'
	icon_state = "nebula_chip"
	w_class = 1


/obj/item/clothing/gloves/swat/fluff/hawk_gloves //Sharpshooter gloves - Hawk Silverstone - nebulaflare
	name = "sharpshooter gloves"
	desc = "These tactical gloves are tailor made for a marksman."
	icon = 'icons/obj/custom_items/hawk_gloves.dmi'
	icon_state = "hawk_gloves"
	item_state = "swat_gl"


/obj/item/clothing/accessory/fluff/karima_datadrive //Data Drive Pendant -  Kyyir'ry'avii Mo'Taki - nebulaflare
	name = "data drive"
	desc = "A small necklace, the pendant flips open to reveal a data drive."
	icon = 'icons/obj/custom_items/motaki_datadrive.dmi'
	icon_state = "motaki_datadrive"
	item_state = "holobadge-cord"
	slot_flags = SLOT_MASK | SLOT_TIE


/obj/item/clothing/ears/skrell/fluff/dompesh_cloth //Skrell Purple Head Cloth - Shkor-Dyet Dom'Pesh - mofo1995
	name = "male skrell purple head cloth"
	desc = "A set of purple headcloths fit for a skrell's head tails. This one has a small SAMPLe logo on the interior of each cloth, perfect for scientific skrell."


/obj/item/weapon/fluff/kiara_altar //Pocket Altar - Kiara Branwen - nursiekitty
	name = "pocket altar"
	desc = "A black tin box with a symbol painted over it. It shimmers in the light."
	icon = 'icons/obj/custom_items/kiara_altar.dmi'
	icon_state = "kiara_altar1"
	w_class = 2

/obj/item/weapon/fluff/kiara_altar/attack_self(mob/user as mob)
	if(src.icon_state == "kiara_altar1")
		src.icon_state = "kiara_altar2"
		user << "You open the pocket altar, revealing its contents."
		desc = "A black tin box, you can see inside; a vial of herbs, a little bag of salt, some epoxy clay runes, a candle with match, a permanent marker and a tiny besom."
	else
		src.icon_state = "kiara_altar1"
		user << "You close the pocket altar."
		desc = "A black tin box with a symbol painted over it. It shimmers in the light."


/obj/item/clothing/head/det/fluff/bell_hat //Brown Hat - Avery Bell - serveris6
	name = "brown hat"
	desc = "A worn mid 20th century brown hat. It seems to have aged very well."
	icon = 'icons/obj/custom_items/bell_coat.dmi'
	icon_state = "bell_hat"
	item_state = "bell_hat"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/det_trench/fluff/bell_coat //Pinned Brown Coat - Avery Bell - serveris6
	name = "pinned brown coat"
	desc = "A worn mid 20th century brown trenchcoat. If you look closely at the breast, you can see an ID flap stitched into the leather - \"Avery Bell, Silhouette Co\"."
	icon = 'icons/obj/custom_items/bell_coat.dmi'
	icon_state = "bell_coat"
	item_state = "bell_coat"
	contained_sprite = TRUE
	allowed = list(/obj/item/weapon/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,
	/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,/obj/item/device/taperecorder, /obj/item/clothing/accessory/badge/fluff/bell_badge)


/obj/item/clothing/under/syndicate/tacticool/fluff/jaylor_turtleneck //Borderworlds Turtleneck - Jaylor Rameau - evilbrage
	name = "borderworlds turtleneck"
	desc = "A loose-fitting turtleneck, common among borderworld pilots and criminals. One criminal in particular is missing his, apparently."


/obj/item/weapon/melee/fluff/tina_knife //Consecrated Athame - Tina Kaekel - tainavaa
	name = "consecrated athame"
	desc = "An athame used in occult rituals. The double-edged dagger is dull. The handle is black with a pink/white occult design strewn about it, and \"Tina\" is inscribed into it in decorated letters."
	icon = 'icons/obj/custom_items/tina_knife.dmi'
	icon_state = "tina_knife"
	item_state = "knife"
	slot_flags = SLOT_BELT
	w_class = 1


/obj/item/device/kit/paint/ripley/fluff/zairjah_kit //Hephaestus Industrial Exosuit MK III Customization Kit - Zairjah - alberyk
	name = "\"Hephaestus Industrial Exosuit MK III\" APLU customisation kit"
	desc = "A ripley APLU model manufactured by Hephaestus industries, a common sight in New Gibson nowadays. It shines with chrome painting and a fancy reinforced glass cockpit."
	new_name = "Hephaestus Industrial Exosuit MK III"
	new_desc = "A ripley APLU model manufactured by Hephaestus industries, a common sight in New Gibson nowadays. It shines with chrome painting and a fancy reinforced glass cockpit."
	new_icon = "ripley_zairjah" //a lot of thanks to cakeisossim for the sprites
	allowed_types = list("ripley","firefighter")


/obj/item/weapon/cane/fluff/usiki_cane //Inscribed Silver-handled Cane - Usiki Guwan - fireandglory
	name = "inscribed silver-handled cane"
	desc = "This silver-handled cane has letters carved into the sides."
	icon = 'icons/obj/custom_items/usiki_cane.dmi'
	icon_state = "usiki_cane"
	item_state = "usiki_cane"
	contained_sprite = TRUE

/obj/item/weapon/cane/fluff/usiki_cane/attack_self(mob/user as mob)
	if(all_languages[LANGUAGE_UNATHI] in user.languages)
		user << "This cane has the words \"A new and better life\" carved into one side in basic, and on the other side in Sinta'Unathi."
	else
		user << "This cane has the words \"A new and better life\" carved into the side, the other side has some unreadable carvings."


/obj/item/clothing/gloves/black/fluff/kathleen_glove //Black Left Glove - Kathleen Mistral - valkywalky2
	name = "black left glove"
	desc = "A pretty normal looking glove to be worn on the left hand."
	icon = 'icons/obj/custom_items/kathleen_glove.dmi'
	icon_state = "kathleen_glove"
	item_state = "kathleen_glove"
	contained_sprite = TRUE
	gender = NEUTER
	body_parts_covered = null
	fingerprint_chance = 50

/obj/structure/bed/chair/wheelchair/fluff/nomak_scooter //Mobility Scooter - Dubaku Nomak - demonofthefall
	name = "mobility scooter"
	desc = "A battery powered scooters designed to carry fatties."
	icon = 'icons/obj/custom_items/nomak_scooter.dmi'
	icon_state = "nomak_scooter"

/obj/structure/bed/chair/wheelchair/fluff/nomak_scooter/update_icon()
	return

/obj/structure/bed/chair/wheelchair/fluff/nomak_scooter/set_dir()
	..()
	overlays = null
	if(buckled_mob)
		buckled_mob.set_dir(dir)


/obj/item/weapon/coin/fluff/yoiko_coin //Sobriety Chip - Yurick Ali - raineko
	name = "sobriety chip"
	desc = "A red coin, made from plastic. A triangle is engraved, surrounding it is the words: \"TO THINE OWN SELF BE TRUE\"."
	icon = 'icons/obj/custom_items/yoiko_coin.dmi'
	icon_state = "yoiko_coin" //thanks fireandglory for the sprites


/obj/item/clothing/suit/unathi/mantle/fluff/karnaikai_wrappings //Unathi Wrappings - Azeazekal Karnaikai - canon35
	name = "unathi wrappings"
	desc = "Stitched together clothing with bandages covering them, looks tailored for an unathi."
	icon = 'icons/obj/custom_items/karnaikai_wrappings.dmi'
	icon_state = "karnaikai_wrappings" //special thanks to Araskael
	item_state = "karnaikai_wrappings"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETAIL
	species_restricted = list("Unathi")
	contained_sprite = TRUE


/obj/item/clothing/mask/gas/fluff/karnaikai_mask //Unathi head wrappings - Azeazekal Karnaikai - canon35
	name = "unathi head wrappings"
	desc = "A bunch of stitched together bandages with a fibreglass breath mask on it, openings for the eyes. Looks tailored for an unathi."
	icon = 'icons/obj/custom_items/karnaikai_mask.dmi'
	icon_state = "karnaikai_mask" //special thanks to Araskael
	item_state = "karnaikai_mask"
	species_restricted = list("Unathi")
	contained_sprite = TRUE


/obj/item/weapon/contraband/poster/fluff/conservan_poster //ATLAS poster - Conservan Xullie - conservatron
	name = "ATLAS poster"

/obj/item/weapon/contraband/poster/fluff/conservan_poster/New()
	..()
	serial_number = 59


/obj/item/weapon/flame/lighter/zippo/fluff/locke_zippo //Fire Extinguisher Zippo - Jacob Locke - completegarbage
	name = "fire extinguisher lighter"
	desc = "Most fire extinguishers on the station are way too heavy. This one's a little lighter."
	icon = 'icons/obj/custom_items/locke_zippo.dmi'
	icon_state = "locke_zippo"


/obj/item/weapon/clipboard/fluff/zakiya_sketchpad //Sketchpad - Zakiya Ahmad - sierrakomodo
	name = "sketchpad"
	desc = "A simple sketchpad, about the size of a regular sheet of paper."
	icon = 'icons/obj/custom_items/zakiya_sketchpad.dmi' //thanks superballs for the sprites
	icon_state = "zakiya_sketchpad"

/obj/item/weapon/clipboard/fluff/zakiya_sketchpad/New()
		..()
		new /obj/item/weapon/paper(src)
		new /obj/item/weapon/paper(src)
		new /obj/item/weapon/paper(src)
		new /obj/item/weapon/paper(src)
		new /obj/item/weapon/paper(src)
		new /obj/item/weapon/paper(src)
		new /obj/item/weapon/paper(src)
		new /obj/item/weapon/paper(src)
		new /obj/item/weapon/paper(src)
		new /obj/item/weapon/paper(src)

/obj/item/weapon/clipboard/fluff/zakiya_sketchpad/update_icon()
	if(toppaper)
		icon_state = "zakiya_sketchpad1"
	else
		icon_state = "zakiya_sketchpad"
	return

/obj/item/weapon/pen/fluff/zakiya_pen //Sketching pencil - Zakiya Ahmad - sierrakomodo
	name = "sketching pencil"
	desc = "A graphite sketching pencil."
	icon = 'icons/obj/custom_items/zakiya_pen.dmi'
	icon_state = "zakiya_pen"


/obj/item/weapon/melee/fluff/zah_mandible //Broken Vaurca Mandible - Ka'Akaix'Zah Zo'ra - sleepywolf
	name = "broken vaurca mandible"
	desc = "A black, four inch long piece of a Vaurca mandible. It seems dulled, and looks like it was shot off."
	icon = 'icons/obj/custom_items/zah_mandible.dmi'
	icon_state = "zah_mandible"
	slot_flags = SLOT_BELT
	w_class = 1
	force = 2


/obj/item/clothing/suit/chaplain_hoodie/fluff/nioathi_hoodie //Shaman Hoodie - Fereydoun Nioathi - jackboot
	name = "shaman hoodie"
	desc = "A slightly faded robe. It's worn by some Unathi shamans."
	icon = 'icons/obj/custom_items/nioathi_hoodie.dmi'
	icon_state = "nioathi_hoodie"
	item_state = "nioathi_hoodie"
	contained_sprite = TRUE


/obj/item/weapon/implanter/fluff //snowflake implanters for snowflakes
	var/allowed_ckey = ""
	var/implant_type = null

/obj/item/weapon/implanter/fluff/proc/create_implant()
	if (!implant_type)
		return
	imp = new implant_type(src)
	update()

	return

/obj/item/weapon/implanter/fluff/attack(mob/M as mob, mob/user as mob, var/target_zone)
	if (!M.ckey || M.ckey != allowed_ckey)
		return

	..()


/obj/item/weapon/fluff/moon_baton //Tiger Claw - Zander Moon - omnivac
	name = "tiger claw"
	desc = "A small ceremonial energy dagger given to Golden Tigers."
	icon = 'icons/obj/custom_items/moon_baton.dmi'
	icon_state = "tigerclaw"
	item_state = "tigerclaw"
	slot_flags = SLOT_BELT
	force = 2
	w_class = 2
	contained_sprite = TRUE
	var/active = FALSE

/obj/item/weapon/fluff/moon_baton/attack_self(mob/user)
	active= !active
	if(active)
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		user << "<span class='notice'>\The [src] is now energised.</span>"
		icon_state = "tigerclaw_active"
		item_state = icon_state
		slot_flags = null
		attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	else
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		user << "<span class='notice'>\The [src] is now de-energised.</span>"
		icon_state = initial(icon_state)
		item_state = icon_state
		slot_flags = initial(slot_flags)
		attack_verb = list("prodded")

	user.update_inv_l_hand(FALSE)
	user.update_inv_r_hand()


/obj/item/clothing/suit/armor/vest/fabian_coat //NT APF Armor - Fabian Goellstein - mirkoloio
	name = "NT APF armor"
	desc = "This is a NT Asset Protection Force Armor, it is fashioned as a jacket in NT Security Colors. The nameplate carries the Name \"Goellstein\"."
	icon = 'icons/obj/custom_items/fabian_coat.dmi'
	icon_state = "fabian_coat_open"
	item_state = "fabian_coat_open"
	contained_sprite = TRUE

/obj/item/clothing/suit/armor/vest/fabian_coat/verb/toggle()
	set name = "Toggle Coat Zipper"
	set category = "Object"
	set src in usr

	if(!usr.canmove || usr.stat || usr.restrained())
		return 0

	switch(icon_state)
		if("fabian_coat_open")
			icon_state = "fabian_coat_closed"
			item_state = icon_state
			usr << "You zip up \the [src]."
		if("fabian_coat_closed")
			icon_state = "fabian_coat_open"
			item_state = icon_state
			usr << "You unzip \the [src]."
		else
			usr << "You attempt to button-up the velcro on \the [src], before promptly realising how silly you are."
			return

	usr.update_inv_wear_suit()

/obj/item/clothing/head/beret/centcom/officer/fluff/fabian_beret //Worn Security Beret - Fabian Goellstein - mirkoloio
	name = "worn security beret"
	desc = "A NT Asset Protection Force Beret. It has the NT APF insignia on it as well as the Name \"Goellstein\" inside."


/obj/item/clothing/head/fluff/vittorio_fez //Black Fez - Vittorio Giurifiglio - tytostyris
	name = "black fez"
	desc = "It is a black fez, it bears an Emblem of the Astronomical symbol of Earth, It also has some nice tassels."
	icon = 'icons/obj/custom_items/vittorio_fez.dmi'
	icon_state = "vittorio_fez"
	item_state = "vittorio_fez"
	contained_sprite = TRUE


/obj/item/clothing/suit/fluff/centurion_cloak //Paludamentum - Centurion - cakeisossim
	name = "paludamentum"
	desc = "A cloak-like piece of silky, red fabric. Fashioned at one point where the shoulder would be with a golden pin."
	icon = 'icons/obj/custom_items/centurion_cloak.dmi'
	icon_state = "centurion_cloak"
	item_state = "centurion_cloak"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	contained_sprite = TRUE


/obj/item/clothing/ears/bandanna/fluff/kir_bandanna //Kir's Bandanna - Kir Iziki - araskael
	name = "purple bandanna"
	desc = "A worn and faded purple bandanna with a knotted, dragon-like design on it."
	icon = 'icons/obj/custom_items/kir_bandanna.dmi'
	icon_state = "kir_bandanna"
	item_state = "kir_bandanna"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/toggle/bomber/fluff/ash_jacket //Hand-me-down Bomber Jacket - Ash LaCroix - superballs
	name = "hand-me-down bomber jacket"
	desc = "A custom tailored bomber jacket that seems to have been through some action. A silver badge is pinned to it, along with a black and blue strip covering it halfway.  \
	The badge reads, \"Christopher LaCroix, Special Agent, Mendell City, E.O.W. 10-7-38, 284\"."
	icon = 'icons/obj/custom_items/ash_jacket.dmi'
	icon_state = "ash_jacket"
	item_state = "ash_jacket"
	icon_open = "ash_jacket_open"
	icon_closed = "ash_jacket"
	contained_sprite = TRUE


/obj/item/clothing/accessory/badge/fluff/dylan_tags //Dog Tags - Dylan Sutton - sircatnip
	name = "dog tags"
	desc = "Some black dog tags, engraved on them is the following: \"Wright, Dylan L, O POS, Pacific Union Special Forces\"."
	icon = 'icons/obj/custom_items/dylan_tags.dmi'
	icon_state = "dylan_tags"
	item_state = "dylan_tags"
	stored_name = "Wright, Dylan L"
	badge_string = "Pacific Union Special Forces"
	contained_sprite = TRUE
	slot_flags = SLOT_MASK | SLOT_TIE


/obj/item/clothing/ears/fluff/rico_stripes //Racing Stripes - Ricochet - nebulaflare
	name = "racing stripes"
	desc = "A pair of fancy racing stripes."
	icon = 'icons/obj/custom_items/rico_stripes.dmi'
	icon_state = "rico_stripes"
	item_state = "rico_stripes"
	contained_sprite = TRUE
	canremove = FALSE
	abstract = TRUE
	species_restricted = list("Machine")
	autodrobe_no_remove = TRUE


/obj/item/weapon/reagent_containers/food/drinks/flask/fluff/barcia_flask //First Shot - Gabriel Barcia - mrgabol100
	name = "first shot"
	desc = "A flask. Smells of absinthe, maybe vodka. The bottom left corner has a silver bar. The bottom is engraved, it reads: \"The First Shot\"."
	icon = 'icons/obj/custom_items/barcia_flask.dmi'
	icon_state = "barcia_flask"


/obj/item/clothing/gloves/fluff/stone_ring //Thunder Dome Pendant Ring - Jerimiah Stone - dominicthemafiaso
	name = "thunder dome pendant ring"
	desc = "It appears to be a Collectors edition Thunder dome Pendant ring from the IGTDL's show rumble in the red planet in 2444. It has a decorative diamond center with a image of the Intergalactic belt in the center."
	icon = 'icons/obj/custom_items/stone_ring.dmi'
	icon_state = "stone_ring"
	item_state = "stone_ring"
	contained_sprite = TRUE
	clipped = TRUE
	species_restricted = null
	gender = NEUTER
	body_parts_covered = null
	fingerprint_chance = 100

/obj/item/clothing/under/dress/fluff/sayyidah_dress //Traditional Jumper Dress - Sayyidah Al-Kateb - alberyk
	name = "traditional jumper dress"
	desc = "A light summer-time dress, decorated neatly with black and silver colors, it seems to be rather old."
	icon = 'icons/obj/custom_items/sayyidah_dress.dmi' //special thanks to Coalf for the sprites
	icon_state = "sayyidah_dress"
	item_state = "sayyidah_dress"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/fluff/vittorio_jacket //Atlas Overcoat - Vittorio Giurifiglio - tytostyris
	name = "atlas overcoat"
	desc = "A classy black militaristic uniform, which is adorned with a sash and an eagle."
	icon = 'icons/obj/custom_items/vittorio_jacket.dmi'
	icon_state = "vittorio_jacket"
	item_state = "vittorio_jacket"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/toggle/labcoat/fluff/helmut_labcoat //CERN Labcoat - Helmut Kronigernischultz - pyrociraptor
	name = "\improper CERN labcoat"
	desc = "A Labcoat with a blue pocket and blue collar. On the pocket, you can read \"C.E.R.N.\"."
	icon = 'icons/obj/custom_items/helmut_labcoat.dmi'
	icon_state = "helmut_labcoat"
	item_state = "helmut_labcoat"
	icon_open = "helmut_labcoat_open"
	icon_closed = "helmut_labcoat"
	contained_sprite = TRUE


/obj/item/clothing/shoes/jackboots/unathi/fluff/yinzr_sandals //Marching Sandals - Sslazhir Yinzr - alberyk
	name = "marching sandals"
	desc = "A pair of sturdy marching sandals made of layers of leather and with a reinforced sole, they are also rather big."
	icon = 'icons/obj/custom_items/yinzr_sandals.dmi'
	item_state = "yinzr_sandals"
	icon_state = "yinzr_sandals"
	contained_sprite = TRUE


/obj/item/clothing/accessory/fluff/laikov_broach //Jeweled Broach - Aji'Rah Laikov - nebulaflare
	name = "jeweled broach"
	desc = "A jeweled broach, inlaid with semi-precious gems. The clasp appears to have been replaced."
	icon = 'icons/obj/custom_items/laikov_broach.dmi'
	item_state = "laikov_broach"
	icon_state = "laikov_broach"
	contained_sprite = TRUE

/obj/item/clothing/accessory/fluff/laikov_broach/attack_self(mob/user as mob)
	if(isliving(user))
		user.visible_message("<span class='notice'>[user] displays their [src.name]. It glitters in many colors.</span>")

/obj/item/clothing/accessory/fluff/laikov_broach/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] thrust the [src.name] into [M]'s face.</span>")


/obj/item/weapon/fluff/akela_photo //Akela's Family Photo - Akela Ha'kim - moltenkore
	name = "family photo"
	desc = "You see on the photo a tajaran couple holding a small kit in their arms, while looking very happy. On the back it is written; \"Nasir, Akela and Ishka\", with a little gold mark that reads: \"Two months\"."
	icon = 'icons/obj/custom_items/akela_photo.dmi'
	icon_state = "akela_photo"
	w_class = 2


/obj/item/weapon/implant/fluff/ziva_implant //Heart Condition - Ziva Ta'Kim - sierrakomodo
	name = "heart monitor"
	desc = "A small machine to watch upon broken hearts."

/obj/item/weapon/implant/fluff/ziva_implant/implanted(mob/living/carbon/human/M as mob)
	if (M.ckey == "sierrakomodo") //just to be sure
		M.verbs += /mob/living/carbon/human/proc/heart_attack
	else
		return

/mob/living/carbon/human/proc/heart_attack()
	set category = "IC"
	set name = "Suffer Heart Condition"
	set desc = "HNNNNG."

	if(last_special > world.time)
		src << "<span class='warning'>Your chest still hurts badly!</span>"
		return

	last_special = world.time + 500

	var/obj/item/organ/F = src.internal_organs_by_name["heart"]

	if(isnull(F))
		return

	F.take_damage(5)
	src << "<span class='warning'>You feel a stabbing pain in your chest!</span>"
	playsound(user, 'sound/effects/Heart Beat.ogg', 20, 1)


/obj/item/clothing/accessory/badge/fluff/caleb_badge //Worn Badge - Caleb Greene - notmegatron
	name = "worn badge"
	desc = "A simple gold badge denoting the wearer as Head of Security. It is worn and dulled with age, but the name, \"Caleb Greene\", is still clearly legible."
	icon = 'icons/obj/custom_items/caleb_badge.dmi'
	item_state = "caleb_badge"
	icon_state = "caleb_badge"
	stored_name = "Caleb Greene"
	badge_string = "NOS Apollo Head of Security"
	contained_sprite = TRUE


/obj/item/fluff/messa_pressing //Pressing of Messa's Tears - Poslan Kur'yer-Isra - jboy2000000
	name = "pressing of Messa's tears"
	desc = "As Messa looked at the pain and death wrought on the world she had given life, she cried, and from her tears sprouted these leaves."
	icon = 'icons/obj/custom_items/cat_religion.dmi'
	icon_state = "messa"
	w_class = 2

/obj/item/fluff/srendarr_pressing //Pressing of S'Rendarr's Hand - Poslan Kur'yer-Isra - jboy2000000
	name = "pressing of S'Rendarr's hand"
	desc = "As S'Rendarr watched his sister cry, he felt rage never known to him before. His fists clashed with those who upset his sister, and from their blood came these."
	icon = 'icons/obj/custom_items/cat_religion.dmi'
	icon_state = "srendarr"
	w_class = 2

/obj/item/clothing/suit/chaplain_hoodie/fluff/poslan_jacket //Twin Suns Throw-over - Poslan Kur'yer-Isra - jboy2000000
	name = "twin suns throw-over"
	desc = "A light black jacket, on one side of its breast is the design of a yellow sun, and on the other side there is a smaller blue sun."
	icon = 'icons/obj/custom_items/cat_religion.dmi'
	icon_state = "poslan_jacket"
	item_state = "poslan_jacket"
	contained_sprite = TRUE


/obj/item/sign/fluff/alexis_degree //Xenonuerology Doctorate - Alexis Shaw - tenenza
	name = "xenonuerology degree"
	desc = "Certification for a doctorate in Xenonuerology, made out to Alexis Shaw by the St. Grahelm University of Biesel, authenticated by watermarking."
	icon_state = "alexis_degree"
	sign_state = "alexis_degree"
	w_class = 2


/obj/item/clothing/mask/fluff/rur_collar //Tagging Collar - R.U.R - coalf
	name = "tagging collar"
	desc = "A steel tagging collar, a giant golden D is imprinted on the front."
	icon = 'icons/obj/custom_items/rur_collar.dmi'
	icon_state = "rur_collar"
	item_state = "rur_collar"
	contained_sprite = TRUE
	body_parts_covered = 0
	canremove = FALSE
	species_restricted = list("Machine")
	autodrobe_no_remove = TRUE
	var/emagged = FALSE

/obj/item/clothing/mask/fluff/rur_collar/emag_act(var/remaining_charges, var/mob/user)
	if (!emagged)
		user << "<span class='danger'>You short out \the [src]'s locking mechanism.</span>"
		src.icon_state = "rur_collar_broken"
		src.canremove = TRUE
		src.emagged = TRUE
		playsound(src.loc, 'sound/effects/sparks1.ogg', 100, 0)
		return 1


/obj/item/clothing/mask/bluescarf/fluff/simon_scarf //Fancy Scarf - Simon Greene - icydew
	name = "fancy scarf"
	desc = "A very smooth, dark blue scarf with a golden trim. It feels really new and clean."
	icon = 'icons/obj/custom_items/simon_scarf.dmi'
	icon_state = "simon_scarf"
	item_state = "simon_scarf"
	contained_sprite = TRUE


/obj/item/clothing/head/soft/sec/corp/fluff/karson_cap //Karson's Cap - Eric Karson - dronzthewolf
	name = "well-worn corporate security cap"
	desc = "A well-worn corporate security cap. The name \"Karson\" is written on the underside of the brim, it is well-worn at the point where it has shaped to the owner's head."


/obj/item/sign/fluff/triaka_atimono //Framed Zatimono - Azkuyua Triaka - jackboot
	name = "framed zatimono"
	desc = "A framed Zatimono, a Unathi standard worn into battle similar to an old-Earth Sashimono. This one is slightly faded."
	icon_state = "triaka_atimono"
	sign_state = "triaka_atimono"
	w_class = 2


/obj/item/fluff/cac_picture //Photo of a spider and a robot - CAC - fireandglory
	name = "photo of a spider and a robot"
	desc = "It is a photo of a cyan IPC holding a thick fuzzy spider of the size of a football."
	icon = 'icons/obj/custom_items/cac_picture.dmi'
	icon_state = "cac_picture"
	w_class = 2
	slot_flags = SLOT_EARS


/obj/item/weapon/coin/fluff/raymond_coin //Engraved Coin - Raymond Hawkins - aboshehab
	name = "engraved coin"
	desc = "A coin of light and bright with one side having an engraving of a greek Lamba sign, and on the back the initials of R.H. are engraved."
	icon = 'icons/obj/custom_items/raymond_coin.dmi'
	icon_state = "raymond_coin"


/obj/item/clothing/under/fluff/zohjar_uniform //Republic Noble Clothing - Zohjar Rasateir - lordraven001
	name = "republic noble clothing"
	desc = "A sophisticated white undersuit, it looks worn and ancient. The fabrics is excellently sewn and soft. It resembles a traditional tajaran nobleman suit."
	icon = 'icons/obj/custom_items/zohjar_clothing.dmi'
	icon_state = "zohjar_uniform"
	item_state = "zohjar_uniform"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/labcoat/tajaran/fluff/zohjar_jacket //People's Republic Medical Officer Coat - Zohjar Rasateir - lordraven001
	name = "people's republic medical officer coat"
	desc = "A sterile insulated coat made of leather stitched over fur. It has two gold lapels indicating Officer rank. \
	The a white armband with a scarlet line in the center indicates that the person wearing this coat is medically trained."


/obj/item/clothing/suit/storage/tajaran/fluff/maksim_coat //Tajaran Naval Officer's Coat - Maksim Vasilyev - aimlessanalyst
	name = "tajaran naval officer coat"
	desc = "A thick wool coat from Adhomai, calling back to days long past."


/obj/item/sign/fluff/iskanz_atimono //Framed Zatimono - Iskanz Sal'Dans - zundy
	name = "framed zatimono"
	desc = "A framed Zatimono, a Unathi standard worn into battle similar to an old-Earth Sashimono. This one seems well maintained and carries Sk'akh Warrior Priest markings and litanies."
	icon_state = "iskanz_atimono"
	sign_state = "iskanz_atimono"
	w_class = 2


/obj/item/clothing/accessory/fluff/zahra_pin //Indigo Remembrance Pin -  Zahra Karimi - synnono
	name = "indigo remembrance pin"
	desc = "A small metal pin, worked into the likeness of an indigo iris blossom."
	icon = 'icons/obj/custom_items/zahra_pin.dmi'
	icon_state = "zahra_pin"
	item_state = "zahra_pin"
	contained_sprite = TRUE


/obj/item/clothing/accessory/armband/fluff/karl_armband //Medizinercorps Armband - Karl Pollard - arrow768
	name = "medizinercorps armband"
	desc = "A plain black armband with the golden Medizinercorps logo on it."
	icon = 'icons/obj/custom_items/karl_armband.dmi'
	icon_state = "karl_armband"
	item_state = "karl_armband"
	contained_sprite = TRUE


/obj/item/weapon/melee/fluff/rook_whip //Ceremonial Whip - Rook Jameson - hivefleetchicken
	name = "ceremonial whip"
	desc = "A traditional cat o'nine tails whip made of jet black leather and embroidered with a few golden touches, made on Earth. It looks ceremoniously robust."
	icon = 'icons/obj/custom_items/rook_whip.dmi'
	icon_state = "rook_whip"
	item_state = "rook_whip"
	slot_flags = SLOT_BELT
	contained_sprite = TRUE
	w_class = 3
	force = 2
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")


/obj/item/clothing/suit/storage/toggle/labcoat/fluff/lilith_coat //Black Labcoat - LiLITH - ladyofravens
	name = "black labcoat"
	desc = "A sleek black labcoat made from durable synthetics. A tag inside the collar reads \"Property of LiLITH\" in red block letters."
	icon = 'icons/obj/custom_items/lilith_coat.dmi'
	icon_state = "lilith_coat"
	item_state = "lilith_coat"
	icon_open = "lilith_coat_open"
	icon_closed = "lilith_coat"
	contained_sprite = TRUE


/obj/item/clothing/head/fluff/sayyidah_tiara //Jeweled Tiara - Sayyidah Al-Kateb - alberyk
	name = "jeweled tiara"
	desc = "A headdress in the shape of a tiara, it is adorned by not so valuable jewels and spots a translucid veil on the back. There is room for pointy ears in the sides of the piece, as it was molded for a tajara."
	icon = 'icons/obj/custom_items/sayyidah_dress.dmi' //special thanks to TheGreatJorge for the sprites
	icon_state = "sayyidah_tiara"
	item_state = "sayyidah_tiara"
	contained_sprite = TRUE


/obj/item/clothing/accessory/fluff/jeyne_pendant //Jeyne's Pendant - Jeyne Kahale - themuncorn
	name = "black choker with pendant"
	desc = "A simple black choker, with a small pendant on the front. The pendant is carefully inscribed with some simple Sinta'Unathi script in white."
	icon = 'icons/obj/custom_items/jeyne_pendant.dmi'
	icon_state = "jeyne_pendant"
	item_state = "jeyne_pendant"
	slot_flags = SLOT_MASK | SLOT_TIE
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/hooded/wintercoat/fluff/basil_coat //Consortium Magister's Robes - Basil Drabardi - aimlessanalyst
	name = "consortium magister's robes"
	desc = "Deep red robes belonging to a Consortium Magister. A curious symbol is displayed on the black tabard down it's front."
	icon = 'icons/obj/custom_items/basil_coat.dmi'
	icon_state = "basil_coat"
	item_state = "basil_coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	contained_sprite = TRUE
	hoodtype = /obj/item/clothing/head/winterhood/fluff/basil_hood

/obj/item/clothing/head/winterhood/fluff/basil_hood
	name = "consortium magister's hood"
	desc = "A hood beloging to a consortium magister's robes."
	icon = 'icons/obj/custom_items/basil_coat.dmi'
	icon_state = "basil_hood"


/obj/item/clothing/under/fluff/iskra_uniform //Worn People's Republic Service Uniform - Iskra Ayrat - alberyk
	name = "worn people's republic service uniform"
	desc = "A well-worn shirt with blue strips, coupled with brown uniform pants. It seems to be part of the people's republic of Adhomai service uniform."
	icon = 'icons/obj/custom_items/iskra_clothing.dmi'
	icon_state = "iskra_clothing"
	item_state = "iskra_clothing"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/fluff/tsali_coat //Mariziite Shroud - Cruz Tsali - serveris6
	name = "mariziite shroud"
	desc = "A worn duster coat frayed near the bottom, with a dark-hide shoulder cape thrown over the torso bearing the mark of a Mariziite warrior priest.  \
	Commonly known as the garb worn by members of the Mariziite Order in the performance of their duties."
	icon = 'icons/obj/custom_items/tsali_coat.dmi'
	icon_state = "tsali_coat"
	item_state = "tsali_coat"
	contained_sprite = TRUE


/obj/item/clothing/under/fluff/ana_uniform //Retired Uniform - Ana Roh'hi'tin - suethecake
	name = "retired uniform"
	desc = "A silken blouse paired with dark-colored slacks. It has the words \"Chief Investigator\" embroidered into the shoulder bar."
	icon = 'icons/obj/custom_items/ana_clothing.dmi'
	icon_state = "ana_uniform"
	item_state = "ana_uniform"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/forensics/fluff/ana_jacket //CSI Jacket - Ana Roh'hi'tin - suethecake
	name = "CSI jacket"
	desc = "A black jacket with the words \"CSI\" printed in the back in bright, white letters."
	icon = 'icons/obj/custom_items/ana_clothing.dmi'
	icon_state = "ana_jacket"
	item_state = "ana_jacket"
	contained_sprite = TRUE

/obj/item/clothing/accessory/badge/old/fluff/ana_badge //Faded Badge - Ana Roh'hi'tin - suethecake
	name = "faded badge"
	desc = "A faded badge, backed with leather, that reads \"NT Security Force\" across the front. It bears the emblem of the forensic division."
	stored_name = "Ana Issek"
	badge_string = "NanoTrasen Security Department"


/obj/item/clothing/head/hairflower/fluff/aquila_pin //Magnetic Flower Pin - Aquila - nandastar
	name = "magnetic flower pin"
	desc = "That's a magnet in the shape of a hair flower pin. Smells nice."


/obj/item/clothing/head/beret/engineering/fluff/ikrad_beret //LR-31MTA Beret - Ikrad Yam'hir - houseofsynth
	name = "\improper LR-31MTA beret"
	desc = "A silver beret with an insignia on the front, it looks like an old Tajaran cannon with a ring around it. \
	Along the top half of the ring \"LR-31MTA\" is engraved. The word \"Yam'hir\" is engraved along the bottom half of the ring. \
	The beret looks old and is worn in some places around the edges. It appears to have a flap inside, \
	secured by a piece of elastic that loops around a button."
	icon = 'icons/obj/custom_items/ikrad_beret.dmi'
	icon_state = "ikrad_beret"
	item_state = "ikrad_beret"
	contained_sprite = TRUE
	var/obj/item/fluff/ikrad_letter/letter

/obj/item/clothing/head/beret/engineering/fluff/ikrad_beret/Initialize()
	. = ..()
	letter = new(src)
	letter.attack_self()

/obj/item/clothing/head/beret/engineering/fluff/ikrad_beret/Destroy()
	QDEL_NULL(letter)
	return ..()

/obj/item/clothing/head/beret/engineering/fluff/ikrad_beret/attack_self(var/mob/user)
	if(letter)
		user << "<span class='notice'>You remove \the [letter] from inside the [src]'s flap.</span>"
		user.drop_from_inventory(src)
		user.put_in_hands(letter)
		user.put_in_hands(src)
		letter = null
	else
		..()

/obj/item/clothing/head/beret/engineering/fluff/ikrad_beret/attackby(var/obj/item/fluff/ikrad_letter/W, var/mob/user)
	if(!src.letter && istype(W))
		user << "<span class='notice'>You place \the [W] back inside the [src]'s flap.</span>"
		user.drop_from_inventory(W)
		W.forceMove(src)
		src.letter = W
	else
		..()

/obj/item/fluff/ikrad_letter //Tattered Letter - Ikrad Yam'hir - houseofsynth
	name = "tattered letter"
	desc = "A tattered looking piece of paper that looks to have been folded multiple times. \
	Although written in Siik'Maas it seems to be laid out like a letter, addressed to an \"Ikta Yam'hir\" and written in quite \
	an untidy scrawl. The letter is torn in some places and the is writing faded."
	icon = 'icons/obj/custom_items/ikrad_beret.dmi'
	icon_state = "ikrad_letter"
	w_class = 2


/obj/item/clothing/suit/storage/fluff/ryan_jacket //Mars' Militia Leather Jacket - Ryan McLean - seniorscore
	name = "mars militia leather jacket"
	desc = "A leather jacket, appears to have a shield on back with the words \"Contra omnes stabimus\", as well as a unit name \"Sandworms of Thadeus\", \
	stitched along a banner at the bottom of the shield."
	icon = 'icons/obj/custom_items/ryan_jacket.dmi'
	icon_state = "ryan_jacket"
	item_state = "ryan_jacket"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/fluff/yuri_duster //Martian Duster - Yuri Daruski - bv1000
	name = "martian duster"
	desc = "A longer coat made of a tough fabric designed to protect the wearer from the harshness of the Mars badlands \
	found beyond the terraformed areas of said planet. Two scorched holes can be found on the lower back, and three non-scorched holes \
	appear in the upper torso on the back, with two lining up with two in the front."
	icon = 'icons/obj/custom_items/yuri_duster.dmi'
	icon_state = "yuri_duster"
	item_state = "yuri_duster"
	contained_sprite = TRUE


/obj/item/clothing/accessory/badge/fluff/bell_badge //Detective's Credentials - Avery Bell - serveris6
	name = "detective's credentials"
	desc = "A laminated card, verifying the denoted as a private investigator licensed in Biesel. A photo of a tan-skinned human male dressed in a brown coat and hat is imprinted."
	icon = 'icons/obj/custom_items/bell_coat.dmi'
	icon_state = "bell_badge"
	item_state = "bell_badge"
	contained_sprite = TRUE
	stored_name = "Avery Bell"
	badge_string = "Silhouette Co. Consulting Detective"

	var/investigator = "Avery Bell"
	var/occupation = "Consulting Detective"
	var/birth_year = "8/8/2426"
	var/licensed_systems = "Republic of Biesel, Sol Alliance, Nralakk"
	var/supplementary_endorsements = "Licensed Medical Examiner; Sol Alliance, Republic of Biesel - Concealed firearm carry; Sol Alliance, Republic of Biesel"
	var/citizenship = "Republic of Biesel"

/obj/item/clothing/accessory/badge/fluff/bell_badge/verb/read()
	set name = "Review credentials"
	set category = "Object"
	set src in usr

	usr << "\icon[] []: The detective's credentials show:"
	usr << "The investigator registered to the credentials is [investigator]."
	usr << "The assignment registered on the card is [occupation]."
	usr << "The birth date on the card displays [birth_year]."
	usr << "The citizenship registered on the card is [citizenship]."
	usr << "The systems that the credentials show the user is licensed to investigate in are [licensed_systems]."
	usr << "Additional endorsements registered on the card show: [supplementary_endorsements]."
	return


/obj/item/clothing/head/beret/engineering/fluff/karlan_beret //Family Beret - Kar'lan Sel'ler - toasterstrudes
	name = "family beret"
	desc = "A brown beret with an orange patch. The patch have the initials; \"K.S.\" sewn into it."
	icon = 'icons/obj/custom_items/karlan_beret.dmi'
	icon_state = "karlan_beret"
	item_state = "karlan_beret"
	contained_sprite = TRUE


/obj/item/clothing/under/fluff/guskov_uniform //Tajaran Service Uniform - Guskov Andrei - fireandglory
	name = "tajaran service uniform"
	desc = "This is obviously a military service uniform, there are signs that it is of Tajaran make, modified to be a bit less warm, although it doesn't look like any uniform used by the People's Republic of Adhomai."
	icon = 'icons/obj/custom_items/guskov_uniform.dmi'
	icon_state = "guskov_uniform"
	item_state = "guskov_uniform"
	contained_sprite = TRUE


/obj/item/weapon/fluff/zhilin_book //Siik'maas-Tau Ceti Basic Dictionary - Zhilin Vadim - fireandglory
	name = "siik'maas-tau ceti basic dictionary"
	desc = "A hefty dictionary with a simple design on the cover, it seems to be for translations. There's a label on the back denoting that it belongs to a \"Zhilin Vadim\"."
	icon = 'icons/obj/custom_items/zhilin_book.dmi'
	icon_state = "zhilin_book"
	w_class = 3

/obj/item/weapon/fluff/zhilin_book/attack_self(mob/user as mob)
	user.visible_message("<span class='notice'>[user] starts flipping through \the [src].</span>",
						"<span class='notice'>You start looking through \the [src], it appears to be filled with translations of Tau-Ceti basic for tajaran users.</span>",
						"<span class='notice'>You hear pages being flipped.</span>")
	playsound(src.loc, "pageturn", 50, 1)


/obj/item/clothing/suit/storage/toggle/fluff/fay_jacket //Emergency Response Team Duty Jacket - Fai Sinsa - soundscopes
	name = "emergency response team duty jacket"
	desc = "A militaristic duty jacket worn by members of the NanoTrasen Emergency Response Teams. The nameplate reads: \"Tpr Sinsa\"."
	icon = 'icons/obj/custom_items/fai_jacket.dmi'
	icon_state = "fai_jacket"
	item_state = "fai_jacket"
	icon_open = "fai_jacket_open"
	icon_closed = "fai_jacket"
	contained_sprite = TRUE


/obj/item/clothing/under/fluff/faysal_uniform //Old Tajaran Nobleman Suit - Faysal Al-Shennawi - alberyk
	name = "old tajaran nobleman suit"
	desc = "A fancy looking suit, made of white line, adorned with golden details and buttons bearing long forgotten meanings. A blue sash decorates this piece of clothing."
	icon = 'icons/obj/custom_items/faysal_uniform.dmi'
	icon_state = "faysal_uniform"
	item_state = "faysal_uniform"
	contained_sprite = TRUE


/obj/item/clothing/glasses/welding/fluff/ghoz_eyes //Prosthetic Vaurca Eyelids - Ka'Akaix'Ghoz Zo'ra - sleepywolf
	name = "prosthetic vaurca eyelids"
	desc = "A small contraption of micro-actuators with a button on the side."
	icon = 'icons/obj/custom_items/ghoz_eyes.dmi'
	icon_state = "ghoz_eyes"
	item_state = "ghoz_eyes"
	contained_sprite = TRUE
	action_button_name = "Toggle Eyelids"
	species_restricted = list("Vaurca") //i think this would make sense since those are some kind of vaurca build prothestic


/obj/item/clothing/head/det/fluff/leo_hat //Tagged brown hat - Leo Wyatt - keinto
	name = "tagged brown hat"
	desc = "A worn mid 20th century brown hat. If you look closely at the back, you can see a an embedded tag from the \"Museum of Terran Culture and Technology\"."
	icon = 'icons/obj/custom_items/leo_coat.dmi'
	icon_state = "leo_hat"
	item_state = "leo_hat"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/det_trench/fluff/leo_coat //Tagged brown coat - Leo Wyatt - keinto
	name = "tagged brown coat"
	desc = "A worn mid 20th century brown trenchcoat. If you look closely at bottom of the back, you can see an embedded tag from the \"Museum of Terran Culture and Technology\"."
	icon = 'icons/obj/custom_items/leo_coat.dmi'
	icon_state = "leo_coat"
	item_state = "leo_coat"
	contained_sprite = TRUE


/obj/item/weapon/nullrod/fluff/azaroz_staff //Null Staff - Kesaos Azaroz - paradoxspace
	name = "null staff"
	desc = "A long, heavy staff seemingly hand-crafted of obsidian and steel. Pure volcanic crystals lie at its end, giving it an appearance similar to a mace."
	icon = 'icons/obj/custom_items/azaroz_staff.dmi'
	icon_state = "azaroz_staff"
	item_state = "azaroz_staff"
	contained_sprite = TRUE
	slot_flags = SLOT_BACK
	w_class = 3


/obj/item/clothing/suit/fluff/eul_robe //Well Made Robe - Uelak Eul - lordraven001
	name = "well made robe"
	desc = "A well made brown robe fashioned from viscose fabric with a white jabot dangling from the neck. There is a tail whole cut out in the back and the sleeves and lower skirt of the robe have been elongated. \
	It looks old from wear and tear."
	icon = 'icons/obj/custom_items/eul_clothing.dmi'
	icon_state = "eul_robe"
	item_state = "eul_robe"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	contained_sprite = TRUE

/obj/item/clothing/glasses/regular/fluff/eul_glasses //Chained Wooden Spectacles - Uelak Eul - lordraven001
	name = "chained wooden spectacles"
	desc = "A pair of wooden spectacles with a long bronze chain out the back of them. They have been bejeweled by benitoite and look elder from use."
	icon = 'icons/obj/custom_items/eul_clothing.dmi'
	icon_state = "eul_glasses"
	item_state = "eul_glasses"
	contained_sprite = TRUE


/obj/item/clothing/suit/poncho/fluff/flaming_poncho //Stitched Heart White Poncho - Flaming Hearts Love Stars - sleepywolf
	name = "stitched heart white poncho"
	desc = "A white poncho stitched together shoddily, with a pink heart made of flame patterned on the front. The fabric is rough, like chainmail."
	icon = 'icons/obj/custom_items/flaming_poncho.dmi'
	icon_state = "flaming_poncho"
	item_state = "flaming_poncho"
	contained_sprite = TRUE


/obj/item/clothing/accessory/badge/fluff/jane_badge //Tarnished Badge - Jane Pyre - somethingvile
	name = "tarnished badge"
	desc = "A worn, tarnished brass badge with ash and soot set deep in the grooves of its surface. The word, though faded and barely discernible, \"Pyre\" can be traced out lining its bottom edge."
	icon = 'icons/obj/custom_items/jane_badge.dmi'
	icon_state = "jane_badge"
	item_state = "jane_badge"
	slot_flags = SLOT_BELT | SLOT_TIE
	contained_sprite = TRUE
	stored_name = "Francis Pyre"
	badge_string = "CPD"


/obj/item/toy/plushie/fluff/oz_plushie //Mr. Monkey - Oz Auman - theiguanaman2
	name = "\improper Mr.Monkey"
	desc = "A calming toy monkey."
	icon = 'icons/obj/custom_items/oz_plushie.dmi'
	icon_state = "oz_plushie"


/obj/item/clothing/suit/storage/fluff/vizili_mantle //Maraziite Throw Over - Urzkrauzi Vizili - jackboot
	name = "maraziite throw over"
	desc = "A worn, grey poncho exclusively worn by members of the Maraziite Order."
	icon = 'icons/obj/custom_items/vizili_clothing.dmi'
	icon_state = "vizili_mantle"
	item_state = "vizili_mantle"
	contained_sprite = TRUE

/obj/item/clothing/mask/fluff/vizili_mask //Iron Mask - Urzkrauzi Vizili - jackboot
	name = "iron mask"
	desc = "A mask made of iron worn by members of the Maraziite Order. It can strike dread in the hearts of Unathi that don't toe the line of Sk'akh orthodoxy."
	icon = 'icons/obj/custom_items/vizili_clothing.dmi'
	icon_state = "vizili_mask"
	item_state = "vizili_mask"
	contained_sprite = TRUE
	flags_inv = HIDEEARS|HIDEFACE
	body_parts_covered = FACE
	w_class = 3.0


/obj/item/weapon/reagent_containers/food/drinks/teapot/fluff/brianne_teapot	//Ceramic Teapot - Sean Brianne - zelmana
	name = "ceramic teapot"
	desc = "A blue ceramic teapot, gilded with the abbreviation for NanoTrasen."
	icon = 'icons/obj/custom_items/brianne_teapot.dmi'
	icon_state = "brianne_teapot"


/obj/item/weapon/reagent_containers/food/drinks/flask/fluff/nasser_flask //Workers Flask - Nasser Antonov - sonicgotnuked
	name = "workers flask"
	desc = "A steel fold down flask that is dented and scratched. It looks like some parts are welded together, making it so it can not fold down anymore. It smells strongly of vodka.."
	icon = 'icons/obj/custom_items/nasser_flask.dmi'
	icon_state = "nasser_flask"
	volume = 55


/obj/item/clothing/head/beret/engineering/fluff/make_beret //Tan Engineering Beret - M.A.K.E - toasterstrudes
	name = "tan engineering beret"
	desc = "An engineering beret that appears to have been dyed tan, with an orange patch sewn into the middle of it."
	icon = 'icons/obj/custom_items/make_items.dmi'
	icon_state = "make_beret"
	item_state = "make_beret"
	contained_sprite = TRUE

/obj/item/device/radio/headset/fluff/make_antenna //Antenna - M.A.K.E - toasterstrudes
	name = "antenna"
	desc = "An antenna attachment that can be screwed into the side of an IPC's head. It looks to have radio functions."
	icon = 'icons/obj/custom_items/make_items.dmi'
	icon_state = "make_antenna"
	item_state = "make_antenna"
	contained_sprite = TRUE


/obj/item/clothing/mask/fluff/corvo_cigarette //Vaporizer Pen - Nathan Corvo - jkjudgex
	name = "vaporizer pen"
	desc = "A simple vaporizer pen, the electronic version of the cigarette."
	icon = 'icons/obj/custom_items/corvo_cigarette.dmi'
	icon_state = "corvo_cigarette"
	item_state = "corvo_cigarette"
	body_parts_covered = 0
	w_class = 2
	slot_flags = SLOT_EARS | SLOT_MASK
	contained_sprite = TRUE
	var/active = FALSE

/obj/item/clothing/mask/fluff/corvo_cigarette/attack_self(mob/user)
	active= !active
	if(active)
		user << "<span class='notice'>You turn \the [src] on.</span>"
	else
		user << "<span class='notice'>You turn \the [src] off.</span>"

	update_icon()
	user.update_inv_l_hand(FALSE)
	user.update_inv_r_hand()

/obj/item/clothing/mask/fluff/corvo_cigarette/update_icon()
	if(active)
		icon_state = "corvo_cigarette_on"
		item_state = "corvo_cigarette_on"
	else
		icon_state = "corvo_cigarette"
		item_state = "corvo_cigarette"

/obj/item/clothing/mask/fluff/corvo_cigarette/examine(mob/user)
	if(..(user, 1))
		user << "It is [active ? "on" : "off"]."

/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac/fluff/leonce_cognac //Old Earth Luxury Cognac - Francois Leonce - driecg36
	name = "old earth luxury cognac"
	desc = "An unusually shaped crystal bottle, covered in elaborate etchings displaying the symbol of the house that produced it. Inside is a smooth, amber liquor, \
	which smells of the barrel it was aged in. The region and producer are on the label."
	icon = 'icons/obj/custom_items/leonce_cognac.dmi'
	icon_state = "leonce_cognac"


/obj/item/clothing/under/fluff/birkin_uniform //White Suit - Joseph Birkin - unknownmurder
	name = "white suit"
	desc = "This collared uniform appears to be little wrinkled and the tie is a bit loose from the collar. The jean seems to be neatly straight with the leather belt attached."
	icon = 'icons/obj/custom_items/birkin_uniform.dmi'
	icon_state = "birkin_uniform"
	item_state = "birkin_uniform"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/fluff/sonorous_mantle //Maraziite Throw Over - Sonorous Zouzoror - sleepywolf
	name = "maraziite throw over"
	desc = "A grey poncho, exclusively warn by members of the Maraziite Order. This one has the flag of the Izweski Hegemony stitched on."
	icon = 'icons/obj/custom_items/sonorous_clothing.dmi'
	icon_state = "sonorous_mantle"
	item_state = "sonorous_mantle"
	contained_sprite = TRUE

/obj/item/clothing/mask/fluff/sonorous_mask //Iron Mask - Sonorous Zouzoror - sleepywolf
	name = "iron mask"
	desc = "A mask made of iron worn by members of the Maraziite Order. This one looks like it's modeled after a fish."
	icon = 'icons/obj/custom_items/sonorous_clothing.dmi'
	icon_state = "sonorous_mask"
	item_state = "sonorous_mask"
	contained_sprite = TRUE
	flags_inv = HIDEEARS|HIDEFACE
	body_parts_covered = FACE
	w_class = 3.0


/obj/item/clothing/under/fluff/ellie_uniform //Cheery Blazer - Ellie Shoshanna - resilynn
	name = "cheery blazer"
	desc = "A cheery but professional outfit, mauve corduroys, blue blazer and a tie."
	icon = 'icons/obj/custom_items/ellie_uniform.dmi'
	icon_state = "ellie_uniform"
	item_state = "ellie_uniform"
	contained_sprite = TRUE


/obj/item/clothing/accessory/fluff/zhilin_necklace //Tajaran Religious Necklace - Zhilin Vadim - fireandglory
	name = "tajaran religious necklace"
	desc = "A necklace with black string, it appears to have carved wooden figures of the Tajaran god Mata'ke and all of his pantheon strung through it."
	icon = 'icons/obj/custom_items/zhilin_necklace.dmi'
	icon_state = "zhilin_necklace"
	item_state = "zhilin_necklace"
	contained_sprite = TRUE
	slot_flags = SLOT_EARS | SLOT_TIE


/obj/item/weapon/book/fluff/huntington_book //Spark Theorem - Monica Huntington - moondancerpony
	name = "\improper Spark Theorem"
	desc = "A bound copy of the 2458 research paper \"Spark Theorem: Research Into the Development of Synthetic Consciousness and Sapience\". This one is signed by the author."
	title = "Spark Theorem"
	icon_state = "book6"
	author = "Kyyir'ry'avii 'Karima' Ile'nagrii Al'Ghul-Mo'Taki"
	dat = "<!doctype html><html style=\"width:100%;height:100%;\"><head><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"></head><body><iframe style=\"width:100%;height:100%\" src=\"https://assets.lohikar.io/mdp/sparktheorem.html\"></iframe></body></html>"
	due_date = 0
	unique = 1


/obj/item/clothing/shoes/fluff/hikmat_shoes //Native Tajaran Foot-wear - Hikmat Rrhazkal-Jawdat - prospekt1559
	name = "native tajaran foot-wear"
	desc = "Native foot and leg wear worn by Tajara, completely covering the legs in wraps and the feet in native Tajaran fabric."
	icon = 'icons/obj/custom_items/hikmat_shoes.dmi'
	icon_state = "hikmat_shoes"
	item_state = "hikmat_shoes"
	species_restricted = null
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/fluff/vira_coat //Designer Military Coat - Vira Bolivar - scheveningen
	name = "designer military coat"
	desc = "A dark funnel neck designer military-style dress coat, specially fitted on commission, clearly designed for a woman's figure. \
	A skillfully stitched 'NT' pattern is laden above a chest pocket, the phrase \"15 years of loyal service to the Corp\" below the insignia, followed by the personal signature of \"Vira Bolivar Taryk\"."
	icon = 'icons/obj/custom_items/vira_coat.dmi'
	icon_state = "vira_coat"
	item_state = "vira_coat"
	contained_sprite = TRUE


/obj/item/weapon/storage/backpack/satchel/fluff/kresimir_bag //Worn Leather Bag - Kresimir Kostadinov - alberyk
	name = "worn leather bag"
	desc = "A sturdy and worn leather bag. The clasp has a faded blue and golden insigna."
	icon = 'icons/obj/custom_items/kresimir_bag.dmi'
	icon_state = "kresimir_bag"
	item_state = "kresimir_bag"
	contained_sprite = TRUE


/obj/item/weapon/stamp/fluff/leland_stamp //Sol Alliance Government Foreign Relations Department Stamp - Leland Field - saudus
	name = "\improper Sol Alliance foreign relations department stamp"
	desc = "A stamp with the emblem of the Sol Alliance Foreign Relations Department. The text \"Diplomatic Observer, L. Field\" is inscribed on the handle."
	icon = 'icons/obj/custom_items/leland_items.dmi'
	icon_state = "leland_stamp"
	item_state = "leland_stamp"

/obj/item/clothing/accessory/badge/fluff/leland_badge //Sol Alliance Government Foreign Relations Department Badge - Leland Field - saudus
	name = "\improper Sol Alliance foreign relations department badge"
	desc = "A badge bearing the emblem of the Sol Alliance Foreign Relations Department. It has an inscription reading \"Leland Field, Diplomatic Observer\"."
	icon = 'icons/obj/custom_items/leland_items.dmi'
	icon_state = "leland_badge"
	stored_name = "Leland Field"
	badge_string = "Diplomatic Observer"

/obj/item/clothing/accessory/badge/fluff/leland_badge/verb/flip()
	set name = "Flip the Badge"
	set desc = "Open or close the badge."
	set category = "Object"
	set src in usr

	if(src.icon_state == "leland_badge")
		src.icon_state = "leland_badge-info"
		usr << "You open \the [src]."
	else
		src.icon_state = "leland_badge"
		usr << "You close \the [src]."


/obj/item/clothing/suit/storage/fluff/azala_coat //Azala's Gentleman's Coat - Azala Guwan - tomiixstarslasher
	name = "gentleman's coat"
	desc = "A blue gentleman's coat. It is very stylish, and appears to be very warm."
	icon = 'icons/obj/custom_items/azala_items.dmi'
	icon_state = "azala_coat"
	item_state = "azala_coat"
	contained_sprite = TRUE

/obj/item/clothing/head/fluff/azala_hat //Azala's Gentleman's Cap - Azala Guwan - tomiixstarslasher
	name = "gentleman's cap"
	desc = "A blue gentleman's cap. It is very stylish, and appears to be warped from being worn crooked."
	icon = 'icons/obj/custom_items/azala_items.dmi'
	icon_state = "azala_hat"
	item_state = "azala_hat"
	contained_sprite = TRUE

/obj/item/clothing/under/fluff/azala_jumpsuit //Azala's Roboticist Jumpsuit - Azala Guwan - tomiixstarslasher
	name = "modified roboticist jumpsuit"
	desc = "A variation of the roboticists jumpsuit, this one is in blue colors."
	icon = 'icons/obj/custom_items/azala_items.dmi'
	icon_state = "azala_jumpsuit"
	item_state = "azala_jumpsuit"
	contained_sprite = TRUE


/obj/item/clothing/suit/fluff/leo_scarf //Scarf - Leo Wyatt - keinto
	name = "striped scarf"
	desc = "A soft scarf striped in black and blue."
	icon = 'icons/obj/custom_items/leo_scarf.dmi'
	icon_state = "leo_scarf"
	item_state = "leo_scarf"
	contained_sprite = TRUE


/obj/item/clothing/under/rank/medical/fluff/jurlkiitajr_scrubs //IAC Scrubs - Rajii'rkalahk Jurlkiitajr - jackboot
	name = "\improper IAA scrubs"
	desc = "A change of sterile medical scrubs worn by IAC workers. This one is specific for Tajara Aid workers."
	icon = 'icons/obj/custom_items/jurlkiitajr_items.dmi'
	icon_state = "jurlkiitajr_scrubs"
	item_state = "jurlkiitajr_scrubs"
	contained_sprite = TRUE

/obj/item/clothing/suit/apron/surgery/fluff/jurlkiitajr_vest //IAC Vest - Rajii'rkalahk Jurlkiitajr - jackboot
	name = "\improper IAA vest"
	desc = "A vest designed to distinguish medical workers in the Interstellar Aid Corps."
	icon = 'icons/obj/custom_items/jurlkiitajr_items.dmi'
	icon_state = "jurlkiitajr_vest"
	item_state = "jurlkiitajr_vest"
	contained_sprite = TRUE


/obj/item/clothing/under/fluff/zilosnish_uniform //Exotic Purple Robe - Zilosnish Szu - sleepywolf
	name = "exotic purple robe"
	desc = "An extravagant display of wealth, hand-tailored with Unathi craftmanship. There are intricate designs of hammers, cactus flowers, and coins etched into the cloth."
	icon = 'icons/obj/custom_items/zilosnish_items.dmi'
	icon_state = "zilosnish_uniform"
	item_state = "zilosnish_uniform"
	contained_sprite = TRUE

/obj/item/clothing/suit/unathi/mantle/fluff/zilosnish_mantle //Exotic Mantle - Zilosnish Szu - sleepywolf
	name = "exotic mantle"
	desc = "A red hide with a gold and jade insignia pin to keep it on a wearers shoulders. The hide is thick, like rhino skin."
	icon = 'icons/obj/custom_items/zilosnish_items.dmi'
	icon_state = "zilosnish_mantle"
	item_state = "zilosnish_mantle"
	contained_sprite = TRUE

/obj/item/weapon/pen/fluff/zilosnish_pen //Golden Pen - Zilosnish Szu - sleepywolf
	name = "golden pen"
	desc = "A pen plated in gold. It has black ink."
	icon = 'icons/obj/custom_items/zilosnish_items.dmi'
	icon_state = "zilosnish_pen"


/obj/item/clothing/head/fluff/qorja_headband //Rebellious Headband - Q'orja Sak'ha - fortport
	name = "rebellious headband"
	desc = "A comfortable headband made from a long, soft cloth that's tied into a knot in the back. It is a bright shade of red, slipped through a decorative brass plate. \
	Upon the metal is an engraving of the People's Republic of Adhomai's insignia, as if straight from their flag."
	icon = 'icons/obj/custom_items/qorja_headband.dmi'
	icon_state = "qorja_headband"
	item_state = "qorja_headband"
	contained_sprite = TRUE


/obj/item/clothing/glasses/regular/fluff/harley_glasses //Chic Sunglasses - Harley O'Ryan - ornias
	name = "chic sunglasses"
	desc = "A relatively expensive set of Phoenixport-manufactured sunglasses. They do not look like they would provide much protection."
	icon = 'icons/obj/custom_items/harley_clothing.dmi'
	icon_state = "harley_glasses"
	item_state = "harley_glasses"
	contained_sprite = TRUE

/obj/item/clothing/under/fluff/harley_uniform //Phoenixport Shirt - Harley O'Ryan - ornias
	name = "\improper Phoenixport shirt"
	desc = "A white t-shirt with the writing \"Eiffel Tower Diner\" on it in a small font, below a recreation of the famous monument in question, the Eiffel Tower."
	icon = 'icons/obj/custom_items/harley_clothing.dmi'
	icon_state = "harley_uniform"
	item_state = "harley_uniform"
	contained_sprite = TRUE

/obj/item/clothing/under/fluff/harley_uniform/verb/change_tshirt()
	set name = "Change the shirt style"
	set desc = "Change the style of your shirt."
	set category = "Object"
	set src in usr

	if (use_check(usr)) return

	var/style = input("You change the shirt to;","Change the shirt style") as null|anything in list("Eiffel Tower Diner","Pyramids of Giza Café","Phoenixport","New Parthenon")
	switch(style)
		if("Eiffel Tower Diner")
			item_state = "harley_uniform"
			desc = "A white t-shirt with the writing \"Eiffel Tower Diner\" on it in a small font, below a recreation of the famous monument in question, the Eiffel Tower."

		if("Pyramids of Giza Café")
			item_state = "harley_uniform_1"
			desc = "A white t-shirt with \"GIZA CAFÉ\" written in large, retro font, with a small background. It looks slightly well-worn."

		if("Phoenixport")
			item_state = "harley_uniform_2"
			desc = "A black vintage shirt with \"PHOENIXPORT\" written on it in a font. A small icon of an orange phoenix is perched on the \"O\"."

		if("New Parthenon")
			item_state = "harley_uniform_3"
			desc = "A grey t-shirt with a stylistic white, faded depiction of the Parthenon on it. It has been cut in half, displaying the inside, with sections clearly labelled in small font."

	usr.update_inv_w_uniform()
	usr.visible_message("<span class='notice'>[user] fumbles with \the [src], changing the shirt..</span>",
						"<span class='notice'>You change \the [src]'s style to be '[style]'.</span>")


/obj/item/clothing/gloves/watch/fluff/rex_watch //Engraved Wristwatch - Rex Winters - tailson
	name = "engraved wristwatch"
	desc = " A fine gold watch. On the inside is an engraving that reads \"Happy birthday dad, thinking of you always\"."
	icon = 'icons/obj/custom_items/rex_watch.dmi'
	icon_state = "rex_watch"


/obj/item/device/camera/fluff/hadley_camera //Hadley's Camera - Hadley Dawson - fekkor
	name = "customized camera"
	desc = "A early 2450's Sunny camera with an adjustable lens, this one has a sticker with the name \"Hadley\" on the back."
	icon = 'icons/obj/custom_items/hadley_camera.dmi'
	icon_state = "hadley_camera"
	icon_on = "hadley_camera"
	icon_off = "hadley_camera_off"


/obj/item/clothing/accessory/medal/silver/fluff/kalren_medal //Silver Star of Merit - Kalren Halstere - brutishcrab51
	name = "silver star of merit"
	desc = "The Biesel Silver Star of Merit, rewarded for bravery and professionalism in the line of duty."
	icon_state = "silver_sword"
