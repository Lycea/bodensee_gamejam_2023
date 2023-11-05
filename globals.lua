local globals = {}

--initial helpers

globals.vars = {}
globals.libs = {}

glib = globals.libs
gvar = globals.vars

local function lib(lib, name)
  glib[name] = require(lib)
  print(glib[name])
end

function globals.lib(name)
  return glib[name]
end

function globals.var(name)
  return gvar[name]
end

gvar.dir = {}

-- libs
lib("helper.base_types","types")

lib("helper.helpers","helper")

lib("components.room","room")
lib("components.map","map")
lib("components.person","person")
lib("helper.loader", "loader")
-- helper vars

gvar.dir.neighbor_enum = {
  top = 1,
  right = 2,
  bot = 3,
  left = 4
}
 
gvar.dir.direction_map = {

  top   = { 0, -1 },
  bot   = { 0, 1 },
  left  = { -1, 0 },
  right = { 1, 0 }
}

gvar.dir.inv_directions = {
  top = "bot",
  bot = "top",
  left = "right",
  right = "left"
}
gvar.gr = {}

--graphics
gvar.gr.animations = glib.loader.loadTiles("assets/animations.png", 16, 16)
gvar.gr.animations.image:setFilter("nearest", "nearest")
gvar.gr.buildings = glib.loader.loadTiles("assets/buildings.png", 32, 32)
gvar.gr.buildings.image:setFilter("nearest", "nearest")
-- main parts


gvar.people = {}
gvar.map = {} 

gvar.time = 0 --current frame time



return globals


