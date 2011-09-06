#include <LineDriver.h>
#include <SPI.h>
#include <SPI_Bus.h>

SPI_Bus reg(_8bit, 8);


void setup()
{
  Serial.begin(9600);
  reg.setSelectionPolicy(SPI_Bus::SELECT_BEFORE);
}


void loop()
{
  static uint8_t last_input_states = 0;
  
  uint8_t states = reg.read8bits();

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
