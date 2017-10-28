#define CHASSIS_SMALL 1
#define CHASSIS_MEDIUM 2
#define CHASSIS_LARGE 4
#define CHASSIS_GATLING 8

#define TYPE_PISTOL 1
#define TYPE_CARBINE 2
#define TYPE_RIFLE 3
#define TYPE_GATLING 4

#define MOD_SILENCE 1
#define MOD_NUCLEAR_CHARGE 2

#define islasercapacitor(A) istype(A, /obj/item/laser_components/capacitor)
#define ismodifier(A) istype(A, /obj/item/laser_components/modifier)
#define isfocusinglens(A) istype(A, /obj/item/laser_components/focusing_lens)

/obj/item/laser_components
	var/reliability = 100
	var/damage = 10
	armor_penetration = 0
	var/fire_delay = 0

/obj/item/laser_components/modifier
	name = "modifier"
	desc = "A basic laser weapon modifier."
	icon_state = "laser" // sprite
	item_state = "laser" // sprite
	var/mod_type

/obj/item/laser_components/capacitor
	name = "capacitor"
	desc = "A basic laser weapon capacitor."
	icon_state = "laser" // sprite
	item_state = "laser" // sprite
	var/shots = 5

/obj/item/laser_components/focusing_lens
	name = "focusing lens"
	desc = "A basic laser weapon focusing lens."
	icon_state = "laser" // sprite
	item_state = "laser" // sprite
	var/dispersion = 1

/obj/item/device/laser_assembly
	name = "laser assembly"
	desc = "A case for shoving things into. Hopefully they work."
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "setup_small"
	var/size = CHASSIS_SMALL

	var/obj/item/laser_components/modifier/modifier
	var/obj/item/laser_components/capacitor/capacitor
	var/obj/item/laser_components/focusing_lens/focusing_lens

/obj/item/device/laser_assembly/attackby(var/obj/item/weapon/D as obj, var/mob/user as mob)
	var/obj/item/laser_components/A = D
	if(!istype(A))
		return ..()
	if(ismodifier(A))
		modifier = A
	else if(islasercapacitor(A))
		capacitor = A
	else if(isfocusinglens(A))
		focusing_lens = A
	else
		return ..()
	user << "<span class='notice'>You insert the [A] into the assembly.</span>"
	qdel(A)
	check_completion()

/obj/item/device/laser_assembly/proc/check_completion()
	if(capacitor && focusing_lens)
		finish()

/obj/item/device/laser_assembly/proc/finish()
	var/obj/item/weapon/gun/energy/laser/prototype/A = new /obj/item/weapon/gun/energy/laser/prototype
	A.origin_chassis = size
	A.capacitor = capacitor
	A.focusing_lens = focusing_lens
	A.modifier = modifier
	A.loc = src.loc
	A.updatetype()
	qdel(src)