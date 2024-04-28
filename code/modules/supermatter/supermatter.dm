
#define NITROGEN_RETARDATION_FACTOR 0.15	//Higher == N2 slows reaction more
#define THERMAL_RELEASE_MODIFIER 10000		//Higher == more heat released during reaction
#define PHORON_RELEASE_MODIFIER 1500		//Higher == less phoron released by reaction
#define OXYGEN_RELEASE_MODIFIER 15000		//Higher == less oxygen released at high temperature/power
#define REACTION_POWER_MODIFIER 1.1			//Higher == more overall power

/*
	How to tweak the SM

	POWER_FACTOR		directly controls how much power the SM puts out at a given level of excitation (power var). Making this lower means you have to work the SM harder to get the same amount of power.
	CRITICAL_TEMPERATURE	The temperature at which the SM starts taking damage.

	CHARGING_FACTOR		Controls how much emitter shots excite the SM.
	DAMAGE_RATE_LIMIT	Controls the maximum rate at which the SM will take damage due to high temperatures.
*/

//Controls how much power is produced by each collector in range - this is the main parameter for tweaking SM balance, as it basically controls how the power variable relates to the rest of the game.
#define POWER_FACTOR 1.0
#define DECAY_FACTOR 700			//Affects how fast the supermatter power decays
#define CRITICAL_TEMPERATURE 5000	//K
#define CHARGING_FACTOR 0.05
#define DAMAGE_RATE_LIMIT 2			//damage rate cap at power = 300, scales linearly with power
#define SPACED_DAMAGE_FACTOR 0.5	//multiplier for damage taken in a vacuum, but on a tile. Used to prevent/configure near-instant explosions when vented

//These would be what you would get at point blank, decreases with distance
#define DETONATION_RADS 200
#define DETONATION_HALLUCINATION 600


#define WARNING_DELAY 20			//seconds between warnings.

///to prevent accent sounds from layering
#define SUPERMATTER_ACCENT_SOUND_MIN_COOLDOWN 2 SECONDS

#define LIGHT_POWER_CALC (max(power / 50, 1))

/obj/machinery/power/supermatter
	name = "supermatter crystal"
	desc = "A strangely translucent and iridescent crystal. <span class='warning'>You get headaches just from looking at it.</span>"
	desc_info = "When energized by a laser (or something hitting it), it emits radiation and heat.  If the heat reaches above 7000 kelvin, it will send an alert and start taking damage. \
	After integrity falls to zero percent, it will delaminate, causing a massive explosion, station-wide radiation spikes, and hallucinations. \
	Supermatter reacts badly to oxygen in the atmosphere.  It'll also heat up really quick if it is in vacuum.<br>\
	<br>\
	Supermatter cores are extremely dangerous to be close to, and requires protection to handle properly.  The protection you will need is:<br>\
	Optical meson scanners on your eyes, to prevent hallucinations when looking at the supermatter.<br>\
	Radiation helmet and suit, as the supermatter is radioactive.<br>\
	<br>\
	Touching the supermatter will result in *instant death*, with no corpse left behind!  You can drag the supermatter, but anything else will kill you."
	desc_antag = "Always ahelp before sabotaging the supermatter, as it can potentially ruin the round. Exposing the supermatter to oxygen or vaccuum will cause it to start rapidly heating up.  \
	Sabotaging the supermatter and making it explode will cause a period of lag as the explosion is processed by the server, as well as irradiating the entire station and causing hallucinations to happen.  \
	Wearing radiation equipment will protect you from most of the delamination effects sans explosion."
	icon = 'icons/obj/supermatter.dmi'
	icon_state = "supermatter"
	density = TRUE
	anchored = FALSE
	light_range = 4
	light_power = 1
	layer = ABOVE_HUMAN_LAYER

	var/gasefficency = 0.25

	var/base_icon_state = "supermatter"

	var/last_power
	var/damage = 0
	var/damage_archived = 0
	var/safe_alert = "Crystaline hyperstructure returning to safe operating levels."
	var/safe_warned = 0
	var/public_alert = 0 //Stick to Engineering frequency except for big warnings when integrity bad
	var/warning_point = 100
	var/warning_alert = "Danger! Crystal hyperstructure instability!"
	var/emergency_point = 700
	var/emergency_alert = "CRYSTAL DELAMINATION IMMINENT."
	var/explosion_point = 1000

	light_color = "#8A8A00"
	uv_intensity = 255
	var/warning_color = "#B8B800"
	var/emergency_color = "#D9D900"

	var/filter_offset = 0

	var/grav_pulling = FALSE
	var/pull_radius = 14
	// Time in ticks between delamination ('exploding') and exploding (as in the actual boom)
	var/pull_time = 100
	var/explosion_power = 8

	var/emergency_issued = 0

	// Time in 1/10th of seconds since the last sent warning
	var/lastwarning = 0

	// This stops spawning redundant explosions. Also incidentally makes supermatter unexplodable if set to 1.
	var/exploded = FALSE

	var/power = 0
	var/oxygen = 0

	//Temporary values so that we can optimize this
	//How much the bullets damage should be multiplied by when it is added to the internal variables
	var/config_bullet_energy = 2
	//How much of the power is left after processing is finished?
//        var/config_power_reduction_per_tick = 0.5
	//How much hallucination should it produce per unit of power?
	var/config_hallucination_power = 0.1

	var/obj/item/device/radio/radio

	var/debug = 0
	var/last_message_time = -100 //for message

	var/datum/looping_sound/supermatter/soundloop

	/// cooldown tracker for accent sounds,
	var/last_accent_sound = 0

/obj/machinery/power/supermatter/Initialize()
	. = ..()
	radio = new /obj/item/device/radio{channels=list("Engineering")}(src)
	soundloop = new(src, TRUE)

/obj/machinery/power/supermatter/Destroy()
	QDEL_NULL(radio)
	QDEL_NULL(soundloop)
	. = ..()

/obj/machinery/power/supermatter/proc/explode()
	message_admins("Supermatter exploded at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
	log_game("Supermatter exploded at ([x],[y],[z])")
	anchored = TRUE
	grav_pulling = TRUE
	exploded = TRUE
	for(var/mob/living/mob in GLOB.living_mob_list)
		var/turf/T = get_turf(mob)
		if(T && (loc.z == T.z))
			if(istype(mob, /mob/living/carbon/human))
				//Hilariously enough, running into a closet should make you get hit the hardest.
				var/mob/living/carbon/human/H = mob
				H.hallucination += max(50, min(300, DETONATION_HALLUCINATION * sqrt(1 / (get_dist(mob, src) + 1)) ) )
	SSradiation.z_radiate(locate(1, 1, z), DETONATION_RADS, TRUE)
	spawn(pull_time)
		explosion(get_turf(src), explosion_power, explosion_power * 2, explosion_power * 3, explosion_power * 4, 1)
		qdel(src)
		return

//Changes color and luminosity of the light to these values if they were not already set
/obj/machinery/power/supermatter/proc/shift_light(var/lum, var/clr)
	if(lum != light_range || abs(power - last_power) > 10 || clr != light_color)
		set_light(lum, LIGHT_POWER_CALC, clr)
		last_power = power


/obj/machinery/power/supermatter/proc/get_integrity()
	var/integrity = damage / explosion_point
	integrity = round(100 - integrity * 100)
	integrity = integrity < 0 ? 0 : integrity
	return integrity


/obj/machinery/power/supermatter/proc/announce_warning()
	var/integrity = get_integrity()
	var/alert_msg = " Integrity at [integrity]%"

	if(damage > emergency_point)
		alert_msg = emergency_alert + alert_msg
		lastwarning = world.timeofday - WARNING_DELAY * 4
	else if(damage >= damage_archived) // The damage is still going up
		safe_warned = 0
		alert_msg = warning_alert + alert_msg
		lastwarning = world.timeofday
	else if(!safe_warned)
		safe_warned = 1 // We are safe, warn only once
		alert_msg = safe_alert
		lastwarning = world.timeofday
	else
		alert_msg = null
	if(alert_msg)
		radio.autosay(alert_msg, "Supermatter Monitor", "Engineering")
		//Public alerts
		if((damage > emergency_point) && !public_alert)
			radio.autosay("WARNING: SUPERMATTER CRYSTAL DELAMINATION IMMINENT!", "Supermatter Monitor")
			public_alert = 1
			for(var/mob/M in GLOB.player_list)
				var/turf/T = get_turf(M)
				if(T && !istype(M, /mob/abstract/new_player) && !isdeaf(M))
					sound_to(M, 'sound/effects/nuclearsiren.ogg')
		else if(safe_warned && public_alert)
			radio.autosay(alert_msg, "Supermatter Monitor")
			public_alert = 0


/obj/machinery/power/supermatter/get_transit_zlevel()
	//don't send it back to the station -- most of the time
	if(prob(99))
		var/list/candidates = SSatlas.current_map.accessible_z_levels.Copy()
		for(var/zlevel in SSatlas.current_map.station_levels)
			candidates.Remove("[zlevel]")
		candidates.Remove("[src.z]")

		if(candidates.len)
			return text2num(pickweight(candidates))

	return ..()

/obj/machinery/power/supermatter/process()
	var/turf/L = loc

	if(isnull(L))		// We have a null turf...something is wrong, stop processing this entity.
		return PROCESS_KILL

	if(!istype(L)) 	//We are in a crate or somewhere that isn't turf, if we return to turf resume processing but for now.
		return  //Yeah just stop.

	if(damage > explosion_point)
		if(!exploded)
			if(!istype(L, /turf/space))
				announce_warning()
			explode()
	else if(damage > warning_point) // while the core is still damaged and it's still worth noting its status
		shift_light(5, warning_color)
		if(damage > emergency_point)
			shift_light(7, emergency_color)
		if(!istype(L, /turf/space) && (world.timeofday - lastwarning) >= WARNING_DELAY * 10)
			announce_warning()
	else
		shift_light(4, initial(light_color))
	if(grav_pulling)
		supermatter_pull()

	if(power)
		soundloop.volume = Clamp((50 + (power / 50)), 50, 100)
	if(damage >= 300)
		soundloop.mid_sounds = list('sound/machines/sm/loops/delamming.ogg' = 1)
	else
		soundloop.mid_sounds = list('sound/machines/sm/loops/calm.ogg' = 1)

	if(last_accent_sound < world.time && prob(20))
		var/aggression = min(((damage / 800) * (power / 2500)), 1.0) * 100
		if(damage >= 300)
			playsound(src, /singleton/sound_category/supermatter_delam, max(50, aggression), FALSE, 10)
		else
			playsound(src, /singleton/sound_category/supermatter_calm, max(50, aggression), FALSE, 10)
		var/next_sound = round((100 - aggression) * 5)
		last_accent_sound = world.time + max(SUPERMATTER_ACCENT_SOUND_MIN_COOLDOWN, next_sound)


	//Ok, get the air from the turf
	var/datum/gas_mixture/env = null

	var/datum/gas_mixture/removed = null

	//ensure that damage doesn't increase too quickly due to super high temperatures resulting from no coolant, for example. We dont want the SM exploding before anyone can react.
	//We want the cap to scale linearly with power (and explosion_point). Let's aim for a cap of 5 at power = 300 (based on testing, equals roughly 5% per SM alert announcement).
	var/damage_inc_limit = (power/300)*(explosion_point/1000)*DAMAGE_RATE_LIMIT

	if(!istype(L, /turf/space))
		env = L.return_air()
		removed = env.remove(gasefficency * env.total_moles)	//Remove gas from surrounding area

	if(!env || !removed || !removed.total_moles)
		damage += max((SPACED_DAMAGE_FACTOR*(power - 15*POWER_FACTOR))/10, 0)
	else if (grav_pulling) //If supermatter is detonating, remove all air from the zone
		env.remove(env.total_moles)
	else
		damage_archived = damage

		damage = max( damage + min( ( (removed.temperature - CRITICAL_TEMPERATURE) / 150 ), damage_inc_limit ) , 0 )
		//Ok, 100% oxygen atmosphere = best reaction
		//Maxes out at 100% oxygen pressure
		oxygen = max(min((removed.gas[GAS_OXYGEN] - (removed.gas[GAS_NITROGEN] * NITROGEN_RETARDATION_FACTOR)) / removed.total_moles, 1), 0)

		//calculate power gain for oxygen reaction
		var/temp_factor
		var/equilibrium_power
		if (oxygen > 0.8)
			//If chain reacting at oxygen == 1, we want the power at 800 K to stabilize at a power level of 400
			equilibrium_power = 400
			icon_state = "[base_icon_state]_glow"
		else
			//If chain reacting at oxygen == 1, we want the power at 800 K to stabilize at a power level of 250
			equilibrium_power = 250
			icon_state = base_icon_state

		temp_factor = ( (equilibrium_power/DECAY_FACTOR)**3 )/800
		power = max( (removed.temperature * temp_factor) * oxygen + power, 0)

		//We've generated power, now let's transfer it to the collectors for storing/usage
		//transfer_energy()

		var/device_energy = power * REACTION_POWER_MODIFIER

		//Release reaction gasses
		var/heat_capacity = removed.heat_capacity()
		removed.adjust_multi(GAS_PHORON, max(device_energy / PHORON_RELEASE_MODIFIER, 0), \
								GAS_OXYGEN, max((device_energy + removed.temperature - T0C) / OXYGEN_RELEASE_MODIFIER, 0))

		var/thermal_power = THERMAL_RELEASE_MODIFIER * device_energy
		if (debug)
			var/heat_capacity_new = removed.heat_capacity()
			visible_message("[src]: Releasing [round(thermal_power)] W.")
			visible_message("[src]: Releasing additional [round((heat_capacity_new - heat_capacity)*removed.temperature)] W with exhaust gasses.")

		removed.add_thermal_energy(thermal_power)
		removed.temperature = between(0, removed.temperature, 10000)

		env.merge(removed)

	for(var/mob/living/carbon/human/l in view(src, min(7, round(sqrt(power/6))))) // If they can see it without mesons on.  Bad on them.
		if(!istype(l.glasses, /obj/item/clothing/glasses/safety) && !l.is_diona() && !l.isSynthetic())
			l.hallucination = max(0, min(200, l.hallucination + power * config_hallucination_power * sqrt( 1 / max(1,get_dist(l, src)) ) ) )

	//adjusted range so that a power of 170 (pretty high) results in 9 tiles, roughly the distance from the core to the engine monitoring room.
	//note that the rads given at the maximum range is a constant 0.2 - as power increases the maximum range merely increases.
	//adjusted to pseudo take into account obstacles in the way (1/3rd of the range is dropped if no direct visibility between core and target is)
	var/rad_range = round(sqrt(power / 2))
	for(var/mob/living/l in range(src, rad_range))
		var/radius = max(get_dist(l, src), 1)
		var/rads = (power / 10) * ( 1 / (radius**2) )
		if (!(l in oview(rad_range, src)) && !(l in range(src, round(rad_range * 2/3))))
			continue
		l.apply_damage(rads, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
		if(l.is_diona())
			l.adjustToxLoss(-rads)
			if(last_message_time + 800 < world.time) // Not to spam message
				to_chat(l, "<span class='notice'>You can feel an extreme level of energy which flows through your body and makes you regenerate very fast.</span>")
	last_message_time = world.time

	power -= (power/DECAY_FACTOR)**3		//energy losses due to radiation

	return 1


/obj/machinery/power/supermatter/bullet_act(var/obj/item/projectile/Proj)
	var/turf/L = loc
	if(!istype(L))		// We don't run process() when we are in space
		return 0	// This stops people from being able to really power up the supermatter
				// Then bring it inside to explode instantly upon landing on a valid turf.


	var/proj_damage = Proj.get_structure_damage()
	if(istype(Proj, /obj/item/projectile/beam))
		power += proj_damage * config_bullet_energy	* CHARGING_FACTOR / POWER_FACTOR
	else
		damage += proj_damage * config_bullet_energy
	return 0

/obj/machinery/power/supermatter/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return attack_hand(user)
	else
		ui_interact(user)
	return

/obj/machinery/power/supermatter/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	ui_interact(user)

/obj/machinery/power/supermatter/attack_hand(mob/user as mob)
	user.visible_message("<span class=\"warning\">\The [user] reaches out and touches \the [src], inducing a resonance... [user.get_pronoun("he")] body starts to glow and bursts into flames before flashing into ash.</span>",\
		"<span class=\"danger\">You reach out and touch \the [src]. Everything starts burning and all you can hear is ringing. Your last thought is \"That was not a wise decision.\"</span>",\
		"<span class=\"warning\">You hear an uneartly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.</span>")

	Consume(user)

// Only accessed by AIs or robots.
/obj/machinery/power/supermatter/ui_data(mob/user)
	var/list/data = list()
	data["integrity_percentage"] = round(get_integrity())
	var/datum/gas_mixture/env = null
	if(loc && !istype(loc, /turf/space))
		env = src.loc.return_air()
	data["ambient_temp"] = round(env?.temperature)
	data["ambient_pressure"] = round(env?.return_pressure())
	data["detonating"] = grav_pulling
	return data

/obj/machinery/power/supermatter/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Supermatter", "Supermatter Crystal", 500, 300)
		ui.open()

/obj/machinery/power/supermatter/attackby(obj/item/attacking_item, mob/user)
	var/mob/living/living_user = user
	if(!istype(living_user))
		return

	living_user.visible_message("<span class=\"warning\">\The [living_user] touches \a [attacking_item] to \the [src] as a silence fills the room...</span>",\
		"<span class=\"danger\">You touch \the [attacking_item] to \the [src] when everything suddenly goes silent.\"</span>\n<span class=\"notice\">\The [attacking_item] flashes into dust as you flinch away from \the [src].</span>",\
		"<span class=\"warning\">Everything suddenly goes silent.</span>")

	living_user.drop_from_inventory(attacking_item)
	Consume(attacking_item)

	living_user.apply_damage(150, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)

/obj/machinery/power/supermatter/CollidedWith(atom/AM as mob|obj)
	if(!AM.simulated)
		return
	if(istype(AM, /obj/effect))
		return
	if(isprojectile(AM))
		return
	if(istype(AM, /mob/living))
		AM.visible_message("<span class=\"warning\">\The [AM] slams into \the [src] inducing a resonance... [AM.get_pronoun("his")] body starts to glow and catch flame before flashing into ash.</span>",\
		"<span class=\"danger\">You slam into \the [src] as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\"</span>",\
		"<span class=\"warning\">You hear an uneartly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.</span>")
	else if(!grav_pulling) //To prevent spam, detonating supermatter does not indicate non-mobs being destroyed
		AM.visible_message("<span class=\"warning\">\The [AM] smacks into \the [src] and rapidly flashes to ash.</span>",\
		"<span class=\"warning\">You hear a loud crack as you are washed with a wave of heat.</span>")

	Consume(AM)

/obj/machinery/power/supermatter/proc/Consume(var/mob/living/user)
	if(istype(user))
		user.dust()
		power += 200
	else
		if (istype(user, /obj/item/holder))
			var/obj/item/holder/H = user
			Consume(H.contained)//If its a holder, eat the thing inside
			qdel(H)
			return
		qdel(user)

	power += 200

		//Some poor sod got eaten, go ahead and irradiate people nearby.
	for(var/mob/living/L in view(10))
		to_chat(L, SPAN_WARNING("As \the [src] slowly stops resonating, you find your skin covered in new radiation burns."))
	SSradiation.radiate(src, 500)

/obj/machinery/power/supermatter/proc/supermatter_pull()
	//following is adapted from singulo code
	// Let's just make this one loop.
	for(var/atom/X in orange(pull_radius,src))
		X.singularity_pull(src, STAGE_FIVE)
		CHECK_TICK

/obj/machinery/power/supermatter/GotoAirflowDest(n) //Supermatter not pushed around by airflow
	return

/obj/machinery/power/supermatter/RepelAirflowDest(n)
	return

/obj/machinery/power/supermatter/shard //Small subtype, less efficient and more sensitive, but less boom.
	name = "Supermatter Shard"
	desc = "A strangely translucent and iridescent crystal that looks like it used to be part of a larger structure. <span class='warning'>You get headaches just from looking at it.</span>"
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"

	warning_point = 50
	emergency_point = 400
	explosion_point = 600

	gasefficency = 0.125

	pull_radius = 5
	pull_time = 45
	explosion_power = 3

/obj/machinery/power/supermatter/shard/announce_warning() //Shards don't get announcements
	return



#undef NITROGEN_RETARDATION_FACTOR
#undef THERMAL_RELEASE_MODIFIER
#undef PHORON_RELEASE_MODIFIER
#undef OXYGEN_RELEASE_MODIFIER
#undef REACTION_POWER_MODIFIER
#undef POWER_FACTOR
#undef DECAY_FACTOR
#undef CRITICAL_TEMPERATURE
#undef CHARGING_FACTOR
#undef DAMAGE_RATE_LIMIT
#undef SPACED_DAMAGE_FACTOR
#undef DETONATION_RADS
#undef DETONATION_HALLUCINATION
#undef WARNING_DELAY
#undef SUPERMATTER_ACCENT_SOUND_MIN_COOLDOWN
#undef LIGHT_POWER_CALC
