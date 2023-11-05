local sample_state =class_base:extend()


function sample_state:new()

    
    print("initialised!!")
end


function sample_state:startup()
   print("startup")
  love.graphics.setDefaultFilter("nearest", "nearest")
   gvar.map = glib.map()
   table.insert(gvar.people, glib.person({ x = 0, y = 0 }))
end


function sample_state:draw()
  love.graphics.setColor(36,159,222)
  love.graphics.rectangle("fill",0,0,scr_w,scr_h)
  love.graphics.setColor(0,255,0)
  love.graphics.rectangle("fill",0,scr_h-32, scr_w, scr_h)
  love.graphics.setColor(255,255,255)

  love.graphics.push()
  love.graphics.scale(2,2)
  love.graphics.translate(-scr_w/4 -32,-scr_h/4 + 32*3.5)
  gvar.map:draw()

  for k,person in pairs(gvar.people) do
    person:draw()
  end
  love.graphics.pop()
end



function sample_state:update()
   for k,person in pairs(gvar.people) do
    person:update()
  end 
end

function sample_state:shutdown()
    
end

function sample_state:clicked(x,y,btn)
  print("state click",x,y,btn)
  gvar.map:new_room()
end



return sample_state()
