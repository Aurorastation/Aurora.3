#define ENERGY_PISTOL 1
#define HEGEMONY_PISTOL 2
#define ZORA_BLASTER 3
#define BIESEL_REVOLVER 4


/obj/item/device/gunkit
	name = "gun selection kit"
	desc = "A kit containing a firearm waiting to be collected."
	desc_info = "This is an OOC item, don't let anyone see it! In order to select a firearm simply control-click on the gunkit and press the option you want."
	icon_state = "modkit"
	var/used = 0

/obj/item/device/gunkit/CtrlClick(mob/user)
	if(owner(holding, /obj/item/device/gunkit))
			var/current_mode = show_radial_menu(user, owner, R.radial_modes, radius = 42, require_near = FALSE , tooltips = FALSE)
				switch(current_mode)
					if("Energy Pistol")
						H.equip_to_slot_or_del(new /obj/item/gun/energy/pistol(H), slot_in_backpack)
						var/used = 1
					if("Nothing")
						var/used = 1
						return


	if(var/used = 1)
		to_chat(user, "<span class='warning'>A firearm has been left in your bag.</span>")
		user.drop_from_inventory(src,O)
		qdel(src)
		return

/obj/item/device/gunkit/klax


/obj/item/device/gunkit/CtrlClick(mob/user)
	if(owner(holding, /obj/item/device/gunkit))
			var/current_mode_unathi = show_radial_menu(user, owner, R.radial_modes, radius = 42, require_near = FALSE , tooltips = FALSE)
				switch(current_mode_unathi)
					if("Energy Pistol")
						H.equip_to_slot_or_del(new /obj/item/gun/energy/pistol(H), slot_in_backpack)
					if("Hegemony Pistol")
						H.equip_to_slot_or_del(new /obj/item/gun/energy/pistol/hegemony(H), slot_in_backpack)

/obj/item/device/gunkit/bieselta
