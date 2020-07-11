dummy = {}
dummy.width = 60
dummy.height = 66

dummy.collider = world:newCircleCollider(500, 360, 20)
dummy.collider:setType('static')
dummy.collider:setMass(100)

sprite = love.graphics.newImage('assets/images/dummy.png')
sprite:setFilter("nearest", "nearest")

function dummy:draw()
  love.graphics.draw(sprite, dummy.collider:getX(), dummy.collider:getY(), nil, 1, 1,
  dummy.width / 2, dummy.height / 1.7)
end