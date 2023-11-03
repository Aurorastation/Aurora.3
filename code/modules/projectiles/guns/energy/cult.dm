/obj/item/gun/energy/rifle/cult
	name = "bloodpike"
	desc = "A ranged weapon of demonic origin, surely. It menaces with crimson spikes."
	desc_info = null
	desc_extended = null
	desc_antag = "This weapon can be recharged by clicking on blood or remains with it, remains recharge more than simple blood."
	icon = 'icons/obj/guns/bloodpike.dmi'
	icon_state = "bloodpike"
	item_state = "bloodpike"
	fire_sound = 'sound/weapons/laserstrong.ogg'
	slot_flags = SLOT_BACK
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
	light_color = COLOR_RED // muzzle flash

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

/obj/item/gun/energy/rifle/cult/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent && iscultist(user))
		if(istype(A, /obj/effect/decal/remains) || istype(A, /obj/effect/decal/cleanable/blood))
			do_absorb(user, A)
			return
	..()

/obj/item/gun/energy/rifle/cult/proc/do_absorb(var/mob/user, var/atom/A)
	var/did_absorb
	if(istype(A, /obj/effect/decal/remains))
		power_supply.give(power_supply.maxcharge / 2) // remains are hard to get, so they give a full half-recharge
		did_absorb = TRUE
	else if(istype(A, /obj/effect/decal/cleanable/blood))
		power_supply.give(charge_cost)
		did_absorb = TRUE

	if(did_absorb)
		user.visible_message("<b>[user]</b> runs \the [src] over \the [A], which it absorbs!", SPAN_CULT("\The [src] absorbs \the [A], powering it up!"))
		playsound(get_turf(src), 'sound/effects/blobattack.ogg', 30, TRUE)
		qdel(A)
		update_icon()

/obj/item/gun/energy/rifle/cult/mounted
	max_shots = 15
	use_external_power = TRUE
	self_recharge = TRUE
	has_safety = FALSE
	does_process = FALSE
	projectile_type = /obj/item/projectile/bullet/shard/heavy
