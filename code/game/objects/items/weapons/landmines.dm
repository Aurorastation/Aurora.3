/obj/item/landmine
	name = "land mine"
	desc = "An anti-personnel explosive device used for area denial."
	icon = 'icons/obj/item/landmine/mine.dmi'
	icon_state = "landmine"
	throwforce = 0
	var/deployed = FALSE
	var/deactivated = FALSE // add wire to re-activate

/obj/item/landmine/update_icon()
	..()
	if(!deployed)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]_on"

/obj/item/landmine/verb/hide_under()
	set src in oview(1)
	set name = "Hide"
	set category = "Object"

	if(use_check_and_message(usr, USE_DISALLOW_SILICONS))
		return

	layer = ABOVE_TILE_LAYER
	to_chat(usr, "<span class='notice'>You hide \the [src].</span>")


/obj/item/landmine/attack_self(mob/user)
	..()
	if(deactivated)
		to_chat(user, SPAN_WARNING("\The [src] is deactivated and needs specific rewiring!"))
		return
	if(!deployed && !use_check(user, USE_DISALLOW_SILICONS))
		user.visible_message(
			"<span class='danger'>[user] starts to deploy \the [src].</span>",
			"<span class='danger'>You begin deploying \the [src]!</span>"
			)

		if (do_after(user, 6 SECONDS, do_flags = DO_REPAIR_CONSTRUCT))
			user.visible_message(
				"<span class='danger'>[user] has deployed \the [src].</span>",
				"<span class='danger'>You have deployed \the [src]!</span>"
				)

			deploy(user)

/**
 * Called when a landmine is deployed
 *
 * * deployer - The `/mob` that deployed the mine
 */
/obj/item/landmine/proc/deploy(mob/deployer)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	src.deployed = TRUE
	deployer.drop_from_inventory(src)
	update_icon()
	src.anchored = TRUE

	add_fingerprint(deployer)
	add_fibers(deployer)

/**
 * Called when a landmine was triggered, and is supposed to explode
 *
 * * triggerer - The `/mob/living` that triggered the mine
 */
/obj/item/landmine/proc/trigger(mob/living/triggerer)
	spark(src, 3, GLOB.alldirs)
	if(ishuman(triggerer))
		triggerer.Weaken(2)
	explosion(loc, 0, 2, 2, 3)
	qdel(src)

/obj/item/landmine/Crossed(AM as mob|obj, var/ignore_deployment = FALSE)
	if(deployed || ignore_deployment)
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(H.shoes?.item_flags & ITEM_FLAG_LIGHT_STEP)
				..()
				return
		if(isliving(AM))
			var/mob/living/L = AM
			if(L.mob_size >= 5)
				L.visible_message(
					"<span class='danger'>[L] steps on \the [src].</span>",
					"<span class='danger'>You step on \the [src]!</span>",
					"<span class='danger'>You hear a mechanical click!</span>"
					)
				trigger(L)
	..()

/obj/item/landmine/attack_hand(mob/user as mob)
	if(deployed && !use_check(user, USE_DISALLOW_SILICONS))
		attack_hand_trigger(user)
	else
		..()

/**
 * Called when the attack_hand is supposed to trigger the mine
 *
 * * user - The `/mob` that attacked the mine
 */
/obj/item/landmine/proc/attack_hand_trigger(mob/user)
	user.visible_message(
			SPAN_DANGER("[user] triggers \the [src]."),
			SPAN_DANGER("You trigger \the [src]!"),
			SPAN_DANGER("You hear a mechanical click!")
			)
	trigger(user)

/**
 * Activates the landmine, arming it
 *
 * NOT the same as deploying it, which is putting it on the ground
 *
 * * user - The `/mob` that activated the mine
 */
/obj/item/landmine/proc/activate(mob/user)
	SHOULD_NOT_SLEEP(TRUE)

	src.deactivated = FALSE

/**
 * Deactivates the landmine, disarming it
 *
 * NOT the same as removing it from the ground
 *
 * * user - The `/mob` that activated the mine
 */
/obj/item/landmine/proc/deactivate(mob/user)
	SHOULD_NOT_SLEEP(TRUE)

	src.deactivated = TRUE

/obj/item/landmine/attackby(obj/item/attacking_item, mob/user)
	..()
	if(deactivated && istype(attacking_item, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = attacking_item
		if(C.use(1))
			to_chat(user, SPAN_NOTICE("You start carefully start rewiring \the [src]."))
			if(do_after(user, 10 SECONDS, do_flags = DO_REPAIR_CONSTRUCT))
				to_chat(user, SPAN_NOTICE("You successfully rewire \the [src], priming it for use."))
				activate(user)
			return
		else
			to_chat(user, SPAN_WARNING("There's not enough cable to finish the task."))
			return
	else if(deployed && istype(attacking_item, /obj/item/wirecutters))
		var/obj/item/wirecutters/W = attacking_item
		user.visible_message(SPAN_WARNING("\The [user] starts snipping some wires in \the [src] with \the [W]..."), \
							SPAN_NOTICE("You start snipping some wires in \the [src] with \the [W]..."))
		if(attacking_item.use_tool(src, user, 150, volume = 50))
			if(prob(W.bomb_defusal_chance))
				to_chat(user, SPAN_NOTICE("You successfully defuse \the [src], though it's missing some essential wiring now."))
				deactivate(user)
				anchored = FALSE
				deployed = FALSE
				update_icon()
				return
		to_chat(user, FONT_LARGE(SPAN_DANGER("You slip, snipping the wrong wire!")))
		trigger(user)
	else if(attacking_item.force > 10 && deployed)
		trigger(user)

/obj/item/landmine/bullet_act()
	if(deployed)
		trigger()

/obj/item/landmine/ex_act(var/severity = 2.0)
	if(deployed)
		trigger()

/*
##################
	Subtypes
##################
*/

/**
 * # Fragmentation Landmine
 *
 * A landmine that throws sharpnels around
 */
/obj/item/landmine/frag
	var/num_fragments = 15
	var/fragment_damage = 10
	var/damage_step = 2
	var/explosion_size = 3
	var/spread_range = 7

/obj/item/landmine/frag/trigger(mob/living/triggerer)
	spark(src, 3, GLOB.alldirs)
	fragem(src,num_fragments,num_fragments,explosion_size,explosion_size+1,fragment_damage,damage_step,TRUE)
	qdel(src)

/**
 * # Radiation Landmine
 *
 * A landmine that irradiates the victim
 */
/obj/item/landmine/radiation
	icon_state = "radlandmine"

/obj/item/landmine/radiation/trigger(mob/living/L)
	spark(src, 3, GLOB.alldirs)
	if(L)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.apply_radiation(50)
	qdel(src)

/**
 * # Phoron Landmine
 *
 * A landmine that releases phoron
 */
/obj/item/landmine/phoron
	icon_state = "phoronlandmine"

/obj/item/landmine/phoron/trigger(mob/living/triggerer)
	spark(src, 3, GLOB.alldirs)
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas(GAS_PHORON, 30)

			target.hotspot_expose(1000, CELL_VOLUME)

	qdel(src)

/**
 * # Nitrous Oxide Landmine
 *
 * A landmine that releases nitrous oxide
 */
/obj/item/landmine/n2o
	icon_state = "phoronlandmine"

/obj/item/landmine/n2o/trigger(mob/living/L)
	spark(src, 3, GLOB.alldirs)
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas(GAS_N2O, 30)

	qdel(src)

/**
 * # EMP Landmine
 *
 * A landmine that emits an EMP pulse
 */
/obj/item/landmine/emp
	icon_state = "emplandmine"

/obj/item/landmine/emp/trigger(mob/living/triggerer)
	spark(src, 3, GLOB.alldirs)
	empulse(src.loc, 2, 4)
	qdel(src)


/**
 * # Phoron Landmine
 *
 * A landmine that only explodes when pressure is released
 */
/obj/item/landmine/standstill
	name = "Standstill Landmine"
	desc = "A landmine that only triggers if you release the pressure from the trigger."
	icon_state = "standstill"
	var/engaged_by = null

/obj/item/landmine/standstill/Destroy()
	STOP_PROCESSING(SSfast_process, src)
	engaged_by = null
	. = ..()

/obj/item/landmine/standstill/trigger(mob/living/triggerer)
	if(!engaged_by && !deactivated)
		to_chat(triggerer, SPAN_HIGHDANGER("Something clicks below your feet, a sense of dread permeates your skin, better not move..."))
		engaged_by = ref(triggerer)

		//Because mobs can bump and swap with one another, and we use forcemove that doesn't call Crossed/Uncrossed/Entered/Exited, we have to
		//keep looking if the victim is still on the mine, and otherwise explode the mine
		START_PROCESSING(SSfast_process, src)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tgui_alert), triggerer, "You feel your [pick("right", "left")] foot step down on a button with a click..., Uh..., Oh...", "Dread", list("Mom..."))

		playsound(src, sound('sound/weapons/empty/empty6.ogg'), 50)

	else
		late_trigger(locate(engaged_by))

/obj/item/landmine/standstill/Uncrossed(O)
	. = ..()

	//Oh no...
	if(engaged_by && O == locate(engaged_by))
		var/mob/living/victim = O
		to_chat(victim, SPAN_HIGHDANGER("The mine clicks below your feet."))
		addtimer(CALLBACK(src, PROC_REF(late_trigger), victim), 1 SECONDS)

/obj/item/landmine/standstill/process()
	if(!engaged_by || deactivated)
		STOP_PROCESSING(SSfast_process, src)
		return

	var/mob/living/victim = locate(engaged_by)
	var/turf/our_turf = get_turf(src)

	if(!(victim in our_turf))
		late_trigger(locate(engaged_by))

/**
 * Called when the actual explosion needs to be performed
 *
 * * victim - The `/mob` that triggers the explosion
 */
/obj/item/landmine/standstill/proc/late_trigger(mob/living/victim)
	if(!deactivated)
		for(var/mob/living/person_in_range in get_hearers_in_LOS(world.view, src))
			to_chat(person_in_range, SPAN_HIGHDANGER("[victim] does a sudden move, releasing the feet from the trigger..."))

		explosion(loc, 2, 5, 7, world.view)
		qdel(src)

/obj/item/landmine/standstill/deactivate(mob/user)
	src.engaged_by = null
	. = ..()

/obj/item/landmine/standstill/attackby(obj/item/attacking_item, mob/user)
	if(engaged_by && (user == locate(engaged_by)))
		to_chat(user, SPAN_ALERT("You are unable to reach the mine without moving your foot, and you feel like doing so would not end well..."))
	else
		..()

/obj/item/landmine/standstill/attack_hand_trigger(mob/user)
	if(!engaged_by)
		return

	late_trigger(locate(engaged_by))

/**
 * # Claymore mine
 *
 * A landmine that projects sharpnels in a cone of explosion, towards one direction
 */
/obj/item/landmine/claymore
	name = "Claymore Landmine"
	desc = "A landmine that projects sharpnels in a cone of explosion, towards one direction."
	desc_extended = "A household name, this mine finds extensive use amongst military forces due to its ability to provide area penetration denial and aid ambushes. \
	It is narrated that Gadpathur, its largest manufacturer in modern times, have built more of these mines than the census of the core planets of the Solarian Alliance."
	desc_info = "This device can be fitted with a signaler device for remotely actuated detonations, or can be activated with the press of a button directly above it."
	icon = 'icons/obj/item/landmine/claymore.dmi'
	icon_state = "m20"
	var/datum/wires/landmine/claymore/trigger_wire
	var/obj/item/device/assembly/signaler/signaler

/obj/item/landmine/claymore/Initialize(mapload, ...)
	. = ..()
	trigger_wire = new(src)

/obj/item/landmine/claymore/Destroy()
	trigger_wire.holder = null
	QDEL_NULL(trigger_wire)
	QDEL_NULL(signaler)
	. = ..()

/obj/item/landmine/claymore/update_icon()
	icon_state = (src.deployed) ? "[initial(icon_state)]_active" : initial(icon_state)

/obj/item/landmine/claymore/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/device/assembly/signaler))
		if(!isnull(signaler))
			to_chat(user, SPAN_NOTICE("There is already a signaler inserted in \the [src]."))
			return

		signaler = attacking_item

		user.drop_from_inventory(attacking_item, src)

		trigger_wire.attach_assembly(WIRE_EXPLODE, signaler)

	else
		. = ..()

/obj/item/landmine/claymore/Crossed(AM, ignore_deployment)
	return //Does nothing with mere crossing over

/obj/item/landmine/claymore/deploy(mob/deployer)
	. = ..()
	src.dir = deployer.dir

#define SHOTS_TO_LAUNCH 20
/obj/item/landmine/claymore/trigger(mob/living/triggerer)
	if(deactivated || !deployed)
		return

	var/list/turf/candidate_turfs = get_turfs_in_cone(get_turf(src), dir2angle(src.dir), world.view, 60)

	for(var/i = 0; i < SHOTS_TO_LAUNCH; i++)
		var/turf/to_hit = pick(candidate_turfs)

		var/obj/item/projectile/bullet/pellet/shotgun/pellet = new(get_turf(src))
		pellet.fire(Get_Angle(get_turf(src), to_hit))

	qdel(src)

#undef SHOTS_TO_LAUNCH
