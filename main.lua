step = 0.25
time = 0
tick = 0

rules = love.graphics.newShader [[
    uniform vec2 normalized;
    const vec4 BACKGROUND = vec4(1.0, 1.0, 1.0, 1.0);
    const vec4 ELECTRON   = vec4(1.0, 1.0, 0.0, 1.0);
    const vec4 TAIL       = vec4(1.0, 0.0, 0.0, 1.0);
    const vec4 WIRE       = vec4(0.0, 0.0, 0.0, 1.0);

    vec2 pos(float x, float y) {
        return vec2(x, y) * normalized;
    }
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        vec4 cell = Texel(texture, texture_coords);
        if (cell == ELECTRON) {
            return TAIL;
        } else if (cell == TAIL) {
            return WIRE;
        } else if (cell == WIRE){
            int neighbors = 0;
            if (Texel(texture, texture_coords + pos( 0.0,  1.0)) == ELECTRON) { neighbors++; } 
            if (Texel(texture, texture_coords + pos( 1.0,  1.0)) == ELECTRON) { neighbors++; }
            if (Texel(texture, texture_coords + pos( 1.0,  0.0)) == ELECTRON) { neighbors++; } 
            if (Texel(texture, texture_coords + pos( 1.0, -1.0)) == ELECTRON) { neighbors++; }
            if (Texel(texture, texture_coords + pos( 0.0, -1.0)) == ELECTRON) { neighbors++; }
            if (Texel(texture, texture_coords + pos(-1.0, -1.0)) == ELECTRON) { neighbors++; }
            if (Texel(texture, texture_coords + pos(-1.0,  0.0)) == ELECTRON) { neighbors++; }
            if (Texel(texture, texture_coords + pos(-1.0,  1.0)) == ELECTRON) { neighbors++; }
            if (neighbors == 1 || neighbors == 2) {
                return ELECTRON;
            } else {
                return WIRE;
            }
        } else {
            return BACKGROUND;
        }
    }
]]
love.graphics.setDefaultFilter('nearest', 'nearest')

board = love.graphics.newCanvas(1000, 1000)
rules:send("normalized", {1 / board:getWidth(), 1 / board:getHeight()})

function love.update(dt)
    time = time + dt
end

function love.draw()
    love.graphics.setCanvas(board)
    love.graphics.draw(love.graphics.newImage("seed.png"))
    love.graphics.setCanvas()
    love.draw = function()
        if time >= step then
            next = love.graphics.newImage(board:newImageData())
            love.graphics.setCanvas(board)
            love.graphics.setShader(rules)
            love.graphics.draw(next)
            love.graphics.setShader()
            love.graphics.setCanvas()
            time = 0
            tick = tick + 1
            print(tick)
        end
        love.graphics.push()
        love.graphics.scale(5.0, 5.0)
        love.graphics.draw(board)
        love.graphics.pop()
    end
end
