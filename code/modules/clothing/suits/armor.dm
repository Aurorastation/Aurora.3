/obj/item/clothing/suit/armor
	allowed = list(/obj/item/gun/energy,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/device/flashlight,/obj/item/clothing/head/helmet)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	item_flags = ITEM_FLAG_THICK_MATERIAL

	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5

	species_restricted = list("exclude", BODYTYPE_VAURCA_BREEDER, BODYTYPE_VAURCA_WARFORM, BODYTYPE_VAURCA_BULWARK)
	var/obj/item/storage/internal/pockets = /obj/item/storage/internal
	var/pocket_slots = 2
	var/pocket_size = 2
	var/pocket_total = null//This will be calculated, unless specifically overidden

/obj/item/clothing/suit/armor/Initialize()
	. = ..()
	if(pockets)
		pockets = new pockets(src)
		pockets.storage_slots = pocket_slots	//two slots
		pockets.max_w_class = pocket_size		//fit only pocket sized items
		if (pocket_total)
			pockets.max_storage_space = pocket_total
		else
			pockets.max_storage_space = pocket_slots * pocket_size

/obj/item/clothing/suit/armor/Destroy()
	if (pockets)
		QDEL_NULL(pockets)
	return ..()

/obj/item/clothing/suit/armor/attack_hand(mob/user as mob)
	if (pockets)
		if (pockets.handle_attack_hand(user))
			..(user)
	else
		..(user)

/obj/item/clothing/suit/armor/MouseDrop(obj/over_object as obj)
	if (pockets)
		if (pockets.handle_mousedrop(usr, over_object))
			..(over_object)
	else
		..(over_object)

/obj/item/clothing/suit/armor/attackby(obj/item/attacking_item, mob/user)
	..()
	if(istype(attacking_item, /obj/item/clothing/accessory/armor_plate))
		if(attacking_item in accessories) //We already attached this. Don't try to put it in our pockets
			return
	if(pockets)
		pockets.attackby(attacking_item, user)

/obj/item/clothing/suit/armor/emp_act(severity)
	. = ..()

	if (pockets)
		pockets.emp_act(severity)

/obj/item/clothing/suit/armor/hear_talk(mob/M, var/msg, verb, datum/language/speaking)
	if (pockets)
		pockets.hear_talk(M, msg, verb, speaking)
	..()

/obj/item/clothing/suit/armor/vest
	name = "armored vest"
	desc = "An armored vest that protects against some damage."
	icon_state = "armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/suit/storage/toggle/armor/hos
	name = "armored trenchcoat"
	desc = "A trenchcoat lined with a protective alloy and some slick leather."
	icon_state = "jensencoat"
	item_state = "jensencoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
	allowed = list(/obj/item/gun/energy, /obj/item/reagent_containers/spray/pepper, /obj/item/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/handcuffs, /obj/item/device/flashlight)

/obj/item/clothing/suit/storage/toggle/armor/hos/Initialize()
	. = ..()
	pockets = new /obj/item/storage/internal(src)
	pockets.storage_slots = 4
	pockets.max_w_class = ITEMSIZE_SMALL
	pockets.max_storage_space = 8

/obj/item/clothing/suit/armor/swat
	name = "swat suit"
	desc = "A heavily armored suit that protects against moderate damage. Used in special operations."
	icon_state = "deathsquad"
	item_state = "swat_suit"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	item_flags = ITEM_FLAG_THICK_MATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank/emergency_oxygen)
	slowdown = 1
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.35
	pocket_slots = 4//fullbody, more slots

/obj/item/clothing/suit/armor/swat/officer
	name = "officer jacket"
	desc = "An armored jacket used in special operations."
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	flags_inv = 0
	body_parts_covered = UPPER_TORSO|ARMS
	pocket_slots = 4//coat, so more slots

//Reactive armor
//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive
	name = "reactive teleport armor"
	desc = "Someone separated our Research Director from their own head!"
	var/active = 0.0
	icon_state = "reactiveoff"
	item_state = "reactiveoff"
	blood_overlay_type = "armor"
	slowdown = 1
	armor = null

/obj/item/clothing/suit/armor/reactive/handle_shield(mob/user, var/on_back, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(prob(50))
		user.visible_message("<span class='danger'>The reactive teleport system flings [user] clear of the attack!</span>")
		var/list/turfs = new/list()
		for(var/turf/T in orange(6, user))
			if(istype(T,/turf/space)) continue
			if(T.density) continue
			if(T.x>world.maxx-6 || T.x<6)	continue
			if(T.y>world.maxy-6 || T.y<6)	continue
			turfs += T
		if(!turfs.len) turfs += pick(/turf in orange(6))
		var/turf/picked = pick(turfs)
		if(!isturf(picked)) return

		spark(user, 5)
		playsound(user.loc, /singleton/sound_category/spark_sound, 50, 1)

		user.forceMove(picked)
		return PROJECTILE_FORCE_MISS
	return FALSE

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		to_chat(user, "<span class='notice'>The reactive armor is now active.</span>")
		src.icon_state = "reactive"
		src.item_state = "reactive"
	else
		to_chat(user, "<span class='notice'>The reactive armor is now inactive.</span>")
		src.icon_state = "reactiveoff"
		src.item_state = "reactiveoff"
		src.add_fingerprint(user)
	return

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	. = ..()

	active = 0
	src.icon_state = "reactiveoff"
	src.item_state = "reactiveoff"

/obj/item/clothing/suit/armor/tactical
	name = "tactical armor"
	desc = "A suit of armor most often used by Special Weapons and Tactics squads. Includes padded vest with pockets along with shoulder and kneeguards."
	icon_state = "swatarmor"
	item_state = "armor"
	var/obj/item/gun/holstered = null
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	slowdown = 1
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.35
	var/obj/item/clothing/accessory/holster/holster

/obj/item/clothing/suit/armor/tactical/Initialize()
	. = ..()
	holster = new()
	holster.icon_state = null
	holster.on_attached(src)	//its inside a suit, we set  this so it can be drawn from
	QDEL_NULL(pockets)	//Tactical armor has internal holster instead of pockets, so we null this out
	cut_overlays()	// Remove the holster's overlay.

/obj/item/clothing/suit/armor/tactical/attackby(obj/item/attacking_item, mob/user)
	..()
	holster.attackby(attacking_item, user)

/obj/item/clothing/suit/armor/tactical/attack_hand(mob/user as mob)
	if (loc == user)//If we're wearing the suit and we click it with an empty hand
		holster.attack_hand(user)//Remove the weapon in the holster
	else
		..(user)

/obj/item/clothing/suit/armor/tactical/verb/holster()
	set name = "Holster"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if (usr.get_active_hand())
		if(!holster.holstered)
			var/obj/item/W = usr.get_active_hand()
			if(!istype(W, /obj/item))
				to_chat(usr, "<span class='warning'>You need your gun equiped to holster it.</span>")
				return
			holster.holster(W, usr)
		else
			to_chat(usr, "<span class='warning'>There's already a gun in the holster, you need an empty hand to draw it.</span>")
			return
	else
		if(holster.holstered)
			holster.unholster(usr)
		else
			to_chat(usr, "<span class='warning'>There's no gun in the holster to draw.</span>")


//Non-hardsuit ERT armor.
/obj/item/clothing/suit/armor/vest/ert
	name = "emergency response team armor"
	desc = "A set of armor worn by members of the Emergency Response Team."
	icon_state = "ertarmor_cmd"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.35

//Commander
/obj/item/clothing/suit/armor/vest/ert/command
	name = "emergency response team commander armor"
	desc = "A set of armor worn by the commander of an Emergency Response Team. Has blue highlights."

//Security
/obj/item/clothing/suit/armor/vest/ert/security
	name = "emergency response team security armor"
	desc = "A set of armor worn by security members of the Emergency Response Team. Has red highlights."
	icon_state = "ertarmor_sec"

//Engineer
/obj/item/clothing/suit/armor/vest/ert/engineer
	name = "emergency response team engineer armor"
	desc = "A set of armor worn by engineering members of the Emergency Response Team. Has orange highlights."
	icon_state = "ertarmor_eng"

//Medical
/obj/item/clothing/suit/armor/vest/ert/medical
	name = "emergency response team medical armor"
	desc = "A set of armor worn by medical members of the Emergency Response Team. Has red and white highlights."
	icon_state = "ertarmor_med"

/obj/item/clothing/suit/storage/vest
	name = "armor vest"
	desc = "A simple kevlar plate carrier."
	icon_state = "kvest"
	item_state = "kvest"
	allowed = list(/obj/item/gun,/obj/item/reagent_containers/spray/pepper,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/device/flashlight)
	siemens_coefficient = 0.5
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/suit/storage/vest/Initialize()
	. = ..()
	pockets.storage_slots = 2	//two slots

/obj/item/clothing/suit/storage/vest/officer
	name = "officer armor vest"
	desc = "A simple kevlar plate carrier belonging to the SCC. This one has a security holobadge clipped to the chest."
	icon_state = "officervest_nobadge"
	item_state = "officervest_nobadge"
	icon_badge = "officervest_badge"
	icon_nobadge = "officervest_nobadge"

/obj/item/clothing/suit/storage/vest/warden
	name = "warden armor vest"
	desc = "A simple kevlar plate carrier belonging to the SCC. This one has a silver badge clipped to the chest."
	icon_state = "wardenvest_nobadge"
	item_state = "wardenvest_nobadge"
	icon_badge = "wardenvest_badge"
	icon_nobadge = "wardenvest_nobadge"

/obj/item/clothing/suit/storage/vest/hos
	name = "commander armor vest"
	desc = "A simple kevlar plate carrier belonging to the SCC. This one has a gold badge clipped to the chest."
	icon_state = "hosvest_nobadge"
	item_state = "hosvest_nobadge"
	icon_badge = "hosvest_badge"
	icon_nobadge = "hosvest_nobadge"

/obj/item/clothing/suit/storage/vest/detective
	name = "detective armor vest"
	desc = "A simple kevlar plate carrier belonging to the SCC. This one has a detective's badge clipped to the chest."
	icon_state = "detectivevest_nobadge"
	item_state = "detectivevest_nobadge"
	icon_badge = "detectivevest_badge"
	icon_nobadge = "detectivevest_nobadge"

/obj/item/clothing/suit/storage/vest/ft
	name = "forensic technician armor vest"
	desc = "A simple kevlar plate carrier belonging to the SCC. This one has a forensic technician's badge clipped to the chest."
	icon_state = "forensictech_nobadge"
	item_state = "forensictech_nobadge"
	icon_badge = "forensictech_badge"
	icon_nobadge = "forensictech_nobadge"

/obj/item/clothing/suit/storage/hazardvest/security
	name = "cadet hazard vest"
	desc = "A sturdy high-visibility vest intended for training security personnel."
	icon = 'icons/obj/item/clothing/department_uniforms/security.dmi'
	icon_state = "hazard_cadet"
	item_state = "hazard_cadet"
	allowed = list(/obj/item/gun,/obj/item/reagent_containers/spray/pepper,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/device/flashlight)
	siemens_coefficient = 0.5
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
		)
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/hazardvest/security/officer
	name = "officer hazard jacket"
	desc = "A sturdy high-visibility jacket for the on the beat officer."
	icon_state = "hazard_officer"
	item_state = "hazard_officer"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/vest/heavy/officer
	name = "officer heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to the SCC, with webbing attached. This one has a security holobadge clipped to the chest."
	icon_state = "officerwebvest_nobadge"
	item_state = "officerwebvest_nobadge"
	icon_badge = "officerwebvest_badge"
	icon_nobadge = "officerwebvest_nobadge"

/obj/item/clothing/suit/storage/vest/heavy/warden
	name = "warden heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to the SCC, with webbing attached. This one has a silver badge clipped to the chest."
	icon_state = "wardenwebvest_nobadge"
	item_state = "wardenwebvest_nobadge"
	icon_badge = "wardenwebvest_badge"
	icon_nobadge = "wardenwebvest_nobadge"

/obj/item/clothing/suit/storage/vest/heavy/hos
	name = "commander heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to the SCC, with webbing attached. This one has a gold badge clipped to the chest."
	icon_state = "hoswebvest_nobadge"
	item_state = "hoswebvest_nobadge"
	icon_badge = "hoswebvest_badge"
	icon_nobadge = "hoswebvest_nobadge"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_BALLISTIC_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

//ert related armor

/obj/item/clothing/suit/storage/vest/heavy/ert
	name = "ERT trooper's plate carrier"
	desc = "A plate carrier worn by troopers of the emergency response team. Has crimson highlights."
	icon_state = "ert_soldier"
	item_state = "ert_soldier"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.35
	slowdown = 0

/obj/item/clothing/suit/storage/vest/heavy/ert/commander
	name = "ERT commander's plate carrier"
	desc = "A plate carrier worn by the elite emergency response team commander. Has gold highlights. This one has a Medal of Valor pinned to the breastplate."
	icon_state = "ert_commander"
	item_state = "ert_commander"

/obj/item/clothing/suit/storage/vest/heavy/ert/lead
	name = "leading trooper's plate carrier"
	desc = "A plate carrier worn by veteran troopers of the emergency response team qualified to lead small squads. Has blue highlights."
	icon_state = "ert_lead"
	item_state = "ert_lead"

/obj/item/clothing/suit/storage/vest/heavy/ert/medic
	name = "ERT medic's plate carrier"
	desc = "A plate carrier worn by combat medics of the emergency response team. Has white highlights. This one has a medic patch sewn to the breastplate."
	icon_state = "ert_medic"
	item_state = "ert_medic"

/obj/item/clothing/suit/storage/vest/heavy/ert/sapper
	name = "ERT sapper's plate carrier"
	desc = "A plate carrier worn by sappers of the emergency response team. Has green highlights."
	icon_state = "ert_sapper"
	item_state = "ert_sapper"

/obj/item/clothing/suit/storage/vest/heavy/ert/peacekeeper
	name = "ERT civil protection plate carrier"
	desc = "A plate carrier worn by troopers serving civil protection details. Commonly seen on high-profile escorts and SCC administration centers."
	icon_state = "civilprotection_nobadge"
	item_state = "civilprotection_nobadge"
	icon_badge = "civilprotection_badge"
	icon_nobadge = "civilprotection_nobadge"

//unathi armor

/obj/item/clothing/suit/armor/unathi
	name = "unathi body armor"
	desc = "An outdated set of ceramic-metal body armor of Unathi design. Commonly seen on Moghes during the days of the Contact War, and now commonplace in the hands of raiders and pirates."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "unathi_armor"
	item_state = "unathi_armor"
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_UNATHI)
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_KEVLAR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.35

/obj/item/clothing/suit/armor/unathi/hegemony
	name = "hegemony body armor"
	desc = "A highly armored ceramic-metal composite chestplate fitted for an Unathi. Commonly used by the military forces of the Izweski Hegemony."
	icon_state = "hegemony_armor"
	item_state = "hegemony_armor"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		rad = ARMOR_RAD_MINOR
	)

// Vaurca version of Unathi armor
/obj/item/clothing/suit/armor/unathi/klax
	name = "klaxan warrior body armor"
	desc = "A highly armored ceramic-metal composite chestplate fitted for a Vaurca Warrior. Commonly used by the military forces of the Izweski Hegemony."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "klax_hopeful"
	item_state = "klax_hopeful"
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_VAURCA)
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		rad = ARMOR_RAD_MINOR
	)
	allowed = list(/obj/item/gun/projectile, /obj/item/gun/energy, /obj/item/gun/launcher, /obj/item/melee, /obj/item/reagent_containers/spray/pepper, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/handcuffs, /obj/item/device/flashlight)
	siemens_coefficient = 0.35

/obj/item/clothing/suit/storage/vest/legion
	name = "foreign legion armored suit"
	desc = "A set of cheap composite armor with elbow guards, shoulder and knee pads."
	icon_state = "legion_armor"
	item_state = "legion_armor"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS
	siemens_coefficient = 0.35
	allowed = list(
		/obj/item/gun,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/handcuffs,
		/obj/item/device/flashlight,
		/obj/item/material/twohanded/pike/flag
	)
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT
	)

/obj/item/clothing/suit/storage/vest/legion/legate
	name = "foreign legion legate coat"
	desc = "A luxurious coat made out of sturdy synthetic fabrics and reinforced with lightweight alloys. Only worn by some of the highest decorated officers of the TCFL."
	icon_state = "legion_coat"
	item_state = "legion_coat"

/obj/item/clothing/suit/storage/vest/legion/legate/Initialize()
	. = ..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 4
	pockets.max_w_class = ITEMSIZE_SMALL
	pockets.max_storage_space = 8

/obj/item/clothing/suit/storage/vest/sol
	name = "sol heavy armor vest"
	desc = "A high-quality armor vest in a deep green. It is surprisingly flexible and light, even with the added webbing and armor plating."
	icon = 'icons/clothing/under/uniforms/sol_uniform.dmi'
	icon_state = "solwebvest"
	item_state = "solwebvest"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/vest/konyang
	name = "konyang police vest"
	desc = "A fairly dated armor vest in bright blue issued to the various police forces of Konyang. It comes with a prominent silver emblem on the front."
	icon = 'icons/clothing/under/uniforms/konyang_uniforms.dmi'
	icon_state = "police_vest"
	item_state = "police_vest"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/vest/kala
	name = "kala armor vest"
	desc = "A simple armor vest issued to all of the Kala. It's made of an advanced lightweight alloy."
	icon = 'icons/clothing/kit/skrell_armor.dmi'
	icon_state = "kala_armor"
	item_state = "kala_armor"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)
	contained_sprite = TRUE

//All of the armor below is mostly unused

/obj/item/clothing/suit/armor/centcomm
	name = "Cent. Com. armor"
	desc = "A suit that protects against some damage."
	icon_state = "centcom"
	item_state = "centcom"
	w_class = ITEMSIZE_LARGE//bulky item
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/gun/energy,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank/emergency_oxygen)
	flags_inv = HIDEWRISTS|HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "A heavily armored suit that protects against moderate damage."
	icon_state = "heavy"
	item_state = "swat_suit"
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.90
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 3
	flags_inv = HIDEWRISTS|HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0.1
	pocket_slots = 3

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEWRISTS|HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/armor/tdome/red
	name = "thunderdome suit (red)"
	desc = "Reddish armor."
	icon_state = "tdred"
	item_state = "tdred"
	siemens_coefficient = 1

/obj/item/clothing/suit/armor/tdome/green
	name = "thunderdome suit (green)"
	desc = "Pukish armor."
	icon_state = "tdgreen"
	item_state = "tdgreen"
	siemens_coefficient = 1
