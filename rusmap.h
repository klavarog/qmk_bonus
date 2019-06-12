#ifndef KLAVAROG_RUSMAP_H
#define KLAVAROG_RUSMAP_H
/*
 * This file contains macros mapping ЙЦУКЕН Cyrillic layout to QWERTY
 * Latin layout. They are all prefixed with RU_. The prefix is
 * followed then by letter's name.
 *
 * Этот файл содержит макросы, задающие соответствие между ЙЦУКЕН и
 * QWERTY раскладками. У них всех префикс RU_. После него идёт
 * название буквы.
 */

#define RU_A    KC_F    // а
#define RU_B    KC_COMM // б
#define RU_V    KC_D    // в
#define RU_G    KC_U    // г
#define RU_D    KC_L    // д
#define RU_JE   KC_T    // е
#define RU_JO   KC_NUBS // ё
#define RU_ZH   KC_SCLN // ж
#define RU_Z    KC_P    // з
#define RU_I    KC_B    // и
#define RU_J    KC_Q    // й
#define RU_K    KC_R    // к
#define RU_L    KC_K    // л
#define RU_M    KC_V    // м
#define RU_N    KC_Y    // н
#define RU_O    KC_J    // о
#define RU_P    KC_G    // п
#define RU_R    KC_H    // р
#define RU_S    KC_C    // с
#define RU_T    KC_N    // т
#define RU_U    KC_E    // у
#define RU_F    KC_A    // ф
#define RU_H    KC_LBRC // х
#define RU_TS   KC_W    // ц
#define RU_CH   KC_X    // ч
#define RU_SH   KC_I    // ш
#define RU_SHCH KC_O    // щ
#define RU_HARD KC_RBRC // ъ
#define RU_Y    KC_S    // ы
#define RU_SOFT KC_M    // ь
#define RU_E    KC_QUOT // э
#define RU_JU   KC_DOT  // ю
#define RU_JA   KC_Z    // я

/*
 * Macros for punctuation signs are also included. Most of them are
 * not Basic keycodes, so they will not work with special keycodes
 * such as LT, MT, etc. This is QMK restraing.
 *
 * Также есть макросы для знаков пунктуации. Большинство из них не
 * относятся к базовым кикодам, поэтому они не будут работать со
 * специальными кикодами, типа LT, MT и т/д. Это ограничение QMK.
 */
#define RU_EXCLAIM       LSFT(KC_1)         // !
#define RU_DOUBLE_QUOTE  LSFT(KC_2)         // "
#define RU_NUMERO_SIGN   LSFT(KC_3)         // №
#define RU_SCOLON        LSFT(KC_4)         // ;
#define RU_PERCENT       LSFT(KC_5)         // %
#define RU_COLON         LSFT(KC_6)         // :
#define RU_QUESTION      LSFT(KC_7)         // ?
#define RU_ASTERISK      LSFT(KC_8)         // *
#define RU_LEFT_PAREN    LSFT(KC_9)         // (
#define RU_RIGHT_PAREN   LSFT(KC_0)         // )
#define RU_MINUS         KC_MINUS           // -
#define RU_UNDERSCORE    LSFT(KC_MINUS)     // _
#define RU_EQUAL         KC_EQUAL           // =
#define RU_PLUS          KC_PLUS            // +
#define RU_BSLASH        KC_BSLASH          // \
#define RU_SLASH         LSFT(RU_BACKSLASH) // /
#define RU_DOT           KC_SLSH            // .
#define RU_COMMA         LSFT(KC_SLSH)      // ,

#define RU_EXLM RU_EXCLAIM                  // !
#define RU_DQUO RU_DOUBLE_QUOTE             // "
#define RU_DQT  RU_DOUBLE_QUOTE             // "
#define RU_NUME RU_NUMERO_SIGN              // №
#define RU_SCLN RU_SCOLON                   // ;
#define RU_PERC RU_PERCENT                  // %
#define RU_CLON RU_COLON                    // :
#define RU_QUES RU_QUESTION                 // ?
#define RU_ASTR RU_ASTERISK                 // *
#define RU_LPRN RU_LEFT_PAREN               // (
#define RU_RPRN RU_RIGHT_PAREN              // )
#define RU_BSLS RU_BSLASH                   // \
#define RU_SLSH RU_SLASH                    // /
#define RU_COMM RU_COMMA                    // ,

#endif
