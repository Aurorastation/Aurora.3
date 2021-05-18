/obj/item/gun/energy/laser
	name = "laser carbine"
	desc = "An Hephaestus Industries G40E carbine, designed to kill with concentrated energy blasts."
	icon = 'icons/obj/guns/laserrifle.dmi'
	icon_state = "laserrifle100"
	item_state = "laserrifle100"
	has_item_ratio = FALSE // the back and suit slots have ratio sprites but the in-hands dont
	fire_sound = 'sound/weapons/laser1.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	accuracy = 1
	w_class = ITEMSIZE_NORMAL
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/beam/midlaser
	can_turret = 1
	turret_is_lethal = 1
	turret_sprite_set = "laser"

	modifystate = "laserrifle"

/obj/item/gun/energy/laser/mounted
	name = "mounted laser carbine"
	has_safety = FALSE
	self_recharge = TRUE
	use_external_power = TRUE
	can_turret = FALSE

/obj/item/gun/energy/laser/mounted/cyborg/overclocked
	max_shots = 15
	recharge_time = 1

/obj/item/gun/energy/laser/practice
	name = "practice laser carbine"
	desc = "A modified version of the HI G40E, this one fires less concentrated energy bolts designed for target practice."
	projectile_type = /obj/item/projectile/beam/practice

obj/item/gun/energy/retro
	name = "retro laser"
	icon = 'icons/obj/guns/retro.dmi'
	icon_state = "retro"
	item_state = "retro"
	has_item_ratio = FALSE
	desc = "An older model of the basic lasergun. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."
	fire_sound = 'sound/weapons/laser1.ogg'
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	offhand_accuracy = 1
	projectile_type = /obj/item/projectile/beam
	fire_delay = 10 //old technology
	can_turret = 1
	turret_is_lethal = 1
	turret_sprite_set = "retro"

	modifystate = "retro"

/obj/item/gun/energy/captain
	name = "antique laser gun"
	icon = 'icons/obj/guns/caplaser.dmi'
	desc = "This is an antique laser gun. All craftsmanship is of the highest quality. The object menaces with spikes of energy."
	desc_info = "This is an energy weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  Most energy weapons can fire through windows harmlessly. Unlike most weapons, this weapon recharges itself."
	icon_state = "caplaser"
	item_state = "caplaser"
	has_item_ratio = FALSE
	force = 5
	fire_sound = 'sound/weapons/laser1.ogg'
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	offhand_accuracy = 2
	projectile_type = /obj/item/projectile/beam
	origin_tech = null
	max_shots = 5 //to compensate a bit for self-recharging
	self_recharge = 1
	can_turret = 1
	turret_is_lethal = 1
	turret_sprite_set = "captain"

/obj/item/gun/energy/lasercannon
	name = "laser cannon"
	desc = "A nanotrasen designed laser cannon capable of acting as a powerful support weapon."
	desc_fluff = "The NT LC-4 is a laser cannon developed and produced by Nanotrasen. Produced and sold to organizations both in need of a highly powerful support weapon and can afford its high unit cost. In spite of the low capacity, it is a highly capable tool, cutting down fortifications and armored targets with ease."
	icon = 'icons/obj/guns/lasercannon.dmi'
	icon_state = "lasercannon100"
	item_state = "lasercannon100"
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

	modifystate = "lasercannon"

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
	desc = "A Nanotrasen designed high-power laser sidearm capable of expelling concentrated xray blasts."
	desc_fluff = "The NT XG-1 is a laser sidearm developed and produced by Nanotrasen. A recent invention, used for specialist operations, it is presently being produced and sold in limited capacity over the galaxy. Designed for precision strikes, releasing concentrated xray blasts that are capable of hitting targets behind cover. It is compact with relatively high capacity to other sidearms."
	icon = 'icons/obj/guns/xray.dmi'
	icon_state = "xray"
	item_state = "xray"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/laser3.ogg'
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	projectile_type = /obj/item/projectile/beam/xray
	charge_cost = 100
	max_shots = 20
	fire_delay = 4
	burst_delay = 4
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
	desc_info = "This is an energy weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  Most energy weapons can fire through windows harmlessly.  To recharge this weapon, use a weapon recharger. \
	To use the scope, use the appropriate verb in the object tab."
	icon = 'icons/obj/guns/sniper.dmi'
	icon_state = "sniper"
	item_state = "sniper"
	has_item_ratio = FALSE // same as the laserrifle
	fire_sound = 'sound/weapons/marauder.ogg'
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5, TECH_POWER = 4)
	projectile_type = /obj/item/projectile/beam/sniper
	slot_flags = SLOT_BACK
	charge_cost = 400
	max_shots = 4
	fire_delay = 45
	force = 10
	w_class = ITEMSIZE_LARGE
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
	name = "laser shotgun"
	desc = "A Nanotrasen designed laser weapon, designed to split a single amplified beam four times."
	desc_fluff = "The NT QB-2 is a laser weapon developed and produced by Nanotrasen. Designed to fill in the niche that ballistic shotguns do, but in the form of laser weaponry. It is equipped with a special crystal lens that splits a single laser beam into four."
	icon = 'icons/obj/guns/lasershotgun.dmi'
	icon_state = "lasershotgun"
	item_state = "lasershotgun"
	modifystate = null
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/laser1.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEMSIZE_LARGE
	accuracy = 0
	force = 10
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2)
	projectile_type = /obj/item/projectile/beam/shotgun
	max_shots = 20
	sel_mode = 1
	is_wieldable = TRUE
	burst = 4
	burst_delay = 0
	move_delay = 0
	fire_delay = 2
	dispersion = list(10)
	can_turret = TRUE
	turret_is_lethal = TRUE
	turret_sprite_set = "laser"

/obj/item/gun/energy/laser/shotgun/research
	name = "expedition shotgun"
	desc = "A Nanotrasen designed laser weapon, designed to split a single amplified beam four times. This one is marked for expeditionary use."
	pin = /obj/item/device/firing_pin/away_site

////////Laser Tag////////////////////

/obj/item/gun/energy/lasertag
	name = "laser tag gun"
	desc = "A simple low-power laser gun, outfitted for use in laser tag arenas."
	item_state = "laser"
	has_item_ratio = FALSE
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 2)
	self_recharge = TRUE
	recharge_time = 2
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	fire_sound = 'sound/weapons/laser1.ogg'
	projectile_type = /obj/item/projectile/beam/laser_tag
	pin = /obj/item/device/firing_pin/tag/red
	can_turret = TRUE
	turret_is_lethal = FALSE
	turret_sprite_set = "red"

/obj/item/gun/energy/lasertag/attackby(obj/item/I, mob/user)
	if(I.ismultitool())
		var/chosen_color = input(user, "Which color do you wish your gun to be?", "Color Selection") as null|anything in list("blue", "red")
		if(!chosen_color)
			return
		get_tag_color(chosen_color)
		to_chat(user, SPAN_NOTICE("\The [src] is now a [chosen_color] laser tag gun."))
		return
	return ..()

/obj/item/gun/energy/lasertag/proc/get_tag_color(var/set_color)
	projectile_type = text2path("/obj/item/projectile/beam/laser_tag/[set_color]")
	if(pin)
		QDEL_NULL(pin)
		var/pin_path = text2path("/obj/item/device/firing_pin/tag/[set_color]")
		pin = new pin_path(src)
	switch(set_color)
		if("red")
			icon = 'icons/obj/guns/redtag.dmi'
		if("blue")
			icon = 'icons/obj/guns/bluetag.dmi'
	icon_state = "[set_color]tag"
	item_state = icon_state
	modifystate = item_state
	update_held_icon()

/obj/item/gun/energy/lasertag/blue
	icon = 'icons/obj/guns/bluetag.dmi'
	icon_state = "bluetag"
	item_state = "bluetag"
	projectile_type = /obj/item/projectile/beam/laser_tag/blue
	pin = /obj/item/device/firing_pin/tag/blue
	turret_sprite_set = "blue"

/obj/item/gun/energy/lasertag/red
	icon = 'icons/obj/guns/redtag.dmi'
	icon_state = "redtag"
	item_state = "redtag"