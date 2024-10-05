-- credits to rvros for the spritesheet! (https://rvros.itch.io/animated-pixel-hero)

function love.load()
    -- disabling ugly blurs
    love.graphics.setDefaultFilter('nearest', 'nearest')

    garlic = require 'garlic'

    local adventurerFile = require 'assets.adventurer'
    adventurer = garlic.newActor( love.graphics.newImage('assets/adventurer-Sheet.png') )

    -- declaring idle animation
    local idleAnimation = garlic.newAnimation('idle',1,5,true,false)
    for _,v in pairs(adventurerFile.idle) do
        idleAnimation.attachFrame( garlic.newFrame(v.x, v.y, v.w, v.h) )
    end

    -- declaring moving animation
    local moveAnimation = garlic.newAnimation('move',2,10,true,false)
    for i,v in pairs(adventurerFile.moving) do
        local attachedFunc = nil

        if i == 2 or i == 5 then
            attachedFunc = function()
                print('Footstep')
            end
        end

        moveAnimation.attachFrame( garlic.newFrame(v.x, v.y, v.w, v.h, attachedFunc) )
    end

    -- declaring rolling animation
    local rollAnimation = garlic.newAnimation('roll',3,10,true,false)
    for _,v in pairs(adventurerFile.rolling) do
        rollAnimation.attachFrame( garlic.newFrame(v.x,v.y,v.w,v.h) )
    end

    -- declaring slashing animation
    local slashingAnimation = garlic.newAnimation('slashing',4,10,true,false)
    for i,v in pairs(adventurerFile.slashing) do
        local attachedFunc = nil
        if i == 7 then
            attachedFunc = function()
                print 'Slashing animation ended!'
            end
        end
        slashingAnimation.attachFrame( garlic.newFrame(v.x,v.y,v.w,v.h,attachedFunc) )
    end

    -- attaching those animations
    adventurer.attachAnimation(idleAnimation)
    adventurer.attachAnimation(moveAnimation)
    adventurer.attachAnimation(rollAnimation)
    adventurer.attachAnimation(slashingAnimation)

    -- play idle animation
    adventurer.playAnimation('idle')
end

function love.keypressed(key) -- switching between animations
    local keyToAnim = {
        ['1'] = 'idle',
        ['2'] = 'move',
        ['3'] = 'roll',
        ['4'] = 'slashing',
    }

    if keyToAnim[key] then
        local gotAnim = adventurer.getAnimation( keyToAnim[key] )

        if gotAnim.playing then
            adventurer.stopAnimation( keyToAnim[key] )
        else
            adventurer.playAnimation( keyToAnim[key] )
        end

    end
end

function love.update(dt)
    adventurer.update(dt)
end

local ramUsage = math.floor(collectgarbage('count'))
local recordRamUsage = ramUsage
function love.draw()
    adventurer.draw('idle',15,100,0,4,4)

    ramUsage = math.floor(collectgarbage('count'))
    if (ramUsage > recordRamUsage) then
        recordRamUsage = ramUsage
    end
    love.graphics.print('Press 1-4 to cycle between animations.\nFPS: ' .. love.timer.getFPS() .. '\nRAM Usage (kilobytes): ' .. ramUsage .. '\nRecord RAM Usage (kilobytes): ' .. recordRamUsage,5,5)
end
