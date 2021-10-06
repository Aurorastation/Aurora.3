/obj/screen/gun
	name = "gun"
	icon = 'icons/mob/screen/generic.dmi'
	master = null
	dir = 2

/obj/screen/gun/Click(location, control, params)
	if(!usr)
		return
	return 1

/obj/screen/gun/move
	name = "Allow Movement"
	icon_state = "no_walk0"
	screen_loc = ui_gun2

/obj/screen/gun/move/Click(location, control, params)
	if(..())
		var/mob/living/user = usr
		if(istype(user))
			if(!user.aiming) user.aiming = new(user)
			user.aiming.toggle_permission(TARGET_CAN_MOVE)
		return 1
	return 0

/obj/screen/gun/item
	name = "Allow Item Use"
	icon_state = "no_item0"
	screen_loc = ui_gun1

/obj/screen/gun/item/Click(location, control, params)
	if(..())
		var/mob/living/user = usr
		if(istype(user))
			if(!user.aiming) user.aiming = new(user)
			user.aiming.toggle_permission(TARGET_CAN_CLICK)
		return 1
	return 0

/obj/screen/gun/mode
	name = "Toggle Gun Mode"
	icon_state = "gun0"
	screen_loc = ui_gun_select

/obj/screen/gun/mode/Click(location, control, params)
	if(..())
		var/mob/living/user = usr
		if(istype(user))
			if(!user.aiming) user.aiming = new(user)
			user.aiming.toggle_active()
		return 1
	return 0

/obj/screen/gun/radio
	name = "Allow Radio Use"
	icon_state = "no_radio0"
	screen_loc = ui_gun4

/obj/screen/gun/radio/Click(location, control, params)
	if(..())
		var/mob/living/user = usr
		if(istype(user))
			if(!user.aiming) user.aiming = new(user)
			user.aiming.toggle_permission(TARGET_CAN_RADIO)
		return 1
	return 0

/obj/screen/gun/burstfire
	name = "Toggle Firing Mode"
	desc = "This can be used in a macro as toggle-firing-mode."
	icon_state = "toggle_burst_fire"
	screen_loc = ui_burstfire

/obj/screen/gun/burstfire/Click(location, control, params)
	if(..())
		var/mob/living/user = usr
		if(istype(user))
			var/obj/item/gun/dakka = user.get_active_hand()
			if(istype(dakka))
				dakka.toggle_firing_mode(user)
			else
				if(istype(user.loc, /mob/living/heavy_vehicle)) //may God forgive me for this
					var/mob/living/heavy_vehicle/snowflake = user.loc
					var/obj/item/mecha_equipment/mounted_system/MS = snowflake.selected_system
					dakka = MS.holding
					if(istype(dakka))
						dakka.toggle_firing_mode(user)

/obj/screen/gun/uniqueaction
	name = "Unique Action"
	desc = "This can be used in a macro as unique-action."
	icon_state = "unique_action"
	screen_loc = ui_uniqueaction

/obj/screen/gun/uniqueaction/Click(location, control, params)
	if(..())
		var/mob/living/user = usr
		if(istype(user))
			var/obj/item/gun/dakka = user.get_active_hand()
			if(istype(dakka))
				dakka.unique_action(user)
			else
				if(istype(user.loc, /mob/living/heavy_vehicle)) //may God forgive me for this
					var/mob/living/heavy_vehicle/snowflake = user.loc
					var/obj/item/mecha_equipment/mounted_system/MS = snowflake.selected_system
					dakka = MS.holding
					if(istype(dakka))
						dakka.unique_action(user)