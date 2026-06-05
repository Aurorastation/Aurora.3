/datum/autowiki/guns
	page = "Template:Autowiki/Content/GunData"


/datum/autowiki/guns/generate()
	var/output = ""

	for(var/typepath in sort_list(subtypesof(/obj/item/gun), GLOBAL_PROC_REF(cmp_typepaths_asc)))
		var/obj/item/gun/generating_gun = new typepath()
		if(IS_AUTOWIKI_SKIP(generating_gun))
			continue

		var/filename = SANITIZE_FILENAME(escape_value(format_text(generating_gun.name)))

		var/list/gun_data = list(
			"name" = generating_gun.name,
			"desc" = generating_gun.desc
		)

		var/list/valid_mag_types = list()
		if(istype(generating_gun, /obj/item/gun/projectile))
			var/obj/item/gun/projectile/projectile_gun = generating_gun
			valid_mag_types = projectile_gun.allowed_magazines

		var/ammo = ""
		for(var/ammo_typepath in valid_mag_types)
			var/obj/item/ammo_magazine/generating_mag = new ammo_typepath()
			if(IS_AUTOWIKI_SKIP(generating_mag))
				continue

			var/ammo_filename = SANITIZE_FILENAME(escape_value(format_text(generating_mag.name)))

			if(!fexists("data/autowiki_files/[ammo_filename].png"))
				upload_icon(getFlatIcon(generating_mag, no_anim = TRUE), ammo_filename)

			ammo += include_template("Autowiki/AmmoMagazine", list(
				"icon" = escape_value(ammo_filename),
				"name" = escape_value(generating_mag.name),
				"capacity" = escape_value(generating_mag.max_ammo),
			))

			qdel(generating_mag)

		gun_data["ammo_types"] = ammo


		upload_icon(getFlatIcon(generating_gun, no_anim = TRUE), filename)
		gun_data["icon"] = filename

		output += include_template("Autowiki/Gun", gun_data)

		qdel(generating_gun)

	return output

/datum/autowiki/guns/proc/wiki_sanitize_assoc(list/sanitizing_list)
	var/list/sanitized = list()

	for(var/key in sanitizing_list)
		var/value = sanitizing_list[key]

		sanitized[escape_value(key)] = escape_value(value)

	return sanitized
