/obj/item/device/assembly/electronic_assembly
	name = "electronic device"
	desc = "It's a case for building electronics with. It can be attached to other small devices."
	icon_state = "setup_device"
	var/opened = 0

	var/obj/item/device/electronic_assembly/device/EA

/obj/item/device/assembly/electronic_assembly/Initialize()
	. = ..()
	EA = new(src)
	EA.holder = src

/obj/item/device/assembly/electronic_assembly/Destroy()
	EA.holder = null
	QDEL_NULL(EA)

	. = ..()

/obj/item/device/assembly/electronic_assembly/attackby(obj/item/attacking_item, mob/user)
	if (attacking_item.iscrowbar())
		toggle_open(user)
	else if (opened)
		EA.attackby(attacking_item, user)
	else
		..()

/obj/item/device/assembly/electronic_assembly/proc/toggle_open(mob/user)
	playsound(get_turf(src), 'sound/items/crowbar_pry.ogg', 50, 1)
	opened = !opened
	EA.opened = opened
	to_chat(user, "<span class='notice'>You [opened ? "open" : "close"] \the [src].</span>")
	secured = 1
	update_icon()

/obj/item/device/assembly/electronic_assembly/update_icon()
	if(EA)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]0"
	if(opened)
		icon_state = "[icon_state]-open"

/obj/item/device/assembly/electronic_assembly/attack_self(mob/user as mob)
	if(EA)
		EA.attack_self(user)

//Called when another assembly acts on this one, var/radio will determine where it came from for wire calcs
/obj/item/device/assembly/electronic_assembly/pulsed(radio = 0)
	if(EA)
		for(var/obj/item/integrated_circuit/built_in/device_input/I in EA.contents)
			I.do_work()

/obj/item/device/assembly/electronic_assembly/examine(mob/user)
	. = ..()
	if(EA)
		for(var/obj/item/integrated_circuit/IC in EA.contents)
			IC.external_examine(user)

/obj/item/device/assembly/electronic_assembly/verb/toggle()
	set src in usr
	set category = "Object"
	set name = "Open/Close Device Assembly"
	set desc = "Open or close device assembly!"

	toggle_open(usr)

/obj/item/device/electronic_assembly/device
	name = "electronic device"
	icon_state = "setup_device"
	desc = "It's a tiny electronic device with specific use for attaching to other devices."
	w_class = ITEMSIZE_TINY
	max_components = IC_COMPONENTS_BASE * 3/4
	max_complexity = IC_COMPLEXITY_BASE * 3/4

	var/obj/item/device/assembly/electronic_assembly/holder
	var/obj/item/integrated_circuit/built_in/device_input/input
	var/obj/item/integrated_circuit/built_in/device_output/output


/obj/item/device/electronic_assembly/device/Initialize()
	. = ..()

	src.input = new(src)
	src.output = new(src)

	src.input.assembly = src
	src.output.assembly = src

/obj/item/device/electronic_assembly/device/Destroy()
	src.holder = null

	src.input.assembly = null
	src.output.assembly = null

	QDEL_NULL(src.input)
	QDEL_NULL(src.output)

	. = ..()

/obj/item/device/electronic_assembly/device/check_interactivity(mob/user)
	if(!CanInteract(user, state = GLOB.deep_inventory_state))
		return 0
	return 1
