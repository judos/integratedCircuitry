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
--   
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
		sprite = sprite
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
			itemSelection_open(player,function(itemName)
				local tip = game.item_prototypes[itemName].localised_name
				box.sprite = "item/"..itemName
				box.tooltip = tip
				--TODO: do something
			end)
		else
			box.sprite = ""
			box.tooltip = ""
			--TODO: do something
		end
	end
end

m.method = function(player,entity)

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


