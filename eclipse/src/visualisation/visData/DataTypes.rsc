module visualisation::visData::DataTypes

// Voor RiskCatDistributionMap
import metrics::Aggregate;

// Unit informatie die gebruikt wordt bij de visualisatie
public alias UnitInfoTuple = tuple[
	loc location,                         // De locatie van de unit (methode of constructor)
	str unitName,                         // De naam van de unit
	int complexity,                       // De metriek cyclomatische complexiteit van de unit
	str risk,                             // Het risico op basis van de complexity: simple, moderate, complext of untestable (zie metrics::Complexity.rsc)
	int totalLines,                       // Het totaal aantal regels van de unit (zie metrics::UnitSize.rsc)
	int commentLines,                     // Het aantal regels commentaar in de unit (zie metrics::UnitSize.rsc)
	int codeLines                         // Het aantal regels code (excl. blanco regels en commmentaar, zie metrics::UnitSize.rsc)
];
public alias UnitInfoList = list[UnitInfoTuple];

// Class informatie die gebruikt wordt bij de visualisatie
public alias ClassInfoTuple = tuple[
	loc location,                         // De locatie van de class
	str className,                        // De naam van de class
	str pkgName,                          // De naam van de package waarin de class zich bevindt
	str complexityRating,                 // De complexity rank van de class: ++, +, 0, - of -- (zie metrics::Rate.rsc)
	int totalLines,                       // Het totaal aantal regels in de class
	int commentLines,                     // Het aantal commentaarregels in de class
	int codeLines,                        // Het aantal regels code in de class
	RiskCatDistributionMap riskCats,      // Relatief aantal unit-codeLines per risicocategorie (simple, moderate, ...) in deze class.
	UnitSizeDistributionMap unitSizeCats, // Relatief aantal unit-codeLines per unit size categorie (small, medium, ...) in deze class.
	UnitInfoList units                    // De lijst met units die zich in deze class bevinden
];
public alias ClassInfoMap = map[str classId, ClassInfoTuple classInfo];

// Package informatie die gebruikt wordt bij de visualisatie
public alias PkgInfoTuple = tuple[
	str pkgName,                          // De naam van de package
	str complexityRating,                 // De complexity rank van de package: ++, +, 0, - of -- (zie metrics::Rate.rsc)
	int totalLines,                       // Het totaal aantal regels in de package
	int commentLines,                     // Het totaal aantal commentaarregels in de package
	int codeLines,                        // Het aantal regels code in de package (excl. blanco regels en commentaar)
	ClassInfoMap classInfos               // De lijst met alle classes in deze package
];
public alias PkgInfoMap = map[str pkgId, PkgInfoTuple pkgInfo];

// Project informatie die gebruikt wordt bij de visualisatie
public alias ProjectInfoTuple = tuple[
	loc project,                           // De locatie van het project
	str projName,                          // De projectnaam
	str complexityRating,                  // De complexity rank van het project: ++, +, 0, - of -- (zie metrics::Rate.rsc)
	int totalLines,                        // Het totaal aantal regels in het hele project
	int commentLines,                      // Het aantal commentaarregels in het hele project
	int codeLines,                         // Het aantal regels code in het hele project (excl. blanco regels en commentaarregels)
	PkgInfoMap pkgInfos                    // De lijst met alle packages in het project. 
];
