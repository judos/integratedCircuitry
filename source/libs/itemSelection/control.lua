local mainMaxRows = 5
local mainMaxEntries = 30
local maxRecentEntries = 20

--------------------------------------------------
-- API
--------------------------------------------------

-- call this to open the item selection gui
-- @param player: Object of the player opening the gui
-- @param types: array of things to show {GROUP_ITEM, GROUP_FLUID, GROUP_SIGNAL}
-- @param callback: Passed function used as callback when action is taken
--		accept a table with: {group=$,name=$,prototype=$}
-- itemSelection_open(player, types, callback)

-- Call this to migrate when updating the library to 2.9
-- itemSelection_migration_2_9()

--------------------------------------------------
-- Global data
--------------------------------------------------

-- This helper file uses the following global data variables:
-- global.itemSelection[$playerName]
--				.recent= { {$group, $name}, {"item", "iron-plate"}, {"fluid", "water"}, ... }
--        .callback = function({group=$,name=$,prototype=$})
--				.showGroups = set of values. e.g: { "item"=true, "fluid"=true, "signal"=true }

--------------------------------------------------
-- Constants
--------------------------------------------------
GROUP_ITEM = "item"
GROUP_FLUID = "fluid"
GROUP_SIGNAL = "virtual-signal"
GROUP_ALL = {GROUP_ITEM, GROUP_FLUID, GROUP_SIGNAL}

------------------------------------
-- Helper methods
------------------------------------

local function initGuiForPlayerName(playerName)
	if global.itemSelection == nil then global.itemSelection = {} end
	local is = global.itemSelection
	if is[playerName] == nil then is[playerName] = {} end
	if is[playerName].recent == nil then is[playerName].recent = {} end
end

local function prototypesForGroup(group)
	if group == GROUP_ITEM then
		return game.item_prototypes
	elseif group == GROUP_FLUID then
		return game.fluid_prototypes
	elseif group == GROUP_SIGNAL then
		return game.virtual_signal_prototypes
	end
end

local function checkBoxForItem(group,name)
	local prototype = prototypesForGroup(group)[name]
	local tip = prototype.localised_name
	return {
		type = "sprite-button",
		name = "itemSelection."..group.."."..name,
		style = "slot_button_style",
		tooltip = tip,
		sprite = group.."/"..name
	}
end

local function selectItem(playerData,player,group,itemName)
	-- add to recent items
	table.insert(playerData.recent,1,{group,itemName})
	-- prevent duplicates
	for i=#playerData.recent,2,-1 do
		if playerData.recent[i][2] == itemName then table.remove(playerData.recent,i) end
	end
	-- remove oldest items from history
	if #playerData.recent > maxRecentEntries then
		table.remove(playerData.recent,maxRecentEntries)
	end

	if global.itemSelection[player.name].callback then
		global.itemSelection[player.name].callback({
			name=itemName,
			group=group,
			prototype=prototypesForGroup(group)[itemName]
		})
		global.itemSelection[player.name].callback = nil
	end
	itemSelection_close(player)
end


local function rebuildItemList(player)
	local frame = player.gui.left.itemSelection.main
	if frame.itemsScrollPane then
		frame.itemsScrollPane.destroy()
	end

	local scroll = frame.add{type="scroll-pane", name="itemsScrollPane"}
	--scroll.style.maximal_width=450  --Needed to produce horizontal scroll bars
	scroll.style.maximal_height=180 --Needed to produce vertical scroll bars
	scroll.horizontal_scroll_policy = "never"
	scroll.vertical_scroll_policy = "auto"
	local items = scroll.add{type="table",name="itemsX",colspan=mainMaxEntries}
	
	local filter = frame.search["itemSelection.field"].text
	local playerData = global.itemSelection[player.name]
	local showGroups = playerData.showGroups
	
	for _,group in pairs(GROUP_ALL) do
		if showGroups[group] then
			for name,prototype in pairs(prototypesForGroup(group)) do
				local specialCondition = true
				if group == GROUP_ITEM then
					specialCondition = not prototype.has_flag("hidden")
				end
				if specialCondition and (filter == "" or string.find(name,filter)) then
					local checkbox = checkBoxForItem(group,name)
					local status, err = pcall(function() items.add(checkbox) end)
					if not status then
						warn("Error occured with item: "..name..".")
						warn(err)
					end
				end
			end
		end
	end
end

------------------------------------
-- Events
------------------------------------

itemSelection_close = function(player)
	if player.gui.left.itemSelection ~= nil then
		player.gui.left.itemSelection.destroy()
	end
	initGuiForPlayerName(player.name)
	local playerData = global.itemSelection[player.name]
	playerData.callback = nil
end


itemSelection_open = function(player,types,callback)
	initGuiForPlayerName(player.name)
	local playerData = global.itemSelection[player.name]
	playerData.showGroups = table.set(types)

	if player.gui.left.itemSelection ~= nil then
		itemSelection_close(player)
	end

	local frame = player.gui.left.add{type="frame",name="itemSelection",direction="vertical",caption={"item-selection"}}
	frame.add{type="table",name="main",colspan=1}
	frame = frame.main

	if #playerData.recent > 0 then
		frame.add{type="table",name="recent",colspan=2}
		frame.recent.add{type="label",name="title",caption={"",{"recent"},":"}}
		local items = frame.recent.add{type="table",name="itemsX",colspan=#playerData.recent}
		for _,recentTable in pairs(playerData.recent) do
			if type(recentTable) == "string" then
				playerData.recent = {}
				break
			end
			items.add(checkBoxForItem(recentTable[1],recentTable[2]))
		end
	end

	frame.add{type="table",name="special",colspan=2}
	frame.special.add{type="label",name="title",caption={"",{"special"},":"}}
	frame.special.add{type="table",name="itemsX",colspan=1}
	frame.special.itemsX.add(checkBoxForItem("item","belt-sorter-everythingelse"))

	frame.add{type="table",name="search",colspan=2}
	frame.search.add{type="label",name="title",caption={"",{"search"},":"}}
	frame.search.add{type="textfield",name="itemSelection.field"}

	rebuildItemList(player)
	-- Store reference for callback

	global.itemSelection[player.name].callback = callback
	global.itemSelection[player.name].filter = ""
	gui_scheduleEvent("itemSelection.updateFilter",player)
end

itemSelection_gui_event = function(guiEvent,player)
	initGuiForPlayerName(player.name)
	local fieldName = guiEvent[1]
	local playerData = global.itemSelection[player.name]
	if playerData == nil then return end
	if playerData.callback == nil then return end
	if fieldName == "field" then
		rebuildItemList(player)
	elseif fieldName == "updateFilter" then
		local frame = player.gui.left.itemSelection.main
		local filter = frame.search["itemSelection.field"].text
		if filter ~= playerData.filter then
			playerData.filter = filter
			rebuildItemList(player)
		end
		gui_scheduleEvent("itemSelection.updateFilter",player)
	elseif table.set(GROUP_ALL)[fieldName] then
		local itemName = guiEvent[2]
		selectItem(playerData,player,fieldName,itemName)
	else
		warn("Unknown fieldName for itemSelection_gui_event: "..tostring(fieldName))
	end
end

-- The format how recent objects were stored has changed, therefore this table needs to be cleared
itemSelection_migration_2_9 = function()
	for playerName, arr in pairs(global.itemSelection) do
		arr.recent = {}
	end
end



