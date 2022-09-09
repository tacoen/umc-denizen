vilman_wand:
	type: item
	material: arrow
	display name: villager wand
    enchantments:
    - vanishing_curse:1
    mechanisms:
#        hides: ENCHANTS
		unbreakable: true
    lore:
    - <&F>Right click to to manage.


be_farmer:
    type: item
    debug: false
    material: COMPOSTER
    display name: <&f>Exit


vilman_menu:
    type: inventory
    # Valid inventory types: ANVIL, BREWING, CHEST, DISPENSER, ENCHANTING, ENDER_CHEST, HOPPER, WORKBENCH
    inventory: CHEST
    title: Villager Job
    size: 27
    gui: true

	
	slots:
	- [COMPOSTER] [BARREL] [LOOM] [SMOKER] [BLAST_FURNACE] [CAULDRON] [SMITHING_TABLE] [STONECUTTER] [FLETCHING_TABLE]
	- [GRINDSTONE] [CARTOGRAPHY_TABLE] [BREWING_STAND] [LECTERN] [] [] [] [VILLAGER_SPAWN_EGG] [TURTLE_EGG]
	- [] [] [STONE] [IRON_BLOCK] [GOLD_BLOCK] [EMERALD_BLOCK] [DIAMOND_BLOCK] [] []


vilman_wand_world:
    type: world
    debug: false
	
    events:

#        on player clicks umcshop_sell_item in umc-shop-gui:
#		- run umc-shop-opentask def.shop:<player.flag[shop_id]> def.page:sell
#		- determine cancelled

#        on player clicks umcshop_buy_item in umc-shop-gui:
#		- run umc-shop-opentask def.shop:<player.flag[shop_id]> def.page:buy
#		- determine cancelled
	
		on player right clicks entity:
		
			- if <player.item_in_hand.contains[vilman_wand]>:
				
				- flag player vilmantarget:!
				
				- narrate <context.entity>
				- flag player vilmantarget:<context.entity>
				- inventory open d:<inventory[vilman_menu]>
			    - determine cancelled

			
		# after player right clicks block:
#				- narrate <context.location>
#				- define target <context.location.find_entities[villager].within[3]>
#				- narrate <[target]>
#				- define target <player.location.find_entities[villager].within[3]>
#				- narrate <[target]>

		on player clicks in vilman_menu:
		
			- define target <player.flag[vilmantarget]>

			- choose <context.slot>:
				- case 1:
					- adjust <[target]> profession:FARMER
				- case 2:
					- adjust <[target]> profession:FISHERMAN
				- case 3:
					- adjust <[target]> profession:Shepherd
				- case 4:
					- adjust <[target]> profession:Butcher
				- case 5:
					- adjust <[target]> profession:Armorer
				- case 6:
					- adjust <[target]> profession:Leatherworker				
				- case 7:
					- adjust <[target]> profession:Toolsmith
				- case 8:
					- adjust <[target]> profession:Mason
				- case 9:
					- adjust <[target]> profession:Fletcher	
				- case 10:
					- adjust <[target]> profession:Weaponsmith	
				- case 11:
					- adjust <[target]> profession:Cartographer	
				- case 12:
					- adjust <[target]> profession:Cleric
				- case 13:
					- adjust <[target]> profession:Librarian
			
			# 15 14
			
				- case 17:
					- adjust <[target]> profession:NITWIT
				- case 18:
					- adjust <[target]> profession:NONE
				
			# 19 20
			
				- case 21:
					- adjust <[target]> villager_level:1
				- case 22:
					- adjust <[target]> villager_level:2
				- case 23:
					- adjust <[target]> villager_level:3
				- case 24:
					- adjust <[target]> villager_level:4
				- case 25:
					- adjust <[target]> villager_level:5

			- narrate "<[target].profession> <[target].villager_level>"

			