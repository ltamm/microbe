function love.load()
    -- initialize the world
    love.window.setMode(window_width, window_height)
    
    -- initialize snake position
    x = window_width / 2
    y = window_height / 2
    snake = {
        {x, y},
        {x-2*snake_radius, y},
        {x-4*snake_radius, y}
    }

    math.randomseed(os.time())
end

function love.update(dt)
     register_movement(dt)
     eat_food()
     place_food(dt)
end

-- Food functions
function eat_food()
    for i,food in ipairs(foods) do
        if collides(snake[1], food, food_radius) then 
           table.remove(foods, i)
           -- todo: grow snake
        end
    end
end

function collides(collider, collidee, r)
    -- crude hitbox for circle things
    return  collider[1] < collidee[1] + r 
            and collider[1] > collidee[1] - r 
            and collider[2] < collidee[2] + r
            and collider[2] > collidee[2] - r
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
    if love.keyboard.isDown("right") then move_right(dt) end
    if love.keyboard.isDown("left") then move_left(dt) end
    if love.keyboard.isDown("up") then move_up(dt) end
    if love.keyboard.isDown("down") then move_down(dt) end

    -- move body
    if #snake > 1 then 
        for i = 2, #snake do
            x, y = apply_mathemagics(translate_to_origin(snake[i], snake[i-1]))
            x, y = translate_to_world(x, y, snake[i])
            snake[i] = {x, y}
        end
    end 
end

function translate_to_origin(origin_point, reference_point)
    x = reference_point[1] - origin_point[1]
    y = reference_point[2] - origin_point[2]
    return x, y
end

function translate_to_world(x, y, origin_point)
    x = x + origin_point[1]
    y = y + origin_point[2]
    return x, y
end

function apply_mathemagics(x, y)
    atan = math.atan2(x, y)
    hyp = math.sqrt((x*x)+(y*y))
    c = hyp - (2*snake_radius)
    last_angle = (math.pi/2) - atan
    x = (c*math.sin(atan))/math.sin(math.pi/2)
    y = (c*math.sin(last_angle))/math.sin(math.pi/2)
    return x, y
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
    -- render head
    love.graphics.circle("fill", snake[1][1], snake[1][2], snake_radius)
    -- render body
    if #snake > 1 then
        for i=2, #snake do
            love.graphics.circle("line", snake[i][1], snake[i][2], snake_radius)
        end
    end
end