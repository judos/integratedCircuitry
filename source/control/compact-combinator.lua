local Surface = require("control.compact-combinator-surface")

-- Registering entity into system
local entityMethods = {}
entities["compact-combinator"] = entityMethods
local guiMethods = {}
gui["compact-combinator"] = guiMethods

local private = {} -- private methods

-- Constants


-- global data used:
-- integratedCircuitry.cc = {
--		players[$playerName] = {
--			position = $position,		Position before teleporting into a compact-combinator
--			surface = $surface			Position before teleporting into a compact-combinator
--			entity = $entity				Compact-combinator entity that was entered
--		},
--		nextId = number						Setting for next compact-combinator (references to blueprint)
--	}


---------------------------------------------------
-- entityData
---------------------------------------------------

-- Used data:
-- {
--		version = 1 (in the current version)
--		id = nr (reference for blueprint)
--		io = { [1-12] = entity } circuit-pole which is used as input/output
--		poles = { [1-24] = entity } big poles to connect all cables
--		ports = { [1-12] = entity } circuit-pole used as port internally
--		power = entity,
--		substation = entity,
--		size = size of the compact combinator
--    chunkPos = position of the center of the blueprint
-- }

--------------------------------------------------
-- GUI
--------------------------------------------------
local teleportBackButtonName = "integratedCircuitry.compact-combinator.back"

guiMethods.open = function(player, entity)
	local data = global.entityData[idOfEntity(entity)]
	player.minimap_enabled=false
	
	local pdata = private.playerData(player.name)
	pdata.position = player.position
	pdata.surface = player.surface
	pdata.entity = entity
	
	player.teleport({data.chunkPos[1]*32+16,data.chunkPos[2]*32+16},Surface.get())
	player.gui.left.add{type="button",name=teleportBackButtonName,caption="Leave the compact combinator"}
end

guiMethods.close = function(player)
	
end

guiMethods.click = function(nameArr, player, entity)
	local button = table.remove(nameArr,1)
	if button == "back" then
		-- Note: entity is nil here because there is no open UI
		local pdata = private.playerData(player.name)
		player.teleport(pdata.position,pdata.surface)
		player.gui.left[teleportBackButtonName].destroy()
		player.minimap_enabled=true
		
		-- Update blueprint of built combinator
		local entity = pdata.entity
		local data = global.entityData[idOfEntity(entity)]
		private.updateBlueprintOf(entity, data)
	end
end

---------------------------------------------------
-- build and remove
---------------------------------------------------

entityMethods.build = function(entity)
	--scheduleAdd(entity, TICK_ASAP)
	local position = entity.position
	local data = {
		version = 1,
		id = private.generateId(),
		io = {},
		poles = {},
		ports = {},
		size = 19,
		chunkPos = Surface.newSpot(position.x, position.y),
	}
	if data.chunkPos == nil then
		entity.surface.create_entity{
			name="tutorial-flying-text", text="Too many compact-combinators in this chunk!", position=entity.position
		}
		entity.destroy()
		return nil
	end
	
	Surface.placeTiles(data.chunkPos, data.size)
	local surface = Surface.get()
	local chunkMiddle = Surface.chunkMiddle(data.chunkPos)
	for y=-3,3,2 do for x=-3,3,2 do
		if math.abs(x)==3 or math.abs(y)==3 then
			local p = entity.surface.find_entity("compact-combinator-io",{x=position.x+x*0.25 , y=position.y+y*0.25})
			if p == nil then
				p = entity.surface.create_entity{
					name="compact-combinator-io", position= {x=position.x+x*0.25 , y=position.y+y*0.25}, force=entity.force
				}
			end
			private.indestructible(p)
			p.disconnect_neighbour()
			table.insert(data.io, p)
			
			local pole1 = surface.create_entity{
				name="compact-combinator-connection", position=position, force=entity.force
			}
			private.indestructible(pole1)
			pole1.disconnect_neighbour()
			private.connectWires(p, pole1)
			table.insert(data.poles, pole1)
			
			local pole2 = surface.create_entity{
				name="compact-combinator-connection", position=chunkMiddle, force=entity.force
			}
			private.indestructible(pole2)
			pole2.disconnect_neighbour()
			private.connectWires(pole1, pole2)
			table.insert(data.poles, pole2)
			
			local port = surface.create_entity{
				name="compact-combinator-port", position= {chunkMiddle[1]+x*3, chunkMiddle[2]+y*3}, force=entity.force
			}
			private.indestructible(port)
			port.disconnect_neighbour()
			private.connectWires(pole2, port)
			table.insert(data.ports, port)
		end end
	end
	data.power = surface.create_entity{
		name="electric-energy-interface", position={chunkMiddle[1], chunkMiddle[2]+data.size/2+2}, force=entity.force
	}
	data.power.electric_buffer_size = 166667
	data.power.power_production = 166667
	private.indestructible(data.power)
	data.substation = surface.create_entity{
		name="compact-combinator-substation", position=chunkMiddle, force=entity.force
	}
	data.substation.disconnect_neighbour()
	private.indestructible(data.substation)
	
	private.copyFromOtherIfAvailable(data,entity)
	private.writeDataToCombinator(data, entity)
	
	return data
end


entityMethods.remove = function(data)
	if data.io then
		for k,e in pairs(data.io) do
			e.destroy()
		end
	end
	if data.poles then
		for k,e in pairs(data.poles) do
			e.destroy()
		end
	end
	Surface.freeSpot(data.chunkPos) --removes all entities inside
end

entityMethods.copy = function(source,srcData,target,targetData)
	
end

entityMethods.copyTo = function(source,srcData,target,targetData)
	-- don't allow overwriting signals of compact-combinator
	private.writeDataToCombinator(targetData, target)
end

---------------------------------------------------
-- update tick
---------------------------------------------------

entityMethods.tick = function(entity,data)
	if not data then
		err("Error occured with status-panel: "..idOfEntity(filterCombinator))
		return 300,nil
	end
	
	return 60 --sleep to next update
end

---------------------------------------------------
-- Private methods
---------------------------------------------------

private.updateBlueprintOf = function(entity, data)
	local inv = Surface.templateInventory()
	-- remove old blueprint
	inv[data.id].clear()
	-- create new blueprint
	local area = Surface.chunkArea(data.chunkPos, data.size)
	inv[data.id].set_stack{name="blueprint"}
	local surface = Surface.get()
	inv[data.id].create_blueprint{surface=surface, force=entity.force, area=area}
end


private.copyFromOtherIfAvailable = function(data, entity)
	local cir = entity.get_or_create_control_behavior()
	local x = cir.get_signal(1).count
	local y = cir.get_signal(2).count
	local size = cir.get_signal(3).count
	local version = cir.get_signal(4).count
	if version == nil or version == 0 or cir.get_signal(4).signal == nil then return end
	local surface = Surface.get()
	local chunkMiddle = Surface.chunkMiddle(data.chunkPos)
	local blueprint = surface.create_entity{name="item-on-ground", position=chunkMiddle, stack={name="blueprint"}}
	local s2 = (size-1)/2
	local area = {{x*32+16-s2, y*32+16-s2},{x*32+16+s2+1, y*32+16+s2+1}}
	blueprint.stack.create_blueprint{surface=surface, force=entity.force, area=area}
	local entitiesBuilt = blueprint.stack.build_blueprint{
		surface=surface, force=entity.force, position=chunkMiddle, force_build=true, skip_fog_of_war=false
	}
	for k,v in pairs(entitiesBuilt) do
		v.revive()
	end
end


private.writeDataToCombinator = function(data, entity)
	local cir = entity.get_or_create_control_behavior()
	-- order of slots is relevant! See method "copyFromOtherIfAvailable"
	cir.set_signal(1, {signal={type="virtual", name="signal-X"}, count=data.chunkPos[1]})
	cir.set_signal(2, {signal={type="virtual", name="signal-Y"}, count=data.chunkPos[2]})
	cir.set_signal(3, {signal={type="virtual", name="signal-S"}, count=data.size})
	cir.set_signal(4, {signal={type="virtual", name="signal-V"}, count=data.version})
	cir.set_signal(5, {signal={type="virtual", name="signal-I"}, count=data.id})
end

private.generateId = function()
	local data = private.data()
	local r = data.nextId
	data.nextId = data.nextId+1
	return r
end

private.data = function()
	local data = global.integratedCircuitry
	if not data.cc then
		-- initialize data
		data.cc = { 
			players = {},
			nextId = 1
		}
	end
	return data.cc
end

private.playerData = function(playerName)
	local players = private.data().players
	if not players[playerName] then
		players[playerName] = {}
	end
	return players[playerName]
end

private.indestructible = function(entity)
	entity.destructible = false
	entity.minable = false
	entity.operable = false
end

private.connectWires = function(entity, entity2)
	local b = entity.connect_neighbour{wire=defines.wire_type.red, target_entity=entity2}
	local b2 = entity.connect_neighbour{wire=defines.wire_type.green, target_entity=entity2}
	if not b or not b2 then
		err("Could not connect Cable!")
	end
end
