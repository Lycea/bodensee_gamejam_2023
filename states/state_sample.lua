local sample_state =class_base:extend()


function sample_state:new()

    
    print("initialised!!")
end


function sample_state:startup()
   print("startup")

   gvar.map = glib.map()
   for i=0, 10 do
     
     table.insert(gvar.people, glib.person({ x = 0, y = 0 }))

   end
   --table.insert(gvar.people, glib.person({ x = 0, y = 0 }))
end


function sample_state:draw()

  gvar.map:draw()

  for k,person in pairs(gvar.people) do
    person:draw()
  end
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
