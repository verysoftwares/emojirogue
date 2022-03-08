function love.load()
    -- emoji font source:
    -- https://dn-works.com/ufas/
    -- for personal use only
    symbolfon= lg.newFont('wares/unifont-14.0.02.ttf', 64)
    --emojifon= lg.newFont('wares/EmojiOneColor.otf', 64)
    emojifon= lg.newFont('wares/TwitterColorEmoji-SVGinOT.ttf', 64)
    hoverfon= lg.newFont('wares/DaysOne-Regular.ttf', 64)
    lg.setFont(emojifon)
end