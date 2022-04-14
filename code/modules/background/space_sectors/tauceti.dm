/datum/space_sector/tau_ceti
	name = SECTOR_TAU_CETI
	description = "Tau Ceti is a system located in close proximity of Sol, and serves as the main base of operation for the megacorporation NanoTrasen. Tau Ceti is governed by the \
	Republic of Biesel, a young Republic that became independent of the economically troubled Sol Alliance in 2452 due to heavy pressure by Nanotrasen. There is still resentment in \
	the Sol Alliance over the loss of such a wealthy system, while Nanotrasen continues to have a heavy hand in all levels of Tau Ceti."
	cargo_price_coef = list("nt" = 0.8, "hpi" = 0.8, "zhu" = 0.8, "een" = 1, "get" = 0.8, "arz" = 1, "blm" = 1,
								"iac" = 1, "zsc" = 1, "vfc" = 1, "bis" = 0,8, "xmg" = 0.8, "npi" = 0.8)
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid)

/datum/space_sector/romanovich
	name = SECTOR_ROMANOVICH
	description = "The Romanovich Cloud is a shell of icy, rocky and metallic bodies that orbit very distant Tau Ceti, past even the Dust Belt. Rich in deposits of precious and \
	semi-precious metals as well as radioactive elements, the Romanovich Cloud is the source of nearly all the raw materials used within Tau Ceti. The cloud is also one of the few\
	sources of Phoron, a volatile but highly-sought after compound, known for its uses in the biomedical and energy industries. Most of the sources of Phoron within the Romanovich \
	Cloud are under control of NanoTrasen, which has consequently established many high-tech research facilities in the area in the past few years."
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/romanovich)

/datum/space_sector/corp_zone
	name = SECTOR_CORP_ZONE
	description = "Formerly Solarian space, the Corporate Reconstruction Zone is the name for all systems occupied by the Republic of Biesel that are not within Tau Ceti's gravity well. \
	The Zone, or the CRZ, is an area of instability and logistical chaos where once-Alliance colonies exist in relative peace compared to the adjacent Human Wildlands. This is owed to \
	two factors: the presence of the lingering Stellar Corporate Conglomerate, and the federal authority of the Republic of Biesel backing them up. Warlords and major antagonistic \
	factions (to Biesel) generally refrain from entering these territories to avoid the ire of the Conglomerate, much less the repercussions of engaging its allies."
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid)