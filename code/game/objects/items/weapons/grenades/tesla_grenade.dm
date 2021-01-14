/obj/item/grenade/tesla
	name = "tesla grenade"
	icon_state = "tesla_grenade"
	item_state = "tesla_grenade"
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4)
	var/zap_power = 10000

/obj/item/grenade/tesla/prime()
	..()
	tesla_zap(src, 5, zap_power)
	tesla_zap(src, 5, zap_power)
	tesla_zap(src, 5, zap_power)
	qdel(src)

/obj/item/grenade/tesla/bio
	name = "bio tesla grenade"
	desc = "A biological tesla grenade, naturally produced by the cavern dwellers of the romanovich cloud."
	icon_state = "bio_tesla_grenade"
	item_state = "bio_tesla_grenade"
	origin_tech = list(TECH_BIO = 3, TECH_MATERIAL = 3, TECH_MAGNET = 4)
	activation_sound = null
	zap_power = 7500