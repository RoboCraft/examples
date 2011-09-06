enum { LED_PIN = 13 };
enum LedState { LED_ON, LED_OFF, LED_BLINK };

LedState led_state;

void setup()
{
  led_state = LED_OFF;
  pinMode(LED_PIN, OUTPUT);
  
  Serial.begin(38400);
}

void loop()
{  
  if (Serial.available())
  {
    char command = Serial.read();
    
    switch (command)
    {
      case '1': led_state = LED_ON; break;
      case '0': led_state = LED_OFF; break;
      case '*': led_state = LED_BLINK; break;
      
      default:
      {
        for (int i = 0; i < 5; ++i)
        {
          digitalWrite(LED_PIN, HIGH);
          delay(50);
          digitalWrite(LED_PIN, LOW);
          delay(50);
        }
      }
    }
  }
  
  switch (led_state)
  {
    case LED_ON: digitalWrite(LED_PIN, HIGH); break;
    case LED_OFF: digitalWrite(LED_PIN, LOW); break;
    
    case LED_BLINK:
    {
      static unsigned long start_millis = 0;
      
      if (millis() - start_millis >= 300)
      {
        start_millis = millis();
        digitalWrite(LED_PIN, !digitalRead(LED_PIN));
      }
    }
  }
}
