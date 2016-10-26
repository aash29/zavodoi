require "theme"
require "sprites"

compass_up_down = true

function draw_line(spr, x1, y1, x2, y2, color)
   local currentX, currentY, errorX, errorY, d, dx, dy, incX, incY

   dx = x2 - x1
   dy = y2 - y1
   errorX = 0
   errorY = 0

   if dx > 0 then
      incX = 1
   elseif dx == 0 then
      incX = 0
   else
      incX = -1
   end

   if dy > 0 then
      incY = 1
   elseif dy == 0 then
      incY = 0
   else
      incY = -1
   end

   dx = math.abs(dx)
   dy = math.abs(dy)

   if dy > dx then
      d = dy
   else
      d = dx
   end

   currentX = x1
   currentY = y1
   sprite.pixel(spr, currentX, currentY, color)

   while currentX ~= x2 and currentY ~= y2 do
      errorX = errorX + dx
      errorY = errorY + dy
      if errorX >= d then
	 errorX = errorX - d
	 currentX = currentX + incX
      end
      if errorY >= d then
	 errorY = errorY - d
	 currentY = currentY + incY
      end
      sprite.pixel(spr, currentX, currentY, color)
   end
end

function compass_init()
   local tfnt, tfnt_s, fnt, w, h, tmp
   tfnt = theme.get "inv.fnt.name"
   tfnt_s = sprite.font_scaled_size(theme.get "inv.fnt.size")
   if not compass_color then
      compass_color = theme.get "inv.col.link"
   end
   if not compass_acolor then
      compass_acolor = theme.get "inv.col.alink"
   end

   fnt = sprite.font(tfnt, tfnt_s)

   fs = math.floor(sprite.font_height(fnt))
   w, h = math.floor(sprite.text_size(fnt, "[W]"))

   if compass_in then
      ns = sprite.load(compass_in)
   else
      ns = sprite.blank(fs, fs*2)
   end
   if compass_ini then
      nsi = sprite.load(compass_ini)
   else
      nsi = sprite.blank(fs, fs*2)
   end
   if compass_ie then
      es = sprite.load(compass_ie)
   else
      es = sprite.blank(fs+w, fs)
   end
   if compass_iei then
      esi = sprite.load(compass_iei)
   else
      esi = sprite.blank(fs+w, fs)
   end
   if compass_is then
      ss = sprite.load(compass_is)
   else
      ss = sprite.blank(fs, fs*2)
   end
   if compass_isi then
      ssi = sprite.load(compass_isi)
   else
      ssi = sprite.blank(fs, fs*2)
   end
   if compass_iw then
      ws = sprite.load(compass_iw)
   else
      ws = sprite.blank(fs+w, fs)
   end
   if compass_iwi then
      wsi = sprite.load(compass_iwi)
   else
      wsi = sprite.blank(fs+w, fs)
   end
   if compass_up_down then
      if compass_iu then
	 us = sprite.load(compass_iu)
      else
	 us = sprite.text(fnt, "Вверх", compass_acolor, 0)
      end
      if compass_iui then
	 usi = sprite.load(compass_iui)
      else
	 usi = sprite.text(fnt, "Вверх", compass_color, 0)
      end
      if compass_id then
	 ds = sprite.load(compass_id)
      else
	 ds = sprite.text(fnt, "Вниз", compass_acolor, 0)
      end
      if compass_idi then
	 dsi = sprite.load(compass_idi)
      else
	 dsi = sprite.text(fnt, "Вниз", compass_color, 0)
      end
   end


   if not compass_ini then
      tmp = sprite.text(fnt, "[N]", compass_color, 0)
      w, h = sprite.size(tmp)
      x = math.floor((fs - w) / 2)
      sprite.draw(tmp, nsi, x, 0)
      draw_line(nsi, 0, fs * 2, fs / 2, fs, compass_color)
      draw_line(nsi, fs / 2, fs, fs, fs * 2, compass_color)
      draw_line(nsi, 1, fs * 2, fs / 2, fs + 2, compass_color)
      draw_line(nsi, fs / 2, fs + 2, fs - 1, fs * 2, compass_color)
      sprite.fill(nsi, fs / 2, fs, 1, fs * 2, compass_color)
   end

   if not compass_in then
      tmp = sprite.text(fnt, "[N]", compass_acolor, 0)
      w, h = sprite.size(tmp)
      x = math.floor((fs - w) / 2)
      sprite.draw(tmp, ns, x, 0)
      draw_line(ns, 0, fs * 2, fs / 2, fs, compass_acolor)
      draw_line(ns, fs / 2, fs, fs, fs * 2, compass_acolor)
      draw_line(ns, 1, fs * 2, fs / 2, fs + 2, compass_acolor)
      draw_line(ns, fs / 2, fs + 2, fs - 1, fs * 2, compass_acolor)
      sprite.fill(ns, fs / 2, fs, 1, fs * 2, compass_acolor)
   end


   if not compass_ie then
      tmp = sprite.text(fnt, "[E]", compass_acolor, 0)
      w, h = sprite.size(tmp)
      y = math.floor((fs - h) / 2)
      sprite.draw(tmp, es, fs, y)
      draw_line(es, 0, 0, fs, fs / 2, compass_acolor)
      draw_line(es, fs, fs / 2, 0, fs, compass_acolor)
      draw_line(es, 0, 1, fs - 2, fs / 2, compass_acolor)
      draw_line(es, fs - 2, fs / 2, 0, fs - 1, compass_acolor)
      sprite.fill(es, 0, fs / 2, fs, 1, compass_acolor)
   end

   if not compass_iei then
      tmp = sprite.text(fnt, "[E]", compass_color, 0)
      w, h = sprite.size(tmp)
      y = math.floor((fs - h) / 2)
      sprite.draw(tmp, esi, fs, y)
      draw_line(esi, 0, 0, fs, fs / 2, compass_color)
      draw_line(esi, fs, fs / 2, 0, fs, compass_color)
      draw_line(esi, 0, 1, fs - 2, fs / 2, compass_color)
      draw_line(esi, fs - 2, fs / 2, 0, fs - 1, compass_color)
      sprite.fill(esi, 0, fs / 2, fs, 1, compass_color)
   end


   if not compass_isi then
      tmp = sprite.text(fnt, "[S]", compass_color, 0)
      w, h = sprite.size(tmp)
      x = math.floor((fs - w) / 2)
      sprite.draw(tmp, ssi, x, fs)
      draw_line(ssi, 0, 0, fs / 2, fs, compass_color)
      draw_line(ssi, fs / 2, fs, fs, 0, compass_color)
      draw_line(ssi, 1, 0, fs / 2, fs - 2, compass_color)
      draw_line(ssi, fs / 2, fs - 2, fs - 1, 0, compass_color)
      sprite.fill(ssi, fs / 2, 0 / 2, 1, fs, compass_color)
   end

   if not compass_is then
      tmp = sprite.text(fnt, "[S]", compass_acolor, 0)
      w, h = sprite.size(tmp)
      x = math.floor((fs - w) / 2)
      sprite.draw(tmp, ss, x, fs)
      draw_line(ss, 0, 0, fs / 2, fs, compass_acolor)
      draw_line(ss, fs / 2, fs, fs, 0, compass_acolor)
      draw_line(ss, 1, 0, fs / 2, fs - 2, compass_acolor)
      draw_line(ss, fs / 2, fs - 2, fs - 1, 0, compass_acolor)
      sprite.fill(ss, fs / 2, 0 / 2, 1, fs, compass_acolor)
   end


   if not compass_iw then
      tmp = sprite.text(fnt, "[W]", compass_acolor, 0)
      w, h = sprite.size(tmp)
      y = math.floor((fs - h) / 2)
      sprite.draw(tmp, ws, 0, y)
      draw_line(ws, w, fs / 2, w + fs, 0, compass_acolor)
      draw_line(ws, w, fs / 2, w + fs, fs, compass_acolor)
      draw_line(ws, w + 2, fs / 2, w + fs, 1, compass_acolor)
      draw_line(ws, w + 2, fs / 2, w + fs, fs - 1, compass_acolor)
      sprite.fill(ws, w, fs / 2, w + fs, 1, compass_acolor)
   end

   if not compass_iwi then
      tmp = sprite.text(fnt, "[W]", compass_color, 0)
      ww, h = sprite.size(tmp)
      y = math.floor((fs - h) / 2)
      sprite.draw(tmp, wsi, 0, y)
      draw_line(wsi, w, fs / 2, w + fs, 0, compass_color)
      draw_line(wsi, w, fs / 2, w + fs, fs, compass_color)
      draw_line(wsi, w + 2, fs / 2, w + fs, 1, compass_color)
      draw_line(wsi, w + 2, fs / 2, w + fs, fs - 1, compass_color)
      sprite.fill(wsi, w, fs / 2, w + fs, 1, compass_color)
   end

   if compass_iv then
      empty_compass = sprite.load(compass_iv)
   else
      empty_compass = sprite.blank(fs, fs)
      sprite.fill(empty_compass, 0, fs/2, fs, 1, compass_color)
      sprite.fill(empty_compass, fs/2, 0, 1, fs, compass_color)
      draw_line(empty_compass, 0, 0, fs, fs, compass_color)
      draw_line(empty_compass, 0, fs, fs, 0, compass_color)
   end


   sprite.free_font(fnt)
   take "compass_n"
   take "compass_e"
   take "compass_s"
   take "compass_w"
   if compass_up_down then
      take "compass_u"
      take "compass_d"
   end
   take "compass"
end


compass_n = menu {
   nam = "N",
   disp = true,
   inv = function()
      if here().to_n then
	 walk(here().to_n)
      else
	 return "Не пройти."
      end
   end,
}

compass_e = menu {
   nam = "E",
   disp = true,
   inv = function()
      if here().to_e then
	 walk(here().to_e)
      end
   end,
}

compass_s = menu {
   nam = "S",
   disp = true,
   inv = function()
      if here().to_s then
	 walk(here().to_s)
      end
   end,
}

compass_w = menu {
   nam = "W",
   disp = true,
   inv = function()
      if here().to_w then
	 walk(here().to_w)
      end
   end,
}

compass_u = menu {
   nam = "U",
   disp = true,
   inv = function()
      if here().to_u then
	 walk(here().to_u)
      end
   end,
}

compass_d = menu {
   nam = "D",
   disp = true,
   inv = function()
      if here().to_d then
	 walk(here().to_d)
      end
   end,
}

compass = stat {
   nam = "Компас",
   disp = function()
      local v = ""
      if here().to_n then
	 pn(txtc(xref(img(ns), ref(compass_n))))
      else
	 pn(txtc(img(nsi)))
      end
      if here().to_w then
	 v = v .. xref(img(ws), ref(compass_w))
      else
	 v = v .. img(wsi)
      end
      v =v .. img(empty_compass)
      if here().to_e then
	 v = v .. xref(img(es), ref(compass_e))
      else
	 v = v .. img(esi)
      end
      pn(txtc(v))
      if here().to_s then
	 pn(txtc(xref(img(ss), ref(compass_s))))
      else
	 pn(txtc(img(ssi)))
      end
      if compass_up_down then
	 v = ""
	 if here().to_u then
	    v = v .. xref(img(us), ref(compass_u))
	 else
	    v = v .. img(usi)
	 end
	 if not compass_delim then
	    v = v .. " \\| "
	 end
	 if here().to_d then
	    v = v .. xref(img(ds), ref(compass_d))
	 else
	    v = v .. img(dsi)
	 end
	 pn(txtc(v))
      end
   end,
}