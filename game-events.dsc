umc_game_events:
    type: world
    debug: true
    events:
	
#		on npc pathfinds:
#			- narrate format:umc "<npc.name> pathfind"  targets:<server.online_players> per_player
#			- run umc-npc2.infoinfo

#		on npc begins navigation:
#			- adjust <npc> speed:.9
#			- narrate format:umc "<npc.name> navigating"  targets:<server.online_players> per_player
#			- run umc-npc2.infoinfo
			
#		on npc cancels navigation:
#			- narrate format:umc "<npc.name> cancels"  targets:<server.online_players> per_player
#			- run umc-npc2.infoinfo
			
#		after npc stuck:
#			- narrate format:umc "<npc.name> stuck"  targets:<server.online_players> per_player
#			- run umc-npc2.infoinfo



        after server start:
		
        - run umc-mmob-load
			
		after player logs in:

			- wait 1s
		
			- if <player.flag[umc.active].equals[true]>:
				- narrate format:umc "Welcome Back <player.name>!"
				- run umc-task-unlock-screen			
				- wait 1s

#				- if <player.has_flag[umc.align]>:
#					- narrate format:umc "Alignment: <player.flag[umc.align]>"
#				- else:
#					- flag player umc.align: 0
#					- narrate format:umc "Alignment: <player.flag[umc.align]>"

				- stop

			- define lockloc <player.location>
			- define cpwd <player.flag[umc.login].if_null[null]>
			
			- if <[cpwd]> == null:
				- narrate format:umc "To register you account with us, type: /player register [yourpassword]"
			- else:
				- narrate format:umc "To verified you account, type: /player login [yourpassword]"
		
			- ~run umc-task-lock-screen			
			- run umc-task-gametitle
		
		on player first login:

			- define lockloc <player.location>
			- define cpwd <player.flag[umc.login].if_null[null]>

			- ~run umc-task-lock-screen			
		
			- if <[cpwd]> == null:

				- wait 1s
				- ~run umc-task-gametitle-long
			
			# initial
			
			- flag <player> money:0
			- flag <player> umc.align:0
			
			- wait 5s

			- adjust <player.location.world> monster_spawn_limit:<script[umc_config].data_key[monster_spawn_limit]>

		after player kills villager:
		
			- if <context.entity.entity_type> == villager:
				- flag player umc.align:--
			- else:
				- flag player umc.align:++

			- narrate format:umc "You kill: <context.entity> <context.entity.entity_type> <player.flag[umc.align]>"	
		

		after player kills monster:	
	
			- flag player umc.align:++
			- narrate format:umc "You kill: <context.entity> <context.entity.entity_type> <player.flag[umc.align]>"	

		after player kills animal:
		
			- if <context.entity.is_tamed>:
				- flag player umc.align:--

		#	- if <context.entity.tameable>:

			- narrate format:umc "You kill: <context.entity> <context.entity.entity_type> <player.flag[umc.align]>"	
