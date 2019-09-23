import unittest

include nimgeo/towkt, common

suite "format Geometry to Wkt":
  test "fCoord to Wkt":
    check ptCoord.toWkt == "1.0 2.0"

  test "LinearRing to Wkt":
    check rings.toWkt == wktring

  test "Point to Wkt":
    check pt.toWkt == wktpt
    check spt.toWkt == wktspt
  
  test "LineString to Wkt":
    check ls.toWkt == wktls
    check sls.toWkt == wktsls

  test "Polygon to Wkt":
    check pg.toWkt == wktpg
    check spg.toWkt == wktspg

  test "MultiPoint to Wkt":
    check mpt.toWkt == wktmpt
    check smpt.toWkt == wktsmpt
  
  test "MultiLineString to Wkt":
    check mls.toWkt == wktmls
    check smls.toWkt == wktsmls

  test "MultiPolygon to Wkt":
    check mpg.toWkt == wktmpg
    check smpg.toWkt == wktsmpg
  
  test "GeometryCollection to Wkt":
    check gc.toWkt == wktgc