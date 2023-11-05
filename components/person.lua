local person = class_base:extend()
local size = {w=16,h=32}

function person:new( home_idx)
    self.position = home_idx
    self.home_room = home_idx

    self._start_pos = self.position
    self._goal_pos =  self.position


    --gvar.map.room_map[ home_idx.y..";"..home_idx.x]:get_pos()
    self.precise_pos = gvar.map.rooms_map[home_idx.y .. ";" .. home_idx.x]:get_pos()

    self.state = "idle"
    self.goal_reached = true
    self.lerp_pos = 100
    self.speed = 0.2
    self.next_idx = {x=0,y=0}
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
       self.next_idx = {
         x= self.position.x + gvar.dir.direction_map[directions[goal_dir]][1], 
         y= self.position.y + gvar.dir.direction_map[directions[goal_dir]][2] }

       self.lerp_pos = 0
     end
  else
    self.precise_pos = glib.helper.lerp_2d(self._start_pos,self._goal_pos, math.min( self.lerp_pos,100)/100)
    self.lerp_pos = self.lerp_pos +self.speed

    if self.lerp_pos >= 100 then
      self.position = self.next_idx
      self.goal_reached = true
    end
  end
end


function person:draw()
  love.graphics.rectangle("fill",
                          self.precise_pos.x,
                          self.precise_pos.y,
                          size.w,
                          size.h
  )
end



return person
