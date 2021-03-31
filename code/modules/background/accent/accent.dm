/datum/accent
	var/name
	var/description = "Unga Dunga."
	var/tag_icon //those icons should go in accent_tags.dmi

/proc/get_accent(var/accent_tag)
	var/datum/asset/spritesheet/S = get_asset_datum(/datum/asset/spritesheet/goonchat)
	return S.icon_tag(accent_tag)