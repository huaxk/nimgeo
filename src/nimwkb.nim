import logging, endians
from oids import hexbyte

import geometry

proc swapEndian32(p: pointer) =
  var o = cast[cstring](p)
  (o[0], o[1], o[2], o[3]) = (o[3], o[2], o[1], o[0])

proc swapEndian64(p: pointer) =
  var o = cast[cstring](p)
  (o[0], o[1], o[2], o[3], o[4], o[5], o[6], o[7]) = (o[7], o[6], o[5], o[4], o[3], o[2], o[1], o[0])


##  parse wkb

proc parseEndian(str: cstring, pos: var int): WkbByteOrder =
  let c = (hexbyte(str[2 * pos]) shl 4) or hexbyte(str[2 * pos + 1])
  result = WkbByteOrder(c)
  inc(pos)
  debug("end position: ", $(pos * 2), " -> ", $result)

proc parseGeometryType(str: cstring, pos: var int, bswap: bool):
                      (WkbGeometryType, bool) =
  var bytes = cast[cstring](addr result[0]) 
  for i in 0..3:
    bytes[i] = chr((hexbyte(str[2 * pos]) shl 4) or hexbyte(str[2 * pos + 1]))
    inc(pos)

  if bswap: swapEndian32(bytes)
  # check has srid
  if bytes[3] == chr(0x20):
    bytes[3] = chr(0x00)
    result[1] = true
  else:
    result[1] = false
  
  debug("end position: ", $(pos * 2), " -> ", $result)

proc parseuint32(str: cstring, pos: var int, bswap: bool): uint32 =
  var bytes = cast[cstring](addr result)
  for i in 0..3:
    bytes[i] = chr((hexbyte(str[2 * pos]) shl 4) or hexbyte(str[2 * pos + 1]))
    inc pos
  
  if bswap:
    swapEndian32(bytes)
  
  debug("end position: ", $(pos * 2), " -> ", $result)

proc parseCoord(str: cstring, pos: var int, bswap: bool): Coord =
  new(result)
  var bytes = cast[cstring](result)
  for i in 0..15:
    bytes[i] = chr((hexbyte(str[2 * pos]) shl 4) or hexbyte(str[2 * pos + 1]))
    inc pos

  if bswap:
    swapEndian64(addr result.x)
    swapEndian64(addr result.y)

  debug("end position: ", $(pos * 2), " -> ",
      "(", result.x, ",", result.y, ")") 

proc parseCoords(str: cstring, pos: var int, bswap: bool): seq[Coord] =
  let n = parseuint32(str, pos, bswap)
  for i in 1..n:
    let coord = parseCoord(str, pos, bswap)
    result.add(coord)

proc parseRings(str: cstring, pos: var int, bswap: bool): seq[seq[Coord]] =
  let ringnum = parseuint32(str, pos, bswap)
  for i in 1..ringnum:
    let coords = parseCoords(str, pos, bswap)
    result.add(coords)

proc parseWkbPoint(str: cstring, pos: var int, bswap: bool): Point =
  new(result)
  result.coord = parseCoord(str, pos, bswap)

proc parseWkbLineString(str: cstring, pos: var int, bswap: bool): LineString =
  new(result)
  result.coords = parseCoords(str, pos, bswap)

proc parseWkbPolygon(str: cstring, pos: var int, bswap: bool): Polygon =
  new(result)
  result.rings = parseRings(str, pos, bswap)  

#  forward declaration
proc parseGeometry*(str: cstring, pos: var int, bswap = false): Geometry

proc parseWkbMultiPoint(str: cstring, pos: var int, bswap: bool): MultiPoint =
  new(result)
  let pointnum = parseuint32(str, pos, bswap)
  for i in 1..pointnum:
    let geo = parseGeometry(str, pos, bswap) #  Point
    result.points.add(geo.pt)

proc parseWkbMultiLineString(str: cstring, pos: var int, bswap: bool):
                          MultiLineString =
  new(result)
  let lsnum = parseuint32(str, pos, bswap)
  for i in 1..lsnum:
    let geo = parseGeometry(str, pos, bswap) #  LineString
    result.linestrings.add(geo.ls)  

proc parseWkbMultiPolygon(str: cstring, pos: var int, bswap: bool): 
                          MultiPolygon =
  new(result)
  let pgnum = parseuint32(str, pos, bswap)
  for i in 1..pgnum:
    let geo = parseGeometry(str, pos, bswap) #  Ploygon
    result.polygons.add(geo.pg)

proc parseGeometryCollection(str: cstring, pos: var int, bswap: bool): 
                             GeometryCollection =
  # new(result)
  let gcnum = parseuint32(str, pos, bswap)
  for i in 1..gcnum:
    let geo = parseGeometry(str, pos, bswap)
    # result.geometries.add(geo)
    result.add(geo)
  

proc parseGeometry*(str: cstring, pos: var int, bswap = false): Geometry =
  let endian = parseEndian(str, pos)
  #  littleEndian = 0, but wkbNDR = 1
  let bswap = (endian == WkbByteOrder(system.cpuEndian))
  let (wkbType, hasSrid) = parseGeometryType(str, pos, bswap)

  var srid: uint32
  if hasSrid: srid = parseuint32(str, pos, bswap)

  case wkbType:
  of wkbPoint:
    var pt = parseWkbPoint(str, pos, bswap)
    if hasSrid: pt.srid = srid
    return Geometry(kind: wkbType, pt: pt)
  of wkbLineString:
    var ls = parseWkbLineString(str, pos, bswap)
    if hasSrid: ls.srid = srid
    return Geometry(kind:  wkbType, ls: ls)
  of wkbPolygon:
    var pg = parseWkbPolygon(str, pos, bswap)
    if hasSrid: pg.srid = srid
    return Geometry(kind: wkbType, pg: pg)
  of wkbMultiPoint:
    var mpt = parseWkbMultiPoint(str, pos, bswap)
    if hasSrid: mpt.srid = srid
    return Geometry(kind: wkbType, mpt: mpt)
  of wkbMultiLineString:
    var mls = parseWkbMultiLineString(str, pos, bswap)
    if hasSrid: mls.srid = srid
    return Geometry(kind: wkbType, mls: mls)
  of wkbMultiPolygon:
    var mpg = parseWkbMultiPolygon(str, pos, bswap)
    if hasSrid: mpg.srid = srid
    return Geometry(kind: wkbType, mpg: mpg)
  of wkbGeometryCollection:
    var gc = parseGeometryCollection(str, pos, bswap)
    return Geometry(kind: wkbType, gc: gc)

proc parseWkb*(str: cstring): Geometry =
  debug("WKB: ", str)
  var pos = 0 #  解析的起点
  return parseGeometry(str, pos)


