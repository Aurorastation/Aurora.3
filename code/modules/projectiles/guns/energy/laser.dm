/obj/item/gun/energy/laser
	name = "laser carbine"
	desc = "An Hephaestus Industries G40E carbine, designed to kill with concentrated energy blasts."
	icon_state = "laserrifle"
	item_state = "laserrifle"
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	accuracy = 1
	w_class = 3
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/beam/midlaser
	can_turret = 1
	turret_is_lethal = 1
	turret_sprite_set = "laser"

/obj/item/gun/energy/laser/mounted
	name = "mounted laser carbine"
	self_recharge = 1
	use_external_power = 1
	can_turret = 0

/obj/item/gun/energy/laser/mounted/cyborg/overclocked
	max_shots = 15
	recharge_time = 1

/obj/item/gun/energy/laser/practice
	name = "practice laser carbine"
	desc = "A modified version of the HI G40E, this one fires less concentrated energy bolts designed for target practice."
	projectile_type = /obj/item/projectile/beam/practice

obj/item/gun/energy/retro
	name = "retro laser"
	icon_state = "retro"
	item_state = "retro"
	desc = "An older model of the basic lasergun. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT
	w_class = 3
	projectile_type = /obj/item/projectile/beam
	fire_delay = 10 //old technology
	can_turret = 1
	turret_is_lethal = 1
	turret_sprite_set = "retro"

/obj/item/gun/energy/captain
	name = "antique laser gun"
	icon_state = "caplaser"
	item_state = "caplaser"
	desc = "This is an antique laser gun. All craftsmanship is of the highest quality. It is decorated with assistant leather and chrome. The object menaces with spikes of energy. On the item is an image of Baystation 12. The station is exploding."
	force = 5
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT
	w_class = 3
	projectile_type = /obj/item/projectile/beam
	origin_tech = null
	max_shots = 5 //to compensate a bit for self-recharging
	self_recharge = 1
	can_turret = 1
	turret_is_lethal = 1
	turret_sprite_set = "captain"

/obj/item/gun/energy/lasercannon
	name = "laser cannon"
	desc = "With the laser cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	item_state = null
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	slot_flags = SLOT_BELT|SLOT_BACK
	projectile_type = /obj/item/projectile/beam/heavylaser
	charge_cost = 400
	max_shots = 5
	fire_delay = 20
	can_turret = 1
	turret_is_lethal = 1
	turret_sprite_set = "cannon"

/obj/item/gun/energy/lasercannon/mounted
	name = "mounted laser cannon"
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	can_turret = 0

/obj/item/gun/energy/lasercannon/mounted/cyborg/overclocked
	recharge_time = 1
	max_shots = 15

/obj/item/gun/energy/xray
	name = "xray laser gun"
	desc = "A high-power laser gun capable of expelling concentrated xray blasts."
	icon_state = "xray"
	item_state = "xray"
	fire_sound = 'sound/weapons/laser3.ogg'
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	projectile_type = /obj/item/projectile/beam/xray
	charge_cost = 100
	max_shots = 20
	fire_delay = 1
	can_turret = 1
	turret_is_lethal = 1
	turret_sprite_set = "xray"

/obj/item/gun/energy/xray/mounted
	name = "mounted xray laser gun"
	charge_cost = 200
	self_recharge = 1
	use_external_power = 1
	recharge_time = 5
	can_turret = 0

/obj/item/gun/energy/sniperrifle
	name = "marksman energy rifle"
	desc = "The HI L.W.A.P. is an older design of Hephaestus Industries. A designated marksman rifle capable of shooting powerful ionized beams, this is a weapon to kill from a distance."
	icon_state = "sniper"
	item_state = "psniper"
	fire_sound = 'sound/weapons/marauder.ogg'
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5, TECH_POWER = 4)
	projectile_type = /obj/item/projectile/beam/sniper
	slot_flags = SLOT_BACK
	charge_cost = 400
	max_shots = 4
	fire_delay = 45
	force = 10
	w_class = 4
	accuracy = -3 //shooting at the hip
	scoped_accuracy = 4
	can_turret = 1
	turret_sprite_set = "sniper"
	turret_is_lethal = 1

	is_wieldable = TRUE

	fire_delay_wielded = 35
	accuracy_wielded = 0

/obj/item/gun/energy/sniperrifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

/obj/item/gun/energy/laser/shotgun
	name = "quad-beam laser"
	desc = "A modified laser weapon, designed to split a single beam four times."
	icon_state = "oldenergykill"
	item_state = "energykill"
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 3
	accuracy = 0
	force = 10
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2)
	projectile_type = /obj/item/projectile/beam/shotgun
	max_shots = 12
	sel_mode = 1
	burst = 4
	burst_delay = 0
	move_delay = 0
	fire_delay = 2
	dispersion = list(10)
	can_turret = 1
	turret_is_lethal = 1
	turret_sprite_set = "laser"

////////Laser Tag////////////////////

/obj/item/gun/energy/lasertag
	name = "laser tag gun"
	item_state = "laser"
	desc = "Standard issue weapon of the Imperial Guard"
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 2)
	self_recharge = 1
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	fire_sound = 'sound/weapons/Laser.ogg'
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	var/required_vest

/obj/item/gun/energy/lasertag/special_check(var/mob/living/carbon/human/M)
	if(ishuman(M))
		if(!istype(M.wear_suit, required_vest))
			to_chat(M, "<span class='warning'>You need to be wearing your laser tag vest!</span>")
			return 0
	return ..()

/obj/item/gun/energy/lasertag/blue
	icon_state = "bluetag"
	item_state = "bluetag"
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	required_vest = /obj/item/clothing/suit/bluetag
	pin = /obj/item/device/firing_pin/tag/blue
	can_turret = 1
	turret_is_lethal = 0
	turret_sprite_set = "blue"

/obj/item/gun/energy/lasertag/red
	icon_state = "redtag"
	item_state = "redtag"
	projectile_type = /obj/item/projectile/beam/lastertag/red
	required_vest = /obj/item/clothing/suit/redtag
	pin = /obj/item/device/firing_pin/tag/red
	can_turret = 1
	turret_is_lethal = 0
	turret_sprite_set = "red"
