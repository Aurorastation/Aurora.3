/obj/item/gun/energy/retro
	name = "\improper L104 laser gun"
	icon = 'icons/obj/guns/faction/antique/retro.dmi'
	icon_state = "retro"
	item_state = "retro"
	has_item_ratio = FALSE
	desc = "An older model laser pistol, small enough to be concealed but underpowered, inefficient, and deceptively heavy, especially compared \
	to modern laser weaponry. However, their overbuilt construction means that many examples have stood the test of time, and advances in rechargeable \
	power cell technology have now turned them into viable backup weapons for outlaws or anyone unable to acquire newer laser weapons."
	fire_sound = 'sound/weapons/laser1.ogg'
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	offhand_accuracy = 1
	projectile_type = /obj/projectile/beam
	fire_delay = 5
	can_turret = TRUE
	turret_is_lethal = TRUE
	turret_sprite_set = "retro"

	modifystate = "retro"

/obj/item/gun/energy/captain
	name = "\improper X-00 laser gun"
	icon = 'icons/obj/guns/faction/antique/caplaser.dmi'
	desc = "This is the X-00, an antique laser gun, out of production for decades and well beyond anyone's capacity to recreate. All craftsmanship is of the highest quality. The gun menaces with spikes of energy."
	icon_state = "caplaser"
	item_state = "caplaser"
	has_item_ratio = FALSE
	force = 11
	fire_sound = 'sound/weapons/laser1.ogg'
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	offhand_accuracy = 2
	projectile_type = /obj/projectile/beam
	origin_tech = null
	max_shots = 5 //to compensate a bit for self-recharging
	self_recharge = TRUE
	can_turret = TRUE
	turret_is_lethal = TRUE
	turret_sprite_set = "captain"

/obj/item/gun/energy/captain/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Unlike most energy weapons, this weapon recharges itself."

/obj/item/gun/energy/xray
	name = "\improper XG-1 X-Ray laser pistol"
	desc = "A NanoTrasen designed high-power laser sidearm capable of expelling concentrated X-Ray blasts."
	desc_extended = "The XG-1 is a laser sidearm developed and produced by NanoTrasen. A recent invention, used for specialist operations, it is presently being produced and sold in limited capacity over the galaxy. Designed for precision strikes, releasing concentrated xray blasts that are capable of hitting targets behind cover. It is compact with relatively high capacity to other sidearms."
	icon = 'icons/obj/guns/faction/nanotrasen_corporation/xray.dmi'
	icon_state = "xray"
	item_state = "xray"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/laser3.ogg'
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	projectile_type = /obj/projectile/beam/xray
	charge_cost = 100
	max_shots = 20
	fire_delay = 4
	burst_delay = 4
	can_turret = TRUE
	turret_is_lethal = TRUE
	turret_sprite_set = "xray"

/obj/item/gun/energy/xray/mounted
	name = "mounted xray laser gun"
	charge_cost = 200
	self_recharge = TRUE
	use_external_power = TRUE
	recharge_time = 5
	can_turret = FALSE

/obj/item/gun/energy/laser/shotgun
	name = "\improper QB-2 laser shotgun"
	desc = "A NanoTrasen designed laser weapon, designed to split a single amplified beam four times."
	desc_extended = "The QB-2 is a laser weapon developed and produced by NanoTrasen. Designed to fill in the niche that ballistic shotguns do, but in the form of laser weaponry. It is equipped with a special crystal lens that splits a single laser beam into four."
	icon = 'icons/obj/guns/faction/nanotrasen_corporation/lasershotgun.dmi'
	icon_state = "lasershotgun"
	item_state = "lasershotgun"
	modifystate = null
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/laser1.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	accuracy = 0
	force = 15
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2)
	projectile_type = /obj/projectile/beam/shotgun
	max_shots = 28
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
	name = "\improper QB-2E laser shotgun"
	desc = "A NanoTrasen designed laser weapon, designed to split a single amplified beam four times. This one is marked for expeditionary use."
	pin = /obj/item/firing_pin/away_site

////////Laser Tag////////////////////

ABSTRACT_TYPE(/obj/item/gun/energy/lasertag)
	name = "laser tag gun"
	desc = "A simple low-power laser gun, outfitted for use in laser tag arenas."
	item_state = "laser"
	has_item_ratio = FALSE
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 2)
	self_recharge = TRUE
	recharge_time = 2
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	fire_sound = 'sound/weapons/laser1.ogg'
	projectile_type = /obj/projectile/beam/laser_tag
	pin = /obj/item/firing_pin/tag/red
	can_turret = TRUE
	turret_is_lethal = FALSE
	turret_sprite_set = "red"

/obj/item/gun/energy/lasertag/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour == TOOL_MULTITOOL)
		var/chosen_color = tgui_input_list(user, "Which color do you wish your gun to be?", "Color Selection", list("blue", "red"))
		if(!chosen_color)
			return
		get_tag_color(chosen_color)
		to_chat(user, SPAN_NOTICE("\The [src] is now a [chosen_color] laser tag gun."))
		return
	return ..()

/obj/item/gun/energy/lasertag/proc/get_tag_color(var/set_color)
	projectile_type = text2path("/obj/projectile/beam/laser_tag/[set_color]")
	if(pin)
		QDEL_NULL(pin)
		var/pin_path = text2path("/obj/item/firing_pin/tag/[set_color]")
		pin = new pin_path(src)
	switch(set_color)
		if("red")
			icon = 'icons/obj/guns/faction/toy/redtag.dmi'
		if("blue")
			icon = 'icons/obj/guns/faction/toy/bluetag.dmi'
	icon_state = "[set_color]tag"
	item_state = icon_state
	modifystate = item_state
	update_held_icon()

/obj/item/gun/energy/lasertag/blue
	icon = 'icons/obj/guns/faction/toy/bluetag.dmi'
	icon_state = "bluetag"
	item_state = "bluetag"
	projectile_type = /obj/projectile/beam/laser_tag/blue
	pin = /obj/item/firing_pin/tag/blue
	turret_sprite_set = "blue"

/obj/item/gun/energy/lasertag/red
	icon = 'icons/obj/guns/faction/toy/redtag.dmi'
	icon_state = "redtag"
	item_state = "redtag"
