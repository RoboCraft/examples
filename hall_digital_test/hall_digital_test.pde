void setup()
{
  Serial.begin(9600);
}

void loop()
{
  static uint8_t prev_state = false;
  
  uint8_t state = digitalRead(2);
  
  if (state != prev_state)
  {
    prev_state = state;
    Serial.println(state ? "ON" : "OFF");
  }
}
