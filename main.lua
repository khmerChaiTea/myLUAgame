function love.load()
    camera = require 'libraries/camera'
    cam = camera()

    --help split grid for sheet to animate
    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")

    sti = require 'libraries/sti'
    gameMap = sti('maps/testMap.lua')

    -- {} mean that player is set to be an empty table
    player = {}
    player.x = 400
    player.y = 200
    player.speed = 5
    player.spriteSheet = love.graphics.newImage('sprites/player-sheet.png')
    --newGrid(frameWidth, frameHeight, imageWidth, imageHeight, left, top, border)
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animations = {}
    --newAnimation(frames, durations, onLoop)
    player.animations.down = anim8.newAnimation (player.grid('1-4', 1), 0.2)
    player.animations.left = anim8.newAnimation (player.grid('1-4', 2), 0.2)
    player.animations.right = anim8.newAnimation (player.grid('1-4', 3), 0.2)
    player.animations.up = anim8.newAnimation (player.grid('1-4', 4), 0.2)

    player.anim = player.animations.left

    background = love.graphics.newImage('sprites/background.png')
end

function love.update(dt)
    local isMoving = false

    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed
        player.anim = player.animations.right
        isMoving = true
    end

    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed
        player.anim = player.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("down") then
        player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end

    if isMoving == false then
        player.anim:gotoFrame(2)
    end

    player.anim:update(dt)

    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    --left border
    if cam.x < w/2 then
        cam.x = w/2
    end

    --top border
    if cam.y < h/2 then
        cam.y = h/2
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    --right border
    if cam.x > (mapW - w/2) then
        cam.x = (mapW - w/2)
    end

    --bottom border
    if cam.y > (mapH - h/2)then
        cam.y = (mapH - h/2)
    end

    
end

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["Ground"])
        gameMap:drawLayer(gameMap.layers["Trees"])
        --nil mean do not change rotation, after will be a scale
        --animations:draw(image, x,y, angle, sx, sy, ox, oy, kx, ky)
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 6, 9)
    cam:detach()
end