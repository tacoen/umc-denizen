

umc-advancement:
    type: task
    name: umc-advancement
	
	script:
	
	- advancement id:umc_alignment icon:sweet_berries "title:Alignment" "description:UMC Alignment"	
	- toast icon:poppy "Welcome <player.name>!"
	
	alignment-check:

#		- if <player.flag[umc.align].is_less_than[-10]> && !<player.flag[umc.sides].equals[semi-devils]>:
		- if <player.flag[umc.align].is_less_than[-10]>:
		
			- toast icon:wither_rose "<player.name> joining Semi-Devils"
			- flag player umc.sides:semi-devils
			
			- advancement id:semidevils_badge parent:umc_alignment icon:poppy "title:Semi Devils" "description:You fight for Semi-Devils."						
			
#		- else if <player.flag[umc.align].is_more_than[10]> && !<player.flag[umc.sides].equals[demi-gods]>:

		- else if <player.flag[umc.align].is_more_than[10]>:

			- toast icon:poppy "<player.name> joining Demi-gods"
			- flag player umc.sides:demi-gods


			- advancement id:demigods_badge parent:umc_alignment icon:poppy "title:Demi Gods" "description:You fight for Demi-gods."			