import oids, strutils

type
  Point* = object
    x: float64
    y: float64

  WkbByteOrder = enum
    wkbXDR  # Big Endian
    wkbNDR  # Little Endian

  WkbGeometryType {.size: sizeof(cint).} = enum
    wkbNull
    wkbPoint
    wkbLineString
    wkbPolygon
    wkbMultiPoint
    wkbMultiLineString
    wkbMultiPolygon
    wkbGeometryCollection

  WkbPoint* = object
    byteOrder: WkbByteOrder
    wkbType: uint32
    # point: Point
    x: float64
    y: float64

proc parseEndian(str: cstring): WkbByteOrder =
  result = wkbNDR

# proc parseBytes(str: cstring): cstring =


proc parseWkbPoint(str: cstring): WkbPoint =
  var bytes = cast[cstring](addr(result.byteOrder))
  echo len(str)
  # echo high(str)
  bytes[0] = chr((hexbyte(str[0]) shl 4) or hexbyte(str[1]))
  if result.byteOrder == wkbNDR:
    echo "Little Endian"
    
  # var pos = 1
  # while pos < str.len:
  #   bytes[pos] = chr((hexbyte(str[2 * pos]) shl 4) or hexbyte(str[2 * pos + 1]))
  #   inc(pos)
  bytes[1] = chr((hexbyte(str[2]) shl 4) or hexbyte(str[3]))
  bytes[2] = chr((hexbyte(str[4]) shl 4) or hexbyte(str[5]))
  bytes[3] = chr((hexbyte(str[6]) shl 4) or hexbyte(str[7]))
  bytes[4] = chr((hexbyte(str[8]) shl 4) or hexbyte(str[9]))

  # bytes[5] = chr((hexbyte(str[10]) shl 4) or hexbyte(str[11]))
  # bytes[6] = chr((hexbyte(str[12]) shl 4) or hexbyte(str[13]))
  # bytes[7] = chr((hexbyte(str[14]) shl 4) or hexbyte(str[15]))
  # bytes[8] = chr((hexbyte(str[16]) shl 4) or hexbyte(str[17]))
  # bytes[9] = chr((hexbyte(str[18]) shl 4) or hexbyte(str[19]))
  # bytes[10] = chr((hexbyte(str[20]) shl 4) or hexbyte(str[21]))
  # bytes[11] = chr((hexbyte(str[22]) shl 4) or hexbyte(str[23]))
  # bytes[12] = chr((hexbyte(str[24]) shl 4) or hexbyte(str[25]))

  # bytes[13] = chr((hexbyte(str[4]) shl 4) or hexbyte(str[5]))
  # bytes[14] = chr((hexbyte(str[6]) shl 4) or hexbyte(str[7]))
  # bytes[15] = chr((hexbyte(str[8]) shl 4) or hexbyte(str[9]))
  # bytes[16] = chr((hexbyte(str[8]) shl 4) or hexbyte(str[9]))
  # bytes[17] = chr((hexbyte(str[4]) shl 4) or hexbyte(str[5]))
  # bytes[18] = chr((hexbyte(str[6]) shl 4) or hexbyte(str[7]))
  # bytes[19] = chr((hexbyte(str[8]) shl 4) or hexbyte(str[9]))
  # bytes[20] = chr((hexbyte(str[8]) shl 4) or hexbyte(str[9]))


when isMainModule:
  # let wkbstr = "01 01000000 000000000000F03F 000000000000F03F"
  let wkbstr = "01000000013FF00000000000003FF0000000000000"

  var p = parseWkbPoint(wkbstr)
  echo repr p
  echo p.wkbType.toHex
