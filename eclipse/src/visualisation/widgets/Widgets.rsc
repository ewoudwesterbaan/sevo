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

// Een button met een label en een buttontekst.
//  - btnText: de tekst op de button,
//  - vcallback: de methode die moet worden aangeroepen wanneer er op de button wordt geklikt.
public Figure button(void () vcallback, str btnText){
	return button(
		btnText, 
		vcallback, 
		fillColor(color("aliceblue")), 
		lineColor(color("steelblue")), 
		fontColor(color("steelblue")),
		fontBold(true),
		resizable(false),
		vsize(35),
		hsize(150)
	);
}

// Een paginatitel.
public Figure pageTitle(str titleText){
	return text(
		titleText, 
		fontColor(color("steelblue")),
		fontBold(true),
		fontSize(25),
		resizable(false),
		vsize(25)
	);
}

