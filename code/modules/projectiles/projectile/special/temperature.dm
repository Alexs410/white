/obj/projectile/temp
	name = "охлаждающий луч"
	icon_state = "ice_2"
	damage = 0
	damage_type = BURN
	nodamage = FALSE
	flag = ENERGY
	aim_mod = 1.25
	var/temperature = -50 // reduce the body temperature by 50 points

/obj/projectile/temp/on_hit(atom/target, blocked = 0)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/hit_mob = target
		var/thermal_protection = 1 - hit_mob.get_insulation_protection(hit_mob.bodytemperature + temperature)

		// The new body temperature is adjusted by the bullet's effect temperature
		// Reduce the amount of the effect temperature change based on the amount of insulation the mob is wearing
		hit_mob.adjust_bodytemperature((thermal_protection * temperature) + temperature)

	else if(isliving(target))
		var/mob/living/L = target
		// the new body temperature is adjusted by the bullet's effect temperature
		L.adjust_bodytemperature((1 - blocked) * temperature)

/obj/projectile/temp/hot
	name = "поджигающий луч"
	temperature = 100 // Raise the body temp by 100 points

/obj/projectile/temp/cryo
	name = "замораживающий луч"
	range = 3
	temperature = -240 // Single slow shot reduces temp greatly

/obj/projectile/temp/cryo/on_range()
	var/turf/T = get_turf(src)
	if(isopenturf(T))
		var/turf/open/O = T
		O.freon_gas_act()
	return ..()
