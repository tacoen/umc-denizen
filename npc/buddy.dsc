umc-buddy:
    type: assignment
    debug: false

	interact scripts:
	- umc-buddy-interact
	
	actions:

        on assignment:
        
		- trigger name:proximity toggle:true radius:4 cooldown:5

		- adjust <npc> lookclose:true
		#- adjust <npc> is_aware:true

		- adjust <npc> use_new_finder:false
		- adjust <npc> has_ai:true
			
		- adjust <npc> speed:1

		- adjust <npc> range:50
		- adjust <npc> distance_margin:0.5
		- adjust <npc> path_distance_margin:0

		- run umc-npc2.load_skin def.name:<npc.name>
        - playsound <player.location> sound:BLOCK_AMETHYST_CLUSTER_PLACE pitch:0.3 volume:1
        - trigger name:click state:true	

		on enter proximity:

		- define slot <proc[umc-time-period]>
		
		- if <npc.is_sleeping> && <player.location.world.time> < 15000:
			- inject umc-npc-task.wakeup
			- stop

		- if <npc.is_sitting>:
			- stand
		
		- if <player.has_flag[meet.<npc.name>]>:

			- if !<npc.is_sleeping>:
				- adjust <npc> lookclose:true
				- ~run umc-npc-task path:say def.slot:<proc[umc-time-period]>

		- else:
			- run umc-npc-task.say def.slot:intro
			- ~animate <npc> animation:ARM_SWING
			- wait 5t
			- run umc-npc-task.say def.slot:feed def.format:ptk
			- flag <player> meet.<npc.name>:true
			- wait 5t
			- random:
				- narrate format:ntk "Nice to meet you, <player.name.to_titlecase>!"
				- narrate format:ntk "<player.name.to_titlecase>? I'm Glad to see you here."
				- narrate format:ntk "Well <player.name.to_titlecase>, Have a nice block!"
				- narrate format:ntk "<player.name.to_titlecase>? Nice name."
			- wait 5t
			- ~run umc-npc-task path:say def.slot:<proc[umc-time-period]>
			

        on exit proximity:

			- define slot <proc[umc-time-period]>

			- adjust <npc> speed:1
			
			- if !<npc.is_sleeping>:
				- follow stop
				- ~run umc-npc-task.say def.slot:bye
				- adjust <npc> lookclose:false
				- ~inject umc-npc-task path:<proc[umc-time-period]> 

			- wait 2s

			- if <npc.flag[task.<[slot]>].if_null[null]> != null:
				- inject <npc.flag[task.<[slot]>]>
				- wait 2t
		
umc-buddy-interact:

    type: interact
    steps:
	  1:
		click trigger:
			script:
			- narrate "hi <player.name>"
	
		chat trigger:
			1:
				trigger: /keyword/ othertext
				script:
				- wait 1
				- chat "<context.message> eh?"
			2:
				trigger: /hi|hello|hey/
				script:
				- wait 1
				- chat "<context.keyword> there buddy!"
			3:
				trigger: /regex:\d+/
				script:
				- wait 1
				- chat "<context.keyword> eh?"
			
			5:
				trigger: /*/
				script:
				
				- if <context.message> == <npc.name>:
					- narrate format:ntk "Yes? thats me."
				- else:
					- narrate format:ptk "<context.message>"
					- narrate format:ptk "<context.keyword>"
					- wait 1
					- narrate format:ntk "I dunno..."
					- narrate format:ntk "Why not type 'keyword' or any number!"

testmusic:
	type: task
	script:
	
	- playsound <player> sound:MUSIC_DISC_MALL