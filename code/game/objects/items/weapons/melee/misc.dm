/obj/item/weapon/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	item_state = "chain"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	origin_tech = "combat=4"
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (OXYLOSS)

/obj/item/weapon/melee/chainsword
	name = "chainsword"
	desc = "A deadly chainsaw in the shape of a sword."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "chainswordoff"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 15
	throwforce = 7
	w_class = 4
	sharp = 1
	edge = 1
	origin_tech = "combat=5"
	attack_verb = list("chopped", "sliced", "shredded", "slashed", "cut", "ripped")
	hitsound = 'sound/weapons/bladeslice.ogg'
	var/active = 0
	can_embed = 0//A chainsword can slice through flesh and bone, and the direction can be reversed if it ever did get stuck

/obj/item/weapon/melee/chainsword/attack_self(mob/user)
	active= !active
	if(active)
		playsound(user, 'sound/weapons/chainsawhit.ogg', 50, 1)
		user << "\blue \The [src] rumbles to life."
		force = 35
		hitsound = 'sound/weapons/chainsawhit.ogg'
		icon_state = "chainswordon"
		slot_flags = null
	else
		user << "\blue \The [src] slowly powers down."
		force = initial(force)
		hitsound = initial(hitsound)
		icon_state = initial(icon_state)
		slot_flags = initial(slot_flags)
	user.regenerate_icons()

/obj/item/weapon/melee/chainsword/suicide_act(mob/user)
	viewers(user) << "\red <b>[user] is slicing \himself apart with the [src.name]! It looks like \he's trying to commit suicide.</b>"
	return (BRUTELOSS|OXYLOSS)


//This is essientially a crowbar and a baseball bat in one.
/obj/item/weapon/melee/misc/hammer
	color
	name = "kneebreaker hammer"
	desc = "An intimidating hammer made of plasteel, this would hurt."
	icon = 'icons/obj/kneehammer.dmi'
	icon_state = "kneehammer"
	item_state = "kneehammer"
	contained_sprite = 1
	slot_flags = SLOT_BELT
	force = 22
	throwforce = 70
//This should do around 15 brute when you throw it, there's probably a better way to do it.
	throw_speed = 1
	throw_range = 5
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	w_class = 3
	origin_tech = "materials=3;syndicate=2"
	sharp = 0
	edge = 0
	hitsound = 'sound/weapons/genhit3.ogg'

/obj/item/weapon/melee/misc/hammer/suicide_act(mob/user)
	viewers(user) << "\red <b>[user] is hitting \himself in the head with the [src.name]! It looks like \he's trying to commit suicide.</b>"
	return (BRUTELOSS|OXYLOSS)