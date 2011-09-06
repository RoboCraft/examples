#include <LineDriver.h>
#include <SPI.h>
#include <SPI_Bus.h>

/* Use the following declaration for software SPI mode:
 *   SPI_8bit_Bus reg(latchPin, clockPin, dataPin);
 * Here we use hardware bus mode (the default) with clock divider = 4,
 * and data transfer mode = most significant bit first.
 */
SPI_Bus reg(_16bit, 8);


void setup()
{
  reg.write(0u);
}


/* Shifts the bits to the left, replacing the low bit by high bit.
 * In other words, rotates the bits to the left.
 * For example, 11110000 becomes 11100001.
 */
void rotateLeft(uint16_t &bits)
{
  bits = (bits << 1) | (bits & 0x8000 ? 1 : 0);
}


void loop()
{
  static uint16_t nomad = 1;
  
  reg.write(nomad); // write into shift register
  rotateLeft(nomad);
  
  /* Full rotate in one second */
  delay(1000 / reg.bandwidth() / 8);
}
