import unittest, logging

import geometry, wkbreader

include common

suite "wkb hex to Geometry":
  test "parse Point to wkb hex":
    check parseWkb(wkbnpt) == ptGeometry
    check parseWkb(wkbnspt) == sptGeometry
    check parseWkb(wkbxpt) == ptGeometry
    check parseWkb(wkbxspt) == sptGeometry

  test "parse LineString to wkb hex":
    check parseWkb(wkbnls) == lsGeometry
    check parseWkb(wkbnsls) == slsGeometry
    check parseWkb(wkbxls) == lsGeometry
    check parseWkb(wkbxsls) == slsGeometry

  test "parse Polygon to wkb hex ":
    check parseWkb(wkbnpg) == pgGeometry
    check parseWkb(wkbnspg) == spgGeometry
    check parseWkb(wkbxpg) == pgGeometry
    check parseWkb(wkbxspg) == spgGeometry

  test "parse MultiPoint to wkb hex":
    check parseWkb(wkbnmpt) == mptGeometry
    check parseWkb(wkbnsmpt) == smptGeometry
    check parseWkb(wkbxmpt) == mptGeometry
    check parseWkb(wkbxsmpt) == smptGeometry


  test "parse MultiLineString wkb hex string":
    check parseWkb(wkbnmls) == mlsGeometry
    check parseWkb(wkbnsmls) == smlsGeometry
    check parseWkb(wkbxmls) == mlsGeometry
    check parseWkb(wkbxsmls) == smlsGeometry

  test "parse MultiPolygon to wkb hex":
    check parseWkb(wkbnmpg) == mpgGeometry
    check parseWkb(wkbnsmpg) == smpgGeometry
    check parseWkb(wkbxmpg) == mpgGeometry
    check parseWkb(wkbxsmpg) == smpgGeometry

  test "parse GeometryCollection to wkb":
    check parseWkb(wkbngc) == gcGeometry
    check parseWkb(wkbxgc) == gcGeometry
