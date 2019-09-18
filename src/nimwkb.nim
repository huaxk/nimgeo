import logging, strutils
from oids import hexbyte

type
  WkbByteOrder* = enum
    wkbXDR  # Big Endian
    wkbNDR  # Little Endian

  # fix the size: 4byte, write bytes directly
  WkbGeometryType*{.size: sizeof(cint).} = enum 
    # wkbNull
    wkbPoint = 1
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

  MultiPoint* = ref MultiPointObj
  MultiPointObj* = object
    srid*: uint32
    points*: seq[Point]

  MultiLineString* = ref MultiLineStringObj
  MultiLineStringObj* = object
    srid*: uint32
    linestrings*: seq[LineString]

  MultiPolygon* = ref MultiPolygonObj
  MultiPolygonObj* = object
    srid*: uint32
    polygons*: seq[Polygon]

  GeometryCollection = seq[Geometry] #  Todo: 可能出现自引用

  Geometry* = ref GeometryObj
  GeometryObj* = object
    case kind*: WkbGeometryType
    of wkbPoint:
      pt*: Point
    of wkbLineString:
      ls*: LineString
    of wkbPolygon:
      pg*: Polygon
    of wkbMultiPoint:
      mpt*: MultiPoint
    of wkbMultiLineString:
      mls*: MultiLineString
    of wkbMultiPolygon:
      mpg*: MultiPolygon      
    of wkbGeometryCollection:
      gc*: GeometryCollection

  WkbWriter* = ref object
    data: string
    pos: int
    bytesOrder: WkbByteOrder


proc `==`*(a, b: Coord): bool =
  return (a.x == b.x) and (a.y == b.y)

proc `==`*(a, b: Point): bool =
  return (a.srid == b.srid) and (a.coord.x == b.coord.x) and (a.coord.y == b.coord.y)

proc `==`*(a, b: LineString): bool =
  return (a.srid == b.srid) and (a.coords == b.coords)

proc `==`*(a, b: Polygon): bool =
  return (a.srid == b.srid) and (a.rings == b.rings)

proc `==`*(a, b: MultiPoint): bool =
  return (a.srid == b.srid) and (a.points == b.points)

proc `==`*(a, b: MultiLineString): bool =
  return (a.srid == b.srid) and (a.linestrings == b.linestrings)  

proc `==`*(a, b: MultiPolygon): bool =
  return (a.srid == b.srid) and (a.polygons == b.polygons)

proc `==`*(a, b: Geometry): bool =
  result = a.kind == b.kind
  if not result: return    
  case a.kind:
    of wkbPoint: result = result and (a.pt == b.pt)
    of wkbLineString: result = result and (a.ls == b.ls)
    of wkbPolygon: result = result and (a.pg == b.pg)
    of wkbMultiPoint: result = result and (a.mpt == b.mpt)
    of wkbMultiLineString: result = result and (a.mls == b.mls)
    of wkbMultiPolygon: result = result and (a.mpg == b.mpg)
    of wkbGeometryCollection: result = result and (a.gc == b.gc)

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


##  write to wkb

# const hexchars = "0123456789ABCDEF"

# proc bytehex*(byt: byte): string =
#   let lower = byt and 0b00001111
#   let height = (byt and 0b11110000) shr 4
#   return hexchars[height] & hexchars[lower]

proc toHex*(x: SomeInteger, len: Positive,
            bytesOrder: WkbByteOrder = wkbNDR): string =
  const
    HexChars = "0123456789ABCDEF"
  var
    n = x
    bytesLen = int(len / 2)
  result = newString(len)  
  for j in countup(0, bytesLen-1):
    result[j*2] = HexChars[int((n and 0xF0) shr 4)]
    result[j*2+1] = HexChars[int(n and 0xF)]
    n = n shr 8
    if n == 0 and x < 0: n = -1

proc toHex*(f: float64, len: Positive): string =
  let i = cast[int64](f)
  return i.toHex()

proc newWkbWriter*(bytesOrder: WkbByteOrder): WkbWriter =
  new(result)
  result.bytesOrder = bytesOrder

proc write(w: WkbWriter, pt: Point, bytesOrder: WkbByteOrder,
           typ: WkbGeometryType) =
  w.data &= bytesOrder.int.toHex(2)
  w.data &= typ.int.toHex(8)
  w.data &= pt.coord.x.toHex(16)

proc write(w: WkbWriter, geo: Geometry, bytesOrder: WkbByteOrder) =
  let kind = geo.kind
  case kind:
  of wkbPoint:
    w.write(geo.pt, bytesOrder, kind)
  else: discard
  
  

# proc toHex(w: WkbWriter): string =
#   for b in w.data:
#     result &= bytehex(b)

proc writeWkb*(geo: Geometry, bytesOrder: WkbByteOrder = wkbNDR): string =
  var wkbWriter = newWkbWriter(bytesOrder)
  # wkbWriter.write(geo)
  return wkbWriter.data