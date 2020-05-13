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
			to_chat(user, "<span class='notice'>You close \the [src].</span>")
			desc = "The design of this pocket watch signals its age, however it seems to retain its pristine quality. The cover is gold, and there appears to be an elegant crest on the outside of the lid."
		if("pocket_watch_close")
			icon_state = "pocket_watch_open"
			to_chat(user, "<span class='notice'>You open \the [src].</span>")
			desc = "Inside the pocket watch, there is a collection of numbers, displaying '[worldtime2text()]'. On the inside of the lid, there is another sequence of numbers etched into the lid itself."


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
	var/obj/item/disk/chip

/obj/item/clothing/glasses/fluff/nebula_glasses/Initialize()
	. = ..()
	chip = new /obj/item/disk/fluff/nebula_chip()

/obj/item/clothing/glasses/fluff/nebula_glasses/Destroy()
	QDEL_NULL(chip)
	return ..()

/obj/item/clothing/glasses/fluff/nebula_glasses/attack_self(mob/user as mob)
	if(chip)
		user.put_in_hands(chip)
		to_chat(user, "<span class='notice'>You eject a small, concealed data chip from a small slot in the frames of \the [src].</span>")
		chip = null

/obj/item/clothing/glasses/fluff/nebula_glasses/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/disk/fluff/nebula_chip) && !chip)
		//user.u_equip(W)
		user.drop_from_inventory(W,src)
		chip = W
		W.add_fingerprint(user)
		add_fingerprint(user)
		to_chat(user, "<span class='notice'>You slot \the [W] back into its place in the frames of \the [src].</span>")

/obj/item/disk/fluff/nebula_chip //data chip - Roxy Wallace - nebulaflare
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


/obj/item/fluff/kiara_altar //Pocket Altar - Kiara Branwen - nursiekitty
	name = "pocket altar"
	desc = "A black tin box with a symbol painted over it. It shimmers in the light."
	icon = 'icons/obj/custom_items/kiara_altar.dmi'
	icon_state = "kiara_altar1"
	w_class = 2

/obj/item/fluff/kiara_altar/attack_self(mob/user as mob)
	if(src.icon_state == "kiara_altar1")
		src.icon_state = "kiara_altar2"
		to_chat(user, "<span class='notice'>You open \the [src], revealing its contents.</span>")
		desc = "A black tin box, you can see inside; a vial of herbs, a little bag of salt, some epoxy clay runes, a candle with match, a permanent marker and a tiny besom."
	else
		src.icon_state = "kiara_altar1"
		to_chat(user, "<span class='notice'>You close \the [src].</span>")
		desc = "A black tin box with a symbol painted over it. It shimmers in the light."


/obj/item/clothing/head/det/fluff/bell_hat //Brown Hat - Avery Bell - serveris6
	name = "brown hat"
	desc = "A worn mid 20th century brown hat. It seems to have aged very well."
	icon = 'icons/obj/custom_items/bell_coat.dmi'
	icon_state = "bell_hat"
	item_state = "bell_hat"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/det_trench/fluff/bell_coat //Pinned Brown Coat - Avery Bell - serveris6
	name = "pinned brown coat"
	desc = "A worn mid 20th century brown trenchcoat. If you look closely at the breast, you can see an ID flap stitched into the leather - \"Avery Bell, Silhouette Co\"."
	icon = 'icons/obj/custom_items/bell_coat.dmi'
	icon_state = "bell_coat"
	item_state = "bell_coat"
	icon_open = "bell_coat"
	icon_closed = "bell_coat"
	contained_sprite = TRUE
	allowed = list(/obj/item/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/gun/energy,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,
	/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/storage/fancy/cigarettes,/obj/item/flame/lighter,/obj/item/device/taperecorder, /obj/item/clothing/accessory/badge/fluff/bell_badge)


/obj/item/melee/fluff/tina_knife //Consecrated Athame - Tina Kaekel - tainavaa
	name = "consecrated athame"
	desc = "An athame used in occult rituals. The double-edged dagger is dull. The handle is black with a pink/white occult design strewn about it, and \"Tina\" is inscribed into it in decorated letters."
	icon = 'icons/obj/custom_items/tina_knife.dmi'
	icon_state = "tina_knife"
	item_state = "knife"
	slot_flags = SLOT_BELT
	w_class = 1

/obj/item/cane/fluff/usiki_cane //Inscribed Silver-handled Cane - Usiki Guwan - fireandglory
	name = "inscribed silver-handled cane"
	desc = "This silver-handled cane has letters carved into the sides."
	icon = 'icons/obj/custom_items/usiki_cane.dmi'
	icon_state = "usiki_cane"
	item_state = "usiki_cane"
	contained_sprite = TRUE

/obj/item/cane/fluff/usiki_cane/attack_self(mob/user as mob)
	if(all_languages[LANGUAGE_UNATHI] in user.languages)
		to_chat(user, "<span class='notice'>This cane has the words \"A new and better life\" carved into one side in basic, and on the other side in Sinta'Unathi.</span>")
	else
		to_chat(user, "<span class='notice'>This cane has the words \"A new and better life\" carved into the side, the other side has some unreadable carvings.</span>")


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

/obj/item/coin/fluff/yoiko_coin //Sobriety Chip - Yurick Ali - raineko
	name = "sobriety chip"
	desc = "A red coin, made from plastic. A triangle is engraved, surrounding it is the words: \"TO THINE OWN SELF BE TRUE\"."
	icon = 'icons/obj/custom_items/yoiko_coin.dmi'
	icon_state = "coin_yoiko_heads" //thanks fireandglory for the sprites
	cmineral = "yoiko"

/obj/item/flame/lighter/zippo/fluff/locke_zippo //Fire Extinguisher Zippo - Jacob Locke - completegarbage
	name = "fire extinguisher lighter"
	desc = "Most fire extinguishers on the station are way too heavy. This one's a little lighter."
	icon = 'icons/obj/custom_items/locke_zippo.dmi'
	icon_state = "locke_zippo"


/obj/item/clipboard/fluff/zakiya_sketchpad //Sketchpad - Zakiya Ahmad - sierrakomodo
	name = "sketchpad"
	desc = "A simple sketchpad, about the size of a regular sheet of paper."
	icon = 'icons/obj/custom_items/zakiya_sketchpad.dmi' //thanks superballs for the sprites
	icon_state = "zakiya_sketchpad"

/obj/item/clipboard/fluff/zakiya_sketchpad/New()
	..()
	new /obj/item/paper(src)
	new /obj/item/paper(src)
	new /obj/item/paper(src)
	new /obj/item/paper(src)
	new /obj/item/paper(src)
	new /obj/item/paper(src)
	new /obj/item/paper(src)
	new /obj/item/paper(src)
	new /obj/item/paper(src)
	new /obj/item/paper(src)

/obj/item/clipboard/fluff/zakiya_sketchpad/update_icon()
	if(toppaper)
		icon_state = "zakiya_sketchpad1"
	else
		icon_state = "zakiya_sketchpad"
	return

/obj/item/pen/fluff/zakiya_pen //Sketching pencil - Zakiya Ahmad - sierrakomodo
	name = "sketching pencil"
	desc = "A graphite sketching pencil."
	icon = 'icons/obj/custom_items/zakiya_pen.dmi'
	icon_state = "zakiya_pen"


/obj/item/melee/fluff/zah_mandible //Broken Vaurca Mandible - Ka'Akaix'Zah Zo'ra - sleepywolf
	name = "broken vaurca mandible"
	desc = "A black, four inch long piece of a Vaurca mandible. It seems dulled, and looks like it was shot off."
	icon = 'icons/obj/custom_items/zah_mandible.dmi'
	icon_state = "zah_mandible"
	slot_flags = SLOT_BELT
	w_class = 1
	force = 2


/obj/item/clothing/suit/chaplain_hoodie/fluff/nioathi_hoodie //Shaman Hoodie - Fereydoun Nioathi - marlonphoenix
	name = "shaman hoodie"
	desc = "A slightly faded robe. It's worn by some Unathi shamans."
	icon = 'icons/obj/custom_items/nioathi_hoodie.dmi'
	icon_state = "nioathi_hoodie"
	item_state = "nioathi_hoodie"
	contained_sprite = TRUE


/obj/item/implanter/fluff //snowflake implanters for snowflakes
	var/allowed_ckey = ""
	var/implant_type = null

/obj/item/implanter/fluff/proc/create_implant()
	if (!implant_type)
		return
	imp = new implant_type(src)
	update()

	return

/obj/item/implanter/fluff/attack(mob/M as mob, mob/user as mob, var/target_zone)
	if (!M.ckey || M.ckey != allowed_ckey)
		return

	..()


/obj/item/fluff/moon_baton //Tiger Claw - Zander Moon - omnivac
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

/obj/item/fluff/moon_baton/attack_self(mob/user)
	active= !active
	if(active)
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")
		icon_state = "tigerclaw_active"
		item_state = icon_state
		slot_flags = null
		attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	else
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] is now de-energised.</span>")
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
			to_chat(usr, "<span class='notice'>You zip up \the [src].</span>")
		if("fabian_coat_closed")
			icon_state = "fabian_coat_open"
			item_state = icon_state
			to_chat(usr, "<span class='notice'>You unzip \the [src].</span>")
		else
			to_chat(usr, "<span class='notice'>You attempt to button-up the velcro on \the [src], before promptly realising how silly you are.</span>")
			return

	usr.update_inv_wear_suit()


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


/obj/item/clothing/accessory/badge/fluff/dylan_tags //Dog Tags - Dylan Wright - sircatnip
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


/obj/item/reagent_containers/food/drinks/flask/fluff/barcia_flask //First Shot - Gabriel Barcia - mrgabol100
	name = "first shot"
	desc = "A flask. Smells of absinthe, maybe vodka. The bottom left corner has a silver bar. The bottom is engraved, it reads: \"The First Shot\"."
	icon = 'icons/obj/custom_items/barcia_flask.dmi'
	icon_state = "barcia_flask"


/obj/item/clothing/ring/fluff/stone_ring //Thunder Dome Pendant Ring - Jerimiah Stone - dominicthemafiaso
	name = "thunder dome pendant ring"
	desc = "It appears to be a Collectors edition Thunder dome Pendant ring from the IGTDL's show rumble in the red planet in 2444. It has a decorative diamond center with a image of the Intergalactic belt in the center."
	icon = 'icons/obj/custom_items/stone_ring.dmi'
	icon_state = "stone_ring"
	item_state = "stone_ring"
	contained_sprite = TRUE


/obj/item/clothing/under/dress/fluff/sayyidah_dress //Traditional Jumper Dress - Sayyidah Al-Kateb - alberyk
	name = "traditional jumper dress"
	desc = "A light summer-time dress, decorated neatly with black and silver colors, it seems to be rather old."
	icon = 'icons/obj/custom_items/sayyidah_dress.dmi' //special thanks to Coalf for the sprites
	icon_state = "sayyidah_dress"
	item_state = "sayyidah_dress"
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


/obj/item/clothing/shoes/jackboots/toeless/fluff/yinzr_sandals //Marching Sandals - Sslazhir Yinzr - alberyk
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


/obj/item/fluff/akela_photo //Akela's Family Photo - Akela Ha'kim - moltenkore
	name = "family photo"
	desc = "You see on the photo a tajaran couple holding a small kit in their arms, while looking very happy. On the back it is written; \"Nasir, Akela and Ishka\", with a little gold mark that reads: \"Two months\"."
	icon = 'icons/obj/custom_items/akela_photo.dmi'
	icon_state = "akela_photo"
	w_class = 2


/obj/item/implant/fluff/ziva_implant //Heart Condition - Ziva Ta'Kim - sierrakomodo
	name = "heart monitor"
	desc = "A small machine to watch upon broken hearts."

/obj/item/implant/fluff/ziva_implant/implanted(mob/living/carbon/human/M as mob)
	if (M.ckey == "sierrakomodo") //just to be sure
		M.verbs += /mob/living/carbon/human/proc/heart_attack
	else
		return

/mob/living/carbon/human/proc/heart_attack()
	set category = "IC"
	set name = "Suffer Heart Condition"
	set desc = "HNNNNG."

	if(last_special > world.time)
		to_chat(src, "<span class='warning'>Your chest still hurts badly!</span>")
		return

	last_special = world.time + 500

	var/obj/item/organ/F = src.internal_organs_by_name[BP_HEART]

	if(isnull(F))
		return

	F.take_damage(5)
	to_chat(src, "<span class='warning'>You feel a stabbing pain in your chest!</span>")
	sound_to(src, 'sound/effects/Heart Beat.ogg')


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
		to_chat(user, "<span class='danger'>You short out \the [src]'s locking mechanism.</span>")
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
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = 2
	gas_transfer_coefficient = 0.90


/obj/item/sign/fluff/triaka_atimono //Framed Zatimono - Azkuyua Triaka - marlonphoenix
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


/obj/item/coin/fluff/raymond_coin //Engraved Coin - Raymond Hawkins - aboshehab
	name = "engraved coin"
	desc = "A coin of light and bright with one side having an engraving of a greek Lamba sign, and on the back the initials of R.H. are engraved."
	icon = 'icons/obj/custom_items/raymond_items.dmi'
	icon_state = "coin_raymond_heads"
	cmineral = "raymond"

/obj/item/clothing/under/fluff/zohjar_uniform //Republic Noble Clothing - Zohjar Rasateir - lordraven001
	name = "republic noble clothing"
	desc = "A sophisticated white undersuit, it looks worn and ancient. The fabrics is excellently sewn and soft. It resembles a traditional tajaran nobleman suit."
	icon = 'icons/obj/custom_items/zohjar_clothing.dmi'
	icon_state = "zohjar_uniform"
	item_state = "zohjar_uniform"
	contained_sprite = TRUE


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


/obj/item/melee/fluff/rook_whip //Ceremonial Whip - Rook Jameson - hivefleetchicken
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
		to_chat(user, "<span class='notice'>You remove \the [letter] from inside the [src]'s flap.</span>")
		user.put_in_hands(letter)
		letter = null
	else
		..()

/obj/item/clothing/head/beret/engineering/fluff/ikrad_beret/attackby(var/obj/item/fluff/ikrad_letter/W, var/mob/user)
	if(!src.letter && istype(W))
		to_chat(user, "<span class='notice'>You place \the [W] back inside the [src]'s flap.</span>")
		user.drop_from_inventory(W,src)
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

/obj/item/clothing/suit/storage/toggle/fluff/ryan_jacket //Mars' Militia Leather Jacket - Ryan McLean - seniorscore
	name = "mars militia leather jacket"
	desc = "A leather jacket, appears to have a shield on back with the words \"Contra omnes stabimus\", as well as a unit name \"Sandworms of Thadeus\", \
	stitched along a banner at the bottom of the shield."
	icon = 'icons/obj/custom_items/ryan_jacket.dmi'
	icon_state = "ryan_jacket"
	item_state = "ryan_jacket"
	icon_open = "ryan_jacket_open"
	icon_closed = "ryan_jacket"
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

	to_chat(usr, "\icon[] []: The detective's credentials show:")
	to_chat(usr, "The investigator registered to the credentials is [investigator].")
	to_chat(usr, "The assignment registered on the card is [occupation].")
	to_chat(usr, "The birth date on the card displays [birth_year].")
	to_chat(usr, "The citizenship registered on the card is [citizenship].")
	to_chat(usr, "The systems that the credentials show the user is licensed to investigate in are [licensed_systems].")
	to_chat(usr, "Additional endorsements registered on the card show: [supplementary_endorsements].")
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


/obj/item/fluff/zhilin_book //Siik'maas-Tau Ceti Basic Dictionary - Zhilin Vadim - fireandglory
	name = "siik'maas-tau ceti basic dictionary"
	desc = "A hefty dictionary with a simple design on the cover, it seems to be for translations. There's a label on the back denoting that it belongs to a \"Zhilin Vadim\"."
	icon = 'icons/obj/custom_items/zhilin_book.dmi'
	icon_state = "zhilin_book"
	w_class = 3

/obj/item/fluff/zhilin_book/attack_self(mob/user as mob)
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

/obj/item/clothing/suit/storage/toggle/det_trench/fluff/leo_coat //Tagged brown coat - Leo Wyatt - keinto
	name = "tagged brown coat"
	desc = "A worn mid 20th century brown trenchcoat. If you look closely at bottom of the back, you can see an embedded tag from the \"Museum of Terran Culture and Technology\"."
	icon = 'icons/obj/custom_items/leo_coat.dmi'
	icon_state = "leo_coat"
	item_state = "leo_coat"
	icon_open = "leo_coat"
	icon_closed = "leo_coat"
	contained_sprite = TRUE


/obj/item/nullrod/fluff/azaroz_staff //Null Staff - Kesaos Azaroz - paradoxspace
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


/obj/item/clothing/accessory/poncho/fluff/flaming_poncho //Stitched Heart White Poncho - Flaming Hearts Love Stars - sleepywolf
	name = "stitched heart white poncho"
	desc = "A white poncho stitched together shoddily, with a pink heart made of flame patterned on the front. The fabric is rough, like chainmail."
	icon = 'icons/obj/custom_items/flaming_poncho.dmi'
	icon_state = "flaming_poncho"
	item_state = "flaming_poncho"
	contained_sprite = TRUE
	icon_override = FALSE


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


/obj/item/clothing/suit/storage/fluff/vizili_mantle //Maraziite Throw Over - Urzkrauzi Vizili - marlonphoenix
	name = "maraziite throw over"
	desc = "A worn, grey poncho exclusively worn by members of the Maraziite Order."
	icon = 'icons/obj/custom_items/vizili_clothing.dmi'
	icon_state = "vizili_mantle"
	item_state = "vizili_mantle"
	contained_sprite = TRUE

/obj/item/clothing/mask/fluff/vizili_mask //Iron Mask - Urzkrauzi Vizili - marlonphoenix
	name = "iron mask"
	desc = "A mask made of iron worn by members of the Maraziite Order. It can strike dread in the hearts of Unathi that don't toe the line of Sk'akh orthodoxy."
	icon = 'icons/obj/custom_items/vizili_clothing.dmi'
	icon_state = "vizili_mask"
	item_state = "vizili_mask"
	contained_sprite = TRUE
	flags_inv = HIDEEARS|HIDEFACE
	body_parts_covered = FACE
	w_class = 3.0


/obj/item/reagent_containers/food/drinks/teapot/fluff/brianne_teapot	//Ceramic Teapot - Sean Brianne - zelmana
	name = "ceramic teapot"
	desc = "A blue ceramic teapot, gilded with the abbreviation for NanoTrasen."
	icon = 'icons/obj/custom_items/brianne_teapot.dmi'
	icon_state = "brianne_teapot"


/obj/item/reagent_containers/food/drinks/flask/fluff/nasser_flask //Workers Flask - Nasser Antonov - sonicgotnuked
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
		to_chat(user, "<span class='notice'>You turn \the [src] on.</span>")
	else
		to_chat(user, "<span class='notice'>You turn \the [src] off.</span>")

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
		to_chat(user, "It is [active ? "on" : "off"].")


/obj/item/reagent_containers/food/drinks/bottle/cognac/fluff/leonce_cognac //Old Earth Luxury Cognac - Francois Leonce - driecg36
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


/obj/item/book/fluff/huntington_book //Spark Theorem - Monica Huntington - moondancerpony
	name = "\improper Spark Theorem"
	desc = "A bound copy of the 2458 research paper \"Spark Theorem: Research Into the Development of Synthetic Consciousness and Sapience\". This one is signed by the author."
	title = "Spark Theorem"
	icon_state = "book6"
	author = "Kyyir'ry'avii 'Karima' Ile'nagrii Al'Ghul-Mo'Taki"
	dat = "<!doctype html><html style=\"width:100%;height:100%;\"><head><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"></head><body><iframe style=\"width:100%;height:100%\" src=\"https://assets.lohikar.io/mdp/sparktheorem.html\"></iframe></body></html>"
	due_date = 0
	unique = 1


/obj/item/clothing/suit/storage/fluff/vira_coat //Designer Military Coat - Vira Bolivar - scheveningen
	name = "designer military coat"
	desc = "A dark funnel neck designer military-style dress coat, specially fitted on commission, clearly designed for a woman's figure. \
	A skillfully stitched 'NT' pattern is laden above a chest pocket, the phrase \"15 years of loyal service to the Corp\" below the insignia, followed by the personal signature of \"Vira Bolivar Taryk\"."
	icon = 'icons/obj/custom_items/vira_coat.dmi'
	icon_state = "vira_coat"
	item_state = "vira_coat"
	contained_sprite = TRUE


/obj/item/storage/backpack/satchel/fluff/kresimir_bag //Worn Leather Bag - Kresimir Kostadinov - alberyk
	name = "worn leather bag"
	desc = "A sturdy and worn leather bag. The clasp has a faded blue and golden insigna."
	icon = 'icons/obj/custom_items/kresimir_bag.dmi'
	icon_state = "kresimir_bag"
	item_state = "kresimir_bag"
	contained_sprite = TRUE


/obj/item/stamp/fluff/leland_stamp //Sol Alliance Government Foreign Relations Department Stamp - Leland Field - saudus
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
		to_chat(usr, "You open \the [src].")
	else
		src.icon_state = "leland_badge"
		to_chat(usr, "You close \the [src].")


/obj/item/clothing/suit/storage/fluff/azala_coat //Azala's Gentleman's Coat - Azala Huz'kai - tomiixstarslasher
	name = "gentleman's coat"
	desc = "A blue gentleman's coat. It is very stylish, and appears to be very warm."
	icon = 'icons/obj/custom_items/azala_items.dmi'
	icon_state = "azala_coat"
	item_state = "azala_coat"
	contained_sprite = TRUE

/obj/item/clothing/head/fluff/azala_hat //Azala's Gentleman's Cap - Azala Huz'kai - tomiixstarslasher
	name = "gentleman's cap"
	desc = "A blue gentleman's cap. It is very stylish, and appears to be warped from being worn crooked."
	icon = 'icons/obj/custom_items/azala_items.dmi'
	icon_state = "azala_hat"
	item_state = "azala_hat"
	contained_sprite = TRUE

/obj/item/clothing/under/fluff/azala_jumpsuit //Azala's Roboticist Jumpsuit - Azala Huz'kai - tomiixstarslasher
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


/obj/item/clothing/under/rank/medical/fluff/jurlkiitajr_scrubs //IAC Scrubs - Rajii'rkalahk Jurlkiitajr - marlonphoenix
	name = "\improper IAA scrubs"
	desc = "A change of sterile medical scrubs worn by IAC workers. This one is specific for Tajara Aid workers."
	icon = 'icons/obj/custom_items/jurlkiitajr_items.dmi'
	icon_state = "jurlkiitajr_scrubs"
	item_state = "jurlkiitajr_scrubs"
	contained_sprite = TRUE

/obj/item/clothing/suit/apron/surgery/fluff/jurlkiitajr_vest //IAC Vest - Rajii'rkalahk Jurlkiitajr - marlonphoenix
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

/obj/item/pen/fluff/zilosnish_pen //Golden Pen - Zilosnish Szu - sleepywolf
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

	if (use_check_and_message(usr)) return

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
	usr.visible_message("<span class='notice'>[usr] fumbles with \the [src], changing the shirt..</span>",
						"<span class='notice'>You change \the [src]'s style to be '[style]'.</span>")


/obj/item/clothing/gloves/watch/fluff/rex_watch //Engraved Wristwatch - Rex Winters - tailson
	name = "engraved wristwatch"
	desc = "A fine gold watch. On the inside is an engraving that reads \"Happy birthday dad, thinking of you always\"."
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


/obj/item/clothing/mask/gas/fluff/karihaakaki_mask //Wooden Mask - Keziah Green/Karihaakaki - dronzthewolf
	name = "wooden mask"
	desc = "A wooden mask for non-human proportions, it has craftsmanship of uncanny precision."
	icon = 'icons/obj/custom_items/karihaakaki_mask.dmi'
	icon_state = "karihaakaki_mask"
	item_state = "karihaakaki_mask"
	species_restricted = list("Vox")
	contained_sprite = TRUE


/obj/item/storage/wallet/fluff/muhawir_wallet //Pineapple Wallet - Muhawir Nawfal - menown
	name = "pineapple wallet"
	desc = "A rather small, cheaply made felt wallet with a zipper near the top. It looks like a pineapple."
	icon = 'icons/obj/custom_items/muhawir_items.dmi'
	icon_state = "muhawir_wallet"

/obj/item/storage/wallet/fluff/muhawir_wallet/update_icon()
	return


/obj/item/folder/fluff/sukhoi_folder //Inventor's Notebook - Natascha Sukhoi - lancelynxx
	name = "inventor's notebook"
	desc = "A dark-green notebook, with crumpled Post-Its sticking out and binding tearing at the edges. It reeks of DromedaryCo cigarettes. The words \"SUKH SYSTEMS\" are scribbled on the cover with a black sharpie."
	icon = 'icons/obj/custom_items/sukhoi_folder.dmi'
	icon_state = "sukhoi_folder"


/obj/item/clothing/suit/fluff/diamond_cloak //Ragged Purple Cloak - Diamond With Flaw - burgerbb
	name = "ragged purple cloak"
	desc = "An old, worn down cloak that smells of dirt and stories."
	icon = 'icons/obj/custom_items/diamond_cloak.dmi'
	icon_state = "diamond_cloak"
	item_state = "diamond_cloak"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	contained_sprite = TRUE


/obj/item/fluff/jennifer_wardrobe_kit //Portable Wardrobe Kit - Jennifer Beal - synnono
	name = "portable wardrobe kit"
	desc = "A kit containing a change of casual clothes, packaged for easy transport. This one advertises some sort of cartoon featuring slimes. It is labeled \"J. Beal.\""
	icon = 'icons/obj/custom_items/jennifer_clothes.dmi'
	icon_state = "jennifer_wardrobe_box"
	item_state = "box"

/obj/item/fluff/jennifer_wardrobe_kit/attack_self(mob/user as mob)
	if (use_check_and_message(user, USE_DISALLOW_SILICONS))
		return

	var/list/outfits = list(
		"Pale turtleneck outfit" = list(
			/obj/item/clothing/under/fluff/jennifer_turtleneck,
			/obj/item/clothing/shoes/fluff/jennifer_aboots
		),
		"Black net mesh outfit" = list(
			/obj/item/clothing/under/fluff/jennifer_nets,
			/obj/item/clothing/shoes/fluff/jennifer_pboots
		),
		"Cartoon T-shirt outfit" = list(
			/obj/item/clothing/under/fluff/jennifer_tee,
			/obj/item/clothing/shoes/fluff/jennifer_shoes
		)
	)

	var/selection = input("What do you find inside?", "Inside the kit...") as null|anything in outfits
	if (!selection)
		return
	for (var/item in outfits[selection])
		new item(get_turf(src))
	to_chat(user, "<span class='notice'>You unpack the outfit from the kit.</span>")

	qdel(src)

/obj/item/clothing/under/fluff/jennifer_nets //Black Net Mesh Outfit - Jennifer Beal - synnono
	name = "black net mesh outfit"
	desc = "A clingy black top and matching skirt, belted with heavy leather around the waist. A soft fabric netting stretches over the exposed collar, midriff, arms and legs."
	icon = 'icons/obj/custom_items/jennifer_clothes.dmi'
	icon_state = "jennifer_nets"
	item_state = "jennifer_nets"
	has_sensor = 0
	contained_sprite = TRUE

/obj/item/clothing/under/fluff/jennifer_turtleneck //Pale Turtleneck Outfit - Jennifer Beal - synnono
	name = "pale turtleneck outfit"
	desc = "A graphite-blue turtleneck sweater, paired with dark blue jeans."
	icon = 'icons/obj/custom_items/jennifer_clothes.dmi'
	icon_state = "jennifer_turtleneck"
	item_state = "jennifer_turtleneck"
	has_sensor = 0
	contained_sprite = TRUE

/obj/item/clothing/under/fluff/jennifer_tee //Cartoon T-shirt Outfit - Jennifer Beal - synnono
	name = "cartoon T-shirt outfit"
	desc = "A promotional white T-shirt and cargo shorts. The shirt is printed with Slime Purple, the protagonist of the cartoon 'Great Slime Hero: Zettai Justice.'\nFor great slime justice!"
	icon = 'icons/obj/custom_items/jennifer_clothes.dmi'
	icon_state = "jennifer_tee"
	item_state = "jennifer_tee"
	has_sensor = 0
	contained_sprite = TRUE

/obj/item/clothing/shoes/fluff/jennifer_pboots //Black Punk Boots - Jennifer Beal - synnono
	name = "black punk boots"
	desc = "A tall pair of thick-heeled black leather boots. They are fastened with several burnished steel buckles."
	icon = 'icons/obj/custom_items/jennifer_clothes.dmi'
	icon_state = "jennifer_pboots"
	item_state = "jennifer_pboots"
	contained_sprite = TRUE

/obj/item/clothing/shoes/fluff/jennifer_aboots //Brown Ankle Boots - Jennifer Beal - synnono
	name = "brown ankle boots"
	desc = "A comfortable pair of short ankle boots."
	icon = 'icons/obj/custom_items/jennifer_clothes.dmi'
	icon_state = "jennifer_aboots"
	item_state = "jennifer_aboots"
	contained_sprite = TRUE

/obj/item/clothing/shoes/fluff/jennifer_shoes //White Walking Sneakers - Jennifer Beal - synnono
	name = "white walking sneakers"
	desc = "A bright pair of white sneakers. They have purple rubber soles."
	icon = 'icons/obj/custom_items/jennifer_clothes.dmi'
	icon_state = "jennifer_shoes"
	item_state = "jennifer_shoes"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/toggle/det_trench/fluff/nelson_jacket //Armored Detective Jacket - Nelson Okafor - seniorscore
	name = "armored detective jacket"
	desc = "A white suit jacket, has a badge hanging out of a breast pocket. Touching it gives a feeling of working on a case for months."
	icon = 'icons/obj/custom_items/nelson_jacket.dmi'
	icon_state = "nelson_jacket"
	item_state = "nelson_jacket"
	icon_open = "nelson_jacket_open"
	icon_closed = "nelson_jacket"
	contained_sprite = TRUE


/obj/item/clothing/under/dress/fluff/katya_dress //Tailored Tajara Dress - Katya Al-Tahara - coalf
	name = "tailored tajaran dress"
	desc = "A simple long, blue and flowing dress, it has a knitted overthrow that fits over the shoulder and arms."
	icon = 'icons/obj/custom_items/katya_clothing.dmi'
	icon_state = "katya_dress"
	item_state = "katya_dress"
	contained_sprite = TRUE

/obj/item/clothing/under/fluff/katya_uniform //Messy Work Clothes - Katya Al-Tahara - coalf
	name = "messy work clothes"
	desc = "A simple pants and shirt combo. The white shirt has long since faded...and are those crumbs?"
	icon = 'icons/obj/custom_items/katya_clothing.dmi'
	icon_state = "katya_uniform"
	item_state = "katya_uniform"
	contained_sprite = TRUE


/obj/item/clothing/accessory/badge/fluff/jamie_tags //Elyran Navy Holotags - Jamie Knight - superballs
	name = "elyran navy holotags"
	desc = "A pair of standard issue holotags issued to all Elyran servicemen. The tags read, \"KNIGHT JAMES 627810021-EN O-NEG CATHOLIC\". \
	Contains both analog and digital information on the serviceman. The digital information seems to be deactivated and non-functional."
	icon = 'icons/obj/custom_items/jamie_tags.dmi'
	icon_state = "jamie_tags"
	item_state = "jamie_tags"
	stored_name = "Knight, James"
	badge_string = "Elyran Navy"
	contained_sprite = TRUE
	slot_flags = SLOT_MASK | SLOT_TIE
	var/separated = FALSE

/obj/item/fluff/jamie_tag //Single Elyran Navy Holotag - Jamie Knight - superballs
	name = "elyran navy holotag"
	desc = "A single tag of a set of holotags issued to all Elyran servicemen. The tags read, \"KNIGHT JAMES 627810021-EN O-NEG CATHOLIC\". \
	Contains both analog and digital information on the serviceman. The digital information seems to be deactivated and non-functional. It is missing it's other pair."
	icon = 'icons/obj/custom_items/jamie_tags.dmi'
	icon_state = "jamie_tag"
	w_class = 1

/obj/item/clothing/accessory/badge/fluff/jamie_tags/update_icon()
	if(separated)
		icon_state = "[icon_state]_single"
		item_state = "[item_state]_single"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)

/obj/item/clothing/accessory/badge/fluff/jamie_tags/verb/separate()
	set name = "Retrieve the Fallen"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr)) return

	if(src.separated)
		return

	usr.visible_message("<span class='notice'>[usr] yanks apart \the [src]!</span>")
	var/obj/item/fluff/jamie_tag/tag = new(get_turf(usr))
	usr.put_in_hands(tag)
	src.separated = TRUE
	src.update_icon()

/obj/item/clothing/accessory/badge/fluff/jamie_tags/attackby(var/obj/item/fluff/jamie_tag/W, var/mob/user)
	if(src.separated && istype(W))
		qdel(W)
		src.separated = FALSE
		src.update_icon()
	else
		..()


/obj/item/clothing/under/fluff/halstere_uniform //Martian Militia Dress Uniform - Kalren Halstere - brutishcrab51
	name = "martian militia dress uniform"
	desc = "A brick-red uniform with golden shoulder-scrubbers, a crisp tie, and golden buttons, complete with steel-grey slacks. An image of Olympus Mons is stamped on the left bicep."
	icon = 'icons/obj/custom_items/halstere_clothing.dmi'
	icon_state = "halstere_uniform"
	item_state = "halstere_uniform"
	contained_sprite = TRUE

/obj/item/clothing/head/fluff/halstere_cap //Martian Militia Dress Cap - Kalren Halstere - brutishcrab51
	name = "martian militia dress cap"
	desc = "A red and black peak cap with a golden Officer Corps indicator on the brow."
	icon = 'icons/obj/custom_items/halstere_clothing.dmi'
	icon_state = "halstere_cap"
	item_state = "halstere_cap"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/fluff/halstere_coat //Martian Militia Officer Coat - Kalren Halstere - brutishcrab51
	name = "martian militia officer coat"
	desc = "A decorated military coat with an aiguillette, arm-bars, and golden buttons. Made of a thick material."
	icon = 'icons/obj/custom_items/halstere_clothing.dmi'
	icon_state = "halstere_jacket"
	item_state = "halstere_jacket"
	icon_open = "halstere_jacket_open"
	icon_closed = "halstere_jacket"
	contained_sprite = TRUE


/obj/item/clothing/head/beret/fluff/chunley_beret //Sol's Dog Handler Beret - Freya Chunley - thesmiley
	name = "sol's dog handler beret"
	desc = "A scarlet military beret worn by the Sol Alliance Military Police dog handling unit. The symbol on the cap is that of a grey wolf's head on white. It quivers menacingly. \
	Upon flipping it you see a name tag with the word \"CHUNLEY\" written in on it with a very sloppy hand write."
	icon = 'icons/obj/custom_items/chunley_beret.dmi'
	icon_state = "chunley_beret"
	item_state = "chunley_beret"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/fluff/keorat_mantle //Worn Maraziite Shroud - Iksaeors Keorat - dasfox
	name = "worn maraziite shroud"
	desc = "A brown, armored looking trenchcoat. There appears to be a fur cloak over the top of it, draping down to the sleeve. The cloak shows the obvious insignia of the Maraziite Order upon it. It looks worn."
	icon = 'icons/obj/custom_items/keorat_clothing.dmi'
	icon_state = "keorat_mantle"
	item_state = "keorat_mantle"
	contained_sprite = TRUE

/obj/item/clothing/mask/fluff/keorat_mask //Charred Iron Mask - Iksaeors Keorat - dasfox
	name = "charred iron mask"
	desc = "This is an iron mask used by those of the Maraziite Order. It appears to be entirely charred, perhaps there's a story behind that."
	icon = 'icons/obj/custom_items/keorat_clothing.dmi'
	icon_state = "keorat_mask"
	item_state = "keorat_mask"
	contained_sprite = TRUE
	flags_inv = HIDEEARS|HIDEFACE
	body_parts_covered = FACE
	w_class = 3


/obj/item/crowbar/fluff/grajahn_crowbar //Crowbar of Divine Strength - Es'tana Grajahn - ezuo
	name = "crowbar of divine strength"
	desc = "An ordinary crowbar that has been painted red, and had some lights rigged to it. It pulsates a yellow light."
	icon = 'icons/obj/custom_items/grajahn_crowbar.dmi'
	icon_state = "grajahn_crowbar"
	item_state = "grajahn_crowbar"
	contained_sprite = TRUE


/obj/item/storage/wallet/fluff/raymond_wallet //Black Leather Wallet - Raymond Hawkins - aboshehab
	name = "black leather wallet"
	desc = "A sleek black leather wallet, with the initials of \"J.H.\" visible at the front side. It's got an old yet maintained look to it."
	icon = 'icons/obj/custom_items/raymond_items.dmi'
	icon_state = "raymond_wallet"

/obj/item/storage/wallet/fluff/raymond_wallet/update_icon()
	return

/obj/item/fluff/raymond_tablet //Holo Tablet - Raymond Hawkins - aboshehab
	name = "holo tablet"
	desc = "A thin electronic device that projects holographic images stored on it."
	icon = 'icons/obj/custom_items/raymond_items.dmi'
	icon_state = "raymond_tablet"
	w_class = 2
	var/picture = null

/obj/item/fluff/raymond_tablet/attack_self(mob/user as mob)
	if (use_check_and_message(user, USE_DISALLOW_SILICONS))
		return

	var/list/pictures = list("22-01-2460", "07-11-2459", "03-08-2459", "08-03-2452", "18-06-2437", "01-01-2434")

	var/selection = input("Which picture do you want to see?", "Holo tablet picture selection.") as null|anything in pictures

	if (!selection)
		return

	picture = selection

/obj/item/fluff/raymond_tablet/examine(mob/user)
	..()
	if(!picture)
		to_chat(user, "\The [src]'s screen is empty.")
		return
	if(in_range(user, src) || isobserver(user))
		show_picture(user)
	else
		to_chat(user, "<span class='notice'>You have to go closer if you want to read it.</span>")

/obj/item/fluff/raymond_tablet/proc/show_picture(mob/user)
	var/desc

	switch(picture)
		if("22-01-2460")
			desc = "This image shows a group of four outside with a scene looks to be a camp out in a forest. You see Raymond Hawkins sitting around a campfire with the three others, which you may know as Annabelle Hawkins, \
			Lily Hawkins and Robert Hawkins, his children."

		if("07-11-2459")
			desc = "This image shows two people, Raymond Hawkins and Robert Hawkins, with the latter being a boy in his early teens. The setting is that of a gun range, with Robert operating a sidearm. \
			Raymond is standing nearby guiding and instructing him on his posture."

		if("03-08-2459")
			desc = "This image shows two people, Raymond Hawkins and Lily Hawkins, with the latter being a girl in her early twenties. The setting is that of an arena, Raymond dressed casually and Lily in a Jiu Jitsu uniform, \
			the belt being an alternation between black and red. She's got a winners medal around her neck, making a peace sign with her right hand while having a grin on her face, posing for a picture with Raymond."

		if("08-03-2452")
			desc = "This image shows two people, Raymond Hawkins and Annabelle Hawkins, the former visibly a decade younger yet thinner, and not in the healthy way. The later looks to be in their late teens. The setting is that of a restaurant, \
			a more high end one, with the two of them seated opposite of each other, posing for a picture. Annabelle especially looks incredibly happy."

		if("18-06-2437")
			desc = "This image shows a group of five posing together for a picture, the surrounding indicates this as a place of military decorum, people dressed in Sol Navy dress uniforms and people in civilian clothing spread around in groups, indicating some form of graduation ceremony. \
			Raymond is in his mid twenties, dressed in full dress uniform standing with four others. One you might know as Stephanie Hawkins, dressed in the same way, looking to be in her mid twenties as well. A boy in his early teens is also standing, \
			which you may know as Robert Hawkins, his brother. The last two are Jack Hawkins and Martha Hawkins, both looking to be in their early fifties, his parents."

		if("01-01-2434")
			desc = "This image shows a large gathering, the scenery and attire indicative of a wedding. Two people stick out, Raymond Hawkins, looking to be in his early twenties dressed in a suit dancing with his bride, \
			which you may know as Stephanie Hawkins. They look content and happy, the atmosphere ecstatic."

	show_browser(user, "<center><b>You can see on the screen of the tablet:</b><br>[desc]</center>", "window=Holo Tablet")


/obj/item/material/knife/fluff/yumi_knife //Cutting Metal - Yumi Yotin - trickingtrapster
	name = "cutting metal"
	desc = "Looks like a piece of sheet metal, sharpened on one end."
	icon = 'icons/obj/custom_items/yotin_knife.dmi'
	icon_state = "yotin_knife"


/obj/item/clothing/suit/storage/toggle/fr_jacket/fluff/volvalaad_jacket //Paramedic's Jacket - Richard Volvalaad - t1gws
	name = "paramedic's jacket"
	desc = "A jacket worn by trained emergency medical personnel, this one has a gold trim and emblem."
	icon = 'icons/obj/custom_items/volvalaad_items.dmi'
	icon_state = "volvalaad_jacket"
	item_state = "volvalaad_jacket"
	icon_open = "volvalaad_jacket_open"
	icon_closed = "volvalaad_jacket"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/fluff/volvalaad_coat //Dominian Noble Coat - Richard Volvalaad - t1gws
	name = "dominian noble coat"
	desc = "This is a coat often worn by the Dominian Nobility, this one is black and blue."
	icon = 'icons/obj/custom_items/volvalaad_items.dmi'
	icon_state = "volvalaad_coat"
	item_state = "volvalaad_coat"
	icon_open = "volvalaad_coat_open"
	icon_closed = "volvalaad_coat"
	contained_sprite = TRUE


/obj/item/paper/fluff/jawdat_paper //Manifesto of the PRA - Rrazujun Rrhazkal-Jawdat - marlonphoenix
	name = "manifesto of the PRA"
	desc = "This is the manifesto of the People's Republic of Adhomai, written by many different Tajara thinkers in the 2430's. Depending on who you ask it is either an enlightening document that showcases the great \
	intellectual and cultural genius of Tajara civilization, or a dense collection of gibberish commie nonsense."
	icon = 'icons/obj/custom_items/jawdat_paper.dmi'
	icon_state = "jawdat_paper"
	info = "<b><center>Manifesto of the Parizahra Zhahrazjujz'tajara Akzatauzjauna'azahrazakahuz Hadii</b><br>\
			<br>\
			Written: Late 2432;<br> \
			First Published: February 2433<br> \
			Translated by Comrade Aurauz'hurl Aizhunua</center><br>\
			<small>A Rrak'narr is haunting the Njarir'Akhran. The Rrak'narr of classlessism. Where have not the Njarir'Akhran blasted classlessism? Where not have the nobility ruthlessly uprooted our supporters \
			like they were tearing up weeds from their gardens? Despite their dismissal, the fact that the Njarir'Akhran are so desperate to exterminate us brings us two inevitable facts:<br>\
			<br>\
			1) Revolutionary ideology is already cemented amongst Tajara.<br>\
			2) It is time for supporters of a classless society to throw off their cloaks and set aside their daggers and pick up the rifle to meet the reactionary bourgeois in the open field.<br>\
			<br>\
			To that end, Comrade Al'mari Hadii has coalesced the many supporters and thinkers of the Revolution to bring to life this manifesto of our people, our nation, and our Revolution.<br>\
			This is a Revolution that will make the Old Order buckle before the strength of the working class until it collapses into ruin. Remember, dear comrade, all of the contents of this manifesto are to justify one simple fact.<br>\
			This one fact has been unsuccessfully suppressed by the Njarir'Akhran, only to live on in the burning spirit of every man, woman, and kit. The simple fact that no Tajara is born inherently better than another.<br>\
			<br>\
			Chapter 1:The Ruling Class and the Working Class<br>\
			Chapter 2: Revolutionaries and Classlessism<br>\
			Chapter 3: The Modern Njarir'Akhran Bourgeois<br>\
			Chapter 4: Classlessism: Bridging Egalitarianism and Collectivism<br>\
			Chapter 5: The Human Question: Neo-Feudalistic Classism<br>\
			Chapter 6: The Great Awakening: Classlessism With Tajara Characteristics In The Greater Galaxy<br>\
			Chapter 7: Aiairu'kuul Dialectic Theory On Trans-Substational Class Elevation<br>\
			Chapter 8: Breaking The Chains: Persuading Non-Tajara To Support Their Own Liberation<br>\
			Chapter 9: The Obliteration Of Class: The Final Goal<br>\
			Chapter 10: Closing Arguments: Al'Mari's Vision Of A People's Republic</small>"

/obj/item/paper/fluff/jawdat_paper/update_icon()
	return

/obj/item/folder/red/manifesto/Initialize()
	. = ..()
	new /obj/item/paper/fluff/jawdat_paper(src)
	new /obj/item/paper/fluff/jawdat_paper(src)
	new /obj/item/paper/fluff/jawdat_paper(src)
	new /obj/item/paper/fluff/jawdat_paper(src)
	new /obj/item/paper/fluff/jawdat_paper(src)
	new /obj/item/paper/fluff/jawdat_paper(src)
	new /obj/item/paper/fluff/jawdat_paper(src)
	new /obj/item/paper/fluff/jawdat_paper(src)
	new /obj/item/paper/fluff/jawdat_paper(src)
	new /obj/item/paper/fluff/jawdat_paper(src)
	new /obj/item/paper/fluff/jawdat_paper(src)


/obj/item/clothing/accessory/holster/thigh/fluff/rifler_holster //Rifler's Holster - Sophie Rifler - shodan43893
	name = "tan leather thigh holster"
	desc = "A version of the security thigh holster done up in tan leather - this one appears to have the word \"Rifler\" engraved down the side. It appears to be rather well made and hard wearing; more of a worker's holster than a show piece."
	icon = 'icons/obj/custom_items/rifler_holster.dmi'
	icon_state = "rifler_holster"


/obj/item/storage/backpack/satchel/fluff/xerius_bag //Tote Bag - Shiur'izzi Xerius - nursiekitty
	name = "tote bag"
	desc = "A sackcloth bag with an image of Moghes printed onto it. Floating above the planet are the words \"Save Moghes!\"."
	icon = 'icons/obj/custom_items/xerius_bag.dmi'
	icon_state = "xerius_bag"
	item_state = "xerius_bag"
	contained_sprite = TRUE


/obj/item/flame/lighter/zippo/fluff/moretti_zippo //Moretti's Zippo - Billy Moretti - lordbalkara
	desc = "A dark zippo with a cool blue flame. Nice."
	icon = 'icons/obj/custom_items/moretti_zippo.dmi'
	icon_state = "moretti_zippo"
	item_state = "moretti_zippo"
	contained_sprite = TRUE
	light_color = LIGHT_COLOR_BLUE


/obj/item/clothing/accessory/poncho/fluff/make_poncho //Raincoat Poncho - M.A.K.E - toasterstrudes
	name = "raincoat poncho"
	desc = "A tough brown hooded poncho that looks to be good at protecting someone from the rain."
	icon = 'icons/obj/custom_items/make_items.dmi'
	icon_state = "make_poncho"
	item_state = "make_poncho"
	contained_sprite = TRUE
	icon_override = FALSE


/obj/item/clothing/under/fluff/aegis_uniform //Hephaestus Experimental Projector - Sovereign Aegis - itanimulli
	name = "Hephaestus experimental projector"
	desc = "An odd device connected to a security uniform, apparently still in the prototype stage."
	icon = 'icons/obj/custom_items/aegis_uniform.dmi'
	icon_state = "aegis_uniform"
	item_state = "aegis_uniform"
	contained_sprite = TRUE
	species_restricted = list("Heavy Machine")


/obj/item/clothing/suit/chef/fluff/fakhr_coat //Royal Cooking Coat - Fakhr Al-Kandari - lordraven001
	name = "royal cooking coat"
	desc = "A royal cooking niform, it has gilded buttons on its cuffs and officer ranking epaulets don its shoulders."
	icon = 'icons/obj/custom_items/fakhr_items.dmi'
	icon_state = "fakhr_coat"
	item_state = "fakhr_coat"
	contained_sprite = TRUE

/obj/item/clothing/head/chefhat/fluff/fakhr_hat //Royal Toque Blanche - Fakhr Al-Kandari - lordraven001
	name = "royal toque blanche"
	desc = "A white toque blanche, There are gilded fabrics sewn into the top of it and a name in traditional Tajaran dialect \"Fakhr\"."
	icon = 'icons/obj/custom_items/fakhr_items.dmi'
	icon_state = "fakhr_hat"
	item_state = "fakhr_hat"
	contained_sprite = TRUE


/obj/item/fluff/daliyah_visa //NanoTrasen Exchange Visa - Daliyah Veridan - xanderdox
	name = "NanoTrasen exchange visa"
	desc = "A work visa authorizing the holder, Daliyah Veridan, to work within the Republic of Biesel. An Eridani and NanoTrasen logo are embossed on the back."
	icon = 'icons/obj/custom_items/daliyah_visa.dmi'
	icon_state = "daliyah_visa"
	w_class = 2


/obj/item/surgery/retractor/fluff/tristen_retractor //Laser Retractor - Tristen Wolff - elianabeth
	name = "laser retractor"
	desc = "The fabled laser retractor. It's a horrible amalgamation of a laser pointer, a retractor, and lots of tape."
	icon = 'icons/obj/custom_items/tristen_retractor.dmi'
	icon_state = "tristen_retractor"


/obj/item/fluff/amy_player //Music player - Amy Heris - golle
	name = "music player"
	desc = "An olive green HF24 in pristine condition, there is a small engraving on the back, reading \"To Amy, I will always be here for you, Varan.\""
	icon = 'icons/obj/custom_items/amy_player.dmi'
	icon_state = "amy_player_off"
	item_state = "electornic"
	w_class = 2
	slot_flags = SLOT_BELT
	var/broken = FALSE
	var/open = FALSE
	var/on = FALSE
	var/obj/item/clothing/ears/earmuffs/earbuds

/obj/item/fluff/amy_player/Initialize()
	. = ..()
	earbuds = new(src)

/obj/item/fluff/amy_player/Destroy()
	QDEL_NULL(earbuds)
	return ..()

/obj/item/fluff/amy_player/update_icon()
	if(broken)
		icon_state = "amy_player_broken"
		return
	if(on)
		icon_state = "amy_player_on"
	else
		icon_state = "amy_player_off"

/obj/item/fluff/amy_player/attack_self(mob/user as mob)
	if(broken)
		to_chat(user, "<span class='warning'>The screen flickers and blinks with errors.</span>")
		return

	if(!on)
		to_chat(user, "<span class='notice'>You turn on \the [src].</span>")
		on = TRUE

	else
		to_chat(user, "<span class='notice'>You turn off \the [src].</span>")
		on = FALSE

	update_icon()


/obj/item/fluff/amy_player/attack_hand(var/mob/user)
	if(earbuds && src.loc == user)
		earbuds.forceMove(user.loc)
		user.put_in_hands(earbuds)
		earbuds = null
		update_icon()
		return

	return ..()

/obj/item/fluff/amy_player/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/clothing/ears/earmuffs) && !earbuds)
		user.unEquip(I)
		I.forceMove(src)
		earbuds = I
		to_chat(user, "<span class='notice'>You place \the [I] in \the [src].</span>")
		return

	if(broken)
		if(I.isscrewdriver())
			if(!open)
				open = TRUE
				to_chat(user, "<span class='notice'>You unfasten the back panel.</span>")

			else
				open = FALSE
				to_chat(user, "<span class='notice'>You secure the back panel.</span>")
			playsound(user.loc, I.usesound, 50, 1)

		if(I.ismultitool() && open)
			to_chat(user, "<span class='notice'>You quickly pulse a few fires, and reset the screen and device.</span>")
			broken = FALSE
			update_icon()

/obj/item/fluff/amy_player/emp_act(severity)
	broken = TRUE
	on = FALSE
	update_icon()
	playsound(src, "spark", 50, 1, -1)
	..()


/obj/item/clothing/head/fluff/jix_wrap //Dull Headwraps - JIX - kyres1
	name = "dull headwraps"
	desc = "A sturdy, dull brown cloth."
	icon = 'icons/obj/custom_items/jix_items.dmi'
	icon_state = "jix_wrap"
	item_state = "jix_wrap"
	contained_sprite = TRUE

/obj/item/clothing/suit/fluff/jix_robes //Dull Robes - JIX - kyres1
	name = "dull robes"
	desc = "A set of drab robes which look particularly old, though in good condition. It consists of two pieces, loosely connected and separating at the center."
	icon = 'icons/obj/custom_items/jix_items.dmi'
	icon_state = "jix_robes"
	item_state = "jix_robes"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	contained_sprite = TRUE


/obj/item/clothing/mask/fluff/ird_mask //Titanium Faceplate - IRD - kyres1
	name = "titanium faceplate"
	desc = "An odd mask seeming to mimic the face of a Human with some artistic liberties taken. Small lights keep it dimly illuminated from within with holographic projectors emulating two bright blue eyes.  \
	Its rigid frame is composed of what looks like polished titanium."
	icon = 'icons/obj/custom_items/ird_face.dmi'
	icon_state = "ird_mask"
	item_state = "ird_mask"
	contained_sprite = TRUE
	flags_inv = HIDEEARS|HIDEFACE
	body_parts_covered = FACE
	w_class = 3.0


/obj/item/dice/fluff/baron_dice //BARON's Dice - BARON - iamcrystalclear
	weighted = TRUE
	favored_number = 2


/obj/item/flame/lighter/zippo/fluff/nikit_zippo //Vasili Mine Zippo - Nikit Vasili - simontheminer
	desc = "An old looking zippo lighter with Vasili Mine Logo engraved on it. \"Good Luck Nikit\" is crudely scratched on under the logo in small writing."
	icon = 'icons/obj/custom_items/nikit_zippo.dmi'
	icon_state = "nikit_zippo"


/obj/item/clothing/suit/fluff/marwani_dress //Unathi Purple Dress - Ilaeza Marwani - burgerbb
	name = "unathi purple dress"
	desc = "A strange purple dress designed to fit very tall female unathi, suitable for indoor wear in warmer climate. Attached to it is some sort of giant iron emblem."
	icon = 'icons/obj/custom_items/marwani_dress.dmi'
	icon_state = "mar_dress"
	item_state = "mar_dress"
	contained_sprite = TRUE

/obj/item/clothing/shoes/jackboots/toeless/fluff/marwani_shoes //Unathi Purple Boots - Ilaeza Marwani - burgerbb
	name = "unathi purple boots"
	desc = "Giant, closed-toe boots with extra claw space and support, perfect for those with clawed feet."
	icon = 'icons/obj/custom_items/marwani_dress.dmi'
	item_state = "mar_boots"
	icon_state = "mar_boots"
	contained_sprite = TRUE

/obj/item/clothing/gloves/white/unathi/fluff/marwani_gloves //Unathi Arm Warmers - Ilaeza Marwani - burgerbb
	name = "unathi arm warmers"
	desc = "Light, white cotton arm warmers fashionably designed to warm unathi arms."
	icon = 'icons/obj/custom_items/marwani_dress.dmi'
	icon_state = "mar_gloves"
	item_state = "mar_gloves"
	contained_sprite = TRUE


/obj/item/deck/tarot/fluff/klavdiya_cards //Adhomian Divination Cards Deck - Klavdiya Tikhomirov - alberyk
	name = "adhomian divination cards deck"
	desc = "An adhomian deck of divination cards, used to read the one's fortune or play games."
	icon_state = "deck_adhomai"

/obj/item/deck/tarot/fluff/klavdiya_cards/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("D'as'ral Massacre","Clairvoyant","Suns' Sister","Queen","King","Father of the Parivara","S'rendal'Matir","Tank","Royal Grenadier","Kraszarrumalkarii","Hand of Fate","Great Revolution","Assassin","Assassination","Dymtris Line",
	"Rrak'narrr","Steeple","Messa","Raskara","S'rendarr","Kazarrhaldiye","Adhomai"))
		P = new()
		P.name = "[name]"
		P.card_icon = "adhomai_major"
		P.back_icon = "card_back_adhomai"
		cards += P
	for(var/suit in list("wands","pentacles","cups","swords"))


		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten","serf","soldier","queen","king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "adhomai_[suit]"
			P.back_icon = "card_back_adhomai"
			cards += P

/obj/item/clothing/accessory/locket/fluff/klavdiya_amulet //Moon Shaped Amulet - Klavdiya Tikhomirov - alberyk
	name = "moon shaped amulet"
	desc = "A metalic necklace that bears a silver moon shapped pendant."
	icon = 'icons/obj/custom_items/klavdiya_amulet.dmi'
	icon_state = "klavdiya_amulet"


/obj/item/clothing/gloves/fluff/lunea_gloves //Spark Gloves - Lunea Discata - tishinastalker
	name = "spark gloves"
	desc = "Custom made flame retardant gloves designed after Cpt. Stallion from hit 2451 anime series Truesteel Arcanist: Fellowship. \
	A lighter assembly is built along the index finger with a tiny plate of steel, and there is a small flint built into the thumb."
	icon = 'icons/obj/custom_items/lunea_gloves.dmi'
	icon_state = "lunea_gloves"
	item_state = "lunea_gloves"
	contained_sprite = TRUE
	var/lit = FALSE

/obj/item/clothing/gloves/fluff/lunea_gloves/verb/toggle()
	set name = "Toggle Spark Gloves"
	set category = "Object"
	set src in usr

	if (use_check_and_message(usr)) return

	if(!lit)
		usr.visible_message("<span class='notice'>With a snap of \the [usr]'s fingers, a small lighter flame sparks from \his index fingers!</span>")
		lit = TRUE
		playsound(src.loc, 'sound/items/cigs_lighters/zippo_on.ogg', 75, 1)
		update_icon()
		usr.update_inv_gloves()
		return

	else
		usr.visible_message("<span class='notice'>With the flick of \the [usr] wrists and the pinch of \his fingers, the glove's flames are extinguished.</span>")
		lit = FALSE
		playsound(src.loc, 'sound/items/cigs_lighters/zippo_off.ogg', 75, 1)
		update_icon()
		usr.update_inv_gloves()
		return

/obj/item/clothing/gloves/fluff/lunea_gloves/update_icon()
	if(lit)
		icon_state = "[icon_state]_lit"
		item_state = "[item_state]_lit"
		set_light(2, 0.25, "#E38F46")
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
		set_light(0)


/obj/item/fluff/fernando_knittingneedles //Kitting Needles - Fernando Gonzales - resilynn
	name = "knitting needles"
	desc = "Silver knitting needles used for stitching yarn."
	icon = 'icons/obj/custom_items/fernando_knitting.dmi'
	icon_state = "knittingneedles"
	item_state = "knittingneedles"
	w_class = 2
	contained_sprite = TRUE
	var/working = FALSE
	var/obj/item/fluff/yarn/ball

/obj/item/fluff/fernando_knittingneedles/Destroy()
	if(ball)
		QDEL_NULL(ball)
	return ..()

/obj/item/fluff/fernando_knittingneedles/examine(mob/user)
	if(..(user, 1))
		if(ball)
			to_chat(user, "There is \the [ball] between the needles.")

/obj/item/fluff/fernando_knittingneedles/update_icon()
	if(working)
		icon_state = "knittingneedles_on"
		item_state = "knittingneedles_on"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)

	if(ball)
		add_overlay("[ball.icon_state]")
	else
		cut_overlays()

/obj/item/fluff/fernando_knittingneedles/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/fluff/yarn))
		if(!ball)
			user.unEquip(O)
			O.forceMove(src)
			ball = O
			to_chat(user, "<span class='notice'>You place \the [O] in \the [src]</span>")
			update_icon()

/obj/item/fluff/fernando_knittingneedles/attack_self(mob/user as mob)
	if(!ball) //if there is no yarn ball, nothing happens
		to_chat(user, "<span class='warning'>You need a yarn ball to stitch.</span>")
		return

	if(working)
		to_chat(user, "<span class='warning'>You are already sitching something.</span>")
		return

	user.visible_message("<span class='notice'>\The [user] is knitting something soft and cozy.</span>")
	working = TRUE
	update_icon()

	if(!do_after(user,2 MINUTES))
		to_chat(user, "<span class='warning'>Your concentration is broken!</span>")
		working = FALSE
		update_icon()
		return

	var/obj/item/clothing/under/sweater/G = new(get_turf(user))
	G.color = ball.color
	qdel(ball)
	ball = null
	working = FALSE
	update_icon()
	to_chat(user, "<span class='warning'>You finished \the [G]!</span>")

/obj/item/fluff/yarn
	name = "ball of yarn"
	desc = "A ball of yarn, this one is white."
	icon = 'icons/obj/custom_items/fernando_knitting.dmi'
	icon_state = "white_ball"
	w_class = 1

/obj/item/fluff/yarn/red
	desc = "A ball of yarn, this one is red."
	color = "#ff0000"

/obj/item/fluff/yarn/blue
	desc = "A ball of yarn, this one is blue."
	color = "#0000FF"

/obj/item/fluff/yarn/green
	desc = "A ball of yarn, this one is green."
	color = "#00ff00"

/obj/item/fluff/yarn/purple
	desc = "A ball of yarn, this one is purple."
	color = "#800080"

/obj/item/fluff/yarn/yellow
	desc = "A ball of yarn, this one is yellow."
	color = "#FFFF00"

/obj/item/storage/box/fluff/knitting //a bunch of things, so it goes into the box
	name = "knitting supplies"

/obj/item/storage/box/fluff/knitting/fill()
	..()
	new /obj/item/fluff/fernando_knittingneedles(src)
	new /obj/item/fluff/yarn(src)
	new /obj/item/fluff/yarn/red(src)
	new /obj/item/fluff/yarn/blue(src)
	new /obj/item/fluff/yarn/green(src)
	new /obj/item/fluff/yarn/purple(src)
	new /obj/item/fluff/yarn/yellow(src)


/obj/item/clothing/under/fluff/moyers_shirt //Custom Martian Raider T-Shirt - Caiden Moyers - tylaaaar
	name = "custom martian raider t-shirt"
	desc = "A Martian Raider Spaceball T-shirt with the name \"MOYERS\" written on the back in plain white text."
	icon = 'icons/obj/custom_items/moyers_shirt.dmi'
	icon_state = "moyers_shirt"
	item_state = "moyers_shirt"
	contained_sprite = TRUE


/obj/item/clothing/suit/fluff/eri_robes //Senior Alchemist Robes - Eri Akhandi - paradoxspace
	name = "senior alchemist robes"
	desc = "A green set of robes, trimmed with what appears to be real gold. Looking at the necklace, you can see the alchemical symbol for the Philosopher's Stone, made of ruby."
	icon = 'icons/obj/custom_items/eri_robes.dmi'
	icon_state = "eri_robes"
	item_state = "eri_robes"
	contained_sprite = TRUE


/obj/item/fluff/halstere_card //Solarian Alliance Military ID - Kalren Halstere - brutishcrab51
	name = "solarian alliance military ID"
	desc = "A green and white military identification card, with an Alliance of Sovereign Solarian Nations sigil stamped on the front."
	icon = 'icons/obj/custom_items/halstere_clothing.dmi'
	icon_state = "halstere_card"
	w_class = 2
	var/flipped = FALSE

/obj/item/fluff/halstere_card/attack_self(mob/user as mob)
	flipped = !flipped
	queue_icon_update()

/obj/item/fluff/halstere_card/update_icon()
	if(flipped)
		icon_state = "halstere_card_open"
	else
		icon_state = initial(icon_state)

/obj/item/fluff/halstere_card/examine(mob/user)
	if(..(user, 1) && flipped)
		to_chat(user, "The name 'Halstere, Kalren C.' is stamped on it. An expiration date is listed on it, '2465JAN01'. A pay grade is listed beside the name. 'MAJ/O4'. A number is listed under the expiration date: '14015236810'.")


/obj/item/clothing/suit/storage/hooded/wintercoat/fluff/balkerina_robes //Red Armada Robes - Zorrianna Balkerina - drwago
	name = "red armada robes"
	desc = "Deep red robes belonging to a Consortium Magister. A curious symbol is displayed on the black tabard down it's front."
	icon = 'icons/obj/custom_items/balkerina_robes.dmi'
	icon_state = "balkerina_robes"
	item_state = "balkerina_robes"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	contained_sprite = TRUE


/obj/item/storage/fluff/sovno_carrier //Reinforced Cat Carrier - Anabelle Sovno - pratepresidenten
	name = "cat carrier"
	desc = "It appears to be a reinforced cat carrier. Decals of hearts and kittens are plastered all over its sides."
	icon = 'icons/obj/custom_items/sovno_carrier.dmi'
	icon_state = "sovno_carrier"
	item_state = "sovno_carrier"
	contained_sprite = TRUE
	w_class = 4
	can_hold = list(/obj/item/holder/cat)
	storage_slots = 4
	max_storage_space = 16
	var/used = FALSE

/obj/item/storage/fluff/sovno_carrier/open(mob/user as mob)
	if(!used)
		deploy_cats(user)
	else
		..()

/obj/item/storage/fluff/sovno_carrier/attack_self(mob/user)
	if(!used)
		deploy_cats(user)

/obj/item/storage/fluff/sovno_carrier/proc/deploy_cats(mob/user as mob)
	used = TRUE
	to_chat(user, "<span class='notice'>You open \the [src]'s hatch.</span>")
	new /mob/living/simple_animal/cat/fluff/jonesy(user.loc)
	new /mob/living/simple_animal/cat/fluff/kathrine(user.loc)
	new /mob/living/simple_animal/cat/fluff/fluffles(user.loc)
	new /mob/living/simple_animal/cat/fluff/faysaljr(user.loc)

/mob/living/simple_animal/cat/fluff/jonesy
	name = "Jonesy"
	desc = "An orange tabby cat. He has a purple silk neckerchief."
	icon = 'icons/obj/custom_items/sovno_carrier.dmi'
	icon_state = "jonesy"
	item_state = "jonesy"
	icon_living = "jonesy"
	icon_dead = "jonesy_dead"
	icon_rest = "jonesy_rest"

/mob/living/simple_animal/cat/fluff/kathrine
	name = "Kathrine"
	desc = "She has an elegant, shiny black coat of fur. Around her neck sits a dark pink collar with a golden bell attached to it."
	gender = FEMALE
	icon = 'icons/obj/custom_items/sovno_carrier.dmi'
	icon_state = "kathrine"
	item_state = "kathrine"
	icon_living = "kathrine"
	icon_dead = "kathrine_dead"
	icon_rest = "kathrine_rest"

/mob/living/simple_animal/cat/fluff/fluffles
	name = "Fluffles"
	desc = "A somewhat sickly looking cat. Her fur is white with black patches. A black collar sits around her neck, a golden heart with the word \"Fluffles\" attached to it."
	gender = FEMALE
	icon = 'icons/obj/custom_items/sovno_carrier.dmi'
	icon_state = "fluffles"
	item_state = "fluffles"
	icon_living = "fluffles"
	icon_dead = "fluffles_dead"
	icon_rest = "fluffles_rest"

/mob/living/simple_animal/cat/fluff/faysaljr
	name = "Faysal Jr"
	desc = "A black and white tabby kitten. His coat is very fluffy and his tail stained completely black. A silver collar with a red gem rests around his neck."
	icon = 'icons/obj/custom_items/sovno_carrier.dmi'
	icon_state = "faysaljr"
	item_state = "faysaljr"
	icon_living = "faysaljr"
	icon_dead = "faysaljr_dead"
	can_nap = 0


/obj/item/clothing/suit/storage/toggle/fluff/talon_coat //Embroidered Coat - Talon Hatfield - dronzthewolf
	name = "embroidered coat"
	desc = " Martian long coat, made to fend off dust storms and other unpleasantries. This one has a few patches sewn into it depicting: A Solarian flag, a Batallion number, and a large sun."
	icon = 'icons/obj/custom_items/talon_coat.dmi'
	icon_state = "talon_coat"
	item_state = "talon_coat"
	icon_open = "talon_coat_open"
	icon_closed = "talon_coat"
	contained_sprite = TRUE


/obj/item/storage/backpack/cloak/fluff/ryn_cloak //Security Tunnel Cloak - Za'Akaix'Ryn Zo'ra - jamchop23334
	name = "security tunnel cloak"
	desc = "A blue, tailor-made tunnel cloak with paltry storage options. The fabric is smoother and less abrasive than regular tunnel cloaks, though it looks difficult to wear."
	icon = 'icons/obj/custom_items/ryn_clothing.dmi'
	icon_state = "ryn_cloak"
	item_state = "ryn_cloak"
	contained_sprite = TRUE

/obj/item/clothing/head/fluff/ryn_hood //Security Tunnel Hood - Za'Akaix'Ryn Zo'ra - jamchop23334
	name = "security tunnel hood"
	desc = "A silky smooth blue hood, though its more of a headwrap. You're having a hard time wrapping your head around how to wear this."
	icon = 'icons/obj/custom_items/ryn_clothing.dmi'
	icon_state = "ryn_hood"
	item_state = "ryn_hood"
	contained_sprite = TRUE


/obj/item/material/kitchen/utensil/fork/fluff/vedai_fork //Stainless Steel Fork - Vedai'Kwia Xizal - conspiir
	desc = "A stainless steel fork. The word \"Kwia\" is engraved on the back of the handle."
	icon = 'icons/obj/custom_items/vedai_fork.dmi'
	icon_state = "vedai_fork"
	applies_material_colour = FALSE

/obj/item/material/kitchen/utensil/fork/fluff/vedai_fork/set_material(var/new_material)
	..()
	name = "stainless [material.display_name] [initial(name)]"


/obj/item/sign/fluff/tokash_sign //Shark Jaw Trophy - Suvek Tokash - evandorf
	name = "shark jaw trophy"
	desc = "A pair of jaws from what must have been a large and impressive shark."
	icon_state = "tokash_sign"
	sign_state = "tokash_sign"
	w_class = 2


/obj/item/spirit_board/fluff/klavdiya_board //Ghostly Board - Klavdiya Tikhomirov - alberyk
	name = "ghostly board"
	desc = "An adhomian ghostly board, used in divination rituals. This one is blue and has the symbol of a moon on it."
	icon = 'icons/obj/custom_items/klavdiya_amulet.dmi'
	icon_state = "klavdiya_board" //thanks to kyres1 for the sprites


/obj/item/clothing/suit/storage/fluff/diamond_jacket //Clawed Arm & Jacket - Diamond with Flaw - burgerbb
	name = "torn chemistry jacket"
	desc = "The entire left side of this perfectly good jacket was torn to shreds."
	icon = 'icons/obj/custom_items/diamond_cloak.dmi'
	icon_state = "diamond_chemjacket"
	item_state = "diamond_chemjacket"
	contained_sprite = TRUE

/obj/item/organ/external/arm/industrial/fluff/dionaea_l_arm
	robotize_type = PROSTHETIC_DIONA

/obj/item/organ/external/hand/industrial/fluff/dionaea_l_hand
	robotize_type = PROSTHETIC_DIONA

/datum/robolimb/fluff/dionaea
	company = PROSTHETIC_DIONA
	desc = "This limb is covered in a strange formation of metal and organic matter."
	icon = 'icons/mob/human_races/r_ind_diona.dmi'
	linked_frame = "Unknown Entity"
	species_can_use = list("Diona")
	unavailable_at_chargen = TRUE

/obj/item/fluff/dionaea_arm
	name = "strange arm"
	desc = "Is that mold?"
	icon = 'icons/mob/human_races/r_ind_diona.dmi'
	icon_state = "preview"

/obj/item/fluff/dionaea_arm/attack_self(mob/user)
	if(user.ckey != "burgerbb" || !ishuman(user))
		to_chat(user,span("notice","You can't seem to figure out what to do with this."))
		return

	var/mob/living/carbon/human/H = user
	if(!H.is_diona())
		to_chat(user,span("notice","It looks strangely familiar..."))
		return

	var/obj/item/organ/external/OL = H.get_organ(BP_L_ARM)
	var/obj/item/organ/external/arm/industrial/fluff/dionaea_l_arm/NA = new(get_turf(src))
	var/obj/item/organ/external/hand/industrial/fluff/dionaea_l_hand/NH = new(get_turf(src))

	if(OL)
		qdel(OL)

	if(NA)
		NA.replaced(H)
		if(NH)
			NH.replaced(H)
		H.update_body()
		H.updatehealth()
		H.UpdateDamageIcon()

	H.drop_from_inventory(src)
	qdel(src)


/obj/item/clothing/glasses/threedglasses/fluff/grunnus_glasses //3D glasses - Paul Grunnus - moom241
	desc = "A pair of old, beat up looking glasses, with red and blue lenses. Pretty archaic, but some might call it fashionable."
	icon = 'icons/obj/custom_items/grunnus_glasses.dmi'
	icon_state = "grunnus_glasses"
	item_state = "grunnus_glasses"
	contained_sprite = TRUE


/obj/item/clothing/under/dress/fluff/ameline_dress //Dominian Culinary Dress - Ameline Hemory - dasfox
	name = "traditional jumper dress"
	desc = " The latest in Dominian dresses, this piece of clothing is similar to those worn by chefs on the planet of Moroz. With a pleated skirt and detachable sleeves, \
	it is on the less modest end of Morozi fashion."
	icon = 'icons/obj/custom_items/ameline_dress.dmi'
	icon_state = "ameline_dress"
	item_state = "ameline_dress"
	contained_sprite = TRUE


/obj/item/clothing/head/fluff/aavs_mask //Reflective Mask - Aavs Guwan - dronzthewolf
	name = "reflective mask"
	desc = "This odd mask and hood combination covers the wearer, and seems to be made of a one-way dome mirror and some old cloth or rope."
	icon = 'icons/obj/custom_items/aavs_mask.dmi'
	icon_state = "aavs_mask"
	item_state = "aavs_mask"
	contained_sprite = TRUE
	flags_inv = HIDEEARS|HIDEFACE|BLOCKHAIR|BLOCKHEADHAIR
	body_parts_covered = HEAD|FACE|EYES


/obj/item/clothing/accessory/fluff/krin_shirt //Skull Shirt - Krin Volqux - paradoxspace
	name = "skull shirt"
	desc = "A shirt carrying the familiar skeletal logo of the Skrellian punk band \"GLORSH YOU ASSHOLE\" This appears to be for their 2461 \"Tri-Qyu Express\" tour."
	icon = 'icons/obj/custom_items/krin_clothing.dmi'
	icon_state = "krin_shirt"
	item_state = "krin_shirt"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/fluff/krin_jacket //Polychromatic Jacket - Krin Volqux - paradoxspace
	name = "polychromatic jacket"
	desc = "What appears to be a modified canvas jacket, covered in small polychromatic patches and aftermarket spikes in holo colors, changing often. The keen eye can spot a \"Fourth Incident\" patch on the chest."
	icon = 'icons/obj/custom_items/krin_clothing.dmi'
	icon_state = "krin_jacket"
	item_state = "krin_jacket"
	contained_sprite = TRUE

/obj/item/clothing/shoes/fluff/krin_shoes //Knee-high High-tops - Krin Volqux - paradoxspace
	name = "knee-high high-tops"
	desc = "These highest-tops stretch all the way up to the knees and then some. Drawn on the side in small Skrellian print is \"High tech, low life.\""
	icon = 'icons/obj/custom_items/krin_clothing.dmi'
	item_state = "krin_shoes"
	icon_state = "krin_shoes"
	contained_sprite = TRUE

/obj/item/storage/backpack/fluff/krin_bag //Broken Pack - Krin Volqux - paradoxspace
	name = "broken pack"
	desc = "What appears to be a technologically-advanced backpack, the electronics are fried from a distant malfunction. It smells like a disposals track. \
	A small \"Original Conglomerate\" patch has been applied to the strap, a popular moisturewave Idol group. It reads \"Not Dead Yet.\" next to a Neaera in a spacesuit."
	icon = 'icons/obj/custom_items/krin_clothing.dmi'
	item_state = "krin_bag"
	icon_state = "krin_bag"
	contained_sprite = TRUE


/obj/item/clothing/under/fluff/mira_uniform //Mira's Cloth Undersuit - Mira Akhandi - drwago
	name = "dark clothes"
	desc = "A set of dark under clothing, loosely fitting. The initials /M.A./ are stitched into the collar."
	icon = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_state = "mira_uniform"
	item_state = "mira_uniform"
	contained_sprite = TRUE

/obj/item/clothing/under/fluff/mira_uniform/Initialize()
	. = ..()
	rolled_sleeves = 0
	rolled_down = 0

/obj/item/clothing/under/fluff/mira_uniform/rollsuit()
	set name = "Roll Down Jumpsuit"
	set category = "Object"

	set src in usr
	if (use_check_and_message(usr, USE_DISALLOW_SILICONS))
		return

	if(rolled_sleeves)
		to_chat(usr, "<span class='warning'>You must roll up your [src]'s sleeves first!</span>")
		return

	rolled_down = !rolled_down
	if(rolled_down)
		body_parts_covered &= LOWER_TORSO|LEGS|FEET
		item_state = "[item_state]_d"
	else
		body_parts_covered = initial(body_parts_covered)
		item_state = initial(item_state)
	update_clothing_icon()

/obj/item/clothing/under/fluff/mira_uniform/rollsleeves()
	set name = "Roll Up Sleeves"
	set category = "Object"
	set src in usr

	if (use_check_and_message(usr, USE_DISALLOW_SILICONS))
		return

	if(rolled_down)
		to_chat(usr, "<span class='warning'>You must roll up your [src] first!</span>")
		return

	rolled_sleeves = !rolled_sleeves
	if(rolled_sleeves)
		body_parts_covered &= ~(ARMS|HANDS)
		item_state = "[item_state]_r"
	else
		body_parts_covered = initial(body_parts_covered)
		item_state = initial(item_state)
	update_clothing_icon()

/obj/item/clothing/suit/storage/toggle/labcoat/fluff/mira_robes //Junior Alchemist Robes - Mira Akhandi - drwago
	name = "junior alchemist robes"
	desc = "A  robe with a light silky gold colored belt around the waist. Placed upon the print is two red jewels pinned to it neatly."
	icon = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_state = "mira_robes"
	item_state = "mira_robes"
	icon_open = "mira_robes_open"
	icon_closed = "mira_robes"
	contained_sprite = TRUE

/obj/item/clothing/shoes/fluff/mira_boots //Mira Boots - Mira Akhandi - drwago
	name = "dark boots"
	desc = "A pair of black boots with tall laces."
	icon = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_state = "mira_boots"
	item_state = "mira_boots"
	contained_sprite = TRUE

/obj/item/clothing/under/fluff/mira_skirt //Mira's Skirt - Mira Akhandi - drwago
	name = "suspended skirt"
	desc = "A plaid skirt with suspenders, sewed into the side is the initials \"M.A.\"."
	icon = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_state = "mira_skirt"
	item_state = "mira_skirt"
	contained_sprite = TRUE

/obj/item/reagent_containers/glass/beaker/fluff/mira_beaker //Alchemist Flask - Mira Akhandi - drwago
	name = "alchemist flask"
	desc = "A large bottle used to mix chemicals inside."
	icon = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_state = "mira_beaker"

/obj/item/storage/backpack/fluff/mira_bag //Burlap Alchemist Bag - Mira Akhandi - drwago
	name = "burlap bag"
	desc = "A smallish burlup sack, modified to lug around belongings. Stiched into it is the letters '\"M.A.\"."
	icon_state = "giftbag0"
	item_state = "giftbag0"

/obj/item/clothing/suit/fluff/mira_vest //Cut-off Vest - Mira Akhandi - drwago
	name = "cut-off vest"
	desc = "A short grey puffer vest."
	icon = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_state = "mira_vest"
	item_state = "mira_vest"
	contained_sprite = TRUE

/obj/item/cane/fluff/qrqil_cane //Energy Cane - Qrqil Qrrzix - yonnimer
	name = "energy cane"
	desc = "This silver-handled cane has letters carved into the sides."
	icon = 'icons/obj/custom_items/qrqil_cane.dmi'
	icon_state = "qrqil_cane"
	item_state = "qrqil_cane"
	contained_sprite = TRUE
	w_class = 2
	var/active = FALSE

/obj/item/cane/fluff/qrqil_cane/attack_self(mob/user)
	active= !active
	if(active)
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")
		item_state = icon_state
		w_class = 4
	else
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] is now de-energised..</span>")
		w_class = initial(w_class)

	update_icon()
	user.update_inv_l_hand(FALSE)
	user.update_inv_r_hand()

/obj/item/cane/fluff/qrqil_cane/update_icon()
	if(active)
		icon_state = "[icon_state]_active"
		item_state = icon_state
	else
		icon_state = initial(icon_state)
		item_state = icon_state


/obj/item/clothing/accessory/poncho/fluff/djar_cape //Zandiziite Cape - D'Jar Sa'Kuate - firstact
	name = "zandiziite cape"
	desc = "A dominian cape, with a clasp bearing the symbol of a champion Zandiziite wrestler. It looks well worn, of the finest material."
	icon = 'icons/obj/custom_items/djar_cape.dmi'
	icon_state = "djar_cape"
	item_state = "djar_cape"
	contained_sprite = TRUE
	icon_override = FALSE


/obj/item/device/flashlight/fluff/maximus_squirrel //Vibrating Blue Squirrel - Maximus Crane - lordfowl
	name = "vibrating blue squirrel"
	desc = "It vibrates, and it is blue. The goal of adventurers everywhere."
	icon = 'icons/obj/custom_items/maximus_squirrel.dmi'
	icon_state = "maximus_squirrel"
	item_state = "maximus_squirrel"
	light_color = LIGHT_COLOR_BLUE
	light_wedge = LIGHT_OMNI
	action_button_name = null
	activation_sound = null
	brightness_on = 1
	contained_sprite = TRUE


/obj/item/storage/toolbox/fluff/bretscher_toolbox //Gang-colored Toolbox - Robert Bretscher - vtcobaltblood
	name = "gang-colored toolbox"
	desc = "A toolbox painted in the traditional colors of a martian youth gang, the Shuttleyard Boys. It looks fairly old, the paint needs some renewal."
	icon = 'icons/obj/custom_items/bretscher_toolbox.dmi'
	icon_state = "bretscher_toolbox"
	item_state = "bretscher_toolbox"
	contained_sprite = TRUE


/obj/item/clothing/suit/chaplain_hoodie/fluff/hidemichi_robes //Zen Monk Robes - Yoshihama Hidemichi - dobhranthedruid
	name = "zen monk robes"
	desc = "A traditional Soto Zen buddhist robes for meditation and services"
	icon = 'icons/obj/custom_items/hidemichi_items.dmi'
	icon_state = "hidemichi_robes"
	item_state = "hidemichi_robes"
	contained_sprite = TRUE

/obj/item/clothing/head/fluff/hidemichi_hat //Takuhatsugasa - Yoshihama Hidemichi - dobhranthedruid
	name = "takuhatsugasa"
	desc = "A dome shaped rice hat, this one is dyed a darker color."
	icon = 'icons/obj/custom_items/hidemichi_items.dmi'
	icon_state = "hidemichi_hat"
	item_state = "hidemichi_hat"
	contained_sprite = TRUE


/obj/item/clothing/accessory/badge/fluff/kelt_tags //Foreign Legion Holo-Tags - Kelt - toasterstrudes
	name = "foreign legion holo-tags"
	desc = "A set of holo-tags, on them is the printed name, address, and Serial Code as well as what appears to be a bar code underneath."
	icon = 'icons/obj/custom_items/kelt_tags.dmi'
	icon_state = "kelt_tags"
	item_state = "kelt_tags"
	stored_name = "Kelt"
	badge_string = "Tau Ceti Foreign Legion"
	contained_sprite = TRUE
	slot_flags = SLOT_MASK | SLOT_TIE


/obj/item/device/radio/headset/fluff/resolve_headset //Antennae - Decisive Resolve - itanimulli
	name = "antennae"
	desc = "Collapsible spherical antennae designed to interface with an IPC. On it, in permanent marker, are the words: \"Cody Brickstend was here\" is immaculate, tiny handwriting."
	icon = 'icons/obj/custom_items/resolve_items.dmi'
	icon_state = "resolve_antennae"
	item_state = "resolve_antennae"
	contained_sprite = TRUE

/obj/item/clothing/shoes/fluff/resolve_shoes //Treads - Decisive Resolve - itanimulli
	name = "treads"
	desc = "Clip-on rubber treads, for that extra grip. Designed for an IPC."
	icon = 'icons/obj/custom_items/resolve_items.dmi'
	icon_state = "resolve_shoes"
	item_state = "resolve_shoes"
	contained_sprite = TRUE

/obj/item/clothing/under/fluff/resolve_uniform //Haphaestus Experimental Projector - Decisive Resolve - itanimulli
	name = "haphaestus experimental projector"
	desc = "A flashing device seemingly attached to an officer's corporate security uniform. On the side of the casing are the words: \"Brickstend\", \"Dernestess\", \"Jastovski\", and \"Finch.\""
	icon = 'icons/obj/custom_items/resolve_items.dmi'
	icon_state = "resolve_uniform"
	item_state = "resolve_uniform"
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/fluff/resolve_poncho //Poncho - Decisive Resolve - itanimulli
	desc = "A decorative synthleather covering. Probably isn't the best for rain. On the shoulder's edge is a small, paper tag, that reads: \"Cassidy Finch was here\" in sloppy handwriting."
	icon = 'icons/obj/custom_items/resolve_items.dmi'
	icon_state = "resolve_poncho"
	item_state = "resolve_poncho"
	contained_sprite = TRUE
	icon_override = FALSE


/obj/item/storage/bible/fluff/oscar_bible //The Holy Book Of The Trinary Perfection - Oscar O'Neil - ironchaos
	name = "holy book of the trinary perfection"
	desc = "A holy book for followers of The Trinary Perfection."
	icon = 'icons/obj/custom_items/oscar_bible.dmi'
	icon_state = "oscar_bible"


/obj/item/fluff/tokash_spear //Ancestral Spear - Suvek Tokash - evandorf
	name = "display stand"
	desc = "A small plasteel display stand which uses magnetic fields to levitate an object."
	icon = 'icons/obj/custom_items/tokash_spear.dmi'
	icon_state = "stand-spear"
	w_class = 3
	var/has_spear = TRUE

/obj/item/fluff/tokash_spear/examine(mob/user)
	if(..(user, 1) && has_spear)
		to_chat(user, "It currently holds an old looking spearhead.")

/obj/item/fluff/tokash_spear/update_icon()
	if(has_spear)
		icon_state = "stand-spear"
	else
		icon_state = "stand"

/obj/item/fluff/tokash_spear/attack_self(var/mob/user)
	if(has_spear)
		to_chat(user, "<span class='notice'>You remove the spearhead from \the [src].</span>")
		var/obj/item/fluff/tokash_spearhead/piece = new(get_turf(user))
		user.put_in_hands(piece)
		has_spear = FALSE
		update_icon()

/obj/item/fluff/tokash_spear/attackby(var/obj/item/W, var/mob/user)
	if(!has_spear && istype(W, /obj/item/fluff/tokash_spearhead))
		to_chat(user, "<span class='notice'>You place \the [W] on the [src].</span>")
		user.drop_from_inventory(W,src)
		qdel(W)
		has_spear = TRUE
		update_icon()
	else
		..()

/obj/item/fluff/tokash_spearhead
	name = "ancestral spearhead"
	desc = "An aged and worn spearhead. It seems to be made of bronze or composite metal."
	icon = 'icons/obj/custom_items/tokash_spear.dmi'
	icon_state = "spearhead"
	w_class = 2


/obj/item/clothing/suit/storage/dominia/fluff/naxxir_cape //Caladius Cape - Nazret Naxxir - conspiir
	name = "caladius cape"
	desc = "A fine Dominian cape tailored for a very short person. It is decorated in the purple colors of the Caladius House."
	icon = 'icons/obj/custom_items/naxxir_cape.dmi'
	icon_state = "naxxir_cape"
	item_state = "naxxir_cape"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/hooded/wintercoat/fluff/naomi_coat //Reishi Queen Winter Coat - Naomi Marlowe - smifboy78
	name = "reishi queen winter coat"
	desc = "A worn purple winter-coat. On the back, \"Reishi Queen\" is stitched on top of a skull patch. It reeks of reishi."
	icon = 'icons/obj/custom_items/naomi_coat.dmi'
	icon_state = "naomi_coat"
	item_state = "naomi_coat"
	contained_sprite = TRUE


/obj/item/clothing/ring/engagement/fluff/james_ring //James' Wedding Ring - James Campbell - valwyn
	name = "wedding ring"
	desc = "A golden wedding ring. \"Our love is written in the stars\" is engraved on it."
	icon_state = "magic"


/obj/item/clothing/gloves/yellow/fluff/linyu_gloves //Insulated Starmitts - Lin-Yu Su-Yeongseon - dasfox
	name = "insulated starmitts"
	desc = "A pair of starmitts, with insulated lining on the fingers. They seem to be in an icy blue instead of standard yellow. Along the seam of the bottom reads \"Lin-Yu\" in golden stitching."
	icon = 'icons/obj/custom_items/linyu_items.dmi'
	icon_state = "linyu_gloves"
	item_state = "linyu_gloves"
	contained_sprite = TRUE

/obj/item/clothing/glasses/spiffygogs/offworlder/fluff/linyu_glasses //Arclight Veil - Lin-Yu Su-Yeongseon - dasfox
	name = "arclight veil"
	desc = " A starveil, modified to block arclight from torches and welders. A black, flexible poly-carbonate lens to block the light is woven into the fabric of the veil itself. On the back in gold stitching reads \"Lin-Yu\"."
	icon = 'icons/obj/custom_items/linyu_items.dmi'
	icon_state = "linyu_glasses"
	item_state = "linyu_glasses"
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/fluff/linyu_cloak //Pioneer's Cloak - Lin-Yu Su-Yeongseon - dasfox
	name = "pioneer's cloak"
	desc = "A grey, spider-silk cloak. A pin on the longer side indicates it's owned by an engineer, with \"Lin-Yu\" sewed into the neck in an icy blue."
	icon = 'icons/obj/custom_items/linyu_items.dmi'
	icon_state = "linyu_cloak"
	item_state = "linyu_cloak"
	contained_sprite = TRUE
	icon_override = FALSE

/obj/item/clothing/accessory/armband/offworlder/fluff/linyu_ribbon //Mayfly Ribbons - Lin-Yu Su-Yeongseon - dasfox
	name = "mayfly ribbons"
	desc = "A blue, red, and white set of ribbons for an exo-stellar skeleton. These have green, hydroponics markings, and the name \"Sasha\" embroidered on the right shoulder ribbon."
	icon = 'icons/obj/custom_items/linyu_items.dmi'
	icon_state = "linyu_ribbon"
	item_state = "linyu_ribbon"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/fluff/imari_hoodie //Adinkra Hoodie - Imari Idris - P - ornias
	name = "adinkra hoodie"
	desc = "A large, immaculate white hoodie adorned with seven Adinkra symbols on the back. Below the large central symbol is the text \"MMERE DANE\". There is a small 'Idris Incorporated' logo below the left drawstring."
	icon = 'icons/obj/custom_items/imari_hoodie.dmi'
	icon_state = "imari_hoodie"
	item_state = "imari_hoodie"
	contained_sprite = TRUE


/obj/item/reagent_containers/glass/bucket/fluff/khasan_bucket //Battered Metal Bucket - Khasan Mikhnovsky - alberyk
	name = "battered metal bucket"
	desc = "A battered rusty metal bucket. It has seen a lot of use and little maintenance."
	icon = 'icons/obj/custom_items/khasan_bucket.dmi'
	icon_state = "khasan_bucket"
	item_state = "khasan_bucket"
	contained_sprite = TRUE
	helmet_type = /obj/item/clothing/head/helmet/bucket/fluff/khasan_bucket
	drop_sound = 'sound/items/drop/axe.ogg'

/obj/item/clothing/head/helmet/bucket/fluff/khasan_bucket
	name = "battered metal bucket helmet"
	icon = 'icons/obj/custom_items/khasan_bucket.dmi'
	icon_state = "khasan_helmet"
	item_state = "khasan_helmet"
	contained_sprite = TRUE


/obj/item/fluff/akinyi_symphette //Holo-symphette - Akinyi Idowu - kyres1
	name = "holo-symphette"
	desc = "A cheap, collapsible musical instrument which utilizes holographic projections to generate a rough noise. It's shaped like a small harp, and seems to be  \
	able to be tuned to mimic several old stringed Solarian instruments with some distorted audio. It's still got its price tag sticker on it."
	icon = 'icons/obj/custom_items/akinyi_symphette.dmi'
	icon_state = "akinyi_symphette"
	item_state = "akinyi_symphette"
	w_class = 3
	slot_flags = SLOT_BACK
	contained_sprite = TRUE
	var/deployed = FALSE

/obj/item/fluff/akinyi_symphette/update_icon()
	if(deployed)
		icon_state = "akinyi_symphette_on"
		item_state = "akinyi_symphette_on"
	else
		icon_state = "akinyi_symphette"
		item_state = "akinyi_symphette"

/obj/item/fluff/akinyi_symphette/attack_self(var/mob/user)
	deployed = !deployed
	to_chat(user, "<span class='notice'>You [deployed ? "expand" : "collapse"] \the [src].</span>")
	update_icon()
	user.update_inv_l_hand()
	user.update_inv_r_hand()

/obj/item/reagent_containers/food/drinks/teapot/fluff/thea_teapot //Bronze Teapot - Thea Reeves - shestrying
	name = "bronze teapot"
	desc = "A round-bottomed, well-used teapot. It looks as though it's been carefully maintained."
	icon = 'icons/obj/custom_items/thea_tea.dmi'
	icon_state = "thea_teapot"
	center_of_mass = list("x"=16, "y"=13)

/obj/item/reagent_containers/food/drinks/fluff/thea_teacup //Bonze Teacup - Thea Reeves - shestrying
	name = "bronze teacup"
	desc = "A shallow, bronze teacup. Looks heavy."
	icon = 'icons/obj/custom_items/thea_tea.dmi'
	icon_state = "thea_teacup"
	volume = 20
	center_of_mass = list("x"=16, "y"=12)

/obj/item/storage/box/fluff/thea_teabox //Tea Box - Thea Reeves - shestrying
	desc = "A black, wooden box, the edges softened with transport and use."
	icon = 'icons/obj/custom_items/thea_tea.dmi'
	icon_state = "thea_teabox"
	foldable = null
	can_hold = list(/obj/item/reagent_containers/food/drinks/teapot/fluff/thea_teapot, /obj/item/reagent_containers/food/drinks/fluff/thea_teacup)

/obj/item/storage/box/fluff/thea_teabox/fill()
	new /obj/item/reagent_containers/food/drinks/teapot/fluff/thea_teapot(src)
	for(var/i in 1 to 4)
		new /obj/item/reagent_containers/food/drinks/fluff/thea_teacup(src)
	make_exact_fit()

/obj/item/fluff/fraseq_journal //Fraseq's Journal of Mysteries - Quorrdash Fraseq - kingoftheping
	name = "leather journal"
	desc = "An old, worn out journal made out of leather. It has a lot of lose pages stuck in it, it surely has seen better days. The front just says \"Fraseq\"."
	icon = 'icons/obj/custom_items/fraseq_journal.dmi'
	icon_state = "fraseq_journal"
	w_class = 3


/obj/item/clothing/accessory/poncho/fluff/ioraks_cape //Iorakian Cape - Kuhserze Ioraks - geeves
	name = "iorakian cape"
	desc = "A tough leather cape, with neat colours of the Ioraks clan threaded through the seams."
	icon = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_state = "ioraks_cape"
	item_state = "ioraks_cape"
	contained_sprite = TRUE
	icon_override = FALSE


/obj/item/clothing/suit/storage/fluff/strauss_jacket //Custom Firesuit - Lena Strauss - oddbomber3768
	name = "modified firesuit"
	desc = "An old industrial firesuit belonging to a defunct and forgotten company. The wearer has sawn off both of the arms, added two buttons on the front and replaced the back name \
	tag with one reading \"FIREAXE\". Doesn't look really fire resistant anymore"
	icon = 'icons/obj/custom_items/strauss_jacket.dmi'
	icon_state = "strauss_jacket"
	item_state = "strauss_jacket"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS


/obj/item/clothing/suit/storage/toggle/labcoat/fluff/likho_labcoat //Terraneus Diagnostics Labcoat - Likho - neworiginalschwann
	name = "terraneus diagnostics labcoat"
	desc = "A well-worn labcoat that marks its wearer as an employee of Terraneus Diagnostics, a subsidiary corporation of Einstein Engines. Text on the labcoat's breast pocket marks \
	the employee as a roboticist employed at Factory 09, Hoboken, United Americas."
	icon = 'icons/obj/custom_items/likho_labcoat.dmi'
	icon_state = "likho_labcoat"
	item_state = "likho_labcoat"
	icon_open = "likho_labcoat_open"
	icon_closed = "likho_labcoat"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/toggle/fr_jacket/fluff/ramit_jacket //Winter Paramedic Jacket - Ra'mit Ma'zaira - simontheminer
	name = "winter paramedic jacket"
	desc = "A custom made first responder coat. Inside is a warm fabric with the name \"Ra'Mit Ma'zaira\" sewn in by the collar."
	icon = 'icons/obj/custom_items/ramit_jacket.dmi'
	icon_state = "ramit_jacket"
	item_state = "ramit_jacket"
	icon_open = "ramit_jacket_open"
	icon_closed = "ramit_jacket"
	contained_sprite = TRUE


/obj/item/clothing/accessory/dressshirt/fluff/takahashi_uniform //High Collar Dress Shirt - Shiki Takahashi - nantei
	name = "high collar dress shirt"
	desc = "A casual dress shirt. This one has an abnormally high collar."
	icon = 'icons/obj/custom_items/takahashi_uniform.dmi'
	icon_state = "takahashi_uniform"
	item_state = "takahashi_uniform"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/det_trench/fluff/takahashi_coat //High Collar Dress Shirt - Shiki Takahashi - nantei
	name = "long trenchcoat"
	desc = "A very long, black, canvas trench coat. It goes down just below the knees. It looks to be custom-fitted, with a layer of graphene for added armor. There is an infinity \
	symbol on the back, similar to the Coalition of Colonies flag."
	icon = 'icons/obj/custom_items/takahashi_uniform.dmi'
	icon_state = "takahashi_coat"
	item_state = "takahashi_coat"
	icon_open = "takahashi_coat_open"
	icon_closed = "takahashi_coat"
	contained_sprite = TRUE


/obj/item/clothing/glasses/sunglasses/blindfold/fluff/nai_fold	//Starvoice - Nai Eresh'Wake - jamchop23334
	name = "starvoid blindfold"
	desc = "An ethereal purple blindfold, woven from an incredibly soft yet durable silk. The faintest of light shines through, shading your darkened vision in a haze of purple."
	icon = 'icons/obj/custom_items/nai_items.dmi'
	icon_state = "nai_fold"
	item_state = "nai_fold"
	contained_sprite = TRUE
	tint = TINT_BLIND
	drop_sound = 'sound/items/drop/gloves.ogg'

/obj/item/clothing/glasses/sunglasses/blindfold/fluff/nai_fold/equipped(mob/M as mob, slot)
	if (M.ckey == "jamchop23334" && M.name == "Nai Eresh'Wake")
		tint = TINT_NONE
	else
		tint = TINT_BLIND
	..()

/obj/item/clothing/gloves/fluff/nai_gloves //Starvoid Gloves - Nai Eresh'Wake - jamchop23334
	name = "starvoid gloves"
	desc = "An ethereal purple set of fingerless evening gloves, secured at the middle finger by a lace, with the palms exposed. The fabric is soft silk of some kind."
	icon = 'icons/obj/custom_items/nai_items.dmi'
	icon_state = "nai_gloves"
	item_state = "nai_gloves"
	contained_sprite = TRUE


/obj/item/fluff/muhawir_bedroll //Bedroll - Muhawir Nawfal - menown
	name = "bedroll"
	desc = "A portable bedroll, made of cloth and padding."
	icon = 'icons/obj/custom_items/muhawir_items.dmi'
	icon_state = "bedroll-rolled"
	w_class = 3.0
	attack_verb = list("battered","whacked")
	var/deployed = FALSE

/obj/item/fluff/muhawir_bedroll/attack_self(mob/user as mob)
	if(!deployed)
		to_chat(user, "<span class='notice'>You open the bedroll, extending it.</span>")
		name = "open bedroll"
		icon_state = "bedroll-open"
		layer = MOB_LAYER - 0.01
		user.drop_from_inventory(src)
		deployed = TRUE
	return

/obj/item/fluff/muhawir_bedroll/attack_hand(mob/user as mob)
	if(deployed)
		to_chat(user, "<span class='notice'>You pick up and fold \the [src].</span>")
		name = initial(name)
		icon_state = initial(icon_state)
		layer = initial(layer)
		deployed = FALSE

	..()

/obj/item/fluff/muhawir_tenttools //Toolbag - Muhawir Nawfal - menown
	name = "toolbag"
	desc = "A roll of poles and ropes. Anybody knowledgeable would know they are designed for erecting a tent."
	icon = 'icons/obj/custom_items/muhawir_items.dmi'
	icon_state = "tent-tools"
	w_class = 3.0
	attack_verb = list("battered","whacked")

/obj/item/fluff/muhawir_tent //Tentroll - Muhawir Nawfal - menown
	name = "tentroll"
	desc = "A portable tent. All wrapped up with straps and buckles."
	icon = 'icons/obj/custom_items/muhawir_items.dmi'
	icon_state = "tent-rolled"
	w_class = 3.0
	attack_verb = list("battered","whacked")

/obj/item/fluff/muhawir_tent/attackby(var/obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/fluff/muhawir_tenttools))
		user.visible_message("<span class='warning'>[user] unrolls the tent .</span>",
			"<span class='notice'>You unroll the tent.</span>")
		if(do_after(user, 5 SECONDS, act_target = src))
			user.visible_message(
				"<span class='warning'>[user] begins sliding the tent poles into the frame of the tent.</span>",
				"<span class='notice'>You begin sliding the tent poles into the frame of the tent.</span>")
			if(do_after(user, 60 SECONDS, act_target = src))
				user.visible_message(
					"<span class='warning'>[user] begins raising tent.</span>",
					"<span class='notice'>You begin raising the tent.</span>")
				if(do_after(user, 20 SECONDS, act_target = src))
					user.visible_message(
						"<span class='warning'>[usr] finishes raising the tent.</span>",
						"<span class='notice'>You finish raising the tent.</span>")
					new/obj/structure/closet/fluff/muhawir_tent(user.loc)
					qdel(src)
				return

/obj/structure/closet/fluff/muhawir_tent
	name = "camping tent"
	desc = "A relatively good quality tent, complete with mounting poles and straps for keeping it open."
	icon = 'icons/obj/custom_items/muhawir_items.dmi'
	icon_state = "tent-closed"
	icon_closed = "tent-closed"
	icon_opened = "tent-open"
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	anchored = TRUE
	storage_capacity = 15
	var/has_bedroll = FALSE

/obj/structure/closet/fluff/muhawir_tent/attackby(W as obj, mob/user as mob)
	if(istype(W, /obj/item/fluff/muhawir_bedroll))
		user.visible_message(
		"<span class='warning'>[user] lays down the bedroll inside \the [src].</span>",
		"<span class='notice'>You lay down the bedroll in \the [src].</span>")
		qdel(W)
		has_bedroll = TRUE
		return

/obj/structure/closet/fluff/muhawir_tent/verb/dismantle()
	set name = "Dismantle Tent"
	set category = "Object"
	set src in view(1)

	if (use_check_and_message(usr, USE_DISALLOW_SILICONS))
		return

	usr.visible_message(
	"<span class='warning'>[usr] begins taking apart the [src.name].</span>",
	"<span class='notice'>You begin taking apart the [src.name].</span>")
	if(has_bedroll)
		if(do_after(usr, 20 SECONDS, act_target = src))
			to_chat(usr, "<span class='notice'>You roll up the bedroll inside \the [src].</span>")
			new/obj/item/fluff/muhawir_bedroll(get_turf(usr))
			has_bedroll = FALSE
	if(do_after(usr, 50 SECONDS, act_target = src))
		to_chat(usr, "<span class='notice'>You take down \the [src].</span>")
		dump_contents()
		new/obj/item/fluff/muhawir_tent(get_turf(usr))
		qdel(src)
		return


/obj/item/clothing/head/fluff/djikstra_hood //Stellar Hood - Msizi Djikstra - happyfox
	name = "stellar hood"
	desc = "A more encompassing version of the Starveil, made from a resilient xeno-silk, intended to protect not just the eyes but also the soul of the wearer."
	icon = 'icons/obj/custom_items/djikstra_items.dmi'
	icon_state = "djikstra_hood"
	item_state = "djikstra_hood"
	contained_sprite = TRUE
	flags_inv = HIDEEARS|BLOCKHAIR|BLOCKHEADHAIR|HIDEEARS|HIDEMASK|HIDEEARS|HIDEEYES
	body_parts_covered = HEAD

/obj/item/clothing/suit/fluff/djikstra_robe //Stellar Robe - Msizi Djikstra - happyfox
	name = "stellar robe"
	desc = "A finely made robe of resilient xeno-silk, shimmering like starlight."
	icon = 'icons/obj/custom_items/djikstra_items.dmi'
	icon_state = "djikstra_robe"
	item_state = "djikstra_robe"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	contained_sprite = TRUE
	valid_accessory_slots = list("decor")

/obj/item/clothing/accessory/fluff/djikstra_blade //Symbolic Khanjbiya - Msizi Djikstra - happyfox
	name = "symbolic khanjbiya"
	desc = "A xeno-silk belt carrying an ornate, but entirely symbolic, curved dagger. The blade is fused to the sheath, preventing it from being drawn."
	icon = 'icons/obj/custom_items/djikstra_items.dmi'
	icon_state = "djikstra_blade"
	item_state = "djikstra_blade"
	contained_sprite = TRUE


/obj/item/clothing/suit/fluff/naali_blanket //Fuzzy Pink Blanket - Naali'Xiiux Qu-Uish - shestrying
	name = "fuzzy pink blanket"
	desc = "A rather large, pink, fluffy blanket. It feels quite heavy, and smells slightly of saltwater."
	icon = 'icons/obj/custom_items/naali_blanket.dmi'
	icon_state = "naali_blanket"
	item_state = "naali_blanket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	contained_sprite = TRUE

/obj/item/clothing/head/helmet/fluff/oscar_helmet //Necropolis Specialist Helmet -  Oscar Easter - slymantis84
	name = "necropolis specialist helmet"
	desc = "A modified EPMC specialist helmet, with a built-in visor and HUD to access electronics and receive tactical information. It doesn't appear to serve many purposes in Biesel"
	icon = 'icons/obj/custom_items/oscar_helmet.dmi'
	icon_state = "oscar_helmet"
	item_state = "oscar_helmet"
	contained_sprite = TRUE
	var/online = FALSE

/obj/item/clothing/head/helmet/fluff/oscar_helmet/attack_self(mob/user)
	online= !online
	if(online)
		to_chat(user, "<span class='notice'>You turn \the [src] on.</span>")
	else
		to_chat(user, "<span class='notice'>You turn \the [src] off.</span>")

	update_icon()
	user.update_inv_head()

/obj/item/clothing/head/helmet/fluff/oscar_helmet/update_icon()
	if(online)
		icon_state = "oscar_helmet_active"
		item_state = "oscar_helmet_active"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)


/obj/item/storage/fancy/fluff/sentiment_bouquet //Bouquet of Chrysanthemums - IRU-Sentiment - niennab
	name = "bouquet of chrysanthemums"
	desc = "A bouquet of white artificial chrysanthemum flowers wrapped in a sheet of newsprint."
	icon = 'icons/obj/custom_items/sentiment_bouquet.dmi'
	icon_state = "sentiment_bouquet"
	item_state = "sentiment_bouquet"
	can_hold = list(/obj/item/clothing/accessory/fluff/sentiment_flower)
	starts_with = list(/obj/item/clothing/accessory/fluff/sentiment_flower = 6)
	storage_slots = 6
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/gloves.ogg'
	use_sound = 'sound/items/drop/paper.ogg'

/obj/item/storage/fancy/fluff/sentiment_bouquet/fill()
	. = ..()
	update_icon()

/obj/item/storage/fancy/fluff/sentiment_bouquet/update_icon()
	icon_state = "[initial(icon_state)]_[contents.len]"
	if(contents.len)
		item_state = initial(item_state)
	else
		item_state = "[initial(item_state)]_e"

/obj/item/clothing/accessory/fluff/sentiment_flower //Artificial Chrysanthemum - IRU-Sentiment - niennab
	name = "artificial chrysanthemum"
	desc = "An artificial white chrysanthemum flower."
	icon = 'icons/obj/custom_items/sentiment_bouquet.dmi'
	icon_state = "sentiment_flower"
	item_state = "sentiment_flower"
	contained_sprite = TRUE


/obj/item/clothing/head/welding/fluff/ioraks_mask //Iorakian Welding Mask - Kuhserze Ioraks - geeves
	name = "iorakian welding mask"
	desc = "A modified version of the standard issue NanoTrasen Engineering Corps welding mask, hand-painted into the colours of the Ioraks clan. Various alterations are clearly \
	visible, including a darkened visor and refitted straps to keep the mask in place. On the inner side there is an ingraving of the Ioraks clan emblem, an open splayed hand with \
	its palm facing the observer."
	icon = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_state = "ioraks_mask"
	item_state = "ioraks_mask"
	contained_sprite = TRUE

/obj/item/storage/box/fluff/ioraks_armbands //Delegation Armbands - Kuhserze Ioraks - geeves
	name = "delegation armbands box"
	desc = "A box full of team coloured armbands. It has a small picture of an Unathi's face misprinted on it."
	icon = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_state = "ioraks_armbands"
	item_state = "ioraks_armbands"
	can_hold = list(/obj/item/clothing/accessory/armband/fluff/ioraks_armband)
	starts_with = list(/obj/item/clothing/accessory/armband/fluff/ioraks_armband = 4, /obj/item/clothing/accessory/armband/fluff/ioraks_armband/alt = 4)
	storage_slots = 8

/obj/item/clothing/accessory/armband/fluff/ioraks_armband
	name = "azszau armband"
	desc = " A quite comfortable armband denoting its wearer as a member of the Azszau team. In fine print on the in-line of the fabric, it has \"The Skilled Hands\" worked into it."
	icon = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_state = "ioraks_armband"
	item_state = "ioraks_armband"
	contained_sprite = TRUE

/obj/item/clothing/accessory/armband/fluff/ioraks_armband/alt
	name = "kutzis armband"
	desc = "A quite comfortable armband denoting its wearer as a member of the Kutzis team. In fine print on the in-line of the fabric, it has \"The Bright Minds\" worked into it."
	icon = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_state = "ioraks_armband2"
	item_state = "ioraks_armband2"


/obj/item/clothing/accessory/poncho/fluff/solozel_mantle //Maraziite Throw Over - Kasluul Solozel - paradoxspace
	name = "maraziite throw over"
	desc = "It's a grey poncho, exclusively donned by the members of the Maraziite Order. This one has a Izweski Hegemony flag boldly sewn onto the shoulder."
	icon = 'icons/obj/custom_items/solozel_items.dmi'
	icon_state = "solozel_mantle"
	item_state = "solozel_mantle"
	contained_sprite = TRUE
	icon_override = FALSE

/obj/item/clothing/mask/fluff/solozel_mask //Iron Mask - Kasluul Solozel - paradoxspace
	name = "iron mask"
	desc = "It's a painted mask of white cast iron, decorated with two massive Hegeranzi horns. This is a slightly older design, worn by the members of the Maraziite Order; used to strike fear into the hearts of heretics."
	icon = 'icons/obj/custom_items/solozel_items.dmi'
	icon_state = "solozel_mask"
	item_state = "solozel_mask"
	contained_sprite = TRUE
	flags_inv = HIDEEARS|HIDEFACE
	body_parts_covered = FACE
	w_class = 3.0


/obj/item/cane/fluff/suul_staff //Akhanzi Staff - Suul Akhandi - herpetophilia
	name = "akhanzi staff"
	desc = "A staff usually carried by shamans of the Akhanzi Order. It is made out of dark, polished wood and is curved at the end."
	icon = 'icons/obj/custom_items/suul_staff.dmi'
	icon_state = "suul_staff"
	item_state = "suul_staff"
	slot_flags = SLOT_BACK
	contained_sprite = TRUE
	w_class = 4

/obj/item/cane/fluff/suul_staff/afterattack(atom/A, mob/user as mob, proximity)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!proximity)
		return
	if (istype(A, /turf/simulated/floor))
		user.visible_message("<span class='notice'>[user] loudly taps their [src.name] against the floor.</span>")
		playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
		return


/obj/item/clothing/accessory/sweater/fluff/cress_sweater //Star Sweater - Emily Cress - mattatlas
	name = "star sweater"
	desc = "An army green sweater. It looks well cared for and contains a star on the front, near the neck. To those familiar with it, the star is the same symbol as one of the nation alliances' logos in Earth's history."
	icon = 'icons/obj/custom_items/cress_items.dmi'
	icon_state = "cress_sweater"
	item_state = "cress_sweater"
	contained_sprite = TRUE

/obj/item/fluff/cress_book //Lyric Book - Emily Cress - mattatlas
	name = "lyric book"
	desc = "An old, faded folder containing various alphabetically organized lyrics of several songs, including musical sheets for guitars. A dark purple H is scribbled on the center, along with half a heart on the \
	left and a cut on the bottom right. The lyrics inside have two copies each: one in Sol Common and one in Tau Ceti Basic. It generally looks to be hard rock."
	icon = 'icons/obj/custom_items/cress_items.dmi'
	icon_state = "cress_book"
	w_class = 2
	var/list/lyrics = list("Falling Down: A song about holding on to the last glimmer of hope. It's generally pretty motivational. The most recent song of the three.",
							"Say Something New: A morose song about companionship, and being unable to continue without an undescribed dear friend. Morose, but overall motivational.",
							"One By One: A song telling an undescribed person to 'give it another try'. It seems to mostly about reconciliation and accepting failure. More somber than the others, and the most dated.")

/obj/item/fluff/cress_book/attack_self(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message("<span class='notice'>[user] begins searching through \the [src] pages.</span>")
	if(do_after(user, 25))
		to_chat(user, "<span class='notice'>You read on the pages of \the [src]: [pick(lyrics)]</span>")


/obj/item/modular_computer/laptop/fluff/harrow_laptop //Developer's Laptop - Danny Harrow - brainos
	name = "developer's laptop"
	anchored = FALSE
	screen_on = FALSE
	icon_state = "laptop-closed"
	desc = "A portable computer, this one is covered edge-to-edge in stickers. Some stand out; such ones from a 2458 Game Jam, 2459 Game Jam and various title logos from obscure holovid series. Printed on the bottom panel \
	is \"Hello, world!\" in a bright, monospace font."
	icon = 'icons/obj/custom_items/harrow_laptop.dmi'

/obj/item/modular_computer/laptop/fluff/harrow_laptop/install_default_hardware()
	..()
	processor_unit = new /obj/item/computer_hardware/processor_unit(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	battery_module = new /obj/item/computer_hardware/battery_module(src)
	battery_module.charge_to_full()
	nano_printer = new /obj/item/computer_hardware/nano_printer(src)
	nano_printer.max_paper = 10
	nano_printer.stored_paper = 5


/obj/item/clothing/accessory/poncho/fluff/ozuha_cape //Victory Cape - Skavoss Ozuha - dronzthewolf
	name = "victory cape"
	desc = "A finely crafted cape that combines Ozuha clan colors and Izweski nation colors, with inscriptions on the decorative brass paldrons reading something in Sinta'Unathi."
	icon = 'icons/obj/custom_items/ozuha_cape.dmi'
	icon_state = "ozuha_cape"
	item_state = "ozuha_cape"
	contained_sprite = TRUE
	icon_override = FALSE


/obj/item/clothing/suit/storage/fluff/ulmari_coat //Aut'akh Medical Coat - Optikam Ulmari - soultheif96
	name = "aut'akh medical coat"
	desc = "A custom-made tailored coat for use in a laboratory/medical setting."
	icon = 'icons/obj/custom_items/ulmari_coat.dmi'
	icon_state = "ulmari_coat"
	item_state = "ulmari_coat"
	contained_sprite = TRUE