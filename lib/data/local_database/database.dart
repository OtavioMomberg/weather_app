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

  Future<void> insert({
    required CurrentWeatherModel cModel,
    required List<HourByHourModel> hModel,
    required List<ForecastModel> fModel,
    required String lastApiCall,
  }) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.insert(
        currentWeather,
        {
          currentId: 1,
          currentName: cModel.name,
          currentTemperature: cModel.temperature,
          currentMaxTemp: cModel.maxTemp,
          currentMinTemp: cModel.minTemp,
          currentChanceRain: cModel.chanceRain,
          currentCondition: cModel.condition,
          currentPressureMB: cModel.pressureMB,
          currentHumidity: cModel.humidity,
          currentFeelslike: cModel.feelslike,
          currentUvIndex: cModel.uvIndex,
          currentLastUpdated: cModel.lastUpdated,
          lastAPICall: lastApiCall,
        },
        conflictAlgorithm: .replace,
      );

      for (var item in hModel) {
        await txn.insert(
          hour, 
          {
            hourDate: item.date,
            hourHour: item.hour,
            hourTemperature: item.temperature,
            hourIconURL: item.iconURL,
          },
          conflictAlgorithm: .replace,
        );
      }

      for (var item in fModel) {
        await txn.insert(
          forecast, 
          {
            forecastDate: item.date,
            forecastMaxTemp: item.maxTemp,
            forecastMinTemp: item.minTemp,
            forecastMaxTempIconURL: item.maxTempIconURL,
            forecastMinTempIconURL: item.minTempIconURL,
          },
          conflictAlgorithm: .replace,
        );
      }
    });
  }

  //---------------------------------------------------------------------------------------------
  //                                      UPDATE
  //---------------------------------------------------------------------------------------------

  Future<void> update({
    required CurrentWeatherModel cModel,
    required String lastApiCall,
    required List<HourByHourModel> hModel, 
    required List<ForecastModel> fModel, 
  }) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.update(
        currentWeather,
        {
          currentName: cModel.name,
          currentTemperature: cModel.temperature,
          currentMaxTemp: cModel.maxTemp,
          currentMinTemp: cModel.minTemp,
          currentChanceRain: cModel.chanceRain,
          currentCondition: cModel.condition,
          currentPressureMB: cModel.pressureMB,
          currentHumidity: cModel.humidity,
          currentFeelslike: cModel.feelslike,
          currentUvIndex: cModel.uvIndex,
          currentLastUpdated: cModel.lastUpdated,
          lastAPICall: lastApiCall,
        },
        where: "$currentId = ?",
        whereArgs: [1],
      );

      for (int i=0; i<hModel.length; i++) {
        await txn.update(
          hour,
          {
            hourDate: hModel[i].date,
            hourHour: hModel[i].hour,
            hourTemperature: hModel[i].temperature,
            hourIconURL: hModel[i].iconURL,
          },
          where: "$hourId = ?",
          whereArgs: [i+1],
        );
      }

      for (int i=0; i<fModel.length; i++) {
        await txn.update(
          forecast,
          {
            forecastDate: fModel[i].date,
            forecastMaxTemp: fModel[i].maxTemp,
            forecastMinTemp: fModel[i].minTemp,
            forecastMaxTempIconURL: fModel[i].maxTempIconURL,
            forecastMinTempIconURL: fModel[i].minTempIconURL,
          },
          where: "$forecastId = ?",
          whereArgs: [i+1],
        );
      }
    });
  }
}