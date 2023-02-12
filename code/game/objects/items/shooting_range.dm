#define DECAL_SCORCH 1
#define DECAL_BULLET 2

// Targets, the things that actually get shot!
/obj/item/target
	name = "shooting target"
	desc = "A shooting target."
	icon = 'icons/obj/target_stake.dmi'
	icon_state = "target_h"
	var/obj/structure/target_stake/stake
	var/hp = 1800
	var/icon/virtual_icon
	var/list/bullet_holes

/obj/item/target/Destroy()
	if(stake)
		stake.set_target(null)
	return ..()

/obj/item/target/attackby(var/obj/item/W, var/mob/user)
	if(W.iswelder())
		if(hp == initial(hp))
			to_chat(user, SPAN_NOTICE("\The [src] is fully repaired."))
			return TRUE
		var/obj/item/weldingtool/WT = W
		if(WT.use(0, user))
			cut_overlays()
			LAZYCLEARLIST(bullet_holes)
			icon = initial(icon)
			hp = initial(hp)
			to_chat(user, SPAN_NOTICE("You slice off \the [src]'s uneven chunks of steel and scorch marks."))
		return TRUE

/obj/item/target/attack_hand(var/mob/user)
	// taking pinned targets off!
	if(stake)
		stake.attack_hand(user)
	else
		return ..()

/obj/item/target/syndicate
	icon_state = "target_s"
	desc = "A shooting target that looks like a hostile agent."
	hp = 2600 // i guess syndie targets are sturdier?

/obj/item/target/alien
	icon_state = "target_q"
	desc = "A shooting target with a threatening silhouette."
	hp = 2350 // alium onest too kinda

/obj/item/target/bullet_act(var/obj/item/projectile/Proj)
	var/p_x = Proj.p_x + pick(0,0,0,0,0,-1,1) // really ugly way of coding "sometimes offset Proj.p_x!"
	var/p_y = Proj.p_y + pick(0,0,0,0,0,-1,1)
	var/decaltype = (Proj.damage_flags & DAM_BULLET) ? DECAL_BULLET : DECAL_SCORCH

	virtual_icon = new(icon, icon_state)

	if(virtual_icon.GetPixel(p_x, p_y)) // if the located pixel isn't blank (null)
		hp -= Proj.damage
		if(hp <= 0)
			visible_message(SPAN_WARNING("\The [src] breaks into tiny pieces and collapses!"))
			qdel(src)
			return

		// Create a temporary object to represent the damage
		var/obj/bmark = new
		bmark.pixel_x = p_x
		bmark.pixel_y = p_y
		bmark.icon = 'icons/effects/effects.dmi'
		bmark.layer = ABOVE_OBJ_LAYER
		bmark.icon_state = "scorch"

		if(decaltype == DECAL_SCORCH) // Energy weapons are hot. they scorch!
			// offset correction
			bmark.pixel_x--
			bmark.pixel_y--

			if(Proj.damage >= 20 || istype(Proj, /obj/item/projectile/beam/practice))
				bmark.icon_state = "scorch"
				bmark.set_dir(pick(NORTH,SOUTH,EAST,WEST)) // random scorch design
			else
				bmark.icon_state = "light_scorch"
		else // Bullets are hard. They make dents!
			bmark.icon_state = "dent"

		if(Proj.damage >= 10 && length(bullet_holes) <= 35) // maximum of 35 bullet holes
			if(decaltype == DECAL_BULLET)
				if(prob(Proj.damage+30)) // bullets make holes more commonly!
					new /datum/bullethole(src, bmark.pixel_x, bmark.pixel_y) // create new bullet hole
			else // Lasers!
				if(prob(Proj.damage-10)) // lasers make holes less commonly
					new /datum/bullethole(src, bmark.pixel_x, bmark.pixel_y) // create new bullet hole

		// draw bullet holes
		for(var/datum/bullethole/B in bullet_holes)
			virtual_icon.DrawBox(null, B.b1x1, B.b1y,  B.b1x2, B.b1y) // horizontal line, left to right
			virtual_icon.DrawBox(null, B.b2x, B.b2y1,  B.b2x, B.b2y2) // vertical line, top to bottom


		add_overlay(bmark) // add the decal
		icon = virtual_icon // apply bullet_holes over decals
		return

	return PROJECTILE_CONTINUE // the bullet/projectile goes through the target!


// Small memory holder entity for transparent bullet holes
/datum/bullethole
	// First box
	var/b1x1 = 0
	var/b1x2 = 0
	var/b1y = 0

	// Second box
	var/b2x = 0
	var/b2y1 = 0
	var/b2y2 = 0

/datum/bullethole/New(var/obj/item/target/Target, var/pixel_x = 0, var/pixel_y = 0)
	if(!Target)
		return

	// Randomize the first box
	b1x1 = pixel_x - pick(1,1,1,1,2,2,3,3,4)
	b1x2 = pixel_x + pick(1,1,1,1,2,2,3,3,4)
	b1y = pixel_y
	if(prob(35))
		b1y += rand(-4,4)

	// Randomize the second box
	b2x = pixel_x
	if(prob(35))
		b2x += rand(-4,4)
	b2y1 = pixel_y + pick(1,1,1,1,2,2,3,3,4)
	b2y2 = pixel_y - pick(1,1,1,1,2,2,3,3,4)

	LAZYADD(Target.bullet_holes, src)

#undef DECAL_SCORCH
#undef DECAL_BULLET
