#ifndef KLAVAROG_LAYERMODE
#define KLAVAROG_LAYERMODE
#define KEYTIMER(name) static uint16_t timer_##name
#define KEYMATCH(ck, layers, mods, kc)\
case name:\
  layermode_router(ck, &timer_##ck, record, layers, mods);\
  return false
void
layermode_router (enum custom_key ck, uint16_t * timer, keyrecord_t * record,
		  layer_state_t layers, uint8_t mods, uint16_t kc)
{
  static uint8_t keys_pressed = 0;
  static layer_state_t prev_layer_state = 0;
  static uint8_t prev_mods = 0;
  if (0 == keys_pressed)
    {
      prev_layer_state = layer_state;
      prev_mods = get_mods ();
    }
  if (record->event.pressed)
    {
      *timer = timer_read ();
      layer_on (layers);
      add_mods (mods);
      keys_pressed++;
    }
  else
    {
      layer_off (layers);
      del_mods (mods);
      keys_pressed--;
#ifdef LAYERMODE_TAP
      if (timer_elapsed (*timer) < LAYERMODE_TAP)
#else
      if (timer_elapsed (*timer) < 300)
#endif
	tap_code16 (kc);
    }
  if (0 == keys_pressed)
    {
      layer_state = prev_layer_state;
      set_mods (prev_mods);
    }

}
#endif
