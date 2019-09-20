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
  CoordObj = object
    x*: float64
    y*: float64

  Point* = ref PointObj
  PointObj = object
    srid*: uint32
    coord*: Coord

  LinearRing* = seq[Coord]

  LineString* = ref LineStringObj
  LineStringObj = object
    srid*: uint32
    coords*: seq[Coord]

  Polygon* = ref PolygonObj
  PolygonObj = object
    srid*: uint32
    rings*: seq[LinearRing]

  MultiPoint* = ref MultiPointObj
  MultiPointObj = object
    srid*: uint32
    points*: seq[Point]

  MultiLineString* = ref MultiLineStringObj
  MultiLineStringObj = object
    srid*: uint32
    linestrings*: seq[LineString]

  MultiPolygon* = ref MultiPolygonObj
  MultiPolygonObj = object
    srid*: uint32
    polygons*: seq[Polygon]

  GeometryCollection* = seq[Geometry] #  Todo: 可能出现自引用

  Geometry* = ref GeometryObj
  GeometryObj = object
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

proc `==`*(a: Endianness, b: WkbByteOrder): bool =
  return a.int != b.int #  nim system.Endianness and WkbByteOrder 定义相反

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
      
proc newPoint*(x, y: float, srid = 0): Geometry =
  return Geometry(kind: wkbPoint,
                  pt: Point(srid: srid.uint32, coord: Coord(x: x, y: y)))

proc `srid=`*(geo: Geometry, srid: int) =
  case geo.kind:
  of wkbPoint: geo.pt.srid = srid.uint32
  of wkbLineString: geo.ls.srid = srid.uint32
  of wkbPolygon: geo.pg.srid = srid.uint32
  of wkbMultiPoint: geo.mpt.srid = srid.uint32
  of wkbMultiLineString: geo.mls.srid = srid.uint32
  of wkbMultiPolygon: geo.mpg.srid = srid.uint32
  else: discard
  
proc srid*(geo: Geometry): int =
  case geo.kind:
  of wkbPoint: return geo.pt.srid.int
  of wkbLineString: return geo.ls.srid.int
  of wkbPolygon: return geo.pg.srid.int
  of wkbMultiPoint: return geo.mpt.srid.int
  of wkbMultiLineString: return geo.mls.srid.int
  of wkbMultiPolygon: return geo.mpg.srid.int
  else: discard
  