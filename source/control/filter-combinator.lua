
-- Registering entity into system
local filterCombinator = {}
entities["filter-combinator"] = filterCombinator

-- Constants
local m = {} --used for methods of the filterCombinator

---------------------------------------------------
-- entityData
---------------------------------------------------

-- Used data:
-- {
--		output = constant-combinator which is used as output
-- }

--------------------------------------------------
-- Global data
--------------------------------------------------


---------------------------------------------------
-- build and remove
---------------------------------------------------

filterCombinator.build = function(entity)
	scheduleAdd(entity, TICK_ASAP)
	info("asdf")
	local position = entity.position
	local output = entity.surface.create_entity{
		name="constant-combinator", 
		position= {x=position.x , y=position.y+1}, 
		force=entity.force
	}
	output.orientation=0
	output.destructible = false
	output.minable = false
	
	return {
		output = output,
	}
end

filterCombinator.remove = function(data)
	if data.output then
		data.output.destroy()
	end
end

filterCombinator.copy = function(source,srcData,target,targetData)
	
end

---------------------------------------------------
-- gui actions
---------------------------------------------------

gui["filter-combinator"]={}
gui["filter-combinator"].open = function(player,entity)
	--[[
	if player.gui.left.filterCombinator then
		player.gui.left.filterCombinator.destroy()
	end
	
	local frame = player.gui.left.add{type="frame",name="filterCombinator",direction="vertical",caption={"status-panel"}}
	frame.add{type="label",name="description",caption={"status-panel-description"}}
	frame.add{type="table",name="table",colspan=2}

	frame.table.add{type="label",name="title",caption={"",{"signal"},":"}}
	frame.table.add{type="sprite-button",name="integratedCircuitry.signal",style="slot_button_style",sprite=""}
	
	frame.table.add{type="label",name="min",caption={"",{"red_value"},":"}}
	frame.table.add{type="textfield",name="integratedCircuitry.min"}
	
	frame.table.add{type="label",name="max",caption={"",{"green_value"},":"}}
	frame.table.add{type="textfield",name="integratedCircuitry.max"}
	
	m.updateGui(player,entity)
	]]--
end

gui["filter-combinator"].close = function(player)
	--[[
	if player.gui.left.filterCombinator then
		player.gui.left.filterCombinator.destroy()
	end
	itemSelection_close(player)
	]]--
end

gui["filter-combinator"].click = function(nameArr,player,entity)
	local fieldName = table.remove(nameArr,1)
	if fieldName == "signal" then
		
	end
end

---------------------------------------------------
-- update tick
---------------------------------------------------

filterCombinator.tick = function(filterCombinator,data)
	if not data then
		err("Error occured with status-panel: "..idOfEntity(filterCombinator))
		return 0,nil
	end
	
	info("test")
	return 10
end


