import oids, strutils, endians

type
  WkbByteOrder*{.size: sizeof(cint).} = enum
    wkbXDR  # Big Endian
    wkbNDR  # Little Endian

  WkbGeometryType*{.size: sizeof(cint).} = enum
    wkbNull
    wkbPoint
    wkbLineString
    wkbPolygon
    wkbMultiPoint
    wkbMultiLineString
    wkbMultiPolygon
    wkbGeometryCollection

  Coord* = ref CoordObj
  CoordObj* = object
    x*: float64
    y*: float64

  Point* = ref PointObj
  PointObj* = object
    srid*: uint32
    coord*: Coord

  LineString* = ref LineStringObj
  LineStringObj* = object
    srid*: uint32
    coords*: seq[Coord]

  Polygon* = ref PolygonObj
  PolygonObj* = object
    srid*: uint32
    rings*: seq[seq[Coord]]

  MultiPoint* = object
    srid*: uint32
    points: seq[Point]

  Geometry* = ref GeometryObj
  GeometryObj* = object
    case kind*: WkbGeometryType
    of wkbPoint:
      pt*: Point
    of wkbLineString:
      ls: LineString
    else: discard

proc swapEndian32(p: pointer) =
  var o = cast[cstring](p)
  (o[0], o[1], o[2], o[3]) = (o[3], o[2], o[1], o[0])

proc swapEndian64(p: pointer) =
  var o = cast[cstring](p)
  (o[0], o[1], o[2], o[3], o[4], o[5], o[6], o[7]) = (o[7], o[6], o[5], o[4], o[3], o[2], o[1], o[0])

proc parseEndian(str: cstring): WkbByteOrder =
  result = WkbByteOrder((hexbyte(str[0]) shl 4) or hexbyte(str[1]))

proc parseGeometryType(str: cstring, bswap: bool): WkbGeometryType =
  var bytes = cast[cstring](addr result) 
  for i in 1..5:
    bytes[i - 1] = chr((hexbyte(str[2 * i]) shl 4) or hexbyte(str[2 * i + 1]))

  if bswap:
    swapEndian32(bytes)

proc parseuint32(str: cstring, pos: var int, bswap: bool): uint32 =
  var bytes = cast[cstring](addr result)
  for i in 0..3:
    bytes[i] = chr((hexbyte(str[2 * pos]) shl 4) or hexbyte(str[2 * pos + 1]))
    inc pos
  
  if bswap:
    swapEndian32(bytes)

proc parseCoord(str: cstring, pos: var int, bswap: bool): Coord =
  new(result)
  var bytes = cast[cstring](result)
  for i in 0..15:
    bytes[i] = chr((hexbyte(str[2 * pos]) shl 4) or hexbyte(str[2 * pos + 1]))
    inc pos
  echo bswap
  if bswap:
    swapEndian64(addr result.x)
    swapEndian64(addr result.y)

proc parseCoords(str: cstring, pos: var int, bswap: bool): seq[Coord] =
  let n = parseuint32(str, pos, bswap)
  for i in 1..n:
    let coord = parseCoord(str, pos, bswap)
    result.add(coord)

proc parseWkbPoint(str: cstring, bswap: bool): Point =
  new(result)
  var pos = 5
  result.coord = parseCoord(str, pos, bswap)

proc parseWkbLineString(str: cstring, bswap: bool): LineString =
  new(result)
  var pos = 5
  result.coords = parseCoords(str, pos, bswap)

proc parseWkb(str: cstring): Geometry =
  let endian = parseEndian(str)
  let bswap = (endian == WkbByteOrder(system.cpuEndian)) # littleEndian = 0, but wkbNDR = 1
  let wkbType = parseGeometryType(str, bswap)
  case wkbType:
  of wkbPoint:
    result = Geometry(kind: wkbPoint, pt: parseWkbPoint(str, bswap))
  of wkbLineString:
    result = Geometry(kind:  wkbLineString, ls: parseWkbLineString(str, bswap))
  else: discard

when isMainModule:
  # let wkb = "0101000000000000000000F03F000000000000F03F" # little endian
  # let wkb = "00000000013FF00000000000003FF0000000000000" # big endian
  # let wkb = "01"&
  #           "02000000"&
  #           "02000000"&
  #           "000000000000F03F"&
  #           "000000000000F03F"&
  #           "0000000000000040"&
  #           "0000000000000040"
  let wkb = "00"&
            "00000002"&
            "00000002"&
            "3FF0000000000000"&
            "3FF0000000000000"&
            "4000000000000000"&
            "4000000000000000"
  var p = parseWkb(wkb)
  echo repr p

  # var bytes = cast[clonglong](addr(p.x))
  # var outp: int64 = 0
  # bigEndian64(addr outp, addr p.x)
  # echo outp.toHex
