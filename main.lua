function love.load()
    love.window.setMode(window_width, window_height)
    love.graphics.setBackgroundColor{32/255, 42/255, 48/255}
    love.graphics.setFont(love.graphics.newFont(20))
end

function love.update(dt)
     register_movement(dt)
     eat_food()
     place_food(dt)
     animate_food(dt)
end

function love.draw()
    draw_score()
    draw_food()
    draw_snake()
end

function draw_score()
    love.graphics.setColor(score_colour)
    love.graphics.print(score, window_width - 50, 25)
end

function draw_food()    
    for i,food in ipairs(foods) do
        love.graphics.setColor(food[3])   
        love.graphics.setLineWidth(0.2)     
        love.graphics.circle("line", food[1], food[2], food[4])
    end
end

function draw_snake()
    love.graphics.setColor(snake_colour) -- remove alpha

    -- render head
    love.graphics.setLineWidth(snake_head_width)
    love.graphics.circle("line", snake[1][1], snake[1][2], snake_radius)

    -- render body
    love.graphics.setLineWidth(snake_width)     
    if #snake > 1 then
        for i=2, #snake do
            love.graphics.circle("line", snake[i][1], snake[i][2], snake_radius)
        end
    end
end

-- Food functions
function eat_food()
    for i,food in ipairs(foods) do
        if collides(snake[1], food, food_max_radius + food_max_radius * food_hitbox_buffer) then 
           score = score + 1 + math.floor(foods[i][4])-food_min_radius
           table.remove(foods, i)
           -- Todo: determine starting location for new body segment
           --       in more sophisticated way
           table.insert(snake,{x+2*snake_radius,y})
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
    time_to_eat = love.math.random(0, food_drop_rate) == 0

    if time_to_eat then 
        -- Randomly determine food colour and starting size
        food_colour = food_colours[love.math.random(#food_colours)]
        table.insert(food_colour, 0)
        food_size = math.random(food_max_radius / 2, food_max_radius)

        table.insert(foods, {love.math.random(food_max_radius, window_width - food_max_radius), 
                             love.math.random(food_max_radius, window_height - food_max_radius),
                             food_colour,
                             food_size,
                             1 -- multiplier for animation
                            }
                    )
    end
end

function animate_food(dt)
    for i, food in ipairs(foods) do
        -- animate fade-in
        current_alpha = food[3][4]
        if current_alpha < food_alpha then
            next_alpha = current_alpha + (dt * food_fadein_speed)
            if next_alpha < food_alpha then food[3][4] = next_alpha else food[3][4] = food_alpha end
        end

        -- animate size
        current_radius = food[4]
        next_radius = current_radius + (food[5] * food_animation_speed * dt)
        if next_radius < food_min_radius then 
            next_radius = food_min_radius + (food_min_radius - next_radius)
            food[5] = food[5] * -1  
        elseif next_radius > food_max_radius then 
            next_radius = food_max_radius - (next_radius - food_max_radius)
            food[5] = food[5] * -1
        end
        food[4] = next_radius
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
    hyp = math.sqrt((x * x) + ( y * y))
    c = hyp - (2 * snake_radius)
    last_angle = (math.pi / 2) - atan
    x = (c * math.sin(atan)) / math.sin(math.pi / 2)
    y = (c * math.sin(last_angle)) / math.sin( math.pi/2 )
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