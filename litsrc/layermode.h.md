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

Second, declare custom keycodes. One custom keycode for each key that you want to have layermode capabilities. This is a common idiom of creating them:

    // In your config.h:
    enum custom_keys {
      CTRL_NUM = SAFE_RANGE,
      ALT_NUM,
    };

The `SAFE_RANGE` part is very important.

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

### Layermode expressions

