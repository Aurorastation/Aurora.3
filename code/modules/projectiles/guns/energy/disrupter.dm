

/obj/item/gun/energy/disruptorpistol
	name = "disruptor pistol"
	desc = "A NanoTrasen designed blaster pistol with two settings: stun and lethal."
	desc_extended = "Developed and produced by NanoTrasen for its internal security division, the NT DP-7 is a state of the art blaster pistol capable of firing reduced-power bolts which disrupt the central nervous system, inducing a stunning effect on the victim. It is also capable of firing full-power blaster bolts."
	icon = 'icons/obj/guns/disruptorpistol/disruptorpistols.dmi'
	icon_state = "disruptorpistol"
	item_state = "disruptorpistol"
	fire_sound = 'sound/weapons/gunshot/bolter.ogg'
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = ITEMSIZE_NORMAL
	force = 5
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/energy/disruptorstun
	secondary_projectile_type = /obj/item/projectile/energy/blaster
	max_shots = 10
	charge_cost = 150
	accuracy = 1
	has_item_ratio = FALSE
	modifystate = "disruptorpistolstun"
	sel_mode = 1
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/energy/disruptorstun, modifystate="disruptorpistolstun", fire_sound = 'sound/weapons/gunshot/bolter.ogg'),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/energy/blaster/disruptor, modifystate="disruptorpistolkill", recoil = 1, fire_sound = 'sound/weapons/gunshot/bolter.ogg')
		)
	required_firemode_auth = list(WIRELESS_PIN_STUN, WIRELESS_PIN_LETHAL)
	var/selectframecheck = FALSE

/obj/item/gun/energy/disruptorpistol/security
	pin = /obj/item/device/firing_pin/wireless

/obj/item/gun/energy/disruptorpistol/miniature
	name = "miniature disruptor pistol"
	desc = "A NanoTrasen designed blaster pistol with two settings: stun and lethal. This is the miniature version."
	icon = 'icons/obj/guns/disruptorpistol/disruptorpistolc.dmi'
	max_shots = 8
	force = 3
	slot_flags = SLOT_BELT|SLOT_HOLSTER|SLOT_POCKET
	w_class = ITEMSIZE_SMALL

/obj/item/gun/energy/disruptorpistol/miniature/security
	pin = /obj/item/device/firing_pin/wireless

/obj/item/gun/energy/disruptorpistol/magnum
	name = "magnum disruptor pistol"
	desc = "A NanoTrasen designed blaster pistol with two settings: stun and lethal. This is the magnum version."
	icon = 'icons/obj/guns/disruptorpistol/disruptorpistolm.dmi'
	max_shots = 15
	force = 6

/obj/item/gun/energy/disruptorpistol/magnum/security
	pin = /obj/item/device/firing_pin/wireless
