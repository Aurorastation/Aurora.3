/// Aurora custom items ///
/*basic guidelines:
Custom items must be accepted at some point in the forums by the staff handling them.
Add custom items to this file, their sprites into their own dmi. in the icons/obj/custom_items.
All custom items with worn sprites must follow the contained sprite system: http://forums.aurorastation.org/viewtopic.php?f=23&t=6798
*/

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
	update_icon()

	return

/obj/item/implanter/fluff/attack(mob/living/target_mob, mob/living/user, target_zone)
	if (!target_mob.ckey || target_mob.ckey != allowed_ckey)
		return

	..()

/obj/item/organ/internal/augment/fluff //used for custom item that are augments

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
	body_parts_covered = UPPER_TORSO | ARMS

/obj/item/clothing/accessory/badge/old/fluff/ana_badge //Faded Badge - Ana Roh'hi'tin - suethecake
	name = "faded badge"
	desc = "A faded badge, backed with leather, that reads \"NT Security Force\" across the front. It bears the emblem of the forensic division."
	stored_name = "Ana Issek"
	badge_string = "NanoTrasen Security Department"


/obj/item/clothing/under/fluff/faysal_uniform //Old Tajaran Nobleman Suit - Faysal Al-Shennawi - alberyk
	name = "old tajaran nobleman suit"
	desc = "A fancy looking suit, made of white line, adorned with golden details and buttons bearing long forgotten meanings. A blue sash decorates this piece of clothing."
	icon = 'icons/obj/custom_items/faysal_uniform.dmi'
	icon_override = 'icons/obj/custom_items/faysal_uniform.dmi'
	icon_state = "faysal_uniform"
	item_state = "faysal_uniform"
	contained_sprite = TRUE


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


/obj/item/reagent_containers/glass/beaker/teapot/fluff/brianne_teapot //Ceramic Teapot - Sean Brianne - zelmana
	name = "ceramic teapot"
	desc = "A blue ceramic teapot, gilded with the abbreviation for NanoTrasen."
	icon = 'icons/obj/custom_items/brianne_items.dmi'
	icon_override = 'icons/obj/custom_items/brianne_items.dmi'
	icon_state = "brianne_teapot"


/obj/item/clothing/mask/fluff/corvo_cigarette //Vaporizer Pen - Nathan Corvo - jkjudgex
	name = "vaporizer pen"
	desc = "A simple vaporizer pen, the electronic version of the cigarette."
	icon = 'icons/obj/custom_items/corvo_cigarette.dmi'
	icon_override = 'icons/obj/custom_items/corvo_cigarette.dmi'
	icon_state = "corvo_cigarette"
	item_state = "corvo_cigarette"
	body_parts_covered = 0
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_EARS | SLOT_MASK
	contained_sprite = TRUE
	var/active = FALSE

/obj/item/clothing/mask/fluff/corvo_cigarette/attack_self(mob/user)
	active= !active
	if(active)
		to_chat(user, SPAN_NOTICE("You turn \the [src] on."))
	else
		to_chat(user, SPAN_NOTICE("You turn \the [src] off."))

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

/obj/item/clothing/mask/fluff/corvo_cigarette/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += "It is [active ? "on" : "off"]."


/obj/item/clothing/suit/storage/fluff/vira_coat //Designer Military Coat - Vira Bolivar - scheveningen
	name = "designer military coat"
	desc = "A dark funnel neck designer military-style dress coat, specially fitted on commission, clearly designed for a woman's figure. \
	A skillfully stitched 'NT' pattern is laden above a chest pocket, the phrase \"15 years of loyal service to the Corp\" below the insignia, followed by the personal signature of \"Vira Bolivar Taryk\"."
	icon = 'icons/obj/custom_items/vira_coat.dmi'
	icon_override = 'icons/obj/custom_items/vira_coat.dmi'
	icon_state = "vira_coat"
	item_state = "vira_coat"
	contained_sprite = TRUE


/obj/item/clothing/suit/fluff/leo_scarf //Scarf - Leo Wyatt - keinto
	name = "striped scarf"
	desc = "A soft scarf striped in black and blue."
	icon = 'icons/obj/custom_items/leo_scarf.dmi'
	icon_override = 'icons/obj/custom_items/leo_scarf.dmi'
	icon_state = "leo_scarf"
	item_state = "leo_scarf"
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
	w_class = WEIGHT_CLASS_NORMAL


/obj/item/flame/lighter/zippo/fluff/nikit_zippo //Vasili Mine Zippo - Nikit Vasili - sampletex
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
	w_class = WEIGHT_CLASS_SMALL


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


/obj/item/cane/fluff/qrqil_cane //Energy Cane - Qrqil Qrrzix - yonnimer
	name = "energy cane"
	desc = "This silver-handled cane has letters carved into the sides."
	icon = 'icons/obj/custom_items/qrqil_cane.dmi'
	icon_override = 'icons/obj/custom_items/qrqil_cane.dmi'
	icon_state = "qrqil_cane"
	item_state = "qrqil_cane"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	var/active = FALSE

/obj/item/cane/fluff/qrqil_cane/attack_self(mob/user)
	active= !active
	if(active)
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("\The [src] is now energised."))
		item_state = icon_state
		w_class = WEIGHT_CLASS_BULKY
	else
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("\The [src] is now de-energised.."))
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


/obj/item/device/radio/headset/fluff/resolve_headset //Antennae - Decisive Resolve - itanimulli
	name = "antennae"
	desc = "Collapsible spherical antennae designed to interface with an IPC."
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
	name = "panel harness"
	desc = "A lightweight, minimalist set of all-in-one paneling. To be worn by an IPC. Doesn't offer much protection."
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
	w_class = WEIGHT_CLASS_NORMAL
	var/has_spear = TRUE

/obj/item/fluff/tokash_spear/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 1 && has_spear)
		. += "It currently holds an old looking spearhead."

/obj/item/fluff/tokash_spear/update_icon()
	if(has_spear)
		icon_state = "stand-spear"
	else
		icon_state = "stand"

/obj/item/fluff/tokash_spear/attack_hand(var/mob/user)
	if(has_spear)
		to_chat(user, SPAN_NOTICE("You remove the spearhead from \the [src]."))
		var/obj/item/fluff/tokash_spearhead/piece = new(get_turf(user))
		user.put_in_hands(piece)
		has_spear = FALSE
		update_icon()

/obj/item/fluff/tokash_spear/attackby(obj/item/attacking_item, mob/user, params)
	if(!has_spear && istype(attacking_item, /obj/item/fluff/tokash_spearhead))
		to_chat(user, SPAN_NOTICE("You place \the [attacking_item] on the [src]."))
		user.drop_from_inventory(attacking_item,src)
		qdel(attacking_item)
		has_spear = TRUE
		update_icon()
	else
		..()

/obj/item/fluff/tokash_spear/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if((over == user && (!(user.restrained()) && (!(user.stat) && (user.contents.Find(src) || in_range(src, user))))))
		if(!istype(user, /mob/living/carbon/slime) && !istype(user, /mob/living/simple_animal))
			if(!user.get_active_hand()) // If active hand is empty.
				var/mob/living/carbon/human/H = over
				var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]

				if(H.hand)
					temp = H.organs_by_name[BP_L_HAND]
				if(temp && !temp.is_usable())
					to_chat(H, SPAN_NOTICE("You try to move your [temp.name], but cannot!"))
					return

				to_chat(H, SPAN_NOTICE("You pick up \the [src]."))
				H.put_in_hands(src)
	return

/obj/item/fluff/tokash_spearhead
	name = "ancestral spearhead"
	desc = "An aged and worn spearhead. It seems to be made of bronze or composite metal."
	icon = 'icons/obj/custom_items/tokash_spear.dmi'
	icon_override = 'icons/obj/custom_items/tokash_spear.dmi'
	icon_state = "spearhead"
	w_class = WEIGHT_CLASS_SMALL

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


/obj/item/device/synthesized_instrument/guitar/multi/fluff/akinyi_symphette //Holo-symphette - Akinyi Idowu - kyres1
	name = "holo-symphette"
	desc = "A cheap, collapsible musical instrument which utilizes holographic projections to generate a rough noise. It's shaped like a small harp, and seems to be  \
	able to be tuned to mimic several old stringed Solarian instruments with some distorted audio. It's still got its price tag sticker on it."
	icon = 'icons/obj/custom_items/akinyi_symphette.dmi'
	icon_override = 'icons/obj/custom_items/akinyi_symphette.dmi'
	icon_state = "akinyi_symphette"
	item_state = "akinyi_symphette"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = SLOT_BACK
	contained_sprite = TRUE
	var/deployed = FALSE

/obj/item/device/synthesized_instrument/guitar/multi/fluff/akinyi_symphette/update_icon()
	if(deployed)
		icon_state = "akinyi_symphette_on"
		item_state = "akinyi_symphette_on"
	else
		icon_state = "akinyi_symphette"
		item_state = "akinyi_symphette"

/obj/item/device/synthesized_instrument/guitar/multi/fluff/akinyi_symphette/AltClick(var/mob/user)
	deployed = !deployed
	to_chat(user, SPAN_NOTICE("You [deployed ? "expand" : "collapse"] \the [src]."))
	update_icon()
	user.update_inv_l_hand()
	user.update_inv_r_hand()

/obj/item/reagent_containers/glass/beaker/teapot/fluff/thea_teapot //Bronze Teapot - Thea Reeves - shestrying
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
	can_hold = list(/obj/item/reagent_containers/glass/beaker/teapot/fluff/thea_teapot, /obj/item/reagent_containers/food/drinks/fluff/thea_teacup)
	make_exact_fit = TRUE

/obj/item/storage/box/fluff/thea_teabox/fill()
	new /obj/item/reagent_containers/glass/beaker/teapot/fluff/thea_teapot(src)
	for(var/i in 1 to 4)
		new /obj/item/reagent_containers/food/drinks/fluff/thea_teacup(src)

/obj/item/fluff/fraseq_journal //Fraseq's Journal of Mysteries - Quorrdash Fraseq - kingoftheping
	name = "leather journal"
	desc = "An old, worn out journal made out of leather. It has a lot of lose pages stuck in it, it surely has seen better days. The front just says \"Fraseq\"."
	icon = 'icons/obj/custom_items/fraseq_journal.dmi'
	icon_override = 'icons/obj/custom_items/fraseq_journal.dmi'
	icon_state = "fraseq_journal"
	w_class = WEIGHT_CLASS_NORMAL


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


/obj/item/clothing/suit/storage/toggle/para_jacket/fluff/ramit_jacket //Winter paramedic Jacket - Ra'mit Ma'zaira - sampletex
	name = "winter paramedic jacket"
	desc = "A custom made paramedic coat. Inside is a warm fabric with the name \"Ra'Mit Ma'zaira\" sewn in by the collar."
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
	w_class = WEIGHT_CLASS_BULKY

/obj/item/cane/fluff/suul_staff/afterattack(atom/A, mob/user as mob, proximity)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!proximity)
		return
	if (istype(A, /turf/simulated/floor))
		user.visible_message(SPAN_NOTICE("[user] loudly taps their [src.name] against the floor."))
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
	w_class = WEIGHT_CLASS_SMALL
	var/list/lyrics = list("Falling Down: A song about holding on to the last glimmer of hope. It's generally pretty motivational. The most recent song of the three.",
							"Say Something New: A morose song about companionship, and being unable to continue without an undescribed dear friend. Morose, but overall motivational.",
							"One By One: A song telling an undescribed person to 'give it another try'. It seems to mostly about reconciliation and accepting failure. More somber than the others, and the most dated.")

/obj/item/fluff/cress_book/attack_self(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message(SPAN_NOTICE("[user] begins searching through \the [src]'s pages..."))
	if(do_after(user, 25))
		to_chat(user, SPAN_NOTICE("You pick out a song in the folder and read the lyrics: [pick(lyrics)]"))


/obj/item/clothing/accessory/poncho/fluff/ozuha_cape //Victory Cape - Skavoss Ozuha - dronzthewolf
	name = "victory cape"
	desc = "A finely crafted cape that combines Ozuha clan colors and Izweski nation colors, with inscriptions on the decorative brass paldrons reading something in Sinta'Unathi."
	icon = 'icons/obj/custom_items/ozuha_cape.dmi'
	icon_override = 'icons/obj/custom_items/ozuha_cape.dmi'
	icon_state = "ozuha_cape"
	item_state = "ozuha_cape"
	contained_sprite = TRUE


/obj/item/device/megaphone/fluff/akinyi_mic //Resonance Microphone - Akinyi Idowu - kyres1
	name = "resonance microphone"
	desc = "A rather costly voice amplifier disguised as a microphone. A button on the side permits the user to dial their vocal volume with ease."
	icon = 'icons/obj/custom_items/akinyi_symphette.dmi'
	icon_override = 'icons/obj/custom_items/akinyi_symphette.dmi'
	icon_state = "akinyi_mic"
	item_state = "akinyi_mic"
	w_class = WEIGHT_CLASS_SMALL
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
	w_class = WEIGHT_CLASS_SMALL
	contained_sprite = TRUE
	var/obj/item/device/megaphone/fluff/akinyi_mic/mic
	var/collapsed = TRUE

/obj/item/fluff/akinyi_stand/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/device/megaphone/fluff/akinyi_mic))
		if(!mic && !collapsed)
			user.unEquip(attacking_item)
			attacking_item.forceMove(src)
			mic = attacking_item
			to_chat(user, SPAN_NOTICE("You place \the [attacking_item] on \the [src]."))
			update_icon()

/obj/item/fluff/akinyi_stand/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if((over == user && (!use_check(over))) && (over.contents.Find(src) || in_range(src, over)))
		if(ishuman(over))
			var/mob/living/carbon/human/H = over
			forceMove(get_turf(H))
			H.put_in_hands(src)
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
		w_class = WEIGHT_CLASS_BULKY
		collapsed = FALSE
	else
		w_class = WEIGHT_CLASS_SMALL
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
	w_class = WEIGHT_CLASS_BULKY
	contained_sprite = TRUE
	storage_slots = 3
	max_w_class = WEIGHT_CLASS_NORMAL
	can_hold = list(
		/obj/item/device/megaphone/fluff/akinyi_mic,
		/obj/item/fluff/akinyi_stand,
		/obj/item/device/synthesized_instrument/guitar/multi/fluff/akinyi_symphette
		)
	starts_with = list(
		/obj/item/device/megaphone/fluff/akinyi_mic = 1,
		/obj/item/fluff/akinyi_stand = 1,
		/obj/item/device/synthesized_instrument/guitar/multi/fluff/akinyi_symphette = 1
	)


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

/obj/item/clothing/suit/storage/toggle/para_jacket/fluff/akila_jacket //Reflective paramedic Jacket - Akila Aksha'Shalwariran - shestrying
	name = "reflective paramedic jacket"
	desc = "A jacket in an eye-blinding yellow, with flourescent green, light-reflective striping along the cuffs and bottom edge. A bright red cross rests on the front, over the heart."
	icon = 'icons/obj/custom_items/akila_jacket.dmi'
	icon_override = 'icons/obj/custom_items/akila_jacket.dmi'
	icon_state = "akila_jacket"
	item_state = "akila_jacket"
	contained_sprite = TRUE

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
		playsound(loc, /singleton/sound_category/quick_arcade, 60)
		last_sound = world.time
		return
	return ..()

/obj/item/fluff/holoconsole/attackby(obj/item/attacking_item, mob/user, params)
	switch(attacking_item.type)
		if(/obj/item/fluff/holoconsole_controller)
			if(left_controller)
				to_chat(user, SPAN_WARNING("\The [src] already has its left controller connected!"))
				return
			user.visible_message("<b>[user]</b> slots \the [attacking_item] back into to \the [src].", SPAN_NOTICE("You slot \the [attacking_item] back into \the [src]."))
			user.drop_from_inventory(attacking_item, src)
			left_controller = attacking_item
			left_controller.parent_console = null
			verbs += /obj/item/fluff/holoconsole/proc/remove_left
			update_icon()
			return
		if(/obj/item/fluff/holoconsole_controller/r)
			if(right_controller)
				to_chat(user, SPAN_WARNING("\The [src] already has its right controller connected!"))
				return
			user.visible_message("<b>[user]</b> slots \the [attacking_item] back into to \the [src].", SPAN_NOTICE("You slot \the [attacking_item] back into \the [src]."))
			user.drop_from_inventory(attacking_item, src)
			right_controller = attacking_item
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
		AddOverlays(screen)
	else
		playsound(loc, 'sound/machines/synth_no.ogg', 50)
		CutOverlays(screen)
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
		playsound(H.loc, /singleton/sound_category/quick_arcade, 60)
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

/obj/item/fluff/holocase/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/fluff/holoconsole))
		if(contained_console)
			to_chat(user, SPAN_WARNING("\The [src] already contains a holoconsole!"))
			return
		user.drop_from_inventory(attacking_item, src)
		contained_console = attacking_item
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


/obj/item/clothing/accessory/poncho/tajarancloak/fancy/fluff/valetzrhonaja_cloak //Nayrragh'Rakhan Cloak - Valetzrhonaja Nayrragh'Rakhan - ramke
	name = "nayrragh'rakhan cloak"
	desc = " A worn, black cloak with golden adornments decorating the edges of the fabric. The insignia of the Nayrragh'Rakhan family is embedded into the custom pin holding the cloak \
	together, and each shoulder is decorated by the representation of a yellow or blue sun - the symbols of S'rendarr and Messa. The fabric is faded, having clearly been tested by time."
	icon = 'icons/obj/custom_items/valetzrhonaja_cloak.dmi'
	icon_override = 'icons/obj/custom_items/valetzrhonaja_cloak.dmi'
	icon_state = "valetzrhonaja_cloak"
	item_state = "valetzrhonaja_cloak"
	contained_sprite = TRUE

/obj/item/flag/fluff/bian_flag //Coalition Fisanduh Unity Flag - Bian Quy Le - persephoneq
	name = "large coalition fisanduh unity flag"
	desc = "A well-loved flag often seen hung by those advocating for Fisanduh's legitimization and acceptance into the Coalition of Colonies."
	icon = 'icons/obj/custom_items/bian_flag.dmi'
	icon_override = 'icons/obj/custom_items/bian_flag.dmi'
	icon_state = "bian_flag"
	flag_path = "fisanduh_coalition"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/fisanduh_coalition

/obj/structure/sign/flag/fisanduh_coalition
	name = "large coalition fisanduh unity flag"
	desc = "A well-loved flag often seen hung by those advocating for Fisanduh's legitimization and acceptance into the Coalition of Colonies."
	icon = 'icons/obj/custom_items/bian_flag.dmi'
	flag_path = "fisanduh_coalition"
	flag_item = /obj/item/flag/fluff/bian_flag
	flag_size = TRUE


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

/obj/item/storage/pill_bottle/dice/fluff/suraya_dicebag //Crevan Dice Bag - Suraya Al-Zahrani - omicega
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

/obj/item/organ/internal/augment/synthetic_cords/voice/fluff/marc //Old Synthetic Vocal Cords - Marc Hardy - dekser
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


/obj/item/clothing/accessory/poncho/shouldercape/qeblak/zeng/fluff/eden_cloak // Zeng-Hu Nralakk division cloak - Eden Li - huntime
	name = "\improper Zeng-Hu cloak: Nralakk division"
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

/obj/item/fluff/nasira_burner/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(lit)
		. += "\The [src] is currently lit."

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

/obj/item/fluff/nasira_burner/attackby(obj/item/attacking_item, mob/user, params)
	..()
	if(attacking_item.isFlameSource())
		var/text = matchmsg
		if(istype(attacking_item, /obj/item/flame/match))
			text = matchmsg
		else if(istype(attacking_item, /obj/item/flame/lighter/zippo))
			text = zippomsg
		else if(istype(attacking_item, /obj/item/flame/lighter))
			text = lightermsg
		else if(attacking_item.iswelder())
			text = weldermsg
		else if(istype(attacking_item, /obj/item/device/assembly/igniter))
			text = ignitermsg
		else
			text = genericmsg
		text = replacetext(text, "USER", "\the [user]")
		text = replacetext(text, "NAME", "\the [name]")
		text = replacetext(text, "FLAME", "\the [attacking_item.name]")
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
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("bittersweetness, insect meat and regret" = 1))
	bitesize = 1

/obj/item/reagent_containers/food/snacks/fluff/taffy/pink
	name = "pink taffy"
	icon_state = "pink_taffy"
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness and a hint of strawberry" = 1))

/obj/item/reagent_containers/food/snacks/fluff/taffy/blue
	name = "blue taffy"
	icon_state = "blue_taffy"
	reagent_data = list(/singleton/reagent/nutriment = list("salty-sweet, tangy taffy" = 1))


/obj/item/clothing/suit/storage/fluff/aheke_coat //Hengsha Thermal Coat - Aheke Han'san - hawkington
	name = "hengsha thermal coat"
	desc = "A very heavy, well padded, and generally quite large grey overcoat, probably made for an Unathi, made out of a rather stiff, almost leathery type substance. With a brown synthetic fur \
	collar and even more fleecing inside. Interestingly enough, there does not seem to be an easy way of closing it. Emblazoned on the back in large, red letters is \"K6\"."
	icon = 'icons/obj/custom_items/aheke_coat.dmi'
	icon_override = 'icons/obj/custom_items/aheke_coat.dmi'
	icon_state = "aheke_coat"
	item_state = "aheke_coat"
	contained_sprite = TRUE

/obj/item/flag/fluff/ahzi_flag //Unathi Fleet Flag - Ankala Ahzi - captaingecko
	name = "unathi fleet flag"
	desc = "A flag bearing the easily recognizable iconography of the Unathi fleets, this one depicting a Sinta slain by spears under an omniscient, uncaring eye."
	icon = 'icons/obj/custom_items/ahzi_items.dmi'
	icon_override = 'icons/obj/custom_items/ahzi_items.dmi'
	icon_state = "ahzi_flag"
	flag_path = "unathi_fleet"
	flag_structure = /obj/structure/sign/flag/unathi_fleet

/obj/structure/sign/flag/unathi_fleet
	name = "unathi fleet flag"
	desc = "A flag bearing the easily recognizable iconography of the Unathi fleets, this one depicting a Sinta slain by spears under an omniscient, uncaring eye."
	icon = 'icons/obj/custom_items/ahzi_items.dmi'
	icon_state = "unathi_fleet"
	flag_path = "unathi_fleet"
	flag_item = /obj/item/flag/fluff/ahzi_flag

/obj/item/flag/fluff/ahzi_flag/l
	name = "large unathi fleet flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/unathi_fleet/large

/obj/structure/sign/flag/unathi_fleet/large
	icon_state = "unathi_fleet_l"
	flag_path = "unathi_fleet"
	flag_size = TRUE
	flag_item = /obj/item/flag/fluff/ahzi_flag/l

/obj/item/clothing/accessory/armband/fluff/ahzi_armband //Unathi Fleet Armband - Ankala Ahzi - captaingecko
	name = "unathi fleet armband"
	desc = "An armband bearing the easily recognizable iconography of the Unathi fleets, this one depicting a Sinta slain by spears under an omniscient, uncaring eye."
	icon = 'icons/obj/custom_items/ahzi_items.dmi'
	icon_override = 'icons/obj/custom_items/ahzi_items.dmi'
	icon_state = "ahzi_armband"
	item_state = "ahzi_armband"
	contained_sprite = TRUE


/obj/item/fluff/ielia_tarot //Starfinder - Ielia Aliori-Quis'Naala - shestrying
	name = "starfinder"
	desc = "A small, bronze ball. It is heavy in the hand and seems to have no switches or buttons on it. "
	icon = 'icons/obj/custom_items/ielia_tarot.dmi'
	icon_override = 'icons/obj/custom_items/ielia_tarot.dmi'
	icon_state = "ielia_tarot"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	var/list/possible_cards = list("Island","Hatching Egg","Star Chanter","Jiu'x'klua","Stormcloud","Gnarled Tree","Poet","Bloated Toad","Void","Qu'Poxii","Fisher","Mountain","Sraso","Nioh")
	var/activated = FALSE
	var/first_card
	var/second_card
	var/third_card

/obj/item/fluff/ielia_tarot/attack_self(var/mob/user)
	if(activated)
		reset_starfinder()
	else
		start_starfinder()

/obj/item/fluff/ielia_tarot/AltClick(mob/user)
	attack_self(user)

/obj/item/fluff/ielia_tarot/verb/start_starfinder()
	set name = "Start the Starfinder"
	set category = "Object"
	set src in view(1)

	if(activated)
		return

	if(use_check_and_message(usr, USE_DISALLOW_SILICONS))
		return

	first_card = null
	second_card = null
	third_card = null

	icon_state = "ielia_tarot_on"
	ClearOverlays()

	usr.visible_message("\The [usr] activates the [src].")
	flick ("card_spawn",src)
	activated = TRUE

	icon_state = "card_spin"
	AddOverlays("card_spin_fx")
	addtimer(CALLBACK(src, PROC_REF(finish_selection), usr), 3 SECONDS)

/obj/item/fluff/ielia_tarot/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 1)
		if(first_card && second_card && third_card)
			. += "The following constellations are displayed on the starfinder: [first_card], [second_card], and [third_card]."

/obj/item/fluff/ielia_tarot/proc/finish_selection(var/mob/user)
	ClearOverlays()
	flick("card_spin_stop",src)
	icon_state = "ielia_tarot_on"
	for(var/i = 1 to 3)
		var/P = pick(possible_cards)
		if(!first_card)
			first_card = P
		else if(first_card && !second_card)
			second_card = P
		else if(first_card && second_card)
			third_card = P

	ClearOverlays()
	AddOverlays("card_display_fx")
	AddOverlays("card_display")

	var/image/first_card_overlay = image(icon, src, first_card)
	first_card_overlay.pixel_x = -8
	AddOverlays(first_card_overlay)

	var/image/second_card_overlay = image(icon, src, second_card)
	AddOverlays(second_card_overlay)

	var/image/third_card_overlay = image(icon, src, third_card)
	third_card_overlay.pixel_x = 8
	AddOverlays(third_card_overlay)

/obj/item/fluff/ielia_tarot/proc/reset_starfinder()
	if(!activated)
		return
	ClearOverlays()
	icon_state = "ielia_tarot"
	activated = FALSE


/obj/item/clothing/suit/storage/fluff/osborne_suit //Dominian Officers Trench Coat - Osborne Strelitz - sirtoast
	name = "dominian officer's trench coat"
	desc = "An Imperial Army trench coat that is used by Dominian officers in colder environments. This one is missing the unit insignia and has the symbol of a military count on its rank collar."
	icon = 'icons/obj/custom_items/osborne_suit.dmi'
	icon_override = 'icons/obj/custom_items/osborne_suit.dmi'
	icon_state = "osborne_suit"
	item_state = "osborne_suit"
	contained_sprite = TRUE


/obj/item/storage/box/fancy/cigarettes/cigar/brianne_cigarettes //Martian Cigarette Case - Sean Brianne - zelmana
	name = "martian cigarette case"
	desc = "A small, personal cigarette tin. It holds cigarettes similar to a cigarette packet but has some nice flair."
	icon = 'icons/obj/custom_items/brianne_items.dmi'
	icon_override = 'icons/obj/custom_items/brianne_items.dmi'
	icon_state = "brianne_cigarettes"
	item_state = "brianne_cigarettes"
	icon_type = "cigarette"
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette/dromedaryco)
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/dromedaryco
	contained_sprite = TRUE


/obj/item/clothing/glasses/sunglasses/fluff/lyod_snowglasses //Lyod snowglasses - Ravna Surtaeva - sycmos
	name = "\improper Lyod snowglasses"
	desc = "A pair of protective glasses hand-sculpted of reindeer antler, intended for use in arctic climates to protect from snow blindness."
	icon = 'icons/obj/custom_items/ravna_items.dmi'
	icon_override = 'icons/obj/custom_items/ravna_items.dmi'
	icon_state = "ravna_sunglasses"
	item_state = "ravna_sunglasses"
	contained_sprite = TRUE
	flash_protection = FLASH_PROTECTION_NONE

/obj/item/clothing/suit/storage/toggle/fluff/prejoroub_fur_longcoat //Prejoroub Fur Longcoat - Ravna Surtaeva - sycmos
	name = "prejoroub fur longcoat"
	desc = "A dense and heavy longcoat of dyed tenelote leather, with a liner and collar of prejoroub fur and decorative trimming throughout."
	icon = 'icons/obj/custom_items/ravna_items.dmi'
	icon_override = 'icons/obj/custom_items/ravna_items.dmi'
	icon_state = "ravna_coat"
	item_state = "ravna_coat"
	contained_sprite = TRUE


/obj/item/clothing/suit/armor/carrier/fluff/abbasi_carrier //Medinan Mercenary's Plate Carrier - Shirin Abbasi - persephoneq
	name = "medinan mercenary's plate carrier"
	desc = "A flashy and apparently well-made plate carrier. This one seems well-maintained, if quite worn-in. It's design is reminiscent of the ornate and intricate patterns of \
	Medinan make, though someone has written various colorful epithets such as 'AIM HERE' over the heart and 'KICK ME' on the back in Elyran Standard. A patch on the center depicts a \
	golden jackal with a challenging and cheerful grin, a chunk of phoron held between it's teeth. On the left shoulder, a much newer patch is sewn in depicting the insignia of the \
	SCC Chainlink. Beneath it is stitched 'ABBASI'."
	icon = 'icons/obj/custom_items/abbasi_carrier.dmi'
	icon_override = 'icons/obj/custom_items/abbasi_carrier.dmi'
	icon_state = "abbasi_carrier"
	item_state = "abbasi_carrier"
	contained_sprite = TRUE


/obj/item/clothing/suit/storage/toggle/fluff/freedom_coat //Renewed Antiquated Labcoat - Freedom Of Self Shackled By Unending Greed - lmwevil
	name = "renewed antiquated labcoat"
	desc = "An ancient labcoat from the Narrows, recently revitalized with extreme tailoring to become a symbol of unity between the Conglomerate and Dionae across the spur after the \
	allowance of Dionae as Executive Officers aboard the Horizon. It must have cost a substantial sum to fix the century old labcoat back up to scratch. On the left arm is a beautifully \
	sewn on patch that reads \"A block\"."
	icon = 'icons/obj/custom_items/freedom_coat.dmi'
	icon_override = 'icons/obj/custom_items/freedom_coat.dmi'
	icon_state = "freedom_coat"
	item_state = "freedom_coat"
	contained_sprite = TRUE

/obj/item/clothing/head/fluff/schlosser_hat // National Defense Force Schiffchen - Schlosser - NewOriginalSchwann
	name = "national defense force schiffchen"
	desc = "A side cap known as a Schiffchen on Visegrad, a term roughly translating to \"little boat\" in Basic, which is commonly worn by members of the Visegradi National Defense Force. The NDF’s symbol – a silver fortress standing upon a crimson background – is prominently featured on the Schiffchen’s badge. “Totschlager” has been written on the inside of the band by somebody with a marker."
	desc_extended = "The Schiffchen has a long, storied, and somewhat controversial history upon Visegrad, which dates back to its initial colonization. The planet’s first security service, the Visegradi People’s Security Service, used the Schiffchen as its standard headwear for security personnel in an effort to invoke \
	the Warsaw Pact’s security services. Following its dissolution the National Defense Force continued to use the Schiffchen as headwear, and it remains a common sight on Visegrad today even if the NDF, which was dissolved by the Navy shortly after the Solarian Collapse, no longer exists."
	icon = 'icons/obj/custom_items/schlosser_hat.dmi'
	icon_override = 'icons/obj/custom_items/schlosser_hat.dmi'
	icon_state = "schlosser_hat"
	item_state = "schlosser_hat"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/konyang/dbjacket/provenance_jacket // Double-Breasted Cropped Jacket - Z.I Provenance - niennab
	name = "double-breasted cropped jacket"
	desc = "Styled after the latest fashion trends on Konyang, this hybrid leather and polyester mesh jacket was built with the planet’s humid climate in mind. This particular jacket appears to be emblematic of Konyang's stylings but hand-made, sporting a distinctive fur collar."
	icon = 'icons/obj/custom_items/provenance_jacket.dmi'
	icon_override = 'icons/obj/custom_items/provenance_jacket.dmi'
	icon_state = "provenance_coat"
	item_state = "provenance_coat"

/obj/item/voidsuit_modkit/fluff/ashkii_suit
	name = "Squall voidsuit kit"
	icon = 'icons/obj/custom_items/ashkii_items.dmi'
	icon_state = "ashkii_modkit"
	desc = "A simple cardboard box containing the requisition forms, permits, and decal kits for a squall voidsuit."
	suit_options = list(
		/obj/item/clothing/suit/space/void/engineering = /obj/item/clothing/suit/space/void/engineering/fluff/ashkii_suit,
		/obj/item/clothing/head/helmet/space/void/engineering = /obj/item/clothing/head/helmet/space/void/engineering/fluff/ashkii_helm)

/obj/item/clothing/head/helmet/space/void/engineering/fluff/ashkii_helm //Squall Voidsuit Helmet - Ashkii Yeongseon - hawkington
	name = "squall helmet"
	desc = "A voidsuit helmet seemingly made out of plasteel. A respirator lines the bottom which gives somewhat less airflow that one would expect. It has an enhanced communications \
	receiver on one side and a gyroscope system on the other; loose wires trailing out of both systems. The four yellow eyes give it a uniquely aggressive look similar to that of the \
	hakhma beetle. \"Property of Engineering Department\" is handwritten on the side in small orange text. Next to a small logo of Hephaestus"
	icon = 'icons/obj/custom_items/ashkii_items.dmi'
	icon_override = 'icons/obj/custom_items/ashkii_items.dmi'
	icon_state = "ashkii_helm"
	item_state = "ashkii_helm"
	contained_sprite = TRUE

/obj/item/clothing/suit/space/void/engineering/fluff/ashkii_suit //Squall Voidsuit - Ashkii Yeongseon - hawkington
	name = "squall voidsuit"
	desc = "A voidsuit that has been bedecked in the Yeongseon colours, namely navy. The entire thing is custom built out of spraypainted plating and a much softer synthleather \
	underlayer; networks of tiny tubes carrying coolant liquids are laminated between the fabric layers. These active cooling systems help regulate the temperature inside the suit. \
	There is particular padding around the joints and spine. Notably a series of dark-brown cables pulled taut around the legs brace them somewhat. While metal reinforcements that \
	resemble a ribcage surround the chestpiece and form into a \"Spine\" on the back. A Hephaestus brand wristbound has been integrated into the forearm of the suit, it's capable of \
	controlling the levels of cooling and the rigidity of the spinal support system. It looks comfortable for a voidsuit."
	icon = 'icons/obj/custom_items/ashkii_items.dmi'
	icon_override = 'icons/obj/custom_items/ashkii_items.dmi'
	icon_state = "ashkii_suit"
	item_state = "ashkii_suit"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/hooded/wintercoat/fluff/ashkii_cloak //Refurbished SLS Cloak - Ashkii Yeongseon - hawkington
	name = "refurbished sls cloak"
	desc = "A black cloak with a notable grey and orange plastic trim. The bulk of it is made out of a number of nanoceramic fibres giving it a distinctly synthetic sheen particularly \
	in bright light. Some tiny and worn white writing on the side and the hood mark it as the property of \"Spur Logistical Solutions\" a small cargo company that went bankrupt years ago."
	icon = 'icons/obj/custom_items/ashkii_items.dmi'
	icon_override = 'icons/obj/custom_items/ashkii_items.dmi'
	icon_state = "ashkii_cloak"
	item_state = "ashkii_cloak"
	contained_sprite = TRUE

/obj/item/device/versebook/fluff/guilty_men
	name = "Guilty Men"
	desc = "A leather bound book bearing a burning Coalition of Colonies flag. \"Guilty Men\" and \"How the Coalition of Colonies and its leaders failed the Frontier\" are engraved on golden plaques on either side of the flag. A controversial book published several years ago, \"Guilty Men\" is acclaimed by some as a scathing rebuke of failed Coalition policies, and their intolerable results, and condemned by others as a radical break from traditional Coalition attitudes and values. This example is worn, with its pages dog-eared and torn in numerous places, while the leather binding has begun to crack and discolor under frequent handling."
	icon = 'icons/obj/custom_items/imogen_items.dmi'
	icon_state = "Guilty_Men"
	item_state = "book"

/obj/item/device/versebook/fluff/guilty_men/Initialize()
	. = ..()
	randomquip = file2list("code/modules/customitems/imogen_guiltymen.txt")

/obj/item/rig/light/offworlder/fluff/aayun
	name = "command exo-stellar skeleton module"
	suit_type = "exo-stellar skeleton"
	desc = "A prototype, exo-stellar skeleton suit finished in SCC blue and gold, evidently built for someone in authority. Made of extremely expensive and custom-made parts, and bears an integrated golden metal scarf as a fashion statement."
	desc_extended = "A prototype exo-stellar skeleton suit, made of extremely expensive, custom-made and proprietary parts, allowing for the comfortable existence of an off-worlder in normal worlder conditions. \
	Features microdoses of medicine in the air supply to aid in lung pain, electrostimulants to assist in muscle rehabilitation, and innumerable other features. Unfortunately, due to design limitations, \
	it is only capable of maintaining a lower internal pressure when exposed to normal environments, and is not spaceworthy nor immune to environmental conditions. This particular model bears a small mark \
	of Zeng-Hu Pharmaceuticals on the main back piece, and was largely designed by a collaborative effort of experts in their fields on the Horizon. A new future for off-worlders, or a money pit?"
	icon = 'icons/obj/custom_items/aayun_suit.dmi'
	icon_state = "aayun_rig"
	helm_type = /obj/item/clothing/head/lightrig/offworlder
	chest_type = /obj/item/clothing/suit/lightrig/offworlder
	glove_type = /obj/item/clothing/gloves/lightrig
	boot_type = /obj/item/clothing/shoes/lightrig

/obj/item/clothing/accessory/poncho/fluff/devorask_coat //Daunting trenchcoat - Osisra Devorask - nkomaeda
	name = "daunting trenchcoat"
	desc = "A long and broad trenchcoat, made of sturdy fabrics. A logo is tailored on the back, showing a silver Unathi knight's helmet with red horns."
	icon = 'icons/obj/custom_items/devorask_items.dmi'
	icon_override = 'icons/obj/custom_items/devorask_items.dmi'
	icon_state = "devorask_coat"
	item_state = "devorask_coat"
	contained_sprite = TRUE

/obj/item/flag/fluff/devorask_flag //Devorask clan flag - Osisra Devorask - nkomaeda
	name = "devorask clan flag"
	desc = "A brightly coloured flag, displaying a silver Unathi knight's helmet with red horns on a typical Ouerean backdrop. Five golden rings are shown on the flag, representing the tenets of the Devorask clan."
	flag_path = "devorask_flag"
	flag_structure = /obj/structure/sign/flag/devorask_flag

/obj/structure/sign/flag/devorask_flag
	name = "devorask clan flag"
	desc = "A brightly coloured flag, displaying a silver Unathi knight's helmet with red horns on a typical Ouerean backdrop. Five golden rings are shown on the flag, representing the tenets of the Devorask clan."
	icon = 'icons/obj/custom_items/devorask_items.dmi'
	icon_state = "devorask_flag"
	flag_path = "devorask_flag"
	flag_item = /obj/item/flag/fluff/devorask_flag
	desc_extended = "The Devorask clan is a Ouerean group running anti-piracy operations in Uueoa-Esa space. Though not too well-known, their title of 'The Daunting' has \
	come up in news and communication during the Months of Blood, where members of the clan and group as a whole ran peacekeeping operations at public services, \
	such as hospitals, power plants and spaceports. The Devorask clan, and the general crew of The Daunting, is currently working together with the Dagamuir \
	Freewater Private Forces. Neatly and precisely tailored in Sinta'Unathi on the five rings, in order from left to right, are 'Overwhelming force to \
	minimize risk', 'Clarity of Intent', 'Defend the Defenceless', 'Fear is Power' and 'Master your Tools'."

/obj/item/flag/fluff/devorask_flag/l
	name = "devorask clan flag"
	flag_size = TRUE
	flag_structure = /obj/structure/sign/flag/devorask_flag/large

/obj/structure/sign/flag/devorask_flag/large
	icon_state = "devorask_flag_l"
	flag_path = "devorask_flag"
	flag_size = TRUE
	flag_item = /obj/item/flag/fluff/devorask_flag/l

/obj/item/organ/external/arm/fluff/gracia_autakh // gracia's aut'akh left arm - Gracia Hiza - cometblaze
	robotize_type = PROSTHETIC_AUTAKH
	skin_color = FALSE
	override_robotize_force_icon = 'icons/mob/human_races/fluff/gracia_arm.dmi'
	override_robotize_painted = FALSE
	robotize_children = FALSE

/obj/item/organ/external/arm/fluff/gracia_autakh/Initialize(mapload)
	. = ..()
	// adding the hand to the child here means only the arm has to be added to the DB
	// since the hand will be attached automatically
	LAZYADD(children, new /obj/item/organ/external/hand/fluff/gracia_autakh(src))

/obj/item/organ/external/hand/fluff/gracia_autakh // gracia's aut'akh left hand - Gracia Hiza - cometblaze
	robotize_type = PROSTHETIC_AUTAKH
	skin_color = FALSE
	override_robotize_force_icon = 'icons/mob/human_races/fluff/gracia_arm.dmi'
	override_robotize_painted = FALSE
	robotize_children = FALSE

/obj/item/clothing/suit/storage/toggle/fluff/tokash_mantle //Consular Mantle - Suvek Tokash - Evandorf
	name = "consular's mantle"
	desc = "A long, ornate, and somewhat extravagant cloak-like mantle. Fashioned with Hegemony colors, it serves as a symbol of the wearer's station and allegiance. Scenes of Unathi history and legend etched into the golden crest surmount the trailing, blood-red fabric. "
	icon = 'icons/obj/custom_items/tokash_mantle.dmi'
	icon_override = 'icons/obj/custom_items/tokash_mantle.dmi'
	icon_state = "tokash_mantle"
	item_state = "tokash_mantle"
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/fluff/kira_carrier //mictlan plate carrier adjustments - Kira Vazquez - Dessysalta
	name = "mictlan plate carrier adjustments"
	desc = "Various pieces of custom-made accessories and adjustments to better suit a plate carrier for its wearer. It has various notes scrawled along it in permanent marker, mostly \
	in Tradeband and Spanish, such as the verse of Ephesians 6:13 and, 'Wishing you well!' The SCC's logo has been woven around the left arm flap, and Mictlan's flag \
	around the right. The back reads K. VAZQUEZ in bold text."
	icon = 'icons/obj/custom_items/kira_carrier.dmi'
	icon_override = 'icons/obj/custom_items/kira_carrier.dmi'
	icon_state = "kira_carrier"
	item_state = "kira_carrier"
	contained_sprite = TRUE

/obj/item/organ/external/leg/right/fluff/nines_autakh // Prosthetic Aut'akh Left Leg - Hazel #S-H9.09 - hazelmouse
	robotize_type = PROSTHETIC_AUTAKH
	skin_color = FALSE
	override_robotize_force_icon = 'icons/mob/human_races/fluff/nines_leg.dmi'
	override_robotize_painted = FALSE
	robotize_children = FALSE

/obj/item/organ/external/leg/right/fluff/nines_autakh/Initialize(mapload)
	. = ..()
	LAZYADD(children, new /obj/item/organ/external/foot/right/fluff/nines_autakh(src))

/obj/item/organ/external/foot/right/fluff/nines_autakh // Prosthetic Aut'akh Left Foot - Hazel #S-H9.09 - hazelmouse
	robotize_type = PROSTHETIC_AUTAKH
	skin_color = FALSE
	override_robotize_force_icon = 'icons/mob/human_races/fluff/nines_leg.dmi'
	override_robotize_painted = FALSE
	robotize_children = FALSE
