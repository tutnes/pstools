#This was inspired by
#https://stackoverflow.com/questions/8423541/how-do-you-run-a-sql-server-query-from-powershell
    param(
        [string] $dataSource = ".\SQLEXPRESS",
        [string] $database = "MasterData",
        [string] $sqlCommand = $(throw "Please specify a query."),
        [string] $port,
        [string] $userId,
        [string] $password,
        [int] $windowsAuth = 0
      )
    if (!$port) {
    $port = 1433
    }
    if ($windowsAuth -eq 1) {
    $connectionString = "Integrated Security=SSPI;"
    }
    $connectionString += "Data Source=$dataSource,$port; " +
            "Initial Catalog=$database;" +
            "User ID=$userId;" + "Password=$password"

    $connection = new-object system.data.SqlClient.SQLConnection($connectionString)
    $command = new-object system.data.sqlclient.sqlcommand($sqlCommand,$connection)
    $connection.Open()

    $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataSet) | Out-Null

    $connection.Close()
    $dataSet.Tables

