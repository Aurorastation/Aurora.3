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
	desc = "A deployed stand for supporting a heavy weapon."
	icon = 'icons/obj/guns/deployed_stand.dmi'
	icon_state = "stand"
	anchored = TRUE
	density = TRUE
	maxhealth = OBJECT_HEALTH_LOW
	desc_mechanics = "Place a compatible gun on it, then secure it with a wrench. Stand directly behind the secured gun with empty hands or compatible magazines and click to man it. Click again or resist to release it. Use a wrench while unmanned to unsecure it, then click with an empty hand to remove the gun. Alt-click to rotate while idle and unmanned. Drag the empty stand onto yourself to fold it."

/obj/structure/weapon_mount/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/weapon_mount, GUN_MOUNT_HEAVY)

/obj/structure/weapon_mount/attack_hand(mob/living/user)
	var/datum/component/weapon_mount/mount = GetComponent(/datum/component/weapon_mount)
	if(user.a_intent != I_HURT && mount?.get_weapon())
		if(mount.is_secured())
			SEND_SIGNAL(src, COMSIG_MOUNTED_WEAPON_INTERACT, user)
		else
			mount.remove_weapon(user)
		return TRUE
	return ..()

/obj/structure/weapon_mount/AltClick(mob/user)
	var/datum/component/weapon_mount/mount = GetComponent(/datum/component/weapon_mount)
	if(mount)
		return mount.rotate_mount(user)
	return ..()

/obj/structure/weapon_mount/CtrlClick(mob/user)
	if(SEND_SIGNAL(src, COMSIG_MOUNTED_WEAPON_RELOAD, user) & COMPONENT_MOUNTED_WEAPON_HANDLED)
		return TRUE
	return ..()

/obj/structure/weapon_mount/CtrlShiftClick(mob/user)
	if(SEND_SIGNAL(src, COMSIG_MOUNTED_WEAPON_EJECT, user) & COMPONENT_MOUNTED_WEAPON_HANDLED)
		return TRUE
	return ..()
