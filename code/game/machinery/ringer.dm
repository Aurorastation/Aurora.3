/obj/machinery/ringer
	name = "ringer terminal"
	desc = "A ringer terminal, PDAs can be linked to it."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "bell_standby"
	anchored = 1.0

	req_access = list(access_hop) //what access it needs to link your pda

	var/id = null
	var/list/obj/item/device/pda/rings_pdas = list() //A list of PDAs to alert upon someone touching the machine
	var/_wifi_id
	var/datum/wifi/receiver/button/ringer/wifi_receiver
	var/on = TRUE
	var/department = "Head of personnel office" //whatever department/desk you put this thing

/obj/machinery/ringer/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/ringer/power_change()
	..()
	update_icon()

/obj/machinery/ringer/Destroy()
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/ringer/update_icon()
	if(stat & NOPOWER)
		icon_state = "bell_off"
		return
	if (rings_pdas || rings_pdas.len)
		icon_state = "bell_active"
	if(!on)
		icon_state = "bell_off"
	else
		icon_state = "bell_standby"

/obj/machinery/ringer/attackby(obj/item/C as obj, mob/living/user as mob)
	if(stat & (BROKEN|NOPOWER) || !istype(usr,/mob/living))
		return

	if (istype(C, /obj/item/device/pda))
		if(!check_access(C))
			user << "<span class='warning'>Access Denied.</span>"
			return
		else if (C in rings_pdas)
			usr << "<span class='notice'>\The [C] appears to be already linked.</span>"
			return
		usr << "<span class='notice'>You link \the [C] to \the [src], it will now ring upon someone using \the [src].</span>"
		rings_pdas += C
		C.OnDestroy(CALLBACK(src, .proc/remove_pda, C))
		update_icon()

	else
		..()

	return

/obj/machinery/ringer/attack_hand(mob/user as mob)
	if(..())
		return

	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER) || !istype(usr,/mob/living))
		return

	if(!on)
		user << "<span class='notice'>Your turn \the [src] on, now all pdas linked to it will be notified.</span>"
		on = TRUE

	else
		user << "<span class='notice'>Your turn \the [src] off.</span>"
		on = FALSE

	update_icon()

	return

/obj/machinery/ringer/proc/ring_pda()
	if(!on)
		return

	if (!rings_pdas || !rings_pdas.len)
		return

	playsound(src.loc, 'sound/machines/ringer.ogg', 50, 1)

	for (var/obj/item/device/pda/pda in rings_pdas)
		if (pda.toff || pda.message_silent)
			continue

		var/message = "Notification from the [department]!"
		pda.new_info(pda.message_silent, pda.ttone, "\icon[pda] <b>[message]</b>")

/obj/machinery/ringer/proc/remove_pda(var/obj/item/device/pda/pda)
	if (istype(pda))
		rings_pdas -= pda

/obj/machinery/button/ringer
	name = "ringer button"
	desc = "Use this to get someone's attention, or to annoy them."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "ringer"

/obj/machinery/button/update_icon()
	if(active)
		icon_state = "ringer"
	else
		icon_state = "ringer_off"

/obj/machinery/button/ringer/attack_hand(mob/user as mob)

	if(..())
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	use_power(5)
	active = 1

	icon_state = "ringer_on"

	for(var/obj/machinery/ringer/M in SSmachinery.all_machines)
		if(M.id == src.id)
			spawn()
				M.ring_pda()

	sleep(50)

	icon_state = "ringer"

	active = 0

	return
