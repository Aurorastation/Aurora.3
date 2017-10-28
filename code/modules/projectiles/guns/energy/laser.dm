/obj/item/weapon/gun/energy/laser
	name = "laser carbine"
	desc = "An Hephaestus Industries G40E carbine, designed to kill with concentrated energy blasts."
	icon_state = "laser"
	item_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 3
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/beam/midlaser
	can_turret = 1
	turret_sprite_set = "laser"

/obj/item/weapon/gun/energy/laser/mounted
	name = "mounted laser carbine"
	self_recharge = 1
	use_external_power = 1
	can_turret = 0

/obj/item/weapon/gun/energy/laser/practice
	name = "practice laser carbine"
	desc = "A modified version of the HI G40E, this one fires less concentrated energy bolts designed for target practice."
	projectile_type = /obj/item/projectile/beam/practice

obj/item/weapon/gun/energy/retro
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
	turret_sprite_set = "retro"

/obj/item/weapon/gun/energy/captain
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
	turret_sprite_set = "captain"

/obj/item/weapon/gun/energy/lasercannon
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
	turret_sprite_set = "cannon"

/obj/item/weapon/gun/energy/lasercannon/mounted
	name = "mounted laser cannon"
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	can_turret = 0

/obj/item/weapon/gun/energy/xray
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
	turret_sprite_set = "xray"

/obj/item/weapon/gun/energy/xray/mounted
	name = "mounted xray laser gun"
	charge_cost = 200
	self_recharge = 1
	use_external_power = 1
	recharge_time = 5
	can_turret = 0

/obj/item/weapon/gun/energy/sniperrifle
	name = "marksman energy rifle"
	desc = "The HI L.W.A.P. is an older design of Hephaestus Industries. A designated marksman rifle capable of shooting powerful ionized beams, this is a weapon to kill from a distance."
	icon_state = "sniper"
	item_state = "sniper"
	fire_sound = 'sound/weapons/marauder.ogg'
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5, TECH_POWER = 4)
	projectile_type = /obj/item/projectile/beam/sniper
	slot_flags = SLOT_BACK
	charge_cost = 400
	max_shots = 4
	fire_delay = 45
	force = 10
	w_class = 4
	accuracy = -5 //shooting at the hip
	scoped_accuracy = 0
	can_turret = 1
	turret_sprite_set = "sniper"

	fire_delay_wielded = 35
	accuracy_wielded = -3

	//action button for wielding
	action_button_name = "Wield rifle"

/obj/item/weapon/gun/energy/sniperrifle/can_wield()
	return 1

/obj/item/weapon/gun/energy/sniperrifle/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/energy/sniperrifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		usr << "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>"

/obj/item/weapon/gun/energy/laser/shotgun
	name = "quad-beam laser"
	desc = "A modified laser weapon, designed to split a single beam four times."
	icon_state = "oldenergykill"
	item_state = "energykill"
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 3
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
	dispersion = list(1.0, -1.0, 2.0, -2.0)
	can_turret = 1
	turret_sprite_set = "laser"

////////Laser Tag////////////////////

/obj/item/weapon/gun/energy/lasertag
	name = "laser tag gun"
	item_state = "laser"
	desc = "Standard issue weapon of the Imperial Guard"
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 2)
	self_recharge = 1
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	fire_sound = 'sound/weapons/Laser.ogg'
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	var/required_vest

/obj/item/weapon/gun/energy/lasertag/special_check(var/mob/living/carbon/human/M)
	if(ishuman(M))
		if(!istype(M.wear_suit, required_vest))
			M << "<span class='warning'>You need to be wearing your laser tag vest!</span>"
			return 0
	return ..()

/obj/item/weapon/gun/energy/lasertag/blue
	icon_state = "bluetag"
	item_state = "bluetag"
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	required_vest = /obj/item/clothing/suit/bluetag
	can_turret = 1
	turret_is_lethal = 0
	turret_sprite_set = "blue"

/obj/item/weapon/gun/energy/lasertag/red
	icon_state = "redtag"
	item_state = "redtag"
	projectile_type = /obj/item/projectile/beam/lastertag/red
	required_vest = /obj/item/clothing/suit/redtag
	can_turret = 1
	turret_is_lethal = 0
	turret_sprite_set = "red"

/obj/item/weapon/gun/energy/laser/prototype
	name = "laser prototype"
	desc = "A custom prototype laser weapon."
	icon_state = "laser"
	item_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 3
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/beam/prototype
	can_turret = 0
	var/origin_chassis
	var/gun_type
	var/obj/item/laser_components/modifier/modifier
	var/obj/item/laser_components/capacitor/capacitor
	var/obj/item/laser_components/focusing_lens/focusing_lens

/obj/item/weapon/gun/energy/laser/prototype/examine()
	..()
	if(modifier)
		usr << "You can see a [capacitor], a [focusing_lens], and a [modifier] attached."
	else
		usr << "You can see a [capacitor] and a [focusing_lens]"

/obj/item/weapon/gun/energy/laser/prototype/attackby(var/obj/item/weapon/D as obj, var/mob/user as mob)
	if(!isscrewdriver(D))
		return ..()
	user << "You disassemble the [src]."
	modifier.loc = src.loc
	capacitor = src.loc
	focusing_lens = src.loc
	new /obj/item/device/laser_assembly(src.loc)
	qdel(src)

/obj/item/weapon/gun/energy/laser/prototype/proc/updatetype()
	switch(origin_chassis)
		if(CHASSIS_SMALL)
			gun_type =  TYPE_PISTOL
			slot_flags = SLOT_BELT
			//item_state = sprite
			name = "A custom laser pistol."
		if(CHASSIS_MEDIUM)
			gun_type = TYPE_CARBINE
			slot_flags = SLOT_BELT
			//item_state = sprite
			name = "A custom laser carbine."
		if(CHASSIS_LARGE)
			gun_type = TYPE_RIFLE
			slot_flags = SLOT_BELT|SLOT_BACK
			//item_state = sprite
			name = "A custom laser rifle."
		if(CHASSIS_GATLING)
			gun_type = TYPE_GATLING
			slot_flags = SLOT_BACK
			//item_state = sprite
			name = "A custom gatling gun."
	if(modifier)
		handle_mod()
	projectile_type = /obj/item/projectile/beam/prototype
	w_class = gun_type
	reliability = capacitor.reliability + focusing_lens.reliability
	fire_delay = capacitor.fire_delay
	max_shots = capacitor.shots

/obj/item/weapon/gun/energy/laser/prototype/proc/handle_mod()
	switch(modifier.mod_type)
		if(MOD_SILENCE)
			silenced = 1
		if(MOD_NUCLEAR_CHARGE)
			self_recharge = 1
	fire_delay += modifier.fire_delay
	reliability += modifier.reliability

/obj/item/weapon/gun/energy/laser/prototype/consume_next_projectile()
	if(!power_supply) return null
	if(!ispath(projectile_type)) return null
	if(!power_supply.checked_use(charge_cost)) return null
	if (self_recharge) addtimer(CALLBACK(src, .proc/try_recharge), recharge_time * 2 SECONDS, TIMER_UNIQUE)
	var/obj/item/projectile/beam/prototype/A = new projectile_type(src)
	if(!istype(A))
		return ..()
	A.damage = capacitor.damage + modifier.damage
	A.armor_penetration = capacitor.armor_penetration + modifier.armor_penetration
	return A

/obj/item/weapon/gun/energy/laser/prototype/small_fail()
	
	return

/obj/item/weapon/gun/energy/laser/prototype/medium_fail()

	return

/obj/item/weapon/gun/energy/laser/prototype/critical_fail()

	return