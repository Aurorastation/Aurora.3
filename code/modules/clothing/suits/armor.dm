/obj/item/clothing/suit/armor
	allowed = list(/obj/item/gun/energy,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/device/flashlight)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	item_flags = THICKMATERIAL

	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5
	var/obj/item/storage/internal/pockets
	var/pocket_slots = 2
	var/pocket_size = 2
	var/pocket_total = null//This will be calculated, unless specifically overidden

/obj/item/clothing/suit/armor/Initialize()
	. = ..()
	pockets = new /obj/item/storage/internal(src)
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

/obj/item/clothing/suit/armor/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (pockets)
		pockets.attackby(W, user)

/obj/item/clothing/suit/armor/emp_act(severity)
	if (pockets)
		pockets.emp_act(severity)
	..()

/obj/item/clothing/suit/armor/hear_talk(mob/M, var/msg, verb, datum/language/speaking)
	if (pockets)
		pockets.hear_talk(M, msg, verb, speaking)
	..()

/obj/item/clothing/suit/armor/vest
	name = "armor"
	desc = "An armored vest that protects against some damage."
	icon_state = "armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/vest/security
	name = "security armor"
	desc = "An armored vest that protects against some damage. This one has a corporate badge."
	icon_state = "armorsec"
	item_state = "armor"

/obj/item/clothing/suit/armor/vest/warden
	name = "warden's jacket"
	desc = "An armoured jacket with silver rank pips and livery."
	icon_state = "warden_jacket"
	item_state = "warden_jacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	pocket_slots = 4//Jackets have more slots

/obj/item/clothing/suit/armor/vest/warden/commissar
	name = "commissar's jacket"
	desc = "An tasteful dark blue jacket with silver and white highlights. Has hard-plate inserts for armor."
	icon_state = "commissar_warden"
	item_state = "commissar_warden"

/obj/item/clothing/suit/armor/hos
	name = "head of security's jacket"
	desc = "An armoured jacket with golden rank pips and livery."
	icon_state = "hos"
	item_state = "hos"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	pocket_slots = 4//More slots because coat

/obj/item/clothing/suit/storage/toggle/armor/hos/jensen
	name = "armored trenchcoat"
	desc = "A trenchcoat augmented with a special alloy for some protection and style."
	icon_state = "jensencoat"
	item_state = "jensencoat"
	icon_open = "jensencoat_open"
	icon_closed = "jensencoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/gun/energy,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/device/flashlight)

/obj/item/clothing/suit/storage/toggle/armor/hos/jensen/Initialize()
	. = ..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 4
	pockets.max_w_class = 2
	pockets.max_storage_space = 8

/obj/item/clothing/suit/armor/riot
	name = "riot vest"
	desc = "A vest of armor with heavy padding to protect against melee attacks. Looks like it might impair movement."
	icon_state = "riot_vest"
	item_state = "riot_vest"
	slowdown = 1
	armor = list(melee = 80, bullet = 20, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.35
	pocket_slots = 4

/obj/item/clothing/suit/armor/bulletproof
	name = "ballistic vest"
	desc = "A vest that excels in protecting the wearer against high-velocity solid projectiles."
	icon_state = "bulletproof_armor"
	item_state = "bulletproof_armor"
	blood_overlay_type = "armor"
	armor = list(melee = 25, bullet = 80, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.35
	pocket_slots = 4

/obj/item/clothing/suit/armor/laserproof
	name = "ablative armor vest"
	desc = "A vest that excels in protecting the wearer against energy projectiles."
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	blood_overlay_type = "armor"
	armor = list(melee = 25, bullet = 25, laser = 80, energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0
	pocket_slots = 4

/obj/item/clothing/suit/armor/laserproof/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(istype(damage_source, /obj/item/projectile/energy) || istype(damage_source, /obj/item/projectile/beam))
		var/obj/item/projectile/P = damage_source

		var/reflectchance = 40 - round(damage/3)
		if(!(def_zone in list("chest", "groin")))
			reflectchance /= 2
		if(P.starting && prob(reflectchance))
			visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text]!</span>")

			// Find a turf near or on the original location to bounce to
			var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)

			// redirect the projectile
			P.firer = user
			P.old_style_target(locate(new_x, new_y, P.z))

			return PROJECTILE_CONTINUE // complete projectile permutation

/obj/item/clothing/suit/armor/swat
	name = "swat suit"
	desc = "A heavily armored suit that protects against moderate damage. Used in special operations."
	icon_state = "deathsquad"
	item_state = "swat_suit"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank/emergency_oxygen)
	slowdown = 1
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 100, rad = 100)
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

/obj/item/clothing/suit/armor/det_suit
	name = "armor"
	desc = "An armored vest with a detective's badge on it."
	icon_state = "detective-armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)


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
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/reactive/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
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
		playsound(user.loc, "sparks", 50, 1)

		user.forceMove(picked)
		return PROJECTILE_FORCE_MISS
	return 0

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
	active = 0
	src.icon_state = "reactiveoff"
	src.item_state = "reactiveoff"
	..()

/obj/item/clothing/suit/armor/tactical
	name = "tactical armor"
	desc = "A suit of armor most often used by Special Weapons and Tactics squads. Includes padded vest with pockets along with shoulder and kneeguards."
	icon_state = "swatarmor"
	item_state = "armor"
	var/obj/item/gun/holstered = null
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	slowdown = 1
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 20, bio = 0, rad = 0)
	siemens_coefficient = 0.35
	var/obj/item/clothing/accessory/holster/holster

/obj/item/clothing/suit/armor/tactical/Initialize()
	. = ..()
	holster = new()
	holster.icon_state = null
	holster.on_attached(src)	//its inside a suit, we set  this so it can be drawn from
	QDEL_NULL(pockets)	//Tactical armour has internal holster instead of pockets, so we null this out
	cut_overlays()	// Remove the holster's overlay.

/obj/item/clothing/suit/armor/tactical/attackby(obj/item/W as obj, mob/user as mob)
	..()
	holster.attackby(W, user)

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
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 20, bio = 0, rad = 0)
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

//New Vests
/obj/item/clothing/suit/storage/vest
	name = "armor vest"
	desc = "A simple kevlar plate carrier."
	icon_state = "kvest"
	item_state = "kvest"
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/gun,/obj/item/reagent_containers/spray/pepper,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/device/flashlight)
	siemens_coefficient = 0.5

/obj/item/clothing/suit/storage/vest/Initialize()
	. = ..()
	pockets.storage_slots = 2	//two slots

/obj/item/clothing/suit/storage/vest/officer
	name = "officer armor vest"
	desc = "A simple kevlar plate carrier belonging to Nanotrasen. This one has a security holobadge clipped to the chest."
	icon_state = "officervest_nobadge"
	item_state = "officervest_nobadge"
	icon_badge = "officervest_badge"
	icon_nobadge = "officervest_nobadge"

/obj/item/clothing/suit/storage/vest/warden
	name = "warden armor vest"
	desc = "A simple kevlar plate carrier belonging to Nanotrasen. This one has a silver badge clipped to the chest."
	icon_state = "wardenvest_nobadge"
	item_state = "wardenvest_nobadge"
	icon_badge = "wardenvest_badge"
	icon_nobadge = "wardenvest_nobadge"

/obj/item/clothing/suit/storage/vest/hos
	name = "commander armor vest"
	desc = "A simple kevlar plate carrier belonging to Nanotrasen. This one has a gold badge clipped to the chest."
	icon_state = "hosvest_nobadge"
	item_state = "hosvest_nobadge"
	icon_badge = "hosvest_badge"
	icon_nobadge = "hosvest_nobadge"
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/vest/pcrc
	name = "PCRC armor vest"
	desc = "A simple kevlar plate carrier belonging to Proxima Centauri Risk Control. This one has a PCRC crest clipped to the chest."
	icon_state = "pcrcvest_nobadge"
	item_state = "pcrcvest_nobadge"
	icon_badge = "pcrcvest_badge"
	icon_nobadge = "pcrcvest_nobadge"

/obj/item/clothing/suit/storage/vest/detective
	name = "detective armor vest"
	desc = "A simple kevlar plate carrier in a vintage brown, it has a detective's badge clipped to the chest."
	icon_state = "detectivevest_nobadge"
	item_state = "detectivevest_nobadge"
	icon_badge = "detectivevest_badge"
	icon_nobadge = "detectivevest_nobadge"

/obj/item/clothing/suit/storage/vest/csi
	name = "forensic technician armor vest"
	desc = "A simple kevlar plate carrier belonging to Nanotrasen. This one has a forensic technician's badge clipped to the chest."
	icon_state = "csivest_nobadge"
	item_state = "csivest_nobadge"
	icon_badge = "csivest_badge"
	icon_nobadge = "csivest_nobadge"

/obj/item/clothing/suit/storage/hazardvest/cadet
	name = "cadet hazard vest"
	desc = "A sturdy high-visibility vest intended for in training security personnel."
	icon_state = "hazard_cadet"
	item_state = "hazard_cadet"
	icon_open = "hazard_cadet_open"
	icon_closed = "hazard_cadet"
	allowed = list(/obj/item/gun,/obj/item/reagent_containers/spray/pepper,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/device/flashlight)
	armor = list(melee = 10, bullet = 0, laser = 10, energy = 10, bomb = 10, bio = 0, rad = 0)
	siemens_coefficient = 0.5

/obj/item/clothing/suit/storage/vest/heavy
	name = "heavy armor vest"
	desc = "A heavy kevlar plate carrier with webbing attached."
	icon_state = "webvest"
	item_state = "webvest"
	armor = list(melee = 50, bullet = 40, laser = 50, energy = 25, bomb = 30, bio = 0, rad = 0)
	slowdown = 1
	siemens_coefficient = 0.35

/obj/item/clothing/suit/storage/vest/heavy/officer
	name = "officer heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to Nanotrasen with webbing attached. This one has a security holobadge clipped to the chest."
	icon_state = "officerwebvest_nobadge"
	item_state = "officerwebvest_nobadge"
	icon_badge = "officerwebvest_badge"
	icon_nobadge = "officerwebvest_nobadge"

/obj/item/clothing/suit/storage/vest/heavy/warden
	name = "warden heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to Nanotrasen with webbing attached. This one has a silver badge clipped to the chest."
	icon_state = "wardenwebvest_nobadge"
	item_state = "wardenwebvest_nobadge"
	icon_badge = "wardenwebvest_badge"
	icon_nobadge = "wardenwebvest_nobadge"

/obj/item/clothing/suit/storage/vest/heavy/hos
	name = "commander heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to Nanotrasen with webbing attached. This one has a gold badge clipped to the chest."
	icon_state = "hoswebvest_nobadge"
	item_state = "hoswebvest_nobadge"
	icon_badge = "hoswebvest_badge"
	icon_nobadge = "hoswebvest_nobadge"
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/vest/heavy/pcrc
	name = "PCRC heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to Proxima Centauri Risk Control with webbing attached. This one has a PCRC crest clipped to the chest."
	icon_state = "pcrcwebvest_nobadge"
	item_state = "pcrcwebvest_nobadge"
	icon_badge = "pcrcwebvest_badge"
	icon_nobadge = "pcrcwebvest_nobadge"

//Provides the protection of a merc voidsuit, but only covers the chest/groin, and also takes up a suit slot. In exchange it has no slowdown and provides storage.
/obj/item/clothing/suit/storage/vest/merc
	name = "heavy armor vest"
	desc = "A high-quality armor vest in a fetching tan. It is surprisingly flexible and light, even with the added webbing and armor plating."
	icon_state = "mercwebvest"
	item_state = "mercwebvest"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 40, bio = 0, rad = 0)

//ert related armor

/obj/item/clothing/suit/storage/vest/heavy/ert
	name = "ERT trooper's plate carrier"
	desc = "A plate carrier worn by troopers of the emergency response team. Has crimson highlights."
	icon_state = "ert_soldier"
	item_state = "ert_soldier"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 20, bio = 0, rad = 0)
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
	desc = "A plate carrier worn by troopers serving civil protection details. Commonly seen on high-profile escorts and Nanotrasen administration centers."
	icon_state = "civilprotection_nobadge"
	item_state = "civilprotection_nobadge"
	icon_badge = "civilprotection_badge"
	icon_nobadge = "civilprotection_nobadge"

//unathi armor

/obj/item/clothing/suit/armor/unathi
	name = "unathi body armor"
	desc = "An armored chestplate designated to be worn by an unathi, used commonly by the hegemony levies."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "unathi_armor"
	item_state = "unathi_armor"
	contained_sprite = TRUE
	species_restricted = list("Unathi")
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0.35

/obj/item/clothing/suit/armor/tajara
	name = "amohdan swordsmen armor"
	desc = "A suit of armor used by the traditional warriors of Amohda."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "amohdan_armor"
	item_state = "amohdan_armor"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/gun,/obj/item/material/sword)
	flags_inv = HIDEJUMPSUIT|HIDETAIL
	species_restricted = list("Tajara")
	armor = list(melee = 60, bullet = 50, laser = 20, energy = 10, bomb = 5, bio = 0, rad = 0)
	siemens_coefficient = 0.35
	description_fluff = "The Feudal Era of Amohda is famous for the steel swords which became common. Many renowned swordsmen and famous warriors would travel the land fighting duels of \
	single combat in their quests to become the greatest swordsman. Modern Amohda is a mix between loyalists to the NKA and to the DPRA, with almost universal praise for a return to \
	traditional culture, yet often violent disagreement about the course of the island's political future. A sizable third party of monarchists which advocate the reestablishment of the \
	Imperial Amohdan dynasty also exists, fragmenting the monarchist factions on the island and further complicating political violence in the area."


//tau ceti foreign legion armor

/obj/item/clothing/suit/storage/vest/legion
	name = "foreign legion armored suit"
	desc = "A set of cheap composite armor with elbow guards, shoulder and knee pads."
	icon_state = "legion_armor"
	item_state = "legion_armor"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS
	armor = list(melee = 50, bullet = 30, laser = 30, energy = 15, bomb = 40, bio = 0, rad = 0)
	siemens_coefficient = 0.35

/obj/item/clothing/suit/armor/vest/idris
	name = "Idris Reclamation Unit coat"
	desc = "A coat worn by the Idris reclamation units, notorious across space."
	icon_state = "iru_coat"
	item_state = "iru_coat"
	cold_protection = 0
	min_cold_protection_temperature = 0
	heat_protection = 0
	max_heat_protection_temperature = 0

/obj/item/clothing/suit/storage/vest/sol
	name = "sol heavy armor vest"
	desc = "A high-quality armor vest in a deep green. It is surprisingly flexible and light, even with the added webbing and armor plating."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "solwebvest"
	item_state = "solwebvest"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 40, bio = 0, rad = 0)
	contained_sprite = 1

//All of the armor below is mostly unused

/obj/item/clothing/suit/armor/centcomm
	name = "Cent. Com. armor"
	desc = "A suit that protects against some damage."
	icon_state = "centcom"
	item_state = "centcom"
	w_class = 4//bulky item
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/gun/energy,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank/emergency_oxygen)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "A heavily armored suit that protects against moderate damage."
	icon_state = "heavy"
	item_state = "swat_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.90
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 3
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0.1
	pocket_slots = 3

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

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
