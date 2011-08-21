#include <SPI.h>

enum { REG_LATCH = 8 };


void setup()
{
  Serial.begin(9600);
  SPI.begin();
  
  pinMode(REG_LATCH, OUTPUT);
  digitalWrite(REG_LATCH, HIGH);
}


void loop()
{
  static uint8_t last_input_states = 0;
  
  /* Trigger the slave select pin for the shift register to parallel-load
   * it's input states into internal register
   */
  digitalWrite(REG_LATCH, LOW);
  digitalWrite(REG_LATCH, HIGH);
  /* Now read the loaded input states */
  uint8_t states = SPI.transfer(0); // sending the dummy byte

  /* Print the input states only if they're changed */
  if (states != last_input_states)
  {
    uint8_t changed = states ^ last_input_states; // get changed states only
    last_input_states = states;
    
    for (int i = 0; i < 8; ++i)
    {
      if (changed & 1)
      {
        Serial.print("#");
        Serial.print(i);
        Serial.print(" -> ");
        Serial.println(states & 1);
      }
      
      changed >>= 1;
      states >>= 1;
    }
  }
}
