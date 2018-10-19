/obj/item/weapon/material/butterflyconstruction
	name = "unfinished concealed knife"
	desc = "An unfinished concealed knife, it looks like the screws need to be tightened."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterflystep1"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/weapon/material/butterflyconstruction/attackby(obj/item/W as obj, mob/user as mob)
	if(isscrewdriver(W))
		user << "You finish the concealed blade weapon."
		new /obj/item/weapon/material/butterfly(user.loc, material.name)
		qdel(src)
		return

/obj/item/weapon/material/butterflyblade
	name = "knife blade"
	desc = "A knife blade. Unusable as a weapon without a grip."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterfly2"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/weapon/material/butterflyhandle
	name = "concealed knife grip"
	desc = "A plasteel grip with screw fittings for a blade."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterfly1"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/weapon/material/butterflyhandle/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/material/butterflyblade))
		var/obj/item/weapon/material/butterflyblade/B = W
		user << "You attach the two concealed blade parts."
		var/finished = new /obj/item/weapon/material/butterflyconstruction(user.loc, B.material.name)
		qdel(W)
		qdel(src)
		user.put_in_hands(finished)
		return

/obj/item/weapon/material/wirerod
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

/obj/item/weapon/material/wirerod/attackby(var/obj/item/I, mob/user as mob)
	..()
	var/obj/item/finished
	if(istype(I, /obj/item/weapon/material/shard) || istype(I, /obj/item/weapon/material/spearhead))
		var/obj/item/weapon/material/tmp_shard = I
		finished = new /obj/item/weapon/material/twohanded/spear(get_turf(user), tmp_shard.material.name)
		user << "<span class='notice'>You fasten \the [I] to the top of the rod with the cable.</span>"
	else if(iswirecutter(I))
		finished = new /obj/item/weapon/melee/baton/cattleprod(get_turf(user))
		user << "<span class='notice'>You fasten the wirecutters to the top of the rod with the cable, prongs outward.</span>"
	if(finished)
		user.drop_from_inventory(src,finished)
		user.drop_from_inventory(I,finished)
		//TODO: Possible better animation here.
		qdel(I)
		qdel(src)
		user.put_in_hands(finished)
	update_icon(user)

/obj/item/weapon/material/shaft
	name = "shaft"
	desc = "A large stick, you could probably attach something to it."
	icon_state = "shaft"
	item_state = "rods"
	force = 5
	throwforce = 3
	w_class = 4
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	default_material = "wood"

/obj/item/weapon/material/shaft/attackby(var/obj/item/I, mob/user as mob)
	..()
	var/obj/item/finished
	if(istype(I, /obj/item/weapon/material/spearhead))
		var/obj/item/weapon/material/spearhead/tip = I
		finished = new /obj/item/weapon/material/twohanded/pike(get_turf(user), tip.material.name)
		user << "<span class='notice'>You attach \the [I] to the top of \the [src].</span>"
	if(finished)
		user.drop_from_inventory(src,finished)
		user.drop_from_inventory(I,finished)
		qdel(I)
		qdel(src)
		//TODO: Possible better animation here.
		user.put_in_hands(finished)
	update_icon(user)

/obj/item/weapon/material/spearhead
	name = "spearhead"
	desc = "A pointy spearhead, not really useful without a shaft."
	icon_state = "spearhead"
	force = 5
	throwforce = 5
	w_class = 2
	attack_verb = list("attacked", "poked")
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	default_material = "steel"


/obj/item/weapon/material/woodenshield
	name = "shield donut"
	desc = "A wooden disc. Unusable as a shield without metal. Don't eat this."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "buckler2"
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	default_material = "wood"

/obj/item/weapon/material/woodenshield/attackby(var/obj/item/I, mob/user as mob)
	..()
	var/obj/item/finished
	if(istype(I, /obj/item/weapon/material/shieldbits))
		var/obj/item/weapon/material/woodenshield/donut = I
		finished = new /obj/item/weapon/shield/buckler(get_turf(user), donut.material.name)
		user << "<span class='notice'>You attach \the [I] to \the [src].</span>"
	if(finished)
		user.drop_from_inventory(src)
		user.drop_from_inventory(I)
		qdel(I)
		qdel(src)
		user.put_in_hands(finished)
	update_icon(user)

/obj/item/weapon/material/shieldbits
	name = "shield fittings"
	desc = "A metal ring and boss, fitting for a buckler."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "buckler1"
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	default_material = "steel"