function love.conf(t)
    t.console = true
    
    score = 0    
    score_colour = {0.6039215686274509, 
                    0.5098039215686274, 
                    0.6509803921568628}

    window_conf()
	snake_conf()
	food_conf()
end

function window_conf()
    window_height = 500
    window_width = 800
end

function snake_conf()
	snake_speed = 200
    snake_radius = 8
    snake_colour =  {79/255, 114/255, 111/255}
    snake_head_width = 1.5
    snake_width = 1

    -- initialize snake
    x = window_width / 2
    y = window_height / 2
    snake = {
        {x, y},
        {x- 2 * snake_radius, y},
        {x - 4 * snake_radius, y}
    }
end

function food_conf()
    foods = {}
    food_alpha = 0.5
    food_fadein_speed = 0.30
    food_max_radius = 8
    food_min_radius = 4
    food_hitbox_buffer = 2
    food_animation_speed = 3
    food_interval = 5
    food_drop_rate = 500
    food_colours = {
        {0.8627450980392157, 0.7294117647058823, 0.4},
        {0.8627450980392157, 0.7294117647058823, 0.5333333333333333},
        {0.8627450980392157, 0.7294117647058823, 0.6666666666666666},
        {0.8627450980392157, 0.7294117647058823, 0.8},
        {0.8627450980392157, 0.7294117647058823, 0.9333333333333333}
    }
end