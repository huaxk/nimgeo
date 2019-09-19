import endians

import geometry

type
  WkbWriter* = ref object
    data: seq[byte]
    pos: int
    bytesOrder: WkbByteOrder

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

proc newWkbWriter*(bytesOrder: WkbByteOrder): WkbWriter =
  new(result)
  result.bytesOrder = bytesOrder

proc write*(w: WkbWriter, pt: Point, bytesOrder: WkbByteOrder,
           typ: WkbGeometryType) =
  w.data.add(bytesOrder.byte)
  w.data.add(typ.uint32.toByte(bytesOrder))
  w.data &= pt.coord.x.toByte(bytesOrder)
  w.data &= pt.coord.y.toByte(bytesOrder)

proc write*(w: WkbWriter, geo: Geometry, byteOrder: WkbByteOrder) =
  let kind = geo.kind
  case kind:
  of wkbPoint:
    w.write(geo.pt, byteOrder, kind)
  else: discard

proc toWkb*(geo: Geometry, byteOrder: WkbByteOrder = wkbNDR): string =
  var wkbWriter = newWkbWriter(byteOrder)
  wkbWriter.write(geo, byteOrder)
  return wkbWriter.data.toHex()