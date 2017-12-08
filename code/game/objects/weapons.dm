/obj/item
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	hitsound = "swing_hit"

/obj/item/Bump(mob/M as mob)
	spawn(0)
		..()
	return

//Called when the user alt-clicks on something with this item in their active hand
//this function is designed to be overridden by individual weapons
/obj/item/proc/alt_attack(var/atom/target, var/mob/user)
	return 1
	//A return value of 1 continues on to do the normal alt-click action.
	//A return value of 0 does not continue, and will not do the alt-click