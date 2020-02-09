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
--		}
--	}


---------------------------------------------------
-- entityData
---------------------------------------------------

-- Used data:
-- {
--		version = 1 (in the current version)
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
		io = {},
		poles = {},
		ports = {},
		size = 19,
		chunkPos = Surface.newSpot(position.x, position.y),
	}
	if data.chunkPos == nil then
		err("Could not find free spot")
		entity.destroy()
		return nil
	end
	info("pos: "..position.x..", "..position.y.." chunkPos: "..data.chunkPos[1]..", "..data.chunkPos[2])
	local cir = entity.get_or_create_control_behavior()
	cir.set_signal(1, {signal={type="virtual", name="signal-X"}, count=data.chunkPos[1]})
	cir.set_signal(2, {signal={type="virtual", name="signal-Y"}, count=data.chunkPos[2]})
	cir.set_signal(3, {signal={type="virtual", name="signal-S"}, count=data.size})
	cir.set_signal(4, {signal={type="virtual", name="signal-V"}, count=data.version})
	
	Surface.placeTiles(data.chunkPos, data.size)
	local surface = Surface.get()
	local chunkMiddle = Surface.chunkMiddle(data.chunkPos)
	for x=-3,3,2 do for y=-3,3,2 do
		if math.abs(x)==3 or math.abs(y)==3 then
			local p = entity.surface.create_entity{
				name="compact-combinator-io", position= {x=position.x+x*0.25 , y=position.y+y*0.25}, force=entity.force
			}
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
	
	return data
end


entityMethods.remove = function(data)
	if data.io then
		for k,e in pairs(data.io) do
			e.destroy()
		end
	end
	Surface.freeSpot(data.chunkPos) --removes all entities inside
end

entityMethods.copy = function(source,srcData,target,targetData)
	
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

private.data = function()
	local data = global.integratedCircuitry
	if not data.cc then
		data.cc = { players={} }
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
