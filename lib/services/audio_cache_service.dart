import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AudioCacheService {
  static const String _cacheKey = 'cached_audio_urls';
  static const int _maxCacheSize = 10;

  final SharedPreferences _prefs;

  AudioCacheService(this._prefs);

  Future<bool> isAudioCached(String audioId) async {
    final cachedUrls = _getCachedUrls();
    return cachedUrls.containsKey(audioId);
  }

  Future<String?> getCachedAudioPath(String audioId) async {
    final cachedUrls = _getCachedUrls();
    if (cachedUrls.containsKey(audioId)) {
      final path = cachedUrls[audioId];
      if (path != null && await File(path).exists()) {
        return path;
      }
    }
    return null;
  }

  Future<void> cacheAudio(String audioId, String audioUrl) async {
    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(audioUrl));
      final response = await request.close();

      final bytes = await consolidateHttpClientResponseBytes(response);
      final cacheDir = await _getCacheDirectory();

      final fileName = 'audio_${audioId}_${DateTime.now().millisecondsSinceEpoch}.mp3';
      final filePath = '${cacheDir.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      final cachedUrls = _getCachedUrls();
      cachedUrls[audioId] = filePath;

      if (cachedUrls.length > _maxCacheSize) {
        final oldestKey = cachedUrls.keys.first;
        final oldPath = cachedUrls[oldestKey];
        if (oldPath != null && await File(oldPath).exists()) {
          await File(oldPath).delete();
        }
        cachedUrls.remove(oldestKey);
      }

      await _saveCachedUrls(cachedUrls);
    } catch (e) {
      print('Error caching audio: $e');
    }
  }

  Future<Directory> _getCacheDirectory() async {
    final cacheDir = await Directory.systemTemp.createTemp('audio_cache');
    return cacheDir;
  }

  Map<String, String> _getCachedUrls() {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString != null) {
      try {
        return Map<String, String>.from(json.decode(jsonString));
      } catch (_) {
        return {};
      }
    }
    return {};
  }

  Future<void> _saveCachedUrls(Map<String, String> cachedUrls) async {
    await _prefs.setString(_cacheKey, json.encode(cachedUrls));
  }

  Future<void> clearCache() async {
    final cachedUrls = _getCachedUrls();
    for (final path in cachedUrls.values) {
      if (path != null && await File(path).exists()) {
        await File(path).delete();
      }
    }
    await _prefs.remove(_cacheKey);
  }

  Future<bool> hasNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<Uint8List> consolidateHttpClientResponseBytes(HttpClientResponse response) async {
    final completer = Completer<Uint8List>();
    final bytes = <int>[];
    response.listen(
          (data) => bytes.addAll(data),
      onDone: () => completer.complete(Uint8List.fromList(bytes)),
      onError: completer.completeError,
    );
    return completer.future;
  }
}