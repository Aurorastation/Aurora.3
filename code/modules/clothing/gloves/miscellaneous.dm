/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "black"
	siemens_coefficient = 1.0

/obj/item/clothing/gloves/swat
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	name = "\improper SWAT gloves"
	icon_state = "black"
	item_state = "black"
	siemens_coefficient = 0.50
	permeability_coefficient = 0.05

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/swat/ert
	species_restricted = null

/obj/item/clothing/gloves/swat/tactical
	name = "\improper tactical gloves"
	icon_state = "black_leather"
	item_state = "black_leather"
	species_restricted = null

/obj/item/clothing/gloves/combat //Combined effect of SWAT gloves and insulated gloves
	desc = "These tactical gloves are somewhat fire and impact resistant."
	name = "combat gloves"
	icon_state = "black"
	item_state = "black"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/ring/ninja
	desc = "A pair of plain black infiltration gloves. Too thin to protect anything, but can fit underneath a hardsuit gauntlet."
	name = "black slipgloves"
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "black"
	item_state = "black"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	undergloves = 1
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/latex
	name = "latex gloves"
	desc = "Sterile latex gloves."
	desc_info = "You can make balloons with these using some cable coil."
	icon_state = "latex"
	item_state = "latex"
	siemens_coefficient = 1.0 //thin latex gloves, much more conductive than fabric gloves (basically a capacitor for AC)
	permeability_coefficient = 0.01
	germ_level = 0
	fingerprint_chance = 75
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'
	var/balloon = /obj/item/toy/balloon/latex

/obj/item/clothing/gloves/latex/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = attacking_item
		if(C.use(1))
			var/obj/item/L = new src.balloon
			user.drop_from_inventory(L,get_turf(src))
			to_chat(user, "<span class='notice'>You make a balloon.</span>")
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You need one length of cable to finish the balloon!</span>")
	. = ..()

/obj/item/clothing/gloves/latex/nitrile
	name = "nitrile gloves"
	desc = "Sterile nitrile gloves."
	icon_state = "nitrile"
	item_state = "nitrile"
	balloon = /obj/item/toy/balloon/latex/nitrile
	anomaly_protection = 0.1

/obj/item/clothing/gloves/latex/nitrile/unathi
	name = "unathi nitrile gloves"
	desc = "Sterile nitrile gloves. Designed for Unathi use."
	icon_state = "nitrile"
	item_state = "nitrile"
	species_restricted = list(BODYTYPE_UNATHI)

/obj/item/clothing/gloves/latex/nitrile/tajara
	name = "tajaran nitrile gloves"
	desc = "Sterile nitrile gloves. Designed for Tajara use."
	icon_state = "nitrile"
	item_state = "nitrile"
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/latex/nitrile/vaurca
	name = "vaurca nitrile gloves"
	desc = "Sterile nitrile gloves. Designed for Vaurca use."
	icon_state = "nitrile"
	item_state = "nitrile"
	species_restricted = list(BODYTYPE_VAURCA)

/obj/item/clothing/gloves/latex/unathi
	name = "unathi latex gloves"
	desc = "Sterile latex gloves. Designed for Unathi use."
	species_restricted = list(BODYTYPE_UNATHI)

/obj/item/clothing/gloves/latex/tajara
	name = "tajaran latex gloves"
	desc = "Sterile latex gloves. Designed for Tajara use."
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/latex/vaurca
	name = "vaurca latex gloves"
	desc = "Sterile latex gloves. Designed for Vaurca use."
	species_restricted = list(BODYTYPE_VAURCA)

/obj/item/clothing/gloves/botanic_leather
	desc = "These leather work gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	name = "leather gloves"
	icon_state = "leather"
	item_state = "leather"
	permeability_coefficient = 0.05
	siemens_coefficient = 0.50 //thick work gloves
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

/obj/item/clothing/gloves/botanic_leather/unathi
	name = "unathi leather gloves"
	species_restricted = list(BODYTYPE_UNATHI)

/obj/item/clothing/gloves/botanic_leather/tajara
	name = "tajaran leather gloves"
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/botanic_leather/vaurca
	name = "vaurca leather gloves"
	species_restricted = list(BODYTYPE_VAURCA)

/obj/item/clothing/gloves/janitor
	name = "rubber cleaning gloves"
	desc = "A pair of thick, long, yellow rubber gloves, designed to protect the wearer from the splash of industrial strength cleaners. Not certified for electrical work."
	icon_state = "janitor"
	item_state = "janitor"
	permeability_coefficient = 0.01 //Prevents chemical seepage as well as latex, but without any of the sterility or protection
	siemens_coefficient = 0.50
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'

/obj/item/clothing/gloves/janitor/unathi
	name = "unathi cleaning gloves"
	species_restricted = list(BODYTYPE_UNATHI)

/obj/item/clothing/gloves/janitor/tajara
	name = "tajaran cleaning gloves"
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/janitor/vaurca
	name = "vaurca cleaning gloves"
	species_restricted = list(BODYTYPE_VAURCA)

	/*
	Forcegloves.  They amplify force from melee hits as well as muck up disarm and stuff a little.
	Has bits of code in item_attack.dm, stungloves.dm, human_attackhand, human_defense
	*/


/obj/item/clothing/gloves/force // this pair should be put in r&d if you choose to do so.  and also the hos office locker.  do it okay
	name = "force gloves"
	desc = "These gloves bend gravity and bluespace, dampening inertia and augmenting the wearer's melee capabilities."
	icon_state = "force_glove" //todo: different sprites for different levels of power
	item_state = "force_glove"
	siemens_coefficient = 0.6
	permeability_coefficient = 0.05
	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

	var/active = 1 //i am actually too lazy to code an on/off switch so if you want it off, take them off for now.  yes.
	var/amplification = 2

/obj/item/clothing/gloves/force/basic //dooo iiiitttttt
	name = "basic force gloves" //do it skull do it give it to all sec the forums agree go
	desc = "These gloves bend gravity and bluespace, providing a cheap boost to the effectiveness of your average security staff."
	icon_state = "power_glove" //todo: different sprites for different levels of power
	item_state = "power_glove"
	amplification = 1 //just do it

/obj/item/clothing/gloves/force/syndicate  //for syndies.  pda, *maybe* nuke team or ert.  up to you.  maybe just use the amp 2 variant.
	name = "enhanced force gloves"
	amplification = 2.5 //because *2.5 is kind of scary okay.  sometimes you want the scary effect.  sometimes not.

/obj/item/clothing/gloves/brassknuckles
	name = "brass knuckles"
	desc = "A pair of brass knuckles. Generally used to enhance the user's punches."
	icon_state = "knuckledusters"
	item_state = "knuckledusters"
	attack_verb = list("punched", "beaten", "struck")
	siemens_coefficient = 1
	fingerprint_chance = 100
	force = 11
	punch_force = 5
	clipped = 1
	matter = list(DEFAULT_WALL_MATERIAL = 1000)

	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = /singleton/sound_category/sword_pickup_sound

/obj/item/clothing/gloves/powerfist
	name = "power fist"
	desc = "A metal gauntlet with a piston-powered ram ontop for that extra punch in your punch."
	icon_state = "powerfist"
	item_state = "powerfist"
	attack_verb = list("whacked", "fisted", "power-punched")
	siemens_coefficient = 1
	fingerprint_chance = 50
	force = 11
	punch_force = 10
	clipped = 1
	species_restricted = list("exclude",BODYTYPE_GOLEM,BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_VAURCA_BULWARK)
	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'
	gender = NEUTER

/obj/item/clothing/gloves/powerfist/Touch(atom/A, mob/living/user, proximity)
	if(!proximity)
		return

	if(!isliving(A))
		return

	var/mob/living/L = A

	if(prob(50) && (user.a_intent == I_HURT))
		playsound(user, 'sound/weapons/beartrap_shut.ogg', 50, 1, -1)
		user.visible_message("<span class='danger'>\The [user] slams \the [L] away with \the [src]!</span>")
		var/T = get_turf(user)
		spark(T, 3, GLOB.alldirs)
		L.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.apply_effect(2, WEAKEN)

/obj/item/clothing/gloves/claws
	name = "clawed gauntlets"
	desc = "A pair of metal gauntlets outfited with menacing sharp blades."
	icon_state = "warping_claws"
	item_state = "warping_claws"
	attack_verb = list("ripped", "torn", "cut")
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
	)
	siemens_coefficient = 1
	force = 11
	punch_force = 10
	clipped = 1
	sharp = 1
	edge = TRUE
	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'

/obj/item/clothing/gloves/offworlder
	name = "starmitts"
	desc = "Thick arm warmers and mittens that reach past the elbow."
	icon = 'icons/obj/item/clothing/accessory/offworlder.dmi'
	contained_sprite = TRUE
	icon_state = "starmittens"
	item_state = "starmittens"
	build_from_parts = TRUE
	worn_overlay = "over"

/obj/item/clothing/gloves/tcaf
	name = "\improper TCAF armsman gloves"
	desc = "A pair of khaki tactical gloves with reinforcement at the knuckles and an adjustable strap at the wrist."
	icon = 'icons/clothing/under/uniforms/tcaf_uniform.dmi'
	contained_sprite = TRUE
	icon_state = "tcaf_armsman_gloves"
	item_state = "tcaf_armsman_gloves"
	build_from_parts = TRUE
	worn_overlay = "over"

/obj/item/clothing/gloves/ballistic
	name = "ballistic gauntlet"
	desc = "A metal gauntlet armed with a wrist-mounted shotgun."
	icon_state = "ballisticfist"
	item_state = "ballisticfist"
	siemens_coefficient = 1
	fingerprint_chance = 50
	clipped = 1
	species_restricted = list("exclude",BODYTYPE_GOLEM,BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_VAURCA_BULWARK)
	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'
	gender = NEUTER
	var/obj/item/gun/projectile/mounted
	var/gun_type = /obj/item/gun/projectile/shotgun/doublebarrel/pellet

/obj/item/clothing/gloves/ballistic/Initialize()
	. = ..()
	if(!mounted)
		var/obj/item/gun/projectile/new_gun = new gun_type (src)
		mounted = new_gun
		mounted.name = "wrist-mounted [initial(new_gun.name)]"

/obj/item/clothing/gloves/ballistic/Destroy()
	if(mounted)
		QDEL_NULL(mounted)
	return ..()

/obj/item/clothing/gloves/ballistic/Touch(atom/A, mob/living/user, proximity)
	if(!proximity)
		return

	if(!isliving(A))
		return

	var/mob/living/L = A

	if(user.a_intent == I_HURT)
		if(mounted)
			spark(user, 3, GLOB.alldirs)
			mounted.Fire(L, user)

/obj/item/clothing/gloves/ballistic/attackby(obj/item/attacking_item, mob/user)
	..()
	if(mounted)
		mounted.load_ammo(attacking_item, user)
		return

/obj/item/clothing/gloves/ballistic/verb/unload_shells()
	set name = "Unload Ballistic Gauntlet"
	set desc = "Unload the shells from the gauntlet's mounted gun."
	set category = "Object"
	set src in usr

	if(usr.stat || usr.restrained() || usr.incapacitated())
		return

	if(mounted)
		mounted.unload_ammo(usr)

/obj/item/clothing/gloves/ballistic/attack_self(mob/user as mob)
	unload_shells()

/obj/item/clothing/gloves/ballistic/double
	name = "ballistic gauntlets"
	icon_state = "dual-ballisticfist"
	item_state = "ballisticfist" //just reuse the single inhand
	fingerprint_chance = 0
	gender = PLURAL

/obj/item/clothing/gloves/ballistic/double/Initialize()
	. = ..()
	if(mounted)
		mounted.switch_firemodes()

/obj/item/clothing/gloves/tesla
	name = "tesla glove"
	desc = "A weaponized gauntlet capable of firing lightning bolts."
	desc_extended = "A tesla-based weapon created by the People's Republic of Adhomai as part of their Tesla Brigade program. Because of its long recharge time, the gauntlet is commonly \
	used as an ancillary weapon."
	icon_state = "tesla_glove_on"
	item_state = "tesla_glove_on"
	siemens_coefficient = 1
	fingerprint_chance = 50
	clipped = TRUE
	species_restricted = list("exclude",BODYTYPE_GOLEM,BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_VAURCA_BULWARK)
	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'
	gender = NEUTER
	var/charged = TRUE

/obj/item/clothing/gloves/tesla/Touch(atom/A, mob/living/user, proximity)
	if(!charged)
		to_chat(user, SPAN_WARNING("\The [src] is still recharging."))
		return

	if(user.a_intent == I_HURT)
		if(proximity)
			if(iscarbon(A))
				var/mob/living/carbon/L = A
				L.electrocute_act(20,src, 1, user.zone_sel.selecting)
				spark(src, 3, GLOB.alldirs)
				charged = FALSE
				update_icon()
				user.update_inv_gloves()
				addtimer(CALLBACK(src, PROC_REF(rearm)), 10 SECONDS)

		else
			var/turf/T = get_turf(user)
			user.visible_message(SPAN_DANGER("\The [user] crackles with energy!"))
			var/obj/item/projectile/beam/tesla/LE = new (T)
			LE.launch_projectile(A, user.zone_sel? user.zone_sel.selecting : null, user)
			spark(src, 3, GLOB.alldirs)
			playsound(user.loc, 'sound/magic/LightningShock.ogg', 75, 1)
			charged = FALSE
			update_icon()
			user.update_inv_gloves()
			addtimer(CALLBACK(src, PROC_REF(rearm)), 30 SECONDS)

/obj/item/clothing/gloves/tesla/proc/rearm()
	visible_message(SPAN_NOTICE("\The [src] surges back with energy!"))
	charged = TRUE
	update_icon()

/obj/item/clothing/gloves/tesla/update_icon()
	if(charged)
		icon_state = "tesla_glove_on"
		item_state = "tesla_glove_on"
	else
		icon_state = "tesla_glove"
		item_state = "tesla_glove"
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_gloves()

/obj/item/clothing/gloves/black/forensic
	name = "forensic gloves"
	desc = "Specially made gloves for investigative personnel. The luminescent threads woven into the material stand out under scrutiny."
	icon_state = "forensic"
	item_state = "forensicgloves"
	species_restricted = list("exclude",BODYTYPE_GOLEM,BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_VAURCA_BULWARK)
