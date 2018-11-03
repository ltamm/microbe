function love.load()
    -- initialize the world
    love.window.setMode(window_width, window_height)
    
    -- initialize snake position
    x = window_width / 2
    y = window_height / 2
    snake = {{x, y}}

end

function love.update(dt)
    register_movement(dt)
    eat_food()
    place_food(dt)
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
        table.insert(foods, {love.math.random(window_width), love.math.random(window_height)})
        food_timer = food_timer - food_interval
    end
end


-- Movement Functions
function register_movement(dt)
    if love.keyboard.isDown("right") then move_right(dt) end
    if love.keyboard.isDown("left") then move_left(dt) end
    if love.keyboard.isDown("up") then move_up(dt) end
    if love.keyboard.isDown("down") then move_down(dt) end
end

function move_right(dt)
    x = snake[1][1]
    if x < window_width - snake_radius then
        snake[1][1] = x + (dt * snake_speed)
    end
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
    end
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
    love.graphics.circle("fill", snake[1][1], snake[1][2], snake_radius)
end