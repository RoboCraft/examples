#include <LineDriver.h>
#include <SPI.h>
#include <SPI_Bus.h>

SPI_Bus reg(_24bit, 10, MSBFIRST);


void setup()
{
  Serial.begin(9600);
  reg.setSelectionPolicy(SPI_Bus::SELECT_BEFORE);
}


void loop()
{
  static uint32_t last_input_states = 0;
  
  uint32_t states = reg.read32bits();

  /* Print the input states only if they're changed */
  if (states != last_input_states)
  {
    uint32_t changed = states ^ last_input_states; // get changed states only
    last_input_states = states;
    
    for (int i = 0; i < reg.bandwidth() * 8; ++i)
    {
      /* Check only few specific inputs */
      if ((i == 0   || // 1A
           i == 6   || // 1G
           i == 9   || // 2B
           i == 13  || // 2F
           i == 18  || // 3C
           i == 20) && // 3E
          (changed & 1))
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
