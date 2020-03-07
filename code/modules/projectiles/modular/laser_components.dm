//Assemblies

/obj/item/device/laser_assembly/medium
	name = "laser assembly (medium)"
	base_icon_state = "medium"
	w_class = 3
	size = CHASSIS_MEDIUM
	modifier_cap = 4

/obj/item/device/laser_assembly/large
	name = "laser assembly (large)"
	base_icon_state = "large"
	w_class = 4
	size = CHASSIS_LARGE
	modifier_cap = 5

/obj/item/device/laser_assembly/admin
	name = "laser assembly (obscene)"
	base_icon_state = "large"
	w_class = 4
	size = CHASSIS_LARGE
	modifier_cap = 25

//Capacitors
/obj/item/laser_components/capacitor/potato
	name = "starch capacitor"
	desc = "A powercell composed of a primarily starch-based conductor."
	icon_state = "starch_capacitor"
	reliability = 30
	shots = 1
	damage = 5

/obj/item/laser_components/capacitor/reinforced
	name = "reinforced capacitor"
	desc = "A reinforced laser weapon capacitor."
	icon_state = "reinforced_capacitor"
	reliability = 80

/obj/item/laser_components/capacitor/nuclear
	name = "uranium-enriched capacitor"
	desc = "A capacitor built from uranium enriched materials."
	icon_state = "uranium_capacitor"
	damage = 20
	shots = 10
	reliability = 50

/obj/item/laser_components/capacitor/nuclear/small_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	for (var/mob/living/M in range(0,src)) //Only a minor failure, enjoy your radiation if you're in the same tile or carrying it
		if (M != user)
			to_chat(M, "<span class='warning'>You feel a warm sensation.</span>")
		M.apply_effect(rand(1,10)*(prototype.criticality+1), IRRADIATE)
	return

/obj/item/laser_components/capacitor/nuclear/medium_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	for (var/mob/living/M in range(round((prototype.criticality+1)),src)) //Only a minor failure, enjoy your radiation if you're in the same tile or carrying it
		if (M != user)
			to_chat(M, "<span class='warning'>You feel a warm sensation.</span>")
		M.apply_effect(rand(1,40)*(prototype.criticality+1), IRRADIATE)
	return

/obj/item/laser_components/capacitor/nuclear/critical_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	for (var/mob/living/M in range(rand(2,6)*(prototype.criticality+1),src))
		to_chat(M, "<span class='warning'>You feel a wave of heat wash over you.</span>")
		M.apply_effect(300*(prototype.criticality+1), IRRADIATE)
	..()

/obj/item/laser_components/capacitor/teranium
	name = "teranium-enriched capacitor"
	desc = "A capacitor built from teranium enriched materials."
	icon_state = "teranium_capacitor"
	damage = 25
	shots = 15
	reliability = 45

/obj/item/laser_components/capacitor/teranium/small_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	tesla_zap(prototype, 3, 1000*(prototype.criticality+1))
	return

/obj/item/laser_components/capacitor/teranium/medium_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	tesla_zap(prototype, round((prototype.criticality+1)*2), 2000*(prototype.criticality+1))
	return

/obj/item/laser_components/capacitor/teranium/critical_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	for (var/i = 0 to round((prototype.criticality+1)))
		tesla_zap(prototype, round((prototype.criticality+1)*2,1), 4000*(prototype.criticality+1))
	..()

/obj/item/laser_components/capacitor/phoron
	name = "phoron-enriched capacitor"
	desc = "A capacitor built from phoron enriched materials."
	icon_state = "phoron_capacitor"
	damage = 30
	shots = 25
	reliability = 40

/obj/item/laser_components/capacitor/phoron/small_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	for (var/mob/living/M in range(0,src)) //Only a minor failure, enjoy your radiation if you're in the same tile or carrying it
		if (M != user)
			to_chat(M, "<span class='warning'>You feel a warm sensation.</span>")
		M.apply_effect(rand(1,10)*(prototype.criticality+1), IRRADIATE)
	return

/obj/item/laser_components/capacitor/phoron/medium_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	empulse(get_turf(src), 0, round((prototype.criticality+1)*3,1))
	explosion(get_turf(prototype), 0, 0, round((prototype.criticality+1)*2,1))
	return

/obj/item/laser_components/capacitor/phoron/critical_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	empulse(get_turf(src), round((prototype.criticality+1),1), round((prototype.criticality+1)*4,1))
	explosion(get_turf(prototype), 0, round((prototype.criticality+1),1), round((prototype.criticality+1)*3,1))
	..()

/obj/item/laser_components/capacitor/bluespace
	name = "bluespace-enriched capacitor"
	desc = "A capacitor built from bluespace enriched materials."
	icon_state = "bluespace_capacitor"
	damage = 35
	shots = 30
	reliability = 30

/obj/item/laser_components/capacitor/bluespace/small_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	for (var/mob/living/M in range(round((prototype.criticality+1),1),src))
		empulse(get_turf(M), 0, round((prototype.criticality+1)*2,1))
	return

/obj/item/laser_components/capacitor/bluespace/medium_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	for (var/mob/living/M in range(round(3*(prototype.criticality+1),1),src))
		empulse(get_turf(M), 0, round((prototype.criticality+1)*2,1))
		do_teleport(M, get_turf(M), rand(1,3)*round((prototype.criticality+1),1), asoundin = 'sound/effects/phasein.ogg')
	return

/obj/item/laser_components/capacitor/bluespace/critical_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	for (var/mob/living/M in range(round(6*(prototype.criticality+1),1),src))
		empulse(get_turf(M), 0, round((prototype.criticality+1)*4,1))
		do_teleport(M, get_turf(M), rand(6,18)*round((prototype.criticality+1),1), asoundin = 'sound/effects/phasein.ogg')
	..()

//Lenses
/obj/item/laser_components/focusing_lens/shotgun
	name = "splitter lens"
	desc = "A focusing lens that splits the beam into several sub-beams."
	icon_state = "splitter_lens"
	dispersion = list(1,-1,2,-2,3,-3,4,-4,5,-5,6,-6,7,-7,8,-8,9,-9,10,-10,11,-11,12,-12,13,-13,14,-14,15,-15)
	burst = 4
	accuracy = -1
	reliability = 35

/obj/item/laser_components/focusing_lens/sniper
	name = "precise lens"
	desc = "A focusing lens that is made of refined crystal, providing enhanced clarity and precision."
	icon_state = "precise_lens"
	accuracy = 2
	reliability = 30
	dispersion = list(0)

/obj/item/laser_components/focusing_lens/strong
	name = "reinforced lens"
	desc = "A focusing lens that is reinforced with stronger material."
	icon_state = "reinforced_lens"
	reliability = 60

//Modifiers

/obj/item/laser_components/modifier/silencer
	name = "energy suppressor"
	desc = "A sophisticated audio dampener that negates much of the sound produced by an energy weapon."
	mod_type = MOD_SILENCE
	icon_state = "energy_silencer"

/obj/item/laser_components/modifier/aeg
	name = "miniaturized reactor"
	desc = "An internal nuclear reactor which recharges the energy cell of the weapon. Feels tingly."
	icon_state = "mini_reactor"
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
	icon_state = "surge_protector"

/obj/item/laser_components/modifier/repeater
	name = "pulser"
	desc = "A modification to the energy cell that permits rudimentary burst fire."
	base_malus = 0.5 //when modifiers get damaged they do not break, but make other components break faster
	malus = 0.5 //subtracted from weapon's overall reliability everytime it's fired
	burst_delay = 1
	burst = 3
	fire_delay = 3
	accuracy = -1
	icon_state = "pulser"

/obj/item/laser_components/modifier/auxiliarycap
	name = "auxiliary capacitor"
	desc = "A string of sub-capacitors along the central cell provide additional bang for your buck."
	base_malus = 3
	malus = 3
	reliability = -10
	shots = 2
	damage = 1.5
	criticality = 1.25
	icon_state = "aux_capacitor"

/obj/item/laser_components/modifier/overcharge
	name = "capacitor overcharge"
	desc = "A bypass to the internal cell's limiter, producing an explosive result."
	base_malus = 5
	malus = 5
	reliability = -25
	shots = 0.5
	damage = 2.5
	criticality = 2
	icon_state = "capacitor_overcharge"

/obj/item/laser_components/modifier/gatling
	name = "gatling rotator"
	desc = "A modification to the lens that permits rapid-fire for extended durations."
	base_malus = 0.5
	malus = 0.5
	burst_delay = 1
	burst = 10
	fire_delay = 10
	chargetime = 3
	accuracy = -3
	icon_state = "rotating_lens"

/obj/item/laser_components/modifier/scope
	name = "telescopic sight"
	desc = "A modification that adds a zoom function to the prototype."
	scope_name = "proto-scope"
	gun_overlay = "scope"
	icon_state = "telescopic_sight"

/obj/item/laser_components/modifier/barrel
	name = "reinforced barrel"
	desc = "Reinforcement along the barrel extends the longevity of the prototype."
	reliability = 25
	base_malus = 0
	malus = 0
	icon_state = "reinforced_barrel"

/obj/item/laser_components/modifier/vents
	name = "exhaust venting"
	desc = "More efficient exhaust venting reduces the impact of firing the prototype."
	reliability = 0
	base_malus = -5
	malus = -5
	icon_state = "vents"

/obj/item/laser_components/modifier/grip
	name = "enhanced grip"
	desc = "A modification that improves the fire delay of the prototype."
	fire_delay = 0.5
	gun_overlay = "grip"
	icon_state = "enhanced_grip"

/obj/item/laser_components/modifier/stock
	name = "improved stock"
	desc = "A modification that improves the accuracy."
	fire_delay = 0.5
	accuracy = 1
	gun_overlay = "stock"
	icon_state = "improved_stock"

/obj/item/laser_components/modifier/bayonet
	name = "bayonet"
	desc = "A modification that adds a big knife to your gun. Science."
	gun_force = 10
	gun_overlay = "bayonet"
	icon_state = "bayonet_item"

/obj/item/laser_components/modifier/ebayonet
	name = "energy bayonet"
	desc = "A modification that adds a hardlight knife to your gun. Science!"
	gun_force = 25
	gun_overlay = "ebayonet"
	icon_state = "ebayonet_item"

//Projectile modulators

/obj/item/laser_components/modulator/taser
	name = "TASER modulator"
	desc = "A modification that modulates the beam into a nonlethal electrical arc."
	damage = 0
	projectile = /obj/item/projectile/beam/stun
	icon_state = "taser"
	firing_sound = 'sound/weapons/Taser.ogg'

/obj/item/laser_components/modulator/tesla
	name = "tesla modulator"
	desc = "A modification that modulates the beam into a lethal electrical arc."
	projectile = /obj/item/projectile/energy/tesla
	icon_state = "tesla"
	firing_sound = 'sound/magic/LightningShock.ogg'

/obj/item/laser_components/modulator/pulse
	name = "pulse modulator"
	desc = "Amplifies the laser beam into a highly lethal pulse beam."
	projectile = /obj/item/projectile/beam/pulse
	damage = 1.5
	icon_state = "pulse"
	firing_sound = 'sound/weapons/pulse.ogg'

/obj/item/laser_components/modulator/xray
	name = "xray modulator"
	desc = "Modulates the beam into a concentrated x-ray blast."
	projectile = /obj/item/projectile/beam/xray
	icon_state = "xray"
	firing_sound = 'sound/weapons/laser3.ogg'

/obj/item/laser_components/modulator/ion
	name = "ion cannon"
	desc = "Modulates the prototype to fire disparate ion projectiles."
	projectile = /obj/item/projectile/ion
	icon_state = "ion"
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 3)

/obj/item/laser_components/modulator/floramut
	name = "floral somatomodulator"
	desc = "Modulates the beam into firing controlled radiation which induces mutation in plant cells."
	projectile = /obj/item/projectile/energy/floramut
	icon_state = "somatoray"
	firing_sound = 'sound/effects/stealthoff.ogg'

/obj/item/laser_components/modulator/floramut2
	name = "betaray modulator"
	desc = "Modulates the beam into firing controlled radiation which induces enhanced reproduction in plant cells."
	projectile = /obj/item/projectile/energy/florayield
	icon_state = "betaray"
	firing_sound = 'sound/effects/stealthoff.ogg'

/obj/item/laser_components/modulator/arodentia
	name = "arodentia modulator"
	desc = "Modulates the beam into firing precise electrical arcs designed for pest control."
	projectile = /obj/item/projectile/beam/mousegun
	damage = 0
	icon_state = "pesker"
	firing_sound = 'sound/weapons/taser2.ogg'

/obj/item/laser_components/modulator/red
	name = "red team modulator"
	desc = "Modulates the beam into firing red team tagger beams."
	projectile = /obj/item/projectile/beam/lastertag/red
	damage = 0
	icon_state = "red"

/obj/item/laser_components/modulator/blue
	name = "blue team modulator"
	desc = "Modulates the beam into firing blue team tagger beams."
	projectile = /obj/item/projectile/beam/lastertag/blue
	damage = 0
	icon_state = "blue"

/obj/item/laser_components/modulator/omni
	name = "omni team modulator"
	desc = "Modulates the beam into firing omni team tagger beams."
	projectile = /obj/item/projectile/beam/lastertag/omni
	damage = 0
	icon_state = "omni"

/obj/item/laser_components/modulator/practice
	name = "practice beam modulator"
	desc = "Modulates the beam into firing nonlethal practice beams."
	projectile = /obj/item/projectile/beam/practice
	damage = 0
	icon_state = "practice"

/obj/item/laser_components/modulator/mindflayer
	name = "mind flayer modulator"
	desc = "Modulates the beam into firing \"mind flayer\" beams."
	projectile = /obj/item/projectile/beam/mindflayer
	damage = 0.5
	icon_state = "flayer"

/obj/item/laser_components/modulator/decloner
	name = "decloner modulator"
	desc = "Modulates the beam into firing highly radioactive particulates."
	projectile = /obj/item/projectile/energy/declone
	damage = 0.5
	icon_state = "decloner"
	firing_sound = 'sound/weapons/pulse3.ogg'
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4, TECH_POWER = 3)

/obj/item/laser_components/modulator/ebow
	name = "dart modulator"
	desc = "Modulates the beam into firing minute energy darts."
	projectile = /obj/item/projectile/energy/dart
	damage = 0.25
	icon_state = "dart"
	firing_sound = 'sound/weapons/Genhit.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 3)

/obj/item/laser_components/modulator/blaster
	name = "blaster-bolt modulator"
	desc = "Modulates the beam into firing disparate energy bolts."
	projectile = /obj/item/projectile/energy/blaster/incendiary
	icon_state = "lensatic"
	origin_tech = list(TECH_COMBAT = 2, TECH_PHORON = 4)

/obj/item/laser_components/modulator/bfg
	name = "bioforce modulator"
	desc = "Modulates the beam into firing big green balls of death."
	projectile = /obj/item/projectile/energy/bfg
	damage = 2
	icon_state = "bfg"
	firing_sound = 'sound/magic/LightningShock.ogg'

/obj/item/laser_components/modulator/tox
	name = "phoron bolt modulator"
	desc = "Modulates the beam into firing toxic phoron bolts."
	projectile = /obj/item/projectile/energy/phoron
	icon_state = "tox"
	firing_sound = 'sound/effects/stealthoff.ogg'
	origin_tech = list(TECH_COMBAT = 4, TECH_PHORON = 4)

/obj/item/laser_components/modulator/net
	name = "energy net modulator"
	desc = "Modulates the beam into firing an energy net."
	projectile = /obj/item/projectile/beam/energy_net
	icon_state = "xray"
	firing_sound = 'sound/weapons/plasma_cutter.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_PHORON = 4, TECH_ILLEGAL = 4)