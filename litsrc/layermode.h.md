# layermode

This library makes creating such buttons in QMK that can

1. Trigger a modifier when pressed and return to previous modifier state when depressed,
2. Turn a layer on when pressed and return to previous layer state when depressed.
3. Tap a keycode when the key is briefly pressed.

```c
#pragma once
```

The code is based on the code fetched from [Sequira source code](https://github.com/bouncepaw/sequira).

## Usage

First, include code tangled from this file. It is saved in file `layermode.h` in the root directory of this repository, copy it to the same directory as your keymap file. Feel free to use it.

    // In your keymap file:
    #include "layermode.h"

Second, declare custom keycodes. One custom keycode for each key that you want to have layermode capabilities. Create them like this.

    // In your config.h:
    enum custom_key {
      CTRL_NUM = SAFE_RANGE,
      ALT_NUM,
    };

The `SAFE_RANGE` part is very important. You can name it any way.

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
- `should_invert_layers`
  If this is `true`, layers will be turned off instead.
- `mods`
  Bitmask of modifiers that will be turned on when the key is pressed. You can compose it like this: `(MOD1) | (MOD2)`, etc.
- `kc`
  This keycode will be sent if the key press time is lower than `LAYERMODE_TAP`.

These are accepted modifiers (you'll have to wrap them in `MOD_BIT` as in an example below):

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
  layermode_router(&timer_##ck, record, layers, mods, should_invert_layers, kc);
  return false
```

For every layermode key use it like that:

    KEYMATCH(CTRL_NUM, (1 << NUM), false, MOD_BIT(MOD_LCTL), KC_NO);
    KEYMATCH(ALT_NUM,  (1 << NUM), false, MOD_BIT(MOD_LALT), KC_1);

## Details

### fn layermode_router
> void

- `uint16_t *timer`
- `keyrecord_t *record`
- `layer_state_t layers`
- `uint8_t mods`
- `bool should_invert_layers`
- `uint16_t kc`

There are static variables that hold the state of the router. They could have been global variables but it's a bad practice to pollute the global namespace.

```c
static uint8_t keys_pressed = 0;
static layer_state_t prev_layer_state = 0;
static uint8_t prev_mods = 0;
```

If this is the first layermode key pressed save the state of modifiers and layers is, so the router can rewind to them after the last layermode key is released.

```c
if (0 == keys_pressed) {
  prev_layer_state = layer_state;
  prev_mods = get_mods();
}
```

If the key is pressed, apply the modifiers and layers. Also, increment the counter.

```c
if (record->event.pressed) {
  *timer = timer_read();
  should_invert_layers ? layer_and(~layers) : layer_or(layers);
  add_mods(mods);
  keys_pressed++;
}
```

If the key is released, rewind! Also, if the passed `kc` has to be pressed, press it. It depends on `LAYERMODE_TAP`, which defaults to `300`. Of course, decrement the counter.

**NB.** The modifiers and layers flash (turn on and off for an instant) if you just press the key. It can mess up some applications that do something when a modifier key is pressed. Look out for the `Alt` key in Firefox. Perhaps, `Win` key may trigger the Start menu in Windows.

```c
else {
  should_invert_layers ? layer_or(layers) : layer_and(~layers);
  del_mods(mods);
  keys_pressed--;
#ifdef LAYERMODE_TAP
  if (timer_elapsed(*timer) < LAYERMODE_TAP)
#else
  if (timer_elapsed(*timer) < 300)
#endif
    tap_code16(kc);
}
```

If the last key is released, rewind to previous state.

```c
if (0 == keys_pressed) {
  layer_state = prev_layer_state;
  set_mods(prev_mods);
}
```

