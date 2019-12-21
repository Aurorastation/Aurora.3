/obj/item/material/butterflyconstruction
	name = "unfinished concealed knife"
	desc = "An unfinished concealed knife, it looks like the screws need to be tightened."
	icon = 'icons/obj/weapons_build.dmi'
	icon_state = "butterflystep1"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/material/butterflyconstruction/attackby(obj/item/W as obj, mob/user as mob)
	if(W.isscrewdriver())
		to_chat(user, "You finish the concealed blade weapon.")
		new /obj/item/material/knife/butterfly(user.loc, material.name)
		qdel(src)
		return

/obj/item/material/butterflyblade
	name = "knife blade"
	desc = "A knife blade. Unusable as a weapon without a grip."
	icon = 'icons/obj/weapons_build.dmi'
	icon_state = "butterfly2"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/material/butterflyhandle
	name = "concealed knife grip"
	desc = "A plasteel grip with screw fittings for a blade."
	icon = 'icons/obj/weapons_build.dmi'
	icon_state = "butterfly1"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/material/butterflyhandle/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/butterflyblade))
		var/obj/item/material/butterflyblade/B = W
		to_chat(user, "You attach the two concealed blade parts.")
		var/finished = new /obj/item/material/butterflyconstruction(user.loc, B.material.name)
		qdel(W)
		qdel(src)
		user.put_in_hands(finished)
		return

/obj/item/material/wirerod
	name = "wired rod"
	desc = "A rod with some wire wrapped around the top. It'd be easy to attach something to the top bit."
	icon_state = "wiredrod"
	item_state = "rods"
	flags = CONDUCT
	force = 8
	throwforce = 10
	w_class = 3
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/material/wirerod/attackby(var/obj/item/I, mob/user as mob)
	..()
	var/obj/item/finished
	if(istype(I, /obj/item/material/shard) || istype(I, /obj/item/material/spearhead))
		var/obj/item/material/tmp_shard = I
		finished = new /obj/item/material/twohanded/spear(get_turf(user), tmp_shard.material.name)
		to_chat(user, "<span class='notice'>You fasten \the [I] to the top of the rod with the cable.</span>")
	else if(I.iswirecutter())
		finished = new /obj/item/melee/baton/cattleprod(get_turf(user))
		to_chat(user, "<span class='notice'>You fasten the wirecutters to the top of the rod with the cable, prongs outward.</span>")
	if(finished)
		user.drop_from_inventory(src,finished)
		user.drop_from_inventory(I,finished)
		//TODO: Possible better animation here.
		qdel(I)
		qdel(src)
		user.put_in_hands(finished)
	update_icon(user)

/obj/item/material/shaft
	name = "shaft"
	desc = "A large stick, you could probably attach something to it."
	icon = 'icons/obj/weapons_build.dmi'
	icon_state = "shaft"
	item_state = "rods"
	force = 5
	throwforce = 3
	w_class = 4
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	default_material = "wood"

/obj/item/material/shaft/attackby(var/obj/item/I, mob/user as mob)
	..()
	var/obj/item/finished
	if(istype(I, /obj/item/material/spearhead))
		var/obj/item/material/spearhead/tip = I
		finished = new /obj/item/material/twohanded/pike(get_turf(user), tip.material.name)
		to_chat(user, "<span class='notice'>You attach \the [I] to the top of \the [src].</span>")
	if(finished)
		user.drop_from_inventory(src,finished)
		user.drop_from_inventory(I,finished)
		qdel(I)
		qdel(src)
		//TODO: Possible better animation here.
		user.put_in_hands(finished)
	update_icon(user)

/obj/item/material/spearhead
	name = "spearhead"
	desc = "A pointy spearhead, not really useful without a shaft."
	icon = 'icons/obj/weapons_build.dmi'
	icon_state = "spearhead"
	force = 5
	throwforce = 5
	w_class = 2
	attack_verb = list("attacked", "poked")
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	default_material = "steel"


/obj/item/material/woodenshield
	name = "shield donut"
	desc = "A wooden disc. Unusable as a shield without metal. Don't eat this."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "buckler2"
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	default_material = "wood"

/obj/item/material/woodenshield/attackby(var/obj/item/I, mob/user as mob)
	..()
	var/obj/item/finished
	if(istype(I, /obj/item/material/shieldbits))
		var/obj/item/material/woodenshield/donut = I
		finished = new /obj/item/shield/buckler(get_turf(user), donut.material.name)
		to_chat(user, "<span class='notice'>You attach \the [I] to \the [src].</span>")
	if(finished)
		user.drop_from_inventory(src)
		user.drop_from_inventory(I)
		qdel(I)
		qdel(src)
		user.put_in_hands(finished)
	update_icon(user)

/obj/item/material/shieldbits
	name = "shield fittings"
	desc = "A metal ring and boss, fitting for a buckler."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "buckler1"
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	default_material = "steel"

/obj/item/woodcirclet
	name = "wood circlet"
	desc = "A small wood circlet for making a flower crown."
	icon = 'icons/obj/weapons_build.dmi'
	icon_state = "woodcirclet"
	item_state = "woodcirclet"
	w_class = ITEMSIZE_SMALL

/obj/item/woodcirclet/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/complete = null
	if(istype(W, /obj/item/seeds))	// Only allow seeds, since we rely on their structure
		var/obj/item/seeds/S = W
		if(istype(S.seed, /datum/seed/flower/poppy))
			complete = new /obj/item/clothing/head/poppy_crown(get_turf(user))
		else if(istype(S.seed, /datum/seed/flower/sunflower))
			complete = new /obj/item/clothing/head/sunflower_crown(get_turf(user))
		else if(istype(S.seed, /datum/seed/flower))  // Note: might be a problem if more flowers are added
			complete = new /obj/item/clothing/head/lavender_crown(get_turf(user))

		if(complete != null)
			to_chat(user, "<span class='notice'>You attach the " + S.seed.seed_name + " to the circlet and create a beautiful flower crown.</span>")
			user.drop_from_inventory(W)
			user.drop_from_inventory(src)
			qdel(W)
			qdel(src)
			user.put_in_hands(complete)
			return