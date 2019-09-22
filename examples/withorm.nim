import norm/postgres
import nimgeo

include env

db("localhost", username, password, database):
  type
    City = object
      name: string
      # position: string
      position {.
        dbType: "GEOMETRY(POINT)"
        parseIt: parseWkbPoint(it)
        formatIt: it.toWkb
      .}: Point

when isMainModule:
  withDb:
    createTables(force=true)

    # var city = City(name: "beijing", position: "0101000000000000000000F03F0000000000000040")
    var city = City(
      name: "beijing",
      position: newPoint(1.0, 2.0)
    )
    city.insert()
    echo city.id
  
  withDb:
    let city = City.getOne(1)
    echo city.name
    echo city.position

  withDb:
    dropTables()