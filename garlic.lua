--[[

MIT License

Copyright (c) 2024 blarg!

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]

local garlic = { _VERSION = '1' }

function garlic.newActor(spritesheet)

    local spritesheet = spritesheet

    local AvailableAnimations = {}

    local actor = {}
    function actor.getSpritesheet() return spritesheet end

    function actor.attachAnimation(anim)
        assert(not AvailableAnimations[anim.id], 'Animation w/ same ID already exists.')

        local newAnim = {}
        newAnim.priority,newAnim.speed,newAnim.loop,newAnim.loopback = anim.priority,anim.speed,anim.loop,anim.loopback
        newAnim.playing = false

        newAnim.frames = {}
        newAnim.currentFrame = 1

        for k,v in pairs(anim.frames) do
            newAnim.frames[k] = love.graphics.newQuad(v.x,v.y,v.w,v.h,spritesheet:getWidth(),spritesheet:getHeight())
        end

        AvailableAnimations[anim.id] = newAnim
        return newAnim
    end

    function actor.playAnimation(id)
        local Anim = AvailableAnimations[id]

        Anim.playing = true
        Anim.currentFrame = 1
    end
    function actor.resumeAnimation(id)
        AvailableAnimations[id].playing = true
    end
    function actor.stopAnimation(id)
        local Anim = AvailableAnimations[id]

        Anim.playing = false
        Anim.currentFrame = 1
    end
    function actor.pauseAnimation(id)
        AvailableAnimations[id].playing = false
    end
    function actor.getAnimation(id)
        return AvailableAnimations[id]
    end
    function actor.getAnimations()
        return AvailableAnimations
    end

    function actor.update(dt)
        for k,v in pairs(AvailableAnimations) do
            if v.playing then
                v.currentFrame = v.currentFrame + (v.speed*dt)

                if v.currentFrame >= (#v.frames + 1) then
                    if v.loopback then
                        v.currentFrame = 1
                        v.playing = false
                    elseif v.loop then
                        v.currentFrame = 1
                        v.playing = true
                    else
                        v.currentFrame = #v.frames
                        v.playing = false
                    end
                end
            end
        end
    end

    function actor.draw(fallbackAnim,...)
        local ChosenAnimationToDraw = nil
        local currentPriority = nil
        for k,v in pairs(AvailableAnimations) do
            if v.playing then
                if not ChosenAnimationToDraw and not currentPriority then
                    ChosenAnimationToDraw = v
                    currentPriority = v.priority
                else
                    if currentPriority < v.priority then
                        ChosenAnimationToDraw,currentPriority = v,v.priority
                    end
                end
            end
        end

        if not ChosenAnimationToDraw then -- if the displayed animation is STILL nill, try to draw a fallback animation
            local fallback = AvailableAnimations[fallbackAnim]
            love.graphics.draw(spritesheet,fallback.frames[ math.floor(fallback.currentFrame) ], unpack({...}))
            return 0
        end
        -- otherwise, play the animation like normal
        love.graphics.draw(spritesheet,ChosenAnimationToDraw.frames[math.floor(ChosenAnimationToDraw.currentFrame)], unpack({...}))
        return 0
    end

    return actor

end

function garlic.newAnimation(id,priority,speed,loop,loopback)
    local animation = {}

    animation.frames = {}
    function animation.attachFrame(frame)
        local FrameIndex = #animation.frames + 1

        local newFrame = {}
        newFrame.x,newFrame.y,newFrame.w,newFrame.h = frame.x,frame.y,frame.w,frame.h

        animation.frames[FrameIndex] = newFrame
    end

    animation.id = id
    animation.priority = priority or 1
    animation.speed = speed or 1
    animation.loop = loop or false
    animation.loopback = loopback or false -- makes animation immediately go back to frame 1 when it finishes

    return animation
end

function garlic.newFrame(x,y,w,h)
    local frame = {}

    frame.x = x or 0
    frame.y = y or 0
    frame.w = w or 0
    frame.h = h or 0

    return frame
end

return garlic
