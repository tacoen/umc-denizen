
umc-shopkeeper:
    type: assignment
    debug: false

	interact scripts:
	- umc-shopkeeper-interact
		
	actions:

        on assignment:
        
		- trigger name:proximity toggle:true radius:4 cooldown:5
		- adjust <npc> lookclose:false
		- run umc-npc path:load_skin def.name:<npc.name>
        - playsound <player.location> sound:BLOCK_AMETHYST_CLUSTER_PLACE pitch:0.3 volume:1
        - trigger name:click state:true
        
		on enter proximity:

		- adjust <npc> lookclose:true
		
		- if <player.has_flag[meet.<npc.name>]>:

			- ~run umc-npc.anim-greet def.topic:<proc[umc-time-period]> delay:5t
			- narrate format:ntk "<&l>Right click<&r> me to shop."

			
		- else:
			- run umc-npc.say def.topic:intro
			- wait 5t
			- run umc-npc.say def.topic:feed def.format:ptk
			- flag <player> meet.<npc.name>:true

        on exit proximity:
		
		- adjust <npc> lookclose:false
		- run umc-npc.anim-greet def.topic:bye delay:5t
		- look <npc> <npc.location.backward_flat[1]>


	
	
umc-shopkeeper-interact:

    type: interact
    steps:
        waiting*:

            click trigger:
                script:
				- if <npc.flag[shop_id].if_null[null] != null:
					- ~run umc-shop-opentask def.shop:<npc.flag[flag.shop_id]> def.page:buy
				- else:
					- narrate format:umc-err "shop_id?"
					
				