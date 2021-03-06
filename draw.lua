-- draw setup
    lg.setDefaultFilter('nearest')

tstwrld=''
--for i=1,13*6 do tstwrld=tstwrld..dex[1][(i-1)%#dex[1]+1] end

    local pal={.15+.3,.15+.4,.2+.6}
palettes={
    {.45,.45,.45},
    {.45,.55,.45},
    {.45,.45,.55},
    {.55,.45,.45},
--    {.55,.45,.55},
    {.45,.55,.55},
--    {.45,.45,.80},
    {.45,.55,.80},
    {.55,.45,.80},
    {.55,.55,.80},
    {.55,.80,.80},
    {.45,.80,.80},
    {.45,.80,.55},
    {.45,.80,.45},
    {.55,.80,.45},
    {.55,.80,.55},
    {.55,.55,.45},
    {.55,.55,.55},
    {.80,.45,.55},
    {.80,.45,.45},
    {.80,.55,.45},
--    {.80,.55,.55},
    {.80,.80,.55},
    {.80,.80,.45},
    {.80,.45,.80},
    {.80,.80,.80},
    {.80,.55,.80},
}
--for i=1,13*6 do ins(palettes,{randomchoice(pal),randomchoice(pal),randomchoice(pal)}) end

cam={x=24,y=0}
    
function draw()
    bg(.2 +.8 *( t     *.1 *.2) %1, 
       .2 +.8 *((t+16) *.1 *.2) %1, 
       .2 +.8 *((t+24) *.1 *.2) %1, 
       1)
    fg(.15+.3, 
              .15+.4, 
                     .2+.6,
                            1)
    bgcolor={.2+.55,1,.2+.55}
    bg(bgcolor)
    --lg.printf('๐ABD/?.-๐ธ24๐ฎ๐ต45๐น๐ฅ๐บ๐ป๐ผ๐ท๐ฑ๐๐๐๐๐ฆ ๐ฏ๐ฐ๐ฅ๐๐จ๐ช๐๐ฅ๐๐๐๐๐ฉ๐๐๐โช๐ฑโโ๐๐ฆ๐๐ฐโ๐ฟ๐กโฝ๐๐ฆฆ๐ฆจ๐ฆ๐ฆก๐พ๐ฆ๐๐๐ฃ๐ค๐ฅ๐ฆ๐ง๐๐ฆ๐ฆ๐ฆข๐ฆ๐ฆฉ Flamingo',16,16,sw)
    local cx,cy= 0,0
    for c=1,utf8.len(tstwrld) do
    lg.setFont(emojifon)
        fg(palettes[(c-1)%#palettes+1][1],
           palettes[(c-1)%#palettes+1][2],
           palettes[(c-1)%#palettes+1][3],
           1)
        lg.print(utf8.sub(tstwrld,c,c),16+cx,16+cy)
        --lg.setFont(hoverfon)
        --lg.print(fmt('%2x%2x%2x',palettes[(c-1)%#palettes+1][1]*255,palettes[(c-1)%#palettes+1][2]*255,palettes[(c-1)%#palettes+1][3]*255),16+cx+8,16+cy+64)

    cx=cx+64; if c>1 and c%13==0 then cx=0; cy=cy+64+11 end
    end

    if in_dungeon() then bgcolor={0.4,0.2,0.2}; bg(bgcolor) end

    fg(palettes[8])
    --for k,v in pairs(map) do
    for py=cam.y,cam.y+12-1 do
    for px=cam.x,cam.x+24-1 do
        if not (px==๐.x and py==๐.y) then--and not (py==cam.y and px<cam.x+utf8.len(header.msg)) then
        local v=map[posstr(px,py)]
        if v and (not in_dungeon() or (in_dungeon() and (find(rays,posstr(px,py)) or (find(memo,posstr(px,py)) and not is_entity(v[1]))))) then
        if dex_pal[v[1]] then fg(dex_pal[v[1]])
        else fg(palettes[8]) end
        if in_dungeon() and find(memo,posstr(px,py)) and not find(rays,posstr(px,py)) then fg(0.2,0.2,0.2) end
        if emojifon:hasGlyphs(v[1]) then
        lg.setFont(emojifon)
        lg.print(v[1], 16+(px-cam.x)*64, 16+(py-cam.y)*(64+11))
        else
        lg.setFont(emojifon2)
        lg.print(v[1], 16+(px-cam.x)*64, 16+(py-cam.y)*(64+11)-5)
        end
        end
        end
    end
    end
    lg.setFont(emojifon)
    if dex_pal[๐[1]]~=nil then
    fg(dex_pal[๐[1]])
    end
    lg.print(๐[1],16+(๐.x-cam.x)*64,16+(๐.y-cam.y)*(64+11))
    lg.setFont(hoverfon)
    gridprint(header.msg)
    
    if love.update==throwselect then
        if throwtgt then
        for i,k in ipairs(throwtgt) do
            if i>9 then break end
            if (t+i*8)%48<32 then
            local kx,ky=strpos(k)
            fg(bgcolor)
            rect('fill',16+(kx-cam.x)*64,16+(ky-cam.y)*(64+11),64,64+11)
            fg(0.8,0.8,0.8)
            gridprint(tostring(i),kx-cam.x,ky-cam.y,false,true)
            end
        end
        end
        for dx=0,24-1 do
            fg(0.8,0.8,0.8)
            if dx==inventory.i-inventory.cam+1 then fg(0.4,0.8,0.4) end
            rect('fill',16+dx*64,16+11*(64+11),64,64+11)
        end
        for i=inventory.cam,inventory.cam+22-1 do
            local v=inventory[i]
            if v then
            gridprint(v[1],i-inventory.cam+1,11,false,true)
            else break end
        end
        gridprint(fmt('HP: %d/9',๐.hp),๐.x-cam.x-3,๐.y-cam.y+1)
    end

    if love.update==quaffselect then
        for dx=0,24-1 do
            fg(0.8,0.8,0.8)
            if dx==inventory.i-inventory.cam+1 then fg(0.4,0.8,0.4) end
            rect('fill',16+dx*64,16+11*(64+11),64,64+11)
        end
        for i=inventory.cam,inventory.cam+22-1 do
            local v=inventory[i]
            if v then
            gridprint(v[1],i-inventory.cam+1,11,false,true)
            else break end
        end
        gridprint(fmt('HP: %d/9',๐.hp),๐.x-cam.x-3,๐.y-cam.y+1)
    end

    if love.update==plantselect then
        for dy=8,12-1 do
        for dx=0,24-1 do
            fg(0.2,0.2,0.6)
            rect('fill',16+dx*64,16+dy*(64+11),64,64+11)
        end
        end
        fg(0.8,0.8,0.8)
        if find(dex[1],inventory[inventory.i][1]) then gridprint(dex_plantrules[inventory[inventory.i][1]],1,8,false,true) end
        for dx=0,24-1 do
            fg(0.8,0.8,0.8)
            if dx==inventory.i-inventory.cam+1 then fg(0.4,0.8,0.4) end
            rect('fill',16+dx*64,16+11*(64+11),64,64+11)
        end
        for i=inventory.cam,inventory.cam+22-1 do
            local v=inventory[i]
            if v then
            gridprint(v[1],i-inventory.cam+1,11,false,true)
            else break end
        end

    end

    if love.update==dialogue then
        local r,g,b,a=lg.getColor()
        for dy=8,12-1 do
        for dx=0,24-1 do
            fg(0.2,0.2,0.6)
            rect('fill',16+dx*64,16+dy*(64+11),64,64+11)
        end
        end
        fg(palettes[8])
        gridprint(cur_diag[cur_diag.i][1],1,9,true)
        if cur_diag[cur_diag.i].choice and cur_diag[cur_diag.i].j==utf8.len(cur_diag[cur_diag.i][1]) then
            local len=1
            for i,v in ipairs(cur_diag[cur_diag.i].choice) do
                len=len+utf8.len(v)+1
            end
            local l=0
            for i,v in ipairs(cur_diag[cur_diag.i].choice) do
                local rv=v
                if i==cur_diag[cur_diag.i].choice.i then
                    rv=fmt('[%s]',v)
                end
                gridprint(rv,12-flr(len/2)+l,11,true)
                l=l+utf8.len(rv)+1
            end
        end
        fg(r,g,b,a)
    end

    if love.update==craft then
        local r,g,b,a=lg.getColor()
        for dy=1,12-1 do
        for dx=0,24-1 do
            if dy~=7 then
            fg(0.2,0.2,0.6)
            if (dy==9 and dx>0 and dx<=5) or dy==11 or dy==1 then fg(0.8,0.8,0.8) end
            if dy==8 then fg(palettes[8]) end
            if dy==11 and dx==inventory.i-inventory.cam+1 then fg(0.4,0.8,0.4) end
            rect('fill',16+dx*64,16+dy*(64+11),64,64+11)
            end
        end
        end
        gridprint('๐ฑx3 Potion of Hurt',1,2,false,true)
        gridprint('๐ฑx2๐ฅx1 SmolHeal Potion',1,3,false,true)
        gridprint('๐ฑx1๐ทx2 Poison Potion',1,4,false,true)
        gridprint('๐ฑx2๐นx2 Corrosion Potion',1,5,false,true)
        gridprint('๐ฑx1๐ฅx1โx2 Warp Potion',1,6,false,true)
        for i,v in ipairs(craft_area) do
            gridprint(v[1],i,9,true)
        end
        for i=inventory.cam,inventory.cam+22-1 do
            local v=inventory[i]
            if v then
            gridprint(v[1],i-inventory.cam+1,11,true)
            else break end
        end
        fg(0.2,0.2,0.6)
        gridprint('Craft:',1,8,true,true)
        gridprint('Recipes:',1,1,true,true)
        fg(r,g,b,a)
    end

    if love.update==gameover then
        for dy=7,12-1 do
        for dx=0,24-1 do
            fg(0.2,0.2,0.6)
            rect('fill',16+dx*64,16+dy*(64+11),64,64+11)
        end
        end
        fg(0.8,0.8,0.8)
        gridprint(fmt('Seed: %d',seed),1,7,false,true)
        gridprint(fmt('Turns taken: %d',turn),1,8,false,true)
        gridprint(fmt('Enemies withered: %d',withered),1,9,false,true)
        gridprint(fmt('Potions crafted: %d',crafted),1,10,false,true)
        gridprint('R to reset.',1,11,false,true)
    end
end

function gridprint(msg,mx,my,diag,setcolor)
    mx=mx or 0
    my=my or 0
    mx=mx*64
    my=my*(64+11)
    local ed=utf8.len(msg)
    if diag then ed=utf8.len(utf8.sub(msg,1,cur_diag[cur_diag.i].j)) end
    for i=1,ed do
        --fg(palettes[8])
        lg.setFont(hoverfon)
        local g=utf8.sub(msg,i,i)
        if not diag and not setcolor then
            fg(bgcolor)
            rect('fill',16+mx,16+my,64,64+11)
        end
        if dex_pal[g] then fg(dex_pal[g])
        else if not setcolor then fg(palettes[8]) end end
        if hoverfon:hasGlyphs(g) then
        lg.print(g,mx+48-hoverfon:getWidth(g)/2,my+7)
        elseif emojifon:hasGlyphs(g) then
        lg.setFont(emojifon)
        lg.print(g,16+mx,16+my)
        else
        lg.setFont(emojifon2)
        lg.print(g,16+mx,16+my-5)
        end
        mx=mx+64
        if g==' ' then 
            local nextword=utf8.sub(msg,i+1,utf8.find(msg,' ',i+1))
            local mw=16*2+64*24
            if diag then mw=mw-64 end
            if mx+utf8.len(nextword)*64>=mw then if diag then mx=64 else mx=0 end; my=my+64+11 end
        end
    end
end

love.draw= draw