import 'package:test/test.dart';

import 'package:dart_emoji/dart_emoji.dart';

void main() {
  var emojiParser = EmojiParser();
  var emojiCoffee = Emoji('coffee', '☕');
  var emojiHeart = Emoji('heart', '❤️');
  var emojiFlagUS = Emoji('flag-us', '🇺🇸'); // "flag-us":"🇺🇸"

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
      group('returns true for', () {
        test('"🚀"', () {
          expect(EmojiUtil.hasTextOnlyEmojis("🚀"), isTrue);
        });

        test('"👁👄👁"', () {
          expect(EmojiUtil.hasTextOnlyEmojis("👁👄👁"), isTrue);
        });
      });

      group('returns false for', () {
        test('"LOL"', () {
          expect(EmojiUtil.hasTextOnlyEmojis("LOL"), isFalse);
        });

        test('"😜 P"', () {
          expect(EmojiUtil.hasTextOnlyEmojis("😜 P"), isFalse);
        });
      });
    });
  });

  test('emoji creation & equality', () {
    var coffee = Emoji('coffee', '☕');

    expect(emojiCoffee == coffee, true);

    expect(coffee.name == 'coffee', true);
    expect(coffee.full == ':coffee:', true);
    expect(coffee.code == '☕', true);

    expect(emojiCoffee.toString(),
        'Emoji{name="coffee", full=":coffee:", code="☕"}');

    expect(emojiCoffee.toString() == coffee.toString(), true);
  });

  test('emoji clone', () {
    var coffee = emojiCoffee.clone();

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
    var heart = emojiParser.info('heart');

    expect(heart is Emoji, true);

    expect(heart.name, 'heart');
    expect(heart.full, ':heart:');
    expect(heart.code, '❤️');
  });

  test('emoji code', () {
    expect(emojiParser.hasEmoji('❤️'), true);
    expect(emojiParser.getEmoji('❤️'), emojiHeart);

    expect(emojiParser.hasEmoji('p'), false);
    expect(emojiParser.getEmoji('p'), Emoji.None);
  });

  test('emojify a text', () {
    expect(emojiParser.emojify('I :heart: :coffee:'), 'I ❤️ ☕');

    expect(emojiParser.emojify('I :love coffee:'), 'I :love coffee:');
    expect(emojiParser.emojify('I :love :coffee'), 'I :love :coffee');
    expect(emojiParser.emojify('I love: :coffee'), 'I love: :coffee');
    expect(emojiParser.emojify('I love: coffee:'), 'I love: coffee:');

    expect(emojiParser.emojify('I :+1: with him'), 'I 👍 with him');
  });

  test('unemojify a text', () {
    expect(emojiParser.unemojify('I ❤️ car'), 'I :heart: car');
    expect(emojiParser.unemojify('I ❤️ ☕'), 'I :heart: :coffee:');

    expect(emojiParser.unemojify('I heart car'), 'I heart car');
    expect(emojiParser.unemojify('I :heart: car'), 'I :heart: car');

    // NOTE: both :+1: and :thumbsup: represent same emoji 👍
    // When calling unemojify() only the latter one is mapped.
    expect(emojiParser.unemojify('I 👍 with him'), 'I :thumbsup: with him');
  });

  test('emoji name includes some special characters', () {
    var emoji;

    // "umbrella_with_rain_drops":"☔"
    emoji = Emoji('umbrella_with_rain_drops', '☔');
    expect(emojiParser.get('umbrella_with_rain_drops'), emoji);

    // "male-scientist":"👨‍🔬"
    emoji = Emoji('male-scientist', '👨‍🔬');
    expect(emojiParser.get('male-scientist'), emoji);

    // "+1":"👍"
    emoji = Emoji('+1', '👍');
    expect(emojiParser.get('+1'), emoji);
  });
}
