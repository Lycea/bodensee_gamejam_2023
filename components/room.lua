local room = class_base:extend()

local room_base_pos = 0
local room_size = 32


local d = gvar.dir
local room_types = {"house","fence","ladder"}
local room_idx ={
  house = {1,1},
  fence = {2,1},
  ladder = {3,1}
}


function room:new(idx_pos)

  if idx_pos.x == idx_pos.y and idx_pos.x == 0 then
    self.room_type = "house"
  else
    --type selection
    local rnd_num = love.math.random(1, 100)
    if rnd_num > 70 then
      self.room_type = "house"
    else
      self.room_type = "fence"
      if rnd_num > 50 then
        self.room_type = "ladder"
      end
    end
  end

  if room_base_pos == 0 then
    room_base_pos = glib.types.pos(scr_w / 2, scr_h / 2)
  end

  self.pos = idx_pos
  self.neighbors ={false,false,false,false}
  self.empty_neighs ={"top","left","right"}

  if idx_pos.y ~= 0 then
    table.insert(self.empty_neighs,"bot")
  end

  print("new room, neigh size", #self.empty_neighs)
end

function room:get_pos()
  return glib.types.pos(
              room_base_pos.x + self.pos.x*room_size,
              room_base_pos.y + self.pos.y*room_size)
end

function room:draw()

    -- love.graphics.rectangle("line",
    --     room_base_pos.x + self.pos.x * room_size,
    --     room_base_pos.y + self.pos.y * room_size,
    --     room_size, room_size)


    love.graphics.draw(gvar.gr.buildings.image,
    gvar.gr.buildings[room_idx[self.room_type][1]]
                     [room_idx[self.room_type][2]],
           room_base_pos.x + self.pos.x * room_size,
           room_base_pos.y + self.pos.y * room_size
    )
    -- connection debug
    -- for k , v in pairs(d.neighbor_enum) do
    --   if self.neighbors[k] == nil then
        
    --   else
    --     love.graphics.setColor(0,255,0)
    --     love.graphics.rectangle("fill",
    --                             room_base_pos.x + self.pos.x * room_size + (room_size/2) + d.direction_map[k][1]*room_size/4,
    --                             room_base_pos.y + self.pos.y * room_size + (room_size/2) + d.direction_map[k][2]*room_size/4,
    --                             room_size/4,
    --                             room_size/4
    --     )
    --     love.graphics.setColor(255,255,255)
    --   end
    --end
end

function room:check_for_slot()
  print("Empty:",#self.empty_neighs)
  if #self.empty_neighs >0 then
    return self.empty_neighs[  love.math.random(1,#self.empty_neighs) ]
  else
    return nil
  end
end

function room:add_neighbor(dir,neighbor)
  self.neighbors[d.neighbor_enum[dir]] = neighbor

  for k, v in pairs(self.empty_neighs) do
    if v == dir then
      table.remove(self.empty_neighs, k)
      break
    end
  end
  
end

function room:gen_neighbor(direction)

   local new_room = room(glib.types.pos(self.pos.x + d.direction_map[direction][1] , self.pos.y +d.direction_map[direction][2]) )

   self:add_neighbor(direction, new_room)
   new_room:add_neighbor(d.inv_directions[direction], self)

   return new_room
end

return room
