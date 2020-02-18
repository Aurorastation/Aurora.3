/obj/item/gun/energy/rifle/cult
	name = "bloodpike"
	desc = "A ranged weapon of demonic origin, surely. It menaces with crimson spikes."
	description_antag = "This weapon siphons the blood of the wielder to regenerate its ammo."
	icon = 'icons/obj/guns/bloodpike.dmi'
	icon_state = "bloodpike"
	item_state = "bloodpike"
	fire_sound = 'sound/weapons/laserstrong.ogg'
	slot_flags = SLOT_BACK // see if i can get a sprite for this
	w_class = ITEMSIZE_LARGE
	force = 10
	max_shots = 5
	fire_delay = 25
	accuracy = -1
	can_turret = FALSE
	can_switch_modes = FALSE
	charge_failure_message = " cannot be rearmed by normal means."

	has_icon_ratio = TRUE
	has_item_ratio = FALSE

	fire_delay_wielded = 1
	accuracy_wielded = 2

	projectile_type = /obj/item/projectile/bullet/shard
	secondary_projectile_type = null
	secondary_fire_sound = null
	firemodes = list()
	modifystate = null

	var/does_process = TRUE

	matter = null
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2, TECH_MAGNET = 3, TECH_ARCANE = 2, TECH_ILLEGAL = 3)

	is_wieldable = TRUE // see if i can get a sprite for this

/obj/item/gun/energy/rifle/cult/Initialize()
	. = ..()
	if(does_process)
		START_PROCESSING(SSprocessing, src)

/obj/item/gun/energy/rifle/cult/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/gun/energy/rifle/cult/process()
	if(power_supply.charge >= power_supply.maxcharge)
		return
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(isipc(src.loc)) // if it's an IPC, we use its cell charge to charge
			if(H.nutrition)
				H.adjustNutritionLoss(20)
				power_supply.give(charge_cost)
			return
		if(H.vessel.get_reagent_amount("blood") < BLOOD_VOLUME_OKAY)
			return
		H.vessel.remove_reagent("blood", (H.species.blood_volume * 0.025)) // otherwise, if it's a human, we use blood to recharge
		power_supply.give(charge_cost)

/obj/item/gun/energy/rifle/cult/mounted
	use_external_power = TRUE
	self_recharge = TRUE
	has_safety = FALSE
	does_process = FALSE
	projectile_type = /obj/item/projectile/bullet/shard/heavy