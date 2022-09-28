/// Aurora custom items ///
/*basic guidelines:
Custom items must be accepted at some point in the forums by the staff handling them.
Add custom items to this file, their sprites into their own dmi. in the icons/obj/custom_items.
All custom items with worn sprites must follow the contained sprite system: http://forums.aurorastation.org/viewtopic.php?f=23&t=6798
*/

/obj/item/clothing/head/fluff/ziva_bandana //Ziva's Bandana - Ziva Ta'Kim - sierrakomodo
	name = "old bandana"
	desc = "An old orange-ish-yellow bandana. It has a few stains from engine grease, and the color has been dulled."
	icon = 'icons/obj/custom_items/motaki_bandana.dmi'
	icon_override = 'icons/obj/custom_items/motaki_bandana.dmi'
	icon_state = "motaki_bandana"
	item_state = "motaki_bandana"
	contained_sprite = TRUE


/obj/item/clothing/suit/armor/vest/fluff/zubari_jacket //Fancy Jacket - Zubari Akenzua - filthyfrankster
	name = "fancy jacket"
	desc = "A well tailored unathi styled armored jacket, fitted for one too."
	icon = 'icons/obj/custom_items/zubari_jacket.dmi'
	icon_override = 'icons/obj/custom_items/zubari_jacket.dmi'
	icon_state = "zubari_jacket"
	item_state = "zubari_jacket"
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


/obj/item/clothing/suit/fluff/centurion_cloak //Paludamentum - Centurion - cakeisossim
	name = "paludamentum"
	desc = "A cloak-like piece of silky, red fabric. Fashioned at one point where the shoulder would be with a golden pin."
	icon = 'icons/obj/custom_items/centurion_cloak.dmi'
	icon_override = 'icons/obj/custom_items/centurion_cloak.dmi'
	icon_state = "centurion_cloak"
	item_state = "centurion_cloak"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	contained_sprite = TRUE


/obj/item/clothing/accessory/badge/fluff/dylan_tags //Dog Tags - Dylan Sutton - catnippy
	name = "dog tags"
	desc = "Some black dog tags, engraved on them is the following: \"Wright, Dylan L, O POS, Pacific Union Special Forces\"."
	icon = 'icons/obj/custom_items/dylan_tags.dmi'
	icon_override = 'icons/obj/custom_items/dylan_tags.dmi'
	icon_state = "dylan_tags"
	item_state = "dylan_tags"
	stored_name = "Wright, Dylan L"
	badge_string = "Pacific Union Special Forces"
	contained_sprite = TRUE
	slot_flags = SLOT_MASK | SLOT_TIE


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
	icon_override = 'icons/obj/custom_items/caleb_badge.dmi'
	item_state = "caleb_badge"
	icon_state = "caleb_badge"
	stored_name = "Caleb Greene"
	badge_string = "NOS Apollo Head of Security"
	contained_sprite = TRUE


/obj/item/sign/fluff/iskanz_atimono //Framed Zatimono - Iskanz Sal'Dans - zundy
	name = "framed zatimono"
	desc = "A framed Zatimono, a Unathi standard worn into battle similar to an old-Earth Sashimono. This one seems well maintained and carries Sk'akh Warrior Priest markings and litanies."
	icon_state = "iskanz_atimono"
	sign_state = "iskanz_atimono"
	w_class = ITEMSIZE_SMALL


/obj/item/clothing/under/fluff/ana_uniform //Retired Uniform - Ana Roh'hi'tin - suethecake
	name = "retired uniform"
	desc = "A silken blouse paired with dark-colored slacks. It has the words \"Chief Investigator\" embroidered into the shoulder bar."
	icon = 'icons/obj/custom_items/ana_clothing.dmi'
	icon_override = 'icons/obj/custom_items/ana_clothing.dmi'
	icon_state = "ana_uniform"
	item_state = "ana_uniform"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/forensics/fluff/ana_jacket //CSI Jacket - Ana Roh'hi'tin - suethecake
	name = "CSI jacket"
	desc = "A black jacket with the words \"CSI\" printed in the back in bright, white letters."
	icon = 'icons/obj/custom_items/ana_clothing.dmi'
	icon_override = 'icons/obj/custom_items/ana_clothing.dmi'
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
	icon_override = 'icons/obj/custom_items/ikrad_beret.dmi'
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
	icon_override = 'icons/obj/custom_items/ikrad_beret.dmi'
	icon_state = "ikrad_letter"
	w_class = ITEMSIZE_SMALL

/obj/item/clothing/suit/storage/toggle/fluff/ryan_jacket //Mars' Militia Leather Jacket - Ryan McLean - seniorscore
	name = "mars militia leather jacket"
	desc = "A leather jacket, appears to have a shield on back with the words \"Contra omnes stabimus\", as well as a unit name \"Sandworms of Thadeus\", \
	stitched along a banner at the bottom of the shield."
	icon = 'icons/obj/custom_items/ryan_jacket.dmi'
	icon_override = 'icons/obj/custom_items/ryan_jacket.dmi'
	icon_state = "ryan_jacket"
	item_state = "ryan_jacket"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/fluff/yuri_duster //Martian Duster - Yuri Daruski - bv1000
	name = "martian duster"
	desc = "A longer coat made of a tough fabric designed to protect the wearer from the harshness of the Mars badlands \
	found beyond the terraformed areas of said planet. Two scorched holes can be found on the lower back, and three non-scorched holes \
	appear in the upper torso on the back, with two lining up with two in the front."
	icon = 'icons/obj/custom_items/yuri_duster.dmi'
	icon_override = 'icons/obj/custom_items/yuri_duster.dmi'
	icon_state = "yuri_duster"
	item_state = "yuri_duster"
	contained_sprite = TRUE


/obj/item/clothing/under/fluff/faysal_uniform //Old Tajaran Nobleman Suit - Faysal Al-Shennawi - alberyk
	name = "old tajaran nobleman suit"
	desc = "A fancy looking suit, made of white line, adorned with golden details and buttons bearing long forgotten meanings. A blue sash decorates this piece of clothing."
	icon = 'icons/obj/custom_items/faysal_uniform.dmi'
	icon_override = 'icons/obj/custom_items/faysal_uniform.dmi'
	icon_state = "faysal_uniform"
	item_state = "faysal_uniform"
	contained_sprite = TRUE


/obj/item/clothing/glasses/welding/fluff/ghoz_eyes //Prosthetic Vaurca Eyelids - Ka'Akaix'Ghoz Zo'ra - sleepywolf
	name = "prosthetic vaurca eyelids"
	desc = "A small contraption of micro-actuators with a button on the side."
	icon = 'icons/obj/custom_items/ghoz_eyes.dmi'
	icon_override = 'icons/obj/custom_items/ghoz_eyes.dmi'
	icon_state = "ghoz_eyes"
	item_state = "ghoz_eyes"
	contained_sprite = TRUE
	action_button_name = "Toggle Eyelids"
	species_restricted = list(BODYTYPE_VAURCA) //i think this would make sense since those are some kind of vaurca build prothestic


/obj/item/clothing/head/det/fluff/leo_hat //Tagged brown hat - Leo Wyatt - keinto
	name = "tagged brown hat"
	desc = "A worn mid 20th century brown hat. If you look closely at the back, you can see a an embedded tag from the \"Museum of Terran Culture and Technology\"."
	icon = 'icons/obj/custom_items/leo_coat.dmi'
	icon_override = 'icons/obj/custom_items/leo_coat.dmi'
	icon_state = "leo_hat"
	item_state = "leo_hat"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/det_trench/fluff/leo_coat //Tagged brown coat - Leo Wyatt - keinto
	name = "tagged brown coat"
	desc = "A worn mid 20th century brown trenchcoat. If you look closely at bottom of the back, you can see an embedded tag from the \"Museum of Terran Culture and Technology\"."
	icon = 'icons/obj/custom_items/leo_coat.dmi'
	icon_override = 'icons/obj/custom_items/leo_coat.dmi'
	icon_state = "leo_coat"
	item_state = "leo_coat"
	contained_sprite = TRUE


/obj/item/toy/plushie/fluff/oz_plushie //Mr. Monkey - Oz Auman - theiguanaman2
	name = "\improper Mr.Monkey"
	desc = "A calming toy monkey."
	icon = 'icons/obj/custom_items/oz_plushie.dmi'
	icon_override = 'icons/obj/custom_items/oz_plushie.dmi'
	icon_state = "oz_plushie"


/obj/item/reagent_containers/food/drinks/teapot/fluff/brianne_teapot //Ceramic Teapot - Sean Brianne - zelmana
	name = "ceramic teapot"
	desc = "A blue ceramic teapot, gilded with the abbreviation for NanoTrasen."
	icon = 'icons/obj/custom_items/brianne_teapot.dmi'
	icon_override = 'icons/obj/custom_items/brianne_teapot.dmi'
	icon_state = "brianne_teapot"


/obj/item/clothing/head/beret/engineering/fluff/make_beret //Tan Engineering Beret - M.A.K.E - toasterstrudes
	name = "tan engineering beret"
	desc = "An engineering beret that appears to have been dyed tan, with an orange patch sewn into the middle of it."
	icon = 'icons/obj/custom_items/make_items.dmi'
	icon_override = 'icons/obj/custom_items/make_items.dmi'
	icon_state = "make_beret"
	item_state = "make_beret"
	contained_sprite = TRUE


/obj/item/clothing/mask/fluff/corvo_cigarette //Vaporizer Pen - Nathan Corvo - jkjudgex
	name = "vaporizer pen"
	desc = "A simple vaporizer pen, the electronic version of the cigarette."
	icon = 'icons/obj/custom_items/corvo_cigarette.dmi'
	icon_override = 'icons/obj/custom_items/corvo_cigarette.dmi'
	icon_state = "corvo_cigarette"
	item_state = "corvo_cigarette"
	body_parts_covered = 0
	w_class = ITEMSIZE_SMALL
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



/obj/item/clothing/suit/storage/fluff/sonorous_mantle //Maraziite Throw Over - Sonorous Zouzoror - sleepywolf
	name = "maraziite throw over"
	desc = "A grey poncho, exclusively warn by members of the Maraziite Order. This one has the flag of the Izweski Hegemony stitched on."
	icon = 'icons/obj/custom_items/sonorous_clothing.dmi'
	icon_override = 'icons/obj/custom_items/sonorous_clothing.dmi'
	icon_state = "sonorous_mantle"
	item_state = "sonorous_mantle"
	contained_sprite = TRUE

/obj/item/clothing/mask/fluff/sonorous_mask //Iron Mask - Sonorous Zouzoror - sleepywolf
	name = "iron mask"
	desc = "A mask made of iron worn by members of the Maraziite Order. This one looks like it's modeled after a fish."
	icon = 'icons/obj/custom_items/sonorous_clothing.dmi'
	icon_override = 'icons/obj/custom_items/sonorous_clothing.dmi'
	icon_state = "sonorous_mask"
	item_state = "sonorous_mask"
	contained_sprite = TRUE
	flags_inv = HIDEEARS|HIDEFACE
	body_parts_covered = FACE
	w_class = ITEMSIZE_NORMAL


/obj/item/clothing/under/fluff/ellie_uniform //Cheery Blazer - Ellie Shoshanna - resilynn
	name = "cheery blazer"
	desc = "A cheery but professional outfit, mauve corduroys, blue blazer and a tie."
	icon = 'icons/obj/custom_items/ellie_uniform.dmi'
	icon_override = 'icons/obj/custom_items/ellie_uniform.dmi'
	icon_state = "ellie_uniform"
	item_state = "ellie_uniform"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/fluff/vira_coat //Designer Military Coat - Vira Bolivar - scheveningen
	name = "designer military coat"
	desc = "A dark funnel neck designer military-style dress coat, specially fitted on commission, clearly designed for a woman's figure. \
	A skillfully stitched 'NT' pattern is laden above a chest pocket, the phrase \"15 years of loyal service to the Corp\" below the insignia, followed by the personal signature of \"Vira Bolivar Taryk\"."
	icon = 'icons/obj/custom_items/vira_coat.dmi'
	icon_override = 'icons/obj/custom_items/vira_coat.dmi'
	icon_state = "vira_coat"
	item_state = "vira_coat"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/fluff/azala_coat //Azala's Gentleman's Coat - Azala Huz'kai - tomiixstarslasher
	name = "gentleman's coat"
	desc = "A blue gentleman's coat. It is very stylish, and appears to be very warm."
	icon = 'icons/obj/custom_items/azala_items.dmi'
	icon_override = 'icons/obj/custom_items/azala_items.dmi'
	icon_state = "azala_coat"
	item_state = "azala_coat"
	contained_sprite = TRUE

/obj/item/clothing/head/fluff/azala_hat //Azala's Gentleman's Cap - Azala Huz'kai - tomiixstarslasher
	name = "gentleman's cap"
	desc = "A blue gentleman's cap. It is very stylish, and appears to be warped from being worn crooked."
	icon = 'icons/obj/custom_items/azala_items.dmi'
	icon_override = 'icons/obj/custom_items/azala_items.dmi'
	icon_state = "azala_hat"
	item_state = "azala_hat"
	contained_sprite = TRUE

/obj/item/clothing/under/fluff/azala_jumpsuit //Azala's Roboticist Jumpsuit - Azala Huz'kai - tomiixstarslasher
	name = "modified roboticist jumpsuit"
	desc = "A variation of the roboticists jumpsuit, this one is in blue colors."
	icon = 'icons/obj/custom_items/azala_items.dmi'
	icon_override = 'icons/obj/custom_items/azala_items.dmi'
	icon_state = "azala_jumpsuit"
	item_state = "azala_jumpsuit"
	contained_sprite = TRUE


/obj/item/clothing/suit/fluff/leo_scarf //Scarf - Leo Wyatt - keinto
	name = "striped scarf"
	desc = "A soft scarf striped in black and blue."
	icon = 'icons/obj/custom_items/leo_scarf.dmi'
	icon_override = 'icons/obj/custom_items/leo_scarf.dmi'
	icon_state = "leo_scarf"
	item_state = "leo_scarf"
	contained_sprite = TRUE


/obj/item/clothing/under/fluff/zilosnish_uniform //Exotic Purple Robe - Zilosnish Szu - sleepywolf
	name = "exotic purple robe"
	desc = "An extravagant display of wealth, hand-tailored with Unathi craftmanship. There are intricate designs of hammers, cactus flowers, and coins etched into the cloth."
	icon = 'icons/obj/custom_items/zilosnish_items.dmi'
	icon_override = 'icons/obj/custom_items/zilosnish_items.dmi'
	icon_state = "zilosnish_uniform"
	item_state = "zilosnish_uniform"
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/unathimantle/fluff/zilosnish_mantle //Exotic Mantle - Zilosnish Szu - sleepywolf
	name = "exotic mantle"
	desc = "A red hide with a gold and jade insignia pin to keep it on a wearers shoulders. The hide is thick, like rhino skin."
	icon = 'icons/obj/custom_items/zilosnish_items.dmi'
	icon_override = 'icons/obj/custom_items/zilosnish_items.dmi'
	icon_state = "zilosnish_mantle"
	item_state = "zilosnish_mantle"
	contained_sprite = TRUE

/obj/item/pen/fluff/zilosnish_pen //Golden Pen - Zilosnish Szu - sleepywolf
	name = "golden pen"
	desc = "A pen plated in gold. It has black ink."
	icon = 'icons/obj/custom_items/zilosnish_items.dmi'
	icon_override = 'icons/obj/custom_items/zilosnish_items.dmi'
	icon_state = "zilosnish_pen"


/obj/item/clothing/head/fluff/qorja_headband //Rebellious Headband - Q'orja Sak'ha - fortport
	name = "rebellious headband"
	desc = "A comfortable headband made from a long, soft cloth that's tied into a knot in the back. It is a bright shade of red, slipped through a decorative brass plate. \
	Upon the metal is an engraving of the People's Republic of Adhomai's insignia, as if straight from their flag."
	icon = 'icons/obj/custom_items/qorja_headband.dmi'
	icon_override = 'icons/obj/custom_items/qorja_headband.dmi'
	icon_state = "qorja_headband"
	item_state = "qorja_headband"
	contained_sprite = TRUE


/obj/item/clothing/wrists/watch/fluff/rex_watch //Engraved Wristwatch - Rex Winters - tailson
	name = "engraved wristwatch"
	desc = "A fine gold watch. On the inside is an engraving that reads \"Happy birthday dad, thinking of you always\"."
	icon = 'icons/obj/custom_items/rex_watch.dmi'
	icon_override = 'icons/obj/custom_items/rex_watch.dmi'
	icon_state = "rex_watch"


/obj/item/device/camera/fluff/hadley_camera //Hadley's Camera - Hadley Dawson - fekkor
	name = "customized camera"
	desc = "A early 2450's Sunny camera with an adjustable lens, this one has a sticker with the name \"Hadley\" on the back."
	icon = 'icons/obj/custom_items/hadley_camera.dmi'
	icon_override = 'icons/obj/custom_items/hadley_camera.dmi'
	icon_state = "hadley_camera"
	icon_on = "hadley_camera"
	icon_off = "hadley_camera_off"


/obj/item/folder/fluff/sukhoi_folder //Inventor's Notebook - Natascha Sukhoi - lancelynxx
	name = "inventor's notebook"
	desc = "A dark-green notebook, with crumpled Post-Its sticking out and binding tearing at the edges. It reeks of DromedaryCo cigarettes. The words \"SUKH SYSTEMS\" are scribbled on the cover with a black sharpie."
	icon = 'icons/obj/custom_items/sukhoi_folder.dmi'
	icon_override = 'icons/obj/custom_items/sukhoi_folder.dmi'
	icon_state = "sukhoi_folder"


/obj/item/clothing/suit/storage/toggle/det_trench/fluff/nelson_jacket //Armored Detective Jacket - Nelson Okafor - seniorscore
	name = "armored detective jacket"
	desc = "A white suit jacket, has a badge hanging out of a breast pocket. Touching it gives a feeling of working on a case for months."
	icon = 'icons/obj/custom_items/nelson_jacket.dmi'
	icon_override = 'icons/obj/custom_items/nelson_jacket.dmi'
	icon_state = "nelson_jacket"
	item_state = "nelson_jacket"
	contained_sprite = TRUE


/obj/item/clothing/head/beret/fluff/chunley_beret //Sol's Dog Handler Beret - Freya Chunley - thesmiley
	name = "sol's dog handler beret"
	desc = "A scarlet military beret worn by the Sol Alliance Military Police dog handling unit. The symbol on the cap is that of a grey wolf's head on white. It quivers menacingly. \
	Upon flipping it you see a name tag with the word \"CHUNLEY\" written in on it with a very sloppy hand write."
	icon = 'icons/obj/custom_items/chunley_beret.dmi'
	icon_override = 'icons/obj/custom_items/chunley_beret.dmi'
	icon_state = "chunley_beret"
	item_state = "chunley_beret"
	contained_sprite = TRUE


/obj/item/material/knife/fluff/yumi_knife //Cutting Metal - Yumi Yotin - trickingtrapster
	name = "cutting metal"
	desc = "Looks like a piece of sheet metal, sharpened on one end."
	icon = 'icons/obj/custom_items/yotin_knife.dmi'
	icon_override = 'icons/obj/custom_items/yotin_knife.dmi'
	icon_state = "yotin_knife"


/obj/item/clothing/accessory/holster/thigh/fluff/rifler_holster //Rifler's Holster - Sophie Rifler - shodan43893
	name = "tan leather thigh holster"
	desc = "A version of the security thigh holster done up in tan leather - this one appears to have the word \"Rifler\" engraved down the side. It appears to be rather well made and hard wearing; more of a worker's holster than a show piece."
	icon = 'icons/obj/custom_items/rifler_holster.dmi'
	icon_override = 'icons/obj/custom_items/rifler_holster.dmi'
	icon_state = "rifler_holster"
	contained_sprite = TRUE


/obj/item/storage/backpack/satchel/fluff/xerius_bag //Tote Bag - Shiur'izzi Xerius - witchebells
	name = "tote bag"
	desc = "A sackcloth bag with an image of Moghes printed onto it. Floating above the planet are the words \"Save Moghes!\"."
	icon = 'icons/obj/custom_items/xerius_bag.dmi'
	icon_override = 'icons/obj/custom_items/xerius_bag.dmi'
	icon_state = "xerius_bag"
	item_state = "xerius_bag"
	contained_sprite = TRUE


/obj/item/clothing/accessory/poncho/fluff/make_poncho //Raincoat Poncho - M.A.K.E - toasterstrudes
	name = "raincoat poncho"
	desc = "A tough brown hooded poncho that looks to be good at protecting someone from the rain."
	icon = 'icons/obj/custom_items/make_items.dmi'
	icon_override = 'icons/obj/custom_items/make_items.dmi'
	icon_state = "make_poncho"
	item_state = "make_poncho"
	contained_sprite = TRUE


/obj/item/clothing/under/fluff/aegis_uniform //Hephaestus Experimental Projector - Sovereign Aegis - itanimulli
	name = "Hephaestus experimental projector"
	desc = "An odd device connected to a security uniform, apparently still in the prototype stage."
	icon = 'icons/obj/custom_items/aegis_uniform.dmi'
	icon_override = 'icons/obj/custom_items/aegis_uniform.dmi'
	icon_state = "aegis_uniform"
	item_state = "aegis_uniform"
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_IPC_INDUSTRIAL)


/obj/item/clothing/mask/fluff/ird_mask //Titanium Faceplate - IRD - kyres1
	name = "titanium faceplate"
	desc = "An odd mask seeming to mimic the face of a Human with some artistic liberties taken. Small lights keep it dimly illuminated from within with holographic projectors emulating two bright blue eyes.  \
	Its rigid frame is composed of what looks like polished titanium."
	icon = 'icons/obj/custom_items/ird_face.dmi'
	icon_override = 'icons/obj/custom_items/ird_face.dmi'
	icon_state = "ird_mask"
	item_state = "ird_mask"
	contained_sprite = TRUE
	flags_inv = HIDEEARS|HIDEFACE
	body_parts_covered = FACE
	w_class = ITEMSIZE_NORMAL


/obj/item/stack/dice/fluff/baron_dice //BARON's Dice - BARON - iamcrystalclear
	weight_roll = 70
	favored_number = 2


/obj/item/flame/lighter/zippo/fluff/nikit_zippo //Vasili Mine Zippo - Nikit Vasili - simontheminer
	desc = "An old looking zippo lighter with Vasili Mine Logo engraved on it. \"Good Luck Nikit\" is crudely scratched on under the logo in small writing."
	icon = 'icons/obj/custom_items/nikit_zippo.dmi'
	icon_override = 'icons/obj/custom_items/nikit_zippo.dmi'
	icon_state = "nikit_zippo"


/obj/item/clothing/accessory/locket/fluff/klavdiya_amulet //Moon Shaped Amulet - Klavdiya Tikhomirov - alberyk
	name = "moon shaped amulet"
	desc = "A metalic necklace that bears a silver moon shapped pendant."
	icon = 'icons/obj/custom_items/klavdiya_amulet.dmi'
	icon_override = 'icons/obj/custom_items/klavdiya_amulet.dmi'
	icon_state = "klavdiya_amulet"
	contained_sprite = TRUE


/obj/item/storage/fluff/sovno_carrier //Reinforced Cat Carrier - Anabelle Sovno - pratepresidenten
	name = "cat carrier"
	desc = "It appears to be a reinforced cat carrier. Decals of hearts and kittens are plastered all over its sides."
	icon = 'icons/obj/custom_items/sovno_carrier.dmi'
	icon_override = 'icons/obj/custom_items/sovno_carrier.dmi'
	icon_state = "sovno_carrier"
	item_state = "sovno_carrier"
	contained_sprite = TRUE
	w_class = ITEMSIZE_LARGE
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
	icon_override = 'icons/obj/custom_items/talon_coat.dmi'
	icon_state = "talon_coat"
	item_state = "talon_coat"
	contained_sprite = TRUE


/obj/item/storage/backpack/cloak/fluff/ryn_cloak //Security Tunnel Cloak - Za'Akaix'Ryn Zo'ra - jamchop23334
	name = "security tunnel cloak"
	desc = "A blue, tailor-made tunnel cloak with paltry storage options. The fabric is smoother and less abrasive than regular tunnel cloaks, though it looks difficult to wear."
	icon = 'icons/obj/custom_items/ryn_clothing.dmi'
	icon_override = 'icons/obj/custom_items/ryn_clothing.dmi'
	icon_state = "ryn_cloak"
	item_state = "ryn_cloak"
	contained_sprite = TRUE

/obj/item/clothing/head/fluff/ryn_hood //Security Tunnel Hood - Za'Akaix'Ryn Zo'ra - jamchop23334
	name = "security tunnel hood"
	desc = "A silky smooth blue hood, though its more of a headwrap. You're having a hard time wrapping your head around how to wear this."
	icon = 'icons/obj/custom_items/ryn_clothing.dmi'
	icon_override = 'icons/obj/custom_items/ryn_clothing.dmi'
	icon_state = "ryn_hood"
	item_state = "ryn_hood"
	contained_sprite = TRUE


/obj/item/sign/fluff/tokash_sign //Shark Jaw Trophy - Suvek Tokash - evandorf
	name = "shark jaw trophy"
	desc = "A pair of jaws from what must have been a large and impressive shark."
	icon_state = "tokash_sign"
	sign_state = "tokash_sign"
	w_class = ITEMSIZE_SMALL


/obj/item/clothing/glasses/threedglasses/fluff/grunnus_glasses //3D glasses - Paul Grunnus - moom241
	desc = "A pair of old, beat up looking glasses, with red and blue lenses. Pretty archaic, but some might call it fashionable."
	icon = 'icons/obj/custom_items/grunnus_glasses.dmi'
	icon_override = 'icons/obj/custom_items/grunnus_glasses.dmi'
	icon_state = "grunnus_glasses"
	item_state = "grunnus_glasses"
	contained_sprite = TRUE


/obj/item/clothing/head/fluff/aavs_mask //Reflective Mask - Aavs Guwan - dronzthewolf
	name = "reflective mask"
	desc = "This odd mask and hood combination covers the wearer, and seems to be made of a one-way dome mirror and some old cloth or rope."
	icon = 'icons/obj/custom_items/aavs_mask.dmi'
	icon_override = 'icons/obj/custom_items/aavs_mask.dmi'
	icon_state = "aavs_mask"
	item_state = "aavs_mask"
	contained_sprite = TRUE
	flags_inv = HIDEEARS|HIDEFACE|BLOCKHAIR|BLOCKHEADHAIR
	body_parts_covered = HEAD|FACE|EYES


/obj/item/clothing/under/fluff/mira_uniform //Mira's Cloth Undersuit - Mira Akhandi - ladyfowl
	name = "dark clothes"
	desc = "A set of dark under clothing, loosely fitting. The initials /M.A./ are stitched into the collar."
	icon = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_override = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_state = "mira_uniform"
	item_state = "mira_uniform"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/labcoat/fluff/mira_robes //Junior Alchemist Robes - Mira Akhandi - ladyfowl
	name = "junior alchemist robes"
	desc = "A  robe with a light silky gold colored belt around the waist. Placed upon the print is two red jewels pinned to it neatly."
	icon = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_override = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_state = "mira_robes"
	item_state = "mira_robes"

/obj/item/clothing/shoes/fluff/mira_boots //Mira Boots - Mira Akhandi - ladyfowl
	name = "dark boots"
	desc = "A pair of black boots with tall laces."
	icon = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_override = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_state = "mira_boots"
	item_state = "mira_boots"
	contained_sprite = TRUE

/obj/item/clothing/under/fluff/mira_skirt //Mira's Skirt - Mira Akhandi - ladyfowl
	name = "suspended skirt"
	desc = "A plaid skirt with suspenders, sewed into the side is the initials \"M.A.\"."
	icon = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_override = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_state = "mira_skirt"
	item_state = "mira_skirt"
	contained_sprite = TRUE

/obj/item/reagent_containers/glass/beaker/fluff/mira_beaker //Alchemist Flask - Mira Akhandi - ladyfowl
	name = "alchemist flask"
	desc = "A large bottle used to mix chemicals inside."
	icon = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_override = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_state = "mira_beaker"

/obj/item/storage/backpack/fluff/mira_bag //Burlap Alchemist Bag - Mira Akhandi - ladyfowl
	name = "burlap bag"
	desc = "A smallish burlup sack, modified to lug around belongings. Stiched into it is the letters '\"M.A.\"."
	icon_state = "giftbag0"
	item_state = "giftbag0"

/obj/item/clothing/suit/fluff/mira_vest //Cut-off Vest - Mira Akhandi - ladyfowl
	name = "cut-off vest"
	desc = "A short grey puffer vest."
	icon = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_override = 'icons/obj/custom_items/mira_clothing.dmi'
	icon_state = "mira_vest"
	item_state = "mira_vest"
	contained_sprite = TRUE

/obj/item/cane/fluff/qrqil_cane //Energy Cane - Qrqil Qrrzix - yonnimer
	name = "energy cane"
	desc = "This silver-handled cane has letters carved into the sides."
	icon = 'icons/obj/custom_items/qrqil_cane.dmi'
	icon_override = 'icons/obj/custom_items/qrqil_cane.dmi'
	icon_state = "qrqil_cane"
	item_state = "qrqil_cane"
	contained_sprite = TRUE
	w_class = ITEMSIZE_SMALL
	var/active = FALSE

/obj/item/cane/fluff/qrqil_cane/attack_self(mob/user)
	active= !active
	if(active)
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")
		item_state = icon_state
		w_class = ITEMSIZE_LARGE
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
	icon_override = 'icons/obj/custom_items/djar_cape.dmi'
	icon_state = "djar_cape"
	item_state = "djar_cape"
	contained_sprite = TRUE


/obj/item/clothing/suit/chaplain_hoodie/fluff/hidemichi_robes //Zen Monk Robes - Yoshihama Hidemichi - dobhranthedruid
	name = "zen monk robes"
	desc = "A traditional Soto Zen buddhist robes for meditation and services"
	icon = 'icons/obj/custom_items/hidemichi_items.dmi'
	icon_override = 'icons/obj/custom_items/hidemichi_items.dmi'
	icon_state = "hidemichi_robes"
	item_state = "hidemichi_robes"
	contained_sprite = TRUE

/obj/item/clothing/head/fluff/hidemichi_hat //Takuhatsugasa - Yoshihama Hidemichi - dobhranthedruid
	name = "takuhatsugasa"
	desc = "A dome shaped rice hat, this one is dyed a darker color."
	icon = 'icons/obj/custom_items/hidemichi_items.dmi'
	icon_override = 'icons/obj/custom_items/hidemichi_items.dmi'
	icon_state = "hidemichi_hat"
	item_state = "hidemichi_hat"
	contained_sprite = TRUE


/obj/item/clothing/accessory/badge/fluff/kelt_tags //Foreign Legion Holo-Tags - Kelt - toasterstrudes
	name = "foreign legion holo-tags"
	desc = "A set of holo-tags, on them is the printed name, address, and Serial Code as well as what appears to be a bar code underneath."
	icon = 'icons/obj/custom_items/kelt_tags.dmi'
	icon_override = 'icons/obj/custom_items/kelt_tags.dmi'
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
	icon_override = 'icons/obj/custom_items/resolve_items.dmi'
	icon_state = "resolve_antennae"
	item_state = "resolve_antennae"
	contained_sprite = TRUE

/obj/item/clothing/shoes/fluff/resolve_shoes //Treads - Decisive Resolve - itanimulli
	name = "treads"
	desc = "Clip-on rubber treads, for that extra grip. Designed for an IPC."
	icon = 'icons/obj/custom_items/resolve_items.dmi'
	icon_override = 'icons/obj/custom_items/resolve_items.dmi'
	icon_state = "resolve_shoes"
	item_state = "resolve_shoes"
	contained_sprite = TRUE

/obj/item/clothing/under/fluff/resolve_uniform //Haphaestus Experimental Projector - Decisive Resolve - itanimulli
	name = "haphaestus experimental projector"
	desc = "A flashing device seemingly attached to an officer's corporate security uniform. On the side of the casing are the words: \"Brickstend\", \"Dernestess\", \"Jastovski\", and \"Finch.\""
	icon = 'icons/obj/custom_items/resolve_items.dmi'
	icon_override = 'icons/obj/custom_items/resolve_items.dmi'
	icon_state = "resolve_uniform"
	item_state = "resolve_uniform"
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/fluff/resolve_poncho //Poncho - Decisive Resolve - itanimulli
	desc = "A decorative synthleather covering. Probably isn't the best for rain. On the shoulder's edge is a small, paper tag, that reads: \"Cassidy Finch was here\" in sloppy handwriting."
	icon = 'icons/obj/custom_items/resolve_items.dmi'
	icon_override = 'icons/obj/custom_items/resolve_items.dmi'
	icon_state = "resolve_poncho"
	item_state = "resolve_poncho"
	contained_sprite = TRUE


/obj/item/fluff/tokash_spear //Ancestral Spear - Suvek Tokash - evandorf
	name = "display stand"
	desc = "A small plasteel display stand which uses magnetic fields to levitate an object."
	icon = 'icons/obj/custom_items/tokash_spear.dmi'
	icon_override = 'icons/obj/custom_items/tokash_spear.dmi'
	icon_state = "stand-spear"
	w_class = ITEMSIZE_NORMAL
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
	icon_override = 'icons/obj/custom_items/tokash_spear.dmi'
	icon_state = "spearhead"
	w_class = ITEMSIZE_SMALL


/obj/item/clothing/suit/storage/hooded/wintercoat/fluff/naomi_coat //Reishi Queen Winter Coat - Naomi Marlowe - smifboy78
	name = "reishi queen winter coat"
	desc = "A worn purple winter-coat. On the back, \"Reishi Queen\" is stitched on top of a skull patch. It reeks of reishi."
	icon = 'icons/obj/custom_items/naomi_coat.dmi'
	icon_override = 'icons/obj/custom_items/naomi_coat.dmi'
	icon_state = "naomi_coat"
	item_state = "naomi_coat"
	contained_sprite = TRUE


/obj/item/reagent_containers/glass/bucket/fluff/khasan_bucket //Battered Metal Bucket - Khasan Mikhnovsky - alberyk
	name = "battered metal bucket"
	desc = "A battered rusty metal bucket. It has seen a lot of use and little maintenance."
	icon = 'icons/obj/custom_items/khasan_bucket.dmi'
	icon_override = 'icons/obj/custom_items/khasan_bucket.dmi'
	icon_state = "khasan_bucket"
	item_state = "khasan_bucket"
	contained_sprite = TRUE
	helmet_type = /obj/item/clothing/head/helmet/bucket/fluff/khasan_bucket
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/clothing/head/helmet/bucket/fluff/khasan_bucket
	name = "battered metal bucket helmet"
	icon = 'icons/obj/custom_items/khasan_bucket.dmi'
	icon_override = 'icons/obj/custom_items/khasan_bucket.dmi'
	icon_state = "khasan_helmet"
	item_state = "khasan_helmet"
	contained_sprite = TRUE


/obj/item/fluff/akinyi_symphette //Holo-symphette - Akinyi Idowu - kyres1
	name = "holo-symphette"
	desc = "A cheap, collapsible musical instrument which utilizes holographic projections to generate a rough noise. It's shaped like a small harp, and seems to be  \
	able to be tuned to mimic several old stringed Solarian instruments with some distorted audio. It's still got its price tag sticker on it."
	icon = 'icons/obj/custom_items/akinyi_symphette.dmi'
	icon_override = 'icons/obj/custom_items/akinyi_symphette.dmi'
	icon_state = "akinyi_symphette"
	item_state = "akinyi_symphette"
	w_class = ITEMSIZE_NORMAL
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
	icon_override = 'icons/obj/custom_items/thea_tea.dmi'
	icon_state = "thea_teapot"
	center_of_mass = list("x"=16, "y"=13)

/obj/item/reagent_containers/food/drinks/fluff/thea_teacup //Bonze Teacup - Thea Reeves - shestrying
	name = "bronze teacup"
	desc = "A shallow, bronze teacup. Looks heavy."
	icon = 'icons/obj/custom_items/thea_tea.dmi'
	icon_override = 'icons/obj/custom_items/thea_tea.dmi'
	icon_state = "thea_teacup"
	volume = 20
	center_of_mass = list("x"=16, "y"=12)

/obj/item/storage/box/fluff/thea_teabox //Tea Box - Thea Reeves - shestrying
	desc = "A black, wooden box, the edges softened with transport and use."
	icon = 'icons/obj/custom_items/thea_tea.dmi'
	icon_override = 'icons/obj/custom_items/thea_tea.dmi'
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
	icon_override = 'icons/obj/custom_items/fraseq_journal.dmi'
	icon_state = "fraseq_journal"
	w_class = ITEMSIZE_NORMAL


/obj/item/clothing/accessory/poncho/fluff/ioraks_cape //Iorakian Cape - Kuhserze Ioraks - geeves
	name = "iorakian cape"
	desc = "A tough leather cape, with neat colours of the Ioraks clan threaded through the seams."
	icon = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_override = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_state = "ioraks_cape"
	item_state = "ioraks_cape"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/fluff/strauss_jacket //Custom Firesuit - Lena Strauss - oddbomber3768
	name = "modified firesuit"
	desc = "An old industrial firesuit belonging to a defunct and forgotten company. The wearer has sawn off both of the arms, added two buttons on the front and replaced the back name \
	tag with one reading \"FIREAXE\". Doesn't look really fire resistant anymore"
	icon = 'icons/obj/custom_items/strauss_jacket.dmi'
	icon_override = 'icons/obj/custom_items/strauss_jacket.dmi'
	icon_state = "strauss_jacket"
	item_state = "strauss_jacket"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS


/obj/item/clothing/suit/storage/toggle/labcoat/fluff/likho_labcoat //Terraneus Diagnostics Labcoat - Likho - neworiginalschwann
	name = "terraneus diagnostics labcoat"
	desc = "A well-worn labcoat that marks its wearer as an employee of Terraneus Diagnostics, a subsidiary corporation of Einstein Engines. Text on the labcoat's breast pocket marks \
	the employee as a roboticist employed at Factory 09, Hoboken, United Americas."
	icon = 'icons/obj/custom_items/likho_labcoat.dmi'
	icon_override = 'icons/obj/custom_items/likho_labcoat.dmi'
	icon_state = "likho_labcoat"
	item_state = "likho_labcoat"


/obj/item/clothing/suit/storage/toggle/fr_jacket/fluff/ramit_jacket //Winter Paramedic Jacket - Ra'mit Ma'zaira - simontheminer
	name = "winter paramedic jacket"
	desc = "A custom made first responder coat. Inside is a warm fabric with the name \"Ra'Mit Ma'zaira\" sewn in by the collar."
	icon = 'icons/obj/custom_items/ramit_jacket.dmi'
	icon_override = 'icons/obj/custom_items/ramit_jacket.dmi'
	icon_state = "ramit_jacket"
	item_state = "ramit_jacket"
	contained_sprite = TRUE


/obj/item/clothing/glasses/sunglasses/blindfold/fluff/nai_fold	//Starvoice - Nai Eresh'Wake - jamchop23334
	name = "starvoid blindfold"
	desc = "An ethereal purple blindfold, woven from an incredibly soft yet durable silk. The faintest of light shines through, shading your darkened vision in a haze of purple."
	icon = 'icons/obj/custom_items/nai_items.dmi'
	icon_override = 'icons/obj/custom_items/nai_items.dmi'
	icon_state = "nai_fold"
	item_state = "nai_fold"
	contained_sprite = TRUE
	tint = TINT_BLIND
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

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
	icon_override = 'icons/obj/custom_items/nai_items.dmi'
	icon_state = "nai_gloves"
	item_state = "nai_gloves"
	contained_sprite = TRUE


/obj/item/clothing/head/fluff/djikstra_hood //Stellar Hood - Msizi Djikstra - happyfox
	name = "stellar hood"
	desc = "A more encompassing version of the Starveil, made from a resilient xeno-silk, intended to protect not just the eyes but also the soul of the wearer."
	icon = 'icons/obj/custom_items/djikstra_items.dmi'
	icon_override = 'icons/obj/custom_items/djikstra_items.dmi'
	icon_state = "djikstra_hood"
	item_state = "djikstra_hood"
	contained_sprite = TRUE
	flags_inv = HIDEEARS|BLOCKHAIR|BLOCKHEADHAIR|HIDEEARS|HIDEMASK|HIDEEARS|HIDEEYES
	body_parts_covered = HEAD

/obj/item/clothing/suit/fluff/djikstra_robe //Stellar Robe - Msizi Djikstra - happyfox
	name = "stellar robe"
	desc = "A finely made robe of resilient xeno-silk, shimmering like starlight."
	icon = 'icons/obj/custom_items/djikstra_items.dmi'
	icon_override = 'icons/obj/custom_items/djikstra_items.dmi'
	icon_state = "djikstra_robe"
	item_state = "djikstra_robe"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	contained_sprite = TRUE

/obj/item/clothing/accessory/fluff/djikstra_blade //Symbolic Khanjbiya - Msizi Djikstra - happyfox
	name = "symbolic khanjbiya"
	desc = "A xeno-silk belt carrying an ornate, but entirely symbolic, curved dagger. The blade is fused to the sheath, preventing it from being drawn."
	icon = 'icons/obj/custom_items/djikstra_items.dmi'
	icon_override = 'icons/obj/custom_items/djikstra_items.dmi'
	icon_state = "djikstra_blade"
	item_state = "djikstra_blade"
	contained_sprite = TRUE


/obj/item/clothing/suit/fluff/naali_blanket //Fuzzy Pink Blanket - Naali'Xiiux Qu-Uish - shestrying
	name = "fuzzy pink blanket"
	desc = "A rather large, pink, fluffy blanket. It feels quite heavy, and smells slightly of saltwater."
	icon = 'icons/obj/custom_items/naali_blanket.dmi'
	icon_override = 'icons/obj/custom_items/naali_blanket.dmi'
	icon_state = "naali_blanket"
	item_state = "naali_blanket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	contained_sprite = TRUE


/obj/item/storage/box/fancy/fluff/sentiment_bouquet //Bouquet of Chrysanthemums - IRU-Sentiment - niennab
	name = "bouquet of chrysanthemums"
	desc = "A bouquet of white artificial chrysanthemum flowers wrapped in a sheet of newsprint."
	icon = 'icons/obj/custom_items/sentiment_bouquet.dmi'
	icon_override = 'icons/obj/custom_items/sentiment_bouquet.dmi'
	icon_state = "sentiment_bouquet"
	item_state = "sentiment_bouquet"
	can_hold = list(/obj/item/clothing/accessory/fluff/sentiment_flower)
	starts_with = list(/obj/item/clothing/accessory/fluff/sentiment_flower = 6)
	storage_slots = 6
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'
	use_sound = 'sound/items/storage/wrapper.ogg'

/obj/item/storage/box/fancy/fluff/sentiment_bouquet/fill()
	. = ..()
	update_icon()

/obj/item/storage/box/fancy/fluff/sentiment_bouquet/update_icon()
	icon_state = "[initial(icon_state)]_[contents.len]"
	if(contents.len)
		item_state = initial(item_state)
	else
		item_state = "[initial(item_state)]_e"

/obj/item/clothing/accessory/fluff/sentiment_flower //Artificial Chrysanthemum - IRU-Sentiment - niennab
	name = "artificial chrysanthemum"
	desc = "An artificial white chrysanthemum flower."
	icon = 'icons/obj/custom_items/sentiment_bouquet.dmi'
	icon_override = 'icons/obj/custom_items/sentiment_bouquet.dmi'
	icon_state = "sentiment_flower"
	item_state = "sentiment_flower"
	contained_sprite = TRUE


/obj/item/clothing/head/welding/fluff/ioraks_mask //Iorakian Welding Mask - Kuhserze Ioraks - geeves
	name = "iorakian welding mask"
	desc = "A modified version of the standard issue NanoTrasen Engineering Corps welding mask, hand-painted into the colours of the Ioraks clan. Various alterations are clearly \
	visible, including a darkened visor and refitted straps to keep the mask in place. On the inner side there is an ingraving of the Ioraks clan emblem, an open splayed hand with \
	its palm facing the observer."
	icon = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_override = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_state = "ioraks_mask"
	item_state = "ioraks_mask"
	contained_sprite = TRUE

/obj/item/storage/box/fluff/ioraks_armbands //Delegation Armbands - Kuhserze Ioraks - geeves
	name = "delegation armbands box"
	desc = "A box full of team coloured armbands. It has a small picture of an Unathi's face misprinted on it."
	icon = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_override = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_state = "ioraks_armbands"
	item_state = "ioraks_armbands"
	can_hold = list(/obj/item/clothing/accessory/armband/fluff/ioraks_armband)
	starts_with = list(/obj/item/clothing/accessory/armband/fluff/ioraks_armband = 4, /obj/item/clothing/accessory/armband/fluff/ioraks_armband/alt = 4)
	storage_slots = 8

/obj/item/clothing/accessory/armband/fluff/ioraks_armband
	name = "azszau armband"
	desc = " A quite comfortable armband denoting its wearer as a member of the Azszau team. In fine print on the in-line of the fabric, it has \"The Skilled Hands\" worked into it."
	icon = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_override = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_state = "ioraks_armband"
	item_state = "ioraks_armband"
	contained_sprite = TRUE

/obj/item/clothing/accessory/armband/fluff/ioraks_armband/alt
	name = "kutzis armband"
	desc = "A quite comfortable armband denoting its wearer as a member of the Kutzis team. In fine print on the in-line of the fabric, it has \"The Bright Minds\" worked into it."
	icon = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_override = 'icons/obj/custom_items/ioraks_cape.dmi'
	icon_state = "ioraks_armband2"
	item_state = "ioraks_armband2"


/obj/item/cane/fluff/suul_staff //Akhanzi Staff - Suul Akhandi - herpetophilia
	name = "akhanzi staff"
	desc = "A staff usually carried by shamans of the Akhanzi Order. It is made out of dark, polished wood and is curved at the end."
	icon = 'icons/obj/custom_items/suul_staff.dmi'
	icon_override = 'icons/obj/custom_items/suul_staff.dmi'
	icon_state = "suul_staff"
	item_state = "suul_staff"
	slot_flags = SLOT_BACK
	contained_sprite = TRUE
	w_class = ITEMSIZE_LARGE

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
	icon_override = 'icons/obj/custom_items/cress_items.dmi'
	icon_state = "cress_sweater"
	item_state = "cress_sweater"
	contained_sprite = TRUE

/obj/item/fluff/cress_book //Lyric Book - Emily Cress - mattatlas
	name = "lyric folder"
	desc = "An old, slightly faded folder containing various alphabetically organized lyrics of several songs, including musical sheets for guitars. The name on the folder reads \"Hyo\". \
			The lyrics inside have two copies each: one in Sol Common and one in Tau Ceti Basic. It generally looks to be hard rock or metal, with overall somber lyrics."
	icon = 'icons/obj/custom_items/cress_items.dmi'
	icon_override = 'icons/obj/custom_items/cress_items.dmi'
	icon_state = "cress_book"
	w_class = ITEMSIZE_SMALL
	var/list/lyrics = list("Falling Down: A song about holding on to the last glimmer of hope. It's generally pretty motivational. The most recent song of the three.",
							"Say Something New: A morose song about companionship, and being unable to continue without an undescribed dear friend. Morose, but overall motivational.",
							"One By One: A song telling an undescribed person to 'give it another try'. It seems to mostly about reconciliation and accepting failure. More somber than the others, and the most dated.")

/obj/item/fluff/cress_book/attack_self(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message("<span class='notice'>[user] begins searching through \the [src]'s pages...</span>")
	if(do_after(user, 25))
		to_chat(user, "<span class='notice'>You pick out a song in the folder and read the lyrics: [pick(lyrics)]</span>")


/obj/item/modular_computer/laptop/fluff/harrow_laptop //Developer's Laptop - Danny Harrow - brainos
	name = "developer's laptop"
	desc = "A portable computer, this one is covered edge-to-edge in stickers. Some stand out; such ones from a 2458 Game Jam, 2459 Game Jam and various title logos from obscure holovid series. Printed on the bottom panel \
	is \"Hello, world!\" in a bright, monospace font."
	icon = 'icons/obj/custom_items/harrow_laptop.dmi'
	icon_override = 'icons/obj/custom_items/harrow_laptop.dmi'
	anchored = FALSE
	screen_on = FALSE
	icon_state = "laptop-closed"

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
	icon_override = 'icons/obj/custom_items/ozuha_cape.dmi'
	icon_state = "ozuha_cape"
	item_state = "ozuha_cape"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/fluff/ulmari_coat //Aut'akh Medical Coat - Ulmari Jukal'za - soultheif96
	name = "aut'akh medical coat"
	desc = "A custom-made tailored coat for use in a laboratory/medical setting."
	icon = 'icons/obj/custom_items/ulmari_coat.dmi'
	icon_override = 'icons/obj/custom_items/ulmari_coat.dmi'
	icon_state = "ulmari_coat"
	item_state = "ulmari_coat"
	contained_sprite = TRUE


/obj/item/device/megaphone/fluff/akinyi_mic //Resonance Microphone - Akinyi Idowu - kyres1
	name = "resonance microphone"
	desc = "A rather costly voice amplifier disguised as a microphone. A button on the side permits the user to dial their vocal volume with ease."
	icon = 'icons/obj/custom_items/akinyi_symphette.dmi'
	icon_override = 'icons/obj/custom_items/akinyi_symphette.dmi'
	icon_state = "akinyi_mic"
	item_state = "akinyi_mic"
	w_class = ITEMSIZE_SMALL
	contained_sprite = TRUE
	activation_sound = null
	needs_user_location = FALSE

/obj/item/fluff/akinyi_stand //Telescopic Mic Stand - Akinyi Idowu - kyres1
	name = "telescopic mic stand"
	desc = "A fold-able telescopic microphone with a built in battery to keep your fancy science fiction microphone charged on the go."
	icon = 'icons/obj/custom_items/akinyi_symphette.dmi'
	icon_override = 'icons/obj/custom_items/akinyi_symphette.dmi'
	icon_state = "akinyi_stand-collapsed"
	item_state = "akinyi_stand-collapsed"
	w_class = ITEMSIZE_SMALL
	contained_sprite = TRUE
	var/obj/item/device/megaphone/fluff/akinyi_mic/mic
	var/collapsed = TRUE

/obj/item/fluff/akinyi_stand/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/device/megaphone/fluff/akinyi_mic))
		if(!mic && !collapsed)
			user.unEquip(O)
			O.forceMove(src)
			mic = O
			to_chat(user, SPAN_NOTICE("You place \the [O] on \the [src]."))
			update_icon()

/obj/item/fluff/akinyi_stand/MouseDrop(mob/user as mob)
	if((user == usr && (!use_check(user))) && (user.contents.Find(src) || in_range(src, user)))
		if(ishuman(user))
			forceMove(get_turf(user))
			user.put_in_hands(src)
			update_icon()

/obj/item/fluff/akinyi_stand/attack_hand(mob/user)
	if(!isturf(loc)) //so if you want to play the use the board, you need to put it down somewhere
		..()
	else
		if(mic && !collapsed)
			mic.attack_self(user)

/obj/item/fluff/akinyi_stand/attack_self(mob/user as mob)
	if(mic)
		mic.forceMove(get_turf(src))
		user.put_in_hands(mic)
		mic = null
		update_icon()
		return

	if(collapsed)
		w_class = ITEMSIZE_LARGE
		collapsed = FALSE
	else
		w_class = ITEMSIZE_SMALL
		collapsed = TRUE

	update_icon()
	user.update_inv_l_hand()
	user.update_inv_r_hand()

/obj/item/fluff/akinyi_stand/update_icon()
	if(collapsed)
		icon_state = "akinyi_stand-collapsed"
		item_state = "akinyi_stand-collapsed"
	else
		if(mic)
			icon_state = "akinyi_stand-1"
			item_state = "akinyi_stand-1"
		else
			icon_state = "akinyi_stand-0"
			item_state = "akinyi_stand-0"

/obj/item/storage/fluff/akinyi_case //Instrument Case - Akinyi Idowu - kyres1
	name = "instrument case"
	desc = "A chunky white leather case, with lots of space inside for holding your delicate musical instruments."
	icon = 'icons/obj/custom_items/akinyi_symphette.dmi'
	icon_override = 'icons/obj/custom_items/akinyi_symphette.dmi'
	icon_state = "akinyi_case"
	item_state = "akinyi_case"
	w_class = ITEMSIZE_LARGE
	contained_sprite = TRUE
	storage_slots = 3
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(
		/obj/item/device/megaphone/fluff/akinyi_mic,
		/obj/item/fluff/akinyi_stand,
		/obj/item/fluff/akinyi_symphette
		)
	starts_with = list(
		/obj/item/device/megaphone/fluff/akinyi_mic = 1,
		/obj/item/fluff/akinyi_stand = 1,
		/obj/item/fluff/akinyi_symphette = 1
	)

/obj/item/clothing/head/det/fluff/bell_hat //Brown Hat - Avery Bell - serveris6
	name = "brown hat"
	desc = "A worn mid 20th century brown hat. It seems to have aged very well."
	icon = 'icons/obj/custom_items/bell_coat.dmi'
	icon_override = 'icons/obj/custom_items/bell_coat.dmi'
	icon_state = "bell_hat"
	item_state = "bell_hat"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/det_trench/fluff/bell_coat //Pinned Brown Coat - Avery Bell - serveris6
	name = "pinned brown coat"
	desc = "A worn mid 20th century brown trenchcoat. If you look closely at the breast, you can see an ID flap stitched into the leather - \"Avery Bell, Silhouette Co\"."
	icon = 'icons/obj/custom_items/bell_coat.dmi'
	icon_override = 'icons/obj/custom_items/bell_coat.dmi'
	icon_state = "bell_coat"
	item_state = "bell_coat"
	contained_sprite = TRUE
	allowed = list(/obj/item/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/gun/energy,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,
	/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/storage/box/fancy/cigarettes,/obj/item/flame/lighter,/obj/item/device/taperecorder, /obj/item/clothing/accessory/badge/fluff/bell_badge)

/obj/item/clothing/accessory/badge/fluff/bell_badge //Detective's Credentials - Avery Bell - serveris6
	name = "detective's credentials"
	desc = "A laminated card, verifying the denoted as a private investigator licensed in Biesel. A photo of a tan-skinned human male dressed in a brown coat and hat is imprinted."
	icon = 'icons/obj/custom_items/bell_coat.dmi'
	icon_override = 'icons/obj/custom_items/bell_coat.dmi'
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

/obj/item/clothing/accessory/poncho/fluff/amos_vest //Ouerean Vest - Amos Zhujian - dronzthewolf
	name = "ourean vest"
	desc = "A  thin vest made of separate colors, this one is brown and turquoise, with something written in Sinta'Unathi on the right breast. While this is a traditional cut vest, it's made of modern machine-woven fabrics as is commonly done on Ouerea, and sized to fit a human."
	icon = 'icons/obj/custom_items/amos_vest.dmi'
	icon_override = 'icons/obj/custom_items/amos_vest.dmi'
	icon_state = "amos_vest"
	item_state = "amos_vest"
	contained_sprite = TRUE


/obj/item/clothing/head/fluff/rhasdrimara_veil //Noble Adhomai Veil - Rhasdrimara Rhanmrero'Arhanja - chanterelle
	name = "noble adhomai veil"
	desc = "An antique veil of black lace worn by noble Tajaran women during times of mourning."
	icon = 'icons/obj/custom_items/rhasdrimara_veil.dmi'
	icon_override = 'icons/obj/custom_items/rhasdrimara_veil.dmi'
	icon_state = "rhasdrimara_veil"
	item_state = "rhasdrimara_veil"
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/suit/storage/toggle/fr_jacket/fluff/akila_jacket //Reflective First Responder Jacket - Akila Aksha'Shalwariran - shestrying
	name = "reflective first responder jacket"
	desc = "A jacket in an eye-blinding yellow, with flourescent green, light-reflective striping along the cuffs and bottom edge. A bright red cross rests on the front, over the heart."
	icon = 'icons/obj/custom_items/akila_jacket.dmi'
	icon_override = 'icons/obj/custom_items/akila_jacket.dmi'
	icon_state = "akila_jacket"
	item_state = "akila_jacket"
	contained_sprite = TRUE


/obj/structure/sign/flag/red_coalition
	name = "Red Coalition flag"
	desc = "A high-quality copy of an original Red Coalition banner. This variant on the standard was flown by the Zelazny arcology during the Martian World War, Zelazny's origins as a \
	mining colony represented in the center by the alchemical symbol for iron."
	icon_state = "redcoalition"

/obj/structure/sign/flag/red_coalition/left
	icon_state = "redcoalition_l"

/obj/structure/sign/flag/red_coalition/right
	icon_state = "redcoalition_r"

/obj/item/flag/fluff/nikita_flag //Red Coalition Banner - Nikita Yutani - sycmos
	name = "Red Coalition flag"
	icon = 'icons/obj/custom_items/nikita_flag.dmi'
	icon_override = 'icons/obj/custom_items/nikita_flag.dmi'
	icon_state = "nikita_flag"
	desc = "A high-quality copy of an original Red Coalition banner. This variant on the standard was flown by the Zelazny arcology during the Martian World War, Zelazny's origins as a \
	mining colony represented in the center by the alchemical symbol for iron."
	flag_path = "redcoalition"

/obj/item/flag/fluff/nikita_flag/l
	flag_size = 1


/obj/item/voidsuit_modkit/fluff/rajka_suit
	name = "HEV-3 voidsuit kit"
	desc = "A simple cardboard box containing the requisition forms, permits, and decal kits for a HEV-3 voidsuit."
	suit_options = list(
		/obj/item/clothing/suit/space/void/mining = /obj/item/clothing/suit/space/void/mining/fluff/rajka_suit,
		/obj/item/clothing/head/helmet/space/void/mining = /obj/item/clothing/head/helmet/space/void/mining/fluff/rajka_helm)

/obj/item/clothing/head/helmet/space/void/mining/fluff/rajka_helm //HEV-3 Helmet - Rajka Kaljurl'zar - abigbear
	name = "HEV-3 helmet"
	desc = "A Hephaestus Environmental Voidsuit variant tailored to Tajara, complete with temperature-circulation auxiliaries, spacious helmet interior to minimize friction, and complete anti-microbial filtration systems."
	icon = 'icons/obj/custom_items/rajka_suit.dmi'
	icon_override = 'icons/obj/custom_items/rajka_suit.dmi'
	icon_state = "rajka_helm"
	item_state = "rajka_helm"
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/suit/space/void/mining/fluff/rajka_suit //HEV-3 Voidsuit - Rajka Kaljurl'zar - abigbear
	name = "HEV-3 voidsuit"
	desc = "A Hephaestus Environmental Voidsuit variant tailored to Tajara, complete with temperature-circulation auxiliaries, heat exchange coils, anti-friction and anti-microbial fabric, and moderate grade external reinforcement for all your industrial EVA activities."
	icon = 'icons/obj/custom_items/rajka_suit.dmi'
	icon_override = 'icons/obj/custom_items/rajka_suit.dmi'
	icon_state = "rajka_suit"
	item_state = "rajka_suit"
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_TAJARA)


/obj/item/fluff/holoconsole // Holoconsole - Qoi Liuiq - shestrying
	name = "holoconsole"
	desc = "A game console capable of displaying a three-dimensional, holographic image of the player's game of choice. It's pink!"
	icon = 'icons/obj/custom_items/qoi_console.dmi'
	icon_override = 'icons/obj/custom_items/qoi_console.dmi'
	icon_state = "console"

	var/on = FALSE
	var/obj/item/fluff/holoconsole_controller/left_controller
	var/obj/item/fluff/holoconsole_controller/r/right_controller
	var/mutable_appearance/screen

	var/sound_delay = 0.5 SECONDS // so we don't deafen everyone by spam clicking
	var/last_sound = 0

/obj/item/fluff/holoconsole/Initialize()
	. = ..()
	left_controller = new /obj/item/fluff/holoconsole_controller(src)
	right_controller = new /obj/item/fluff/holoconsole_controller/r(src)
	verbs += /obj/item/fluff/holoconsole/proc/remove_left
	verbs += /obj/item/fluff/holoconsole/proc/remove_right
	screen = mutable_appearance(icon, "screen")
	update_icon()

/obj/item/fluff/holoconsole/Destroy()
	QDEL_NULL(left_controller)
	QDEL_NULL(right_controller)
	return ..()

/obj/item/fluff/holoconsole/update_icon()
	icon_state = "console[left_controller ? "_l" : ""][right_controller ? "_r" : ""]"

/obj/item/fluff/holoconsole/attack_self(mob/user)
	if(on && !(world.time < last_sound + sound_delay))
		playsound(loc, /decl/sound_category/quick_arcade, 60)
		last_sound = world.time
		return
	return ..()

/obj/item/fluff/holoconsole/attackby(obj/item/I, mob/user)
	switch(I.type)
		if(/obj/item/fluff/holoconsole_controller)
			if(left_controller)
				to_chat(user, SPAN_WARNING("\The [src] already has its left controller connected!"))
				return
			user.visible_message("<b>[user]</b> slots \the [I] back into to \the [src].", SPAN_NOTICE("You slot \the [I] back into \the [src]."))
			user.drop_from_inventory(I, src)
			left_controller = I
			left_controller.parent_console = null
			verbs += /obj/item/fluff/holoconsole/proc/remove_left
			update_icon()
			return
		if(/obj/item/fluff/holoconsole_controller/r)
			if(right_controller)
				to_chat(user, SPAN_WARNING("\The [src] already has its right controller connected!"))
				return
			user.visible_message("<b>[user]</b> slots \the [I] back into to \the [src].", SPAN_NOTICE("You slot \the [I] back into \the [src]."))
			user.drop_from_inventory(I, src)
			right_controller = I
			right_controller.parent_console = null
			verbs += /obj/item/fluff/holoconsole/proc/remove_right
			update_icon()
			return
	return ..()

/obj/item/fluff/holoconsole/verb/toggle_on()
	set name = "Toggle On"
	set category = "Object"
	set src in view(1)

	on = !on
	usr.visible_message("<b>[usr]</b> turns \the [src] [on ? "on" : "off"].", SPAN_NOTICE("You turn \the [src] [on ? "on" : "off"]."))
	if(on)
		playsound(loc, 'sound/machines/synth_yes.ogg', 50)
		add_overlay(screen)
	else
		playsound(loc, 'sound/machines/synth_no.ogg', 50)
		cut_overlay(screen)
	update_icon()

/obj/item/fluff/holoconsole/proc/remove_left()
	set name = "Remove Left Controller"
	set category = "Object"
	set src in view(1)

	usr.visible_message("<b>[usr]</b> removes the left controller from \the [src], flicking it open.", SPAN_NOTICE("You remove the left controller from \the [src], flicking it open."))
	usr.put_in_hands(left_controller)
	left_controller.parent_console = WEAKREF(src)
	left_controller = null
	verbs -= /obj/item/fluff/holoconsole/proc/remove_left
	update_icon()

/obj/item/fluff/holoconsole/proc/remove_right()
	set name = "Remove Right Controller"
	set category = "Object"
	set src in view(1)

	usr.visible_message("<b>[usr]</b> removes the right controller from \the [src], flicking it open.", SPAN_NOTICE("You remove the right controller from \the [src], flicking it open."))
	usr.put_in_hands(right_controller)
	right_controller.parent_console = WEAKREF(src)
	right_controller = null
	verbs -= /obj/item/fluff/holoconsole/proc/remove_right
	update_icon()

/obj/item/fluff/holoconsole_controller // Holoconsole - Qoi Liuiq - shestrying
	name = "left holoconsole controller"
	desc = "A controller for the Holoconsole, capable of folding in half and re-attaching to the machine. It's pink!"
	icon = 'icons/obj/custom_items/qoi_console.dmi'
	icon_override = 'icons/obj/custom_items/qoi_console.dmi'
	icon_state = "controller"

	var/datum/weakref/parent_console
	var/sound_delay = 0.5 SECONDS // so we don't deafen everyone by spam clicking
	var/last_sound = 0

/obj/item/fluff/holoconsole_controller/attack_self(mob/user)
	if(world.time < last_sound + sound_delay)
		return

	var/obj/item/fluff/holoconsole/H = parent_console.resolve()
	if(H?.on)
		playsound(H.loc, /decl/sound_category/quick_arcade, 60)
		last_sound = world.time

/obj/item/fluff/holoconsole_controller/r // Holoconsole - Qoi Liuiq - shestrying
	name = "right holoconsole controller"

/obj/item/fluff/holocase // Holoconsole Case - Qoi Liuiq - shestrying
	name = "holoconsole case"
	desc = "A case for the Holoconsole. This one is made of fabric, with various iron-on patches attached to it. It's pink!"
	icon = 'icons/obj/custom_items/qoi_console.dmi'
	icon_override = 'icons/obj/custom_items/qoi_console.dmi'
	icon_state = "case"

	var/spinned = FALSE
	var/obj/item/fluff/holoconsole/contained_console

/obj/item/fluff/holocase/Initialize()
	. = ..()
	contained_console = new /obj/item/fluff/holoconsole(src)

/obj/item/fluff/holocase/Destroy()
	QDEL_NULL(contained_console)
	return ..()

/obj/item/fluff/holocase/update_icon()
	if(!contained_console)
		icon_state = "case_o"
		return
	icon_state = spinned ? "case_b" : "case"

/obj/item/fluff/holocase/attack_self(mob/user)
	if(!contained_console)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a console inside it! Insert it before trying to spin \the [src] around."))
		return
	spinned = !spinned
	user.visible_message("<b>[usr]</b> deftly spins \the [src], showing its [spinned ? "back" : "front"].", SPAN_NOTICE("You deftly spin \the [src], showing its [spinned ? "back" : "front"]."))
	update_icon()

/obj/item/fluff/holocase/attack_hand(mob/user)
	if(contained_console && src == user.get_inactive_hand())
		user.visible_message("<b>[usr]</b> removes \the [contained_console] from \the [src].", SPAN_NOTICE("You remove \the [contained_console] from \the [src]."))
		user.put_in_hands(contained_console)
		contained_console = null
		update_icon()
		return
	return ..()

/obj/item/fluff/holocase/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/fluff/holoconsole))
		if(contained_console)
			to_chat(user, SPAN_WARNING("\The [src] already contains a holoconsole!"))
			return
		user.drop_from_inventory(I, src)
		contained_console = I
		user.visible_message("<b>[usr]</b> puts \the [contained_console] into \the [src], zipping it back up.", SPAN_NOTICE("You put \the [contained_console] into \the [src], zipping it back up."))
		update_icon()
		return
	return ..()

/obj/item/clothing/accessory/poncho/dominia_cape/fluff/godard_cape //House godard cape - Pierre Godard - desven
	name = "house godard cape"
	desc = "This is a cape in the style of Dominian nobility. This one is in the colours of House Godard."
	icon = 'icons/obj/custom_items/godard_cape.dmi'
	icon_override = 'icons/obj/custom_items/godard_cape.dmi'
	icon_state = "godard_cape"
	item_state = "godard_cape"
	contained_sprite = TRUE

/obj/item/flame/lighter/zippo/fluff/sezrak_zippo //Imperial 16th Zippo - Sezrak Han'san - captaingecko
	name = "imperial 16th zippo"
	desc = "A zippo lighter given by the Empire of Dominia to the men of the 16th Regiment of the Imperial Army, also known as the \"Suicide Regiments\", that would manage to survive more \
	than a dozen deployments. The Imperial 16th is a regiment deployed by Dominia during battles that cannot be lost, their men ensuring victories through the use of unusual and highly \
	dangerous tactics, resulting in extremely high losses during almost all of its engagements."
	icon = 'icons/obj/custom_items/sezrak_zippo.dmi'
	icon_override = 'icons/obj/custom_items/sezrak_zippo.dmi'
	icon_state = "sezrak_zippo"
	item_state = "sezrak_zippo"
	contained_sprite = TRUE


/obj/item/clothing/glasses/spiffygogs/fluff/andersen_goggles //Red Goggles - Adam Andersen - cybercide
	name = "red goggles"
	desc = " A pair of worn black goggles with red tinted lenses, both the Kevlar strap and polycarbonate lenses have some scuffs and scratches but they still hold up nicely. \
	There appears to be a Zavodskoi Interstellar insignia on the strap."
	icon = 'icons/obj/custom_items/andersen_goggles.dmi'
	icon_override = 'icons/obj/custom_items/andersen_goggles.dmi'
	icon_state = "andersen_goggles"
	item_state = "andersen_goggles"
	contained_sprite = TRUE


/obj/item/clothing/glasses/welding/fluff/mahir_glasses //Hephaestus Auto-darkening Welding Glasses - Mahir Rrhamrare - veterangary
	name = "hephaestus auto-darkening welding glasses"
	desc = "A pair of Hephaestus produced safety glasses with the prototype incorporation of liquid crystal lenses that polarize intense light present in arc-welding."
	icon = 'icons/obj/custom_items/mahir_glasses.dmi'
	icon_override = 'icons/obj/custom_items/mahir_glasses.dmi'
	icon_state = "mahir_glasses"
	item_state = "mahir_glasses"
	contained_sprite = TRUE


/obj/item/clipboard/fluff/kennard_ledger //Blue Ledger - Kennard Rose - 6thechamp9
	name = "blue ledger"
	desc = "An aluminum block runs the width of the dark blue plastic board, biting down on it with crocodile teeth and barely holding it together. Stuffed within the ledger, a cabbage \
	of paperwork narrates numerous cases, most of them closed. Turning it on its back reveals the embossed letters: NT."
	icon = 'icons/obj/custom_items/kennard_ledger.dmi'
	icon_override = 'icons/obj/custom_items/kennard_ledger.dmi'
	contained_sprite = TRUE


/obj/item/clothing/accessory/poncho/tajarancloak/fancy/fluff/valetzrhonaja_cloak //Nayrragh'Rakhan Cloak - Valetzrhonaja Nayrragh'Rakhan - ramke
	name = "nayrragh'rakhan cloak"
	desc = " A worn, black cloak with golden adornments decorating the edges of the fabric. The insignia of the Nayrragh'Rakhan family is embedded into the custom pin holding the cloak \
	together, and each shoulder is decorated by the representation of a yellow or blue sun - the symbols of S'rendarr and Messa. The fabric is faded, having clearly been tested by time."
	icon = 'icons/obj/custom_items/valetzrhonaja_cloak.dmi'
	icon_override = 'icons/obj/custom_items/valetzrhonaja_cloak.dmi'
	icon_state = "valetzrhonaja_cloak"
	item_state = "valetzrhonaja_cloak"
	contained_sprite = TRUE


/obj/structure/sign/flag/fisanduh_coalition
	name = "coalition fisanduh unity flag"
	desc = "A well-loved flag often seen hung by those advocating for Fisanduh's legitimization and acceptance into the Coalition of Colonies."
	icon_state = "coalition-fisanduh"

/obj/structure/sign/flag/fisanduh_coalition/left
	icon_state = "fisanduh_coalition_l"

/obj/structure/sign/flag/fisanduh_coalition/right
	icon_state = "fisanduh_coalition_r"

/obj/item/flag/fluff/bian_flag //Coalition Fisanduh Unity Flag - Bian Quy Le - persephoneq
	name = "coalition fisanduh unity flag"
	icon = 'icons/obj/custom_items/bian_flag.dmi'
	icon_override = 'icons/obj/custom_items/bian_flag.dmi'
	icon_state = "bian_flag"
	desc = "A well-loved flag often seen hung by those advocating for Fisanduh's legitimization and acceptance into the Coalition of Colonies."
	flag_path = "fisanduh_coalition"
	flag_size = 1


/obj/item/organ/internal/augment/fluff/goldman_eye //Moneymaker Cybernetic Eye Overlay - Kobi Goldman - sleepywolf
	name = "moneymaker cybernetic eye overlay"
	desc = "An advanced golden holographic overlay chip installed into prosthetic eyes. Manufactured by Zeng-Hu for Idris Businessmen in the Eridani Corporate sector, \
	this specific chip is engraved with a signature, and small note. \"For the man who sees my true value. With Love, Renae.\""
	icon = 'icons/obj/custom_items/goldman_eye.dmi'
	icon_override = 'icons/obj/custom_items/goldman_eye.dmi'
	on_mob_icon = 'icons/obj/custom_items/goldman_eye.dmi'
	icon_state = "goldman_eye"
	item_state = "goldman_eye_onmob"
	parent_organ = BP_HEAD

	action_button_icon = "goldman_eye"
	action_button_name = "Activate The Moneymaker Cybernetic Eye"
	activable = TRUE
	cooldown = 25

/obj/item/organ/internal/augment/fluff/goldman_eye/attack_self(var/mob/user)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/W = user.get_active_hand()

	if(W)
		var/value = get_value(W)
		user.visible_message("\The [user] scans \the [W] with \the [src]")
		user.show_message("Price estimation of \the [W]: [value ? value : "N/A"] Credits")

/obj/item/organ/internal/augment/fluff/goldman_chip //Platinum Membership Banking Chip - Kobi Goldman - sleepywolf
	name = "platinum membership banking chip"
	desc = "A Platinum Membership Chip with Lazarus Banking, a subsidiary of Idris Banking that focuses completely on private and anonymous banking. Membership with Lazarus is exclusive, \
	and Membership Chips are the only way to authenticate. The chip is usually implanted near the heart in an EMP proof slot for security purposes. There is a small button on the chip."
	icon = 'icons/obj/custom_items/goldman_eye.dmi'
	icon_override = 'icons/obj/custom_items/goldman_eye.dmi'
	icon_state = "goldman_chip"
	parent_organ = BP_CHEST

/obj/item/organ/internal/augment/fluff/goldman_chip/attack_self(var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (user)
		visible_message("<b>Platinum Chip</b> states eloquently, \"Welcome, Platinum Member and Esteemed Colleague. Please retrieve your funds at the nearest Trade Hub. Please ensure you keep \
		this Platinum Membership Chip in you at all times, unless for emergency anonymous withdraws. Have a nice day, and stay with Lazarus Banking for all your private and personal purchases.\"")

/obj/item/clothing/under/fluff/rajjurl_uniform //Tajaran Noble's Suit - Rajjurl Al-Thaalzir - abigbear
	name = "tajaran noble's suit"
	desc = "A dark, older suit refurbished with new additions and golden buttons, embroidery, and trim. Made with silken fabric, crimson epaulette, and matching sleeve cuffs this suit is a remnant of an older time on Adhomai made new again with recent restorations."
	icon = 'icons/obj/custom_items/rajjurl_uniform.dmi'
	icon_override = 'icons/obj/custom_items/rajjurl_uniform.dmi'
	icon_state = "rajjurl_uniform"
	item_state = "rajjurl_uniform"
	contained_sprite = TRUE
	no_overheat = TRUE

/obj/item/clothing/gloves/white/tajara/fluff/rajjurl_gloves //Tajaran Silken Gloves - Rajjurl Al-Thaalzir - abigbear
	name = "tajaran silken gloves"
	desc = "A pair of silken gloves fitted to a Tajaran hand."
	icon = 'icons/obj/custom_items/rajjurl_uniform.dmi'
	icon_override = 'icons/obj/custom_items/rajjurl_uniform.dmi'
	icon_state = "rajjurl_gloves"
	item_state = "rajjurl_gloves"
	contained_sprite = TRUE

/obj/item/storage/backpack/fluff/pax_bag // Alqaana Backpack - Ka'Akaix'Pax C'thur - desven
	name = "Alqaana backpack"
	desc = "Known for her extravagant concerts, Alqaana is one of the few idols that have drawn inspiration from Solarian classical music over more contemporary skrellian genres. This is her, in bag form!"
	icon = 'icons/obj/custom_items/pax_bag.dmi'
	icon_override = 'icons/obj/custom_items/pax_bag.dmi'
	icon_state = "pax_bag"
	item_state = "pax_bag"
	contained_sprite = TRUE

/obj/item/storage/pill_bottle/dice/fluff/suraya_dicebag //Crevan Dice Bag - Suraya Al-Zahrani - Omicega
	name = "velvet dice bag"
	desc = "A deep purple dice bag fashioned from Adhomian velvet, with two little drawstrings to tighten the neck closed."
	icon = 'icons/obj/custom_items/suraya_dice.dmi'
	icon_override = 'icons/obj/custom_items/suraya_dice.dmi'
	icon_state = "sur_dbag"
	item_state = "sur_dbag"

	starts_with = list(
		/obj/item/stack/dice/fluff/suraya_dice = 3,
		/obj/item/stack/dice/fluff/suraya_dice/alt = 3
	)

/obj/item/stack/dice/fluff/suraya_dice
	name = "blue adhomian die"
	desc = "A blue-and-gold wooden die with six sides, beautifully carved and delicately painted. The single dot on the number one side is, on closer inspection, a miniature image of the god Rredouane."
	icon = 'icons/obj/custom_items/suraya_dice.dmi'
	icon_override = 'icons/obj/custom_items/suraya_dice.dmi'
	icon_state = "sur_b_d1"
	base_icon = "sur_b_d"
	favored_number = 1
	weight_roll = 22

/obj/item/stack/dice/fluff/suraya_dice/AltClick(mob/user)
	if(user.get_active_hand() != src)
		return ..()

	if(weight_roll)
		user.visible_message("<b>\The [user]</b> jiggles \the [src] around in their hand for a second.", SPAN_NOTICE("You jiggle the die rapidly in your hand, resetting the internal weighting."))
		weight_roll = 0
	else
		user.visible_message("<b>\The [user]</b> jiggles \the [src] around in their hand for a second.", SPAN_NOTICE("You carefully jiggle the die one way, then the other, allowing its internal weighting to lock into place."))
		weight_roll = initial(weight_roll)

/obj/item/stack/dice/fluff/suraya_dice/alt
	name = "green adhomian die"
	desc = "A green-and-silver wooden die with six sides, beautifully carved and delicately painted. The single dot on the number one side is, on closer inspection, a miniature image of the god Rredouane."
	icon_state = "sur_g_d1"
	base_icon = "sur_g_d"
	favored_number = 6

/obj/item/clothing/head/fluff/ulzka_skull // The skull of Ulzka Dorviza - The Continuity of Ulzka Dorviza - boggle08
	name = "skull of Ulzka Dorviza"
	desc = "This is the polished skull of a long dead Unathi. Great horns adorn either side of it, however, one of them is cracked off. In the rare instance it isn't lodged firmly in the gestalt it belongs to, it is bagged and tied up into the cowl that houses it."
	icon = 'icons/obj/custom_items/ulzka_skull.dmi'
	icon_override = 'icons/obj/custom_items/ulzka_skull.dmi'
	icon_state = "ulzka_skull"
	item_state = "ulzka_skull"
	canremove = FALSE
	contained_sprite = TRUE

/obj/item/organ/internal/augment/synthetic_cords/voice/fluff/marc //Old Synthetic Vocal Cords - Marc Hardy - Dekser
	name = "old synthetic vocal cords"
	desc = "A set of Old Age Synthetic Vocal Cords. They look barely functional."

/obj/item/clothing/suit/storage/toggle/fluff/leonid_chokha //Old Rebel's Chokha - Leonid Myagmar - lucaken
	name = "old rebel's chokha"
	desc = "A not-so traditional Vysokan Chokha made out of beat-up gurmori leathers, worn-out to the point of seeming ancient. Though it might have been a Host-boy's garment once, it is now \
	swarmed with dozens of patches all with varying colours and origins - the most prominent of which is a large image of a crimson snake on a white plain, curled around a fire. It's the oldest \
	out of all the adornments."
	icon = 'icons/obj/custom_items/leonid_chokha.dmi'
	icon_override = 'icons/obj/custom_items/leonid_chokha.dmi'
	icon_state = "leonid_chokha"
	item_state = "leonid_chokha"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/fluff/sezrak_coat //Red Domelkoan Coat - Sezrak Han'san - captaingecko
	name = "red Domelkoan Coat"
	desc = "A warm coat made in Domelkos. This red coat is stuffed with yupmi fur and made out of reinforced cloth-like synthetic materials, both to keep the wearer warm in the cold winters of \
	Moroz, and to resist all but the rougher treatments... All the while remaining good-looking enough. Both shoulders on this coat feature the standard of the Han'san clan-house, presented in a \
	gilded color."
	icon = 'icons/obj/custom_items/sezrak_coat.dmi'
	icon_override = 'icons/obj/custom_items/sezrak_coat.dmi'
	icon_state = "sezcoat"
	item_state = "sezcoat"
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/fluff/sezrak_cape //Red Han'san Cape - Sezrak Han'san - captaingecko
	name = "red Han'san cape"
	desc = "This is a cape loosely based on the style of Dominian nobility, the latest fashion across Dominian space, although it doesn't feature any of the colors belonging to the Great Houses, \
	and doesn't bear the symbolism of the ones worn by Tribunalist priests. The left shoulder-side bears the standards of the Han'san clan-house with a small, discreet symbol of gilded colors, \
	instead of the usual Green used for this house."
	icon = 'icons/obj/custom_items/sezrak_coat.dmi'
	icon_override = 'icons/obj/custom_items/sezrak_coat.dmi'
	icon_state = "sez_cape"
	item_state = "sez_cape"
	contained_sprite = TRUE

/obj/item/journal/fluff/mrakiizar_book //Worn Journal - Azradov Mrakiizar - kingoftheping
	name = "worn journal"
	desc = "A heavily worn journal-like hardcover book. It is filled with lots of handwritten notes, lists and some sketches in between. Both the contents in the book, aswell as the loose pages \
	tucked in between are mostly written in Siik'maas. The front has a strip of tape with the name 'Ahkrraazarjhri Maalhalkasanurran' on it."
	icon = 'icons/obj/custom_items/mrakiizar_book.dmi'
	icon_override = 'icons/obj/custom_items/mrakiizar_book.dmi'
	icon_state = "mrakiizar_book"
	item_state = "mrakiizar_book"
	contained_sprite = TRUE
	var/open_state = "mrakiizar_book1"
	var/list/open_states = list("mrakiizar_book1", "mrakiizar_book2", "mrakiizar_book3", "mrakiizar_book4")

/obj/item/journal/fluff/mrakiizar_book/update_icon()
	if(!open)
		icon_state = "mrakiizar_book_closed"
	else
		icon_state = open_state

	if(closed_desc)
		desc = open ? initial(desc) + closed_desc : initial(desc)

/obj/item/journal/fluff/mrakiizar_book/attack_hand(mob/user)
	if(open && user.a_intent == I_HURT)
		if(!LAZYLEN(indices))
			to_chat(user, SPAN_WARNING("There aren't any indices to rip a paper out of!"))
			return

		var/list/viable_indices = list()
		for(var/index in indices)
			var/obj/item/folder/embedded/E = indices[index]
			if(!(locate(/obj/item/paper) in E))
				continue
			viable_indices += index

		if(!length(viable_indices))
			to_chat(user, SPAN_WARNING("None of the indices in \the [src] contain a paper!"))
			return

		var/selected_folder = input(user, "Select an index to rip a paper out of.", "Rip Index Select") as null|anything in viable_indices
		if(isnull(selected_folder))
			return

		var/obj/item/folder/embedded/E = indices[selected_folder]
		var/list/papers = list()

		for(var/obj/item/paper/P in E)
			papers += P

		var/obj/item/paper/selected_paper = input(user, "Select a paper to rip out.", "Rip Paper Select") as null|anything in papers
		if(isnull(selected_paper))
			return

		user.visible_message(SPAN_WARNING("<b>[user]</b> rips \the [selected_paper] out of \the [src]."), SPAN_NOTICE("You rip \the [selected_paper] out of \the [src]."), range = 5)
		if(selected_paper.can_change_icon_state)
			selected_paper.icon = icon
			selected_paper.base_state = "torn"
			selected_paper.update_icon()
		user.put_in_hands(selected_paper)
		E.handle_post_remove()
		playsound(loc, 'sound/items/poster_ripped.ogg', 50, FALSE)
		return
	return ..()

/obj/item/journal/fluff/mrakiizar_book/CtrlClick(mob/user)
	if(open && Adjacent(user))
		open_state = next_in_list(icon_state, open_states)
		user.visible_message("<b>[user]</b> flips a page in \the [src].", SPAN_NOTICE("You flip a page in \the [src]."), range = 3)
		playsound(loc, 'sound/items/pickup/paper.ogg', 50, FALSE)
		update_icon()
		return
	return ..()

/obj/item/clothing/accessory/fluff/jaquelyn_necklace //Shrapnel Necklace - Jaquelyn Roberts - roostercat12
	name = "shrapnel necklace"
	desc = "A necklace consisting of a piece of shrapnel on a silver chain, with a pink wire running around the back. You can feel a pulse similar to a heartbeat from a small device on the back \
	side of the Shrapnel, with the wire feeding into it."
	icon = 'icons/obj/custom_items/jaquelyn_necklace.dmi'
	icon_override = 'icons/obj/custom_items/jaquelyn_necklace.dmi'
	icon_state = "jaquelyn_necklace"
	item_state = "jaquelyn_necklace"
	contained_sprite = TRUE
	slot_flags = SLOT_EARS | SLOT_TIE

/obj/item/clothing/under/fluff/quoro_robes //Black Robes - Quoro Wurri'Til - witchbells
	name = "black robes"
	desc = "Some simple black robes, made to wear under something more elaborate. The fabric has a distinct texture to it, giving you the impression of activewear or swimsuits."
	icon = 'icons/obj/custom_items/quoro_items.dmi'
	icon_override = 'icons/obj/custom_items/quoro_items.dmi'
	icon_state = "quoro_robes"
	item_state = "quoro_robes"
	contained_sprite = TRUE

/obj/item/clothing/head/fluff/quoro_hat //Skrellian Silver Headband - Quoro Wurri'Til - witchbells
	name = "skrellian silver headband"
	desc = "A jeweled silver headband worn at the base of the headtails."
	icon = 'icons/obj/custom_items/quoro_items.dmi'
	icon_override = 'icons/obj/custom_items/quoro_items.dmi'
	icon_state = "quoro_hat"
	item_state = "quoro_hat"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/fluff/quoro_suit //Skrellian Fancy Robes - Quoro Wurri'Til - witchbells
	name = "skrellian fancy robes"
	desc = "An elaborate yet functional set of robes favored by the upper echelons of skrellian society, with a silver belt attached. A star is embroidered on the back, \
	symbolizing the Nralakk Federation."
	icon = 'icons/obj/custom_items/quoro_items.dmi'
	icon_override = 'icons/obj/custom_items/quoro_items.dmi'
	icon_state = "quoro_suit"
	item_state = "quoro_suit"
	contained_sprite = TRUE


/obj/item/clothing/accessory/poncho/shouldercape/qeblak/zeng/fluff/eden_cloak // Zeng-Hu Nralakk division cloak - Eden Li - Huntime
	name = "Zeng-Hu cloak: Nralakk Division"
	desc = "A cloak worn by Zeng-Hu personnel who worked with or in the Nralakk Federation."
	icon = 'icons/obj/custom_items/eden_cloak.dmi'
	icon_override = 'icons/obj/custom_items/eden_cloak.dmi'
	icon_state = "ZH_cape_custom"
	item_state = "ZH_cape_custom"

/obj/item/clothing/head/welding/fluff/akara_mask //Steel Face Mask - Akara Seuseisak - aticius
	name = "steel face mask"
	desc = "A slab of steel that has been hammered into the shape of a full-face mask with crude tools. It seems quite old and an appreciable layer of rust has built up."
	icon = 'icons/obj/custom_items/akara_mask.dmi'
	icon_override = 'icons/obj/custom_items/akara_mask.dmi'
	icon_state = "akara_mask"
	item_state = "akara_mask"
	contained_sprite = TRUE
	action_button_name = "Adjust mask"
	flash_protection = FLASH_PROTECTION_NONE
	tint = TINT_NONE

/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/fluff/iliasz_jacket //Naval Pilot's Jacket - Iliasz Jajszczyk - dansemacabre
	name = "naval pilot's jacket"
	desc = "A sturdy grey-green neonomex-lined jacket, flame-resistant and sleek. A garment of choice for anyone who might be in the cockpit of something with a risk of catching fire. \
	There's a name patch sewn onto the breast of this one, reading \"JAJSZCZYK\". It seems to be more rugged than a typical flight jacket, and also appears to have some waterproofing. \
	A Solarian flag in miniature rests on the right sleeve, the colors faded and worn."
	icon = 'icons/obj/custom_items/iliasz_jacket.dmi'
	icon_override = 'icons/obj/custom_items/iliasz_jacket.dmi'
	icon_state = "iliasz_jacket"
	item_state = "iliasz_jacket"
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/tajarancloak/fluff/dekel_smock // Corporate Smock - Dekel Mrrhazrughan - veterangary
	name = "corporate smock"
	desc = "A dark coloured surplus winter smock repurposed for interstellar use that has a hood shaded with corporate colors. A traditional Stellar Corporate Conglomerate star is embroidered on the back."
	icon = 'icons/obj/custom_items/dekel_smock.dmi'
	icon_override = 'icons/obj/custom_items/dekel_smock.dmi'
	icon_state = "seccloak"
	item_state = "seccloak"
	contained_sprite = TRUE
	var/hoodtype = /obj/item/clothing/head/winterhood/fluff/dekel_hood

/obj/item/clothing/accessory/poncho/tajarancloak/fluff/dekel_smock/Initialize()
	. = ..()
	new hoodtype(src)

/obj/item/clothing/head/winterhood/fluff/dekel_hood
	name = "corporate hood"
	desc = "A hood attached to a corporate smock."
	icon = 'icons/obj/custom_items/dekel_smock.dmi'
	icon_override = 'icons/obj/custom_items/dekel_smock.dmi'
	icon_state = "seccloak_hood"
	item_state = "seccloak_hood"
	contained_sprite = TRUE
	flags_inv = HIDEEARS | BLOCKHAIR

/obj/item/clothing/accessory/poncho/tajarancloak/fluff/dekel_smock/on_attached(obj/item/clothing/S, mob/user as mob)
	..()
	has_suit.verbs += /obj/item/clothing/accessory/poncho/tajarancloak/fluff/dekel_smock/verb/change_hood

/obj/item/clothing/accessory/poncho/tajarancloak/fluff/dekel_smock/on_removed(mob/user as mob)
	if(has_suit)
		has_suit.verbs -= /obj/item/clothing/accessory/poncho/tajarancloak/fluff/dekel_smock/verb/change_hood
	..()

/obj/item/clothing/accessory/poncho/tajarancloak/fluff/dekel_smock/verb/change_hood()
	set name = "Toggle Hood"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return

	var/obj/item/clothing/accessory/poncho/tajarancloak/fluff/dekel_smock/D = get_accessory(/obj/item/clothing/accessory/poncho/tajarancloak/fluff/dekel_smock)
	if(!D)
		return

	SEND_SIGNAL(D, COMSIG_ITEM_UPDATE_STATE, D)


/obj/item/fluff/nasira_burner //Adhomian Incense Burner - Nasira Nahnikh - ramke
	name = "adhomian incense burner"
	desc = "A traditional Adhomian incense burner with blue and yellow suns depicted on the front. The metal cover is blackened from use, and there appear to be unclear etchings on the inside."
	icon = 'icons/obj/custom_items/nasira_burner.dmi'
	icon_state = "burner"
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'
	var/matchmsg = "USER lights NAME with their FLAME."
	var/lightermsg = "USER manages to awkwardly light NAME with FLAME."
	var/zippomsg = "With a flick of their wrist, USER lights NAME with their FLAME."
	var/weldermsg = "USER lights NAME with FLAME. That looked rather unsafe!"
	var/ignitermsg = "USER fiddles with FLAME, and eventually manages to light NAME."
	var/genericmsg = "USER lights NAME with their FLAME."
	var/lit = FALSE

/obj/item/fluff/nasira_burner/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/fluff/nasira_burner/examine(mob/user)
	..(user)
	if(lit)
		to_chat(user, "\The [src] is currently lit.")

/obj/item/fluff/nasira_burner/proc/light(var/lighting_text)
	if(!lit)
		lit = TRUE
		playsound(src, 'sound/items/cigs_lighters/cig_light.ogg', 75, 1, -1)
		if(lighting_text)
			var/turf/T = get_turf(src)
			T.visible_message(SPAN_NOTICE(lighting_text))
		set_light(2, 0.25, "#E38F46")
		icon_state = "burner_lit"
		START_PROCESSING(SSprocessing, src)

/obj/item/fluff/nasira_burner/attack_self(mob/user as mob)
	if(lit)
		lit = FALSE
		var/turf/T = get_turf(src)
		T.visible_message(SPAN_NOTICE("[user] extinguishes \the [src]."))
		set_light(0)
		icon_state = initial(icon_state)
		STOP_PROCESSING(SSprocessing, src)

/obj/item/fluff/nasira_burner/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(W.isFlameSource())
		var/text = matchmsg
		if(istype(W, /obj/item/flame/match))
			text = matchmsg
		else if(istype(W, /obj/item/flame/lighter/zippo))
			text = zippomsg
		else if(istype(W, /obj/item/flame/lighter))
			text = lightermsg
		else if(W.iswelder())
			text = weldermsg
		else if(istype(W, /obj/item/device/assembly/igniter))
			text = ignitermsg
		else
			text = genericmsg
		text = replacetext(text, "USER", "\the [user]")
		text = replacetext(text, "NAME", "\the [name]")
		text = replacetext(text, "FLAME", "\the [W.name]")
		light(text)

/obj/item/fluff/nasira_burner/process()
	if(prob(10))
		var/lit_message

		lit_message = pick( "The smell of ceremonial incense reaches your nose.",
								"Adhomian incense permeates the air around you.",
								"The soft glow of the incense burner illuminates the vicinity.")

		if(lit_message)
			visible_message(SPAN_NOTICE(lit_message), range = 3)

/obj/item/clothing/suit/vaurca/fluff/bells_zora_cloak //Tailored Hive Cloak - Ka'Akaix'Bells Zo'ra - shestrying
	name = "tailored hive cloak"
	desc = "A typical-looking Vaurca hive cloak design, tailored from what looks to be labcoat material."
	icon = 'icons/obj/custom_items/bells_zora_items.dmi'
	icon_override = 'icons/obj/custom_items/bells_zora_items.dmi'
	icon_state = "bells_zora_cloak"
	item_state = "bells_zora_cloak"
	contained_sprite = TRUE

/obj/item/storage/box/fancy/fluff/bells_zora_box //Taffy Basket - Ka'Akaix'Bells Zo'ra - shestrying
	name = "taffy basket"
	desc = "A round, wicker basket full to the brim with taffy! "
	icon = 'icons/obj/custom_items/bells_zora_items.dmi'
	icon_override = 'icons/obj/custom_items/bells_zora_items.dmi'
	icon_state = "bells_zora_box_full"
	item_state = "bells_zora_box_full"
	can_hold = list(/obj/item/reagent_containers/food/snacks/fluff/taffy)
	starts_with = list(/obj/item/reagent_containers/food/snacks/fluff/taffy = 6, /obj/item/reagent_containers/food/snacks/fluff/taffy/pink = 6, /obj/item/reagent_containers/food/snacks/fluff/taffy/blue = 6)
	storage_slots = 18
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'
	use_sound = 'sound/items/storage/wrapper.ogg'

/obj/item/storage/box/fancy/fluff/bells_zora_box/fill()
	. = ..()
	update_icon()

/obj/item/storage/box/fancy/fluff/bells_zora_box/update_icon()
	if(contents.len == 0)
		icon_state = "bells_zora_box_empty"
		desc = " A round, wicker basket. There's some colorful crumbs on the bottom of the linen lining. "
	else if(contents.len <= 11)
		icon_state = "bells_zora_box_half"
		desc = "A round, wicker basket with some taffy inside!"
	else if(contents.len >= 12)
		icon_state = "bells_zora_box_full"
		desc = "A round, wicker basket full to the brim with taffy!"


/obj/item/reagent_containers/food/snacks/fluff/taffy
	name = "orange taffy"
	desc = "A piece of handmade taffy, rolled up in a cute spiral!"
	icon = 'icons/obj/custom_items/bells_zora_items.dmi'
	icon_state = "orange_taffy"
	reagents_to_add = list(/decl/reagent/nutriment = 3)
	reagent_data = list(/decl/reagent/nutriment = list("bittersweetness, insect meat and regret" = 1))
	bitesize = 1

/obj/item/reagent_containers/food/snacks/fluff/taffy/pink
	name = "pink taffy"
	icon_state = "pink_taffy"
	reagent_data = list(/decl/reagent/nutriment = list("sweetness and a hint of strawberry" = 1))

/obj/item/reagent_containers/food/snacks/fluff/taffy/blue
	name = "blue taffy"
	icon_state = "blue_taffy"
	reagent_data = list(/decl/reagent/nutriment = list("salty-sweet, tangy taffy" = 1))
