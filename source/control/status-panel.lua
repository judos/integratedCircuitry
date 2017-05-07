require "libs.itemSelection.control"

-- Registering entity into system
local statusPanel = {}
entities["status-panel"] = statusPanel

-- Constants
local m = {} --used for methods of the statusPanel

---------------------------------------------------
-- entityData
---------------------------------------------------

-- Used data:
-- {
--   sprite = luaEntity(car object showing the sprite)
--   min = integer(min value to show red)
--   max = integer(max value to show green)
--   signal = table( group = string(item,fluid,virtual_signal), name = string)
-- }

--------------------------------------------------
-- Global data
--------------------------------------------------


---------------------------------------------------
-- build and remove
---------------------------------------------------

statusPanel.build = function(entity)
	scheduleAdd(entity, TICK_ASAP)
	
	local position = entity.position
	local sprite = entity.surface.create_entity{
		name="status-panel-sprite", 
		-- y-offset is required for correct order of sprite display
		-- the offset is undone by using shift value in the sprite
		position= {x=position.x , y=position.y+1}, 
		force=entity.force
	}
	sprite.orientation=0
	sprite.insert({name="coal",count=1})
	sprite.destructible = false
	sprite.minable = false
	return {
		sprite = sprite,
		min = 0,
		max = 100,
		signal = nil
	}
end

statusPanel.remove = function(data)
	if data.sprite then
		data.sprite.destroy()
	end
end

statusPanel.copy = function(source,srcData,target,targetData)
	if target.name ~= "status-panel" and target.name ~= "status-panel" then
		return
	end
	info("Copy entity: "..x(srcData).." target: "..x(targetData))
	
	
end

---------------------------------------------------
-- gui actions
---------------------------------------------------

gui["status-panel"]={}
gui["status-panel"].open = function(player,entity)
	if player.gui.left.statusPanel then
		player.gui.left.statusPanel.destroy()
	end
	
	local frame = player.gui.left.add{type="frame",name="statusPanel",direction="vertical",caption={"status-panel"}}
	frame.add{type="label",name="description",caption={"status-panel-description"}}
	frame.add{type="table",name="table",colspan=2}

	frame.table.add{type="label",name="title",caption={"",{"signal"},":"}}
	frame.table.add{type="sprite-button",name="integratedCircuitry.signal",style="slot_button_style",sprite=""}
	
	frame.table.add{type="label",name="min",caption={"",{"red_value"},":"}}
	frame.table.add{type="textfield",name="red_value"}
	
	frame.table.add{type="label",name="max",caption={"",{"green_value"},":"}}
	frame.table.add{type="textfield",name="green_value"}
	
	m.updateGui(player,entity)
end

gui["status-panel"].close = function(player)
	if player.gui.left.statusPanel then
		player.gui.left.statusPanel.destroy()
	end
	itemSelection_close(player)
end

gui["status-panel"].click = function(nameArr,player,entity)
	info("clicked: "..x(nameArr))
	local fieldName = table.remove(nameArr,1)
	if fieldName == "signal" then
		local box = player.gui.left.statusPanel.table["integratedCircuitry.signal"]
		if box.sprite == "" then
			itemSelection_open(player,{GROUP_ITEM, GROUP_FLUID, GROUP_SIGNAL},function(arr)
				box.sprite = arr.group.."/"..arr.name
				box.tooltip = arr.prototype.localised_name
				m.setSignal(player,entity,arr)
			end)
		else
			box.sprite = ""
			box.tooltip = ""
			--TODO: do something
		end
	end
end

m.setSignal = function(player,entity,arr)
	local data = global.entityData[idOfEntity(entity)]
	if not arr then
		data.signal = nil
		return
	end
	data.signal = {
		name = arr.name,
		group = arr.group
	}
	data.min = 0
	if group == GROUP_ITEM then
		data.max = arr.prototype.stack_size
		info(arr.prototype.subgroup.name)
	elseif group == GROUP_FLUID then
		data.max = 25000
	elseif group == GROUP_SIGNAL then
		data.max = 100
	end
	m.updateGui(player,entity)
end

m.updateGui = function(player,entity)
	local data = global.entityData[idOfEntity(entity)]
	
	local tab = player.gui.left.statusPanel.table
	tab.red_value.text = data.min
	tab.green_value.text = data.max
	local signal = tab["integratedCircuitry.signal"]
	if data.signal then
		signal.sprite = data.signal.group.."/"..data.signal.name
		local prototypes = itemSelection_prototypesForGroup(data.signal.group)
		signal.tooltip = prototypes[data.signal.name].localised_name
	else
		signal.sprite = ""
		signal.tooltip = ""
	end		
end

---------------------------------------------------
-- update tick
---------------------------------------------------

statusPanel.tick = function(statusPanel,data)
	if not data then
		err("Error occured with status-panel: "..idOfEntity(statusPanel))
		return 0,nil
	end
	
	return 60,nil
end


