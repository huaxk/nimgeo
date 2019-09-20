import endians

import geometry

type
  WkbWriter* = ref object
    data: seq[byte]
    pos: int
    byteOrder: WkbByteOrder

##  write to wkb

proc toByte*(x: uint32, byteOrder: WkbByteOrder): array[4, byte] =
  var
    x = x
    y = x
  if cpuEndian != byteOrder:
    if cpuEndian == littleEndian:
      bigEndian32(addr y, addr x)
    else:
      littleEndian32(addr y, addr x)
  return cast[array[4, byte]](y)

proc toByte*(x: float64, byteOrder: WkbByteOrder): array[8, byte] =
  var
    x = x
    y = x
  #  TODO: 代码与前面重复，因为pointer不能赋值，重构成有问题
  if cpuEndian != byteOrder:        
    if cpuEndian == littleEndian:
      bigEndian64(addr y, addr x)
    else:
      littleEndian64(addr y, addr x)
  return cast[array[8, byte]](y)

proc toByte*(coord: Coord, byteOrder: WkbByteOrder): seq[byte] =
  result &= coord.x.toByte(byteOrder)
  result &= coord.y.toByte(byteOrder)

proc toByte(typ: WkbGeometryType, byteOrder: WkbByteOrder, hasSrid: bool = false):
            array[4, byte] =
  result = typ.uint32.toByte(byteorder)
  if hasSrid:
    if byteOrder == wkbNDR:
      result[3] = 0x20
    else:
      result[0] = 0x20
    
proc bytehex*(byt: byte): string =
  const HexChars = "0123456789ABCDEF"
  let lower = byt and 0b00001111
  let height = (byt and 0b11110000) shr 4
  return HexChars[height] & HexChars[lower]

proc toHex*(bytes: seq[byte]): string =
  result = newString(2*bytes.len)
  var i = 0
  for b in bytes:
    let hex = bytehex(b)
    result[i] = hex[0]
    result[i+1] = hex[1]
    i += 2

proc newWkbWriter*(byteOrder: WkbByteOrder): WkbWriter =
  new(result)
  result.byteOrder = byteOrder

proc write(w: WkbWriter, pt: Point, byteOrder: WkbByteOrder) =
  let
    typ = wkbPoint
    hasSrid = pt.srid != 0

  w.data &= byteOrder.byte
  w.data &= typ.toByte(byteOrder, hasSrid)
  if hasSrid:
    w.data &= pt.srid.toByte(byteOrder)

  w.data &= pt.coord.toByte(byteOrder)

proc write(w: WkbWriter, ls: LineString, byteOrder: WkbByteOrder) =
  let
    typ = wkbLineString
    hasSrid = ls.srid != 0
    length = ls.coords.len

  w.data &= byteOrder.byte
  w.data &= typ.toByte(byteOrder, hasSrid)
  if hasSrid:
    w.data &= ls.srid.toByte(byteOrder)
  w.data &= length.uint32.toByte(byteOrder)

  for i in countup(0, length-1):
    w.data &= ls.coords[i].toByte(byteOrder)

proc write(w: WkbWriter, pg: Polygon, byteOrder: WkbByteOrder) =
  let
    typ = wkbPolygon
    hasSrid = pg.srid != 0
    ringnum = pg.rings.len

  w.data &= byteOrder.byte
  w.data &= typ.toByte(byteOrder, hasSrid)
  if hasSrid:
    w.data &= pg.srid.toByte(byteOrder)

  w.data &= ringnum.uint32.toByte(byteOrder)
  for i in countup(0, ringnum-1):
    let
      ring = pg.rings[i]
      coordnum = ring.len
    w.data &= coordnum.uint32.toByte(byteOrder)
    for j in countup(0, coordnum-1):
      w.data &= ring[j].toByte(byteOrder)

proc write(w: WkbWriter, mpt: MultiPoint, byteOrder: WkbByteOrder) =
  let
    typ = wkbMultiPoint
    hasSrid = mpt.srid != 0
    pointnum = mpt.points.len

  w.data &= byteOrder.byte
  w.data &= typ.toByte(byteOrder, hasSrid)
  if hasSrid:
    w.data &= mpt.srid.toByte(byteOrder)

  w.data &= pointnum.uint32.toByte(byteOrder)
  for i in countup(0, pointnum-1):
    w.write(mpt.points[i], byteOrder)

proc write(w: WkbWriter, mls: MultiLineString, byteOrder: WkbByteOrder) =
  let
    typ = wkbMultiLineString
    hasSrid = mls.srid != 0
    linestringnum = mls.linestrings.len 

  w.data &= byteOrder.byte
  w.data &= typ.toByte(byteOrder, hasSrid)
  if hasSrid:
    w.data &= mls.srid.toByte(byteOrder)

  w.data &= linestringnum.uint32.toByte(byteOrder)
  for i in countup(0, linestringnum-1):
    w.write(mls.linestrings[i], byteOrder)

proc write(w: WkbWriter, mpg: MultiPolygon, byteOrder: WkbByteOrder) =
  let
    typ = wkbMultiPolygon
    hasSrid = mpg.srid != 0
    polygonnum = mpg.polygons.len

  w.data &= byteOrder.byte
  w.data &= typ.toByte(byteOrder, hasSrid)
  if hasSrid:
    w.data &= mpg.srid.toByte(byteOrder)

  w.data &= polygonnum.uint32.toByte(byteOrder)
  for i in countup(0, polygonnum-1):
    w.write(mpg.polygons[i], byteOrder)

#  forward declaration
proc write(w: WkbWriter, geo: Geometry, byteOrder: WkbByteOrder)

proc write(w: WkbWriter, gc: GeometryCollection, byteOrder: WkbByteOrder) =
  let
    typ = wkbGeometryCollection
    gcnum = gc.len
  w.data &= byteOrder.byte
  w.data &= typ.toByte(byteOrder)

  w.data &= gcnum.uint32.toByte(byteOrder)
  for i in countup(0, gcnum-1):
    w.write(gc[i], byteOrder)

proc write(w: WkbWriter, geo: Geometry, byteOrder: WkbByteOrder) =
  let kind = geo.kind
  case kind:
  of wkbPoint:
    w.write(geo.pt, byteOrder)
  of wkbLineString:
    w.write(geo.ls, byteOrder)
  of wkbPolygon:
    w.write(geo.pg, byteOrder)
  of wkbMultiPoint:
    w.write(geo.mpt, byteOrder)
  of wkbMultiLineString:
    w.write(geo.mls, byteOrder)
  of wkbMultiPolygon:
    w.write(geo.mpg, byteOrder)
  of wkbGeometryCollection:
    w.write(geo.gc, byteOrder)

proc toWkb*(pt: Point, byteOrder: WkbByteOrder = wkbNDR): string =
  var wkbWriter = newWkbWriter(byteOrder)
  wkbWriter.write(pt, byteOrder)
  return wkbWriter.data.toHex

proc toWkb*(ls: LineString, byteOrder: WkbByteOrder = wkbNDR): string =
  var wkbWriter = newWkbWriter(byteOrder)
  wkbWriter.write(ls, byteOrder)
  return wkbWriter.data.toHex

proc toWkb*(pg: Polygon, byteOrder: WkbByteOrder = wkbNDR): string =
  var wkbWriter = newWkbWriter(byteOrder)
  wkbWriter.write(pg, byteOrder)
  return wkbWriter.data.toHex

proc toWkb*(mpt: MultiPoint, byteOrder: WkbByteOrder = wkbNDR): string =
  var wkbWriter = newWkbWriter(byteOrder)
  wkbWriter.write(mpt, byteOrder)
  return wkbWriter.data.toHex

proc toWkb*(mls: MultiLineString, byteOrder: WkbByteOrder = wkbNDR): string =
  var wkbWriter = newWkbWriter(byteOrder)
  wkbWriter.write(mls, byteOrder)
  return wkbWriter.data.toHex

proc toWkb*(mpg: MultiPolygon, byteOrder: WkbByteOrder = wkbNDR): string =
  var wkbWriter = newWkbWriter(byteOrder)
  wkbWriter.write(mpg, byteOrder)
  return wkbWriter.data.toHex

proc toWkb*(gc: GeometryCollection, byteOrder: WkbByteOrder = wkbNDR): string =
  var wkbWriter = newWkbWriter(byteOrder)
  wkbWriter.write(gc, byteOrder)
  return wkbWriter.data.toHex

proc toWkb*(geo: Geometry, byteOrder: WkbByteOrder = wkbNDR): string =
  var wkbWriter = newWkbWriter(byteOrder)
  wkbWriter.write(geo, byteOrder)
  return wkbWriter.data.toHex