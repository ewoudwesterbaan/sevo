module visualisation::widgets::Widgets

import vis::Figure;
import vis::Render;
import vis::KeySym;

import IO;

// Toont een popup met een tooltip tekst.
//   - gebruik: box(size(50),fillColor("red"), popup("Hello"))
public FProperty popup(str msg) {
	return mouseOver(box(text(msg), shadow(true), fillColor("lightyellow"), grow(0.8), resizable(false)));
}

