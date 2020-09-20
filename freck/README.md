# Freck

Freck is a replacement for QMK but for accord keyboards. QMK is meant for discord keyboards. Creating a whole keyboard framework is not an easy task, so we'll start small. This literate source introduces some of concepts (that will be) used by Freck. Everything here can be embedded in QMK.

WIP WIP WIP.

```c
#pragma once
```

## enum CapitalKeyruneData

- `kNext = 1 << 15`
- `kRecursive = 1 << 14`
- `kPressed = 1 << 13`
- `kUnrepeatable = 1 << 12`
- `kOffset = 8`

| Bit                 | Meaning                                                      |
| ------------------- | ------------------------------------------------------------ |
| 15, `kNext`         | This keyrune is followed by an other one in a keyrune word.  |
| 14, `kRecursive`    | This keyrune should be executed as an accord.                |
| 13, `kPressed`      | This keyrune should be considered only when the accord is pressed. False if only when depressed/released. |
| 12, `kUnrepeatable` | True if this keyrune cannot be auto-repeated.                |
| 11..8               | Number of words in this sentence. Summed with other such values in the sentence. |
| 7..0                | A scancode to send or an accord zone to execute if `kRecursive`. |

## enum MinusculeKeyruneType

**Starting with 01**: accords.

- `kAccord = (1 << 14)`
- `kAccordExtended = (1 << 13)`

| Bit                   | Meaning                                                      |
| --------------------- | ------------------------------------------------------------ |
| `kAccord`, 14         | *x* is the accord to execute if `kRecursive` is set on in Capital keyrune. |
| `kAccordExtended`, 13 | Bits 12..0 of the next keyrune that has `kAccord` set on is appended to the corresponding value of this keyrune. |
| 12..0 = *x*           | Accord to execute.                                           |

**Starting with 001:** ether calling.

- `kCall = (1 << 13)`
- `kCallArgumentAvailable = (1 << 12)`

| Bit                          | Meaning                                                      |
| ---------------------------- | ------------------------------------------------------------ |
| 13, `kCall`                  | `ether_call(arg0, arg1, arg2, arg3, current_keyrune_word)`.  |
| 12, `kCallArgumentAvailable` | Accept `arg0` and `arg1` of the next keyrune that has `kCall` set on as `arg2` and `arg3` respectively. |
| 11..8 = *arg0*               | Obligatory argument. Use it when `arg1` is not enough.       |
| 7..0 = *arg1*                | Obligatory argument, but bigger.                             |

`ether_call` is a function that can be redefined by the user. See `fn ether_call` later.

**Starting with 0001:** modifiers.

- `kMod = (1 << 12)`
- `kModApplyOr = 0`
- `kModApplyAnd = (1 << 10)`
- `kModApplyXor = (2 << 10)`
- `kModApplySet = (3 << 10)`

| Bit                                                          | Meaning                                 |
| ------------------------------------------------------------ | --------------------------------------- |
| 12, `kMod`                                                   | Apply modifiers in a specified manner.  |
| 11..10, either `kModApplyOr`, `kModApplyAnd`, `kModApplyXor`, `kModApplySet`. | Specified manner to apply modifiers.    |
| 9..8                                                         | Reserved for future use.                |
| 7, `kRightGUI`, `kRGUI`                                      | This and later: corresponding modifier. |
| 6, `kRightAlt`, `kRALT`                                      |                                         |
| 5, `kRightShift`, `kRSFT`                                    |                                         |
| 4, `kRightControl`, `kRCTL`                                  |                                         |
| 3, `kLeftGUI`, `kLGUI`                                       |                                         |
| 2, `kLeftAlt`, `kLALT`                                       |                                         |
| 1, `kLeftShift`, `kLSFT`                                     |                                         |
| 0, `kLeftControl`, `kLCTL`                                   |                                         |

**Starting with 00001:** all are reserved for future use.