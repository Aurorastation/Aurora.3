/singleton/psionic_power/punch
	name = "Psi-Punch"
	desc = "Imbue your fists with psionic power."
	icon_state = "const_fist"
	point_cost = 2
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/punch

/obj/item/spell/punch
	name = "psi-punch"
	icon_state = "generic"
	cast_methods = CAST_MELEE
	aspect = ASPECT_PSIONIC
	force = 25
	armor_penetration = 15
	cooldown = 0
	psi_cost = 5
