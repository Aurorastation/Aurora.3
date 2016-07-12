/mob/living/silicon/robot/syndicate
	lawupdate = 0
	scrambledcodes = 1
	icon = 'icons/mob/robots.dmi'
	icon_state = "syndie_bloodhound"
	lawchannel = "State"
	req_access = list(access_syndicate)

/mob/living/silicon/robot/syndicate/New()
	if(!cell)
		cell = new /obj/item/weapon/cell(src)
		cell.maxcharge = 25000
		cell.charge = 25000

	..()

//syndicate borg gear

/obj/item/weapon/gun/energy/mountedsmg
	name = "mounted SMG"
	desc = "A cyborg mounted sub machine gun, it can print more bullets over time."
	icon_state = "lawgiver" //placeholder for now
	item_state = "lawgiver"
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	max_shots = 20
	charge_cost = 100
	projectile_type = /obj/item/projectile/bullet/pistol
	self_recharge = 1
	use_external_power = 1
	recharge_time = 5

	firemodes = list(
	list(name="semiauto", burst=1, fire_delay=0),
	list(name="3-round bursts", burst=3, move_delay=4, accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 1.0)),
	list(name="short bursts", 	burst=5, move_delay=4, accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
	)

