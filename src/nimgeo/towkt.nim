import geometry

proc toWkt(coord: Coord): string =
  return $coord.x & " " & $coord.y

proc toWkt(coords: seq[Coord]): string =
  var
    i = 0
    length = coords.len
  while i < length:
    if i != length-1:
      result &= coords[i].toWkt & ", "
    else:
      result &= coords[i].toWkt
    inc(i)

proc toWkt(rings: seq[LinearRing]): string =
  var
    i = 0
    ringnum = rings.len
  while i < ringnum:
    if i != ringnum - 1:
      result &= "(" & rings[i].toWkt & "), "
    else:
      result &= "(" & rings[i].toWkt & ")"
    inc(i)

proc toWkt*(pt: Point, prefix=true, srid=true): string =
  if srid and pt.srid != 0:
    result = "SRID=" & $pt.srid & "; "
  if prefix:
    result &= "POINT(" & pt.coord.toWkt & ")"
  else:
    result &= pt.coord.toWkt

proc toWkt*(ls: LineString, prefix=true, srid=true): string =
  if srid and ls.srid != 0:
    result = "SRID=" & $ls.srid & "; "
  if prefix:
    result &= "LINESTRING(" & ls.coords.toWkt & ")"
  else:
    result &= ls.coords.toWkt

proc toWkt*(pg: Polygon, prefix=true, srid=true): string =
  if srid and pg.srid != 0:
    result = "SRID=" & $pg.srid & "; "
  if prefix:
    result &= "POLYGON(" & pg.rings.toWkt & ")"
  else:
    result &= pg.rings.toWkt

proc toWkt(points: seq[Point]): string =
  var
    i = 0
    pointnum = points.len
  while i < pointnum:
    if i != pointnum-1:
      result &= points[i].toWkt(prefix=false) & ", "
    else:
      result &= points[i].toWkt(prefix=false)
    inc(i)

proc toWkt*(mpt: MultiPoint): string =
  if mpt.srid != 0:
    result = "SRID=" & $mpt.srid & "; "
  result &= "MULTIPOINT(" & mpt.points.toWkt & ")"

proc toWkt(linestrings: seq[LineString]): string =
  var
    i = 0
    lsnum = linestrings.len
  while i < lsnum:
    if i != lsnum-1:
      result &= "(" & linestrings[i].toWkt(prefix=false) & "), "
    else:
      result &= "(" & linestrings[i].toWkt(prefix=false) & ")"
    inc(i)

proc toWkt*(mls: MultiLineString): string =
  if mls.srid != 0:
    result = "SRID=" & $mls.srid & "; "
  result &= "MULTIlINESTRING(" & mls.linestrings.toWkt & ")"

proc toWkt(polygons: seq[Polygon]): string =
  var
    i = 0
    pgnum = polygons.len
  while i < pgnum:
    if i != pgnum-1:
      result &= "(" & polygons[i].toWkt(prefix=false) & "), "
    else:
      result &= "(" & polygons[i].toWkt(prefix=false) & ")"
    inc(i)

proc toWkt*(mpg: MultiPolygon): string =
  if mpg.srid != 0:
    result = "SRID=" & $mpg.srid & "; "
  result &= "MULTIPOLYGON(" & mpg.polygons.toWkt & ")"

proc toWkt*(gc: GeometryCollection): string

proc toWkt*(geo: Geometry): string =
  case geo.kind:
  of wkbPoint:
    return geo.pt.toWkt
  of wkbLineString:
    return geo.ls.toWkt
  of wkbPolygon:
    return geo.pg.toWkt
  of wkbMultiPoint:
    return geo.mpt.toWkt
  of wkbMultiLineString:
    return geo.mpg.toWkt
  of wkbMultiPolygon:
    return geo.mpg.toWkt
  of wkbGeometryCollection:
    return geo.gc.toWkt

proc toWkt*(gc: GeometryCollection): string =
  var
    i = 0
    gcnum = gc.len
  result = "GEOMETRYCOLLECTION("
  while i < gcnum:
    if i != gcnum-1:
      result &= gc[i].toWkt & ", "
    else:
      result &= gc[i].toWkt
    inc(i)
  result &= ")"

proc `$`*(pt: Point): string = pt.toWkt
proc `$`*(ls: LineString): string = ls.toWkt
proc `$`*(pg: Polygon): string = pg.toWkt
proc `$`*(mpt: MultiPoint): string = mpt.toWkt
proc `$`*(mls: MultiLineString): string = mls.toWkt
proc `$`*(mpg: MultiPolygon): string = mpg.toWkt
proc `$`*(gc: GeometryCollection): string = gc.toWkt
  