// CURRENT WEATHER TABLE
const currentWeather = "current";
const currentId = "id";
const currentName = "name";
const currentTemperature = "temperature";
const currentMaxTemp = "max_temp";
const currentMinTemp = "min_temp";
const currentChanceRain = "chance_of_rain";
const currentCondition = "condition";
const currentPressureMB = "pressure_mb";
const currentHumidity = "humidity";
const currentFeelslike = "feelslike";
const currentUvIndex = "uv_index";
const currentLastUpdated = "last_updated";
const lastAPICall = "last_api_call";

final currentTable = '''
  CREATE TABLE IF NOT EXISTS $currentWeather (
    $currentId INTEGER PRIMARY KEY,
    $currentName TEXT NOT NULL,
    $currentTemperature REAL NOT NULL,
    $currentMaxTemp REAL NOT NULL,
    $currentMinTemp REAL NOT NULL,
    $currentChanceRain INTEGER NOT NULL,
    $currentCondition TEXT NOT NULL,
    $currentPressureMB REAL NOT NULL,
    $currentHumidity INTEGER NOT NULL,
    $currentFeelslike REAL NOT NULL,
    $currentUvIndex REAL NOT NULL,
    $currentLastUpdated TEXT NOT NULL,
    $lastAPICall TEXT NOT NULL
  )
''';

// HOURLY WEATHER TABLE
const hour = "hour";
const hourId = "id";
const hourDate = "date";
const hourHour = "hour";
const hourTemperature = "temperature";
const hourIconURL = "icon_url";

final hourTable = '''
  CREATE TABLE IF NOT EXISTS $hour (
    $hourId INTEGER PRIMARY KEY AUTOINCREMENT,
    $hourDate TEXT NOT NULL,
    $hourHour TEXT NOT NULL,
    $hourTemperature REAL NOT NULL,
    $hourIconURL TEXT NOT NULL
  )
''';

// FORECAST WEATHER TABLE
const forecast = "forecast";
const forecastId = "id";
const forecastDate = "date";
const forecastMaxTemp = "max_temp";
const forecastMinTemp = "min_temp";
const forecastMaxTempIconURL = "max_temp_icon_url";
const forecastMinTempIconURL = "min_temp_icon_url";

final forecastTable = '''
  CREATE TABLE IF NOT EXISTS $forecast (
    $forecastId INTEGER PRIMARY KEY AUTOINCREMENT,
    $forecastDate TEXT NOT NULL,
    $forecastMaxTemp REAL NOT NULL,
    $forecastMinTemp REAL NOT NULL,
    $forecastMaxTempIconURL TEXT NOT NULL,
    $forecastMinTempIconURL TEXT NOT NULL
  )
''';