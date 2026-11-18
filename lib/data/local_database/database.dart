import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_app/data/local_database/tables.dart';
import 'package:weather_app/data/models/current_weather_model.dart';
import 'package:weather_app/data/models/forecast_model.dart';
import 'package:weather_app/data/models/hour_by_hour_model.dart';

final class LocalDatabase._() {
  Database? _db;

  static final _instance = LocalDatabase._();
  factory instance() => _instance;

  Future<Database> get database async {
    if (_db != null) { return _db!; }
    _db = await _createDatabase();
    return _db!;
  }

  Future<Database> _createDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "weather.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(currentTable);
        await db.execute(hourTable);
        await db.execute(forecastTable);
      },
    );
    return database;
  }

  //---------------------------------------------------------------------------------------------
  //                                      SELECT
  //---------------------------------------------------------------------------------------------

  Future<CurrentWeatherModel?> selectCurrent() async {
    final db = await database;
    final data = await db.query(currentWeather);

    final formatedData = data.map(
      (item) => CurrentWeatherModel(
        name: item[currentName] as String,
        temperature: item[currentTemperature] as double,
        maxTemp: item[currentMaxTemp] as double,
        minTemp: item[currentMinTemp] as double,
        chanceRain: item[currentChanceRain] as int,
        condition: item[currentCondition] as String,
        pressureMB: item[currentPressureMB] as double,
        humidity: item[currentHumidity] as int,
        feelslike: item[currentFeelslike] as double,
        uvIndex: item[currentUvIndex] as double,
        lastUpdated: item[currentLastUpdated] as String,
      ),
    ).firstOrNull;
    return formatedData;
  }

  Future<String?> selectLastApiCall() async {
    final db = await database;
    final data = await db.query(
      currentWeather,
      columns: [lastAPICall],
      limit: 1,
    );

    return data.firstOrNull?[lastAPICall] as String?;
  }

  Future<List<HourByHourModel>> selectHour() async {
    final db = await database;
    final data = await db.query(hour);

    final formatedData = data.map(
      (item) => HourByHourModel(
        date: item[hourDate] as String,
        hour: item[hourHour] as String,
        temperature: item[hourTemperature] as double,
        iconURL: item[hourIconURL] as String,
      ),
    ).toList();
    return formatedData;
  }

  Future<List<ForecastModel>> selectForecast() async {
    final db = await database;
    final data = await db.query(forecast);

    final formatedData = data.map(
      (item) => ForecastModel(
        date: item[forecastDate] as String,
        maxTemp: item[forecastMaxTemp] as double,
        minTemp: item[forecastMinTemp] as double,
        maxTempIconURL: item[forecastMaxTempIconURL] as String,
        minTempIconURL: item[forecastMinTempIconURL] as String,
      ),
    ).toList();
    return formatedData;
  }

  //---------------------------------------------------------------------------------------------
  //                                      INSERT
  //---------------------------------------------------------------------------------------------

  Future<int> insertCurrent({
    required CurrentWeatherModel model,
    required String lastApiCall,
  }) async {
    final db = await database;

    return await db.insert(
      currentWeather,
      {
        currentId: 1,
        currentName: model.name,
        currentTemperature: model.temperature,
        currentMaxTemp: model.maxTemp,
        currentMinTemp: model.minTemp,
        currentChanceRain: model.chanceRain,
        currentCondition: model.condition,
        currentPressureMB: model.pressureMB,
        currentHumidity: model.humidity,
        currentFeelslike: model.feelslike,
        currentUvIndex: model.uvIndex,
        currentLastUpdated: model.lastUpdated,
        lastAPICall: lastApiCall,
      },
      conflictAlgorithm: .replace,
    );
  }

  Future<int> insertHour({required HourByHourModel model}) async {
    final db = await database;

    return await db.insert(
      hour,
      {
        hourDate: model.date,
        hourHour: model.hour,
        hourTemperature: model.temperature,
        hourIconURL: model.iconURL,
      },
      conflictAlgorithm: .replace,
    );
  }

  Future<int> insertForecast({required ForecastModel model}) async {
    final db = await database;

    return await db.insert(
      forecast,
      {
        forecastDate: model.date,
        forecastMaxTemp: model.maxTemp,
        forecastMinTemp: model.minTemp,
        forecastMaxTempIconURL: model.maxTempIconURL,
        forecastMinTempIconURL: model.minTempIconURL,
      },
      conflictAlgorithm: .replace,
    );
  }

  //---------------------------------------------------------------------------------------------
  //                                      UPDATE
  //---------------------------------------------------------------------------------------------

  Future<int> updateCurrent({
    required CurrentWeatherModel model,
    required String lastApiCall,
  }) async {
    final db = await database;

    return await db.update(
      currentWeather,
      {
        currentName: model.name,
        currentTemperature: model.temperature,
        currentMaxTemp: model.maxTemp,
        currentMinTemp: model.minTemp,
        currentChanceRain: model.chanceRain,
        currentCondition: model.condition,
        currentPressureMB: model.pressureMB,
        currentHumidity: model.humidity,
        currentFeelslike: model.feelslike,
        currentUvIndex: model.uvIndex,
        currentLastUpdated: model.lastUpdated,
        lastAPICall: lastApiCall,
      },
      where: "$currentId = ?",
      whereArgs: [1],
    );
  }

  Future<int> updateHour({
    required HourByHourModel model, 
    required int id
  }) async {
    final db = await database;

    return await db.update(
      hour,
      {
        hourDate: model.date,
        hourHour: model.hour,
        hourTemperature: model.temperature,
        hourIconURL: model.iconURL,
      },
      where: "$hourId = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateForecast({
    required ForecastModel model, 
    required int id
  }) async {
    final db = await database;

    return await db.update(
      forecast,
      {
        forecastDate: model.date,
        forecastMaxTemp: model.maxTemp,
        forecastMinTemp: model.minTemp,
        forecastMaxTempIconURL: model.maxTempIconURL,
        forecastMinTempIconURL: model.minTempIconURL,
      },
      where: "$forecastId = ?",
      whereArgs: [id],
    );
  }
}