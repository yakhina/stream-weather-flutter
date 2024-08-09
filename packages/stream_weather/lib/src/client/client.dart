// ignore_for_file: unnecessary_getters_setters, avoid_print

import 'dart:async';
import 'package:stream_weather/src/client/retry_policy.dart';
import 'package:stream_weather/src/core/api/stream_weather_api.dart';
import 'package:stream_weather/src/core/http/stream_weather_http_client.dart';
import 'package:stream_weather/stream_weather.dart';

/// Handler function used for logging records. Function requires a single
/// [LogRecord] as the only parameter.
typedef LogHandlerFunction = void Function(LogRecord record);

final _levelEmojiMapper = {
  Level.INFO: '🟢',
  Level.WARNING: '🟠',
  Level.SEVERE: '🔴',
};

/// The Dart client for OpenWeatherMap API,
/// a service for retrieving weather by date and searching for locations to retrieve exact longitude and latitude.
/// 
/// 
/// The StreamWeatherClient client will manage API call, event and error handling 
/// and manage the http connection to OpenWeatherMap [https://openweathermap.org/] servers.
///
/// ```dart
/// final client = StreamWeatherClient("openweather-app-id");
/// ```
class StreamWeatherClient {
  /// Create a client instance with default options.
  /// You should only create the client once and re-use it across your
  /// application.
  StreamWeatherClient(
    String appId, {
    this.logLevel = Level.WARNING,
    this.logHandlerFunction = StreamWeatherClient.defaultLogHandler,
    RetryPolicy? retryPolicy,
    String? baseURL,
    Duration connectTimeout = const Duration(seconds: 6),
    Duration receiveTimeout = const Duration(seconds: 6),
    StreamWeatherApi? streamWeatherApi,
    Iterable<Interceptor>? chatApiInterceptors,
  }) {
    logger.info('Initiating new StreamWeatherClient');

    final options = StreamWeatherHttpClientOptions(
      baseUrl: baseURL,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );

    _streamWeatherApi = streamWeatherApi ??
        StreamWeatherApi(
          appId,
          options: options,
          logger: detachedLogger('🕸️'),
          interceptors: chatApiInterceptors,
        );

    _retryPolicy = retryPolicy ??
        RetryPolicy(
          shouldRetry: (_, __, error) {
            return error is StreamWeatherNetworkError && error.isRetriable;
          },
        );
  
  }


  late final StreamWeatherApi _streamWeatherApi;

  /// Additional headers for all requests
  static Map<String, Object?> additionalHeaders = {};


  late final RetryPolicy _retryPolicy;

  /// The retry policy options getter
  RetryPolicy get retryPolicy => _retryPolicy;

  /// By default the Stream Weather client will write all messages with level Warn or
  /// Error to stdout.
  ///
  /// During development you might want to enable more logging information,
  /// you can change the default log level when constructing the client.
  ///
  /// ```dart
  /// final client = StreamWeatherClient("open-weather-map-app-id",
  /// logLevel: Level.INFO);
  /// ```
  final Level logLevel;

  /// Client specific logger instance.
  /// Refer to the class [Logger] to learn more about the specific
  /// implementation.
  late final Logger logger = detachedLogger('🌦️');

  /// A function that has a parameter of type [LogRecord].
  /// This is called on every new log record.
  /// By default the client will use the handler returned by
  /// [_getDefaultLogHandler].
  /// Setting it you can handle the log messages directly instead of have them
  /// written to stdout,
  /// this is very convenient if you use an error tracking tool or if you want
  /// to centralize your logs into one facility.
  ///
  /// ```dart
  /// myLogHandlerFunction = (LogRecord record) {
  ///  // do something with the record (ie. send it to Sentry or Fabric)
  /// }
  ///
  /// final client = StreamChatClient("open-weather-map-app-id",
  /// logHandlerFunction: myLogHandlerFunction);
  ///```
  final LogHandlerFunction logHandlerFunction;

  /// Default log handler function for the [StreamWeatherClient] logger.
  static void defaultLogHandler(LogRecord record) {
    print(
      '${record.time} '
      '${_levelEmojiMapper[record.level] ?? record.level.name} '
      '${record.loggerName} ${record.message} ',
    );
    if (record.error != null) print(record.error);
    if (record.stackTrace != null) print(record.stackTrace);
  }

  /// Default logger for the [StreamWeatherClient].
  Logger detachedLogger(String name) => Logger.detached(name)
    ..level = logLevel
    ..onRecord.listen(logHandlerFunction);

 
  /// Requests weather with a given coordinates.
  Future<QueryWeatherByDateResponse> queryWeather({
    double? lat,
    double? lon,
    int? dt,
    WeatherUnitsType? units,
    String? appId,
  }) async {
    final response = await _streamWeatherApi.weather.queryWeather(
      lat: lat,
      lon: lon,
      dt: dt,
      units: units,
      appId: appId,
    );
    return response;
  }

  /// Requests locations  by a serach query
  Future<QueryCoordinatesByLocationNameResponse> queryCoordinates({
    String? q,
    int? limit,
    String? appId,
  }) async {
    final response = await _streamWeatherApi.locations.queryCoordinates(
      q: q,
      limit: limit,
      appId: appId,
    );
    return response;
  }
}


// /// The class that handles the state of the channel listening to the events
// class WeatherClientState {
//   /// Creates a new instance listening to events and updating the state
//   WeatherClientState(this._client);


//   final StreamWeatherClient _client;


//   CompositeSubscription? _eventsSubscription;

//   /// Starts listening to the client events.
//   void subscribeToEvents() {
//     if (_eventsSubscription != null) {
//       cancelEventSubscription();
//     }

//     _eventsSubscription = CompositeSubscription();
//     _eventsSubscription!
//       ..add(_client
//           .on()
//           .map((event) => event.unreadChannels)
//           .whereType<int>()
//           .listen((count) {
//         currentUser = currentUser?.copyWith(unreadChannels: count);
//       }))
//       ..add(_client
//           .on()
//           .map((event) => event.totalUnreadCount)
//           .whereType<int>()
//           .listen((count) {
//         currentUser = currentUser?.copyWith(totalUnreadCount: count);
//       }));


//     _listenLocationsUpdated();

//     _listenWeatherUpdated();
//   }

//   /// Update all the [users] with the provided [userList]
//   void queryLocations(String query) {
//     final newUsers = {
//       ...locations,
//       for (final user in locationList)
//         if (user != null) user.id: user,
//     };
//     _locationsController.add(newUsers);
//   }

//   CompositeSubscription? _eventsSubscription;

//   /// Starts listening to the client events.
//   void subscribeToEvents() {
//     if (_eventsSubscription != null) {
//       cancelEventSubscription();
//     }

//     _eventsSubscription = CompositeSubscription();
//     _eventsSubscription!
//       ..add(_client
//           .on()
//           .where((event) =>
//               event.me != null && event.type != EventType.healthCheck)
//           .map((e) => e.me!)
//           .listen((user) {
//         currentUser = currentUser?.merge(user) ?? user;
//       }))
//       ..add(_client
//           .on()
//           .map((event) => event.unreadChannels)
//           .whereType<int>()
//           .listen((count) {
//         currentUser = currentUser?.copyWith(unreadChannels: count);
//       }))
//       ..add(_client
//           .on()
//           .map((event) => event.totalUnreadCount)
//           .whereType<int>()
//           .listen((count) {
//         currentUser = currentUser?.copyWith(totalUnreadCount: count);
//       }));

//     _listenChannelLeft();

//     _listenChannelDeleted();

//     _listenChannelHidden();

//     _listenUserUpdated();

//     _listenAllChannelsRead();
//   }


//   final _weatherController = BehaviorSubject<Map<String, WeatherData>>.seeded({});
//   final _locationsController = BehaviorSubject<Map<String, Location>>.seeded({});

//   /// Stops listening to the client events.
//   void cancelEventSubscription() {
//     if (_eventsSubscription != null) {
//       _eventsSubscription!.cancel();
//       _eventsSubscription = null;
//     }
//   }