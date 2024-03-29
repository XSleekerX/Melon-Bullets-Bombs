---@type Plugin
local plugin = ...
plugin.name = 'Melon bullets'
plugin.author = 'sans'
plugin.description = 'Makes bullets watermelons'



local melonbullets


plugin.commands['/melonbullets'] = {
  info = 'Turns on melon bullets',
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
    if melonbullets == true and bullet.player.isBot == false then
        local itm = items.create(itemTypes.getByName("Watermelon"), bullet.pos, yawToRotMatrix(bullet.player.human.viewYaw))
        itm.rigidBody.vel:add(Vector(bullet.vel.x / 50, (bullet.vel.y / 80)+0.12, bullet.vel.z / 50))
        itm.data.isBulletMelon = true
        if itm then
        itm.data.melonBomb = true
        itm.data.melonFuse = 188
    end
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

plugin:addHook('Logic', function()
 for _, itm in ipairs(items.getAll()) do
        if itm.data.melonBomb then
 			if itm.data.melonFuse == 0 then
                events.createExplosion(itm.pos)
events.createSound(48, itm.pos, 10.0, 0.25) 
                itm:explode()
				itm:speak("Boom", 2)	
			    itm:remove()
            else
				if itm.data.melonFuse % 63 == 0 then 
               		itm:speak(math.ceil(itm.data.melonFuse*1.5873015873) / 100, 1) 
				end
                itm.data.melonFuse = itm.data.melonFuse - 1
              end
		end
	end
end)
end
