import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  Function()? onSongComplete;

  MyAudioHandler() {

    /// 🔥 PLAYBACK STATE UPDATE (Notification UI FIXED)
    _player.playbackEventStream.listen((event) {
      playbackState.add(
        playbackState.value.copyWith(
          controls: [
            MediaControl.rewind, // ⏪ LEFT
            _player.playing
                ? MediaControl.pause
                : MediaControl.play, // ▶️ CENTER
            MediaControl.fastForward, // ⏩ RIGHT
          ],

          /// 👇 Only these 3 buttons will show
          androidCompactActionIndices: const [0, 1, 2],

          systemActions: const {
            MediaAction.seek,
            MediaAction.seekForward,
            MediaAction.seekBackward,
          },

          processingState: _mapState(_player.processingState),
          playing: _player.playing,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
        ),
      );
    });

    /// 🔥 SONG COMPLETE LISTENER
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        onSongComplete?.call();
      }
    });
  }

  /// 🔥 PLAY SONG
  Future<void> playMedia(
      String url, String title, String artist, String image) async {

    await _player.setUrl(url);

    final duration = _player.duration;

    mediaItem.add(MediaItem(
      id: url,
      title: title,
      artist: artist,
      artUri: (image.isNotEmpty && image.startsWith("http"))
          ? Uri.parse(image)
          : null,
      duration: duration,
    ));

    await _player.play();
  }

  /// 🔥 STREAMS
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  /// 🔥 BASIC CONTROLS
  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  /// 🔥 ⏩ FORWARD 10 SEC
  @override
  Future<void> fastForward() async {
    final newPos = _player.position + const Duration(seconds: 10);

    if (newPos < (_player.duration ?? Duration.zero)) {
      await _player.seek(newPos);
    } else {
      await _player.seek(_player.duration ?? Duration.zero);
    }
  }

  /// 🔥 ⏪ BACKWARD 10 SEC
  @override
  Future<void> rewind() async {
    final newPos = _player.position - const Duration(seconds: 10);

    if (newPos > Duration.zero) {
      await _player.seek(newPos);
    } else {
      await _player.seek(Duration.zero);
    }
  }

  /// 🔥 OPTIONAL: STOP (if needed)
  @override
  Future<void> stop() async {
    await _player.stop();
  }

  /// 🔥 STATE MAPPER
  AudioProcessingState _mapState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  /// 🔥 DISPOSE (IMPORTANT)
  @override
  Future<void> onTaskRemoved() async {
    await _player.dispose();
    return super.onTaskRemoved();
  }
}