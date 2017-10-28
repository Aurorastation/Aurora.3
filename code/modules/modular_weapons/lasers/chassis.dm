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
    else if(iscapacitor(A))
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
    A.w_class = sizetowclass()
    A.capacitor = capacitor
    A.focusing_lens = focusing_lens
    A.modifier = modifier
    A.loc = src.loc
    A.updatetype()
    qdel(src)

/obj/item/device/laser_assembly/proc/sizetowclass
    switch(size)
        if(CHASSIS_SMALL)
            return 1
        if(CHASSIS_MEDIUM)
            return 2
        if(CHASSIS_LARGE)
            return 3
        if(CHASSIS_GATLING)
            return 4