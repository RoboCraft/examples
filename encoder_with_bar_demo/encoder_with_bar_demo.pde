enum
{
  ENC_PIN1 = 2,
  ENC_PIN2 = 3,
  BAR_FIRST_PIN = 4,
  BAR_PINS_COUNT = 10
};

void setup()
{
  pinMode(ENC_PIN1, INPUT);
  pinMode(ENC_PIN2, INPUT);
  
  for (int i = 0; i < BAR_PINS_COUNT; ++i)
    pinMode(BAR_FIRST_PIN + i, OUTPUT);
  
  Serial.begin(9600);
}

unsigned graydecode(unsigned gray) 
{
  unsigned bin;
  
  for (bin = 0; gray; gray >>= 1)
    bin ^= gray;

  return bin;
}

void loop()
{
  static uint8_t previous_code = 0;
  static int bar_level = 0;
  
  uint8_t gray_code = digitalRead(ENC_PIN1) | (digitalRead(ENC_PIN2) << 1),
          code = graydecode(gray_code);
  
  if (code == 0)
  {
    if (previous_code == 3)
    {
      bar_level = constrain(bar_level + 1, 0, BAR_PINS_COUNT);
      Serial.println(bar_level);
    }
    else if (previous_code == 1)
    {
      bar_level = constrain(bar_level - 1, 0, BAR_PINS_COUNT);
      Serial.println(bar_level);
    }
  }

  for (int i = 0; i < BAR_PINS_COUNT; ++i)
    digitalWrite(BAR_FIRST_PIN + i, (i < bar_level ? HIGH : LOW));
  
  previous_code = code;
  delay(1);
}
