/*
 * Spawner for Antag Ian
 */

/obj/item/weapon/commanderjackbootbox //commanderjackboot
    name = "Commander Jackboot Deploy Point"
    desc = "A teleport pad for a JACKBOOT model corgi"
    icon = 'icons/obj/grenade.dmi'
    icon_state = "landmine"
/obj/item/weapon/commanderjackbootbox/attack_hand(var/obj/item/weapon/W as obj, var/mob/user as mob)
    new /mob/living/simple_animal/hostile/commanded/dog/commanderjackboot(src.loc)
    playsound(src.loc, 'sound/mecha/nominalsyndi.ogg', 100, 1)
    qdel(src)