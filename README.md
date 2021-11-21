# dart_emoji

👉 A light-weight Emoji 📦 for Dart & Flutter with all up-to-date emojis written in pure Dart 😄 . Made from 💯% ☕ with ❤️!

This is a fork from [flutter-emoji](https://pub.dev/packages/flutter_emoji), which is inspired from the [node-emoji](https://github.com/omnidan/node-emoji) package.

## Why is this a fork from `flutter-emoji`?
| | `flutter-emoji` | `dart-emoji` |
|-|-|-|
| Still maintained? | ❌ | ✅ |
| Null Safety | ❌ | ✅ |
| Pure Dart Package | ❌ | ✅ |
| Updated emojis | ❌ | ✅ |

## Installation

Add this into `pubspec.yaml`

```
dependencies:
  dart_emoji: ^1.0.0
```

## API Usage

First, import the package:

```
import 'package:dart_emoji/dart_emoji.dart';
```

There are two main classes you need to know to handle Emoji text: `Emoji` and `EmojiParser`.

Basically, you need to initialize an instance of `EmojiParser`.

```
var parser = EmojiParser();
var coffee = Emoji('coffee', '☕');
var heart  = Emoji('heart', '❤️');

// Get emoji info
var emojiHeart = parser.info('heart');
print(emojiHeart); '{name: heart, full: :heart:, code: ❤️}'

// Check emoji equality
heart == emojiHeart;  // returns: true
heart == emojiCoffee; // returns: false

// Get emoji by name or code
parser.get('coffee');   // returns: Emoji{name="coffee", full=":coffee:", code="☕"}
parser.get(':coffee:'); // returns: Emoji{name="coffee", full=":coffee:", code="☕"}

parser.hasName('coffee'); // returns: true
parser.getName('coffee'); // returns: Emoji{name="coffee", full=":coffee:", code="☕"}

parser.hasEmoji('❤️'); // returns: true
parser.getEmoji('❤️'); // returns: Emoji{name="heart", full=":heart:", code="❤️"}

parser.emojify('I :heart: :coffee:'); // returns: 'I ❤️ ☕'
parser.unemojify('I ❤️ ☕'); // returns: 'I :heart: :coffee:'
```

All methods will return `Emoji.None` if emoji is not found.

```
parser.get('does_not_exist_emoji_name'); // returns: Emoji.None
```

## License

[MIT](LICENSE.md) @ 2021 [Gatch GmbH](https://gatch.fun).
