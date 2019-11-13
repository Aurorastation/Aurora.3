/obj/structure/shotgun_rack
	name = "shotgun rack"
	desc = "A wooden rack designated to store shotguns."
	icon = 'icons/obj/shotgunrack.dmi'
	icon_state = "shotgun_rack"
	anchored = 1
	density = 0

	var/obj/item/gun/projectile/shotgun/rack_shotgun

/obj/structure/shotgun_rack/attackby(obj/item/O, mob/user)
	if(isrobot(user))
		return
	if(istype(O, /obj/item/gun/projectile/shotgun) && O.w_class != 3) //w_class check is to stop people from placing a sawn off shotgun here
		if(!rack_shotgun)
			user.unEquip(O)
			O.forceMove(src)
			rack_shotgun = O
			to_chat(user, "<span class='notice'>You place \the [O] in \the [src].</span>")
			icon_state = "shotgun_rack_[O.icon_state]"

/obj/structure/shotgun_rack/attack_hand(mob/user)
	if(isrobot(user))
		return
	if (!user.can_use_hand())
		return
	if(rack_shotgun)
		user.put_in_hands(rack_shotgun)
		to_chat(user, "<span class='notice'>You take \the [rack_shotgun] from \the [src].</span>")
		rack_shotgun = null
		icon_state = "shotgun_rack"

/obj/structure/shotgun_rack/attack_tk(mob/user)
	if(rack_shotgun)
		rack_shotgun.forceMove(loc)
		to_chat(user, "<span class='notice'>You telekinetically remove \the [rack_shotgun] from \the [src].</span>")
		rack_shotgun = null
		icon_state = "shotgun_rack"

//premade types

/obj/structure/shotgun_rack/double
	icon_state = "shotgun_rack_dshotgun"

/obj/structure/shotgun_rack/double/Initialize()
	. = ..()
	rack_shotgun = new/obj/item/gun/projectile/shotgun/doublebarrel(src)

/obj/structure/shotgun_rack/double_pellet
	icon_state = "shotgun_rack_dshotgun"

/obj/structure/shotgun_rack/double_pellet/Initialize()
	. = ..()
	rack_shotgun = new/obj/item/gun/projectile/shotgun/doublebarrel/pellet(src)


/obj/structure/shotgun_rack/pump
	icon_state = "shotgun_rack_shotgun"

/obj/structure/shotgun_rack/pump/Initialize()
	. = ..()
	rack_shotgun = new/obj/item/gun/projectile/shotgun/pump(src)

/obj/structure/shotgun_rack/combat
	icon_state = "shotgun_rack_cshotgun"

/obj/structure/shotgun_rack/combat/Initialize()
	. = ..()
	rack_shotgun = new/obj/item/gun/projectile/shotgun/pump/combat(src)

/obj/structure/shotgun_rack/improvised
	icon_state = "shotgun_rack_ishotgun"

/obj/structure/shotgun_rack/improvised/Initialize()
	. = ..()
	rack_shotgun = new/obj/item/gun/projectile/shotgun/improvised(src)
