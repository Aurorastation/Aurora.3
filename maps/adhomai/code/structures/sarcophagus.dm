/obj/structure/closet/coffin/sarcophagus
	name = "sarcophagus"
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "sarc"
	icon_closed = "sarc"
	icon_opened = "sarc_open"

/obj/structure/closet/coffin/sarcophagus/treasure/fill()
	..()
	if(prob(50))
		new /obj/random/coin (src)
		new /obj/random/coin (src)

	if(prob(25))
		new /obj/item/weapon/archaeological_find (src)

	if(prob(15))
		new /obj/random/sword (src)

	if(prob(15))
		new /obj/item/mold/sword(src)

	if(prob(10))
		new /obj/item/stack/material/meteoric (src)
		new /obj/item/stack/material/meteoric (src)

	new /obj/effect/decal/remains/xeno (src)

/obj/structure/closet/coffin/sarcophagus/trapped
	var/list/possible_traps = list("fire", "explosion", "poison", "radiation", "gas")
	var/selected_trap
	var/used = FALSE

/obj/structure/closet/coffin/sarcophagus/trapped/Initialize(mapload)
	..()
	if(!selected_trap)
		selected_trap = pick(possible_traps)

/obj/structure/closet/coffin/sarcophagus/trapped/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(!used)
		trigger_trap(user)
	else
		toggle()

/obj/structure/closet/coffin/sarcophagus/trapped/proc/trigger_trap(mob/user)
	switch(selected_trap)

		if("fire")
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.adjust_fire_stacks(5)
				H.IgniteMob()
				visible_message("<span class='danger'>\The [src] engulfs \the [H] in a stream of fire when opened!</span>")

		if("explosion")
			visible_message("<span class='danger'>\The [src] explodes violently when opened!</span>")
			explosion(loc, 0, 2, 2, 3)

		if("poison")
			if(user.reagents)
				user.reagents.add_reagent("cyanide", 3)
				to_chat(user, "<span class='danger'>You feel a small prick as you open \the [src].</span>")

		if("radiation")
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.apply_radiation(200)
				visible_message("<span class='danger'>\The [src] emits a faint glow when opened!</span>")

		if("gas")
			var/datum/reagents/R = new/datum/reagents(100)
			R.my_atom = src
			R.add_reagent("toxin",500)
			var/datum/effect/effect/system/smoke_spread/chem/S = new("toxin")
			S.show_log = 0
			S.set_up(R, 10, 0, src, 40)
			S.start()
			qdel(R)
			visible_message("<span class='danger'>\The [src] releases a cloud when opened!</span>")

	used = TRUE
	toggle()

/obj/random/sarcophagus
	name = "random sarcophagus"
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "sarc"
	spawnlist = list(
		/obj/structure/closet/coffin/sarcophagus,
		/obj/structure/closet/coffin/sarcophagus/treasure,
		/obj/structure/closet/coffin/sarcophagus/trapped

	)