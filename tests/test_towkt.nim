import unittest

include nimgeo/towkt, common

suite "Geometry to Wkt":
  test "format Coord to Wkt":
    check ptCoord.toWkt == "1.0 2.0"

  test "format LinearRing to Wkt":
    check rings.toWkt == wktring

  test "format Point to Wkt":
    check pt.toWkt == wktpt
    check spt.toWkt == wktspt
  
  test "format LineString to Wkt":
    check ls.toWkt == wktls
    check sls.toWkt == wktsls

  test "format Polygon to Wkt":
    check pg.toWkt == wktpg
    check spg.toWkt == wktspg

  test "format MultiPoint to Wkt":
    check mpt.toWkt == wktmpt
    check smpt.toWkt == wktsmpt
  
  test "format MultiLineString to Wkt":
    check mls.toWkt == wktmls
    check smls.toWkt == wktsmls

  test "format MultiPolygon to Wkt":
    check mpg.toWkt == wktmpg
    check smpg.toWkt == wktsmpg
  
  test "format GeometryCollection to Wkt":
    check gc.toWkt == wktgc