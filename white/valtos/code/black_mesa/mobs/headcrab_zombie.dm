/mob/living/simple_animal/hostile/blackmesa/xen/headcrab_zombie
	name = "headcrab zombie"
	desc = "This unlucky person has had a headcrab latch onto their head. Ouch."
	icon = 'white/valtos/icons/black_mesa/mobs.dmi'
	icon_state = "zombie"
	icon_living = "zombie"
	maxHealth = 110
	health = 110
	icon_gib = null
	icon_dead = "zombie_dead"
	speak_chance = 1
	speak_emote = list("growls")
	speed = 1
	emote_taunt = list("growls", "snarls", "grumbles")
	taunt_chance = 100
	melee_damage_lower = 21
	melee_damage_upper = 21
	attack_sound = 'white/valtos/sounds/black_mesa/mobs/zombies/claw_strike.ogg'
	gold_core_spawnable = HOSTILE_SPAWN
	alert_cooldown_time = 8 SECONDS
	alert_sounds = list(
		'white/valtos/sounds/black_mesa/mobs/zombies/alert1.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/alert2.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/alert3.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/alert4.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/alert5.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/alert6.ogg',
	)

/mob/living/simple_animal/hostile/blackmesa/xen/headcrab_zombie/death(gibbed)
	new /obj/effect/gibspawner/human(get_turf(src))
	return ..()

/mob/living/simple_animal/hostile/blackmesa/xen/headcrab_zombie/scientist
	name = "zombified scientist"
	desc = "Even after death, I still have to wear this horrible tie!"
	icon_state = "scientist_zombie"
	icon_living = "scientist_zombie"


/mob/living/simple_animal/hostile/blackmesa/xen/headcrab_zombie/guard
	name = "zombified guard"
	desc = "About that brain I owed ya!"
	icon_state = "security_zombie"
	icon_living = "security_zombie"
	maxHealth = 140 // Armor!
	health = 140

/mob/living/simple_animal/hostile/blackmesa/xen/headcrab_zombie/hev
	name = "zombified hazardous environment specialist"
	desc = "User death... surpassed."
	icon_state = "hev_zombie"
	icon_living = "hev_zombie"
	maxHealth = 250
	health = 250
	alert_sounds = list(
		'white/valtos/sounds/black_mesa/mobs/zombies/hzv1.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/hzv2.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/hzv3.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/hzv4.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/hzv5.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/hzv6.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/hzv7.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/hzv8.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/hzv9.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/hzv10.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/hzv11.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/hzv12.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/hzv13.ogg',
		'white/valtos/sounds/black_mesa/mobs/zombies/hzv14.ogg',
	)




