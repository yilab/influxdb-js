window.InfluxDB = class InfluxDB
  constructor: (@host, @port, @username, @password, @database) ->

  test: () ->
    return true

  createDatabase: (databaseName, callback) ->
    url = @url("db")
    data = {name: databaseName}
    $.post url, JSON.stringify(data), callback

  deleteDatabase: (databaseName) ->
    url = @url("db/#{databaseName}")
    $.delete url

  getDatabaseNames: () ->
    url = @url("dbs")
    $.get url

  createUser: (databaseName, username, password, callback) ->
    url = @url("db/#{databaseName}/users")
    data = {username: username, password: password}
    $.post url, JSON.stringify(data), callback

  readPoint: (fieldNames, seriesNames, callback) ->
    url = @url("db/#{@database}/series")
    query = "SELECT #{fieldNames} FROM #{seriesNames};"
    url += "&q=" + encodeURIComponent(query)
    $.get url, null, callback

  _readPoint: (query, callback) ->
    url = @seriesUrl(@database)
    url += "&q=" + encodeURIComponent(query)
    $.get url, {}, callback

  writePoint: (seriesName, values, options, callback) ->
    options ?= {}
    datum = {points: [], name: seriesName, columns: []}
    point = []

    for k, v of values
      point.push v
      datum.columns.push k

    datum.points.push point
    data = [datum]

    url = @seriesUrl(@database)
    $.post url, JSON.stringify(data), callback

  url: (action) ->
    "http://#{@host}:#{@port}/#{action}?u=#{@username}&p=#{@password}"

  seriesUrl: (databaseName, query) ->
    @url("db/#{databaseName}/series")
