require "libs.control.functions"
require "util"
require "libs.logging"

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
--   sprite = luaEntity
--   min = integer(min value to show red)
--   max = integer(max value to show green)
--   signal = table( type = string(item,fluid,virtual_signal), name = string)
-- }

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
	sprite.destructible = false
	sprite.minable = false
	local data = {
		sprite = sprite,
		min = 0,
		max = 100,
		signal = nil
	}
	m.loadDataFromConfig(entity, data)
	return data
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
	targetData.signal = table.deepcopy(srcData.signal)
end

---------------------------------------------------
-- gui actions
---------------------------------------------------

gui["status-panel"]={}
gui["status-panel"].open = function(player,entity)
	player.opened = nil
	if player.gui.screen["status-panel"] then
		player.gui.screen["status-panel"].destroy()
	end
	
	local frame = player.gui.screen.add{type="frame",name="status-panel",direction="vertical",caption={"status-panel"}}
	frame.add{type="label",name="description",caption={"status-panel-description"}}
	frame.add{type="label",name="description2",caption={"status-panel-description2"}}
	frame.add{type="table",name="table",column_count=2}

	frame.table.add{type="label",name="title",caption={"",{"signal"},":"}}
	frame.table.add{type="choose-elem-button",name="integratedCircuitry.signal",elem_type="signal"}
	
	frame.table.add{type="label",name="min",caption={"",{"red_value"},":"}}
	frame.table.add{type="textfield",name="integratedCircuitry.min"}
	
	frame.table.add{type="label",name="max",caption={"",{"green_value"},":"}}
	frame.table.add{type="textfield",name="integratedCircuitry.max"}
	frame.force_auto_center()
	
	m.updateGui(player,entity)
	player.opened = frame
end

gui["status-panel"].close = function(player, typ)
	if typ == defines.gui_type.custom then
		if player.gui.screen["status-panel"] then
			player.gui.screen["status-panel"].destroy()
		end
	end
end

gui["status-panel"].click = function(nameArr,player,entity)
	local closeGui = false
	local fieldName = table.remove(nameArr,1)
	if fieldName == "signal" then
		local box = player.gui.screen["status-panel"].table["integratedCircuitry.signal"]
		local signal = box.elem_value
		if signal then
			local p = prototypesForGroup(signal.type)
			local prototype = p[signal.name]
			m.setSignal(player,entity,{type=signal.type,name=signal.name,prototype=prototype})
		else
			m.setSignal(player,entity,nil)
		end
		local data = global.entityData[idOfEntity(entity)]
		m.writeDataToConfig(data, entity)
	elseif table.set({"min","max"})[fieldName] then
		local data = global.entityData[idOfEntity(entity)]
		local tab = player.gui.screen["status-panel"].table
		local text = tab["integratedCircuitry."..fieldName].text
		if text~="" and text~="-" then 
			local textBefore = text
			if text:find("e") then 
				closeGui = true 
			else
				text = tonumber(text) or data[fieldName] or ""
				if tostring(text) ~= tostring(textBefore) then
					tab["integratedCircuitry."..fieldName].text = text -- correct alpha numeric input
				end
				data[fieldName] = tonumber(text)
			end
		end
		m.writeDataToConfig(data, entity)
	end
	if closeGui then player.opened = nil end
end

m.loadDataFromConfig = function(entity, data)
	local cir = entity.get_or_create_control_behavior()
	data.signal = cir.get_signal(1).signal
	if cir.get_signal(2).signal then
		data.min = cir.get_signal(2).count
	end
	if cir.get_signal(3).signal then
		data.max = cir.get_signal(3).count
	end
end

m.writeDataToConfig = function(data, entity)
	local cir = entity.get_or_create_control_behavior()
	-- order of slots is relevant! See method "copyFromOtherIfAvailable"
	if data.signal then
		cir.set_signal(1, {signal={type=data.signal.type, name=data.signal.name}, count=0})
	else
		cir.set_signal(1, nil)
	end
	cir.set_signal(2, {signal={type="virtual", name="signal-M"}, count=data.min or 0})
	cir.set_signal(3, {signal={type="virtual", name="signal-N"}, count=data.max or 500})
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
	
	local tab = player.gui.screen["status-panel"].table
	tab["integratedCircuitry.min"].text = data.min or ""
	tab["integratedCircuitry.max"].text = data.max or ""
	local signal = tab["integratedCircuitry.signal"]
	if data.signal then
		signal.elem_value = data.signal
	else
		signal.elem_value = nil
	end		
end

---------------------------------------------------
-- update tick
---------------------------------------------------

statusPanel.tick = function(statusPanel,data)
	statusPanel.direction = 0
	if not data then
		err("Error occured with status-panel: "..idOfEntity(statusPanel))
		return 0,nil
	end
	if not data.signal then
		data.sprite.graphics_variation = 1
		return 60,nil
	end
	
	local signalGreen = statusPanel.get_circuit_network(defines.wire_type.green,1)
	local signalRed = statusPanel.get_circuit_network(defines.wire_type.red,1)
	local signal = table.deepcopy(data.signal)
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


