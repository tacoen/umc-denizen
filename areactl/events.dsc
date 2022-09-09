umc-area-events:
    type: world
    events:

		after player enters cuboid:

		- define nona <context.area.note_name>

		- if <server.has_flag[umc.area.<[nona]>.active]>:
			- run umc-area-event-task def.method:enter def.name:<[nona]>

		after player exits cuboid:

		- define nona <context.area.note_name>

		- if <server.has_flag[umc.area.<[nona]>.active]>:
			- run umc-area-event-task def.method:exit def.name:<[nona]>


umc-area-event-task:
	type: task
	script:

	- narrate "<[method]> - area:<[name]>"

	- choose <[method]>:

		- case enter:


			- if <server.flag[umc.area.<[name]>.prop.title].if_null[null]> != null:
				- inject umc-area-title

			- if <server.flag[umc.area.<[name]>.prop.midi].if_null[null]> != null:
				- inject umc-area-midi

			- if <server.flag[umc.area.<[name]>.prop.owner]> != <player.name>:

				- if <server.flag[umc.area.<[name]>.gamemode].if_null[null]> != null:
					- actionbar format:umc-title "Gamemode: <server.flag[umc.area.<[name]>.gamemode]>"
					- flag player umc.gamemode:<player.gamemode>
					- adjust <player> gamemode:<server.flag[umc.area.<[name]>.gamemode]>

			- else:

				- flag player umc.gamemode:<player.gamemode>
				- adjust <player> gamemode:creative
				- actionbar format:umc-title "Gamemode: Creative (Owner)"


			# mobs - populate - spawn

			- if <server.flag[umc.area.<[name]>.spawn.entities].if_null[null]> != null:

				- inject umc-area-spawn

			# task

			- if <server.flag[umc.area.<[name]>.task.in].if_null[null]> != null:
				- inject <server.flag[umc.area.<[name]>.task.in]>


		- case exit:

			- if <player.flag[umc.gamemode].if_null[null]> != null:
				- adjust <player> gamemode:<player.flag[umc.gamemode]>

			- if <server.flag[umc.area.<[name]>.task.out].if_null[null]> != null:
				- inject <server.flag[umc.area.<[name]>.task.out]>
				
			- midi cancel
			- flag player midi-play:!
			

cobaan:
	type: task
	script:

	- narrate format:umc "from cobaan task"
	- narrate format:umc "<[name]>"
