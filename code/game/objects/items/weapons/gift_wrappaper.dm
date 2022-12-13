/* Gifts and wrapping paper
 * Contains:
 *		Gifts
 *		X-mas Gifts
 */

/*
 * Gifts
 */
/obj/item/a_gift
	name = "gift"
	desc = "PRESENTS!!!! eek!"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_state = "gift1"
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/a_gift/New()
	..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	if(w_class > 0 && w_class < ITEMSIZE_LARGE)
		icon_state = "gift[w_class]"
	else
		icon_state = "gift[pick(1, 2, 3)]"
	return

/obj/item/gift/attack_self(mob/user as mob)
	user.drop_item()
	playsound(src.loc, 'sound/items/package_unwrap.ogg', 50,1)
	if(src.gift)
		user.put_in_hands(gift)
		src.gift.add_fingerprint(user)
	else
		to_chat(user, "<span class='warning'>The gift was empty!</span>")
	qdel(src)
	return

/obj/item/a_gift/ex_act(var/severity = 2.0)
	qdel(src)
	return

/obj/effect/spresent/relaymove(mob/user as mob)
	if (user.stat)
		return
	to_chat(user, "<span class='warning'>You can't move.</span>")

/obj/effect/spresent/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if (!W.iswirecutter())
		to_chat(user, "<span class='warning'>I need wirecutters for that.</span>")
		return

	to_chat(user, "<span class='notice'>You cut open the present.</span>")

	for(var/mob/M in src) //Should only be one but whatever.
		M.forceMove(src.loc)
		if (M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

	qdel(src)

/obj/item/a_gift/attack_self(mob/M as mob)
	var/gift_type = pick(
		/obj/item/storage/wallet,
		/obj/item/storage/photo_album,
		/obj/item/storage/box/snappops,
		/obj/item/storage/box/fancy/crayons,
		/obj/item/storage/backpack/holding,
		/obj/item/storage/belt/champion,
		/obj/item/soap/deluxe,
		/obj/item/pickaxe/silver,
		/obj/item/pen/invisible,
		/obj/item/lipstick/random,
		/obj/item/grenade/smokebomb,
		/obj/item/corncob,
		/obj/item/contraband/poster,
		/obj/item/book/manual/barman_recipes,
		/obj/item/book/manual/chef_recipes,
		/obj/item/bikehorn,
		/obj/item/beach_ball,
		/obj/item/beach_ball/holoball,
		/obj/item/toy/waterballoon,
		/obj/item/toy/blink,
		/obj/item/toy/crossbow,
		/obj/item/gun/projectile/revolver/capgun,
		/obj/item/toy/katana,
		/obj/item/toy/prize/deathripley,
		/obj/item/toy/prize/durand,
		/obj/item/toy/prize/fireripley,
		/obj/item/toy/prize/gygax,
		/obj/item/toy/prize/honk,
		/obj/item/toy/prize/marauder,
		/obj/item/toy/prize/mauler,
		/obj/item/toy/prize/odysseus,
		/obj/item/toy/prize/phazon,
		/obj/item/toy/prize/ripley,
		/obj/item/toy/prize/seraph,
		/obj/item/toy/spinningtoy,
		/obj/item/toy/sword,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiadeus,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiavulgaris,
		/obj/item/device/paicard,
		/obj/item/device/violin,
		/obj/item/storage/belt/utility/full,
		/obj/item/clothing/accessory/horrible)

	if(!ispath(gift_type,/obj/item))	return

	var/obj/item/I = new gift_type(M)
	M.remove_from_mob(src)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	qdel(src)
	return

/*
 * Wrapping Paper
 */

/*
 * Xmas Gifts
 */
/obj/item/xmasgift
	name = "christmas gift"
	desc = "PRESENTS!!!! eek!"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_state = "gift"
	w_class = ITEMSIZE_TINY
	randpixel = 12
	var/gift_type

/obj/item/xmasgift/Initialize()
	..()
	randpixel_xy()
	var/gift_benefactor = pick("the NanoTrasen Department of Christmas Affairs", "Miranda Trasen", "Joseph Dorne", "Isaac Asimov", "Baal D. Griffon", "the Sol Alliance (Sorry about the blockade!)",
		"Hephaestus Industries", "Idris Incorporated", "Glorsh Omega II", "the Nralakk Federation", "the People's Republic of Adhomai", "the Adhomai Liberation Army", "the Izweski Hegemony",
		"the Zo'ra Hive","the Coalition of Colonies", "Digital Dingo", "Optimum Jeffrey", "Lemmy and the Clockworks", "President Hadii", "King Azunja","Supreme Commander Nated'Hakhan",
		"Lord-Regent Not'zar","Jesus Christ","Santa Claus","Mrs. Claus","Sandy Claws","Buddha","Gary","Jesus Christ!","the True Queen of Biesel, God-Lady Seon-rin von Illdenberg, First of Her Name",
		"Admiral Frost","Pirate King Frost", "The Secret NanoTrasen Cabal of Duty Officers", "The Society for the Preservation of Rats", "Officer Beepsky","Lieutenant Columbo","Crew of the NSS Upsilon","Runtime",
		"Bones","Chauncey","Ian","Pun Pun","Nup Nup","Waldo","Odlaw","Crew of the NSS Exodus", "Custodial Staff of the NTCC Odin","ERT Phoenix","grey slime (357)","Bob the Blob","People for the Ethical Treatment of Bluespace Bears",
		"Mr. Clown and Mrs. Mime from New Puerto Rico","the Grinch","the Krampus","Satan","Mega-Satan","<span class='danger'>\[BENEFACTOR REDACTED]\</span>","Bluespace Cat","Union of Bluespace Technicians Tau Ceti","the New Kingdom of Adhomai",
		"Ginny", "Boleslaw Keesler", "The Queen in Blue", "Cuban Pete", "Ceres' Lance", "the real Odin Killer (Still out here, guys!)", "the K'lax Hive", "the C'thur Hive")
	var/pick_emotion = pick("love","platonic admiration","approval","love (not in a sexual way or anything, though)","apathy", "schadenfreude","love","God's blessing","Santa's blessing","Non-demoninational deity's blessing","love","compassion","appreciation",
		"respect","begrudging respect","love", "seasonal obligation")
	desc = "To: <i>The [station_name()]</i><BR>From: <i>[gift_benefactor], with [pick_emotion]</i>"

	if(!gift_type)
		gift_type = get_gift_type()

	if(ispath(gift_type, /mob/living/simple_animal))
		if(ispath(gift_type, /mob/living/simple_animal/schlorrgo))
			icon_state = "strangeschlorrgo"
		else
			icon_state = "strangepet"

	return

/obj/item/xmasgift/proc/get_gift_type()
	var/picked_gift_type = pick(
		/obj/random/action_figure,
		/obj/random/coin,
		/obj/random/spacecash,
		/obj/random/glowstick,
		/obj/random/gloves,
		/obj/random/wizard_dressup,
		/obj/item/storage/wallet,
		/obj/item/storage/photo_album,
		/obj/item/storage/box/snappops,
		/obj/item/storage/box/fancy/crayons,
		/obj/item/soap/deluxe,
		/obj/item/pen/invisible,
		/obj/item/clothing/wrists/watch,
		/obj/item/lipstick/random,
		/obj/item/clothing/shoes/carp,
		/obj/item/bikehorn,
		/obj/item/toy/waterballoon,
		/obj/item/toy/blink,
		/obj/item/gun/projectile/revolver/capgun,
		/obj/item/toy/prize/deathripley,
		/obj/item/toy/prize/durand,
		/obj/item/toy/prize/fireripley,
		/obj/item/toy/prize/gygax,
		/obj/item/toy/prize/honk,
		/obj/item/toy/prize/marauder,
		/obj/item/toy/prize/mauler,
		/obj/item/toy/prize/odysseus,
		/obj/item/toy/prize/phazon,
		/obj/item/toy/prize/ripley,
		/obj/item/toy/prize/seraph,
		/obj/item/device/paicard,
		/obj/item/clothing/accessory/horrible,
		/obj/item/device/camera,
		/obj/item/bluespace_crystal,
		/obj/item/flame/lighter/zippo,
		/obj/item/device/taperecorder,
		/obj/item/storage/box/fancy/cigarettes/dromedaryco,
		/obj/item/toy/bosunwhistle,
		/obj/item/clothing/mask/fakemoustache,
		/obj/item/clothing/mask/gas/mime,
		/obj/item/clothing/head/festive/santa,
		/obj/item/stack/material/animalhide/lizard,
		/obj/item/stack/material/animalhide/cat,
		/obj/item/stack/material/animalhide/corgi,
		/obj/item/stack/material/animalhide/human,
		/obj/item/stack/material/animalhide/monkey,
		/obj/item/xmasgift/medium,
		/obj/item/toy/balloon/syndicate,
		/obj/item/toy/xmastree,
		/obj/item/bluespace_crystal,
		/obj/item/gun/energy/mousegun,
		/obj/item/gun/energy/wand/toy,
		/obj/item/mirror,
		/obj/item/ore/coal,
		/obj/item/ore/coal,
		/obj/item/ore/coal,
		/obj/item/stamp/clown,
		/obj/item/organ/internal/heart/skrell,
		/obj/item/toy/balloon/color,
		/obj/item/storage/box/partypopper)

	return picked_gift_type

/obj/item/xmasgift/ex_act(var/severity = 2.0)
	qdel(src)
	return

/obj/item/xmasgift/attack_self(mob/user)
	var/atom/movable/I = new gift_type(get_turf(user))
	user.remove_from_mob(src)
	user.put_in_hands(I)
	to_chat(user, SPAN_NOTICE("You open the gift, revealing your new [I.name]! Just what you always wanted!"))
	qdel(src)
	return

/obj/item/xmasgift/medium
	icon_state = "gift2"
	w_class = ITEMSIZE_SMALL

/obj/item/xmasgift/medium/get_gift_type()
	var/picked_gift_type = pick(
		/obj/random/booze,
		/obj/random/random_flag,
		/obj/item/storage/belt/champion,
		/obj/item/pickaxe/silver,
		/obj/item/grenade/smokebomb,
		/obj/item/contraband/poster,
		/obj/item/book/manual/barman_recipes,
		/obj/item/book/manual/chef_recipes,
		/obj/item/banhammer,
		/obj/item/clothing/shoes/cowboy,
		/obj/item/toy/crossbow,
		/obj/item/toy/katana,
		/obj/item/toy/spinningtoy,
		/obj/item/toy/sword,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiadeus,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiavulgaris,
		/obj/item/device/paicard,
		/obj/item/clothing/accessory/horrible,
		/obj/item/clothing/shoes/heels,
		/obj/item/storage/box/donkpockets,
		/obj/item/reagent_containers/food/drinks/teapot,
		/obj/item/device/flashlight/lantern,
		/obj/item/clothing/mask/balaclava,
		/obj/item/clothing/accessory/badge/old,
		/obj/item/clothing/mask/gas/mime,
		/obj/item/clothing/shoes/galoshes,
		/mob/living/simple_animal/lizard,
		/mob/living/simple_animal/rat/brown,
		/mob/living/simple_animal/rat/gray,
		/mob/living/simple_animal/rat/white,
		/obj/item/xmasgift,
		/obj/item/tank/jetpack/void,
		/obj/item/xmasgift/large,
		/obj/item/reagent_containers/food/snacks/pudding,
		/obj/item/contraband/poster,
		/obj/item/clothing/head/hardhat/atmos,
		/mob/living/bot/cleanbot,
		/obj/item/device/binoculars,
		/obj/item/device/camera,
		/obj/item/device/gps,
		/obj/item/device/uv_light,
		/obj/random/loot,
		/obj/random/contraband,
		/obj/item/autochisel,
		/obj/item/ore/coal,
		/obj/item/ore/coal,
		/obj/item/ore/coal,
		/obj/item/phone,
		/obj/item/device/dociler,
		/obj/item/device/flashlight/maglight,
		/obj/item/device/megaphone,
		/obj/item/device/violin)

	return picked_gift_type

/obj/item/xmasgift/large
	icon_state = "gift3"
	w_class = ITEMSIZE_NORMAL

/obj/item/xmasgift/large/get_gift_type()
	var/picked_gift_type = pick(
		/obj/random/plushie,
		/obj/random/backpack,
		/obj/item/inflatable_duck,
		/obj/item/beach_ball,
		/obj/item/clothing/under/syndicate/tracksuit,
		/obj/item/clothing/under/rank/sol/marine,
		/obj/item/clothing/under/rank/sol/dress/marine,
		/obj/random/hoodie,
		/mob/living/simple_animal/cat/kitten,
		/mob/living/simple_animal/chick,
		/mob/living/simple_animal/corgi/puppy,
		/mob/living/simple_animal/mushroom,
		/mob/living/simple_animal/ice_tunneler,
		/mob/living/simple_animal/carp/baby,
		/mob/living/simple_animal/schlorrgo,
		/mob/living/carbon/human/monkey/nupnup,
		/obj/item/xmasgift/medium,
		/obj/item/tank/jetpack,
		/obj/item/toy/plushie/drone,
		/obj/item/toy/plushie/ivancarp,
		/obj/item/ore/coal,
		/obj/item/ore/coal,
		/obj/item/ore/coal,
		/obj/item/mass_driver_diy,
		/mob/living/simple_animal/crab,
		/mob/living/simple_animal/parrot,
		/mob/living/simple_animal/hostile/commanded/dog/pug,
		/obj/item/target/alien,
		/obj/item/storage/box/candy)

	return picked_gift_type

/obj/item/xmasgift/schlorrgo
	gift_type = /mob/living/simple_animal/schlorrgo
	w_class = ITEMSIZE_NORMAL

/obj/item/xmasgift/viscerator
	gift_type = /mob/living/simple_animal/hostile/viscerator
	w_class = ITEMSIZE_NORMAL
