
//This list is purly for giggles at the moment.
//But makes the test enviroment look nicer.
var/list/planet_tile_icons = list(
	"ironsand1" = 20,
	"ironsand2" = 5,
	"ironsand3" = 5,
	"ironsand4" = 5,
	"ironsand5" = 5,
	"ironsand6" = 5,
	"ironsand7" = 5,
	"ironsand8" = 5,
	"ironsand9" = 5,
	"ironsand10" = 5,
	"ironsand11" = 5,
	"ironsand12" = 5,
	"ironsand13" = 5,
	"ironsand14" = 5,
	"ironsand15" = 5
	)

/turf/planet
	icon = 'icons/turf/floors.dmi'
	name = "\proper planet surface"
	icon_state = "ironsand1"

	temperature = Tm100C
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
//	heat_capacity = 700000 No. Why not? :(

	oxygen = 0.344
	carbon_dioxide = 54.78
	nitrogen = 1.67
	phoron = 0.001

	var/storm_overlay = ""

	New()
		//SetLuminosity(1)
		var/randomIcon = pickweight(planet_tile_icons)
		icon_state = randomIcon

/turf/planet/attack_hand(mob/user as mob)
	if ((user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored || !isturf(user.pulling.loc))
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/planet/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		user << "\blue Constructing support lattice ..."
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		ReplaceWithLattice()
		R.use(1)
		return

	if (istype(C, /obj/item/stack/tile/steel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/steel/S = C
			del(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.build(src)
			S.use(1)
			return
		else
			user << "\red The plating is going to need some support."
	return
