local Surface = require("control.compact-combinator-surface")

-- Registering entity into system
local entityMethods = {}
entities["compact-combinator"] = entityMethods
local guiMethods = {}
gui["compact-combinator"] = guiMethods

-- Constants
local m = {} --private methods

---------------------------------------------------
-- entityData
---------------------------------------------------

-- Used data:
-- {
--		version = 1 (in the current version)
--		io = {[1]=... [4]=..} constant-combinator which is used as input/output
--		size = size of the blueprint used (in the current version 10x10)
--    chunkPos = position of the center of the blueprint (usally expands by {{-5,-5},{4,4}}
--		state = enum(
--			"chunk-gen" generation of chunk requested
--			"empty"			chunk and tiles generated
--			"built"			blueprint is built and connected
--		)
-- }

--------------------------------------------------
-- Gui testing
--------------------------------------------------
local teleportButtonName = "integratedCircuitry.compact-combinator"

guiMethods.open = function(player, entity)
	player.gui.left.add{type="button",name=teleportButtonName,caption="Teleport"}
end

guiMethods.close = function(player)
	if player.gui.left[teleportButtonName] then
		player.gui.left[teleportButtonName].destroy()
	end
end

guiMethods.click = function(nameArr, player, entity)
	local button = table.remove(nameArr,1)
	if button == "compact-combinator" then
		local data = global.entityData[idOfEntity(entity)]
		player.teleport({data.chunkPos[1]*32+16,data.chunkPos[2]*32+16},Surface.get())
		player.gui.left[teleportButtonName].destroy()
		player.gui.left.add{type="button",name="integratedCircuitry.compact-combinator-back",caption="Teleport back"}
	elseif button == "compact-combinator-back" then
		player.teleport({0,0},game.surfaces["nauvis"])
		player.gui.left[teleportButtonName.."-back"].destroy()
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
		size = 20,
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
		return 0,nil
	end
	
	if data.state == "chunk-gen" then
		if Surface.get().is_chunk_generated({0,0}) then
			Surface.placeTiles(data.chunkPos)
			data.state = "empty"
			info("chunk generated: "..serpent.block(data.chunkPos))
		else
			info("waiting for chunk gen: "..serpent.block(data.chunkPos))
		end
	end
	if data.state == "empty" then
		
	end
	
	return 10 --sleep to next update
end



