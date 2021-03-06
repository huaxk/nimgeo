import nimgeo/geometry

# addHandler(newConsoleLogger(levelThreshold = lvlDebug))

const srid = 4326'u32

#  Point
let ptCoord = Coord(x: 1.0, y: 2.0)
let pt = Point(coord: ptCoord)
let spt = Point(srid: srid, coord: ptCoord)
let ptGeometry = Geometry(kind: wkbPoint, pt: pt)
let sptGeometry = Geometry(kind: wkbPoint, pt: spt)
const wktpt = "POINT(1.0 2.0)"
const wktspt = "SRID=4326; POINT(1.0 2.0)"
const jsonpt = """{"type":"Point","coordinates":[1.0,2.0]}"""
const jsonspt = """{"type":"Point","coordinates":[1.0,2.0],"crs":{"type":"name","properties":{"name":"EPSG:4326"}}}"""
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


#  LineString     
let coords = @[Coord(x: 1.0, y: 1.0), Coord(x: 2.0, y: 2.0)]
let ls = LineString(coords: coords)
let sls = LineString(srid: srid, coords: coords)
let lsGeometry = Geometry(kind: wkbLineString, ls: ls)
let slsGeometry = Geometry(kind: wkbLineString, ls: sls)
const wktls = "LINESTRING(1.0 1.0, 2.0 2.0)"
const wktsls = "SRID=4326; LINESTRING(1.0 1.0, 2.0 2.0)"
const jsonls = """{"type":"LineString","coordinates":[[1.0,1.0],[2.0,2.0]]}"""
const jsonsls = """{"type":"LineString","coordinates":[[1.0,1.0],[2.0,2.0]],"crs":{"type":"name","properties":{"name":"EPSG:4326"}}}"""
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

#  Polygon
let rings = @[
              @[Coord(x: 1.0, y: 1.0), Coord(x: 2.0, y: 2.0),
                Coord(x: 3.0, y: 3.0), Coord(x: 1.0, y: 1.0)
              ],
              @[Coord(x:4.0, y: 4.0), Coord(x: 5.0, y: 5.0),
                Coord(x: 6.0, y: 6.0), Coord(x: 4.0, y: 4.0)
              ]
            ]
let pg = Polygon(rings: rings)
let spg = Polygon(srid: srid, rings: rings)
let pgGeometry = Geometry(kind: wkbPolygon, pg: pg)
let spgGeometry = Geometry(kind: wkbPolygon, pg: spg)
const wktring = "(1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0)"
const wktpg = "POLYGON((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0))"
const wktspg = "SRID=4326; POLYGON((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0))"
const jsonpg = """{"type":"Polygon","coordinates":[[[1.0,1.0],[2.0,2.0],[3.0,3.0],[1.0,1.0]],[[4.0,4.0],[5.0,5.0],[6.0,6.0],[4.0,4.0]]]}"""
const jsonspg = """{"type":"Polygon","coordinates":[[[1.0,1.0],[2.0,2.0],[3.0,3.0],[1.0,1.0]],[[4.0,4.0],[5.0,5.0],[6.0,6.0],[4.0,4.0]]],"crs":{"type":"name","properties":{"name":"EPSG:4326"}}}"""
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

#  MultiPoint
let points = @[Point(coord: Coord(x: 1.0, y: 1.0)), 
               Point(coord: Coord(x: 2.0, y: 2.0))]
let mpt = MultiPoint(points: points)
let smpt = MultiPoint(srid: srid, points: points)
let mptGeometry = Geometry(kind: wkbMultiPoint, mpt: mpt)
let smptGeometry = Geometry(kind: wkbMultiPoint, mpt: smpt)
const wktmpt = "MULTIPOINT(1.0 1.0, 2.0 2.0)"
const wktsmpt = "SRID=4326; MULTIPOINT(1.0 1.0, 2.0 2.0)"
const jsonmpt = """{"type":"MultiPoint","coordinates":[[1.0,1.0],[2.0,2.0]]}"""
const jsonsmpt = """{"type":"MultiPoint","coordinates":[[1.0,1.0],[2.0,2.0]],"crs":{"type":"name","properties":{"name":"EPSG:4326"}}}"""
const wkbnmpt = "01"&
                "04000000"&
                "02000000"&# number of point
                "01"&
                "01000000"&
                "000000000000F03F"&
                "000000000000F03F"&
                "01"&
                "01000000"&
                "0000000000000040"&
                "0000000000000040"

const wkbnsmpt = "01"&
                 "04000020"&
                 "E6100000"&#  srid = 4326
                 "02000000"&# number of point
                 "01"&
                 "01000000"&
                 "000000000000F03F"&
                 "000000000000F03F"&
                 "01"&
                 "01000000"&
                 "0000000000000040"&
                 "0000000000000040"

const wkbxmpt = "00"&
                "00000004"&
                "00000002"&# number of point
                "00"&
                "00000001"&
                "3FF0000000000000"&
                "3FF0000000000000"&
                "00"&
                "00000001"&
                "4000000000000000"&
                "4000000000000000"                

const wkbxsmpt = "00"&
                 "20000004"&
                 "000010E6"&#  srid = 4326
                 "00000002"&# number of point
                 "00"&
                 "00000001"&
                 "3FF0000000000000"&
                 "3FF0000000000000"&
                 "00"&
                 "00000001"&
                 "4000000000000000"&
                 "4000000000000000" 

#  MultiLineString
let lss = @[
            LineString(coords: @[Coord(x: 1.0, y: 1.0), Coord(x: 2.0, y: 2.0)]),
            LineString(coords: @[Coord(x: 3.0, y: 3.0), Coord(x: 4.0, y: 4.0)])
          ]
let mls = MultiLineString(linestrings: lss)
let smls = MultiLineString(srid: srid, linestrings: lss)
let mlsGeometry = Geometry(kind: wkbMultiLineString, mls: mls)
let smlsGeometry = Geometry(kind: wkbMultiLineString, mls: smls)
const wktmls = "MULTIlINESTRING((1.0 1.0, 2.0 2.0), (3.0 3.0, 4.0 4.0))"
const wktsmls = "SRID=4326; MULTIlINESTRING((1.0 1.0, 2.0 2.0), (3.0 3.0, 4.0 4.0))"
const jsonmls = """{"type":"MultiLineString","coordinates":[[[1.0,1.0],[2.0,2.0]],[[3.0,3.0],[4.0,4.0]]]}"""
const jsonsmls = """{"type":"MultiLineString","coordinates":[[[1.0,1.0],[2.0,2.0]],[[3.0,3.0],[4.0,4.0]]],"crs":{"type":"name","properties":{"name":"EPSG:4326"}}}"""
const wkbnmls = "01"&
                "05000000"&
                "02000000"&# number of LineString
                "01"&
                "02000000"&
                "02000000"&
                "000000000000F03F"&
                "000000000000F03F"&
                "0000000000000040"&
                "0000000000000040"&
                "01"&
                "02000000"&
                "02000000"&
                "0000000000000840"&
                "0000000000000840"&
                "0000000000001040"&
                "0000000000001040"
const wkbnsmls = "01"&
                  "05000020"&
                  "E6100000"&#  srid = 4326
                  "02000000"&# number of LineString
                  "01"&
                  "02000000"&
                  "02000000"&
                  "000000000000F03F"&
                  "000000000000F03F"&
                  "0000000000000040"&
                  "0000000000000040"&
                  "01"&
                  "02000000"&
                  "02000000"&
                  "0000000000000840"&
                  "0000000000000840"&
                  "0000000000001040"&
                  "0000000000001040"
const wkbxmls = "00"&
                "00000005"&
                "00000002"&# number of LineString
                "00"&
                "00000002"&
                "00000002"&
                "3FF0000000000000"&
                "3FF0000000000000"&
                "4000000000000000"&
                "4000000000000000"&
                "00"&
                "00000002"&
                "00000002"&
                "4008000000000000"&
                "4008000000000000"&
                "4010000000000000"&
                "4010000000000000"
const wkbxsmls = "00"&
                  "20000005"&
                  "000010E6"&#  srid = 4326
                  "00000002"&# number of LineString
                  "00"&
                  "00000002"&
                  "00000002"&
                  "3FF0000000000000"&
                  "3FF0000000000000"&
                  "4000000000000000"&
                  "4000000000000000"&
                  "00"&
                  "00000002"&
                  "00000002"&
                  "4008000000000000"&
                  "4008000000000000"&
                  "4010000000000000"&
                  "4010000000000000"

#  MultiPolygon
let polygons = @[
            Polygon(rings: @[
              @[Coord(x: 1.0, y: 1.0), Coord(x: 2.0, y: 2.0),
                Coord(x: 3.0, y: 3.0), Coord(x: 1.0, y: 1.0)]
            ]),
            Polygon(rings: @[
              @[Coord(x: 3.0, y: 3.0), Coord(x: 4.0, y: 4.0),
                Coord(x: 5.0, y: 5.0), Coord(x: 3.0, y: 3.0)],
              @[Coord(x: 6.0, y: 6.0), Coord(x: 7.0, y: 7.0),
                Coord(x: 8.0, y: 8.0), Coord(x: 6.0, y: 6.0)]
            ])
          ]
let mpg = MultiPolygon(polygons: polygons)
let smpg = MultiPolygon(srid: srid, polygons: polygons)
let mpgGeometry = Geometry(kind: wkbMultiPolygon, mpg: mpg)
let smpgGeometry = Geometry(kind: wkbMultiPolygon, mpg: smpg)
const wktmpg = "MULTIPOLYGON(((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0)), ((3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0), (6.0 6.0, 7.0 7.0, 8.0 8.0, 6.0 6.0)))"
const wktsmpg = "SRID=4326; MULTIPOLYGON(((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0)), ((3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0), (6.0 6.0, 7.0 7.0, 8.0 8.0, 6.0 6.0)))"
const jsonmpg = """{"type":"MultiPolygon","coordinates":[[[[1.0,1.0],[2.0,2.0],[3.0,3.0],[1.0,1.0]]],[[[3.0,3.0],[4.0,4.0],[5.0,5.0],[3.0,3.0]],[[6.0,6.0],[7.0,7.0],[8.0,8.0],[6.0,6.0]]]]}"""
const jsonsmpg = """{"type":"MultiPolygon","coordinates":[[[[1.0,1.0],[2.0,2.0],[3.0,3.0],[1.0,1.0]]],[[[3.0,3.0],[4.0,4.0],[5.0,5.0],[3.0,3.0]],[[6.0,6.0],[7.0,7.0],[8.0,8.0],[6.0,6.0]]]],"crs":{"type":"name","properties":{"name":"EPSG:4326"}}}"""
const wkbnmpg = "01"&
                "06000000"&
                "02000000"&# number of Ploygon
                "01"&
                "03000000"&# Ploygon
                "01000000"&# number of rings
                "04000000"&# number of points
                "000000000000F03F"&
                "000000000000F03F"&
                "0000000000000040"&
                "0000000000000040"&
                "0000000000000840"&
                "0000000000000840"&
                "000000000000F03F"&
                "000000000000F03F"&
                "01"&
                "03000000"&# Ploygon
                "02000000"&# number of rings
                "04000000"&# number of points
                "0000000000000840"&
                "0000000000000840"&
                "0000000000001040"&
                "0000000000001040"&
                "0000000000001440"&
                "0000000000001440"&
                "0000000000000840"&
                "0000000000000840"&
                "04000000"&# number of points
                "0000000000001840"&
                "0000000000001840"&
                "0000000000001C40"&
                "0000000000001C40"&
                "0000000000002040"&
                "0000000000002040"&
                "0000000000001840"&
                "0000000000001840"
const wkbnsmpg =  "01"&
                  "06000020"&
                  "E6100000"&#  srid = 4326
                  "02000000"&# number of Ploygon
                  "01"&
                  "03000000"&# Ploygon
                  "01000000"&# number of rings
                  "04000000"&# number of points
                  "000000000000F03F"&
                  "000000000000F03F"&
                  "0000000000000040"&
                  "0000000000000040"&
                  "0000000000000840"&
                  "0000000000000840"&
                  "000000000000F03F"&
                  "000000000000F03F"&
                  "01"&
                  "03000000"&# Ploygon
                  "02000000"&# number of rings
                  "04000000"&# number of points
                  "0000000000000840"&
                  "0000000000000840"&
                  "0000000000001040"&
                  "0000000000001040"&
                  "0000000000001440"&
                  "0000000000001440"&
                  "0000000000000840"&
                  "0000000000000840"&
                  "04000000"&# number of points
                  "0000000000001840"&
                  "0000000000001840"&
                  "0000000000001C40"&
                  "0000000000001C40"&
                  "0000000000002040"&
                  "0000000000002040"&
                  "0000000000001840"&
                  "0000000000001840"
const wkbxmpg = "00"&
                "00000006"&
                "00000002"&# number of Ploygon
                "00"&
                "00000003"&# Ploygon
                "00000001"&# number of rings
                "00000004"&# number of points
                "3FF0000000000000"&
                "3FF0000000000000"&
                "4000000000000000"&
                "4000000000000000"&
                "4008000000000000"&
                "4008000000000000"&
                "3FF0000000000000"&
                "3FF0000000000000"&
                "00"&
                "00000003"&# Ploygon
                "00000002"&# number of rings
                "00000004"&# number of points
                "4008000000000000"&
                "4008000000000000"&
                "4010000000000000"&
                "4010000000000000"&
                "4014000000000000"&
                "4014000000000000"&
                "4008000000000000"&
                "4008000000000000"&
                "00000004"&# number of points
                "4018000000000000"&
                "4018000000000000"&
                "401C000000000000"&
                "401C000000000000"&
                "4020000000000000"&
                "4020000000000000"&
                "4018000000000000"&
                "4018000000000000"
const wkbxsmpg =  "00"&
                  "20000006"&
                  "000010E6"&#  srid = 4326
                  "00000002"&# number of Ploygon
                  "00"&
                  "00000003"&# Ploygon
                  "00000001"&# number of rings
                  "00000004"&# number of points
                  "3FF0000000000000"&
                  "3FF0000000000000"&
                  "4000000000000000"&
                  "4000000000000000"&
                  "4008000000000000"&
                  "4008000000000000"&
                  "3FF0000000000000"&
                  "3FF0000000000000"&
                  "00"&
                  "00000003"&# Ploygon
                  "00000002"&# number of rings
                  "00000004"&# number of points
                  "4008000000000000"&
                  "4008000000000000"&
                  "4010000000000000"&
                  "4010000000000000"&
                  "4014000000000000"&
                  "4014000000000000"&
                  "4008000000000000"&
                  "4008000000000000"&
                  "00000004"&# number of points
                  "4018000000000000"&
                  "4018000000000000"&
                  "401C000000000000"&
                  "401C000000000000"&
                  "4020000000000000"&
                  "4020000000000000"&
                  "4018000000000000"&
                  "4018000000000000"

#  GeometryCollection
let gc = @[Geometry(kind: wkbPoint,
                    pt: Point(coord: Coord(x: 1.0, y: 1.0))),
           Geometry(kind: wkbLineString,
                    ls: LineString(coords: @[Coord(x: 1.0, y: 1.0),
                                             Coord(x: 2.0, y: 2.0)
                                           ]))
          ]
let gcGeometry = Geometry(kind: wkbGeometryCollection, gc: gc)
const wktgc = "GEOMETRYCOLLECTION(POINT(1.0 1.0), LINESTRING(1.0 1.0, 2.0 2.0))"
const jsongc = """{"type":"GeometryCollection","geometries":[{"type":"Point","coordinates":[1.0,1.0]},{"type":"LineString","coordinates":[[1.0,1.0],[2.0,2.0]]}]}"""
const wkbngc = "01"&
              "07000000"&#  GeometryCollection
              "02000000"&#  number of geometry
              "01"&
              "01000000"&#  Point
              "000000000000F03F"&
              "000000000000F03F"&
              "01"&
              "02000000"&# LineString
              "02000000"&
              "000000000000F03F"&
              "000000000000F03F"&
              "0000000000000040"&
              "0000000000000040"
const wkbxgc = "00"&
              "00000007"&#  GeometryCollection
              "00000002"&#  number of geometry
              "00"&
              "00000001"&#  Point
              "3FF0000000000000"&
              "3FF0000000000000"&
              "00"&
              "00000002"&# LineString
              "00000002"&
              "3FF0000000000000"&
              "3FF0000000000000"&
              "4000000000000000"&
              "4000000000000000"