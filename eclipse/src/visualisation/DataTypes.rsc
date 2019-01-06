module visualisation::DataTypes

public alias UnitInfoTuple = tuple[loc location, str unitName, int complexity, str risk, int totalLines, int commentLines, int codeLines];
public alias UnitInfoList = list[UnitInfoTuple];
public alias ClassInfoTuple = tuple[loc location, str className, str pkgName, str complexityRating, int totalLines, int commentLines, int codeLines, UnitInfoList units];
public alias ClassInfoMap = map[str classId, ClassInfoTuple classInfo];
public alias PkgInfoTuple = tuple[str pkgName, str complexityRating, int totalLines, int commentLines, int codeLines, ClassInfoMap classInfos];
public alias PkgInfoMap = map[str pkgId, PkgInfoTuple pkgInfo];
public alias ProjectInfoTuple = tuple[loc project, str projName, str complexityRating, int totalLines, int commentLines, int codeLines, PkgInfoMap pkgInfos];