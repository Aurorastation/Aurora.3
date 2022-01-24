/obj/item/mecha_equipment/mounted_system/soul_javelin
	name = "mounted soul javelin"
	desc = "A heavy duty daemon shardlauncher, not for the faint of heart."
	icon_state = "mecha_souljavelin"
	holding_type = /obj/item/gun/energy/rifle/cult/mounted
	equipment_delay = -2
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_CULT)

/obj/item/mecha_equipment/doomblade
	name = "daemon doomblade"
	desc = "A large blade menacing with demonic energy, try to not touch the red parts."
	icon_state = "mecha_doomblade"
	equipment_delay = 5
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_CULT)
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	var/obj/item/melee/cultblade/doomblade

/obj/item/mecha_equipment/doomblade/Initialize()
	. = ..()
	doomblade = new /obj/item/melee/cultblade/mounted(src)

/obj/item/mecha_equipment/doomblade/attack(mob/living/M, mob/living/user)
	if(!owner)
		return
	doomblade.attack(M, user, user.zone_sel.selecting)