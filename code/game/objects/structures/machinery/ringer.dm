#define PRESET_NORTH \
dir = NORTH; \
pixel_y = 24;

#define PRESET_SOUTH \
dir = SOUTH; \
pixel_y = -24;

#define PRESET_WEST \
dir = WEST; \
pixel_x = -8;

#define PRESET_EAST \
dir = EAST; \
pixel_x = 8;

/// Job titles mapped to weak references of their initialized ringer terminals.
GLOBAL_LIST_EMPTY(ringers_by_job)

/obj/structure/machinery/ringer
	name = "ringer terminal"
	desc = "A ringer terminal, PDAs can be linked to it."
	icon = 'icons/obj/machinery/wall/terminals.dmi'
	icon_state = "bell"
	anchored = TRUE
	appearance_flags = TILE_BOUND // prevents people from viewing the overlay through a wall
	pda_linkable = TRUE

	req_access = list() //what access it needs to link your pda

	var/id = null
	/// Jobs (including alternate titles) whose issued devices automatically link here.
	var/list/autolink_jobs = list()

	///A list of PDAs to alert upon someone touching the machine
	var/list/obj/item/modular_computer/rings_pdas = list()

	var/listener/ringers
	var/on = TRUE

	///Whatever department/desk you put this thing
	var/department = "Somewhere"

	///If the pinging is in cooldown, boolean
	var/pinged = FALSE

/obj/structure/machinery/ringer/north
	PRESET_NORTH

/obj/structure/machinery/ringer/north/medical
	autolink_jobs = list(
		"Chief Medical Officer",
		"Physician",
		"Surgeon",
		"Medical Intern",
		"Resident Physician",
		"Resident Surgeon"
	)
	department = "Medbay"
	id = "medbay_ringer"
	req_access = list(/datum/access/medical::id)

/obj/structure/machinery/ringer/north/engineering
	autolink_jobs = list(
		"Chief Engineer",
		"Ship Engineer",
		"Reactor Operator",
		"Maintenance Technician",
		"Systems Engineer",
		"Atmospheric Technician",
		"Environmental Systems Engineer",
		"Propulsion Engineer",
		"Damage Control Technician",
		"Engineering Apprentice",
		"Atmospherics Apprentice"
	)
	department = "Engineering"
	id = "engie_ringer"
	pixel_y = 30
	req_access = null
	req_one_access = list(/datum/access/engine_equip::id, /datum/access/atmospherics::id)

/obj/structure/machinery/ringer/south
	PRESET_SOUTH

/obj/structure/machinery/ringer/south/custodial
	autolink_jobs = list("Janitor")
	department = "Custodial"
	id = "ringers_custodial"
	name = "\improper Custodial Ringer Terminal"
	req_access = list(/datum/access/janitor::id)

/obj/structure/machinery/ringer/south/investigations
	autolink_jobs = list("Head of Security", "Investigator", "Investigator Intern")
	department = "Security"
	id = "investigation_ringer"
	req_access = list(/datum/access/security::id)

/obj/structure/machinery/ringer/south/pharmacy
	autolink_jobs = list("Pharmacist", "Pharmacy Intern")
	department = "Pharmacy Frontdesk"
	id = "pharmacy_ringer"
	req_access = list(/datum/access/pharmacy::id)

/obj/structure/machinery/ringer/west
	PRESET_WEST

/obj/structure/machinery/ringer/west/custodial
	autolink_jobs = list("Janitor")
	department = "Custodial"
	id = "ringers_custodial"
	name = "\improper Custodial Ringer Terminal"
	pixel_y = 5
	req_access = list(/datum/access/janitor::id)

/obj/structure/machinery/ringer/west/custodial_auxiliary
	autolink_jobs = list("Janitor")
	department = "Auxiliary Custodial"
	id = "ringers_custodialaux"
	name = "\improper Auxiliary Custodial Ringer Terminal"
	pixel_y = 5
	req_access = list(/datum/access/janitor::id)

/obj/structure/machinery/ringer/west/consular_a
	autolink_jobs = list(
		"Consular Officer",
		"Civil Service Functionaire",
		"Foreign Service Officer",
		"Party Representative",
		"Kreshwan",
		"Diplomatic Aide",
		"Civil Service Aide",
		"Diplomatic Bodyguard",
		"Civil Service Bodyguard"
	)
	department = "Consular A"
	id = "consular_a_ringer"
	pixel_x = -10
	req_access = null
	req_one_access = list(/datum/access/consular::id)

/obj/structure/machinery/ringer/west/investigations
	autolink_jobs = list("Head of Security", "Investigator", "Investigator Intern")
	department = "Security"
	id = "investigation_ringer"
	req_access = list(/datum/access/security::id)

/obj/structure/machinery/ringer/west/hydroponics
	autolink_jobs = list("Gardener", "Hydroponicist")
	department = "Hydroponics"
	id = "ringer_hydroponics"
	pixel_x = -10
	pixel_y = -31
	req_access = list(/datum/access/hydroponics::id)

/obj/structure/machinery/ringer/east
	PRESET_EAST

/obj/structure/machinery/ringer/east/operations_office
	autolink_jobs = list("Operations Manager", "Hangar Technician")
	department = "Cargo"
	id = "cargo_ringer"
	pixel_y = 17
	req_access = list(/datum/access/cargo::id)

/obj/structure/machinery/ringer/east/security_lobby
	autolink_jobs = list(
		"Head of Security",
		"Warden",
		"Security Officer",
		"Security Cadet",
		"Warden Cadet"
	)
	department = "Security"
	id = "security_ringer"
	pixel_x = 10
	req_access = null
	req_one_access = list(/datum/access/security::id)

/obj/structure/machinery/ringer/east/consular_b
	autolink_jobs = list(
		"Consular Officer",
		"Civil Service Functionaire",
		"Foreign Service Officer",
		"Party Representative",
		"Kreshwan",
		"Diplomatic Aide",
		"Civil Service Aide",
		"Diplomatic Bodyguard",
		"Civil Service Bodyguard"
	)
	department = "Consular B"
	id = "consular_b_ringer"
	pixel_x = 10
	req_access = null
	req_one_access = list(/datum/access/consular::id)

/obj/structure/machinery/ringer/east/investigations
	autolink_jobs = list("Head of Security", "Investigator", "Investigator Intern")
	department = "Security"
	id = "investigation_ringer"
	req_access = list(/datum/access/security::id)

/obj/structure/machinery/ringer/east/hydroponics
	autolink_jobs = list("Gardener", "Hydroponicist")
	department = "Hydroponics"
	id = "ringer_hydroponics"
	req_access = list(/datum/access/hydroponics::id)

/obj/structure/machinery/ringer/east/machinist
	autolink_jobs = list("Machinist")
	department = "Operations"
	id = "workshop_ringer"
	req_access = list(/datum/access/robotics::id)

/obj/structure/machinery/ringer/Initialize(mapload)
	. = ..()
	for(var/job_title in autolink_jobs)
		LAZYADD(GLOB.ringers_by_job[job_title], WEAKREF(src))
	if(id)
		ringers = new(id, src)

	if(src.dir & NORTH)
		alpha = 127
	update_icon()

	if(!mapload)
		set_pixel_offsets()

/obj/structure/machinery/ringer/power_change()
	..()
	update_icon()

/obj/structure/machinery/ringer/set_pixel_offsets()
	pixel_x = DIR2PIXEL_X(dir)
	pixel_y = DIR2PIXEL_Y(dir)

/obj/structure/machinery/ringer/Destroy()
	for(var/job_title in autolink_jobs)
		LAZYREMOVE(GLOB.ringers_by_job[job_title], weak_reference)
		if(!length(GLOB.ringers_by_job[job_title]))
			GLOB.ringers_by_job -= job_title
	QDEL_NULL(ringers)
	return ..()

/obj/structure/machinery/ringer/update_icon()
	ClearOverlays()
	var/mutable_appearance/screen = overlay_image(icon, "bell-standby")
	var/mutable_appearance/screen_hologram = overlay_image(icon, "bell-standby")
	var/mutable_appearance/screen_emis = emissive_appearance(icon, "bell-standby")
	screen_hologram.filters += filter(type="color", color=list(
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_OPACITY
	))
	screen.filters += filter(type="color", color=list(
		HOLOSCREEN_ADDITION_OPACITY, 0, 0, 0,
		0, HOLOSCREEN_ADDITION_OPACITY, 0, 0,
		0, 0, HOLOSCREEN_ADDITION_OPACITY, 0,
		0, 0, 0, 1
	))
	screen_hologram.blend_mode = BLEND_MULTIPLY
	screen.blend_mode = BLEND_ADD
	if(!on || stat & NOPOWER)
		icon_state = initial(icon_state)
		set_light(FALSE)
		return
	if(rings_pdas || rings_pdas.len)
		screen = overlay_image(icon, "bell-active")
		set_light(L_WALLMOUNT_POWER, L_WALLMOUNT_RANGE, COLOR_CYAN)
	if(pinged)
		screen = overlay_image(icon, "bell-alert")
		set_light(L_WALLMOUNT_POWER, L_WALLMOUNT_RANGE, COLOR_CYAN)
	if(on)
		AddOverlays("bell-scanline")
	else
		screen = overlay_image(icon, "bell-standby")
		set_light(L_WALLMOUNT_POWER, L_WALLMOUNT_RANGE, COLOR_CYAN)
	AddOverlays(screen_hologram)
	AddOverlays(screen)
	AddOverlays(screen_emis)

/obj/structure/machinery/ringer/attackby(obj/item/attacking_item, mob/user)
	if(stat & (BROKEN|NOPOWER) || !istype(user,/mob/living))
		return TRUE

	if (istype(attacking_item, /obj/item/modular_computer))
		return toggle_pda_link(attacking_item, user)
	else
		return ..()

/obj/structure/machinery/ringer/toggle_pda_link(obj/item/modular_computer/pda, mob/user)
	var/obj/item/active_item = user.get_active_hand()
	var/obj/item/card/id/active_id = active_item?.GetID()
	if(!active_id && ishuman(user))
		var/mob/living/carbon/human/human_user = user
		active_id = human_user.wear_id?.GetID()
	if(!check_access(active_id))
		to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE
	if(pda in rings_pdas)
		to_chat(user, SPAN_NOTICE("You unlink \the [pda] from \the [src]."))
		remove_pda(pda)
		return TRUE
	to_chat(user, SPAN_NOTICE("You link \the [pda] to \the [src], it will now ring upon someone using \the [src]."))
	add_pda(pda)
	return TRUE

/obj/structure/machinery/ringer/attack_hand(mob/user as mob)
	if(..())
		return

	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER) || !istype(usr,/mob/living))
		return

	if(!on)
		to_chat(user, SPAN_NOTICE("You turn \the [src] on, now all PDAs linked to it will be notified."))
		on = TRUE

	else
		to_chat(user, SPAN_NOTICE("You turn \the [src] off."))
		on = FALSE

	update_icon()

/obj/structure/machinery/ringer/proc/ring_pda()

	if (!on || pinged)
		return

	pinged = TRUE
	update_icon()

	playsound(src.loc, 'sound/machines/ringer.ogg', 50, TRUE, ignore_walls = FALSE)

	for (var/obj/item/modular_computer/P in rings_pdas)
		var/message = "Attention required!"
		P.get_notification(message, 1, "[capitalize(department)]")

	addtimer(CALLBACK(src, PROC_REF(unping)), 45 SECONDS)

/obj/structure/machinery/ringer/proc/unping()
	pinged = FALSE
	update_icon()

/obj/structure/machinery/ringer/proc/remove_pda(obj/item/modular_computer/P)
	if (istype(P))
		UnregisterSignal(P, COMSIG_QDELETING)
		rings_pdas -= P
		update_icon()

/// Links a PDA if it is not already receiving this ringer's notifications.
/obj/structure/machinery/ringer/proc/add_pda(obj/item/modular_computer/P)
	if(!istype(P) || (P in rings_pdas))
		return
	rings_pdas += P
	RegisterSignal(P, COMSIG_QDELETING, PROC_REF(remove_pda))
	update_icon()

/obj/structure/machinery/ringer_button
	name = "ringer button"
	desc = "Use this to get someone's attention, or to annoy them."
	icon = 'icons/obj/machinery/wall/terminals.dmi'
	icon_state = "ringer"
	anchored = TRUE
	var/id = ""

/obj/structure/machinery/ringer_button/Initialize(mapload, newid)
	. = ..()
	if(!id)
		id = newid
	update_icon()

/obj/structure/machinery/ringer_button/power_change()
	..()
	update_icon()

/obj/structure/machinery/ringer_button/update_icon()
	if(stat & NOPOWER)
		icon_state = "ringer_off"
	else
		icon_state = "ringer"

/obj/structure/machinery/ringer_button/attack_hand(mob/living/user)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	flick("ringer_on", src)

	if(use_power)
		use_power_oneoff(active_power_usage)

	for (var/thing in GET_LISTENERS(id))
		var/listener/L = thing
		var/obj/structure/machinery/ringer/C = L.target
		if (istype(C))
			C.ring_pda()

#undef PRESET_NORTH
#undef PRESET_SOUTH
#undef PRESET_WEST
#undef PRESET_EAST
