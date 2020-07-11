function init()
    Input = require 'lib/input/Input'
    anim8 = require "lib/anim8/anim8"
    Camera = require "lib/hump/camera"
    local windfield = require("lib/windfield")
    world = windfield.newWorld()

    love.window.setTitle("Demo")

    cursor = love.mouse.newCursor('assets/images/crosshair.png', 21, 21)
    love.mouse.setCursor(cursor)

    background = love.graphics.newImage('assets/images/background.png')
    love.graphics.setBackgroundColor(28 / 255, 27 / 255, 33 / 255, 1)
    -- background:setFilter("nearest", "nearest")

    input = Input()
    input:bind('w', 'up')
    input:bind('a', 'left')
    input:bind('s', 'down')
    input:bind('d', 'right')
    input:bind('mouse1', 'm1')
    input:bind('mouse2', 'm2')

    require('src/player')
    require('src/entities/dummy')
end
