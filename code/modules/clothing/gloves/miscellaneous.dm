/obj/item/clothing/gloves/captain
	desc = "Regal blue gloves, with a nice gold trim. Swanky."
	name = "captain's gloves"
	icon_state = "captain"
	item_state = "egloves"

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1.0

/obj/item/clothing/gloves/swat
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	name = "\improper SWAT Gloves"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0.50
	permeability_coefficient = 0.05

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/combat //Combined effect of SWAT gloves and insulated gloves
	desc = "These tactical gloves are somewhat fire and impact resistant."
	name = "combat gloves"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/latex
	name = "latex gloves"
	desc = "Sterile latex gloves."
	icon_state = "latex"
	item_state = "lgloves"
	siemens_coefficient = 1.0 //thin latex gloves, much more conductive than fabric gloves (basically a capacitor for AC)
	permeability_coefficient = 0.01
	germ_level = 0
/obj/item/clothing/gloves/botanic_leather
	desc = "These leather work gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	name = "botanist's leather gloves"
	icon_state = "leather"
	item_state = "ggloves"
	permeability_coefficient = 0.05
	siemens_coefficient = 0.50 //thick work gloves

/obj/item/clothing/gloves/watch
	desc = "A small wristwatch, capable of telling time."
	name = "watch"
	icon_state = "watch"
	item_state = "watchgloves"
	w_class = 1
	wired = 1
	species_restricted = null

	verb/checktime()
		set category = "Object"
		set name = "Check Time"
		set src in usr

		if(wired && !clipped)
			usr << "You check your watch, spotting a digital collection of numbers reading '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [game_year]'."
			if (emergency_shuttle.get_status_panel_eta())
				usr << "\red The shuttle's status is reported as: [emergency_shuttle.get_status_panel_eta()]."
		else if(wired && clipped)
			usr << "You check your watch realising it's still open"
		else
			usr << "You check your watch as it dawns on you that it's broken"

	verb/pointatwatch()
		set category = "Object"
		set name = "Point at watch"
		set src in usr

		if(wired && !clipped)
			usr.visible_message ("<span class='notice'>[usr] taps their foot on the floor, arrogantly pointing at the [src] on their wrist with a look of derision in their eyes.</span>", "<span class='notice'>You point down at the [src], an arrogant look about your eyes.</span>")
		else if(wired && clipped)
			usr.visible_message ("<span class='notice'>[usr] taps their foot on the floor, arrogantly pointing at the [src] on their wrist with a look of derision in their eyes, not noticing it's open</span>", "<span class='notice'>You point down at the [src], an arrogant look about your eyes.</span>")
		else
			usr.visible_message ("<span class='notice'>[usr] taps their foot on the floor, arrogantly pointing at the [src] on their wrist with a look of derision in their eyes, not noticing it's broken</span>", "<span class='notice'>You point down at the [src], an arrogant look about your eyes.</span>")

	examine(mob/user)
		..()
		if (get_dist(src, user) <= 1)
			checktime()

	attackby(obj/item/weapon/W, mob/user)
		if(istype(W, /obj/item/weapon/screwdriver))
			if (clipped) //Using clipped because adding a new var for something is dumb
				user.visible_message("\blue [user] screws the cover of the [src] closed.","\blue You screw the cover of the [src] closed..")
				clipped = 0
				return
//			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			user.visible_message("\blue [user] unscrew the cover of the [src].","\blue You unscrew the cover of the [src].")
			clipped = 1
			return
		if(wired)
			return
		if(istype(W, /obj/item/stack/cable_coil))
			var/obj/item/stack/cable_coil/C = W
			if (!clipped)
				user << "<span class='notice'>The [src] is not open.</span>"
				return

			if(wired)
				user << "<span class='notice'>The [src] are already wired.</span>"
				return

			if(C.amount < 2)
				user << "<span class='notice'>There is not enough wire to cover the [src].</span>"
				return

			C.use(2)
			wired = 1
			user << "<span class='notice'>You repair some wires in the [src].</span>"
			return

	emp_act(severity)
		if(prob(50/severity))
			wired = 0
		..()

	/*
	Forcegloves.  They amplify force from melee hits as well as muck up disarm and stuff a little.
	Has bits of code in item_attack.dm, stungloves.dm, human_attackhand, human_defense
	*/


/obj/item/clothing/gloves/force // this pair should be put in r&d if you choose to do so.  and also the hos office locker.  do it okay

	desc = "These gloves bend gravity and bluespace, dampening inertia and augmenting the wearer's melee capabilities."
	name = "force gloves"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0.6
	permeability_coefficient = 0.05

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

	var/active = 1 //i am actually too lazy to code an on/off switch so if you want it off, take them off for now.  yes.
	var/amplification = 2

/obj/item/clothing/gloves/force/basic //dooo iiiitttttt
	desc = "These gloves bend gravity and bluespace, providing a cheap boost to the effectiveness of your average security staff."
	name = "basic force gloves" //do it skull do it give it to all sec the forums agree go
	amplification = 1 //just do it

/obj/item/clothing/gloves/force/syndicate  //for syndies.  pda, *maybe* nuke team or ert.  up to you.  maybe just use the amp 2 variant.
	desc = "These gloves bend gravity and bluespace, dampening inertia and augmenting the wearer's melee capabilities."
	name = "enhanced force gloves"
	icon_state = "black"
	item_state = "swat_gl"
	amplification = 2.5 //because *2.5 is kind of scary okay.  sometimes you want the scary effect.  sometimes not.


/* this is too cluttered.  i'd rather keep it simple.

	verb/toggleGloves() //also this doesn't actually do anything yet.  if you want to code in on/off, it needs interactions with the human attackhand file.
		set category = "Object"
		set name = "Toggle Forceglove Activity"
		set src in usr

		if (active == 0)
			active = 1
			amplification = 1.5
			usr << "You squeeze twice, activating the gloves and amplifying the force of your blows.  Your hands tingle pleasantly."

		else if (active == 1)
			active = 0
			amplification = 1
			usr << "You deactivate the forcegloves.  Your hands feel heavy."

	verb/toggleForceAmp()
		set category = "Object"
		set name = "Toggle Force-Amplification Level"
		set src in usr

		if (active == 0)
			usr << "You wiggle your fingers, but the gloves aren't active.  You activate them, setting the gloves to their lowest setting: Lethal.  You will now hit 1.5x as hard."
			amplification = 1.5
		else if (amplification < 1.5 || amplification == 2.5 )
			amplification = 1.5
			usr << "You wiggle your fingers, setting the gloves to their lowest setting: Lethal.  You will now hit 1.5x as hard."
		else if (amplification == 1.5)
			amplification = 2
			usr << "You wiggle your fingers, setting the gloves to the medium setting: Very Lethal.  You will now hit twice as hard."
		else if (amplification == 2)
			amplification = 2.5
			usr << "You wiggle your fingers, setting the gloves to the highest setting: Extremely Lethal.  You will now hit 2.5x as hard."

*/
