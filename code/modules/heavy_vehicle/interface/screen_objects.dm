// Screen objects hereon out.
/obj/screen/mecha
	name = "hardpoint"
	icon = 'icons/mecha/mecha_hud.dmi'
	icon_state = "hardpoint"
	var/mob/living/heavy_vehicle/owner
	maptext_y = 11

/obj/screen/mecha/proc/notify_user(var/mob/user, var/text)
	if(user && user.loc == owner)
		to_chat(user, text)

/obj/screen/mecha/radio
	name = "radio"
	icon_state = "base"
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 #242424; font-size: 6px;\">RADIO</span>"
	maptext_x = 2
	maptext_y = 11

/obj/screen/mecha/radio/Click()
	if(..())
		if(owner.radio)
			owner.radio.attack_self(usr)

/obj/screen/mecha/Initialize()
	. = ..()
	var/mob/living/heavy_vehicle/newowner = loc
	if(!istype(newowner))
		return qdel(src)
	owner = newowner

/obj/screen/mecha/Click()
	return (!owner || !usr.incapacitated() && (usr == owner || usr.loc == owner))

/obj/screen/mecha/hardpoint
	name = "hardpoint"
	var/hardpoint_tag
	var/obj/item/holding

	maptext_x = 34
	maptext_y = 3
	maptext_width = 120

/obj/screen/mecha/hardpoint/Destroy()
	owner = null
	holding = null
	. = ..()

/obj/screen/mecha/hardpoint/MouseDrop()
	..()
	if(holding) holding.screen_loc = screen_loc

/obj/screen/mecha/hardpoint/proc/update_system_info()
	// No point drawing it if we have no item to use or nobody to see it.
	if(!holding || !owner)
		return

	var/has_pilot_with_client = owner.client
	if(!has_pilot_with_client && LAZYLEN(owner.pilots))
		for(var/thing in owner.pilots)
			var/mob/pilot = thing
			if(pilot.client)
				has_pilot_with_client = TRUE
				break

	if(!has_pilot_with_client)
		return

	var/list/new_overlays = list()
	if(!owner.get_cell() || (owner.get_cell().charge <= 0))
		overlays.Cut()
		maptext = ""
		return

	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">[holding.get_hardpoint_maptext()]</span>"

	var/ui_damage = (!owner.body.diagnostics || !owner.body.diagnostics.is_functional() || ((owner.emp_damage>EMP_GUI_DISRUPT) && prob(owner.emp_damage)))

	var/value = holding.get_hardpoint_status_value()
	if(isnull(value))
		overlays.Cut()
		return

	if(ui_damage)
		value = -1
		maptext = "ERROR"
	else
		if((owner.emp_damage>EMP_GUI_DISRUPT) && prob(owner.emp_damage*2))
			if(prob(10))
				value = -1
			else
				value = rand(1,BAR_CAP)
		else
			value = round(value * BAR_CAP)

	// Draw background.
	if(!default_hardpoint_background)
		default_hardpoint_background = image(icon = 'icons/mecha/mecha_hud.dmi', icon_state = "bar_bkg")
		default_hardpoint_background.pixel_x = 34
	new_overlays |= default_hardpoint_background

	if(value == 0)
		if(!hardpoint_bar_empty)
			hardpoint_bar_empty = image(icon='icons/mecha/mecha_hud.dmi',icon_state="bar_flash")
			hardpoint_bar_empty.pixel_x = 24
			hardpoint_bar_empty.color = "#FF0000"
		new_overlays |= hardpoint_bar_empty
	else if(value < 0)
		if(!hardpoint_error_icon)
			hardpoint_error_icon = image(icon='icons/mecha/mecha_hud.dmi',icon_state="bar_error")
			hardpoint_error_icon.pixel_x = 34
		new_overlays |= hardpoint_error_icon
	else
		value = min(value, BAR_CAP)
		// Draw statbar.
		if(!LAZYLEN(hardpoint_bar_cache))
			for(var/i=0;i<BAR_CAP;i++)
				var/image/bar = image(icon='icons/mecha/mecha_hud.dmi',icon_state="bar")
				bar.pixel_x = 24+(i*2)
				if(i>5)
					bar.color = "#00ff00"
				else if(i>1)
					bar.color = "#ffff00"
				else
					bar.color = "#ff0000"
				hardpoint_bar_cache += bar
		for(var/i = 1; i <= value; i++)
			new_overlays += hardpoint_bar_cache[i]
	overlays = new_overlays

/obj/screen/mecha/hardpoint/Initialize(mapload, var/newtag)
	. = ..()
	hardpoint_tag = newtag
	name = "hardpoint ([hardpoint_tag])"

/obj/screen/mecha/hardpoint/Click(var/location, var/control, var/params)

	if(!(..()))
		return

	var/modifiers = params2list(params)
	if(modifiers["ctrl"])
		if(owner.hardpoints_locked)
			notify_user(usr, SPAN_WARNING("The hardpoint ejection system is locked."))
			return
		if(owner.remove_system(hardpoint_tag))
			notify_user(usr, SPAN_NOTICE("You disengage and discard the system mounted to your [hardpoint_tag] hardpoint."))
		else
			notify_user(usr, SPAN_DANGER("You fail to remove the system mounted to your [hardpoint_tag] hardpoint."))
		return

	if(owner.selected_hardpoint == hardpoint_tag)
		icon_state = "hardpoint"
		owner.clear_selected_hardpoint()
	else
		if(owner.set_hardpoint(hardpoint_tag))
			icon_state = "hardpoint_selected"

/obj/screen/mecha/eject
	name = "eject"
	icon_state = "large_base"
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 #242424; font-size: 6px;\">EJECT</span>"
	maptext_x = 3
	maptext_y = 10

/obj/screen/mecha/eject/Click()
	if(..())
		owner.eject(usr)

/obj/screen/mecha/rename
	name = "rename"
	icon_state = "base"
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 #242424; font-size: 5px;\">RENAME</span>"
	maptext_x = 1
	maptext_y = 12

/obj/screen/mecha/rename/Click()
	if(..())
		owner.rename(usr)

/obj/screen/mecha/power
	name = "power"
	icon_state = null

	maptext_width = 64
	maptext_y = 2

/obj/screen/mecha/toggle
	name = "toggle"
	var/toggled

/obj/screen/mecha/toggle/Click()
	if(..()) toggled()

/obj/screen/mecha/toggle/proc/toggled()
	toggled = !toggled
	icon_state = "[initial(icon_state)][toggled ? "_enabled" : ""]"
	return toggled

/obj/screen/mecha/toggle/air
	name = "air"
	icon_state = "base"
	maptext = "<span style=\"font-family: 'Small Fonts'; color: #525252; -dm-text-outline: 1 #242424; font-size: 6px;\">AIR</span>"
	maptext_x = 8

/obj/screen/mecha/toggle/air/toggled()
	toggled = !toggled
	owner.use_air = toggled
	var/main_color = owner.use_air ? "#d1d1d1" : "#525252"
	maptext = "<span style=\"font-family: 'Small Fonts'; color: [main_color]; -dm-text-outline: 1 #242424; font-size: 6px;\">AIR</span>"
	notify_user(usr, SPAN_NOTICE("Auxiliary atmospheric system [owner.use_air ? "enabled" : "disabled"]."))

/obj/screen/mecha/toggle/maint
	name = "toggle maintenance protocol"
	icon_state = "large_base"
	maptext = "<span style=\"font-family: 'Small Fonts'; color: #525252; -dm-text-outline: 1 #242424; font-size: 6px;\">MAINT</span>"
	maptext_x = 2
	maptext_y = 10

/obj/screen/mecha/toggle/maint/toggled()
	toggled = !toggled
	owner.maintenance_protocols = toggled
	var/main_color = owner.maintenance_protocols ? "#d1d1d1" : "#525252"
	maptext = "<span style=\"font-family: 'Small Fonts'; color: [main_color]; -dm-text-outline: 1 #242424; font-size: 6px;\">MAINT</span>"
	notify_user(usr, SPAN_NOTICE("Maintenance protocols [owner.maintenance_protocols ? "enabled" : "disabled"]."))

/obj/screen/mecha/toggle/power_control
	name = "power control"
	icon_state = "large_base"
	maptext = "<span style=\"font-family: 'Small Fonts'; color: #525252; -dm-text-outline: 1 #242424; font-size: 6px;\">POWER</span>"
	maptext_x = 1
	maptext_y = 11

/obj/screen/mecha/toggle/power_control/toggled()
	toggled = !toggled
	owner.toggle_power(usr)
	var/main_color = toggled ? "#d1d1d1" : "#525252"
	maptext = "<span style=\"font-family: 'Small Fonts'; color: [main_color]; -dm-text-outline: 1 #242424; font-size: 6px;\">POWER</span>"

/obj/screen/mecha/toggle/power_control/update_icon()
	toggled = (owner.power == MECH_POWER_ON)
	return ..()

/obj/screen/mecha/toggle/hardpoint
	name = "toggle hardpoint lock"
	icon_state = "base"
	maptext = "<span style=\"font-family: 'Small Fonts'; color: #525252; -dm-text-outline: 1 #242424; font-size: 6px;\">GEAR</span>"
	maptext_x = 4

/obj/screen/mecha/toggle/hardpoint/toggled()
	if(owner.force_locked)
		notify_user(usr, SPAN_WARNING("The locking system cannot be operated due to software restriction. Contact the manufacturer for more details."))
		return
	toggled = !toggled
	owner.hardpoints_locked = toggled
	var/main_color = owner.hardpoints_locked ? "#d1d1d1" : "#525252"
	maptext = "<span style=\"font-family: 'Small Fonts'; color: [main_color]; -dm-text-outline: 1 #242424; font-size: 6px;\">GEAR</span>"
	notify_user(usr, SPAN_NOTICE("Hardpoint system access is now [owner.hardpoints_locked ? "disabled" : "enabled"]."))

/obj/screen/mecha/toggle/hatch
	name = "toggle hatch lock"
	icon_state = "base"
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 #242424; font-size: 6px;\">LOCK</span>"
	maptext_x = 5

/obj/screen/mecha/toggle/hatch/toggled()
	if(!owner.hatch_locked && !owner.hatch_closed)
		notify_user(usr, SPAN_WARNING("You cannot lock the hatch while it is open."))
		return
	if(owner.force_locked)
		notify_user(usr, SPAN_WARNING("The locking system cannot be operated due to software restriction. Contact the manufacturer for more details."))
		return
	toggled = !toggled
	owner.hatch_locked = toggled
	if(owner.hatch_locked)
		maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 #242424; font-size: 5px;\">UNLOCK</span>"
		maptext_y = 12
		maptext_x = 1
	else
		maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 #242424; font-size: 6px;\">LOCK</span>"
		maptext_y = 11
		maptext_x = 5
	notify_user(usr, SPAN_NOTICE("The [owner.body.hatch_descriptor] is [owner.hatch_locked ? "now" : "no longer" ] locked."))

/obj/screen/mecha/toggle/hatch_open
	name = "open or close hatch"
	icon_state = "base"
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 #242424; font-size: 6px;\">CLOSE</span>"
	maptext_x = 3

/obj/screen/mecha/toggle/hatch_open/update_icon()
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 #242424; font-size: 6px;\">[owner.hatch_closed ? "OPEN" : "CLOSE"]</span>"
	maptext_x = owner.hatch_closed ? 4 : 3

/obj/screen/mecha/toggle/hatch_open/toggled(var/notify_user = TRUE)
	if(owner.hatch_locked && owner.hatch_closed)
		notify_user(usr, SPAN_WARNING("You cannot open the hatch while it is locked."))
		return
	toggled = !toggled
	owner.hatch_closed = toggled
	if(notify_user)
		notify_user(usr, SPAN_NOTICE("The [owner.body.hatch_descriptor] is now [owner.hatch_closed ? "closed" : "open" ]."))
	update_icon()
	owner.update_icon()

// This is basically just a holder for the updates the mech does.
/obj/screen/mecha/health
	name = "exosuit integrity"
	icon_state = "health"

/obj/screen/mecha/toggle/sensor
	name = "toggle sensor matrix"
	icon_state = "base"
	maptext = "<span style=\"font-family: 'Small Fonts'; color: #525252; -dm-text-outline: 1 #242424; font-size: 5px;\">SENSOR</span>"
	maptext_x = 1
	maptext_y = 12

/obj/screen/mecha/toggle/sensor/toggled()
	if(!owner.head)
		notify_user(usr, SPAN_WARNING("I/O Error: Sensor systems not found."))
		return
	if(!owner.head.vision_flags)
		notify_user(usr, SPAN_WARNING("\The [owner.head] does not have any special sensor configurations."))
		return
	toggled = !toggled
	owner.head.active_sensors = toggled
	var/main_color = owner.head.active_sensors ? "#d1d1d1" : "#525252"
	maptext = "<span style=\"font-family: 'Small Fonts'; color: [main_color]; -dm-text-outline: 1 #242424; font-size: 5px;\">SENSOR</span>"
	notify_user(usr, SPAN_NOTICE("[capitalize_first_letters(owner.head.name)] Advanced Sensor mode is [owner.head.active_sensors ? "now" : "no longer" ] active."))

/obj/screen/mecha/toggle/megaspeakers
	name = "toggle integrated megaspeakers"
	icon_state = "base" // based
	maptext = "<span style=\"font-family: 'Small Fonts'; color: #525252; -dm-text-outline: 1 #242424; font-size: 5px;\">VOLUME</span>"
	maptext_x = 1
	maptext_y = 12

/obj/screen/mecha/toggle/megaspeakers/toggled()
	toggled = !toggled
	owner.loudening = toggled
	var/main_color = owner.loudening ? "#d1d1d1" : "#525252"
	maptext = "<span style=\"font-family: 'Small Fonts'; color: [main_color]; -dm-text-outline: 1 #242424; font-size: 5px;\">VOLUME</span>"
	notify_user(usr, SPAN_NOTICE("You [owner.loudening ? "activate" : "deactivate"] \the [owner]'s integrated megaspeakers."))

#undef BAR_CAP
