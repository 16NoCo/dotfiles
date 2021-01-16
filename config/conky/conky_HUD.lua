settings_table = {
    {
        -- Edit this table to customise your rings.
        -- You can create more rings simply by adding more elements to settings_table.
        -- "name" is the type of stat to display; you can choose from 'cpu', 'memperc', 'fs_used_perc', 'battery_used_perc'.
        name='time',
        -- "arg" is the argument to the stat type, e.g. if in Conky you would write ${cpu cpu0}, 'cpu0' would be the argument. If you would not use an argument in the Conky variable, use ''.
        arg='%I.%M',
        -- "max" is the maximum value of the ring. If the Conky variable outputs a percentage, use 100.
        max=12,
        -- "bg_colour" is the colour of the base ring.
        bg_colour=0xFFFFFF,
        -- "bg_alpha" is the alpha value of the base ring.
        bg_alpha=0.1,
        -- "fg_colour" is the colour of the indicator part of the ring.
        fg_colour=0xFFFFFF,
        -- "fg_alpha" is the alpha value of the indicator part of the ring.
        fg_alpha=0.2,
        -- "x" and "y" are the x and y coordinates of the centre of the ring, relative to the top left corner of the Conky window.
        x=100, y=150,
        -- "radius" is the radius of the ring.
        radius=50,
        -- "thickness" is the thickness of the ring, centred around the radius.
        thickness=5,
        -- "start_angle" is the starting angle of the ring, in degrees, clockwise from top. Value can be either positive or negative.
        start_angle=0,
        -- "end_angle" is the ending angle of the ring, in degrees, clockwise from top. Value can be either positive or negative, but must be larger than start_angle.
        end_angle=360
    }
}


require 'cairo'

function conky_test()
    return 20
end

function draw_bar(cr,pct,x,y,dx,dy,w,r,g,b)
    cairo_move_to(cr,x,y+dy*pct)
    cairo_line_to(cr,x+dx,y+dy)
    cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
    cairo_set_line_width(cr,w)
    cairo_set_source_rgba(cr,r,g,b,0.7)
    cairo_stroke(cr)
end

function conky_main()
    if conky_window==nil then return end
    local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
    
    local cr=cairo_create(cs)
	xpos=268
	ypos=81
	height=155
	width=3
    
    str=string.format('${%s %s}', 'exec','amixer get Master | grep Mono: | cut -f2 -d[ | cut -f1 -d%')
    str=conky_parse(str)
    pct=tonumber(str)/100
	state=string.format('${%s %s}', 'exec','amixer get Master | grep Mono: | cut -f4 -d[ | cut -f1 -d]')
	state=conky_parse(state)
    draw_bar(cr,0,xpos,ypos,0,height,width,0.3,0.3,0.3)
	if state=='on' then
	    draw_bar(cr,1-pct*pct,xpos,ypos,0,height,width,0.8,0.8,0.8)
	end
end
