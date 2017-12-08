//Assemblies

/obj/item/device/laser_assembly/medium
	name = "laser assembly (medium)"
	w_class = 3
	size = CHASSIS_MEDIUM
	modifier_cap = 2

/obj/item/device/laser_assembly/large
	name = "laser assembly (large)"
	w_class = 4
	size = CHASSIS_LARGE
	modifier_cap = 3

/obj/item/device/laser_assembly/admin
	name = "laser assembly (obscene)"
	w_class = 4
	size = CHASSIS_LARGE
	modifier_cap = 25

//Capacitors
/obj/item/laser_components/capacitor/potato
	name = "starch capacitor"
	desc = "A powercell composed of a primarily starch-based conductor."
	reliability = 5
	shots = 1
	damage = 5

/obj/item/laser_components/capacitor/reinforced
	name = "reinforced capacitor"
	desc = "A reinforced laser weapon capacitor."
	icon_state = "laser" // sprite
	item_state = "laser" // sprite
	reliability = 75

/obj/item/laser_components/capacitor/nuclear
	name = "uranium-enriched capacitor"
	desc = "A capacitor built from uranium enriched materials."
	damage = 20
	shots = 10
	reliability = 40

/obj/item/laser_components/capacitor/nuclear/small_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	for (var/mob/living/M in range(0,src)) //Only a minor failure, enjoy your radiation if you're in the same tile or carrying it
		if (src in M.contents)
			M << "<span class='warning'>Your gun feels pleasantly warm for a moment.</span>"
		else
			M << "<span class='warning'>You feel a warm sensation.</span>"
		M.apply_effect(rand(1,10)*prototype.criticality, IRRADIATE)
	return

/obj/item/laser_components/capacitor/nuclear/medium_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	for (var/mob/living/M in range(round(prototype.criticality),src)) //Only a minor failure, enjoy your radiation if you're in the same tile or carrying it
		if (src in M.contents)
			M << "<span class='warning'>Your gun feels pleasantly warm for a moment.</span>"
		else
			M << "<span class='warning'>You feel a warm sensation.</span>"
		M.apply_effect(rand(1,40)*prototype.criticality, IRRADIATE)
	return

/obj/item/laser_components/capacitor/nuclear/critical_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	for (var/mob/living/M in range(rand(2,6)*prototype.criticality,src))
		if (src in M.contents)
			M << "<span class='danger'>Your gun's reactor overloads!</span>"
		M << "<span class='warning'>You feel a wave of heat wash over you.</span>"
		M.apply_effect(300*prototype.criticality, IRRADIATE)
	return

/obj/item/laser_components/capacitor/teranium
	name = "teranium-enriched capacitor"
	desc = "A capacitor built from teranium enriched materials."
	damage = 25
	shots = 15
	reliability = 40

/obj/item/laser_components/capacitor/teranium/small_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	tesla_zap(src, 3, 1000*prototype.criticality)
	return

/obj/item/laser_components/capacitor/teranium/medium_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	tesla_zap(pick(src), round(prototype.criticality*2), 2000*prototype.criticality)
	return

/obj/item/laser_components/capacitor/teranium/critical_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	for (var/i = 0 to round(prototype.criticality))
		tesla_zap(pick(src), round(prototype.criticality*2,1), 4000*prototype.criticality)
	return

/obj/item/laser_components/capacitor/phoron
	name = "phoron-enriched capacitor"
	desc = "A capacitor built from phoron enriched materials."
	damage = 30
	shots = 25
	reliability = 30

/obj/item/laser_components/capacitor/phoron/small_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	empulse(get_turf(src), 0, round(prototype.criticality*2,1))
	return

/obj/item/laser_components/capacitor/phoron/medium_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	empulse(get_turf(src), 0, round(prototype.criticality*3,1))
	explosion(get_turf(src), 0, 0, round(prototype.criticality*2,1))
	return

/obj/item/laser_components/capacitor/phoron/critical_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	empulse(get_turf(src), round(prototype.criticality,1), round(prototype.criticality*4,1))
	explosion(get_turf(src), 0, round(prototype.criticality,1), round(prototype.criticality*3,1))
	return

/obj/item/laser_components/capacitor/bluespace
	name = "bluespace-enriched capacitor"
	desc = "A capacitor built from bluespace enriched materials."
	damage = 35
	shots = 30
	reliability = 30

/obj/item/laser_components/capacitor/bluespace/small_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	for (var/mob/living/M in range(round(prototype.criticality,1),src))
		empulse(get_turf(M), 0, round(prototype.criticality*2,1))
	return

/obj/item/laser_components/capacitor/bluespace/medium_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	for (var/mob/living/M in range(round(3*prototype.criticality,1),src))
		empulse(get_turf(M), 0, round(prototype.criticality*2,1))
		do_teleport(M, get_turf(M), rand(1,3)*round(prototype.criticality,1), asoundin = 'sound/effects/phasein.ogg')
	return

/obj/item/laser_components/capacitor/bluespace/critical_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	for (var/mob/living/M in range(round(6*prototype.criticality,1),src))
		empulse(get_turf(M), 0, round(prototype.criticality*4,1))
		do_teleport(M, get_turf(M), rand(6,18)*round(prototype.criticality,1), asoundin = 'sound/effects/phasein.ogg')
	return

//Lenses
/obj/item/laser_components/focusing_lens/shotgun
	name = "splitter lens"
	desc = "A focusing lens that splits the beam into several sub-beams."
	dispersion = list(1.0, -1.0, 2.0, -2.0)
	burst = 4
	accuracy = -1
	reliability = 30

/obj/item/laser_components/focusing_lens/sniper
	name = "precise lens"
	desc = "A focusing lens that is made of refined crystal, providing enhanced clarity and precision."
	accuracy = 2
	reliability = 20

/obj/item/laser_components/focusing_lens/strong
	name = "reinforced lens"
	desc = "A focusing lens that is reinforced with stronger material."
	reliability = 50

//Modifiers

/obj/item/laser_components/modifier/silencer
	name = "energy silencer"
	desc = "A sophisticated audio dampener that negates much of the sound produced by an energy weapon."
	mod_type = MOD_SILENCE

/obj/item/laser_components/modifier/aeg
	name = "miniaturized reactor"
	desc = "An internal nuclear reactor which recharges the energy cell of the weapon. Feels tingly."
	mod_type = MOD_NUCLEAR_CHARGE
	reliability = -10
	criticality = 1.5

/obj/item/laser_components/modifier/surge
	name = "surge protector"
	desc = "A surge protector along the cell minimizes capacitor failure."
	reliability = 0
	base_malus = 0 //when modifiers get damaged they do not break, but make other components break faster
	malus = 0 //subtracted from weapon's overall reliability everytime it's fired
	criticality = 0.5

/obj/item/laser_components/modifier/repeater
	name = "pulser"
	desc = "A modification to the energy cell that permits rudimentary burst fire."
	base_malus = 0.5 //when modifiers get damaged they do not break, but make other components break faster
	malus = 0.5 //subtracted from weapon's overall reliability everytime it's fired
	burst_delay = 1
	burst = 3
	fire_delay = 3
	accuracy = -1

/obj/item/laser_components/modifier/auxiliarycap
	name = "auxiliary capacitor"
	desc = "A string of sub-capacitors along the central cell provide additional bang for your buck."
	base_malus = 3
	malus = 3
	reliability = -10
	shots = 2
	damage = 1.5
	criticality = 1.25

/obj/item/laser_components/modifier/overcharge
	name = "capacitor overcharge"
	desc = "A bypass to the internal cell's limiter, producing an explosive result."
	base_malus = 5
	malus = 5
	reliability = -25
	shots = 0.5
	damage = 2.5
	criticality = 2

/obj/item/laser_components/modifier/gatling
	name = "rotating lens"
	desc = "A modification to the lens that permits rapid-fire for extended durations."
	base_malus = 0.5
	malus = 0.5
	burst_delay = 1
	burst = 10
	fire_delay = 10
	chargetime = 3
	accuracy = -3

/obj/item/laser_components/modifier/scope
	name = "telescopic sight"
	desc = "A modification that adds a zoom function to the prototype."
	scope_name = "proto-scope"

/obj/item/laser_components/modifier/barrel
	name = "reinforced barrel"
	desc = "Reinforcement along the barrel extends the longevity of the prototype."
	reliability = 25
	base_malus = 0
	malus = 0

/obj/item/laser_components/modifier/vents
	name = "exhaust venting"
	desc = "More efficient exhaust venting reduces the impact of firing the prototype."
	reliability = 0
	base_malus = -5
	malus = -5

/obj/item/laser_components/modifier/grip
	name = "enhanced grip"
	desc = "A modification that improves the fire delay of the prototype."
	fire_delay = 0.5

/obj/item/laser_components/modifier/stock
	name = "improved stock"
	desc = "A modification that improves the accuracy."
	fire_delay = 0.5
	accuracy = 1

/obj/item/laser_components/modifier/bayonet
	name = "bayonet"
	desc = "A modification that adds a big knife to your gun. Science."
	gun_force = 10

/obj/item/laser_components/modifier/ebayonet
	name = "energy bayonet"
	desc = "A modification that adds a hardlight knife to your gun. Science!"
	gun_force = 25

/obj/item/laser_components/modifier/taser
	name = "TASER modulator"
	desc = "A modification that modulates the beam into a nonlethal electrical arc."
	damage = 0
	projectile = /obj/item/projectile/beam/stun

/obj/item/laser_components/modifier/tesla
	name = "tesla modulator"
	desc = "A modification that modulates the beam into a lethal electrical arc."
	projectile = /obj/item/projectile/energy/tesla

/obj/item/laser_components/modifier/pulse
	name = "pulse modulator"
	desc = "Amplifies the laser beam into a highly lethal pulse beam."
	projectile = /obj/item/projectile/beam/pulse
	damage = 1.25

/obj/item/laser_components/modifier/xray
	name = "xray modulator"
	desc = "Modulates the beam into a concentrated x-ray blast."
	projectile = /obj/item/projectile/beam/sniper

/obj/item/laser_components/modifier/ion
	name = "ion cannon"
	desc = "Modulates the prototype to fire disparate ion projectiles."
	projectile = /obj/item/projectile/ion

/obj/item/laser_components/modifier/floramut
	name = "floral somatomodulator"
	desc = "Modulates the beam into firing controlled radiation which induces mutation in plant cells."
	projectile = /obj/item/projectile/energy/floramut

/obj/item/laser_components/modifier/floramut
	name = "betaray modulator"
	desc = "Modulates the beam into firing controlled radiation which induces enhanced reproduction in plant cells."
	projectile = /obj/item/projectile/energy/florayield

/obj/item/laser_components/modifier/arodentia
	name = "arodentia modulator"
	desc = "Modulates the beam into firing precise electrical arcs designed for pest control."
	projectile = /obj/item/projectile/beam/mousegun
	damage = 0

/obj/item/laser_components/modifier/red
	name = "red team modulator"
	desc = "Modulates the beam into firing red team tagger beams."
	projectile = /obj/item/projectile/beam/lastertag/red
	damage = 0

/obj/item/laser_components/modifier/blue
	name = "blue team modulator"
	desc = "Modulates the beam into firing blue team tagger beams."
	projectile = /obj/item/projectile/beam/lastertag/blue
	damage = 0

/obj/item/laser_components/modifier/omni
	name = "omni team modulator"
	desc = "Modulates the beam into firing omni team tagger beams."
	projectile = /obj/item/projectile/beam/lastertag/omni
	damage = 0

/obj/item/laser_components/modifier/practice
	name = "practice"
	desc = "Modulates the beam into firing nonlethal practice beams."
	projectile = /obj/item/projectile/beam/practice
	damage = 0

/obj/item/laser_components/modifier/mindflayer
	name = "mind flayer modulator"
	desc = "Modulates the beam into firing \"mind flayer\" beams."
	projectile = /obj/item/projectile/beam/mindflayer
	damage = 0.5

/obj/item/laser_components/modifier/decloner
	name = "decloner modulator"
	desc = "Modulates the beam into firing highly radioactive particulates."
	projectile = /obj/item/projectile/energy/declone
	damage = 0.5

/obj/item/laser_components/modifier/ebow
	name = "dart modulator"
	desc = "Modulates the beam into firing minute energy darts."
	projectile = /obj/item/projectile/energy/dart
	damage = 0.25

/obj/item/laser_components/modifier/blaster
	name = "lensatic modulator"
	desc = "Modulates the beam into firing disparate energy bolts."
	projectile = /obj/item/projectile/energy/blaster

/obj/item/laser_components/modifier/bfg
	name = "bioforce modulator"
	desc = "Modulates the beam into firing big green balls of death."
	projectile = /obj/item/projectile/energy/bfg
	damage = 2