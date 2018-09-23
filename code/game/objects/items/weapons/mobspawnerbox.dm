/*
 * Spawner for Antag Ian
 */

/obj/item/weapon/shadyianbox //gang ian spawner
    name = "Shady Package"
    desc = "A large box that seems to keep yapping and stuff"
    icon = 'icons/obj/items.dmi'
    icon_state = "gift3"
/obj/item/weapon/shadyianbox/attack_hand(var/obj/item/weapon/W as obj, var/mob/user as mob)
    new /mob/living/simple_animal/hostile/commanded/dog/shadyian(src.loc)
    qdel(src)