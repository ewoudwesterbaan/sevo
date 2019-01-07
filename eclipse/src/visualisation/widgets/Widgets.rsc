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
		gap(10),
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

// Een klikbaar breadcrum element
public Figure breadcrumElement(void () vcallback, str elmText){
	return text(
		" / <elmText>", 
		handleBreadcrumClick(vcallback), 
		fontColor(color("steelblue")),
		fontSize(14),
		resizable(false),
		ialign(0.0),
		hsize(1),
		vsize(22));
}

// Een niet klikbaar breadcrum element
public Figure breadcrumElement(str elmText){
	return text(
		" / <elmText>", 
		fontSize(14),
		resizable(false),
		ialign(0.0),
		hsize(1),
		vsize(22));
}

// Handelt een click event af op een breadcrum element 
private FProperty handleBreadcrumClick(void () vcallback) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		println("Click!!");
		if (modifiers[modShift()]) return false;
		if (modifiers[modCtrl()]) return false;
		if (modifiers[modAlt()]) return false;
		vcallback();
		return true;
	});
}

// Een breadcrum figure.
public Figure breadcrumPath(list[Figure] breadcrumElements){
	return hcat(breadcrumElements, ialign(0.0), resizable(false));
}

