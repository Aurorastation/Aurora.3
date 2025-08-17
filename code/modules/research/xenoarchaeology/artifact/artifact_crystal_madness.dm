
/obj/structure/crystal_madness
	name = "large crystal"
	desc = "\
		A large crystal, seemingly floating in the air, and giving off a light blue glow.\
		"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "crystal_madness"
	density = 1
	light_color = "#99eef3"
	light_range = 2
	light_power = 0.5
	/// Advanced by damaging the crystal.
	/// Effects depend on current stage.
	var/stage = 0
	/// Time of last stage advancement.
	/// So that stage cannot be advanced too quickly.
	var/last_stage_advancement = 0

/obj/structure/crystal_madness/proc/advance_stage()
	// immediate effects
	if(prob(50))
		stage += 1
	set_light(
		clamp(light_range+pick(-0.50,0.50,1.00), 2.0, 9.0),
		clamp(light_power+pick(-0.25,0.25,0.50), 0.5, 7.0),
		pick("#a9d8e0", "#99eef3", "#99eef3", "#79cfd4", "#439a9f"),
	)

	// get mobs
	var/list/affected_mobs = list()
	for(var/mob/living/carbon/human/mob_in_range in get_hearers_in_LOS(world.view, src))
		if((!mob_in_range.is_psi_blocked(src)) && (mob_in_range.has_psionics() || mob_in_range.has_psi_aug() || mob_in_range.has_zona_bovinae()))
			affected_mobs += mob_in_range

	// set up timer for delayed effects
	addtimer(CALLBACK(src, PROC_REF(delayed_stage_effect), affected_mobs), 5 SECONDS)

/obj/structure/crystal_madness/proc/delayed_stage_effect(var/list/affected_mobs)
	for(var/mob/living/carbon/human/mob in affected_mobs)
		if(stage < 3)
			to_chat(mob,
				pick(
					SPAN_NOTICE("For a very brief moment, you feel uneasy."),
					SPAN_NOTICE("For a very short moment, you feel strange."),
					SPAN_NOTICE("For a short while, you feel anxious."),
					SPAN_NOTICE("You feel very anxious for a second or two."),
					SPAN_NOTICE("You are very uncomfortable for a few seconds."),
					SPAN_NOTICE("You experience a strange feeling for a short moment."),
					SPAN_NOTICE("You feel strange and anxious for a short while, but that feeling fades away quickly."),
				),
			)
			desc = "\
				A large crystal, seemingly floating in the air, and giving off a light blue glow.\
				"
		else if(stage < 6)
			to_chat(mob,
				pick(
					SPAN_WARNING("You feel very anxious for a short while."),
					SPAN_WARNING("For a short while, you feel very anxious and uncomfortable."),
					SPAN_WARNING("A very unsettling thought crosses your head."),
					SPAN_WARNING("Some dreadful concept enters your mind, and stays there for a short moment."),
					SPAN_WARNING("A very distressing thought intrudes into your mind."),
					SPAN_WARNING("A vaguely disturbing thought intrudes into your mind."),
					SPAN_WARNING("A thought crosses your head, making you fearful of what is coming."),
				),
			)
			shake_camera(mob, 3, 1)
			mob.make_adrenaline(5)
			desc = "\
				A large crystal, seemingly floating in the air, and giving off a strong light blue glow. \
				It appears to be vibrating or shaking slightly.\
				"
		else if(stage < 9)
			to_chat(mob,
				pick(
					SPAN_DANGER("You hear a voice intruding into your mind, suggesting violent thoughts, but it fades away quickly."),
					SPAN_DANGER("Unknown voice enters your mind, encouraging violence, but it disappears after a few moments."),
					SPAN_DANGER("A voice appears to invade your thoughts, telling you to commit acts of violence, but it soon disappears."),
					SPAN_DANGER("For a brief moment, you cannot stop yourself thinking about hurting others."),
					SPAN_DANGER("You find yourself thinking about violence and hurting other people, for a short while."),
					SPAN_DANGER("You cannot stop yourself from wishing death upon others, for a short moment."),
					SPAN_DANGER("For a few seconds, the only concept you can imagine or think about, is death."),
					SPAN_DANGER("You are paralyzed with fear, unable to do anything, until a moment passes and you regain control over your body."),
					SPAN_DANGER("For a short while, you feel as if you have lost control over your body, only able to imagine dreadful, fearful thoughts."),
				),
			)
			shake_camera(mob, 6, 2)
			mob.make_dizzy(120)
			mob.make_adrenaline(15)
			desc = "\
				A large crystal, seemingly floating in the air, and giving off a strong light blue glow. \
				It appears to be vibrating or shaking, and lets out a constant, if quiet, hum.\
				"
		else
			to_chat(mob,
				pick(
					SPAN_HIGHDANGER("You hear a voice intruding into your mind, suggesting violence, and you can do nothing but obey."),
					SPAN_HIGHDANGER("Some unknown entity enters your mind, encouraging violence, and you can only follow its command."),
					SPAN_HIGHDANGER("An entity appears to invade your thoughts, telling you to kill and murder, and you feel it taking control over your body."),
					SPAN_HIGHDANGER("Some voice invades into your mind, instructing you to kill and murder, and you feel as if your body moves on its own to follow this command."),
					SPAN_HIGHDANGER("You find yourself thinking about violence and hurting other people, for a short while, before you decide to act on these thoughts."),
					SPAN_HIGHDANGER("You feel powerless when an entity intrudes into your mind, and commands you to commit terrible, violent acts."),
					SPAN_HIGHDANGER("All you can do is comply when a voice intrudes into your thoughts, commanding you to commit acts of violence."),
					SPAN_HIGHDANGER("For a brief moment you see an entity, so strange you cannot even describe, before it invades your mind and orders you to rage and kill."),
					SPAN_HIGHDANGER("For a short moment, you witness an otherworldly being that you cannot even begin to describe, before it infiltrates your thoughts and gives you the instruction to kill and become furious."),
					SPAN_HIGHDANGER("You feel as if you have lost control over your own body, only watching from the backseat, as it goes on a rampage."),
				),
			)
			shake_camera(mob, 9, 4)
			mob.make_dizzy(200)
			mob.make_adrenaline(30)
			addtimer(CALLBACK(mob, TYPE_PROC_REF(/mob/living/carbon/human, berserk_start)), 10 SECONDS)
			addtimer(CALLBACK(mob, TYPE_PROC_REF(/mob/living/carbon/human, berserk_stop)), 60 SECONDS)
			stage = 3
			desc = "\
				A large crystal, seemingly floating in the air, and giving off a light blue glow.\
				"

/obj/structure/crystal_madness/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	if(istype(hitting_projectile, /obj/projectile/bullet))
		src.visible_message(
			pick(
				SPAN_WARNING("\The [src] appears to deflect \the [hitting_projectile], shattering it into dust."),
				SPAN_WARNING("\The [src] appears to deflect \the [hitting_projectile], sending it up in the air."),
				SPAN_WARNING("\The [src] appears to bounce off \the [hitting_projectile], sending it into the floor."),
				SPAN_WARNING("\The [src] appears to deflect \the [hitting_projectile]."),
				SPAN_WARNING("\The [src] appears to deflect \the [hitting_projectile]. It has little effect."),
				SPAN_WARNING("\The [src] appears to bounce off \the [hitting_projectile]."),
				SPAN_WARNING("\The [src] appears to bounce off \the [hitting_projectile]. It has little effect."),
			),
		)
	else if(istype(hitting_projectile, /obj/projectile/energy))
		src.visible_message(
			pick(
				SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile]."),
				SPAN_WARNING("\The [src] appears to consume \the [hitting_projectile]."),
				SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile] entirely."),
				SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile]. It has little effect."),
				SPAN_WARNING("\The [src] appears to consume \the [hitting_projectile]. It has little effect."),
			),
		)
	else if(istype(hitting_projectile, /obj/projectile/beam))
		var/damage = hitting_projectile.get_structure_damage()
		if(damage < 20)
			src.visible_message(
				pick(
				SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile]."),
				SPAN_WARNING("\The [src] appears to consume \the [hitting_projectile]."),
				SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile] entirely."),
				SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile]. It has little effect."),
				SPAN_WARNING("\The [src] appears to consume \the [hitting_projectile]. It has little effect."),
				),
			)
		else
			if(world.time - last_stage_advancement > 30 SECONDS)
				last_stage_advancement = world.time
				advance_stage()
			src.visible_message(
				pick(
					SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile] entirely."),
					SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile] completely."),
					SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile], and vibrates slightly."),
					SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile], and hums."),
					SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile]. It glows stronger momentarily."),
					SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile]. It glows brighter for a few seconds."),
					SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile]. You can hear it resonate."),
					SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile]. You can hear it vibrate."),
					SPAN_WARNING("\The [src] appears to absorb \the [hitting_projectile]. You can see it glow stronger for a few seconds."),
				),
			)

/obj/structure/crystal_madness/attack_hand(mob/user as mob)
	if(stage < 1)
		user.visible_message(
			SPAN_WARNING("\The [user] reaches out and touches \the [src]."),
			SPAN_DANGER("You reach out and touch \the [src]. It is cold."),
			)
	else if(stage < 3)
		user.visible_message(
			SPAN_WARNING("\The [user] reaches out and touches \the [src]."),
			SPAN_DANGER("You reach out and touch \the [src]. It is somewhat warm."),
			)
	else if(stage < 6)
		user.visible_message(
			SPAN_WARNING("\The [user] reaches out and touches \the [src]."),
			SPAN_DANGER("You reach out and touch \the [src]. It is very hot."),
			)
	else
		user.visible_message(
			SPAN_WARNING("\The [user] reaches out and touches \the [src]."),
			SPAN_DANGER("You reach out and touch \the [src]. It is scorching hot, and you feel it twitch and vibrate slightly."),
			)

/obj/structure/crystal_madness/attackby(obj/item/attacking_item, mob/user)
	if(stage < 6)
		user.visible_message(
			SPAN_WARNING("\The [user] reaches out and touches \the [src]."),
			SPAN_DANGER("You touch \the [attacking_item] to \the [src]."),
			)
	else
		user.visible_message(
			SPAN_WARNING("\The [user] reaches out and touches \the [src]."),
			SPAN_DANGER("You touch \the [attacking_item] to \the [src]. You can feel it vibrating slightly even through \the [src]."),
			)


