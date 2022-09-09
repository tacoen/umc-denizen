umc-area-midi:
    type: task
    debug: false
	script:
		- if <player.flag[midi-play]>:
			- midi cancel
			- flag player midi-play:!

		- wait 1s

		- midi file:<server.flag[umc.area.<[name]>.prop.midi]> volume:0.7 <player.location>
		- flag player midi-play:true


umc-area-title:
    type: task
    debug: false
	script:

		- if <server.flag[umc.area.<[name]>.prop.owner].if_null[null]> != null:
			- define subtitle "Owner: <server.flag[umc.area.<[name]>.prop.owner]>"
		- else:
			- define subtitle "Price: <server.flag[umc.area.<[name]>.prop.price]>"

		- title "title:<server.flag[umc.area.<[name]>.prop.title]>" "subtitle:<[subtitle]>" fade_in:2s stay:3s fade_out:1s


umc-mmob-load:
    type: task
    debug: false
	script:
		- yaml create id:umc-mm
		- yaml id:umc-mm load:../MythicMobs/Mobs/umc.yml
		- define mmc <list[]>
		- define mmp <list[]>
		- flag server umc.mmob:!

		- foreach <yaml[umc-mm].list_keys[]> as:m:
			- define ke <[m].split[-]>
			- define r "<[ke].get[1]>-<[ke].get[2]>"

			- define mmp <[mmp].include[<[ke].get[2]>]>
			- define mmc <[mmc].include[<[ke].get[1]>]>

			- flag server umc.mmob.<[ke].get[1]>:->:<[m]>


		#- flag server umc.mmob.prof:<[mmp].deduplicate.alphabetical>
		- flag server umc.mmob.color:<[mmc].deduplicate.alphabetical>

		- narrate <server.flag[umc.mmob]>

umc-task-lock-screen:
    type: task
	script:
		- define loc <player.location>
		- define waitd <script[umc_config].data_key[login_time].if_null[360s]>
		- wait 1s
		- cast blindness hide_particles no_icon amplifier:10 duration:<[waitd]>
		- cast INVISIBILITY hide_particles no_icon amplifier:10 duration:<[waitd]>
		- look <player> <player.cursor_on> duration:<[waitd]>
		- adjust server idle_timeout:<[waitd]>
		- teleport <player> <[loc]>
		- flag player umc.active:!

umc-task-unlock-screen:
    type: task
	script:
		- flag player umc.active:true expire:2h
		- cast blindness remove
		- cast INVISIBILITY remove
		- look <player> <player.cursor_on>
        - teleport <player> <player.location>

umc-task-gametitle:
	type: task
	script:

	- title "subtitle:<script[umc_config].data_key[title]>" fade_in:1s stay:2s fade_out:2s
	- wait 5s

umc-task-gametitle-long:
	type: task
	script:
	- title "title:块边距" subtitle:<script[umc_config].data_key[title]>"  fade_in:1s stay:3s fade_out:1s
	- wait 5s
	- title "subtitle:<script[umc_config].data_key[subtitle]>"  fade_in:1s stay:3s fade_out:1s
	- wait 5s
	- title "title:<&e><&l><script[umc_config].data_key[title]>" fade_out:3s stay:5s fade_in:1s
	- wait 10s
	- title "sub" fade_in:1s stay:3s fade_out:1s
	- wait 5s
	- title "subtitle:ブロックマージン" fade_in:1s stay:3s fade_out:1s
	- wait 5s
	- actionbar "lead: tacoen" format:umc-title

umc-task-reset:
	type: task
	script:
		- adjust <player.location.world> monster_spawn_limit:<script[umc_config].data_key[monster_spawn_limit]>
		- narrate "monster_spawn_limit = <player.location.world.monster_spawn_limit>"
