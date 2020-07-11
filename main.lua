Input = require 'lib/input/Input'
anim8 = require "lib/anim8/anim8"
Camera = require "lib/hump/camera"

function love.load()
    require("src/init")
    init()
    wall1 = world:newRectangleCollider(390, 260, 528, 5)
    wall1:setType('static')
    wall2 = world:newRectangleCollider(383, 260, 5, 220)
    wall2:setType('static')
    wall3 = world:newRectangleCollider(390, 475, 528, 5)
    wall3:setType('static')
    wall4 = world:newRectangleCollider(918, 260, 5, 220)
    wall4:setType('static')
    cam = Camera(player.collider:getX(), player.collider:getY())
end

function love.update(dt)
    player:update(dt)
    world:update(dt)
    cam:lookAt(player.collider:getX(), player.collider:getY())
end

function love.draw()
    cam:attach()
    love.graphics.draw(background, 0, 0)

    if (player.collider:getY() > dummy.collider:getY()) then
        dummy:draw()
        player:draw()
    else
        player:draw()
        dummy:draw()
    end
    -- world:draw()
    cam:detach()
end
