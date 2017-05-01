/obj/effect/projectile
	icon = 'icons/effects/projectiles.dmi'
	icon_state = "bolt"
	layer = 20

/obj/effect/projectile/New(var/turf/location)
	if(istype(location))
		loc = location

/obj/effect/projectile/proc/set_transform(var/matrix/M)
	if(istype(M))
		transform = M

/obj/effect/projectile/proc/activate(var/kill_delay = 3)
	spawn(kill_delay)
		qdel(src)	//see effect_system.dm - sets loc to null and lets GC handle removing these effects

	return

//----------------------------
// Laser beam
//----------------------------
/obj/effect/projectile/laser/tracer
	icon_state = "beam"

/obj/effect/projectile/laser/muzzle
	icon_state = "muzzle_laser"

/obj/effect/projectile/laser/impact
	icon_state = "impact_laser"

//----------------------------
// Blue laser beam
//----------------------------
/obj/effect/projectile/laser_blue/tracer
	icon_state = "beam_blue"

/obj/effect/projectile/laser_blue/muzzle
	icon_state = "muzzle_blue"

/obj/effect/projectile/laser_blue/impact
	icon_state = "impact_blue"

//----------------------------
// Omni laser beam
//----------------------------
/obj/effect/projectile/laser_omni/tracer
	icon_state = "beam_omni"

/obj/effect/projectile/laser_omni/muzzle
	icon_state = "muzzle_omni"

/obj/effect/projectile/laser_omni/impact
	icon_state = "impact_omni"

//----------------------------
// Xray laser beam
//----------------------------
/obj/effect/projectile/xray/tracer
	icon_state = "xray"

/obj/effect/projectile/xray/muzzle
	icon_state = "muzzle_xray"

/obj/effect/projectile/xray/impact
	icon_state = "impact_xray"

//----------------------------
// Heavy laser beam
//----------------------------
/obj/effect/projectile/laser_heavy/tracer
	icon_state = "beam_heavy"

/obj/effect/projectile/laser_heavy/muzzle
	icon_state = "muzzle_beam_heavy"

/obj/effect/projectile/laser_heavy/impact
	icon_state = "impact_beam_heavy"

//----------------------------
// Pulse laser beam
//----------------------------
/obj/effect/projectile/laser_pulse/tracer
	icon_state = "u_laser"

/obj/effect/projectile/laser_pulse/muzzle
	icon_state = "muzzle_u_laser"

/obj/effect/projectile/laser_pulse/impact
	icon_state = "impact_u_laser"

//----------------------------
// Pulse muzzle effect only
//----------------------------
/obj/effect/projectile/pulse/muzzle
	icon_state = "muzzle_pulse"

//----------------------------
// Emitter beam
//----------------------------
/obj/effect/projectile/emitter/tracer
	icon_state = "emitter"

/obj/effect/projectile/emitter/muzzle
	icon_state = "muzzle_emitter"

/obj/effect/projectile/emitter/impact
	icon_state = "impact_emitter"

//----------------------------
// Stun beam
//----------------------------
/obj/effect/projectile/stun/tracer
	icon_state = "stun"

/obj/effect/projectile/stun/muzzle
	icon_state = "muzzle_stun"

/obj/effect/projectile/stun/impact
	icon_state = "impact_stun"

//----------------------------
// Eye beam
//----------------------------
/obj/effect/projectile/eyelaser/tracer
	icon_state = "eye"

/obj/effect/projectile/eyelaser/muzzle
	icon_state = "muzzle_eye"

/obj/effect/projectile/eyelaser/impact
	icon_state = "impact_eye"

//----------------------------
// Bullet
//----------------------------
/obj/effect/projectile/bullet/muzzle
	icon_state = "muzzle_bullet"

// Solar beam
//----------------------------
/obj/effect/projectile/solar/tracer
	icon_state = "solar"

/obj/effect/projectile/solar/muzzle
	icon_state = "muzzle_solar"

/obj/effect/projectile/solar/impact
	icon_state = "impact_solar"

//----------------------------
// Pulse muzzle
//----------------------------
/obj/effect/projectile/pulse_bullet/muzzle
	icon_state = "muzzle_pulse"


//----------------------------
// Demonic Beam
//----------------------------
/obj/effect/projectile/cult/tracer
	icon_state = "cult"

/obj/effect/projectile/cult/muzzle
	icon_state = "muzzle_cult"

/obj/effect/projectile/cult/impact
	icon_state = "impact_cult"


//----------------------------
// Empowered Demonic Beam
//----------------------------
/obj/effect/projectile/cult/heavy/tracer
	icon_state = "hcult"

/obj/effect/projectile/cult/heavy/muzzle
	icon_state = "muzzle_hcult"

/obj/effect/projectile/cult/heavy/impact
	icon_state = "impact_hcult"