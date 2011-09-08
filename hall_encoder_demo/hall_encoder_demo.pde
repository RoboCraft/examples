#include <LiquidCrystal.h>

LiquidCrystal lcd(13, 12, 11, 10, 9, 8);

enum { ENC_PIN1 = 2, ENC_PIN2 = 3 };
enum { FORWARD = 1, BACKWARD = -1 };

long revolutions = 0, revolutions_at_last_display = 0;
int direction = FORWARD;
uint8_t previous_code = 0;

void turned(int new_direction)
{
  if (new_direction != direction)
  {
    revolutions = 0;
    revolutions_at_last_display = 0;
  }
  else
    ++revolutions;
  
  direction = new_direction;
}

uint8_t readEncoder(uint8_t pin1, uint8_t pin2)
{
  uint8_t gray_code = digitalRead(pin1) | (digitalRead(pin2) << 1), result = 0;
  
  for (result = 0; gray_code; gray_code >>= 1)
    result ^= gray_code;
  
  return result;
}

void setup()
{
  pinMode(ENC_PIN1, INPUT);
  pinMode(ENC_PIN2, INPUT);

  lcd.begin(8, 2);
}

void loop()
{
  uint8_t code = readEncoder(ENC_PIN1, ENC_PIN2);
  
  if (code == 0)
  {
    if (previous_code == 3)
      turned(FORWARD);
    else if (previous_code == 1)
      turned(BACKWARD);
  }
  
  previous_code = code;
  
  static unsigned long millis_at_last_display = 0;
  
  if (millis() - millis_at_last_display >= 1000)
  {
    lcd.clear();
    lcd.print(direction == FORWARD ? ">> " : "<< ");
    
    lcd.print(revolutions - revolutions_at_last_display);
    lcd.print("/s");
    
    lcd.setCursor(0, 1);
    lcd.print(revolutions);
    
    millis_at_last_display = millis();
    revolutions_at_last_display = revolutions;
  }
}
