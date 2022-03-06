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
    for k,v in pairs(map) do
        local px,py= strpos(k)
        if not (px==elf.x and py==elf.y) and not (py==0 and px<#'Hello world!') then
        lg.print(dex[1][flr(v*#dex[1])+1], 16+px*64, 16+py*(64+11))
        end
    end
    lg.setFont(hoverfon)
    gridprint('Hello world!')
    lg.setFont(emojifon)
    lg.print('😋',16+elf.x*64,16+elf.y*(64+11))
end

function gridprint(msg,mx,my)
    mx=mx or 0
    my=my or 0
    mx=mx*64
    my=my*(64+11)
    for i=1,#msg do
        lg.print(sub(msg,i,i),mx+48-hoverfon:getWidth(sub(msg,i,i))/2,my+7)
        mx=mx+64
        if mx>=16*2+64*24-64 then mx=0; my=my+64+11 end
    end
end

love.draw= draw