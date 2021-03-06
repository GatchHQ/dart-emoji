import 'package:dart_emoji/dart_emoji.dart';
import 'package:test/test.dart';

void main() {
  final emojiParser = EmojiParser();
  final emojiCoffee = Emoji('coffee', 'β');
  final emojiHeart = Emoji('heart', 'β€οΈ');
  final emojiFlagUS = Emoji('flag-us', 'πΊπΈ');

  group('EmojiUtil', () {
    test('.stripColons()', () {
      expect(EmojiUtil.stripColons('coffee'), 'coffee');
      expect(
          EmojiUtil.stripColons('coffee', (error) {
            expect(error, EmojiMessage.errorMalformedEmojiName);
          }),
          'coffee');
      expect(EmojiUtil.stripColons(':coffee:', (error) {}), 'coffee');
      expect(EmojiUtil.stripColons(':coff ee:'), ':coff ee:');
      expect(EmojiUtil.stripColons(':grey_question:'), 'grey_question');
      expect(EmojiUtil.stripColons('grey_question:'), 'grey_question:');
      expect(EmojiUtil.stripColons(':e-mail:'), 'e-mail');
    });

    test('.ensureColons()', () {
      expect(EmojiUtil.ensureColons('coffee'), ':coffee:');
      expect(EmojiUtil.ensureColons(':coffee'), ':coffee:');
      expect(EmojiUtil.ensureColons('coffee:'), ':coffee:');
      expect(EmojiUtil.ensureColons(':coffee:'), ':coffee:');
    });

    test('.stripNSM()', () {
      expect(EmojiUtil.stripNSM(String.fromCharCodes(Runes('\u2764\ufe0f'))),
          String.fromCharCodes(Runes('\u2764')));
      expect(EmojiUtil.stripNSM(String.fromCharCodes(Runes('\u2764'))),
          String.fromCharCodes(Runes('\u2764')));
    });

    group('.hasTextOnlyEmojis()', () {
      void testHasOnlyEmojis(
        String text, {
        required bool expected,
        bool ignoreWhitespace = false,
      }) {
        test(text, () {
          expect(
            EmojiUtil.hasOnlyEmojis(text, ignoreWhitespace: ignoreWhitespace),
            expected,
          );
        });
      }

      group('returns true for', () {
        testHasOnlyEmojis('π', expected: true);
        testHasOnlyEmojis('πππ', expected: true);
        testHasOnlyEmojis('π¨πΎβπ¦²', expected: true);
        testHasOnlyEmojis('π¨πΎ', expected: true);
        testHasOnlyEmojis('πΆπ½', expected: true);
        testHasOnlyEmojis('π©π»βπΎ', expected: true);
      });

      group('returns false for', () {
        testHasOnlyEmojis('lol', expected: false);
        testHasOnlyEmojis('π P', expected: false);
        testHasOnlyEmojis('>π¨πΎβπ¦²', expected: false);
        testHasOnlyEmojis(':troll:', expected: false);
        testHasOnlyEmojis('π π', expected: false);
      });

      group('ignoreWhitespace', () {
        testHasOnlyEmojis('π π', expected: true, ignoreWhitespace: true);
      });
    });
  });

  test('emoji creation & equality', () {
    final coffee = Emoji('coffee', 'β');

    expect(emojiCoffee == coffee, true);

    expect(coffee.name == 'coffee', true);
    expect(coffee.full == ':coffee:', true);
    expect(coffee.code == 'β', true);

    expect(emojiCoffee.toString(),
        'Emoji{name="coffee", full=":coffee:", code="β"}');

    expect(emojiCoffee.toString() == coffee.toString(), true);
  });

  test('emoji clone', () {
    final coffee = emojiCoffee.clone();

    expect(coffee == emojiCoffee, true);
  });

  test('get', () {
    expect(emojiParser.get('coffee'), emojiCoffee);
    expect(emojiParser.get(':coffee:'), emojiCoffee);

    expect(emojiParser.get('does_not_exist'), Emoji.None);
    expect(emojiParser.get(':does_not_exist:'), Emoji.None);
  });

  test('emoji name', () {
    expect(emojiParser.hasName('coffee'), true);
    expect(emojiParser.getName('coffee'), emojiCoffee);

    expect(emojiParser.hasName(':coffee:'), true);
    expect(emojiParser.getName(':coffee:'), emojiCoffee);

    expect(emojiParser.hasName('flag-us'), true);
    expect(emojiParser.getName('flag-us'), emojiFlagUS);

    expect(emojiParser.hasName('does_not_exist'), false);
    expect(emojiParser.getName(':does_not_exist:'), Emoji.None);
  });

  test('emoji info', () {
    final heart = emojiParser.info('heart');

    expect(heart.name, 'heart');
    expect(heart.full, ':heart:');
    expect(heart.code, 'β€οΈ');
  });

  test('emoji code', () {
    expect(emojiParser.hasEmoji('β€οΈ'), true);
    expect(emojiParser.getEmoji('β€οΈ'), emojiHeart);

    expect(emojiParser.hasEmoji('p'), false);
    expect(emojiParser.getEmoji('p'), Emoji.None);
  });

  test('emojify a text', () {
    expect(emojiParser.emojify('I :heart: :coffee:'), 'I β€οΈ β');

    expect(emojiParser.emojify('I :love coffee:'), 'I :love coffee:');
    expect(emojiParser.emojify('I :love :coffee'), 'I :love :coffee');
    expect(emojiParser.emojify('I love: :coffee'), 'I love: :coffee');
    expect(emojiParser.emojify('I love: coffee:'), 'I love: coffee:');

    expect(emojiParser.emojify('I :+1: with him'), 'I π with him');
  });

  test('unemojify a text', () {
    expect(emojiParser.unemojify('I β€οΈ car'), 'I :heart: car');
    expect(emojiParser.unemojify('I β€οΈ β'), 'I :heart: :coffee:');

    expect(emojiParser.unemojify('I heart car'), 'I heart car');
    expect(emojiParser.unemojify('I :heart: car'), 'I :heart: car');

    expect(emojiParser.unemojify('I π with him'), 'I :+1: with him');
  });

  group('unemojify', () {});

  test('emoji name includes some special characters', () {
    var emoji;

    // "umbrella_with_rain_drops":"β"
    emoji = Emoji('umbrella_with_rain_drops', 'β');
    expect(emojiParser.get('umbrella_with_rain_drops'), emoji);

    // "male-scientist":"π¨βπ¬"
    emoji = Emoji('male-scientist', 'π¨βπ¬');
    expect(emojiParser.get('male-scientist'), emoji);

    // "+1":"π"
    emoji = Emoji('+1', 'π');
    expect(emojiParser.get('+1'), emoji);
  });
}
