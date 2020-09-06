/obj/machinery/ringer
	name = "ringer terminal"
	desc = "A ringer terminal, PDAs can be linked to it."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "bell"
	anchored = TRUE

	req_access = list() //what access it needs to link your pda

	var/id = null
	var/list/obj/item/device/pda/rings_pdas = list() //A list of PDAs to alert upon someone touching the machine
	var/listener/ringers
	var/on = TRUE
	var/department = "Somewhere" //whatever department/desk you put this thing
	var/pinged = FALSE //for cooldown
	var/global/list/screen_overlays

/obj/machinery/ringer/Initialize()
	. = ..()
	if(id)
		ringers = new(id, src)
	generate_overlays()
	update_icon()

/obj/machinery/ringer/power_change()
	..()
	update_icon()

/obj/machinery/ringer/Destroy()
	QDEL_NULL(ringers)
	return ..()

/obj/machinery/ringer/proc/generate_overlays(var/force = 0)
	if(LAZYLEN(screen_overlays) && !force)
		return
	LAZYINITLIST(screen_overlays)
	screen_overlays["bell-active"] = make_screen_overlay(icon, "bell-active")
	screen_overlays["bell-alert"] = make_screen_overlay(icon, "bell-alert")
	screen_overlays["bell-scanline"] = make_screen_overlay(icon, "bell-scanline")
	screen_overlays["bell-standby"] = make_screen_overlay(icon, "bell-standby")

/obj/machinery/ringer/update_icon()
	cut_overlays()
	if(!on || stat & NOPOWER)
		icon_state = initial(icon_state)
		set_light(FALSE)
		return
	if(rings_pdas || rings_pdas.len)
		add_overlay(screen_overlays["bell-active"])
		set_light(1.4, 1, COLOR_CYAN)
	if(pinged)
		add_overlay(screen_overlays["bell-alert"])
		set_light(1.4, 1, COLOR_CYAN)
	if(on)
		add_overlay(screen_overlays["bell-scanline"])
	else
		add_overlay(screen_overlays["bell-standby"])
		set_light(1.4, 1, COLOR_CYAN)

/obj/machinery/ringer/attackby(obj/item/C as obj, mob/living/user as mob)
	if(stat & (BROKEN|NOPOWER) || !istype(user,/mob/living))
		return

	if (istype(C, /obj/item/device/pda))
		if(!check_access(C))
			to_chat(user, "<span class='warning'>Access Denied.</span>")
			return
		else if (C in rings_pdas)
			to_chat(user, "<span class='notice'>You unlink \the [C] from \the [src].</span>")
			remove_pda(C)
			return
		to_chat(user, "<span class='notice'>You link \the [C] to \the [src], it will now ring upon someone using \the [src].</span>")
		rings_pdas += C
		// WONT FIX: This requires callbacks fuck my dick.
		destroyed_event.register(C, src, .proc/remove_pda)
		update_icon()

	else
		..()

/obj/machinery/ringer/attack_hand(mob/user as mob)
	if(..())
		return

	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER) || !istype(usr,/mob/living))
		return

	if(!on)
		to_chat(user, "<span class='notice'>You turn \the [src] on, now all PDAs linked to it will be notified.</span>")
		on = TRUE

	else
		to_chat(user, "<span class='notice'>You turn \the [src] off.</span>")
		on = FALSE

	update_icon()

/obj/machinery/ringer/proc/ring_pda()

	if (!on || pinged)
		return

	pinged = TRUE
	update_icon()

	playsound(src.loc, 'sound/machines/ringer.ogg', 50, 1)

	for (var/obj/item/device/pda/pda in rings_pdas)
		if (pda.toff || pda.message_silent)
			continue

		var/message = "Notification from \the [department]!"
		pda.new_info(pda.message_silent, pda.ttone, "\icon[pda] <b>[message]</b>")

	addtimer(CALLBACK(src, .proc/unping), 45 SECONDS)

/obj/machinery/ringer/proc/unping()
	pinged = FALSE
	update_icon()

/obj/machinery/ringer/proc/remove_pda(var/obj/item/device/pda/pda)
	if (istype(pda))
		rings_pdas -= pda

/obj/machinery/ringer_button
	name = "ringer button"
	desc = "Use this to get someone's attention, or to annoy them."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "ringer"
	anchored = TRUE
	var/id = ""

/obj/machinery/ringer_button/Initialize(mapload, newid)
	. = ..()
	if(!id)
		id = newid
	update_icon()

/obj/machinery/ringer_button/power_change()
	..()
	update_icon()

/obj/machinery/ringer_button/update_icon()
	if(stat & NOPOWER)
		icon_state = "ringer_off"
	else
		icon_state = "ringer"

/obj/machinery/ringer_button/attack_hand(mob/living/user)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(use_power)
		use_power(active_power_usage)

	for (var/thing in GET_LISTENERS(id))
		var/listener/L = thing
		var/obj/machinery/ringer/C = L.target
		if (istype(C))
			C.ring_pda()
