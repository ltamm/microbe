function love.load()
    -- initialize the world
    love.window.setMode(window_width, window_height)
    
    -- initialize snake position
    x = window_width / 3
    y = window_height / 3
    snake = {
        {x, y},
        {x-2*snake_radius, y}
    }

    math.randomseed(os.time())
end

function love.update(dt)
     register_movement(dt)
    --eat_food()
    --place_food(dt)
end

-- Food functions
function eat_food()
    for i,food in ipairs(foods) do
        if overlaps(food) then 
           table.remove(foods, i)
           -- todo: grow snake
        end
    end
end

function overlaps(food)
    -- crude hitbox
    x = snake[1][1]
    y = snake[1][2]
    return x < food[1] + food_radius 
            and x > food[1] - food_radius 
            and y < food[2] + food_radius 
            and y > food[2] - food_radius
end

function place_food(dt)
    food_timer = food_timer + dt
    if food_timer >= food_interval then 
        -- generate random location for food
        table.insert(foods, {math.random(window_width), math.random(window_height)})
        food_timer = food_timer - food_interval
    end
end


-- Movement Functions
function register_movement(dt)
      moved = false
      if love.keyboard.isDown("right") then 
        moved = move_right(dt)
    end
     -- if love.keyboard.isDown("left") then move_left(dt) end
    -- if love.keyboard.isDown("up") then move_up(dt) end
    if love.keyboard.isDown("down") then 
        moved = move_down(dt) 
    end

    -- translate body 
    -- treat body as origin
    if moved then
        pointx = snake[1][1]-snake[2][1]
        pointy = snake[1][2]-snake[2][2]

        atan = math.atan2(pointx, pointy)
        hyp = math.sqrt((pointx*pointx)+(pointy*pointy))
        c = hyp - (2*snake_radius)
        last_angle = (math.pi/2) - atan
        x_val = (c*math.sin(atan))/math.sin(math.pi/2)
        y_val = (c*math.sin(last_angle))/math.sin(math.pi/2)

        -- undo translation
        snake[2] = {x_val + snake[2][1], y_val + snake[2][2]}
    end    

end

function move_right(dt)
    x = snake[1][1]
    if x < window_width - snake_radius then
        snake[1][1] = x + (dt * snake_speed)
        return true
    end
    return false
end

function move_left(dt)
    x = snake[1][1]
    if x > snake_radius then
        snake[1][1] = x - (dt * snake_speed)
    end
end

function move_up(dt)
    y = snake[1][2]
    if y > snake_radius then
        snake[1][2] = y - (dt * snake_speed)
    end
end

function move_down(dt)
    y = snake[1][2]
    if y < window_height - snake_radius then
        snake[1][2] = y + (dt * snake_speed)
        return true
    end
    return false
end

function love.draw()

    -- draw food
    for i,food in ipairs(foods) do
        love.graphics.setColor(1,0,0,1)
        love.graphics.circle("fill", food[1], food[2], food_radius)
    end
    
    -- draw snake
    draw_snake()
    
end

function draw_snake()
    love.graphics.setColor(0, 1, 0, 1)
    -- render head
    love.graphics.circle("fill", snake[1][1], snake[1][2], snake_radius)
    -- render body
    if #snake > 1 then
        for i=2, #snake do
            love.graphics.circle("line", snake[i][1], snake[i][2], snake_radius)
        end
    end
end