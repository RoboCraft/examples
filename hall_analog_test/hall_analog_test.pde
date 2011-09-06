void setup()
{
  Serial.begin(9600);
}

int sign(int x)
{
  return (x > 0) - (x < 0);
}

void loop()
{
  //int field_strength = analogRead(0) - 512;
  
  //if (abs(field_strength) > 20)
  //  Serial.println(sign(field_strength));
  
  Serial.println(analogRead(0));
  
  delay(1000);
}
