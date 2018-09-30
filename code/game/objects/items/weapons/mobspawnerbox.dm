/*
 * Spawner for Antag Ian
 */

/obj/item/weapon/cyberdogdeployment // Cyberdog Deploy Point
    name = "Cyber Dog Deployment Pad"
    desc = "A teleport pad for a syndicate made cyber dog"
    icon = 'icons/obj/grenade.dmi'
    icon_state = "landmine"
/obj/item/weapon/cyberdogdeployment/attack_hand(var/obj/item/weapon/W as obj, var/mob/user as mob)
    new /mob/living/simple_animal/hostile/commanded/dog/cyberhound(src.loc)
    playsound(src.loc, 'sound/mecha/nominalsyndi.ogg', 100, 1)
    qdel(src)