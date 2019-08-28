# layermode

This library makes creating such buttons in QMK that can

1. Trigger a modifier when pressed and return to previous modifier state when depressed,
2. Turn a layer on when pressed and return to previous layer state when depressed.

```c
#ifndef KLAVAROG_LAYERMODE
#define KLAVAROG_LAYERMODE
```

The code is based on the code fetched from [Sequira source code](https://github.com/bouncepaw/sequira).

## Usage

First, include code tangled from this file. It is saved in file `layermode.h` in the root directory of this repository. Feel free to use it.

    // In your keymap file:
    #include "layermode.h"

Second, declare custom keycodes. One custom keycode for each key that you want to have layermode capabilities. Create them like this.

    // In your config.h:
    enum custom_key {
      CTRL_NUM = SAFE_RANGE,
      ALT_NUM,
    };

The `SAFE_RANGE` part is very important. Also, the enum must be named `custom_key`.

Third, add the keycodes to your layout. There is nothing special about it:

    // In your keymap file:
    const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] =
      { // Put the keycodes somewhere there ↓
        [DEFAULT] = //...
        [NUM]     = //...
        //...
      };

Four, create function `process_record_user`. It is used (when present) by QMK when processing unknown keycodes (the custom ones).

    // In your keymap file:
    bool process_record_user(uint16_t keycode, keyrecord_t *record) {
      // Put your timers here.
      switch (keycode) {
        // Put layermode expressions here.
      }
    }

There are two parts in the code above: timers and layermode expressions. Learn more about them below.

### Timers

Each layermode must have an associated timer variable. The macro `KEYTIMER` wraps declaration of such variables.

```c
#define KEYTIMER(name) static uint16_t timer_##name
```

For every layermode key write similar lines:

    KEYTIMER(CTRL_NUM);
    KEYTIMER(ALT_NUM);

Each timer will take two bytes of memory.

### Layermode expressions

Basically, layermode expression is a `case`-expression.

#### defmacro KEYMATCH

This macro accepts these parameters:

- `ck`
  Custom keycode you declared.
- `layers`
  Bitmask of layers that will be turned on when the key is pressed. You can compose it like this: `(1 << LAYER1) | (1 << LAYER2)`, etc.
- `mods`
  Bitmask of modifiers that will be turned on when the key is pressed. You can compose it like this: `(MOD1) | (MOD2)`, etc.

These are accepted modifiers:

| Value    | Meaning |
|----------|---------|
| MOD_LCTL | Left Control |
| MOD_LSFT | Left Shift |
| MOD_LALT | Left Alt |
| MOD_LGUI | Left GUI (Windows/Command/Meta key) |
| MOD_RCTL | Right Control |
| MOD_RSFT | Right Shift |
| MOD_RALT | Right Alt (AltGr) |
| MOD_RGUI | Right GUI (Windows/Command/Meta key) |
| MOD_HYPR | Hyper (Left Control, Shift, Alt and GUI) |
| MOD_MEH  | Meh (Left Control, Shift, and Alt) |

The macro itself just calls function `layermode_router`. It is defined later. If you are just reading this document for usage guide, you may ignore its definition.

```c
case name:
  layermode_router(ck, &timer_##ck, record, layers, mods);
  return false
```

For every layermode key use it like that:

    KEYMATCH(CTRL_NUM, (1 << NUM), MOD_LCTL);
    KEYMATCH(ALT_NUM,  (1 << NUM), MOD_LALT);

## Details

### fn layermode_router
> void

- `enum custom_key ck`
- `uint16_t *timer`
- `keyrecord_t *record`
- `layer_state_t layers`
- `uint8_t mods`


```c
// TODO.
```
