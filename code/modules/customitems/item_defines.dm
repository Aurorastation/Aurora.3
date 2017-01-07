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
			usr << "You close the [src]."
			desc = "The design of this pocket watch signals its age, however it seems to retain its pristine quality. The cover is gold, and there appears to be an elegant crest on the outside of the lid."
		if("pocket_watch_close")
			icon_state = "pocket_watch_open"
			usr << "You open the [src]."
			desc = "Inside the pocket watch, there is a collection of numbers, displaying '[worldtime2text()]'. On the inside of the lid, there is another sequence of numbers etched into the lid itself."


/obj/item/clothing/head/soft/sec/corp/fluff/mendoza_cap //Mendoza's cap - Chance Mendoza - loow
	name = "well-worn corporate security cap"
	desc = "A baseball hat in corporate colors.'C. Mendoza' is embroidered in fine print on the bill. On the underside of the cap, in dark ink, the phrase 'Gamble till you're Lucky!' is written in loopy cursive handwriting."


/obj/item/clothing/head/fluff/ziva_bandana //Ziva's Bandana - Ziva Ta'Kim - sierrakomodo
	name = "old bandana"
	desc = "An old orange-ish-yellow bandana. It has a few stains from engine grease, and the color has been dulled."
	icon = 'icons/obj/custom_items/motaki_bandana.dmi'
	icon_state = "motaki_bandana"
	item_state = "motaki_bandana"
	contained_sprite = 1


/obj/item/clothing/suit/armor/vest/fluff/zubari_jacket //Fancy Jacket - Zubari Akenzua - filthyfrankster
	name = "fancy jacket"
	desc = "A well tailored unathi styled armored jacket, fitted for one too."
	icon = 'icons/obj/custom_items/zubari_jacket.dmi'
	icon_state = "zubari_jacket"
	item_state = "zubari_jacket"
	contained_sprite = 1


/obj/item/clothing/suit/unathi/mantle/fluff/yinzr_mantle //Heirloom Unathi Mantle - Sslazhir Yinzr - alberyk
	name = "heirloom unathi mantle"
	desc = "A withered mantle sewn from threshbeast's hides, the pauldrons that holds it on the shoulders seems to be the remains of some kind of old armor."
	icon = 'icons/obj/custom_items/yinzr_mantle.dmi'
	icon_state = "yinzr_mantle" //special thanks to Araskael
	item_state = "yinzr_mantle"
	species_restricted = list("Unathi") //forged for lizardmen
	contained_sprite = 1


/obj/item/clothing/glasses/fluff/nebula_glasses	//chich eyewear - Roxy Wallace - nebulaflare
	name = "chic eyewear"
	desc = "A stylish pair of glasses. They look custom made."
	icon = 'icons/obj/custom_items/nebula_glasses.dmi'
	icon_state = "nebula_glasses"
	item_state = "nebula_glasses"
	contained_sprite = 1
	var/obj/item/weapon/disk/chip

/obj/item/clothing/glasses/fluff/nebula_glasses/New()
	chip = new /obj/item/weapon/disk/fluff/nebula_chip()
	..()

/obj/item/clothing/glasses/fluff/nebula_glasses/attack_self(mob/user as mob)
	if(chip)
		user.put_in_hands(chip)
		user << "<span class='notice'>You eject a small, concealed data chip from a small slot in the frames of the [src].</span>"
		chip = null

/obj/item/clothing/glasses/fluff/nebula_glasses/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/disk/fluff/nebula_chip) && !chip)
		//user.u_equip(W)
		user.drop_from_inventory(W)
		W.forceMove(src)
		chip = W
		W.add_fingerprint(user)
		add_fingerprint(user)
		user << "You slot the [W] back into its place in the frames of the [src]."

/obj/item/weapon/disk/fluff/nebula_chip //data chip - Roxy Wallace - nebulaflare
	name = "data chip"
	desc = "A small green chip."
	icon = 'icons/obj/custom_items/nebula_chip.dmi'
	icon_state = "nebula_chip"
	w_class = 1


/obj/item/clothing/gloves/swat/fluff/hawk_gloves //Sharpshooter gloves - Hawk Silverstone - nebulaflare
	name = "\improper sharpshooter gloves"
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
	slot_flags = SLOT_MASK


/obj/item/clothing/ears/skrell/fluff/dompesh_cloth //Skrell Purple Head Cloth - Shkor-Dyet Dom'Pesh - mofo1995
	name = "male skrell purple head cloth"
	desc = "A purple cloth band worn by male skrell around their head tails."
	icon = 'icons/obj/custom_items/dompesh_cloth.dmi'
	icon_state = "dompesh_cloth"
	item_state = "dompesh_cloth"
	contained_sprite = 1


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
	icon = 'icons/obj/custom_items/bell_hat.dmi'
	icon_state = "bell_hat"
	item_state = "bell_hat"
	contained_sprite = 1

/obj/item/clothing/suit/storage/det_trench/fluff/bell_coat //Pinned Brown Coat - Avery Bell - serveris6
	name = "pinned brown coat"
	desc = "A worn mid 20th century brown trenchcoat. If you look closely at the breast, you can see an ID flap stitched into the leather - 'Avery Bell, Silhouette Co.'."
	icon = 'icons/obj/custom_items/bell_coat.dmi'
	icon_state = "bell_coat"
	item_state = "bell_coat"
	contained_sprite = 1


/obj/item/clothing/under/syndicate/tacticool/fluff/jaylor_turtleneck //Borderworlds Turtleneck - Jaylor Rameau - evilbrage
	name = "borderworlds turtleneck"
	desc = "A loose-fitting turtleneck, common among borderworld pilots and criminals. One criminal in particular is missing his, apparently."


/obj/item/weapon/melee/fluff/tina_knife //Consecrated Athame - Tina Kaekel - tainavaa
	name = "consecrated athame"
	desc = "An athame used in occult rituals. The double-edged dagger is dull. The handle is black with a pink/white occult design strewn about it, and 'Tina' is inscribed into it in decorated letters."
	icon = 'icons/obj/custom_items/tina_knife.dmi'
	icon_state = "tina_knife"
	item_state = "knife"
	slot_flags = SLOT_BELT
	w_class = 1
	force = 2


/obj/item/device/kit/paint/ripley/fluff/zairjah_kit //Hephaestus Industrial Exosuit MK III Customization Kit - Zairjah - alberyk
	name = "Hephaestus Industrial Exosuit MK III customization kit"
	desc = "A ripley APLU model manufactured by Hephaestus industries, a common sight in New Gibson nowadays. It shines with chrome painting and a fancy reinforced glass cockpit."
	new_name = "Hephaestus Industrial Exosuit MK III"
	new_desc = "An ripley APLU model manufactured by Hephaestus industries, a common sight in New Gibson nowadays. It shines with chrome painting and a fancy reinforced glass cockpit."
	new_icon = "ripley_zairjah" //a lot of thanks to cakeisossim for the sprites
	allowed_types = list("ripley","firefighter")


/obj/item/weapon/cane/fluff/usiki_cane //Inscribed Silver-handled Cane - Usiki Guwan - fireandglory
	name = "inscribed silver-handled cane"
	desc = "This silver-handled cane has letters carved into the sides."
	icon = 'icons/obj/custom_items/usiki_cane.dmi'
	icon_state = "usiki_cane"
	item_state = "usiki_cane"
	contained_sprite = 1

/obj/item/weapon/cane/fluff/usiki_cane/attack_self(mob/user as mob)
	if(user.get_species() == "Unathi")
		user << "This cane has the words 'A new and better life' carved into one side in basic, and on the other side in Sinta'Unathi."
	else
		user << "This cane has the words 'A new and better life' carved into the side, the other side has some unreadable carvings."


/obj/item/clothing/gloves/black/fluff/kathleen_glove //Black Left Glove - Kathleen Mistral - valkywalky2
	name = "black left glove"
	desc = "A pretty normal looking glove to be worn on the left hand."
	icon = 'icons/obj/custom_items/kathleen_glove.dmi'
	icon_state = "kathleen_glove"
	item_state = "kathleen_glove"
	contained_sprite = 1


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
	contained_sprite = 1


/obj/item/clothing/mask/gas/fluff/karnaikai_mask //Unathi head wrappings - Azeazekal Karnaikai - canon35
	name = "unathi head wrappings"
	desc = "A bunch of stitched together bandages with a fibreglass breath mask on it, openings for the eyes. Looks tailored for an unathi."
	icon = 'icons/obj/custom_items/karnaikai_mask.dmi'
	icon_state = "karnaikai_mask" //special thanks to Araskael
	item_state = "karnaikai_mask"
	species_restricted = list("Unathi")
	contained_sprite = 1


/obj/item/weapon/contraband/poster/fluff/conservan_poster //ATLAS poster - Conservan Xullie - conservatron
	name = "ATLAS poster"

/obj/item/weapon/contraband/poster/fluff/conservan_poster/New()
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
	contained_sprite = 1


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
	desc = "A small cerimonial energy dagger given to Golden Tigers."
	icon = 'icons/obj/custom_items/moon_baton.dmi'
	icon_state = "tigerclaw"
	item_state = "tigerclaw"
	slot_flags = SLOT_BELT
	force = 2
	w_class = 2
	contained_sprite = 1
	var/active = 0

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
	user.regenerate_icons()


/obj/item/clothing/suit/armor/vest/fabian_coat //NT APF Armor - Fabian Goellstein - mirkoloio
	name = "NT APF armor"
	desc = "This is a NT Asset Protection Force Armor, it is fashioned as a jacket in NT Security Colors. The nameplate carries the Name 'Goellstein'."
	icon = 'icons/obj/custom_items/fabian_coat.dmi'
	icon_state = "fabian_coat_open"
	item_state = "fabian_coat_open"
	contained_sprite = 1

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
			usr << "You attempt to button-up the velcro on your [src], before promptly realising how silly you are."
			return

	usr.update_inv_wear_suit()

/obj/item/clothing/head/beret/centcom/officer/fluff/fabian_beret //Worn Security Beret - Fabian Goellstein - mirkoloio
	name = "worn security beret"
	desc = "A NT Asset Protection Force Beret. It has the NT APF insignia on it as well as the Name 'Goellstein' inside."


/obj/item/clothing/accessory/armband/fluff/vittorio_armband //ATLAS Armband - Vittorio Giurifiglio - tytostyris
	name = "Atlas armband"
	desc = "This is an atlas armband showing anyone who sees this person, as a member of the Political party Atlas."
	icon = 'icons/obj/custom_items/vittorio_armband.dmi'
	icon_state = "vittorio_armband"
	item_state = "vittorio_armband"
	contained_sprite = 1

/obj/item/clothing/head/fluff/vittorio_fez //Black Fez - Vittorio Giurifiglio - tytostyris
	name = "black fez"
	desc = "It is a black fez, it bears an Emblem of the Astronomical symbol of Earth, It also has some nice tassels."
	icon = 'icons/obj/custom_items/vittorio_fez.dmi'
	icon_state = "vittorio_fez"
	item_state = "vittorio_fez"
	contained_sprite = 1


/obj/item/clothing/suit/fluff/centurion_cloak //Paludamentum - Centurion - cakeisossim
	name = "paludamentum"
	desc = "A cloak-like piece of silky, red fabric. Fashioned at one point where the shoulder would be with a golden pin."
	icon = 'icons/obj/custom_items/centurion_cloak.dmi'
	icon_state = "centurion_cloak"
	item_state = "centurion_cloak"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	contained_sprite = 1


/obj/item/clothing/ears/bandanna/fluff/kir_bandanna //Kir's Bandanna - Kir Iziki - araskael
	name = "purple bandanna"
	desc = "A worn and faded purple bandanna with a knotted, dragon-like design on it."
	icon = 'icons/obj/custom_items/kir_bandanna.dmi'
	icon_state = "kir_bandanna"
	item_state = "kir_bandanna"
	contained_sprite = 1


/obj/item/clothing/suit/storage/toggle/bomber/fluff/ash_jacket //Hand-me-down Bomber Jacket - Ash LaCroix - superballs
	name = "hand-me-down bomber jacket"
	desc = "A custom tailored bomber jacket that seems to have been through some action. A silver badge is pinned to it, along with a black and blue strip covering it halfway. The badge reads, \"Christopher LaCroix, Special Agent, Mendell City, E.O.W. 10-7-38, 284\""
	icon = 'icons/obj/custom_items/ash_jacket.dmi'
	icon_state = "ash_jacket"
	item_state = "ash_jacket"
	icon_open = "ash_jacket_open"
	icon_closed = "ash_jacket"
	contained_sprite = 1


/obj/item/clothing/accessory/badge/holo/cord/fluff/dylan_tags //Dog Tags - Dylan Sutton - sircatnip
	name = "dog tags"
	desc = "Some black dog tags, engraved on them is the following: \"Wright, Dylan L, O POS, Pacific Union Special Forces.\""
	icon = 'icons/obj/custom_items/dylan_tags.dmi'
	icon_state = "dylan_tags"
	item_state = "dylan_tags"
	stored_name = "Wright, Dylan L"
	badge_string = "Pacific Union Special Forces"
	contained_sprite = 1


/obj/item/clothing/ears/fluff/rico_stripes //Racing Stripes - Ricochet - nebulaflare
	name = "racing stripes"
	desc = "A pair of fancy racing stripes."
	icon = 'icons/obj/custom_items/rico_stripes.dmi'
	icon_state = "rico_stripes"
	item_state = "rico_stripes"
	contained_sprite = 1
	canremove = 0
	abstract = 1
	species_restricted = list("Baseline Frame")


/obj/item/weapon/reagent_containers/food/drinks/flask/fluff/barcia_flask //First Shot - Gabriel Barcia - mrgabol100
	name = "first shot"
	desc = "A flask. Smells of absinthe, maybe vodka. The bottom left corner has a silver bar. \"The bottom is engraved, it reads 'The First Shot\"."
	icon = 'icons/obj/custom_items/barcia_flask.dmi'
	icon_state = "barcia_flask"


/obj/item/clothing/gloves/fluff/stone_ring //Thunder Dome Pendant Ring - Jerimiah Stone - dominicthemafiaso
	name = "thunder dome pendant ring"
	desc = "It appears to be a Collectors edition Thunder dome Pendant ring from the IGTDL's show rumble in the red planet in 2444. It has a decorative diamond center with a image of the Intergalactic belt in the center."
	icon = 'icons/obj/custom_items/stone_ring.dmi'
	icon_state = "stone_ring"
	item_state = "stone_ring"
	contained_sprite = 1
	clipped = 1
	species_restricted = null

/obj/item/clothing/under/dress/fluff/sayyidah_dress //Traditional Jumper Dress - Sayyidah Al-Kateb - alberyk
	name = "traditional jumper dress"
	desc = "A light summer-time dress, decorated neatly with black and silver colors, it seems to be rather old."
	icon = 'icons/obj/custom_items/sayyidah_dress.dmi' //special thanks to Coalf for the sprites
	icon_state = "sayyidah_dress"
	item_state = "sayyidah_dress"
	contained_sprite = 1


/obj/item/clothing/suit/storage/fluff/vittorio_jacket //Atlas Overcoat - Vittorio Giurifiglio - tytostyris
	name = "atlas overcoat"
	desc = "A classy black militaristic uniform, which is adorned with a sash and an eagle."
	icon = 'icons/obj/custom_items/vittorio_jacket.dmi'
	icon_state = "vittorio_jacket"
	item_state = "vittorio_jacket"
	contained_sprite = 1


/obj/item/clothing/suit/storage/toggle/labcoat/fluff/helmut_labcoat //CERN Labcoat - Helmut Kronigernischultz - pyrociraptor
	name = "CERN labcoat"
	desc = "A Labcoat with a blue pocket and blue collar. On the pocket, you can read \"C.E.R.N.\"."
	icon = 'icons/obj/custom_items/helmut_labcoat.dmi'
	icon_state = "helmut_labcoat"
	item_state = "helmut_labcoat"
	icon_open = "helmut_labcoat_open"
	icon_closed = "helmut_labcoat"
	contained_sprite = 1


/obj/item/clothing/shoes/jackboots/unathi/fluff/yinzr_sandals //Marching Sandals - Sslazhir Yinzr - alberyk
	name = "marching sandals"
	desc = "A pair of sturdy marching sandals made of layers of leather and with a reinforced sole, they are also rather big."
	icon = 'icons/obj/custom_items/yinzr_sandals.dmi'
	item_state = "yinzr_sandals"
	icon_state = "yinzr_sandals"
	contained_sprite = 1


/obj/item/clothing/accessory/fluff/laikov_broach //Jeweled Broach - Aji'Rah Laikov - nebulaflare
	name = "jeweled broach"
	desc = "A jeweled broach, inlaid with semi-precious gems. The clasp appears to have been replaced."
	icon = 'icons/obj/custom_items/laikov_broach.dmi'
	item_state = "laikov_broach"
	icon_state = "laikov_broach"
	contained_sprite = 1

/obj/item/clothing/accessory/fluff/laikov_broach/attack_self(mob/user as mob)
	if(isliving(user))
		user.visible_message("<span class='notice'>[user] displays their [src.name]. It glitters in many colors.</span>")

/obj/item/clothing/accessory/fluff/laikov_broach/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] thrust the [src.name] into [M]'s face.</span>")


/obj/item/weapon/fluff/akela_photo // Akela's Family Photo - Akela Ha'kim - moltenkore
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

	F.damage += 5
	src << "<span class='warning'>You feel a stabbing pain in your chest!</span>"
	playsound(user, 'sound/effects/Heart Beat.ogg', 20, 1)


/obj/item/clothing/accessory/badge/fluff/caleb_badge //Worn Badge - Caleb Greene - notmegatron
	name = "worn badge"
	desc = "A simple gold badge denoting the wearer as Head of Security. It is worn and dulled with age, but the name, \"Caleb Greene\", is still clearly legible."
	icon_state = "badge"
	icon = 'icons/obj/custom_items/caleb_badge.dmi'
	item_state = "caleb_badge"
	icon_state = "caleb_badge"
	stored_name = "Caleb Greene"
	badge_string = "NOS Apollo Head of Security"
	contained_sprite = 1


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
	contained_sprite = 1


/obj/item/sign/fluff/alexis_degree //Xenonuerology Doctorate - Alexis Shaw - Tenenza
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
	contained_sprite = 1
	body_parts_covered = 0
	canremove = 0
	species_restricted = list("Machine")
	var/emagged = 0

/obj/item/clothing/mask/fluff/rur_collar/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/card/emag) && !emagged)
		user << "<span class='danger'>You short out \the [src]'s locking mechanism.</span>"
		src.icon_state = "rur_collar_broken"
		src.canremove = 1
		src.emagged = 1
		playsound(src.loc, 'sound/effects/sparks1.ogg', 100, 0)
		return

	return


/obj/item/clothing/mask/bluescarf/fluff/simon_scarf //Fancy Scarf - Simon Greene - icydew
	name = "fancy scarf"
	desc = "A very smooth, dark blue scarf with a golden trim. It feels really new and clean."
	icon = 'icons/obj/custom_items/simon_scarf.dmi'
	icon_state = "simon_scarf"
	item_state = "simon_scarf"
	contained_sprite = 1


/obj/item/clothing/head/soft/sec/corp/fluff/karson_cap //Karson's Cap - Eric Karson - dronzthewolf
	name = "well-worn corporate security cap"
	desc = "A well-worn corporate security cap. The name Karson is written on the underside of the brim, it is well-worn at the point where it has shaped to the owner's head."


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
	contained_sprite = 1

/obj/item/clothing/suit/storage/toggle/labcoat/fluff/zohjar_jacket //People's Republic Medical Officer Coat - Zohjar Rasateir - lordraven001
	name = "people's republic medical officer coat"
	desc = "A sterile insulated coat made of leather stitched over fur. It has two gold lapels indicating Officer rank. The a white armband with a scarlet line in the center indicates that the person wearing this coat is medically trained."
	icon = 'icons/obj/custom_items/zohjar_clothing.dmi'
	icon_state = "zohjar_jacket"
	item_state = "zohjar_jacket"
	icon_open = "zohjar_jacket_open"
	icon_closed = "zohjar_jacket"
	contained_sprite = 1


/obj/item/clothing/suit/storage/fluff/maksim_coat //Tajaran Naval Officer's Coat - Maksim Vasilyev - aimlessanalyst
	name = "tajaran naval officer coat"
	desc = "A thick wool coat from Adhomai, calling back to days long past."
	icon = 'icons/obj/custom_items/maksim_coat.dmi'
	icon_state = "maksim_coat"
	item_state = "maksim_coat"
	contained_sprite = 1


/obj/item/sign/fluff/iskanz_atimono //Framed Zatimono - Iskanz Sal'Dans - zundy
	name = "framed zatimono"
	desc = "A framed Zatimono, a Unathi standard worn into battle similar to an old-Earth Sashimono. This one seems well maintained and carries Sk'akh Warrior Priest markings and litanies."
	icon_state = "iskanz_atimono"
	sign_state = "iskanz_atimono"
	w_class = 2


/obj/item/clothing/accessory/fluff/zahra_pin //Indigo remembrance pin -  Zahra Karimi - synnono
	name = "Indigo remembrance pin"
	desc = "A small metal pin, worked into the likeness of an indigo iris blossom."
	icon = 'icons/obj/custom_items/zahra_pin.dmi'
	icon_state = "zahra_pin"
	item_state = "zahra_pin"
	contained_sprite = 1


/obj/item/clothing/accessory/armband/fluff/karl_armband //Medizinercorps armband - Karl Jonson - arrow768
	name = "medizinercorps armband"
	desc = "A plain black armband with the golden Medizinercorps logo on it."
	icon = 'icons/obj/custom_items/karl_armband.dmi'
	icon_state = "karl_armband"
	item_state = "karl_armband"
	contained_sprite = 1


/obj/item/weapon/melee/fluff/rook_whip //Ceremonial Whip - Rook Jameson - hivefleetchicken
	name = "ceremonial whip"
	desc = "A traditional cat o'nine tails whip made of jet black leather and embroidered with a few golden touches, made on Earth. It looks ceremoniously robust."
	icon = 'icons/obj/custom_items/rook_whip.dmi'
	icon_state = "rook_whip"
	item_state = "rook_whip"
	slot_flags = SLOT_BELT
	contained_sprite = 1
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
	contained_sprite = 1


/obj/item/clothing/head/fluff/sayyidah_tiara //Jeweled Tiara - Sayyidah Al-Kateb - alberyk
	name = "jeweled tiara"
	desc = "A headdress in the shape of a tiara, it is adorned by not so valuable jewels and spots a translucid veil on the back. There is room for pointy ears in the sides of the piece, as it was molded for a tajara."
	icon = 'icons/obj/custom_items/sayyidah_dress.dmi' //special thanks to TheGreatJorge for the sprites
	icon_state = "sayyidah_tiara"
	item_state = "sayyidah_tiara"
	contained_sprite = 1


/obj/item/clothing/accessory/fluff/jeyne_pendant //Jeyne's Pendant - Jeyne Kahale - themuncorn
	name = "black choker with pendant"
	desc = "A simple black choker, with a small pendant on the front. The pendant is carefully inscribed with some simple Sinta'Unathi script in white."
	icon = 'icons/obj/custom_items/jeyne_pendant.dmi'
	icon_state = "jeyne_pendant"
	item_state = "jeyne_pendant"
	slot_flags = SLOT_MASK | SLOT_TIE
	contained_sprite = 1


/obj/item/clothing/suit/storage/hooded/wintercoat/fluff/basil_coat //Consortium Magister's Robes - Basil Drabardi - aimlessanalyst
	name = "consortium magister's robes"
	desc = "Deep red robes belonging to a Consortium Magister. A curious symbol is displayed on the black tabard down it's front."
	icon = 'icons/obj/custom_items/basil_coat.dmi'
	icon_state = "basil_coat"
	item_state = "basil_coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	contained_sprite = 1
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
	contained_sprite = 1


/obj/item/clothing/suit/storage/fluff/tsali_coat //Mariziite Shroud - Cruz Tsali - serveris6
	name = "mariziite shroud"
	desc = "A worn duster coat frayed near the bottom, with a dark-hide shoulder cape thrown over the torso bearing the mark of a Mariziite warrior priest. Commonly known as the garb worn by members of the Mariziite Order in the performance of their duties."
	icon = 'icons/obj/custom_items/tsali_coat.dmi'
	icon_state = "tsali_coat"
	item_state = "tsali_coat"
	contained_sprite = 1


/obj/item/clothing/under/fluff/ana_uniform //Retired Uniform - Ana Roh'hi'tin - suethecake
	name = "retired uniform"
	desc = "A silken blouse paired with dark-colored slacks. It has the words 'Chief Investigator' embroidered into the shoulder bar."
	icon = 'icons/obj/custom_items/ana_clothing.dmi'
	icon_state = "ana_uniform"
	item_state = "ana_uniform"
	contained_sprite = 1

/obj/item/clothing/suit/storage/forensics/fluff/ana_jacket //CSI Jacket - Ana Roh'hi'tin - suethecake
	name = "CSI jacket"
	desc = "A black jacket with the words 'CSI' printed in the back in bright, white letters."
	icon = 'icons/obj/custom_items/ana_clothing.dmi'
	icon_state = "ana_jacket"
	item_state = "ana_jacket"
	contained_sprite = 1

/obj/item/clothing/accessory/badge/old/fluff/ana_badge //Faded Badge - Ana Roh'hi'tin - suethecake
	name = "faded badge"
	desc = "A faded badge, backed with leather, that reads 'NT Security Force' across the front. It bears the emblem of the Forensic division."
	stored_name = "Ana Issek"
	badge_string = "NanoTrasen Security Department"


/obj/item/clothing/head/hairflower/fluff/aquila_pin //Magnetic Flower Pin - Aquila - nandabun
	name = "magnetic flower pin"
	desc = "That's a magnet in the shape of a hair flower pin. Smells nice."


/obj/item/clothing/head/beret/eng/fluff/ikrad_beret //LR-31MTA Beret - Ikrad Yam'hir - houseofsynth
	name = "LR-31MTA Beret"
	desc = "A silver beret with an insignia on the front, it looks like an old Tajaran cannon with a ring around it. \
	Along the top half of the ring \"LR-31MTA\" is engraved. The word \"Yam'hir\" is engraved along the bottom half of the ring. \
	The beret looks old and is worn in some places around the edges. It appears to have a flap inside, \
	secured by a piece of elastic that loops around a button."
	icon = 'icons/obj/custom_items/ikrad_beret.dmi'
	icon_state = "ikrad_beret"
	item_state = "ikrad_beret"
	contained_sprite = 1
	var/letter

/obj/item/clothing/head/beret/eng/fluff/ikrad_beret/New()
	..()
	var/obj/item/fluff/ikrad_letter/hat_letter = new(src)
	letter = hat_letter
	hat_letter.attack_self()

/obj/item/clothing/head/beret/eng/fluff/ikrad_beret/attack_self(var/mob/user)
	if(letter)
		user << "<span class='notice'>You remove \the [letter] from inside the [src]'s flap.</span>"
		user.drop_from_inventory(src)
		user.put_in_hands(letter)
		user.put_in_hands(src)
		letter = null
	else
		..()

/obj/item/clothing/head/beret/eng/fluff/ikrad_beret/attackby(var/obj/item/fluff/ikrad_letter/W, var/mob/user)
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
	name = "mars' militia leather jacket"
	desc = "A leather jacket, appears to have a shield on back with the words \"Contra omnes stabimus\", as well as a unit name \"Sandworms of Thadeus\", \
	stitched along a banner at the bottom of the shield."
	icon = 'icons/obj/custom_items/ryan_jacket.dmi'
	icon_state = "ryan_jacket"
	item_state = "ryan_jacket"
	contained_sprite = 1