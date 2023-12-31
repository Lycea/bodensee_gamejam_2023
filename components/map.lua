local map = class_base:extend()
local d = gvar.dir


function map:new()
  self.rooms = {}
  self.rooms_map = {}
  local room = glib.room(glib.types.pos(0,0))
  table.insert(self.rooms, room)
  self.rooms_map["0;0"] = room

end

function map:get_directions(room_idx)

  local tmp_room = self.rooms_map[room_idx.y .. ";" .. room_idx.x]
  local dirs = {}

  for k,v in pairs(tmp_room.neighbors) do
    print("  ",k,v)
  end

  for direction, idx in pairs( d.neighbor_enum )  do
    print(direction,idx, tmp_room.neighbors[idx])
    if tmp_room.neighbors[idx] then
      if direction == "top" and tmp_room.room_type == "ladder"  then
        table.insert(dirs,direction)

      elseif direction == "bot" and
          tmp_room.neighbors[d.neighbor_enum["bot"]].room_type == "ladder"   then
        table.insert(dirs,direction)

      elseif direction == "left" or direction == "right" then
        table.insert(dirs, direction)
      end
    end
  end
  
  return dirs
end

function map:new_room()
 local room_not_found = true
 print("---------------------------")
 while room_not_found == true do
   print("searching for room")
   local rnd_idx = love.math.random(1,#self.rooms)
   local neigh_id =self.rooms[rnd_idx]:check_for_slot()
   print(neigh_id)

   if neigh_id ~= nil then
     -- generate and insert room
     local room = self.rooms[rnd_idx]:gen_neighbor(neigh_id)
     print("new idx: ", room.pos.y,room.pos.x)
     self.rooms_map[room.pos.y..";"..room.pos.x]=room
     table.insert(self.rooms, room)

     --insert person
     if room.room_type == "house" then
       table.insert(gvar.people, glib.person({ x = room.pos.x, y = room.pos.y }))
     end

     print("start fixing other connections")
     --now fix the other directions
     for dir, position_change in pairs(d.direction_map) do
       print("  fixing ",dir)
       local map_y = room.pos.y + position_change[2]
       local map_x = room.pos.x + position_change[1]
       local other_room = self.rooms_map[ map_y..";"..map_x   ]

       if other_room then
         room:add_neighbor(dir, other_room)
         other_room:add_neighbor(d.inv_directions[dir], room)
       end
     end
     print("done fixing other connections")

     break
   end
 end
end


function map:draw()
  --print("drawing")
  for _,room in pairs(self.rooms) do
    room:draw()
  end

  --self:new_room()
  --print("new room done ?")
end


return map
