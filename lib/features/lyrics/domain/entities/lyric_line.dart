/// Model for synced lyrics supporting line and karaoke word timestamps per PRD §4.10.
class LyricLine {
  const LyricLine({
    required this.timestamp,
    required this.text,
    this.words = const [],
  });

  final Duration timestamp;
  final String text;
  final List<LyricWord> words;
}

class LyricWord {
  const LyricWord({
    required this.timestamp,
    required this.duration,
    required this.text,
  });

  final Duration timestamp;
  final Duration duration;
  final String text;
}

class MockLyricsData {
  MockLyricsData._();

  static const List<LyricLine> sampleOneMoreTime = [
    LyricLine(
      timestamp: Duration(seconds: 0),
      text: 'One more time, we\'re gonna celebrate',
      words: [
        LyricWord(timestamp: Duration(seconds: 0), duration: Duration(milliseconds: 600), text: 'One '),
        LyricWord(timestamp: Duration(milliseconds: 600), duration: Duration(milliseconds: 500), text: 'more '),
        LyricWord(timestamp: Duration(milliseconds: 1100), duration: Duration(milliseconds: 600), text: 'time, '),
        LyricWord(timestamp: Duration(milliseconds: 1700), duration: Duration(milliseconds: 400), text: 'we\'re '),
        LyricWord(timestamp: Duration(milliseconds: 2100), duration: Duration(milliseconds: 500), text: 'gonna '),
        LyricWord(timestamp: Duration(milliseconds: 2600), duration: Duration(milliseconds: 800), text: 'celebrate'),
      ],
    ),
    LyricLine(
      timestamp: Duration(seconds: 4),
      text: 'Oh yeah, all right, don\'t stop the dancing',
      words: [
        LyricWord(timestamp: Duration(seconds: 4), duration: Duration(milliseconds: 500), text: 'Oh '),
        LyricWord(timestamp: Duration(milliseconds: 4500), duration: Duration(milliseconds: 600), text: 'yeah, '),
        LyricWord(timestamp: Duration(milliseconds: 5100), duration: Duration(milliseconds: 400), text: 'all '),
        LyricWord(timestamp: Duration(milliseconds: 5500), duration: Duration(milliseconds: 600), text: 'right, '),
        LyricWord(timestamp: Duration(milliseconds: 6100), duration: Duration(milliseconds: 400), text: 'don\'t '),
        LyricWord(timestamp: Duration(milliseconds: 6500), duration: Duration(milliseconds: 500), text: 'stop '),
        LyricWord(timestamp: Duration(milliseconds: 7000), duration: Duration(milliseconds: 400), text: 'the '),
        LyricWord(timestamp: Duration(milliseconds: 7400), duration: Duration(milliseconds: 800), text: 'dancing'),
      ],
    ),
    LyricLine(
      timestamp: Duration(seconds: 9),
      text: 'One more time, we\'re gonna celebrate',
    ),
    LyricLine(
      timestamp: Duration(seconds: 14),
      text: 'Oh yeah, all right, don\'t stop the dancing',
    ),
    LyricLine(
      timestamp: Duration(seconds: 19),
      text: 'One more time, we\'re gonna celebrate',
    ),
    LyricLine(
      timestamp: Duration(seconds: 24),
      text: 'Oh yeah, all right, don\'t stop the dancing',
    ),
    LyricLine(
      timestamp: Duration(seconds: 30),
      text: 'Music\'s got me feeling so free',
    ),
    LyricLine(
      timestamp: Duration(seconds: 35),
      text: 'Celebrate and dance so free',
    ),
    LyricLine(
      timestamp: Duration(seconds: 40),
      text: 'One more time, music\'s got me feeling so free',
    ),
    LyricLine(
      timestamp: Duration(seconds: 46),
      text: 'We\'re gonna celebrate, celebrate and dance so free',
    ),
    LyricLine(
      timestamp: Duration(seconds: 52),
      text: 'One more time',
    ),
    LyricLine(
      timestamp: Duration(minutes: 1, seconds: 0),
      text: 'Music\'s got me feeling so free',
    ),
    LyricLine(
      timestamp: Duration(minutes: 1, seconds: 15),
      text: 'One more time, we\'re gonna celebrate',
    ),
    LyricLine(
      timestamp: Duration(minutes: 1, seconds: 24),
      text: 'Oh yeah, all right, don\'t stop the dancing',
    ),
    LyricLine(
      timestamp: Duration(minutes: 1, seconds: 35),
      text: 'Feel the music, feeling good tonight',
    ),
  ];
}
