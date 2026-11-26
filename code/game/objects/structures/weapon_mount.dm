/obj/item/weapon_mount
	name = "folded weapon mount"
	desc = "A folded stand for supporting a mounted weapon."
	icon = 'icons/obj/guns/gun_mount.dmi'
	icon_state = "stand"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	should_use_health = TRUE
	maxhealth = OBJECT_HEALTH_LOW
	desc_mechanics = "Activate it in your hand or Ctrl-click an adjacent tile to deploy it. Drag the deployed stand onto yourself to fold it."

/obj/item/weapon_mount/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/deployable_item, /obj/structure/weapon_mount, 5 SECONDS, 5 SECONDS)

/obj/item/weapon_mount/attack_self(mob/user)
	if(..())
		return TRUE
	SEND_SIGNAL(src, COMSIG_ITEM_DEPLOY, user, get_step(user, user.dir))
	return TRUE

/obj/structure/weapon_mount
	name = "weapon mount"
	desc = "A deployed weapon stand. Its mounting cradle is empty."
	icon = 'icons/obj/guns/deployed_stand.dmi'
	icon_state = "stand"
	anchored = TRUE
	density = TRUE
	maxhealth = OBJECT_HEALTH_LOW
	desc_mechanics = "Drag it onto yourself to fold it back into a portable stand."
