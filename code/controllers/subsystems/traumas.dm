var/datum/controller/subsystem/traumas/SStraumas

/datum/controller/subsystem/traumas
	name = "Traumas"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC
	var/list/phobia_types
	var/list/phobia_words
	var/list/phobia_mobs
	var/list/phobia_objs
	var/list/phobia_turfs
	var/list/phobia_species

#define PHOBIA_FILE "phobia.json"

/datum/controller/subsystem/traumas/New()
    NEW_SS_GLOBAL(SStraumas)

/datum/controller/subsystem/traumas/Initialize()
	phobia_types = list("spiders", "space", "security", "doctors", "clowns", "lizards", "cats", "humans", "skrell", "robots", "pests", "nanotrasen", "filth", "paranormals", "death", "darkness")

	phobia_words = list("spiders"   = strings(PHOBIA_FILE, "spiders"),
						"space"     = strings(PHOBIA_FILE, "space"),
						"security"  = strings(PHOBIA_FILE, "security"),
						"clowns"    = strings(PHOBIA_FILE, "clowns"),
						"doctors"= strings(PHOBIA_FILE, "doctors"),
						"lizards"    = strings(PHOBIA_FILE, "unathi"),
						"cats"       = strings(PHOBIA_FILE, "cats"),
						"humans"    = strings(PHOBIA_FILE, "humans"),
						"skrell"    = strings(PHOBIA_FILE, "skrell"),
						"robots"    = strings(PHOBIA_FILE, "robots"),
						"pests"     = strings(PHOBIA_FILE, "pests"),
						"nanotrasen"= strings(PHOBIA_FILE, "nanotrasen"),
						"filth"     = strings(PHOBIA_FILE, "filth"),
						"paranormals"= strings(PHOBIA_FILE, "paranormals"),
						"death"     = strings(PHOBIA_FILE, "death"),
						"darkness" = strings(PHOBIA_FILE, "darkness")
					   )

	phobia_mobs = list("spiders"  = typecacheof(list(/mob/living/simple_animal/spiderbot, /mob/living/simple_animal/hostile/giant_spider)),
						"security" = typecacheof(list(/mob/living/bot/secbot)),
						"lizards"  = typecacheof(list(/mob/living/simple_animal/lizard)),
						"cats"  = typecacheof(list(/mob/living/simple_animal/cat, /mob/living/simple_animal/familiar/pet/cat, /mob/living/simple_animal/cat/kitten)),
						"robots"  = typecacheof(list(/mob/living/silicon,/mob/living/bot, /mob/living/simple_animal/hostile/retaliate/malf_drone)),
						"pests" = typecacheof(list(/mob/living/simple_animal/hostile/carp, /mob/living/simple_animal/rat, /mob/living/carbon/alien/diona)),
						"paranormals" = typecacheof(list(/mob/living/simple_animal/hostile/scarybat, /mob/living/simple_animal/hostile/true_changeling,
														/mob/living/simple_animal/hostile/mimic, /mob/living/simple_animal/hostile/faithless,
														/mob/living/simple_animal/construct)),
						"death" = typecacheof(list(/mob/abstract/observer))
					   )

	phobia_objs = list("spiders"   = typecacheof(list(/obj/effect/spider,/obj/item/toy/plushie/spider, /obj/effect/decal/cleanable/spiderling_remains)),

					   "security"  = typecacheof(list(/obj/item/clothing/under/rank/security, /obj/item/clothing/under/rank/warden, /obj/item/clothing/head/beret/sec,
											 	 /obj/item/clothing/under/rank/head_of_security, /obj/item/clothing/under/det, /obj/item/clothing/glasses/hud/security,
												 /obj/item/melee/baton, /obj/item/gun/energy/taser, /obj/item/handcuffs, /obj/item/clothing/glasses/sunglasses/sechud,
												 /obj/machinery/door/airlock/security, /obj/item/clothing/under/rank/cadet, /obj/structure/sign/directions/security,
												 /obj/item/clothing/head/bio_hood/security, /obj/item/clothing/head/bomb_hood/security, /obj/item/clothing/head/helmet/space/void/security,
												 /obj/item/clothing/head/soft/sec, /obj/item/clothing/suit/armor/vest/security, /obj/item/clothing/suit/bio_suit/security,
												 /obj/item/clothing/suit/bomb_suit/security, /obj/item/clothing/suit/security/navyofficer, /obj/item/clothing/suit/space/void/security,
												 /obj/item/clothing/suit/storage/hooded/wintercoat/security, /obj/item/device/magnetic_lock/security,/obj/item/toy/figure/secofficer,
												 /obj/item/gun/bang/sec, /obj/item/gun/projectile/sec, /obj/item/book/manual/wiki/security_space_law)),

					   "clowns"    = typecacheof(list(/obj/item/clothing/under/rank/clown, /obj/item/clothing/shoes/clown_shoes,
												 /obj/item/clothing/mask/gas/clown_hat, /obj/item/bananapeel,
												 /obj/item/bikehorn, /obj/item/device/pda/clown)),

					   "cats"  = typecacheof(list(/obj/item/clothing/head/tajaran, /obj/item/clothing/suit/storage/tajaran,
												 /obj/item/clothing/suit/storage/toggle/labcoat/tajaran, /obj/item/clothing/suit/storage/tajaran,
												 /obj/item/stack/material/animalhide/cat, /obj/item/holder/cat, /obj/item/toy/plushie/kitten)),

					   "lizards"   = typecacheof(list(/obj/item/toy/plushie/lizard,/obj/item/material/hatchet/unathiknife,/obj/item/rig/unathi,
												/obj/item/clothing/suit/unathi/robe, /obj/structure/sign/flag/hegemony, /obj/item/stack/material/animalhide/lizard,
												/obj/item/toy/plushie/lizard)),

					   "skrell" = typecacheof(list(/obj/structure/sign/flag/jargon, /obj/item/clothing/ears/skrell, /obj/item/clothing/suit/space/void/skrell,
												 /obj/item/clothing/head/helmet/space/void/skrell, /obj/item/organ/internal/brain/skrell, /obj/item/organ/internal/eyes/skrell,
												 /obj/item/organ/internal/heart/skrell, /obj/item/organ/internal/kidneys/skrell, /obj/item/organ/internal/liver/skrell, /obj/item/organ/internal/lungs/skrell,
												 /obj/item/reagent_containers/food/snacks/skrellsnacks)),

					   "robots" = typecacheof(list(/obj/item/device/electronic_assembly/drone, /obj/item/holder/drone, /obj/item/device/mmi/digital,
												 /obj/item/organ/internal/ipc_tag, /obj/machinery/computer/borgupload, /obj/item/clothing/suit/cyborg_suit,
												 /obj/machinery/cryopod/robot, /obj/machinery/robotic_fabricator, /obj/effect/decal/cleanable/blood/gibs/robot, /obj/effect/decal/remains/robot,
												 /obj/item/robot_parts, /obj/item/organ/internal/cell, /obj/item/organ/internal/data, /obj/item/toy/figure/borg)),

					   "nanotrasen" = typecacheof(list(/obj/item/toy/nanotrasenballoon, /obj/item/soap/nanotrasen, /obj/structure/sign/flag/nanotrasen,
												 /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen, /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen, /obj/item/storage/toolbox/lunchbox/nt,
												 /obj/structure/banner, /obj/structure/bed/chair/office/bridge, /obj/item/clothing/head/collectable/captain,
												 /obj/item/clothing/head/helmet/space/void/captain, /obj/item/clothing/suit/space/void/captain, /obj/item/clothing/suit/storage/hooded/wintercoat/captain,
												 /obj/item/clothing/under/captainformal, /obj/item/clothing/under/rank/captain, /obj/item/toy/figure/captain, /obj/item/card/id/captains_spare,
												 /obj/item/gun/energy/captain, /obj/item/stamp/captain, /obj/item/storage/backpack/captain, /obj/item/clothing/suit/armor/vest/security)),

					   "filth"   = typecacheof(list(/obj/effect/decal/cleanable,/obj/effect/decal/remains,/obj/item/trash, /obj/machinery/portable_atmospherics/hydroponics)),

					   "paranormals"   = typecacheof(list(/obj/item/book/tome,/obj/item/nullrod,/obj/structure/constructshell,
												/obj/structure/cult, /obj/structure/girder/cult, /obj/structure/grille/cult, /obj/effect/forcefield/cult,
												/obj/effect/gateway, /obj/item/clothing/head/culthood, /obj/item/clothing/head/helmet/space/cult, /obj/item/clothing/shoes/cult,
												/obj/item/clothing/suit/cultrobes, /obj/item/clothing/suit/space/cult, /obj/item/toy/cultsword, /obj/item/melee/cultblade,
												/obj/item/storage/backpack/cultpack, /obj/item/storage/bible, /obj/effect/rune, /obj/item/spirit_board)),

					   "doctors" = typecacheof(list(/obj/item/gun/launcher/syringe, /obj/item/reagent_containers/syringe, /obj/item/clothing/suit/storage/toggle/labcoat,
												 /obj/item/toy/figure/md, /obj/item/bedsheet/medical, /obj/item/rig/medical, /obj/item/storage/backpack/duffel/med,
												 /obj/item/storage/backpack/medic, /obj/item/storage/backpack/messenger/med, /obj/item/storage/belt/medical,
												 /obj/machinery/vending/medical, /obj/structure/closet/crate/medical, /obj/structure/closet/medical_wall,
												 /obj/structure/sign/greencross, /obj/item/clothing/accessory/armband/med, /obj/item/clothing/head/helmet/space/void/medical, /obj/item/clothing/mask/breath/medical,
												 /obj/item/clothing/under/rank/medical, /obj/item/surgery/scalpel, /obj/machinery/clonepod, /obj/item/storage/firstaid, /obj/machinery/optable,
												 /obj/item/clothing/accessory/armband/science, /obj/item/clothing/under/rank/scientist, /obj/machinery/door/airlock/science, /obj/machinery/door/airlock/medical))

					   )
	phobia_turfs = list("space" = typecacheof(list(/turf/space, /turf/simulated/open)),
						"paranormals" = typecacheof(list(/turf/simulated/wall/cult, /turf/simulated/floor/cult)),
						"filth" = typecacheof(list(/turf/simulated/floor/grass, /turf/simulated/mineral)),
						"darkness" = typecacheof(list(/turf/unsimulated/mask)) //fuck this is so dangerously snowflake lohikar is going to eat my ass
						)

	phobia_species = list("lizards"   = typecacheof(list(/datum/species/unathi)),
						  "cats" = typecacheof(list(/datum/species/tajaran)),
						  "skrell"   = typecacheof(list(/datum/species/skrell)),
						  "robots"   = typecacheof(list(/datum/species/machine)),
						  "pests"   = typecacheof(list(/datum/species/diona, /datum/species/bug, /datum/species/vox)),
						  "paranormals"   = typecacheof(list(/datum/species/shadow, /datum/species/skeleton, /datum/species/golem)),
						  "humans"   = typecacheof(list(/datum/species/human))
						 )

#undef PHOBIA_FILE
