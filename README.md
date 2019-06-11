# QMK Bonus

## Русский

QMK Bonus — набор библиотек, 
нацеленных на использование вместе
с QMK. Те, которые докажут свою
универсальность, будут отправлены
в QMK на пулл-реквест.

### Библиотеки

Пока ни одна не сделана.

- `rusmap.h` содержит макросы,
делающие создание русской раскладки
очевиднее:
```c
// Кусочек из rusmap.h
#define RU_J  KC_Q
#define RU_TS KC_W
```
- `layermode.h` упрощает создание
двойных клавиш, которые помимо 
модификатора также включают или 
выключают какой-нибудь слой.
- `chordgen` генерирует код для
обработки аккордов из таблицы 
аккордов.

## English
QMK Bonus is a library set to be
used with QMK. Those libraries
that prove their versatility will
be pull-requested to QMK.

### Libraries

Nothing done yet.

- `rusmap.h` makes creating 
Russian layouts easier:

```c
// An extract from rusmap.h
#define RU_J  KC_Q
#define RU_TS KC_W
```
- `layermode.h` eases creating keys
that both triggers a modifier and 
turns on or off a layer.
- `chordgen` generates chord 
processing code from a chord table.