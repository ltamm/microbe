function love.conf(t)
	t.console = true
	window_conf()
	snake_conf()
	food_conf()
end

function window_conf()
	window_width = 800
	window_height = 500
end

function snake_conf()
	snake_speed = 200
	snake_radius = 8

    -- initialize snake
    x = window_width / 2
    y = window_height / 2
    snake = {
        {x, y},
        {x-2*snake_radius, y},
        {x-4*snake_radius, y}
    }
end

function food_conf()
    food_radius = 10
    food_timer = 0
    food_interval = 5
    foods = {}
    food_colours = {
        {0.8627450980392157, 0.7294117647058823, 0.4},
        {0.8627450980392157, 0.7294117647058823, 0.5333333333333333},
        {0.8627450980392157, 0.7294117647058823, 0.6666666666666666},
        {0.8627450980392157, 0.7294117647058823, 0.8},
        {0.8627450980392157, 0.7294117647058823, 0.9333333333333333}
    }
end