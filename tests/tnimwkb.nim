# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import nimwkb

const srid = 4326'u32

let pt = Coord(x: 1.0, y: 2.0)
const wkbnpt = "01"&# little endian
               "01000000"&
               "000000000000F03F"&
               "0000000000000040" 
const wkbnspt = "01"&# little endian
                "01000020"&
                "E6100000"&# with srid = 4326
                "000000000000F03F"&
                "0000000000000040"
const wkbxpt = "00"&# big endian
               "00000001"&
               "3FF0000000000000"&
               "4000000000000000"
const wkbxspt = "00"&# big endian
                "20000001"&
                "000010E6"&# with srid = 4326
                "3FF0000000000000"&
                "4000000000000000"

var ls = @[Coord(x: 1.0, y: 1.0), Coord(x: 2.0, y: 2.0)]
const wkbnls = "01"&
               "02000000"&
               "02000000"&
               "000000000000F03F"&
               "000000000000F03F"&
               "0000000000000040"&
               "0000000000000040"               
const wkbnsls = "01"&
                "02000020"&
                "E6100000"&# with srid = 4326
                "02000000"&
                "000000000000F03F"&
                "000000000000F03F"&
                "0000000000000040"&
                "0000000000000040"
const wkbxls = "00"&
               "00000002"&
               "00000002"&
               "3FF0000000000000"&
               "3FF0000000000000"&
               "4000000000000000"&
               "4000000000000000"

const wkbxsls = "00"&
                "20000002"&
                "000010E6"&# with srid = 4326
                "00000002"&
                "3FF0000000000000"&
                "3FF0000000000000"&
                "4000000000000000"&
                "4000000000000000"

suite "parse Point wkb hex string":
  test "little endian wkb":
    check parseWkb(wkbnpt) == Geometry(kind: wkbPoint,
                                       pt: Point(srid: 0, coord: pt))

  test "little endian wkb with srid":
    check parseWkb(wkbnspt) == Geometry(kind: wkbPoint,
                                        pt: Point(srid: srid, coord: pt))
  
  test "big endian wkb":
    check parseWkb(wkbxpt) == Geometry(kind: wkbPoint,
                                       pt: Point(srid: 0, coord: pt))

  test "big endian wkb with srid":
    check parseWkb(wkbxspt) == Geometry(kind: wkbPoint,
                                        pt: Point(srid: srid, coord: pt))

suite "parse LineString wkb hex string":
  test "little endian wkb":
    check parseWkb(wkbnls) == Geometry(kind: wkbLineString,
                                       ls: LineString(srid: 0, coords: ls))

  test "little endian wkb with srid":
    check parseWkb(wkbnsls) == Geometry(kind: wkbLineString,
                                        ls: LineString(srid: srid, coords: ls))

  test "big endian wkb":
    check parseWkb(wkbxls) == Geometry(kind: wkbLineString,
                                       ls: LineString(srid: 0, coords:ls))

  test "big endian wkb with srid":
    check parseWkb(wkbxsls) == Geometry(kind: wkbLineString,
                                        ls: LineString(srid: srid, coords: ls))