/obj/item/device/assembly
	name = "assembly"
	desc = "A small electronic device that should never exist."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = ""
	flags = CONDUCT
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 100)
	recyclable = TRUE
	throwforce = 2
	throw_speed = 3
	throw_range = 10
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'
	origin_tech = list(TECH_MAGNET = 1)

	var/secured = TRUE
	var/list/attached_overlays = null
	var/obj/item/device/assembly_holder/holder = null
	var/cooldown = 0 //To prevent spam
	var/wires = WIRE_RECEIVE | WIRE_PULSE

	var/const/WIRE_RECEIVE = 1			//Allows Pulsed(0) to call Activate()
	var/const/WIRE_PULSE = 2				//Allows Pulse(0) to act on the holder
	var/const/WIRE_PULSE_SPECIAL = 4		//Allows Pulse(0) to act on the holders special assembly
	var/const/WIRE_RADIO_RECEIVE = 8		//Allows Pulsed(1) to call Activate()
	var/const/WIRE_RADIO_PULSE = 16		//Allows Pulse(1) to send a radio message

/obj/item/device/assembly/proc/holder_movement()
	return

//Called via spawn(10) to have it count down the cooldown var
/obj/item/device/assembly/proc/process_cooldown()
	cooldown--
	if(cooldown <= 0)
		return FALSE
	addtimer(CALLBACK(src, PROC_REF(process_cooldown)), 1 SECOND)
	return TRUE

// Called when another assembly acts on this one, var/radio will determine where it came from for wire calcs
/obj/item/device/assembly/proc/pulsed(var/radio = 0)
	if(holder && (wires & WIRE_RECEIVE))
		activate()
	if(radio && (wires & WIRE_RADIO_RECEIVE))
		activate()
	return TRUE

// Called when this device attempts to act on another device, var/radio determines if it was sent via radio or direct
/obj/item/device/assembly/proc/pulse(var/radio = 0)
	if(holder && (wires & WIRE_PULSE))
		holder.process_activation(src, TRUE, FALSE)
	if(holder && (wires & WIRE_PULSE_SPECIAL))
		holder.process_activation(src, FALSE, TRUE)
	return TRUE

/obj/item/device/assembly/proc/activate()
	if(!secured || cooldown)
		return FALSE
	cooldown = 2
	addtimer(CALLBACK(src, PROC_REF(process_cooldown)), 1 SECOND)
	return TRUE

/obj/item/device/assembly/proc/toggle_secure()
	secured = !secured
	update_icon()
	return secured

// Called when an assembly is attacked by another
/obj/item/device/assembly/proc/attach_assembly(var/obj/item/device/assembly/A, var/mob/user)
	holder = new /obj/item/device/assembly_holder(get_turf(src))
	if(holder.attach(A, src, user))
		to_chat(user, SPAN_NOTICE("You attach \the [A] to \the [src]!"))
		return TRUE
	return FALSE

/obj/item/device/assembly/attackby(obj/item/W, mob/user)
	if(isassembly(W))
		var/obj/item/device/assembly/A = W
		if(!A.secured && !secured)
			attach_assembly(A, user)
			return
	if(W.isscrewdriver())
		if(toggle_secure())
			to_chat(user, SPAN_NOTICE("\The [src] is ready!"))
		else
			to_chat(user, SPAN_NOTICE("\The [src] can now be attached!"))
		return
	return ..()

/obj/item/device/assembly/process()
	STOP_PROCESSING(SSprocessing, src)
	return


/obj/item/device/assembly/examine(mob/user)
	. = ..()
	if(. && (in_range(src, user) || loc == user))
		if(secured)
			to_chat(user, "\The [src] is ready!")
		else
			to_chat(user, "\The [src] can be attached!")


/obj/item/device/assembly/attack_self(mob/user)
	if(!user)
		return FALSE
	interact(user)
	return TRUE


/obj/item/device/assembly/interact(mob/user)
	return
