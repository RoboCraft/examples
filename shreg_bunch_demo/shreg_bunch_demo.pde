#include <LineDriver.h>
#include <SPI.h>
#include <SPI_Bus.h>
#include <ServoExt.h>
#include <LiquidCrystalExt.h>

enum
{
  SERVOS_AMOUNT = 4,
  SERVOS_FIRST_PIN = 9,
  SERVO_ROTATE_STEP = 2,

  /* LCD */
  SYMBOL_HEIGHT = 8,
  SYM_DANGER = 0,
  SYM_LIGHTNING = 1,

  /* RGB LED */
  RED_LINE = 2,
  GREEN_LINE = 0,
  BLUE_LINE = 1,

  /* DIP-switches */
  SWITCH1 = 1 << 4,
  SWITCH2 = 1 << 5,
  SWITCH3 = 1 << 6,

  /* <SERVOS_AMOUNT> buttons to control servos */
  FIRST_BUTTON = 1 << 0,
};

SPI_Bus shreg_in(_8bit, 9); // 74HC165 parallel-load shift register
SPI_Bus shreg(_16bit, 10);  // two daisy-chaned 74HC595 parallel-out shift registers
LiquidCrystal lcd(5, 6, 7, 13, 14, 15, &shreg, 4); // LCD is connected to a 74HC595

/* Servos are connected to a 74HC595 */
Servo servos[SERVOS_AMOUNT] = { &shreg, &shreg, &shreg, &shreg };

/* Servo rotate directions. The latter two are inverted 'cause
 * SG-90 servos and Robbe 10g rotate in opposite directions
 * with the same pulse width
 */
int servo_directions[SERVOS_AMOUNT] = { 1, 1, -1, -1 };

/* Skull and bones symbol */
uint8_t danger[SYMBOL_HEIGHT] =
{
  B01110,
  B10101,
  B11011,
  B01110,
  B00000,
  B10001,
  B01110,
  B10001,
};

/* Lightning symbol */
uint8_t lightning[SYMBOL_HEIGHT] =
{
  B00010,
  B00100,
  B01000,
  B11111,
  B00010,
  B00100,
  B01000,
  B00000,
};


void setup()
{
  /* Latch is to be controlled before reading the input states */
  shreg_in.setSelectionPolicy(SPI_Bus::SELECT_BEFORE);

  /* Rotate servos to the middle position */
  for (int i = 0; i < SERVOS_AMOUNT; ++i)
  {
    servos[i].attach(SERVOS_FIRST_PIN + i);
    servos[i].write(90);
  }

  /* Since servos are controlled by timer interrupts using the same shift register,
   * we must disable the interrupts avoid SPI_Bus buffer corruption.
   */
  noInterrupts();
  lcd.createChar(SYM_DANGER, danger);
  lcd.createChar(SYM_LIGHTNING, lightning);
  lcd.begin(8, 2);
  lcd.print("Yo dawg!");
  interrupts();
}


/* Show the <symbol> or the space character at specified position <pos>
 * of the second line depending on the value of <enabled>.
 */
void indicate(char symbol, uint8_t pos, bool enabled)
{
  lcd.setCursor(pos, 1);
  lcd.write(enabled ? symbol : ' ');
}


void loop()
{
  static unsigned long last_micros = 0;
  static uint8_t last_inputs = 0;

  /* Read input every 10 ms */
  if (micros() - last_micros >= 10000)
  {
    last_micros = micros();

    noInterrupts();
    /* Read the input states */
    const uint8_t inputs = shreg_in.read8bits();
    /* Use the first switch to control the backlight */
    lcd.backlight((inputs & SWITCH1) != 0);
    interrupts();

    /* LCD has very low refresh rate and we cannot refresh it 100 times
     * per second, so we'll refresh it only when it's really needed.
     */
    if (inputs != last_inputs)
    {
      noInterrupts();
      indicate(SYM_DANGER, 3, (inputs & SWITCH2) != 0);
      indicate(SYM_LIGHTNING, 5, (inputs & SWITCH3) != 0);
      interrupts();

      last_inputs = inputs;
    }

    /* Now update the servos */
    for (int i = 0; i < SERVOS_AMOUNT; ++i)
    {
      /* Check for the respective button is pressed */
      if ((inputs & (FIRST_BUTTON << i)) != 0)
      {
        /* Calculate the new angle based on what was written last */
        int new_angle = servos[i].read() + servo_directions[i] * SERVO_ROTATE_STEP;

        /* Change the rotate direction of the servo if angle reached
         * the minimum or the maximum.
         */
        if (new_angle < 0 || new_angle > 180)
        {
          new_angle = constrain(new_angle, 0, 180);
          servo_directions[i] *= -1; // changing direction
        }

        servos[i].write(new_angle);
      }
    }

    /* Now play with RGB LED colors 2 times per second */
    static uint8_t ticks = 0, led_color = 0;

    if (ticks >= 50)
    {
      noInterrupts();
      shreg.lineWrite(RED_LINE, led_color & (1 << 0));
      shreg.lineWrite(GREEN_LINE, led_color & (1 << 1));
      shreg.lineWrite(BLUE_LINE, led_color & (1 << 2));
      interrupts();
    
      ticks = 0;
      ++led_color;
    }

    ++ticks;
  }
}
