function love.conf(t)
	t.console = true
	window_conf()
	snake_conf()
	food_conf()
end

function window_conf()
	window_width = 400
	window_height = 250
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
    food_radius = 5
    food_timer = 0
    food_interval = 5
    foods = {}
end