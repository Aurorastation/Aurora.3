/* Gifts and wrapping paper
 * Contains:
 *		Gifts
 *		X-mas Gifts
 *		Wrapping Paper
 */

/*
 * Gifts
 */
/obj/item/weapon/a_gift
	name = "gift"
	desc = "PRESENTS!!!! eek!"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_state = "gift1"

/obj/item/weapon/a_gift/New()
	..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	if(w_class > 0 && w_class < 4)
		icon_state = "gift[w_class]"
	else
		icon_state = "gift[pick(1, 2, 3)]"
	return

/obj/item/weapon/gift/attack_self(mob/user as mob)
	user.drop_item()
	if(src.gift)
		user.put_in_active_hand(gift)
		src.gift.add_fingerprint(user)
	else
		user << "<span class='warning'>The gift was empty!</span>"
	qdel(src)
	return

/obj/item/weapon/a_gift/ex_act()
	qdel(src)
	return

/obj/effect/spresent/relaymove(mob/user as mob)
	if (user.stat)
		return
	user << "<span class='warning'>You can't move.</span>"

/obj/effect/spresent/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

	if (!iswirecutter(W))
		user << "<span class='warning'>I need wirecutters for that.</span>"
		return

	user << "<span class='notice'>You cut open the present.</span>"

	for(var/mob/M in src) //Should only be one but whatever.
		M.loc = src.loc
		if (M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

	qdel(src)

/obj/item/weapon/a_gift/attack_self(mob/M as mob)
	var/gift_type = pick(
		/obj/item/weapon/storage/wallet,
		/obj/item/weapon/storage/photo_album,
		/obj/item/weapon/storage/box/snappops,
		/obj/item/weapon/storage/fancy/crayons,
		/obj/item/weapon/storage/backpack/holding,
		/obj/item/weapon/storage/belt/champion,
		/obj/item/weapon/soap/deluxe,
		/obj/item/weapon/pickaxe/silver,
		/obj/item/weapon/pen/invisible,
		/obj/item/weapon/lipstick/random,
		/obj/item/weapon/grenade/smokebomb,
		/obj/item/weapon/corncob,
		/obj/item/weapon/contraband/poster,
		/obj/item/weapon/book/manual/barman_recipes,
		/obj/item/weapon/book/manual/chef_recipes,
		/obj/item/weapon/bikehorn,
		/obj/item/weapon/beach_ball,
		/obj/item/weapon/beach_ball/holoball,
		/obj/item/toy/balloon,
		/obj/item/toy/blink,
		/obj/item/toy/crossbow,
		/obj/item/weapon/gun/projectile/revolver/capgun,
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
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiadeus,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiavulgaris,
		/obj/item/device/paicard,
		/obj/item/device/violin,
		/obj/item/weapon/storage/belt/utility/full,
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
/obj/item/weapon/wrapping_paper
	name = "wrapping paper"
	desc = "You can use this to wrap items in."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrap_paper"
	var/amount = 20.0

/obj/item/weapon/wrapping_paper/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (!( locate(/obj/structure/table, src.loc) ))
		user << "<span class='warning'>You MUST put the paper on a table!</span>"
	if (W.w_class < 4)
		if ((istype(user.l_hand, /obj/item/weapon/wirecutters) || istype(user.r_hand, /obj/item/weapon/wirecutters)))
			var/a_used = 2 ** (src.w_class - 1)
			if (src.amount < a_used)
				user << "<span class='warning'>You need more paper!</span>"
				return
			else
				if(istype(W, /obj/item/smallDelivery) || istype(W, /obj/item/weapon/gift)) //No gift wrapping gifts!
					return

				src.amount -= a_used
				user.drop_item()
				var/obj/item/weapon/gift/G = new /obj/item/weapon/gift( src.loc )
				G.size = W.w_class
				G.w_class = G.size + 1
				G.icon_state = text("gift[]", G.size)
				G.gift = W
				W.loc = G
				G.add_fingerprint(user)
				W.add_fingerprint(user)
				src.add_fingerprint(user)
			if (src.amount <= 0)
				new /obj/item/weapon/c_tube( src.loc )
				qdel(src)
				return
		else
			user << "<span class='warning'>You need scissors!</span>"
	else
		user << "<span class='warning'>The object is FAR too large!</span>"
	return


/obj/item/weapon/wrapping_paper/examine(mob/user)
	if(..(user, 1))
		user << text("There is about [] square units of paper left!", src.amount)

/obj/item/weapon/wrapping_paper/attack(mob/target as mob, mob/user as mob)
	if (!istype(target, /mob/living/carbon/human)) return
	var/mob/living/carbon/human/H = target

	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket) || H.stat)
		if (src.amount > 2)
			var/obj/effect/spresent/present = new /obj/effect/spresent (H.loc)
			src.amount -= 2

			if (H.client)
				H.client.perspective = EYE_PERSPECTIVE
				H.client.eye = present

			H.loc = present

			H.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been wrapped with [src.name]  by [user.name] ([user.ckey])</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to wrap [H.name] ([H.ckey])</font>")
			msg_admin_attack("[key_name_admin(user)] used [src] to wrap [key_name_admin(H)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(H))

		else
			user << "<span class='warning'>You need more paper.</span>"
	else
		user << "They are moving around too much. A straightjacket would help."

/*
 * Xmas Gifts
 */
/obj/item/weapon/xmasgift
	name = "christmas gift"
	desc = "PRESENTS!!!! eek!"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_state = "gift1"
	w_class = 1

/obj/item/weapon/xmasgift/New()
	..()
	var/gift_benefactor = pick("John Rolf","Isaac Bureaurgard","David Montrello","Sarah Karpac","Camille Rodgers","Luke Lawrence","Goliath Grills","Torbjorn","Odin","Jesus DeSanto","Santa Claus","Ms. Claus","Mr. Claus","Bjorn","Frodo","Gandalf","Elrond",
		"Robert Heinlen","Martin Fresco","Lawrence Chamberlain","Buster Kilrain","Nerevar","Neville Trouserkepling","Adam Sortings","Eve's Grocers","Father Christmas","Adolph Romkippler","Adolf Strange","Camille","Maximilian von Biesel","Max","Bob Wallace",
		"The Grinch","Cicilia Simon","John F. Kennedy","Joseph Dorn","Mendell City","Ta�Akaix�Scay�extiih�aur Zo�ra","Ta'Akaix'Vaur'skiyet'sca Zo'ra","Miranda Trasen","Jiub","The Biesellian National Guard","The ERT","Baal D. Griffon","Hephaestus Industries","The Sol Alliance (Sorry about the blockade!")
	var/pick_emotion = pick("love","platonic admiration","approval","love (not in a sexual way or anything, though)","apathy", "schadenfreude","love","God's blessing","Santa's blessing","Non-demoninational deity's blessing","love","compassion","appreciation",
		"respect","begrudging respect","love")
	desc = "To: The [station_name()]<BR>From: <i>[gift_benefactor], with [pick_emotion]</i>"

	return

/obj/item/weapon/xmasgift/ex_act()
	qdel(src)
	return

/obj/item/weapon/xmasgift/small/attack_self(mob/M as mob)
	var/gift_type = pick(
		/obj/item/weapon/storage/wallet,
		/obj/item/weapon/storage/photo_album,
		/obj/item/weapon/storage/box/snappops,
		/obj/item/weapon/storage/fancy/crayons,
		/obj/item/weapon/soap/deluxe,
		/obj/item/weapon/pen/invisible,
		/obj/item/weapon/lipstick/random,
		/obj/item/weapon/corncob,
		/obj/item/weapon/bikehorn,
		/obj/item/toy/balloon,
		/obj/item/toy/blink,
		/obj/item/toy/gun,
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
		/obj/item/weapon/coin/silver,
		/obj/item/device/camera,
		/obj/item/weapon/coin/gold,
		/obj/item/bluespace_crystal,
		/obj/item/weapon/flame/lighter/zippo,
		/obj/item/device/taperecorder,
		/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,
		/obj/item/toy/bosunwhistle,
		/obj/item/clothing/mask/fakemoustache,
		/obj/item/clothing/mask/gas/clown_hat,
		/obj/item/clothing/mask/gas/mime,
		/obj/item/clothing/head/festive/santa,
		/obj/item/stack/material/animalhide/lizard,
		/obj/item/stack/material/animalhide/cat,
		/obj/item/stack/material/animalhide/corgi,
		/obj/item/stack/material/animalhide/human,
		/obj/item/stack/material/animalhide/monkey,
		/obj/item/stack/material/animalhide/xeno,
		/obj/item/trash/cheesie,
		/obj/item/trash/raisins,
		/obj/item/trash/koisbar,
		/obj/item/weapon/xmasgift/medium,
		/obj/item/toy/syndicateballoon,
		/obj/item/toy/xmastree)

	var/atom/movable/I = new gift_type(M)
	M.remove_from_mob(src)
	M.put_in_hands(I)
	M << "<span class='notice'>You open the gift, revealing your new [I.name]! Just what you always wanted!</span>"
	qdel(src)
	return

/obj/item/weapon/xmasgift/medium
	icon_state = "gift2"
	item_state = "gift2"
	w_class = 2

/obj/item/weapon/xmasgift/medium/attack_self(mob/M as mob)
	var/gift_type = pick(
		/obj/item/weapon/sord,
		/obj/item/weapon/storage/belt/champion,
		/obj/item/weapon/pickaxe/silver,
		/obj/item/weapon/grenade/smokebomb,
		/obj/item/weapon/contraband/poster,
		/obj/item/weapon/book/manual/barman_recipes,
		/obj/item/weapon/book/manual/chef_recipes,
		/obj/item/weapon/banhammer,
		/obj/item/toy/crossbow,
		/obj/item/toy/katana,
		/obj/item/toy/spinningtoy,
		/obj/item/toy/sword,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiadeus,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiavulgaris,
		/obj/item/device/paicard,
		/obj/item/clothing/accessory/horrible,
		/obj/item/weapon/storage/box/donkpockets,
		/obj/item/weapon/reagent_containers/food/drinks/teapot,
		/obj/item/device/flashlight/lantern,
		/obj/item/clothing/mask/balaclava,
		/obj/item/clothing/accessory/badge/old,
		/obj/item/clothing/mask/gas/clown_hat,
		/obj/item/clothing/mask/gas/mime,
		/obj/item/clothing/shoes/galoshes,
		/mob/living/simple_animal/lizard,
		/mob/living/simple_animal/mouse/brown,
		/mob/living/simple_animal/mouse/gray,
		/mob/living/simple_animal/mouse/white,
		/obj/item/weapon/xmasgift/small,
		/obj/item/weapon/tank/jetpack/void,
		/obj/item/weapon/xmasgift/large,
		/obj/item/weapon/reagent_containers/food/snacks/pudding)

	var/atom/movable/I = new gift_type(M)
	M.remove_from_mob(src)
	if (!M.put_in_hands(I))
		M.forceMove(get_turf(src))
	M << "<span class='notice'>You open the gift, revealing your new [I.name]! Just what you always wanted!</span>"
	qdel(src)
	return

/obj/item/weapon/xmasgift/large
	icon_state = "gift3"
	item_state = "gift3"
	w_class = 3

/obj/item/weapon/xmasgift/large/attack_self(mob/M as mob)
	var/gift_type = pick(
		/obj/item/weapon/inflatable_duck,
		/obj/item/weapon/beach_ball,
		/obj/item/clothing/under/redcoat,
		/obj/item/clothing/under/syndicate/tracksuit,
		/obj/item/clothing/under/rank/clown,
		/obj/item/clothing/under/mime,
		/mob/living/simple_animal/cat/kitten,
		/mob/living/simple_animal/chick,
		/mob/living/simple_animal/corgi/puppy,
		/mob/living/simple_animal/mushroom,
		/mob/living/carbon/human/monkey/nupnup,
		/obj/item/weapon/xmasgift/medium,
		/obj/item/weapon/tank/jetpack,
		/obj/structure/plushie/drone,
		/obj/structure/plushie/ivancarp,)

	var/atom/movable/I = new gift_type(M)
	M.remove_from_mob(src)
	M.put_in_hands(I)
	M << "<span class='notice'>You open the gift, revealing your new [I.name]! Just what you always wanted!</span>"
	qdel(src)
	return
