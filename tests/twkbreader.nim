import unittest, logging

import nimgeo/[geometry, wkbreader]

include common

suite "wkb hex to Geometry":
  test "parse Geometry Point from wkb hex":
    check parseWkb(wkbnpt) == ptGeometry
    check parseWkb(wkbnspt) == sptGeometry
    check parseWkb(wkbxpt) == ptGeometry
    check parseWkb(wkbxspt) == sptGeometry

  test "parse Point from wkb hex":
    check parseWkbPoint(wkbnpt) == pt
    check parseWkbPoint(wkbnspt) == spt
    check parseWkbPoint(wkbxpt) == pt
    check parseWkbPoint(wkbxspt) == spt

  test "parse Geometry LineString from wkb hex":
    check parseWkb(wkbnls) == lsGeometry
    check parseWkb(wkbnsls) == slsGeometry
    check parseWkb(wkbxls) == lsGeometry
    check parseWkb(wkbxsls) == slsGeometry

  test "parse LineString from wkb hex":
    check parseWkbLineString(wkbnls) == ls
    check parseWkbLineString(wkbnsls) == sls
    check parseWkbLineString(wkbxls) == ls
    check parseWkbLineString(wkbxsls) == sls

  test "parse Geometry Polygon from wkb hex ":
    check parseWkb(wkbnpg) == pgGeometry
    check parseWkb(wkbnspg) == spgGeometry
    check parseWkb(wkbxpg) == pgGeometry
    check parseWkb(wkbxspg) == spgGeometry

  test "parse Polygon from wkb hex":
    check parseWkbPolygon(wkbnpg) == pg
    check parseWkbPolygon(wkbnspg) == spg
    check parseWkbPolygon(wkbxpg) == pg
    check parseWkbPolygon(wkbxspg) == spg

  test "parse Geometry MultiPoint from wkb hex":
    check parseWkb(wkbnmpt) == mptGeometry
    check parseWkb(wkbnsmpt) == smptGeometry
    check parseWkb(wkbxmpt) == mptGeometry
    check parseWkb(wkbxsmpt) == smptGeometry

  test "parse MultiPoint from wkb hex":
    check parseWkbMultiPoint(wkbnmpt) == mpt
    check parseWkbMultiPoint(wkbnsmpt) == smpt
    check parseWkbMultiPoint(wkbxmpt) == mpt
    check parseWkbMultiPoint(wkbxsmpt) == smpt

  test "parse Geometry MultiLineString from wkb hex":
    check parseWkb(wkbnmls) == mlsGeometry
    check parseWkb(wkbnsmls) == smlsGeometry
    check parseWkb(wkbxmls) == mlsGeometry
    check parseWkb(wkbxsmls) == smlsGeometry

  test "parse MultiLineString from wkb hex":
    check parseWkbMultiLineString(wkbnmls) == mls
    check parseWkbMultiLineString(wkbnsmls) == smls
    check parseWkbMultiLineString(wkbxmls) == mls
    check parseWkbMultiLineString(wkbxsmls) == smls

  test "parse Geometry MultiPolygon from wkb hex":
    check parseWkb(wkbnmpg) == mpgGeometry
    check parseWkb(wkbnsmpg) == smpgGeometry
    check parseWkb(wkbxmpg) == mpgGeometry
    check parseWkb(wkbxsmpg) == smpgGeometry

  test "parse MultiPolygon from wkb hex":
    check parseWkbMultiPolygon(wkbnmpg) == mpg
    check parseWkbMultiPolygon(wkbnsmpg) == smpg
    check parseWkbMultiPolygon(wkbxmpg) == mpg
    check parseWkbMultiPolygon(wkbxsmpg) == smpg

  test "parse Geometry GeometryCollection to wkb hex":
    check parseWkb(wkbngc) == gcGeometry
    check parseWkb(wkbxgc) == gcGeometry

  test "parse GeometryCollection from wkb hex":
    check parseWkbGeometryCollection(wkbngc) == gc
    check parseWkbGeometryCollection(wkbxgc) == gc