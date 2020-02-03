require "libs.control.functions"

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
--   signal = table( type = string(item,fluid,virtual_signal), name = string)
-- }

--------------------------------------------------
-- Migration
--------------------------------------------------

function migrate_0_1_1_statusPanel()
	for id,data in pairs(global.entityData) do
		if data.name == "status-panel" then
			if not data.sprite.valid then
				local location = positionOfId(id)
				local surface = surfaceWithIndex(location.surfaceIndex)
				local position = location.position
				data.sprite = surface.create_entity{
					name="ic-status-panel-sprite", 
					-- y-offset is required for correct order of sprite display
					-- the offset is undone by using shift value in the sprite
					position= {x=position.x , y=position.y+1}, 
					force=nil
				}
			end
		else
			info("Unknown entity: "..data.name)
		end
	end
end

---------------------------------------------------
-- build and remove
---------------------------------------------------

statusPanel.build = function(entity)
	scheduleAdd(entity, TICK_ASAP)
	
	local position = entity.position
	local sprite = entity.surface.create_entity{
		name="ic-status-panel-sprite", 
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
	targetData.min = srcData.min
	targetData.max = srcData.max
	targetData.signal = deepcopy(srcData.signal)
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
	frame.add{type="table",name="table",column_count=2}

	frame.table.add{type="label",name="title",caption={"",{"signal"},":"}}
	frame.table.add{type="choose-elem-button",name="integratedCircuitry.signal",elem_type="item"}
	
	frame.table.add{type="label",name="min",caption={"",{"red_value"},":"}}
	frame.table.add{type="textfield",name="integratedCircuitry.min"}
	
	frame.table.add{type="label",name="max",caption={"",{"green_value"},":"}}
	frame.table.add{type="textfield",name="integratedCircuitry.max"}
	
	m.updateGui(player,entity)
end

gui["status-panel"].close = function(player)
	if player.gui.left.statusPanel then
		player.gui.left.statusPanel.destroy()
	end
end

gui["status-panel"].click = function(nameArr,player,entity)
	local fieldName = table.remove(nameArr,1)
	if fieldName == "signal" then
		local box = player.gui.left.statusPanel.table["integratedCircuitry.signal"]
		local itemName = box.elem_value
		if itemName then
			local prototype = prototypesForGroup("item")[itemName]
			m.setSignal(player,entity,{type="item",name=itemName,prototype=prototype})
		else
			m.setSignal(player,entity,nil)
		end
	elseif table.set({"min","max"})[fieldName] then
		local data = global.entityData[idOfEntity(entity)]
		local tab = player.gui.left.statusPanel.table
		local text = tab["integratedCircuitry."..fieldName].text
		if text~="" and text~="-" then 
			text = tonumber(text) or ""
			tab["integratedCircuitry."..fieldName].text = text -- correct alpha numeric input
		end
		data[fieldName] = tonumber(text)
	end
end

m.setSignal = function(player,entity,arr)
	local data = global.entityData[idOfEntity(entity)]
	if not arr then
		data.signal = nil
		m.updateGui(player,entity)
		return
	end
	data.signal = {
		name = arr.name,
		type = arr.type
	}
	data.min = 0
	if arr.type == "item" then
		data.max = arr.prototype.stack_size
		if arr.prototype.subgroup.name == "raw-material" then
			data.max = arr.prototype.stack_size * 5
		elseif arr.prototype.subgroup.name == "module" then
			data.max = arr.prototype.stack_size * 0.2
		end
	elseif arr.type == "fluid" then
		data.max = 25000
	elseif arr.type == "signal" then
		data.max = 100
	end
	m.updateGui(player,entity)
end

m.updateGui = function(player,entity)
	local data = global.entityData[idOfEntity(entity)]
	
	local tab = player.gui.left.statusPanel.table
	tab["integratedCircuitry.min"].text = data.min or ""
	tab["integratedCircuitry.max"].text = data.max or ""
	local signal = tab["integratedCircuitry.signal"]
	if data.signal then
		signal.elem_value = data.signal.name
	else
		signal.elem_value = nil
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
	if not data.signal or statusPanel.energy == 0 then
		data.sprite.graphics_variation = 1
		return 60,nil
	end
	
	local signalGreen = statusPanel.get_circuit_network(defines.wire_type.green,1)
	local signalRed = statusPanel.get_circuit_network(defines.wire_type.red,1)
	local signal = deepcopy(data.signal)
	if signal.type == "virtual-signal" then
		signal.type = "virtual"
	end
	
	local amount = 0
	if signalGreen ~= nil then
		amount = amount + signalGreen.get_signal(signal)
	end
	if signalRed ~= nil then
		amount = amount + signalRed.get_signal(signal)
	end
	
	local min = tonumber(data.min) or 0
	local max = tonumber(data.max) or 0
	
	local per = (amount - min) / (max - min)
	if per < 0 or tostring(per) == "nan" then per = 0 end
	if per > 1 then per = 1 end
	local rotations = 10 -- orientation 1 = empty picture
	--info(per)
	data.sprite.graphics_variation = 1 + 1+math.min(rotations-1,math.floor(per * rotations))
	return 30,nil
end


