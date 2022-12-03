//
// Sol Facility Objects
//

// Empty Inflatables Barrier Box
/obj/item/storage/bag/inflatable/empty
	name = "scuffed inflatable barriers box"
	starts_with = null

// Empty Solarian 9mm Pistol
/obj/item/gun/projectile/pistol/sol/empty
	magazine_type = null

// Empty Solarian 10mm SMG
/obj/item/gun/projectile/automatic/c20r/sol/empty
	magazine_type = null

// Sol Facility Staff Personal Closet
/obj/structure/closet/secure_closet/personal/sol_facility
	name = "personnel locker"
	desc = "It's a secure locker for personnel."
	anchored = TRUE
	canbemoved = TRUE
	req_access = null

/obj/structure/closet/secure_closet/personal/sol_facility/fill()
	// Sol Uniform (50%)
	if(prob(50))
		new /obj/item/clothing/under/rank/sol(src)
		new /obj/item/clothing/shoes/workboots/grey(src)
	// Service Pistol (5%)
	if(prob(5))
		new /obj/item/gun/projectile/pistol/sol/empty(src)
	// 100 Credits (10%)
	if(prob(10))
		new /obj/item/spacecash/c100(src)
	// 20 Credits
	new /obj/item/spacecash/c20(src)
	// Random Soda or Water
	if(prob(20))
		new /obj/item/reagent_containers/food/drinks/cans/cola(src)
	else
		new /obj/item/reagent_containers/food/drinks/waterbottle(src)
	// Crayon MRE (5%)
	if(prob(5))
		new /obj/item/storage/box/fancy/mre/menu11(src)


/obj/structure/closet/secure_closet/personal/sol_facility/amanda
	name = "personnel locker (Amanda S. (Engineer))"
	registered_name = "Amanda S. (Engineer)"

/obj/structure/closet/secure_closet/personal/sol_facility/ava
	name = "personnel locker (Ava N. (Custodian))"
	registered_name = "Ava N. (Custodian)"

/obj/structure/closet/secure_closet/personal/sol_facility/dima
	name = "personnel locker (Dima A. (Security))"
	registered_name = "Dima A. (Security)"

/obj/structure/closet/secure_closet/personal/sol_facility/ayako
	name = "personnel locker (Ayako H. (Medical))"
	registered_name = "Ayako H. (Medical)"

// Security Storage Locker
/obj/structure/closet/secure_closet/guncabinet/sol_facility
	name = "security storage locker"
	anchored = TRUE
	canbemoved = TRUE
	req_access = null

/obj/structure/closet/secure_closet/guncabinet/sol_facility/fill()
	// Empty Stunbaton (20%)
	if(prob(20))
		new /obj/item/melee/baton(src)
	// Empty Service Pistol (20%)
	if(prob(20))
		new /obj/item/gun/projectile/pistol/sol/empty(src)
	// Empty SMG (10%)
	if(prob(10))
		new /obj/item/gun/projectile/automatic/c20r/sol/empty(src)

// Security Ammunition Storage Locker
/obj/structure/closet/secure_closet/guncabinet/sol_facility/ammo
	name = "security ammunition storage locker"
	anchored = TRUE
	canbemoved = TRUE
	req_access = null

/obj/structure/closet/secure_closet/guncabinet/sol_facility/ammo/fill()
	// Service Pistol Mag (20%)
	if(prob(20))
		new /obj/item/ammo_magazine/mc9mm(src)
	// SMG Mag (10%)
	if(prob(10))
		new /obj/item/ammo_magazine/a10mm(src)

// Big Sol Floor Decal
/obj/effect/floor_decal/sol_full
	name = "full Sol Alliance logo"
	icon = 'maps/away/away_site/sol_facility/icons/sol_decal_preview.dmi'
	icon_state = "sol_decal_preview"

	var/list/decals = list(
		"0,0", "1,0", "2,0", "3,0", "4,0",
		"0,1", "1,1", "2,1", "3,1", "4,1",
		"0,2", "1,2", "2,2", "3,2", "4,2",
		"0,3", "1,3", "2,3", "3,3", "4,3",
		"0,4", "1,4", "2,4", "3,4", "4,4"
	)

/obj/effect/floor_decal/sol_full/Initialize()
	..()
	for(var/coordinate in decals)
		var/list/split_coordinate = splittext(coordinate, ",")
		var/turf/decal_turf = loc
		for(var/i = 1 to text2num(split_coordinate[1]))
			decal_turf = get_step(decal_turf, EAST)
		for(var/i = 1 to text2num(split_coordinate[2]))
			decal_turf = get_step(decal_turf, NORTH)
		new /obj/effect/floor_decal/sol(decal_turf, null, null, FALSE, coordinate)
	return INITIALIZE_HINT_QDEL

/obj/effect/floor_decal/sol
	name = "\improper Sol Alliance logo"
	icon = 'maps/away/away_site/sol_facility/icons/sol_decals.dmi'
	icon_state = "0,0"

// Sol Facility Turret
/obj/machinery/porta_turret/sol_facility
	name = "turret"
	req_access = (access_sol_facility)
	immobile = TRUE
	no_salvage = TRUE
	sprite_set = "blaster"
	installation = /obj/item/gun/energy/disruptorpistol
	projectile = /obj/item/projectile/energy/disruptorstun
	eprojectile = /obj/item/projectile/energy/blaster/disruptor
	shot_sound = 'sound/weapons/gunshot/bolter.ogg'
	eshot_sound	= 'sound/weapons/gunshot/bolter.ogg'
	maxhealth = 200
	health = 200
	light_range = 0
	light_power = 0
	check_arrest = FALSE
	check_records = FALSE
	check_weapons = FALSE
	check_access = TRUE
	check_wildlife = FALSE
	check_synth = FALSE
	ailock = TRUE

/obj/machinery/turretid/stun/sol_facility
	req_access = null

/turf/simulated/abyss/is_open() // Should be implemented properly.
    return TRUE

/turf/unsimulated/floor/asteroid/basalt/sol_facility
	name = "blackened cracked full plasteel floor tile"
	desc = "A blackened, cracked, sooty full plasteel floor tile. Or rather, whats left of one."

/turf/simulated/lava/sol_facility
	name = "molten metal slag"
	desc = "A glowing, steaming heap of molten metal slag."