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

cam={x=0,y=0}
    
function draw()
    bg(.2 +.8 *( t     *.1 *.2) %1, 
       .2 +.8 *((t+16) *.1 *.2) %1, 
       .2 +.8 *((t+24) *.1 *.2) %1, 
       1)
    fg(.15+.3, 
              .15+.4, 
                     .2+.6,
                            1)
    bg(.2+.55,
              1,.2+.55,1)
    --lg.printf('🌍ABD/?.-🌸24💮🏵45🌹🥀🌺🌻🌼🌷🌱🎂🛍🐉🎅🦠🕯🐰🎥🍂👨💪🎓🔥🎃🕎💕🕉👩🎊🏊👑☪🌱☘☀🏈🦃💘👰⛄🎿🏡⚽🌎🦦🦨🦘🦡🐾🦃🐔🐓🐣🐤🐥🐦🐧🕊🦅🦆🦢🦉🦩 Flamingo',16,16,sw)
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

    fg(palettes[8])
    --for k,v in pairs(map) do
    for py=cam.y,cam.y+12-1 do
    for px=cam.x,cam.x+24-1 do
        if not (px==😋.x and py==😋.y) and not (py==0 and px<cam.x+utf8.len(header.msg)) then
        local v=map[posstr(px,py)]
        if v then
        if dex_pal[v[1]] then fg(dex_pal[v[1]])
        else fg(palettes[8]) end
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
    lg.setFont(hoverfon)
    gridprint(header.msg)
    lg.setFont(emojifon)
    fg(dex_pal['😋'])
    lg.print('😋',16+(😋.x-cam.x)*64,16+(😋.y-cam.y)*(64+11))

    if love.update==dialogue then
        local r,g,b,a=lg.getColor()
        for dy=8,12-1 do
        for dx=0,24-1 do
            fg(0.2,0.2,0.6)
            rect('fill',16+dx*64,16+dy*(64+11),64,64+11)
            gridprint(cur_diag[cur_diag.i][1],1,9,true)
        end
        end
        fg(r,g,b,a)
    end
end

function gridprint(msg,mx,my,diag)
    mx=mx or 0
    my=my or 0
    mx=mx*64
    my=my*(64+11)
    local ed=utf8.len(msg)
    if diag then ed=utf8.len(utf8.sub(msg,1,cur_diag[cur_diag.i].j)) end
    for i=1,ed do
        fg(palettes[8])
        lg.setFont(hoverfon)
        local g=utf8.sub(msg,i,i)
        if dex_pal[g] then fg(dex_pal[g])
        else fg(palettes[8]) end
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
            local mw=16*2+64*24-64
            if diag then mw=mw-64 end
            if mx+utf8.len(nextword)*64>=mw then if diag then mx=64 else mx=0 end; my=my+64+11 end
        end
    end
end

love.draw= draw