/turf/simulated/wall/r_wall
	icon_state = "rgeneric"
	desc_info = "You can deconstruct this by with the following steps:<br>\
	Cut the outer grill with wirecutters, then unscrew them.<br>\
	Slice the cover with a welder, then pry it off with a crowbar.<br>\
	Use a wrench to loosen the anchor bolts, then cut the supports with a welder.<br>\
	Pry off the sheath with a crowbar to expose the girder. Examine it to see how to deconstruct it."

/turf/simulated/wall/r_wall/Initialize(mapload)
	. = ..(mapload, "plasteel","plasteel") //3strong

/turf/simulated/wall/cult
	icon_state = "cult"
	desc = "Hideous images dance beneath the surface."
	appearance_flags = NO_CLIENT_COLOR

/turf/simulated/wall/cult/Initialize(mapload)
	. = ..(mapload, MATERIAL_CULT)
	desc = "Hideous images dance beneath the surface."
	canSmoothWith = list(/turf/simulated/wall/cult, /turf/simulated/wall/cult_reinforced)

/turf/simulated/wall/cult_reinforced/Initialize(mapload)
	. = ..(mapload, MATERIAL_CULT, MATERIAL_CULT_REINFORCED)
	desc = "Hideous images dance beneath the surface."
	canSmoothWith = list(/turf/simulated/wall/cult, /turf/simulated/wall/cult_reinforced)

/turf/unsimulated/wall/cult
	name = "cult wall"
	desc = "Hideous images dance beneath the surface."
	icon = 'icons/turf/smooth/cult_wall.dmi'
	canSmoothWith = null
	smooth = SMOOTH_TRUE
	smoothing_hints = SMOOTHHINT_TARGETS_NOT_UNIQUE | SMOOTHHINT_ONLY_MATCH_TURF
	icon_state = "cult"
	appearance_flags = NO_CLIENT_COLOR

/turf/simulated/wall/vaurca/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_VAURCA)
	canSmoothWith = list(src.type)

/turf/simulated/wall/iron/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_IRON)
	canSmoothWith = list(src.type)

/turf/simulated/wall/uranium/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_URANIUM)
	canSmoothWith = list(src.type)

/turf/simulated/wall/diamond/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_DIAMOND)
	canSmoothWith = list(src.type)

/turf/simulated/wall/gold/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_GOLD)
	canSmoothWith = list(src.type)

/turf/simulated/wall/silver/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_SILVER)
	canSmoothWith = list(src.type)

/turf/simulated/wall/phoron/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_PHORON)
	canSmoothWith = list(src.type)

/turf/simulated/wall/sandstone/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_SANDSTONE)
	canSmoothWith = list(src.type)

/turf/simulated/wall/ironphoron/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_IRON, MATERIAL_PHORON)
	canSmoothWith = list(src.type)

/turf/simulated/wall/golddiamond/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_GOLD, MATERIAL_DIAMOND)
	canSmoothWith = list(src.type)

/turf/simulated/wall/silvergold/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_SILVER, MATERIAL_GOLD)
	canSmoothWith = list(src.type)

/turf/simulated/wall/sandstonediamond/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_SANDSTONE, MATERIAL_DIAMOND)
	canSmoothWith = list(src.type)

/turf/simulated/wall/titanium/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_TITANIUM)
	canSmoothWith = list(src.type)

/turf/simulated/wall/titanium_reinforced/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_TITANIUM, MATERIAL_TITANIUM)
	canSmoothWith = list(src.type)

/turf/simulated/wall/wood/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_WOOD)
	canSmoothWith = list(src.type)

/turf/simulated/wall/birchwood/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_BIRCH)
	canSmoothWith = list(src.type)

/turf/simulated/wall/mahoganywood/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_MAHOGANY)
	canSmoothWith = list(src.type)

/turf/simulated/wall/maplewood/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_MAPLE)
	canSmoothWith = list(src.type)

/turf/simulated/wall/bamboowood/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_BAMBOO)
	canSmoothWith = list(src.type)

/turf/simulated/wall/ebonywood/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_EBONY)
	canSmoothWith = list(src.type)

/turf/simulated/wall/walnutwood/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_WALNUT)
	canSmoothWith = list(src.type)

/turf/simulated/wall/yewwood/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_YEW)
	canSmoothWith = list(src.type)

/turf/simulated/wall/rusty/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_RUST)
	desc = "Rust stains this ancient wall."
	canSmoothWith = list(src.type)

/turf/simulated/wall/cloth/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_CLOTH)
	canSmoothWith = list(src.type)

/turf/simulated/wall/concrete/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_CONCRETE)
	canSmoothWith = list(src.type)



#define APS_WALL_ALWAYS_DEFLECTS -1
#define APS_SOUND_EFFECT_EXTRA_RANGE 6
/**
 * Resistant walls
 *
 * The créme de la créme of military engineering, resistant walls are the fear of every engineer with an emitter,
 *  or a force not equipped enough to face their robustness
 */

// If the wall should always deflect this type of shots
/turf/simulated/wall/reinforced_aps
	name = "APS Wall" // APS Stands for Active Protection System
	desc = "A wall with an Active Protection System."

	/**
	 * APS Config variables
	 */

	/// How long the defensive smoke screen lasts
	var/smoke_screen_duration = 20 SECONDS
	/// How many emitter shots the APS is able to handle before being overwhelmed
	var/emitter_deflections_amount = APS_WALL_ALWAYS_DEFLECTS
	/// How many normal shots the APS is able to handle before being overwhelmed
	var/shots_deflection_amount = 10
	/// How much thermite cycles can it withstand (a cycle is a >5u spray + ignition)
	var/thermite_resistance_amount = 5
	/// Can this be deconstructed via standard means? (Blocks the use of the wirecutter to start the process)
	var/allow_standard_deconstruction = TRUE
	/// Can this be attacked in CQC (eg. with a fireaxe, an esword)?
	var/allow_cqc_attack = TRUE


	/**
	 * APS Vars, used internally
	 */
	var/emitter_projectile_hits = 0
	var/shots_projectile_hits = 0
	var/thermite_hits = 0
	var/obj/effect/effect/smoke/smoke_screen

/**
 * Smoke screen procs
 */

/// Creates a smoke screen with location the wall
/turf/simulated/wall/reinforced_aps/proc/make_smokescreen()
	if(!smoke_screen)
		smoke_screen = new(src, smoke_screen_duration)
		addtimer(CALLBACK(src, PROC_REF(clear_smokescreen)), (smoke_screen_duration-(1 SECONDS)))

/// Removes the smoke screen reference, to prevent harddels
/turf/simulated/wall/reinforced_aps/proc/clear_smokescreen()
	smoke_screen = null


/// Projectile deflection
/turf/simulated/wall/reinforced_aps/proc/deflect_projectile(var/obj/item/projectile/Proj)
	// Reflect the projectile, stolen from the personal shields
	var/new_x = Proj.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
	var/new_y = Proj.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
	var/turf/curloc = get_turf(src)
	Proj.original = locate(new_x, new_y, Proj.z)
	Proj.starting = curloc
	//Proj.firer = src
	Proj.yo = new_y - curloc.y
	Proj.xo = new_x - curloc.x
	var/new_angle_s = Proj.Angle + rand(120,240)
	while(new_angle_s > 180) // Translate to regular projectile degrees
		new_angle_s -= 360
	Proj.set_angle(new_angle_s)
	Proj.Angle = new_angle_s
	return FALSE // Should be PROJECTILE_CONTINUE but for some reason it just goes through without getting reflected???


// I envision to make it based on being overwhelmed by the fire volume, but it would require a token/leaky bucket to do so;
// consider this a TODO, unless you see this 6 years from now, then it's just an idea of possible development.
/// Handling called by being hit by a projectile
/turf/simulated/wall/reinforced_aps/bullet_act(var/obj/item/projectile/Proj)

	// Emitter projectiles handling
	if(istype(Proj, /obj/item/projectile/beam/emitter) && ((emitter_projectile_hits <= emitter_deflections_amount) || (emitter_deflections_amount == APS_WALL_ALWAYS_DEFLECTS )))
		emitter_projectile_hits += 1

		make_smokescreen()
		playsound(src, 'sound/effects/EMPulse.ogg', 75, 1, APS_SOUND_EFFECT_EXTRA_RANGE)
		return deflect_projectile(Proj)

	// Other projectiles handling
	else if(istype(Proj, /obj/item/projectile) && ((shots_projectile_hits <= shots_deflection_amount) || (shots_deflection_amount == APS_WALL_ALWAYS_DEFLECTS )))
		shots_projectile_hits += 1

		make_smokescreen()
		playsound(src, 'sound/effects/zzzt.ogg', 75, 1, APS_SOUND_EFFECT_EXTRA_RANGE)
		return deflect_projectile(Proj)

	else
		. = ..()

/// Triggered by attack by items
/turf/simulated/wall/reinforced_aps/attackby(obj/item/W, mob/user)

	// Blocks standard deconstruction
	if(W.iswirecutter() && !allow_standard_deconstruction)
		to_chat(user, SPAN_NOTICE("The additional armor prevents you from reaching the grille."))
		return

	// Blocks CQC attacks
	else if(!allow_cqc_attack && user.a_intent == I_HURT)
		to_chat(user, SPAN_NOTICE("The APS bounces back [W]."))
		return

	else
		. = ..()

/// Proc used when the wall is sprayed with thermite and then attacked by a lighter to set it on fire
/turf/simulated/wall/reinforced_aps/thermitemelt(mob/user)
	if((thermite_hits <= thermite_resistance_amount) || (thermite_resistance_amount == APS_WALL_ALWAYS_DEFLECTS ))
		thermite_hits += 1

		var/obj/effect/overlay/thermite/O = new /obj/effect/overlay/thermite(src)
		QDEL_IN(O, 100)

		playsound(src, 'sound/effects/extinguish.ogg', 75, 1, APS_SOUND_EFFECT_EXTRA_RANGE)

		thermite = 0

		return
	. = ..()



/**
 * Subtypes
 */

/turf/simulated/wall/reinforced_aps/titanium/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_TITANIUM, MATERIAL_TITANIUM)
	canSmoothWith = list(src.type)

#undef APS_WALL_ALWAYS_DEFLECTS
#undef APS_SOUND_EFFECT_EXTRA_RANGE
