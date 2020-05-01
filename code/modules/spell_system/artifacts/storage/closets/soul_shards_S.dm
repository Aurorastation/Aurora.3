/obj/structure/closet/wizard/souls
	name = "soul shard belt"
	desc = "Soul Stone Shards are ancient tools capable of capturing and harnessing the spirits of the dead and dying. The spell Artificer allows you to create arcane machines for the captured souls to pilot. This also includes the spell Artificer, used to create the shells used in construct creation."

/obj/structure/closet/wizard/souls/fill()
	..()
	new /obj/item/contract/boon/wizard/artificer(src)
	new /obj/item/storage/belt/soulstone/full(src)