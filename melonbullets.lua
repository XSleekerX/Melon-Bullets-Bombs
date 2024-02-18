---@type Plugin
local plugin = ...
plugin.name = 'Melon bullets'
plugin.author = 'sans'
plugin.description = 'Makes bullets watermelons'



local melonbullets


plugin.commands['/melonbullets'] = {
  info = 'turns on melon bullets',
  canCall = function (ply) return ply.isAdmin end,
  ---@param ply Player
  call = function (ply)

        if melonbullets ~= true then 
            melonbullets = true 
            ply:sendMessage("Melon bullets enabled")
        elseif melonbullets == true then
            melonbullets = false
            ply:sendMessage("Melon bullets disabled")
        end 

  end
}


function plugin.hooks.PostBulletCreate(bullet)
    if melonbullets == true then 
        local itm = items.create(itemTypes.getByName("Watermelon"), bullet.pos, yawToRotMatrix(bullet.player.human.viewYaw), math.random(0,5))
        itm.rigidBody.vel:add(Vector(bullet.vel.x / 7, bullet.vel.y / 7, bullet.vel.z / 7))
        itm.data.isBulletMelon = true
    end


end       


function plugin.hooks.Logic()
    for _, itm in ipairs(items.getAll()) do
        if itm.data.isBulletMelon== true then

            if itm.data.bulTimer == nil then 
                itm.data.bulTimer = 0
            end
        end

        if itm.data.bulTimer ~= nil then 
            if tick == 59 then
                if itm.data.bulTimer <= 20 then
                    itm.data.bulTimer = itm.data.bulTimer + 1 
                end 

                if itm.data.bulTimer == 20 then 
                    itm:remove()
                end
            end
        end
    end



end