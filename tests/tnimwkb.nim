# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import nimwkb

const srid = 4326'u32

# Point
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

# LineString     
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
                "02000000"&# number of points
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

# Polygon      
var pg = @[
           @[Coord(x: 1.0, y: 1.0), Coord(x: 2.0, y: 2.0), Coord(x: 3.0, y: 3.0), Coord(x: 1.0, y: 1.0)],
           @[Coord(x:4.0, y: 4.0), Coord(x: 5.0, y: 5.0), Coord(x: 6.0, y: 6.0), Coord(x: 4.0, y: 4.0)]
          ]    
const wkbnpg = "01"&
               "03000000"&
               "02000000"&# number of rings
               "04000000"&# number of points
               "000000000000F03F"&
               "000000000000F03F"&
               "0000000000000040"&
               "0000000000000040"&
               "0000000000000840"&
               "0000000000000840"&
               "000000000000F03F"&
               "000000000000F03F"&
               "04000000"&# number of points
               "0000000000001040"&
               "0000000000001040"&
               "0000000000001440"&
               "0000000000001440"&
               "0000000000001840"&
               "0000000000001840"&
               "0000000000001040"&
               "0000000000001040"           

const wkbnspg = "01"&
                "03000020"&
                "E6100000"&# with srid = 4326
                "02000000"&# number of rings
                "04000000"&# number of points
                "000000000000F03F"&
                "000000000000F03F"&
                "0000000000000040"&
                "0000000000000040"&
                "0000000000000840"&
                "0000000000000840"&
                "000000000000F03F"&
                "000000000000F03F"&
                "04000000"&# number of points
                "0000000000001040"&
                "0000000000001040"&
                "0000000000001440"&
                "0000000000001440"&
                "0000000000001840"&
                "0000000000001840"&
                "0000000000001040"&
                "0000000000001040"           
const wkbxpg = "00"&
               "00000003"&
               "00000002"&# number of rings
               "00000004"&# number of points
               "3FF0000000000000"&
               "3FF0000000000000"&
               "4000000000000000"&
               "4000000000000000"&
               "4008000000000000"&
               "4008000000000000"&
               "3FF0000000000000"&
               "3FF0000000000000"&
               "00000004"&# number of points
               "4010000000000000"&
               "4010000000000000"&
               "4014000000000000"&
               "4014000000000000"&
               "4018000000000000"&
               "4018000000000000"&
               "4010000000000000"&
               "4010000000000000" 
const wkbxspg = "00"&
                "20000003"&
                "000010E6"&# with srid = 4326
                "00000002"&# number of rings
                "00000004"&# number of points
                "3FF0000000000000"&
                "3FF0000000000000"&
                "4000000000000000"&
                "4000000000000000"&
                "4008000000000000"&
                "4008000000000000"&
                "3FF0000000000000"&
                "3FF0000000000000"&
                "00000004"&# number of points
                "4010000000000000"&
                "4010000000000000"&
                "4014000000000000"&
                "4014000000000000"&
                "4018000000000000"&
                "4018000000000000"&
                "4010000000000000"&
                "4010000000000000" 


suite "parse Polygon wkb hex string":
  test "little endian wkb":
    check parseWkb(wkbnpg) == Geometry(kind: wkbPolygon,
                                       pg: Polygon(srid: 0, rings: pg))

  test "little endian wkb with srid":
    check parseWkb(wkbnspg) == Geometry(kind: wkbPolygon,
                                       pg: Polygon(srid: srid, rings: pg))

  test "big endian wkb":
    check parseWkb(wkbxpg) == Geometry(kind: wkbPolygon,
                                       pg: Polygon(srid: 0, rings:pg))

  test "big endian wkb with srid":
    check parseWkb(wkbxspg) == Geometry(kind: wkbPolygon,
                                       pg: Polygon(srid: srid, rings:pg))