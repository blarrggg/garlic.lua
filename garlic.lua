local module = {}
module._version = 1

function module.newActor(spritesheet)
    local spritesheet = spritesheet

    local AvailableAnimations = {}
    local methods = {}

    local DisplayingAnim = nil

    function methods.findAnimation(id)
        for k,v in pairs(AvailableAnimations) do
            if v.id == id then
                return v,k
            end
        end
    end

    function methods.destroyAnimation(id)
        local _,key = methods.findAnimation(id)
        table.remove(AvailableAnimations,key)
    end
    
    function methods.newAnimation(id)
        assert(not methods.findAnimation(id),'Animation with ID ' .. id .. ' already exists!')
        if not DisplayingAnim then DisplayingAnim = id end

        local Frames = {}

        local anim = {}

        function anim.newFrame(x,y,w,h)
            local nQuad = love.graphics.newQuad(x,y,w,h,spritesheet:getWidth(),spritesheet:getHeight())

            Frames[#Frames+1] = nQuad
            return nQuad
        end
        function anim.getFrames() return Frames end

        function anim.play()
            if DisplayingAnim then
                local oldAnim = methods.findAnimation(DisplayingAnim)
                if anim.priority > oldAnim.priority then
                    DisplayingAnim = anim.id
                end
            end

            anim.frame = 1
            anim.playing = true
        end

        anim.id = id
        anim.priority = 0
        anim.frame = 1
        anim.speed = 5
        anim.playing = false
        anim.looping = false
        anim.loopback = false -- should animation return to frame 0 when it is done? (only active if looping is false)

        return anim
    end

    function methods.update(dt)
        for k,v in pairs(AvailableAnimations) do
            if v.playing then
                v.frame = v.frame + (dt*v.speed)

                local crntFrames = #v.getFrames()
                if v.frame >= crntFrames then
                    if v.looping then
                        v.frame = 1
                        v.playing = true
                    elseif v.loopback then
                        v.frame = 1
                        v.playing = false
                    else
                        v.frame = crntFrames
                        v.playing = false
                    end
                end
            end
        end
    end

    function methods.draw(...)
        local DisplayingAnimation = methods.findAnimation(DisplayingAnim)
        love.graphics.draw(DisplayingAnimation.getFrames()[ math.floor(DisplayingAnimation.frame ) ],unpack({...}))
    end

    return methods
end

return module