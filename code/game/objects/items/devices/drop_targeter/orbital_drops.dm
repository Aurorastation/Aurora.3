/obj/item/device/orbital_dropper/drill
	name = "drill dropper"
	desc = "A device used to paint a target, which will then promptly orbitally drop the requested items. This drill literally pierces the heavens."

	drop_message = "Stand by for drillfall, ETA ten seconds, clear the targeted area."
	drop_message_emagged = "St%n^ b* for dr$llfa#l, ETA t@n s*c%&ds, RUN."

	map = new /datum/map_template/drill

/obj/item/device/orbital_dropper/minecart
	name = "minecart train dropper"
	desc = "A device used to paint a target, which will then promptly orbitally drop the requested items. This one is configured to deliver an exoplanet-ready minecart train. Rails not included."

	drop_message = "Stand by for trainfall, ETA ten seconds. Clear the targeted area."
	drop_message_emagged = "St%n^ b* for tr$infa#l, ETA t@n s*c%&ds, CHOO CHOO!"

	drop_amount = 1
	map = new /datum/map_template/minecart

/obj/item/device/orbital_dropper/mecha
	name = "mecha dropper"
	desc = "A device used to paint a target, which will then promptly orbitally drop the requested items. This one feels vaguely familiar..."

	drop_amount = 1

	drop_message = "Mech coming in hot!"
	drop_message_emagged = "Mech comin- SHIT! WHO PAINTED THAT?"
	announcer_name = "Respawn Mech Industries"
	announcer_channel = "Common"

	map = new /datum/map_template/mecha

/obj/item/device/orbital_dropper/mecha/heavy
	map = new /datum/map_template/mecha/heavy

/obj/item/device/orbital_dropper/mecha/combat
	map = new /datum/map_template/mecha/combat

/obj/item/device/orbital_dropper/mecha/powerloader
	map = new /datum/map_template/mecha/powerloader

/obj/item/device/orbital_dropper/armory
	name = "armory dropper"
	desc = "A device used to paint a target, which will then promptly orbitally drop the requested items. Who's ready to raise hell?"

	drop_amount = 1

	drop_message = "The cavalry has arrived!"
	drop_message_emagged = "The cav-cav-cav-BzzzZZTTT!"
	announcer_name = "GunCourier Industries Autodrone"
	announcer_channel = "Common"

	map = new /datum/map_template/armory

/obj/item/device/orbital_dropper/armory/syndicate
	desc_antag = "This is a stealthy variant of the standard armory orbital drop. It will not report itself dropping on common, unless emagged."
	announcer_name = "Syndicate Autodrone"
	announcer_channel = "Mercenary"

/obj/item/device/orbital_dropper/icarus_drones
	name = "icarus painter"
	desc = "A device used to paint a target, which will then promptly orbitally drop the requested items. This one has been modified to call in Icarus Drones."

	var/num_of_drones = 2
	drop_amount = 1
	does_explosion = FALSE

	emagged = TRUE // to let people drop it in the station

	drop_message_emagged = "NanoTrasen combat drones coming your way! Happy hunting!"
	announcer_name = "SCCV Horizon Sensor Array"

	map = null

/obj/item/device/orbital_dropper/icarus_drones/orbital_drop(var/turf/target, var/user)
	log_and_message_admins("[key_name_admin(user)] has used a [src] at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>.")
	for(var/i = 1, i <= num_of_drones, i++)
		new /mob/living/simple_animal/hostile/icarus_drone(get_random_turf_in_range(target, 4, 2, TRUE))
