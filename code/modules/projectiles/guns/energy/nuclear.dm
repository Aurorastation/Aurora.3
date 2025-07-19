/obj/item/gun/energy/gun
	name = "energy carbine"
	desc = "A NanoTrasen designed energy-based carbine with two settings: Stun and kill."
	desc_extended = "The NT EC-4 is an energy carbine developed and produced by NanoTrasen. Compact, light and durable, used by security forces and law enforcement for its ability to fire stun or lethal beams, depending on selection. It is widely sold and distributed across the galaxy."
	icon = 'icons/obj/guns/ecarbine.dmi'
	icon_state = "energystun"
	item_state = "energystun"
	fire_sound = 'sound/weapons/Taser.ogg'
	slot_flags = SLOT_BELT
	accuracy = 1
	max_shots = 15
	can_turret = 1
	secondary_projectile_type = /obj/projectile/beam
	secondary_fire_sound = 'sound/weapons/laser1.ogg'
	can_switch_modes = 1
	turret_is_lethal = 0

	projectile_type = /obj/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "energystun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/projectile/beam/stun, modifystate="energystun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam, modifystate="energykill", fire_sound='sound/weapons/laser1.ogg')
		)

	has_item_ratio = FALSE

	var/crit_fail = 0 //Added crit_fail as a local variable

/obj/item/gun/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge = 1
	use_external_power = 1
	can_turret = 0

/obj/item/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon = 'icons/obj/guns/nucgun.dmi'
	icon_state = "nucgun"
	item_state = "nucgun"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	slot_flags = SLOT_BELT
	force = 18 //looks heavier than a pistol
	self_recharge = 1
	modifystate = null
	reliability = 95
	turret_sprite_set = "nuclear"
	charge_failure_message = "'s charging socket was removed to make room for a minaturized reactor."

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam, fire_sound='sound/weapons/laser1.ogg')
		)

	var/lightfail = 0

/obj/item/gun/energy/gun/nuclear/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Unlike most weapons, this weapon recharges itself."

/obj/item/gun/energy/gun/nuclear/get_cell()
	return DEVICE_NO_CELL

/obj/item/gun/energy/gun/nuclear/small_fail(var/mob/user)
	for (var/mob/living/M in range(0,src)) //Only a minor failure, enjoy your radiation if you're in the same tile or carrying it
		if (M == user)
			to_chat(M, SPAN_WARNING("Your gun feels pleasantly warm for a moment."))
		else
			to_chat(M, SPAN_WARNING("You feel a warm sensation."))
	SSradiation.radiate(src, rand(3, 50))
	return

/obj/item/gun/energy/gun/nuclear/medium_fail(var/mob/user)
	if(prob(50))
		critical_fail(user)
	else
		small_fail(user)
	return

/obj/item/gun/energy/gun/nuclear/critical_fail(var/mob/user)
	to_chat(user, SPAN_DANGER("Your gun's reactor overloads!"))
	for (var/mob/living/M in range(rand(1,4),src))
		to_chat(M, SPAN_WARNING("You feel a wave of heat wash over you."))
	SSradiation.radiate(src, rand(3, 80))
	crit_fail = 1 //break the gun so it stops recharging
	self_recharge = FALSE
	update_icon()
	return

/obj/item/gun/energy/gun/nuclear/proc/update_charge()
	if (crit_fail)
		AddOverlays("nucgun-whee")
		return
	var/ratio = max((power_supply?.charge / power_supply?.maxcharge), 0)
	ratio = round(ratio, 0.25) * 100
	AddOverlays("nucgun-[ratio]")

/obj/item/gun/energy/gun/nuclear/proc/update_reactor()
	if(crit_fail)
		AddOverlays("nucgun-crit")
		return
	if(lightfail)
		AddOverlays("nucgun-medium")
	else if ((power_supply?.charge/power_supply?.maxcharge) <= 0.5)
		AddOverlays("nucgun-light")
	else
		AddOverlays("nucgun-clean")

/obj/item/gun/energy/gun/nuclear/proc/update_mode()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	switch(current_mode.name)
		if("stun")
			AddOverlays("nucgun-stun")
		if("lethal")
			AddOverlays("nucgun-kill")

/obj/item/gun/energy/gun/nuclear/update_icon()
	ClearOverlays()
	update_charge()
	update_reactor()
	update_mode()

/obj/item/gun/energy/pistol
	name = "energy pistol"
	desc = "A NanoTrasen energy-based pistol gun with two settings: Stun and kill."
	desc_extended = "The NT EP-3 is an energy sidearm developed and produced by NanoTrasen. Compact, light and durable, used by security forces and law enforcement for its ability to fire stun or lethal beams, depending on selection. It is widely sold and distributed across the galaxy."
	icon = 'icons/obj/guns/epistol.dmi'
	icon_state = "epistolstun100"
	item_state = "epistolstun100"
	fire_sound = 'sound/weapons/Taser.ogg'
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	max_shots = 10
	fire_delay = 4
	can_turret = 1
	secondary_projectile_type = /obj/projectile/beam/pistol
	secondary_fire_sound = 'sound/weapons/laser1.ogg'
	can_switch_modes = 1
	turret_sprite_set = "carbine"
	turret_is_lethal = 0

	projectile_type = /obj/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "epistolstun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/projectile/beam/stun, modifystate="epistolstun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam/pistol, modifystate="epistolkill", fire_sound='sound/weapons/laser1.ogg')
		)

/obj/item/gun/energy/pistol/hegemony
	name = "hegemony energy pistol"
	desc = "An upgraded variant of the standard energy pistol with two settings: Incapacitate and Smite."
	desc_extended = "This is the Zkrehk-Guild Beamgun, an energy-based sidearm designed and manufactured on Moghes. A special crystal used in its design allows it to penetrate armor with pinpoint accuracy."
	icon = 'icons/obj/guns/hegemony_pistol.dmi'
	icon_state = "hegemony_pistol"
	item_state = "hegemony_pistol"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/Taser.ogg'
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	max_shots = 12
	fire_delay = 3
	can_turret = FALSE
	secondary_projectile_type = /obj/projectile/beam/pistol/hegemony
	secondary_fire_sound = 'sound/weapons/laser1.ogg'
	can_switch_modes = TRUE

	projectile_type = /obj/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)
	modifystate = "hegemony_pistol"

	firemodes = list(
		list(mode_name="incapacitate", projectile_type=/obj/projectile/beam/stun, modifystate="hegemony_pistol", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="smite", projectile_type=/obj/projectile/beam/pistol/hegemony, modifystate="hegemony_pistol", fire_sound='sound/weapons/laser1.ogg')
		)

/obj/item/gun/energy/pistol/goldendeep
	name = "golden deep ornate energy pistol"
	desc = "An intricate golden energy pistol, engraved with a quality unlike no other. If you had to describe this pistol in one word, it would be <b>expensive.</b>"
	desc_extended = "Possessed by only the most affluent affiliates of the Golden Deep, this ornate energy pistol covered in gold is the result of a commission, which had the artistic quality of Ultra Maz combined with the scientific technology acquired by the Estriconian to produce a weapon that many outsiders see as a firearm more valuable than the assets it was made to protect."
	icon = 'icons/obj/guns/goldendeep_ornatepistol.dmi'
	icon_state = "ornatepistolstun100"
	item_state = "ornatepistolstun100"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/laser2.ogg'
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	max_shots = 12
	fire_delay = 3
	can_turret = FALSE
	secondary_projectile_type = /obj/projectile/beam/pistol
	secondary_fire_sound = 'sound/weapons/laser3.ogg'
	can_switch_modes = TRUE

	projectile_type = /obj/projectile/beam/disorient
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)
	modifystate = "ornatepistolstun"

	firemodes = list(
		list(mode_name="disorient", projectile_type=/obj/projectile/beam/disorient, modifystate="ornatepistolstun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam/pistol, modifystate="ornatepistollethal", fire_sound='sound/weapons/laser1.ogg')
		)

/obj/item/gun/energy/repeater
	name = "energy repeater"
	desc = "A Stellar Corporate Conglomerate created energy repeater, extremely lightweight. It has three settings: Single, Three-Burst, and Full-Auto."
	desc_extended = "The SCC-ER1 was designed to be a reliable yet concealable firearm, capable of defending SCC assets and agents from various attackers."
	icon = 'icons/obj/guns/erepeater.dmi'
	icon_state = "energysmg100"
	item_state = "energysmg100"
	modifystate = "energysmg"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/energy_repeater.ogg'
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	max_shots = 24
	fire_delay = 3

	offhand_accuracy = 6 // same as firing it in your main hand

	projectile_type = /obj/projectile/beam/pistol/scc
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 4)

	firemodes = list(
		list(mode_name="single", can_autofire = FALSE, burst = 1),
		list(mode_name="three-burst", can_autofire = FALSE, burst = 3, burst_accuracy = list(1,0,0), dispersion = list(0, 10, 15)),
		list(mode_name="full-auto", can_autofire = TRUE, burst = 1, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3), dispersion = list(5, 10, 15, 20))
		)

/obj/item/gun/energy/repeater/pistol
	name = "Energy Pistol"
	desc = "A more compact and portable version of the Stellar Corporate Conglomerate Energy Repeater. It has two settings: Stun, and Lethal."
	desc_extended = "The SCC-ER1-2 was designed to be a reliable yet more compact version of the SCC-ER1, capable of defending Staff and Assets."
	icon = 'icons/obj/guns/sccpistol.dmi'
	icon_state = "sccpistolstun100"
	item_state = "sccpistolstun"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/Taser.ogg'
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	max_shots = 10
	fire_delay = 5
	secondary_projectile_type = /obj/projectile/beam/pistol/scc/weak
	secondary_fire_sound = 'sound/weapons/energy_repeater.ogg'
	can_switch_modes = 1

	projectile_type = /obj/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)
	modifystate = "sccpistolstun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/projectile/beam/stun, modifystate="sccpistolstun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam/pistol/scc/weak, modifystate="sccpistolkill", fire_sound='sound/weapons/energy_repeater.ogg')
		)

/obj/item/gun/energy/gun/skrell
	self_recharge = TRUE
	fire_sound = 'sound/weapons/Laser2.ogg'
	modifystate = null
	charge_failure_message = "'s charging socket was removed to make room for a recharger."
	secondary_fire_sound = 'sound/weapons/laser3.ogg'

/obj/item/gun/energy/gun/skrell/emp_act(severity)
	. = ..()

	return //Fuck robots.

/obj/item/gun/energy/gun/skrell/pistol
	name = "nralakk particle pistol"
	desc = "A Nralakk Federation particle-beam pistol with two settings: Disable and Lethal."
	icon = 'icons/obj/guns/nralakkpistol.dmi'
	icon_state = "particlepistol"
	item_state = "particlepistol"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	force = 11
	projectile_type = /obj/projectile/beam/stun/skrell
	secondary_projectile_type = /obj/projectile/beam/pulse/skrell

	firemodes = list(
		list(mode_name="disable", projectile_type=/obj/projectile/beam/stun/skrell, fire_sound='sound/weapons/Laser2.ogg'),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam/pulse/skrell, fire_sound='sound/weapons/laser3.ogg')
		)

/obj/item/gun/energy/gun/skrell/smg
	name = "nralakk particle submachinegun"
	desc = "A Nralakk Federation particle-beam submachine gun with two settings: Disable and Lethal."
	icon = 'icons/obj/guns/nralakksmg.dmi'
	icon_state = "particlesmg"
	item_state = "particlesmg"
	slot_flags = SLOT_BELT|SLOT_HOLSTER|SLOT_BACK
	max_shots = 18
	force = 16
	projectile_type = /obj/projectile/beam/stun/skrell
	secondary_projectile_type = /obj/projectile/beam/pulse/skrell

	firemodes = list(
		list(mode_name="disable", projectile_type=/obj/projectile/beam/stun/skrell, fire_sound='sound/weapons/Laser2.ogg'),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam/pulse/skrell, fire_sound='sound/weapons/laser3.ogg', burst = 2, burst_delay = 2)
		)

/obj/item/gun/energy/gun/qukala
	name = "tqi-qop carbine"
	desc = "The Tqi-Qop Carbine is the main weapon of the Qukala. Its compact light frame and excellent ammo capacity make it a superb weapon for the Skrell."
	desc_extended = ""
	icon = 'icons/obj/item/gun/energy/gun/qukala.dmi'
	icon_state = "qukalagun"
	item_state = "qukalagun"
	fire_sound = 'sound/weapons/Taser.ogg'
	slot_flags = SLOT_BELT
	accuracy = 2
	max_shots = 25
	secondary_projectile_type = /obj/projectile/beam
	secondary_fire_sound = 'sound/weapons/laser1.ogg'
	can_switch_modes = 1

	projectile_type = /obj/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "qukalagun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam/midlaser/skrell, fire_sound='sound/weapons/laser1.ogg')
		)

	has_item_ratio = FALSE

/obj/item/gun/energy/gun/qukala/mounted
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	can_turret = 0

/obj/item/gun/energy/fedpistol
	name = "nralakk energy pistol"
	desc = "A Skrell-made pistol that utilises a psionic control mechanism. It's made from a lightweight alloy."
	desc_extended = "A sidearm usually seen in the hands of Nralakk Federation officials and law enforcement, the Xuqm-3 energy pistol has a psionically-linked firing pin that checks for a developed Zona Bovinae in its user before it can be fired. A wire can be attached to the user's wrist to allow for mode switching using psionics rather than changing it physically. For non-psionic users, a small dial for mode switching has been attached."
	icon = 'icons/obj/guns/psi_pistol.dmi'
	icon_state = "psipistolstun100"
	item_state = "psipistolstun100"
	fire_sound = 'sound/weapons/Taser.ogg'
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	pin = /obj/item/device/firing_pin/psionic
	max_shots = 10
	fire_delay = 4
	can_turret = FALSE
	secondary_projectile_type = /obj/projectile/energy/blaster/skrell
	secondary_fire_sound = 'sound/weapons/laser3.ogg'
	can_switch_modes = TRUE
	projectile_type = /obj/projectile/energy/disruptorstun/skrell
	modifystate = "psipistolstun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/projectile/energy/disruptorstun/skrell, modifystate="psipistolstun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/projectile/energy/blaster/skrell, modifystate="psipistollethal", fire_sound='sound/weapons/laser3.ogg'),
		list(mode_name="ion", projectile_type=/obj/projectile/ion/small, modifystate="psipistolion", fire_sound='sound/weapons/laser1.ogg')
		)

/obj/item/gun/energy/fedpistol/nopsi
	pin = /obj/item/device/firing_pin
