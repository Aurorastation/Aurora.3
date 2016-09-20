/// Aurora custom items ///
// Add custom items to this file, their sprites into their own dmi. in the icons/obj/custom_items
// Clothing items will probably require contained sprites

/obj/item/clothing/accessory/fluff/antique_pocket_watch //Antique Pocket Watch - Eric Derringer - xelnagahunter - Done
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


/obj/item/clothing/head/soft/sec/corp/fluff/mendoza_cap //Mendoza's cap - Chance Mendoza - loow - DONE
	name = "Mendoza's corporate security cap"
	desc = "A baseball hat in corporate colors.'C. Mendoza' is embroidered in fine print on the bill. On the underside of the cap, in dark ink, the phrase 'Gamble till you're Lucky!' is written in loopy cursive handwriting."


/obj/item/clothing/head/fluff/ziva_bandana //Ziva's Bandana - Ziva Ta'Kim - sierrakomodo - DONE
	name = "old bandana"
	desc = "An old orange-ish-yellow bandana. It has a few stains from engine grease, and the color has been dulled."
	icon = 'icons/obj/custom_items/motaki_bandana.dmi'
	icon_state = "motaki_bandana"
	item_state = "motaki_bandana"
	contained_sprite = 1


/obj/item/clothing/suit/armor/vest/fluff/zubari_jacket //Fancy Jacket - Zubari Akenzua - filthyfrankster - DONE
	name = "fancy jacket"
	desc = "A well tailored unathi styled armored jacket, fitted for one too."
	icon = 'icons/obj/custom_items/zubari_jacket.dmi'
	icon_state = "zubari_jacket"
	item_state = "zubari_jacket"
	contained_sprite = 1


/obj/item/clothing/suit/unathi/mantle/fluff/yinzr_mantle //Heirloom Unathi Mantle - Sslazhir Yinzr - alberyk - DONE
	name = "heirloom unathi mantle"
	desc = "A withered mantle sewn from threshbeast's hides, the pauldrons that holds it on the shoulders seems to be the remains of some kind of old armor."
	icon = 'icons/obj/custom_items/yinzr_mantle.dmi'
	icon_state = "yinzr_mantle" //special thanks to Araskael
	item_state = "yinzr_mantle"
	species_restricted = list("Unathi") //forged for lizardmen
	contained_sprite = 1


/obj/item/clothing/glasses/fluff/nebula_glasses	//chich eyewear - Roxy Wallace - nebulaflare - DONE
	name = "chic eyewear"
	desc = "A stylish pair of glasses. They look custom made."
	icon = 'icons/obj/custom_items/nebula_glasses.dmi'
	icon_state = "nebula_glasses"
	item_state = "nebula_glasses"
	contained_sprite = 1

/obj/item/clothing/glasses/fluff/nebula_glasses/var/chip
	/obj/item/clothing/glasses/fluff/nebula_glasses/New()
		chip = new /obj/item/weapon/disk/fluff/nebula_chip()
		..()

/obj/item/clothing/glasses/fluff/nebula_glasses/attack_self(mob/user as mob)
	if(chip)
		user.put_in_hands(chip)
		user << "\blue You eject a small, concealed data chip from a small slot in the frames of the [src]."
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

/obj/item/weapon/disk/fluff/nebula_chip //data chip - Roxy Wallace - nebulaflare - DONE
	name = "data chip"
	desc = "A small green chip."
	icon = 'icons/obj/custom_items/nebula_chip.dmi'
	icon_state = "nebula_chip"
	w_class = 1


/obj/item/clothing/gloves/swat/fluff/hawk_gloves //Sharpshooter gloves - Hawk Silverstone - nebulaflare - DONE
	name = "\improper sharpshooter gloves"
	desc = "These tactical gloves are tailor made for a marksman."
	icon = 'icons/obj/custom_items/hawk_gloves.dmi'
	icon_state = "hawk_gloves"
	item_state = "swat_gl"


/obj/item/clothing/accessory/fluff/karima_datadrive //Data Drive Pendant -  Kyyir'ry'avii Mo'Taki - nebulaflare - DONE
	name = "data drive"
	desc = "A small necklace, the pendant flips open to reveal a data drive."
	icon = 'icons/obj/custom_items/motaki_datadrive.dmi'
	icon_state = "motaki_datadrive"
	item_state = "holobadge-cord"
	slot_flags = SLOT_MASK


/obj/item/clothing/ears/skrell/fluff/dompesh_cloth // Skrell Purple Head Cloth - Shkor-Dyet Dom'Pesh - mofo1995 - DONE
	name = "male skrell purple head cloth"
	desc = "A purple cloth band worn by male skrell around their head tails."
	icon = 'icons/obj/custom_items/dompesh_cloth.dmi'
	icon_state = "dompesh_cloth"
	item_state = "dompesh_cloth"
	contained_sprite = 1


/obj/item/weapon/fluff/kiara_altar // Pocket Altar - Kiara Branwen - nursiekitty - DONE
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

/obj/item/clothing/head/det_hat/fluff/bell_hat //Brown Hat - Avery Bell - serveris6 - DONE
	name = "brown hat"
	desc = "A worn mid 20th century brown hat. It seems to have aged very well."
	icon = 'icons/obj/custom_items/bell_hat.dmi'
	icon_state = "bell_hat"
	item_state = "bell_hat"
	contained_sprite = 1


/obj/item/clothing/suit/storage/det_suit/fluff/bell_coat //Pinned Brown Coat - Avery Bell - serveris6 - DONE
	name = "pinned brown coat"
	desc = "A worn mid 20th century brown trenchcoat. If you look closely at the breast, you can see an ID flap stitched into the leather - 'Avery Bell, Silhouette Co.'."
	icon = 'icons/obj/custom_items/bell_coat.dmi'
	icon_state = "bell_coat"
	item_state = "bell_coat"
	contained_sprite = 1


/obj/item/clothing/under/syndicate/tacticool/fluff/jaylor_turtleneck // Borderworlds Turtleneck - Jaylor Rameau - evilbrage - DONE
	name = "borderworlds turtleneck"
	desc = "A loose-fitting turtleneck, common among borderworld pilots and criminals. One criminal in particular is missing his, apparently."


/obj/item/weapon/melee/fluff/tina_knife // Consecrated Athame - Tina Kaekel - tainavaa - DONE
	name = "consecrated athame"
	desc = "An athame used in occult rituals. The double-edged dagger is dull. The handle is black with a pink/white occult design strewn about it, and 'Tina' is inscribed into it in decorated letters."
	icon = 'icons/obj/custom_items/tina_knife.dmi'
	icon_state = "tina_knife"
	item_state = "knife"
	slot_flags = SLOT_BELT
	w_class = 1
	force = 2


/obj/item/device/kit/paint/ripley/fluff/zairjah_kit // Hephaestus Industrial Exosuit MK III Customization Kit - Zairjah - alberyk - DONE
	name = "Hephaestus Industrial Exosuit MK III customization kit"
	desc = "A ripley APLU model manufactured by Hephaestus industries, a common sight in New Gibson nowadays. It shines with chrome painting and a fancy reinforced glass cockpit."
	new_name = "Hephaestus Industrial Exosuit MK III"
	new_desc = "An ripley APLU model manufactured by Hephaestus industries, a common sight in New Gibson nowadays. It shines with chrome painting and a fancy reinforced glass cockpit."
	new_icon = "ripley_zairjah" //a lot of thanks to cakeisossim for the sprites
	allowed_types = list("ripley","firefighter")


/obj/item/weapon/cane/fluff/usiki_cane // Inscribed Silver-handled Cane - Usiki Guwan - fireandglory - DONE
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


/obj/item/clothing/gloves/black/fluff/kathleen_glove // Black Left Glove - Kathleen Bullard - valky_walky2 - DONE
	name = "black left glove"
	desc = "A pretty normal looking glove to be worn on the left hand."
	icon = 'icons/obj/custom_items/kathleen_glove.dmi'
	icon_state = "kathleen_glove"
	item_state = "kathleen_glove"
	contained_sprite = 1


/obj/structure/bed/chair/wheelchair/fluff/nomak_scooter // Mobility Scooter - Dubaku Nomak - demonofthefall - DONE
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


/obj/item/weapon/coin/fluff/yoiko_coin // Sobriety Chip - Yoiko Ali - raineko - DONE
	name = "sobriety chip"
	desc = "A red coin, made from plastic. A triangle is engraved, surrounding it is the words: 'TO THINE OWN SELF BE TRUE'."
	icon = 'icons/obj/custom_items/yoiko_coin.dmi'
	icon_state = "yoiko_coin" //thanks fireandglory for the sprites


/obj/item/clothing/suit/unathi/mantle/fluff/karnaikai_wrappings //Unathi Wrappings - Azeazekal Karnaikai - canon35 - DONE
	name = "unathi wrappings"
	desc = "Stitched together clothing with bandages covering them, looks tailored for an unathi."
	icon = 'icons/obj/custom_items/karnaikai_wrappings.dmi'
	icon_state = "karnaikai_wrappings" //special thanks to Araskael
	item_state = "karnaikai_wrappings"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETAIL
	species_restricted = list("Unathi")
	contained_sprite = 1


/obj/item/clothing/mask/gas/fluff/karnaikai_mask //Unathi head wrappings - Azeazekal Karnaikai - canon35 - DONE
	name = "unathi head wrappings"
	desc = "A bunch of stitched together bandages with a fibreglass breath mask on it, openings for the eyes. Looks tailored for an unathi."
	icon = 'icons/obj/custom_items/karnaikai_mask.dmi'
	icon_state = "karnaikai_mask" //special thanks to Araskael
	item_state = "karnaikai_mask"
	species_restricted = list("Unathi")
	contained_sprite = 1


/obj/item/weapon/contraband/poster/fluff/conservan_poster //ATLAS poster - Conservan Xullie - conservatron - DONE
	name = "ATLAS poster"

/obj/item/weapon/contraband/poster/fluff/conservan_poster/New()
	serial_number = 59

/datum/poster/bay_59
	name = "ATLAS poster"
	desc = "ATLAS: For all of Humanity."
	icon_state = "bposter59"


/obj/item/weapon/flame/lighter/zippo/fluff/locke_zippo // Fire Extinguisher Zippo - Jacob Locke - completegarbage - DONE
	name = "fire extinguisher lighter"
	desc = "Most fire extinguishers on the station are way too heavy. This one's a little lighter."
	icon = 'icons/obj/custom_items/locke_zippo.dmi'
	icon_state = "locke_zippo"


/obj/item/weapon/clipboard/fluff/zakiya_sketchpad // Sketchpad - Zakiya Ahmad - sierrakomodo - DONE
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

/obj/item/weapon/pen/fluff/zakiya_pen // Sketching pencil - Zakiya Ahmad - sierrakomodo - DONE
	name = "sketching pencil"
	desc = "A graphite sketching pencil."
	icon = 'icons/obj/custom_items/zakiya_pen.dmi'
	icon_state = "zakiya_pen"


/obj/item/weapon/melee/fluff/zah_mandible // Broken Vaurca Mandible - Ka'Akaix'Zah Void - sleepywolf - DONE
	name = "broken vaurca mandible"
	desc = "A black, four inch long piece of a Vaurca mandible. It seems dulled, and looks like it was shot off."
	icon = 'icons/obj/custom_items/zah_mandible.dmi'
	icon_state = "zah_mandible"
	slot_flags = SLOT_BELT
	w_class = 1
	force = 2


/obj/item/clothing/suit/chaplain_hoodie/fluff/nioathi_hoodie //Shaman Hoodie - Fereydoun Nioathi - jackboot - DONE
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

/obj/item/weapon/implanter/fluff/attack(mob/M as mob, mob/user as mob)
	if (!M.ckey || M.ckey != allowed_ckey)
		return

	..()


/obj/item/weapon/fluff/moon_baton //Tiger Claw - Zander Moon - omnivac - DONE
	name = "tiger claw"
	desc = "A small energy dagger given to Golden Tigers."
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
		user << "\blue \The [src] is now energised."
		icon_state = "tigerclaw_active"
		item_state = icon_state
		slot_flags = null
		attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	else
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		user << "\blue \The [src] is de-energised."
		icon_state = initial(icon_state)
		item_state = icon_state
		slot_flags = initial(slot_flags)
		attack_verb = list()
	user.regenerate_icons()


/obj/item/clothing/suit/armor/vest/fabian_coat //NT APF Armor - Fabian Goellstein - mirkoloio - DONE
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

/obj/item/clothing/head/beret/centcom/officer/fluff/fabian_beret //Worn Security Beret - Fabian Goellstein - mirkoloio - DONE
	name = "worn security beret"
	desc = "A NT Asset Protection Force Beret. It has the NT APF insignia on it as well as the Name 'Goellstein' inside."


/obj/item/clothing/accessory/armband/fluff/vittorio_armband //ATLAS Armband - Vittorio Giurifiglio - tytostyris - DONE
	name = "Atlas armband"
	desc = "This is an atlas armband showing anyone who sees this person, as a member of the Political party Atlas."
	icon = 'icons/obj/custom_items/vittorio_armband.dmi'
	icon_state = "vittorio_armband"
	item_state = "vittorio_armband"
	contained_sprite = 1

/obj/item/clothing/head/fluff/vittorio_fez //Black Fez - Vittorio Giurifiglio - tytostyris - DONE
	name = "black fez"
	desc = "It is a black fez, it bears an Emblem of the Astronomical symbol of Earth, It also has some nice tassels."
	icon = 'icons/obj/custom_items/vittorio_fez.dmi'
	icon_state = "vittorio_fez"
	item_state = "vittorio_fez"
	contained_sprite = 1


/obj/item/clothing/suit/fluff/centurion_cloak //Paludamentum - Centurion - cakeisossim - DONE
	name = "paludamentum"
	desc = "A cloak-like piece of silky, red fabric. Fashioned at one point where the shoulder would be with a golden pin."
	icon = 'icons/obj/custom_items/centurion_cloak.dmi'
	icon_state = "centurion_cloak"
	item_state = "centurion_cloak"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	contained_sprite = 1


/obj/item/clothing/ears/bandanna/fluff/kir_bandanna// Kir's Bandanna - Kir Iziki - araskael - DONE
	name = "purple bandanna"
	desc = "A worn and faded purple bandanna with a knotted, dragon-like design on it."
	icon = 'icons/obj/custom_items/kir_bandanna.dmi'
	icon_state = "kir_bandanna"
	item_state = "kir_bandanna"
	contained_sprite = 1
	

/obj/item/clothing/suit/storage/toggle/bomber/fluff/ash_jacket //Hand-me-down Bomber Jacket - superballs - Ash LaCroix - DONE
	name = "hand-me-down bomber jacket"
	desc = "A custom tailored bomber jacket that seems to have been through some action. A silver badge is pinned to it, along with a black and blue strip covering it halfway. The badge reads, 'Christopher LaCroix, Special Agent, Mendell City, E.O.W. 10-7-38, 284'"
	icon = 'icons/obj/custom_items/ash_jacket.dmi'
	icon_state = "ash_jacket"
	item_state = "ash_jacket"
	icon_open = "ash_jacket_open"
	icon_closed = "ash_jacket"
	contained_sprite = 1


/obj/item/clothing/accessory/badge/holo/cord/fluff/dylan_tags //Dog Tags - Dylan Sutton - sircatnip - DONE
	name = "dog tags"
	desc = "Some black dog tags, engraved on them is the following: Wright, Dylan L, O POS, Pacific Union Special Forces."
	icon = 'icons/obj/custom_items/dylan_tags.dmi'
	icon_state = "dylan_tags"
	item_state = "dylan_tags"
	stored_name = "Wright, Dylan L"
	badge_string = "Pacific Union Special Forces"
	contained_sprite = 1


/obj/item/clothing/ears/fluff/rico_stripes //Racing Stripes - Ricochet - nebulaflare - DONE
	name = "racing stripes"
	desc = "A pair of fancy racing stripes."
	icon = 'icons/obj/custom_items/rico_stripes.dmi'
	icon_state = "rico_stripes"
	item_state = "rico_stripes"
	contained_sprite = 1
	canremove = 0
	abstract = 1
	species_restricted = list("Machine")


/obj/item/weapon/reagent_containers/food/drinks/flask/fluff/barcia_flask //First Shot - Gabriel Barcia - mrgabol100 - DONE
	name = "first shot"
	desc = "A flask. Smells of absinthe, maybe vodka. The bottom left corner has a silver bar. The bottom is engraved, it reads 'The First Shot'."
	icon = 'icons/obj/custom_items/barcia_flask.dmi'
	icon_state = "barcia_flask"


/obj/item/clothing/gloves/fluff/stone_ring //Thunder Dome Pendant Ring - Jerimiah Stone - dominicthemafiaso - DONE
	name = "thunder dome pendant ring"
	desc = "It appears to be a Collectors edition Thunder dome Pendant ring from the IGTDL's show rumble in the red planet in 2444. It has a decorative diamond center with a image of the Intergalactic belt in the center."
	icon = 'icons/obj/custom_items/stone_ring.dmi'
	icon_state = "stone_ring"
	item_state = "stone_ring"
	contained_sprite = 1
	
	
/obj/item/clothing/under/dress/fluff/sayyidah_dress //Traditional Jumper Dress - Sayyidah Al-Kateb - alberyk - DONE
	name = "traditional jumper dress"
	desc = "A light summer-time dress, decorated neatly with black and silver colors, it seems to be rather old."
	icon = 'icons/obj/custom_items/sayyidah_dress.dmi' //special thanks to Coalf for the sprites
	icon_state = "sayyidah_dress"
	item_state = "sayyidah_dress"
	contained_sprite = 1
