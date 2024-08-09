// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_weather/stream_weather.dart';

/// Default debounce duration in milliseconds
const int kDefaultDebounceDurationMilliseconds = 300;

/// Widget used to provide search field and autocomplete behaviour for locations
class StreamLocationSearchWidget extends StatefulWidget {
  /// Constructor for the [StreamLocationSearchWidget] widget
  const StreamLocationSearchWidget(
      {super.key,
      required this.client,
      required this.onLocationSelectedCallback,
      this.defaultLocation,
      this.limitNumberOfResults,});

  /// Client to do location operations with
  final StreamWeatherClient client;

  /// Option to set the limit the number of autocomplete results (5 by default, 
  /// which is maximum allowed by the API)
  final int? limitNumberOfResults;

  /// Possible default location to show in the search field
  final Location? defaultLocation;

  /// On location selected callback
  final Function(Location) onLocationSelectedCallback;

  @override
  _StreamLocationSearchWidgetState createState() =>
      _StreamLocationSearchWidgetState();
}

class _StreamLocationSearchWidgetState
    extends State<StreamLocationSearchWidget> {

  late TextEditingController textEditingController;

  String? _currentQuery;

  Location? _selectedLocation;

  late _Debounceable<List<Location>?, String> _debouncedSearch;

  Future<List<Location>?> _search(String query) async {
    _currentQuery = query;

    // If query is empty, return an empty list.
    if (query.isEmpty) {
      final options = Future<List<Location>?>.value(<Location>[]);
      return options;
    }

    final options = widget.client
        .queryCoordinates(q: query, limit: widget.limitNumberOfResults ?? 5)
        .then((response) {
      return response.data;
    });

    // If another search happened after this one, throw away these options.
    if (_currentQuery != query) {
      return null;
    }
    _currentQuery = null;

    return options;
  }

  @override
  void initState() {
    _selectedLocation = widget.defaultLocation;
    super.initState();
    _debouncedSearch = _debounce<List<Location>?, String>(_search);
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Location>(
      initialValue: TextEditingValue(text: _selectedLocation?.name ?? ''), 
      optionsBuilder: (TextEditingValue textEditingValue) async {
        final options = await _debouncedSearch(textEditingValue.text);
        if (options == null || textEditingValue.text.isEmpty || options.isEmpty) {
          return [];
        }
        return options;
      },
      optionsViewBuilder: (context, onSelected, options) {
        return options.isEmpty ? const SizedBox.shrink() : ListView.builder(
          itemBuilder: (context, index) {
            final option = options.elementAt(index);
            final subtitle = [option.state, option.country, option.lat.toString(), option.lon.toString()]
                .where((element) => element != null)
                .join(', ');
            return ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListTile(
                title: Text(option.name.toString()),
                subtitle: Text(subtitle),
                onTap: () {
                  _selectedLocation = option;
                  textEditingController.text = option.name.toString();
                  widget.onLocationSelectedCallback(option);
                },
                ),
            );
          },
          itemCount: options.length);
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        textEditingController = fieldTextEditingController;
        return TextField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      },
      onSelected: (Location selected) {
        _selectedLocation = selected;
        textEditingController.text = selected.name.toString();
        widget.onLocationSelectedCallback(selected);
      },
    );
  }
}

typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
///
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
_Debounceable<S, T> _debounce<S, T>(_Debounceable<S?, T> function) {
  _DebounceTimer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer();
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is _CancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  };
}

/// A wrapper around Timer used for debouncing.
class _DebounceTimer {
  _DebounceTimer() {
    _timer = Timer(
        const Duration(milliseconds: kDefaultDebounceDurationMilliseconds),
        _onComplete);
  }

  /// Option to set the debounce duration
  int? debounceDurationMilliseconds;

  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

/// An exception indicating that the timer was canceled.
class _CancelException implements Exception {
  const _CancelException();
}
