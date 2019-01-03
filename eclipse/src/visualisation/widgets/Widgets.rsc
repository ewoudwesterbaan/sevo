module visualisation::widgets::Widgets

import vis::Figure;
import vis::Render;
import vis::KeySym;

import IO;

// Toont een popup met een tooltip tekst.
//   - gebruik: box(size(50),fillColor("red"), popup("Hello"))
public FProperty popup(str msg) {
	return mouseOver(box(text(msg), 
		shadow(true), shadowColor(color("gainsboro", 0.5)), shadowPos(5, 5), 
		lineColor("burlywood"), fillColor("blanchedalmond"), 
		right(), top(),
		resizable(false))
	);
}

