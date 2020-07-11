player = {}
player.speed = 5
player.width = 60
player.height = 90
player.dx = 0
player.dy = 0
player.projectiles = {}

player.collider = world:newCircleCollider(720, 300, 20)
player.collider:setMass(10)

spriteSheet = love.graphics.newImage('assets/images/spritesheet2.png')
spriteSheet:setFilter("nearest", "nearest")

fire = love.graphics.newImage('assets/images/fire.png')
fire:setFilter("nearest", "nearest")

player.grids = {}
player.grids.walk = anim8.newGrid(player.width, player.height,
                                  spriteSheet:getWidth(),
                                  spriteSheet:getHeight())

player.animations = {}
player.animations.idle = anim8.newAnimation(player.grids.walk('1-4', 1), 0.2)
player.animations.forward = anim8.newAnimation(
                                player.grids.walk('5-6', 1, '1-6', 2), 0.075)
player.animations.right = anim8.newAnimation(
                              player.grids.walk('2-6', 3, '1-1', 4), 0.11)
player.animations.left = anim8.newAnimation(
                             player.grids.walk('2-6', 3, '1-1', 4), 0.11)
player.anim = player.animations.idle

function player:update(dt)
    handleMovement(dt)
    handleProjectiles(dt)
end

function player:draw()
    drawPlayer()
    drawProjectiles()
end

function handleMovement(dt)
    player.anim:update(dt)

    local dx, dy = 0, 0

    if input:down('left') then
        dx = dx - 1
        player.anim = player.animations.left
    end
    if input:down('right') then
        dx = dx + 1
        player.anim = player.animations.right
    end
    if input:down('up') then
        dy = dy - 1
        player.anim = player.animations.forward
    end
    if input:down('down') then
        dy = dy + 1
        player.anim = player.animations.forward
    end

    local length = 1
    if dx ~= 0 and dy ~= 0 then length = math.sqrt(dx ^ 2 + dy ^ 2) end
    dx, dy = dx / length, dy / length

    if dx > 0 then dx = math.floor(dx * player.speed) end
    if dy > 0 then dy = math.floor(dy * player.speed) end
    if dx < 0 then dx = math.ceil(dx * player.speed) end
    if dy < 0 then dy = math.ceil(dy * player.speed) end

    player.dx = dx
    player.dy = dy

    player.collider:setLinearVelocity(dx * 50, dy * 50)

    if dx == 0 and dy == 0 then player.anim = player.animations.idle end
end

function handleProjectiles(dt)
    if input:pressed('m1') then
        projectile = {
            collider = world:newCircleCollider(player.collider:getX() - 25,
                                               player.collider:getY(), 10)
        }
        projectile.collider:setFriction(0)
        table.insert(player.projectiles, projectile)
    end

    if input:down('m1') then
        for i, p in ipairs(player.projectiles) do
            p.collider:setAngle(p.collider:getAngle() - .1)
            mouseX, mouseY = love.mouse.getPosition()
            offsetX, offsetY = 0, 0

            -- Calculates the angle that the mouse is making with the fire i.e. how much the fire needs to revolve
            -- around the player to get to the mouse
            angle = math.atan2(p.collider:getY() - player.collider:getY(),
                               p.collider:getX() - player.collider:getX()) -
                        math.atan2(mouseY - 360, mouseX - 640)

            -- Rounds for floating point imprecision
            if (angle > 0 and angle < 0.01) or (angle < 0 and angle > -0.01) then
                angle = 0
            end

            -- Finds minimum angle, since atan calculation only considers one revolution direction
            if math.abs(angle) > math.pi then
                if angle < 0 then
                    angle = angle + 2 * math.pi
                else
                    angle = angle - 2 * math.pi
                end
            end

            -- Revolves the fire counterclockwise or clockwise depending on angle
            if angle > 0 then
                sin = math.sin(0.01)
                cos = math.cos(0.01)

                diffX = p.collider:getX() - player.collider:getX()
                diffY = p.collider:getY() - player.collider:getY()

                offsetX = diffX - (diffX * cos - diffY * sin)
                offsetY = diffY - (diffX * sin + diffY * cos)
            end

            if angle < 0 then
                sin = math.sin(-0.01)
                cos = math.cos(-0.01)

                diffX = p.collider:getX() - player.collider:getX()
                diffY = p.collider:getY() - player.collider:getY()

                offsetX = diffX - (diffX * cos - diffY * sin)
                offsetY = diffY - (diffX * sin + diffY * cos)
            end
            
            -- Fire needs to follow player dx and dy and then offset is caused by mouse movement
            p.collider:setLinearVelocity(player.dx * 50 + offsetX * 150,
                                         player.dy * 50 + offsetY * 150)
        end
    end

    if input:released('m1') then
        for i, p in ipairs(player.projectiles) do
            p.collider:destroy()
            table.remove(player.projectiles, i)
        end
    end
end

function drawPlayer()
    local sx = 1
    if player.anim == player.animations.left then sx = -1 end
    player.anim:draw(spriteSheet, player.collider:getX(),
                     player.collider:getY(), nil, sx, 1, player.width / 2,
                     player.height / 1.5)
end

function drawProjectiles()
    for i, p in ipairs(player.projectiles) do
        love.graphics.draw(fire, p.collider:getX(), p.collider:getY(),
                           p.collider:getAngle(), 1, 1, 10, 10)
    end
end
