local sample_state =class_base:extend()


function sample_state:new()

    
    print("initialised!!")
end


function sample_state:startup()
   print("startup")

   gvar.map = glib.map() 
end


function sample_state:draw()

  gvar.map:draw()
end



function sample_state:update()
    
end

function sample_state:shutdown()
    
end

function sample_state:clicked(x,y,btn)
  print("state click",x,y,btn)
  gvar.map:new_room()
end



return sample_state()
