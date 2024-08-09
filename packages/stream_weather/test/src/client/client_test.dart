import 'package:mocktail/mocktail.dart';
import 'package:stream_weather/stream_weather.dart';
import 'package:test/test.dart';

import '../fakes.dart';
void main() {
  group('Weather Stream', () {
    const appId = 'test-api-key';
    late final api = FakeStreamWeatherApi();

    late StreamWeatherClient client;

    setUpAll(() async {
      client = StreamWeatherClient(appId, streamWeatherApi: api);
    });

    test('`.queryWeather`', () async {
        final weatherData = [WeatherData(
          dt:1684929490,
          sunrise:1684926645,
          sunset:1684977332,
          temp:292.55,
          feelsLike:292.87,
          pressure:1014,
          humidity:89,
          dewPoint:290.69,
          uvi:0.16,
          clouds:53,
          visibility:10000,
          windSpeed:3.13,
          windDeg:93,
          weather: [
            Weather(id: 803, main: 'Clouds', description: 'broken clouds', icon: '04d')
            ]
      )];

      when(() => api.weather.queryWeather(
            lat: any(named: 'lat'),
            lon: any(named: 'lon'),
            dt: any(named: 'dt'),
            appId: any(named: 'appId'),
            units: any(named: 'units'),
          )).thenAnswer((_) async => QueryWeatherByDateResponse()..data = weatherData);


      final res = await client.queryWeather();

      expect(res, isNotNull);
      expect(res.data.first.dt, weatherData.first.dt);
      expect(res.data.first.temp, weatherData.first.temp);

      verify(() => api.weather.queryWeather(
            lat: any(named: 'lat'),
            lon: any(named: 'lon'),
            dt: any(named: 'dt'),
            appId: any(named: 'appId'),
            units: any(named: 'units'),
          )).called(1);
      
      verifyNoMoreInteractions(api.weather);
    });

    test('`.queryCoordinates`', () async {
      final locations = List.generate(
        3,
        (index) => Location(lat: 44.6114149, lon: -1.224436, name: 'Amsterdam', country: 'NL', state: 'NH', localNames: {'en': 'Amsterdam', 'nl': 'Amsterdam'}),
      );

      when(() => api.locations.queryCoordinates(
            q: any(named: 'q'),
            limit: any(named: 'limit'),
            appId: any(named: 'appId'),
          )).thenAnswer((_) async => QueryCoordinatesByLocationNameResponse()..data = locations);


      final res = await client.queryCoordinates();
      expect(res, isNotNull);
      expect(res.data?.length, locations.length);

      verify(() => api.locations.queryCoordinates(
            q: any(named: 'q'),
            limit: any(named: 'limit'),
            appId: any(named: 'appId'),
          )).called(1);
      
      verifyNoMoreInteractions(api.locations);
    });
  });
}