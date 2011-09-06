enum { ENC_PIN1 = 2, ENC_PIN2 = 3 };

void setup()
{
  pinMode(ENC_PIN1, INPUT);
  pinMode(ENC_PIN2, INPUT);
  
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
  
  uint8_t gray_code = digitalRead(ENC_PIN1) | (digitalRead(ENC_PIN2) << 1),
          code = graydecode(gray_code);
  
  if (code == 0)
  {
    if (previous_code == 3)
      Serial.println("->");
    else if (previous_code == 1)
      Serial.println("<-");
  }

  previous_code = code;
  delay(1);
}
