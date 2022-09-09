
# use this as template

op-homebase:
    type: world
    events:

        after player enters homebase:
        - actionbar format:umc-title "<&l>Homebase"
		- cast NIGHT_VISION d:36000 amplifier:4 <player> no_icon hide_particles
		- adjust <player> affects_monster_spawning:false
		- flag player umc.spawn_limit:<player.location.world.monster_spawn_limit>
		- wait 5t
		- adjust <player.location.world> monster_spawn_limit:0

        after player exits homebase:
        - ratelimit <player> 10s
        - actionbar format:umc-title "<&l>Exiting Homebase"
		- adjust <player> affects_monster_spawning:true	
		- cast cancel NIGHT_VISION <player>
		- adjust <player.location.world> monster_spawn_limit:<player.flag[umc.spawn_limit]>
