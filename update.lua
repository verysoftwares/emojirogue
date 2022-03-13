😋 = {'😋',x=20+6+2,y=3+1,hp=9}
turn=0

function update(hw_dt)
    --if tapped('r') then love.event.quit('restart') end
    local moved=false
    
    if tapped('c') then love.update=talkselect; shout('Chat with whom?') end

    if tapped(',') then 
        if map[posstr(😋.x,😋.y)] then
            ins(inventory,map[posstr(😋.x,😋.y)])
            map[posstr(😋.x,😋.y)]=nil
            shout(fmt('Picked up %s.',inventory[#inventory][1]))
        end
        moved=true
    end

    if tapped('p') then 
        if in_dungeon() then shout('Can\'t plant in the dungeon.')
        else 
            if map[posstr(😋.x,😋.y)] then shout('This space is occupied.') 
            else
            love.update=plantselect; shout('Plant what?') 
            if not plant_places[posstr(cam.x,cam.y)] then
                plant_places[posstr(cam.x,cam.y)]={}
            end
            end
        end
    end

    if tapped('t') then 
        throwtgt={}
        if rays then
        for i,v in ipairs(rays) do
            if map[v] and is_entity(map[v][1]) then
                ins(throwtgt,v)
            end
        end
        end
        if #throwtgt==0 then shout('No targets nearby.')
        else love.update=throwselect; 
        shout('Throw what and where?') 
        end
    end

    if not moved and not is_solid(posstr(😋.x,😋.y-1)) and (tapped('up') or tapped('kp8') or tapped('u'))    then if not 😋.webbed then 😋.y=😋.y-1 end; moved=true end
    if not moved and not is_solid(posstr(😋.x,😋.y+1)) and (tapped('down') or tapped('kp2') or tapped('n'))  then if not 😋.webbed then 😋.y=😋.y+1 end; moved=true end
    if not moved and not is_solid(posstr(😋.x-1,😋.y)) and (tapped('left') or tapped('kp4') or tapped('h'))  then if not 😋.webbed then 😋.x=😋.x-1 end; moved=true end
    if not moved and not is_solid(posstr(😋.x+1,😋.y)) and (tapped('right') or tapped('kp6') or tapped('k')) then if not 😋.webbed then 😋.x=😋.x+1 end; moved=true end
    if not moved and not is_solid(posstr(😋.x-1,😋.y-1)) and (tapped('kp7') or tapped('y')) then if not 😋.webbed then 😋.x=😋.x-1; 😋.y=😋.y-1 end; moved=true end
    if not moved and not is_solid(posstr(😋.x-1,😋.y+1)) and (tapped('kp1') or tapped('b')) then if not 😋.webbed then 😋.x=😋.x-1; 😋.y=😋.y+1 end; moved=true end
    if not moved and not is_solid(posstr(😋.x+1,😋.y-1)) and (tapped('kp9') or tapped('i')) then if not 😋.webbed then 😋.x=😋.x+1; 😋.y=😋.y-1 end; moved=true end
    if not moved and not is_solid(posstr(😋.x+1,😋.y+1)) and (tapped('kp3') or tapped('m')) then if not 😋.webbed then 😋.x=😋.x+1; 😋.y=😋.y+1 end; moved=true end

    if map[posstr(😋.x,😋.y)] and map[posstr(😋.x,😋.y)][1]=='🔽' and (love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')) and tapped('<') then
        cam.y=cam.y-12
        if map_empty() then
            cavegen()
        else 
            local sx,sy=strpos(map[posstr(😋.x,😋.y)].entry)
            😋.x=sx; 😋.y=sy
        end
        raycast()
    end
    if map[posstr(😋.x,😋.y)] and map[posstr(😋.x,😋.y)][1]=='🔼' and tapped('<') then
        cam.y=cam.y+12
        local sx,sy=strpos(map[posstr(😋.x,😋.y)].entry)
        😋.x=sx; 😋.y=sy
        raycast()
    end

    if moved and not 😋.webbed then
        end_turn()        
    elseif moved and 😋.webbed then
        if 😋.webbed<=0 then shout('You\'re no longer webbed.'); 😋[1]='😋'; 😋.webbed=nil
        else shout('You\'re still webbed!') end
        if 😋.webbed then 😋.webbed=😋.webbed-random(2) end
        
        entity_update()
        if in_dungeon() then raycast() end
    end

    t=t+1
end

function talkselect()
    for i,v in ipairs({{'up',0,-1},{'down',0,1},{'left',-1,0},{'right',1,0},{'kp8',0,-1},{'kp2',0,1},{'kp4',-1,0},{'kp6',1,0},{'kp7',-1,-1},{'kp9',1,-1},{'kp1',-1,1},{'kp3',1,1},{'u',0,-1},{'n',0,1},{'h',-1,0},{'k',1,0},{'y',-1,-1},{'i',1,-1},{'b',-1,1},{'m',1,1}}) do
    if tapped(v[1]) then
        local pos=posstr(😋.x+v[2],😋.y+v[3])
        if map[pos] then
            if map[pos].t then
                map[pos].t(map[pos]); header.msg=''
            else shout(fmt('You can\'t chat with a %s!',map[pos][1])); love.update=update end
        else shout('Nobody there to talk to.'); love.update=update end
    end
    end
    t=t+1
end

function start_dialogue(d)
    cur_diag=diag_db[d]
    cur_diag.i=1
    cur_diag[cur_diag.i].j=cur_diag[cur_diag.i].j or 1
    love.update=dialogue
end

function dialogue()
    if cur_diag[cur_diag.i].choice then
        if tapped('left')  then cur_diag[cur_diag.i].choice.i=cur_diag[cur_diag.i].choice.i-1 end
        if tapped('right') then cur_diag[cur_diag.i].choice.i=cur_diag[cur_diag.i].choice.i+1 end
        if cur_diag[cur_diag.i].choice.i<1 then cur_diag[cur_diag.i].choice.i=#cur_diag[cur_diag.i].choice end
        if cur_diag[cur_diag.i].choice.i>#cur_diag[cur_diag.i].choice then cur_diag[cur_diag.i].choice.i=1 end
    end
    if tapped('z') or tapped('return') then
        if cur_diag[cur_diag.i].j<utf8.len(cur_diag[cur_diag.i][1]) then
            cur_diag[cur_diag.i].j=utf8.len(cur_diag[cur_diag.i][1])
        else
            if not cur_diag[cur_diag.i].choice then
                cur_diag.i=cur_diag.i+1
                if not cur_diag[cur_diag.i] then love.update=update; return 
                else cur_diag[cur_diag.i].j=cur_diag[cur_diag.i].j or 1 end
            else
                cur_diag[cur_diag.i].choiceresult[cur_diag[cur_diag.i].choice[cur_diag[cur_diag.i].choice.i]]()
            end
        end
    end
    if t%3==0 then 
        if cur_diag[cur_diag.i].j<utf8.len(cur_diag[cur_diag.i][1]) then cur_diag[cur_diag.i].j=cur_diag[cur_diag.i].j+1 end
    end
    t=t+1
end

diag_db={
    ['baobab_craft']={
        {'🆎🅰🅾 🅱🅰🅾🅱🆎'},
        {'🅰🅾 🅱🅰🆎 🌱🅾🅱🅾🅱🅰',choice={i=1,'yes','no'},choiceresult={['yes']=function() love.update=craft end, ['no']=function() love.update=update end}},
    },
    ['baobab_boo']={{'🅱🅾🅾'}},
    ['baobab_oob']={{'🅾🅾🅱'}},
    ['baobab_abba']={{'🅰🅱🅱🅰'}},
    ['baobab_dungeon']={{'🅱🅾🅱🅾 🆎🅾⛰ 🅰🆎🅾🅱🅰🔽 🆎🅰 🅱🅰🅱🅱🅰🅾💰'}},
}

header={msg='Hello world!'}
function shout(msg)
    if t==header.t then header.msg=fmt('%s %s',header.msg,msg)
    else header.msg=msg end
    header.t=t
end

function craft()
    if tapped('escape') then love.update=update end

    if tapped('left')  then inventory.i=inventory.i-1 end
    if tapped('right') then inventory.i=inventory.i+1 end
    if inventory.i>#inventory then inventory.i=1 end
    if inventory.i<1 then inventory.i=#inventory end

    if tapped('z') and #inventory>0 and #craft_area<5 then 
        ins(craft_area,inventory[inventory.i])
        rem(inventory,inventory.i)
    end

    if tapped('return') then
        for k,r in pairs(dex_recipes) do
            queue=''
            for j,v in ipairs(craft_area) do
                queue=queue..v[1]
            end
            local rec=k
            while utf8.len(queue)>0 do
                local char=utf8.sub(queue,1,1)
                queue=utf8.sub(queue,2)
                local f=utf8.find(rec,char)
                if f then
                    rec=utf8.sub(rec,1,f-1)..utf8.sub(rec,f+1)
                    if utf8.len(rec)==0 then 
                        if utf8.len(queue)~=0 then goto failure
                        else
                        ins(inventory,deepcopy(r))
                        shout(fmt('Crafted %s!',r.name))
                        goto success
                        end
                    end
                else goto failure end
            end
            ::failure::
        end
        ins(inventory,deepcopy(dex_recipes['fail']))
        shout('Crafting failed!')

        ::success::
        craft_area={}
    end
    t=t+1
end

inventory={i=1,{'🌱'},{'🌱'},{'🌱'},{'🥀'},{'🌱'},{'🌱'},{'🥛'}}
craft_area={}

function raycast()
    rays={}
    for i=0,530-1 do
        local a=pi*2/530*i
        local rx=😋.x*64+16+32
        local ry=😋.y*(64+11)+16+32
        while AABB(rx,ry,1,1,cam.x*64+16,cam.y*(64+11)+16,64*24,(64+11)*12) do
            rx=rx+cos(a)*0.8
            ry=ry+sin(a)*0.8
            local tx,ty=flr((rx-16-32)/64),flr((ry-16-32)/(64+11))
            if map[posstr(tx,ty)] then
                --print(tx,ty,😋.x,😋.y,cam.x,cam.y)
                if not find(rays,posstr(tx,ty)) then ins(rays,posstr(tx,ty)) end
                if not find(memo,posstr(tx,ty)) then ins(memo,posstr(tx,ty)) end
                if not is_seethru(posstr(tx,ty)) then break end
            end
        end
    end
end
memo={}

function enemy_raycast(pos)
    print(fmt('nmy @ %s sees surroundings',pos))
    local ex,ey=strpos(pos)
    enemy_rays={}
    for i=0,530-1 do
        local a=pi*2/530*i
        local rx=ex*64+16+32
        local ry=ey*(64+11)+16+32
        while AABB(rx,ry,1,1,cam.x*64+16,cam.y*(64+11)+16,64*24,(64+11)*12) do
            rx=rx+cos(a)*0.8
            ry=ry+sin(a)*0.8
            local tx,ty=flr((rx-16-32)/64),flr((ry-16-32)/(64+11))
            if posstr(tx,ty)==posstr(😋.x,😋.y) then
                print(fmt('nmy spotted player @ %d:%d!',tx,ty))
                if not find(enemy_rays,posstr(tx,ty)) then ins(enemy_rays,posstr(tx,ty)) end
                enemy_pathfind(pos,posstr(😋.x,😋.y))
                return
            end
            if map[posstr(tx,ty)] and not (posstr(tx,ty)==pos) then
                --print(tx,ty,😋.x,😋.y,cam.x,cam.y)
                if not find(enemy_rays,posstr(tx,ty)) then ins(enemy_rays,posstr(tx,ty)) end
                if not is_seethru(posstr(tx,ty)) then break end
            end
        end
    end
end

function enemy_pathfind(pos,tgt)
    local out={{pos}}
    local tx,ty=strpos(tgt)
    for i,v in ipairs(out) do
        local px,py=strpos(v[1])
        if px==tx and py==ty then
            map[pos].path={}
            map[pos].state='located'
            print(fmt('nmy @ %s in state located',pos))
            local pathtile=v
            while pathtile do
                print(pathtile[1])
                ins(map[pos].path,1,pathtile[1])
                pathtile=pathtile.prev
            end
            rem(map[pos].path,1) -- because it is just the starting tile
            return
        end
        if px-1>=cam.x and is_seethru(posstr(px-1,py)) and not findany(out,posstr(px-1,py)) then ins(out,{posstr(px-1,py)}); out[#out].prev=v end
        if px-1>=cam.x and py-1>=cam.y and is_seethru(posstr(px-1,py-1)) and not findany(out,posstr(px-1,py-1)) then ins(out,{posstr(px-1,py-1)}); out[#out].prev=v end
        if py-1>=cam.y and is_seethru(posstr(px,py-1)) and not findany(out,posstr(px,py-1)) then ins(out,{posstr(px,py-1)}); out[#out].prev=v end
        if px+1<cam.x+24 and py-1>=cam.y and is_seethru(posstr(px+1,py-1)) and not findany(out,posstr(px+1,py-1)) then ins(out,{posstr(px+1,py-1)}); out[#out].prev=v end
        if px+1<cam.x+24 and is_seethru(posstr(px+1,py)) and not findany(out,posstr(px+1,py)) then ins(out,{posstr(px+1,py)}); out[#out].prev=v end
        if px+1<cam.x+24 and py+1<cam.y+12 and is_seethru(posstr(px+1,py+1)) and not findany(out,posstr(px+1,py+1)) then ins(out,{posstr(px+1,py+1)}); out[#out].prev=v end
        if py+1<cam.y+12 and is_seethru(posstr(px,py+1)) and not findany(out,posstr(px,py+1)) then ins(out,{posstr(px,py+1)}); out[#out].prev=v end
        if px-1>=cam.x and py+1<cam.y+12 and is_seethru(posstr(px-1,py+1)) and not findany(out,posstr(px-1,py+1)) then ins(out,{posstr(px-1,py+1)}); out[#out].prev=v end
    end
    print(fmt('..but the player was not found among %d positions?!',#out))
    print(fmt('%d:%d',tx,ty),findany(out,tgt))
end

function entity_update()
    for y=0,12-1 do
    for x=0,24-1 do
        local pos=posstr(cam.x+x,cam.y+y)
        if map[pos] and map[pos].f then map[pos].updated=false end 
    end
    end
    for y=0,12-1 do
    for x=0,24-1 do
        local pos=posstr(cam.x+x,cam.y+y)
        if map[pos] and map[pos].f and not map[pos].updated then map[pos].updated=true; map[pos].f(pos) end 
    end
    end
end

function throwselect()
    if tapped('escape') then love.update=update end

    if tapped('left')  then inventory.i=inventory.i-1 end
    if tapped('right') then inventory.i=inventory.i+1 end
    if inventory.i>#inventory then inventory.i=1 end
    if inventory.i<1 then inventory.i=#inventory end

    for i,v in ipairs(throwtgt) do
        if i>9 then break end
        if tapped(tostring(i)) then
            if inventory[inventory.i][1]=='🥛' then
                map[v].hp=map[v].hp-2
                shout(fmt('It hit the %s for 2 damage!',map[v][1]))
                if map[v].hp<=0 then map[v]=nil end
            elseif inventory[inventory.i][1]=='☕' then
                map[v].hp=map[v].hp+2
                if map[v].hp>dex_nmy[map[v][1]].maxhp then
                    map[v].hp=dex_nmy[map[v][1]].maxhp
                end
                shout(fmt('It healed the %s!',map[v][1]))
            else
                shout('It didn\'t do any damage.')
            end
            rem(inventory,inventory.i)
            end_turn()
            love.update=update
        end
    end
    t=t+1
end

function end_turn()
    header.msg=''

    local old_cam={x=cam.x,y=cam.y}
    if 😋.y>=cam.y+12 then cam.y=cam.y+12 end
    if 😋.x>=cam.x+24 then cam.x=cam.x+24 end
    if 😋.y<cam.y then cam.y=cam.y-12 end
    if 😋.x<cam.x then cam.x=cam.x-24 end
    if old_cam.x~=cam.x or old_cam.y~=cam.y then
        if plant_places[posstr(old_cam.x,old_cam.y)] then
            plant_places[posstr(old_cam.x,old_cam.y)].leftturn=turn
        end
        if plant_places[posstr(cam.x,cam.y)] and plant_places[posstr(cam.x,cam.y)].leftturn and plant_places[posstr(cam.x,cam.y)].sc_turn then
            for i=plant_places[posstr(cam.x,cam.y)].leftturn,turn do
                if (i-plant_places[posstr(cam.x,cam.y)].sc_turn)%10==0 then
                    plant_update()
                end
            end
            plant_places[posstr(cam.x,cam.y)].leftturn=nil
        end
    end

    entity_update()
    if not in_dungeon() and plant_places[posstr(cam.x,cam.y)] and plant_places[posstr(cam.x,cam.y)].sc_turn and turn-plant_places[posstr(cam.x,cam.y)].sc_turn>0 and (turn-plant_places[posstr(cam.x,cam.y)].sc_turn)%10==0 then
        print(plant_update)
        plant_update()
    end

    if in_dungeon() then raycast() end

    turn=turn+1
end

plant_places={}

function plantselect()
    if tapped('escape') then love.update=update end

    if tapped('left')  then inventory.i=inventory.i-1 end
    if tapped('right') then inventory.i=inventory.i+1 end
    if inventory.i>#inventory then inventory.i=1 end
    if inventory.i<1 then inventory.i=#inventory end

    if tapped('return') then
        map[posstr(😋.x,😋.y)]={inventory[inventory.i][1]}
        rem(inventory,inventory.i)
        love.update=update
        if not plant_places[posstr(cam.x,cam.y)].sc_turn then
            plant_places[posstr(cam.x,cam.y)].sc_turn=turn
        end
        end_turn()
        shout('')
    end

    t=t+1
end

function plant_update()
    map_buffer={}
    plants={}
    for y=0,12-1 do
    for x=0,24-1 do
        local pos=posstr(x,y)
        if map[posstr(cam.x+x,cam.y+y)] then map_buffer[pos]=map[posstr(cam.x+x,cam.y+y)][1]
        if is_plant(map_buffer[pos]) and not find(plants,map_buffer[pos]) then
            ins(plants,map_buffer[pos])
        end
        end
    end
    end
    table.sort(plants,function(a,b) return find(dex[1],a)<find(dex[1],b) end)
    for i,v in ipairs(plants) do
    for y=0,12-1 do
    for x=0,24-1 do
        local neigh=neighbours(posstr(x,y))
        if map_buffer[posstr(x,y)]==v then
            if v=='🌱' and #neigh<2 or #neigh>3 then
                map[posstr(cam.x+x,cam.y+y)]=nil
                print(posstr(cam.x+x,cam.y+y))
            end
        end
        if not map_buffer[posstr(x,y)] then
            if findmap(neigh,v) then
                print(#neigh)
                if v=='🌱' and #neigh==3 then
                    map[posstr(cam.x+x,cam.y+y)]={'🌱'}
                end
            end
        end
    end
    end    
    end
end

function findmap(tbl,id)
    for i,v in ipairs(tbl) do
        if map_buffer[v]==id then
            return true
        end
    end
    return false
end

function neighbours(pos)
    local px,py=strpos(pos)
    out={}
    if map_buffer[posstr(px-1,py)] then ins(out,posstr(px-1,py)) end
    if map_buffer[posstr(px-1,py-1)] then ins(out,posstr(px-1,py-1)) end
    if map_buffer[posstr(px,py-1)] then ins(out,posstr(px,py-1)) end
    if map_buffer[posstr(px+1,py-1)] then ins(out,posstr(px+1,py-1)) end
    if map_buffer[posstr(px+1,py)] then ins(out,posstr(px+1,py)) end
    if map_buffer[posstr(px+1,py+1)] then ins(out,posstr(px+1,py+1)) end
    if map_buffer[posstr(px,py+1)] then ins(out,posstr(px,py+1)) end
    if map_buffer[posstr(px-1,py+1)] then ins(out,posstr(px-1,py+1)) end
    return out
end

love.update= update