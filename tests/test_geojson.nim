import json, unittest

import nimgeo
include common

proc `%`(coord: Coord): JsonNode =
  result = newJArray()
  result.add(%coord.x)
  result.add(%coord.y)

proc `%`*(pt: Point): JsonNode =
  result = newJObject()
  result["type"] = %"Point"
  result["coordinates"] = %pt.coord

proc `%`*(ls: LineString): JsonNode =
  result = newJObject()
  result["type"] = %"LineString"
  result["coordinates"] = newJArray()
  for coord in ls.coords:
    result["coordinates"].add(%coord)

proc `%`*(pg: Polygon): JsonNode =
  result = newJObject()
  result["type"] = %"Polygon"
  result["coordinates"] = newJArray()
  for ring in pg.rings:
    var ringNode = newJArray()
    for coord in ring:
      ringNode.add(%coord)
    result["coordinates"].add(ringNode)


suite "geojson":
  test "geojson":
    echo %*pt
    echo %*ls
    echo %*pg