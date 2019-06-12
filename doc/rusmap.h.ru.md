# rusmap.h

Когда пользователь создаёт в QMK создаёт раскладку, он использует макросы,
которые раскрываются в числа. Эти числа называются сканкодами, это по сути
номер клавиши. Операционная система затем, исходя из раскладки и полученного
сканкода, вводит символ. То есть, если на компьютере стоит QWERTY, и клавиатура
отправила сканкод `17`, то введётся символ `q`. Если же на компьютере включена
ЙЦУКЕН, то введётся уже символ `й`.

Таким образом, у букв q и й одинаковый сканкод. Разрабатывая раскладку русских
букв, неудобно использовать макросы, сделанные с ориентировкой на QWERTY.
Библиотека `rusmap.h` предлагает набор макросов, соответствующий раскладке
ЙЦУКЕН. У некоторых макросов есть синонимы, которые делают то же самое, что и
оригинал.

Символ            |Макрос из `rusmap.h`            |Макрос из QMK           |Синонимы             |
------------------|--------------------------------|------------------------|---------------------|
`а`               |`RU_A`                          |`KC_F`                  |                     |
`б`               |`RU_B`                          |`KC_COMM`               |                     |
`в`               |`RU_V`                          |`KC_D`                  |                     |
`г`               |`RU_G`                          |`KC_U`                  |                     |
`д`               |`RU_D`                          |`KC_L`                  |                     |
`е`               |`RU_JE`                         |`KC_T`                  |                     |
`ё`               |`RU_JO`                         |`KC_NUBS`               |                     |
`ж`               |`RU_ZH`                         |`KC_SCLN`               |                     |
`з`               |`RU_Z`                          |`KC_P`                  |                     |
`и`               |`RU_I`                          |`KC_B`                  |                     |
`й`               |`RU_J`                          |`KC_Q`                  |                     |
`к`               |`RU_K`                          |`KC_R`                  |                     |
`л`               |`RU_L`                          |`KC_K`                  |                     |
`м`               |`RU_M`                          |`KC_V`                  |                     |
`н`               |`RU_N`                          |`KC_Y`                  |                     |
`о`               |`RU_O`                          |`KC_J`                  |                     |
`п`               |`RU_P`                          |`KC_G`                  |                     |
`р`               |`RU_R`                          |`KC_H`                  |                     |
`с`               |`RU_S`                          |`KC_C`                  |                     |
`т`               |`RU_T`                          |`KC_N`                  |                     |
`у`               |`RU_U`                          |`KC_E`                  |                     |
`ф`               |`RU_F`                          |`KC_A`                  |                     |
`х`               |`RU_H`                          |`KC_LBRC`               |                     |
`ц`               |`RU_TS`                         |`KC_W`                  |                     |
`ч`               |`RU_CH`                         |`KC_X`                  |                     |
`ш`               |`RU_SH`                         |`KC_I`                  |                     |
`щ`               |`RU_SHCH`                       |`KC_O`                  |                     |
`ъ`               |`RU_HARD`                       |`KC_RBRC`               |                     |
`ы`               |`RU_Y`                          |`KC_S`                  |                     |
`ь`               |`RU_SOFT`                       |`KC_M`                  |                     |
`э`               |`RU_E`                          |`KC_QUOT`               |                     |
`ю`               |`RU_JU`                         |`KC_DOT`                |                     |
`я`               |`RU_JA`                         |`KC_Z`                  |                     |
`!`               |`RU_EXCLAIM`                    |`LSFT(KC_1)`            |`RU_EXLM`            |
`"`               |`RU_DOUBLE_QUOTE`               |`LSFT(KC_2)`            |`RU_DQUO`, `RU_DQT`  |
`№`               |`RU_NUMERO_SIGN`                |`LSFT(KC_3)`            |`RU_NUM`             |
`;`               |`RU_SCOLON`                     |`LSFT(KC_4)`            |`RU_SCLN`            |
`%`               |`RU_PERCENT`                    |`LSFT(KC_5)`            |`RU_PERC`            |
`:`               |`RU_COLON`                      |`LSFT(KC_6)`            |`RU_CLON`            |
`?`               |`RU_QUESTION`                   |`LSFT(KC_7)`            |`RU_QUES`            |
`*`               |`RU_ASTERISK`                   |`LSFT(KC_8)`            |`RU_ASTR`            |
`(`               |`RU_LEFT_PAREN`                 |`LSFT(KC_9)`            |`RU_LPRN`            |
`)`               |`RU_RIGHT_PAREN`                |`LSFT(KC_0)`            |`RU_RPRN`            |
`-`               |`RU_MINUS`                      |`KC_MINUS`              |`RU_MINS`            |
`_`               |`RU_UNDERSCORE`                 |`LSFT(KC_MINUS)`        |`RU_UNDS`            |
`=`               |`RU_EQUAL`                      |`KC_EQUAL`              |`RU_EQL`             |
`+`               |`RU_PLUS`                       |`KC_PLUS`               |                     |
`\`               |`RU_BSLASH`                     |`KC_BSLASH`             |`RU_BSLS`            |
`/`               |`RU_SLASH`                      |`LSFT(BACKSLASH)`       |`RU_SLSH`            |
`.`               |`RU_DOT`                        |`KC_SLSH`               |                     |
`,`               |`RU_COMMA`                      |`LSFT(KC_SLSH)`         |`RU_COMM`            |

## Установка

Можно просто скопировать файл `rusmap.h` в свой проект, можно скопировать
отдельные макросы. Если файл был скопирован, его необходимо включить в
исходный код:

```c
// здесь макросы не работают

#include "rusmap.h"

// тут уже сам код, где используются эти макросы
```

## Пример

Эти макросы можно применить как-нибудь так в файле `keymap.c`:

```c
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [CYRILLIC] =
  LAYOUT(RU_J,  RU_TS, RU_U,  RU_K,  RU_E,  RU_N,  RU_G,    RU_SH, RU_SHCH, RU_Z,   RU_H,
         RU_F,  RU_Y,  RU_V,  RU_A,  RU_P,  RU_R,  RU_O,    RU_L,  RU_D,    RU_ZH,  RU_E,
         RU_JA, RU_CH, RU_S,  RU_M,  RU_I,  RU_T,  RU_SOFT, RU_B,  RU_JU,   RU_DOT, RU_JO)
}
```
