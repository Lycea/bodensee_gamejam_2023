local person = class_base:extend()
local size = {w=8,h=12}

local anim_indexes = {
  climbing = {
    len = 2,
    x = 1,
    y = 3
  },
  idle = {
    len = 1,
    x = 1,
    y = 2
  },
  walking = {
    len = 3,
    x = 1,
    y = 1
  }
}

function person:new( home_idx)
    self.position = home_idx
    self.home_room = home_idx

    self._start_pos = self.position
    self._goal_pos =  self.position


    --gvar.map.room_map[ home_idx.y..";"..home_idx.x]:get_pos()
    self.precise_pos = gvar.map.rooms_map[home_idx.y .. ";" .. home_idx.x]:get_pos()

    self.state = "idle"
    self.dir = "left"
    self.goal_reached = true
    self.lerp_pos = 100
    self.speed = 0.1
    self.next_idx = {x=0,y=0}

    self.flip_v = 1
    self.cur_frame =0

    self._timer = timer(0.1,gvar.time)
end


function person:update()
  if self.goal_reached == true then
     print("goal was reached ... searching new")
     local directions = gvar.map:get_directions(self.position)
     print("directions:", #directions)

     if #directions ~= 0 then
       self._start_pos = self.precise_pos:copy()
       local goal_dir = love.math.random(1,#directions)

       local next_x = self.precise_pos.x + gvar.dir.direction_map[directions[goal_dir]][1] * 32
       local next_y = self.precise_pos.y + gvar.dir.direction_map[directions[goal_dir]][2] * 32

       self._goal_pos = glib.types.pos( next_x,next_y )
       print("moving ",directions[goal_dir])
       self.goal_reached = false

       self.dir = directions[goal_dir]

       if directions[goal_dir] == "top" or directions[goal_dir] == "bot" then
         self.flip_v = 1
         self.state = "climbing"
       else
         if self.dir == "left" then
           self.flip_v = -1
         else
           self.flip_v = 1
         end
         self.state ="walking"
       end
       
       self.next_idx = {
         x= self.position.x + gvar.dir.direction_map[directions[goal_dir]][1], 
         y= self.position.y + gvar.dir.direction_map[directions[goal_dir]][2] }

       self.lerp_pos = 0
       self.cur_frame = 0
     end
  else
    self.precise_pos = glib.helper.lerp_2d(self._start_pos,self._goal_pos, math.min( self.lerp_pos,100)/100)
    self.lerp_pos = self.lerp_pos +self.speed

    if self._timer:check(gvar.time) then
      local idxes = anim_indexes[self.state]
      self.cur_frame = self.cur_frame +1
      self.cur_frame = self.cur_frame >= idxes.len and 0 or self.cur_frame
    end


    if self.lerp_pos >= 100 then
      self.position = self.next_idx
      self.goal_reached = true
    end
  end
end


function person:draw()
  -- love.graphics.rectangle("fill",
  --                         self.precise_pos.x + 12,
  --                         self.precise_pos.y + 16,
  --                         size.w,
  --                         size.h
  -- )
  local idxes = anim_indexes[self.state]

  love.graphics.draw(gvar.gr.animations.image,
                     gvar.gr.animations[idxes.y][idxes.x+ self.cur_frame] ,
                     self.precise_pos.x + 12   +size.w/2,
                     self.precise_pos.y + 16,
                     0,
                     self.flip_v,1,
                     size.w/2,0
  )

  -- love.graphics.draw(self.image,
  --                    self.x + (self.image:getWidth() / 2),
  --                    self.y, 0,

  --                    self.direction, 1,
  --  (self.image:getWidth() / 2), 0)
end



return person
