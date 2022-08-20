/obj/machinery/bluespace_drive
	name = "bluespace drive"
	desc = "An extremely advanced piece of technology, allowing for entire ships to blink out of existance and materialize at another place in the galaxy."
	icon = 'icons/contained_objects/machinery/bluespace_drive.dmi'
	icon_state = "bsd_core"
	anchored = TRUE
	density = TRUE
	pixel_y = -32
	pixel_x = -32
	idle_power_usage = 150 KILOWATTS
	health_max = 1000
	health_resistances = DAMAGE_RESIST_ELECTRICAL
	damage_hitsound = 'sound/machines/bluespace_drive/bsd_damaging.ogg'
	health_min_damage = 10

	var/obj/item/device/radio/radio

	/// Indicates whether the drive should show effects.
	var/const/STATE_BROKEN = FLAG(0)

	/// Indicates whether the drive should use the unstable core effect.
	var/const/STATE_UNSTABLE = FLAG(1)

	/// A field of STATE_* flags related to the drive.
	var/state = EMPTY_BITFIELD

/obj/machinery/bluespace_drive/Destroy()
	return ..()

/obj/machinery/bluespace_drive/Initialize()
	. = ..()
	radio = new /obj/item/device/radio{channels=list("Engineering")}(src)
	playsound(src, 'sound/machines/bluespace_drive/bsd_idle.ogg', 100, extrarange = 6)
	particles = new /particles/bluespace_drive_torus
	set_light(1, 5, 15, 10, COLOR_CYAN)
	update_icon()

/obj/machinery/bluespace_drive/update_icon()
	cut_overlays()
	if(state & STATE_BROKEN)
		icon_state = "bsd_core-broken"
	else
		icon_state = "bsd_core"
	if(state & STATE_UNSTABLE)
		add_overlay("singularity-unstable")
	else if(state & STATE_BROKEN)
		return
	else
		add_overlay("singularity")

/obj/machinery/bluespace_drive/emp_act(severity)
	..()
	if(!(state & STATE_BROKEN))
		visible_message(SPAN_WARNING("\The [src]'s field warps and buckles uneasily!"))
		playsound(get_turf(src), damage_hitsound, 80)

/obj/machinery/bluespace_drive/bullet_act(obj/item/projectile/projectile)
	. = ..()
	if(!(state & STATE_BROKEN))
		visible_message(SPAN_WARNING("\The [src]'s field crackles disturbingly!"))
		playsound(get_turf(src), damage_hitsound, 80)

/obj/machinery/bluespace_drive/post_health_change(health_mod, damage_type)
	. = ..()
	var/damage_percentage = get_damage_percentage()
	if(damage_percentage >= 50 && !(state & STATE_UNSTABLE))
		state |= STATE_UNSTABLE
		update_icon()
	else if(damage_percentage < 50 && (state & STATE_UNSTABLE))
		state &= ~STATE_UNSTABLE
		update_icon()

/obj/machinery/bluespace_drive/on_death()
	. = ..()
	playsound(get_turf(src), 'sound/machines/bluespace_drive/bsd_explosion.ogg', 100)
	visible_message(SPAN_DANGER(FONT_LARGE("\The [src] begins emitting an ear-splitting, horrible shrill! Get back!")))
	addtimer(CALLBACK(src, .proc/explode), 31 SECONDS)
	radio.autosay(FONT_LARGE("<b>DANGER: BLUESPACE DRIVE SINGULARITY DELAMINATION IMMINENT!</b>"), "Bluespace Drive Monitoring Circuit")
	playsound(src, 'sound/machines/bluespace_drive/bsd_alarm.ogg', 100, is_global = TRUE)

/// Final death act handler for the drive where it explodes. You really shouldn't call this directly or you'll make weird broken things regarding health tracking. Use `kill_health()` instead, the death handler calls this.
/obj/machinery/bluespace_drive/proc/explode()
	visible_message(SPAN_DANGER(FONT_LARGE("\The [src]'s containment field is wracked by a series of horrendous distortions, buckling and twisting like a living thing before bursting in a flash of light!")))
	//explosion(get_turf(src), -1, 5, 10)
	empulse(get_turf(src), 4, 7)
	state |= STATE_BROKEN
	for (var/verb in verbs)
		verbs -= verb
	QDEL_NULL(radio)
	QDEL_NULL(particles)
	update_icon()

/obj/machinery/bluespace_drive/attackby(obj/item/item, mob/user)
	if(istype(item, /obj/item/grab))
		var/obj/item/grab/grab = item
		to_chat(user, SPAN_WARNING("\The [src] pulls at \the [grab.affecting] but they're too heavy."))
		return
	if(issilicon(user) || !user.unEquip(item, src))
		to_chat(user, SPAN_WARNING("\The [src] pulls at \the [item] but it's attached to you."))
		return
	user.visible_message(
		SPAN_WARNING("\The [user] reaches out \a [item] to \the [src], warping briefly as it disappears in a flash of blue light, scintillating motes left behind."),
		SPAN_DANGER("You touch \the [src] with \the [item], the field buckling around it before retracting with a crackle as it leaves small, blue scintillas on your hand as you flinch away."),
		SPAN_WARNING("You hear an otherwordly crackle, followed by humming.")
	)
	qdel(item)
	playsound(get_turf(src), 'sound/machines/bluespace_drive/bsd_interact.ogg', 100)

/obj/machinery/bluespace_drive/examine_damage_state(mob/user)
	if(health_dead)
		to_chat(user, SPAN_DANGER("Its field is completely destroyed, the core revealed under the arcing debris."))
		return

	var/damage_percentage = get_damage_percentage()
	switch (damage_percentage)
		if(0)
			to_chat(user, SPAN_NOTICE("At a glance, its field is peacefully humming without any alterations."))
		if(1 to 32)
			to_chat(user, SPAN_WARNING("Its field is crackling gently, with the occasional twitch."))
		if(33 to 65)
			to_chat(user, SPAN_WARNING("Its damaged field is twitching and crackling dangerously!"))
		else
			to_chat(user, SPAN_DANGER("Its unstable field is cracking and shifting dangerously, revealing the core inside briefly!"))