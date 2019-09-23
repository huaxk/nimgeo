import json

import geometry

proc `%`*(coord: Coord): JsonNode =
  return JsonNode(kind: JArray, elems: @[%coord.x, %coord.y])

proc `%`*(pt: Point): JsonNode =
  result = newJObject()
  result["type"] = %"Point"
  result["coordinates"] = %pt.coord
  if pt.hasSrid:
    result["crs"] = %*{"type":"name","properties":{"name":"EPSG:" & $pt.srid}}

proc `%`*(ls: LineString): JsonNode =
  result = newJObject()
  result["type"] = %"LineString"
  result["coordinates"] = %ls.coords
  if ls.hasSrid:
    result["crs"] = %*{"type":"name","properties":{"name":"EPSG:" & $ls.srid}}

proc `%`*(pg: Polygon): JsonNode =
  result = newJObject()
  result["type"] = %"Polygon"
  result["coordinates"] = %pg.rings
  if pg.hasSrid:
    result["crs"] = %*{"type":"name","properties":{"name":"EPSG:" & $pg.srid}}

proc `%`*(mpt: MultiPoint): JsonNode =
  result = newJObject()
  result["type"] = %"MultiPoint"
  result["coordinates"] = newJArray()
  for pt in mpt.points:
    result["coordinates"].add(%pt.coord)
  if mpt.hasSrid:
    result["crs"] = %*{"type":"name","properties":{"name":"EPSG:" & $mpt.srid}}
  
proc `%`*(mls: MultiLineString): JsonNode =
  result = newJObject()
  result["type"] = %"MultiLineString"
  result["coordinates"] = newJArray()
  for ls in mls.linestrings:
    result["coordinates"].add(%ls.coords)
  if mls.hasSrid:
    result["crs"] = %*{"type":"name","properties":{"name":"EPSG:" & $mls.srid}}

proc `%`*(mpg: MultiPolygon): JsonNode =
  result = newJObject()
  result["type"] = %"MultiPolygon"
  result["coordinates"] = newJArray()
  for pg in mpg.polygons:
    result["coordinates"].add(%pg.rings)
  if mpg.hasSrid:
    result["crs"] = %*{"type":"name","properties":{"name":"EPSG:" & $mpg.srid}}

proc `%`*(geo: Geometry): JsonNode =
  case geo.kind:
  of wkbPoint:
    return %geo.pt
  of wkbLineString:
    return %geo.ls
  of wkbPolygon:
    return %geo.pg
  of wkbMultiPoint:
    return %geo.mpt
  of wkbMultiLineString:
    return %geo.mls
  of wkbMultiPolygon:
    return %geo.mpg
  of wkbGeometryCollection:
    return %geo.gc    

proc `%`*(gc: GeometryCollection): JsonNode =
  result = newJObject()
  result["type"] = %"GeometryCollection"
  result["geometries"] = newJArray()
  for geo in gc:
    result["geometries"].add(%geo)

#  TODO: GeometryCollection缺srid属性