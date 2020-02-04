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
--		io = {[1]=... [12]=...} constant-combinator which is used as input/output
--		size = size of the blueprint used
--    chunkPos = position of the center of the blueprint
--		state = enum(
--			"chunk-gen" generation of chunk requested
--			"empty"			chunk and tiles generated
--		)
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
	scheduleAdd(entity, TICK_ASAP)
	local position = entity.position
	
	local io = {}
	for x=-0.75,0.75,0.5 do
		for y=-0.75,0.75,0.5 do
			if math.abs(x)==0.75 or math.abs(y)==0.75 then
				local p = entity.surface.create_entity{
					name="compact-combinator-io", position= {x=position.x+x , y=position.y+y}, force=entity.force
				}
				p.destructible = false
				p.minable = false
				p.operable = false
				p.disconnect_neighbour()
				table.insert(io, p)
			end
		end
	end
	
	-- generate surface if not existed yet
	local surface = Surface.get()
	
	return {
		version = 1,
		io = io,
		size = 19,
		chunkPos = Surface.newSpot(),
		state = "chunk-gen"
	}
end


entityMethods.remove = function(data)
	if data.io then
		for k,e in pairs(data.io) do
			e.destroy()
		end
	end
	Surface.freeSpot(data.chunkPos)
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
	
	if data.state == "chunk-gen" then
		if Surface.get().is_chunk_generated(data.chunkPos) then
			Surface.placeTiles(data.chunkPos, data.size)
			data.state = "empty"
			info("chunk generated: "..serpent.block(data.chunkPos))
		else
			info("waiting for chunk gen: "..serpent.block(data.chunkPos))
		end
	end
	if data.state == "empty" then
		return 300 -- no need to update anymore
	end
	
	return 10 --sleep to next update
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


