import json, unittest

import nimgeo/geojson
include common

suite "format Geometry to geojson":
  test "Point to GeoJson":
    check $(%*pt) == jsonpt
    check $(%*spt) == jsonspt
  
  test "LineString to GeoJson":
    check $(%*ls) == jsonls
    check $(%*sls) == jsonsls

  test "Polygon to GeoJson":
    check $(%*pg) == jsonpg
    check $(%*spg) == jsonspg

  test "MultiPoint to GeoJson":
    check $(%*mpt) == jsonmpt
    check $(%*smpt) == jsonsmpt

  test "MultiLine to GeoJson":
    check $(%*mls) == jsonmls
    check $(%*smls) == jsonsmls

  test "MultiPolygon to GeoJson":
    check $(%*mpg) == jsonmpg
    check $(%*smpg) == jsonsmpg

  test "GeometryCollection to GeoJson":
    check $(%*gc) == jsongc
