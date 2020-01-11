/obj/item/device/orbital_dropper/drill
	name = "drill dropper"
	desc = "A device used to paint a target, which will then promptly orbitally drop the requested items. This drill literally pierces the heavens."

	drop_message = "Stand by for drillfall, ETA ten seconds, clear the targetted area."
	drop_message_emagged = "St%n^ b* for dr$llfa#l, ETA t@n s*c%&ds, RUN."

	template_name = "drill.dmm"

/obj/item/device/orbital_dropper/mecha
	name = "mecha dropper"
	desc = "A device used to paint a target, which will then promptly orbitally drop the requested items. This one feels vaguely familiar..."

	drop_amount = 1

	drop_message = "Mech coming in hot!"
	drop_message_emagged = "Mech comin- SHIT! WHO PAINTED THAT?"
	announcer_name = "Respawn Mech Industries"
	announcer_channel = "Common"

	template_name = "combat-mecha.dmm"

/obj/item/device/orbital_dropper/armory
	name = "armory dropper"
	desc = "A device used to paint a target, which will then promptly orbitally drop the requested items. Who's ready to raise hell?"

	drop_amount = 1

	drop_message = "The cavalry has arrived!"
	drop_message_emagged = "The cav-cav-cav-BzzzZZTTT!"
	announcer_name = "GunCourier Industries Autodrone"
	announcer_channel = "Common"

	template_name = "mini-armory.dmm"

/obj/item/device/orbital_dropper/armory/syndicate
	description_antag = "This is a stealthy variant of the standard armory orbital drop. It will not report itself dropping on common, unless emagged."
	announcer_name = "Syndicate Autodrone"
	announcer_channel = "Mercenary"