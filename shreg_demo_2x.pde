#include <LineDriver.h>
#include <SPI.h>
#include <SPI_Bus.h>

/* Use the following declaration for software SPI mode:
 *   SPI_8bit_Bus reg(latchPin, clockPin, dataPin);
 * Here we use hardware bus mode (the default) with clock divider = 4,
 * and data transfer mode = most significant bit first.
 */
SPI_Bus reg1(_8bit, 8), reg2(_8bit, 7);


void setup()
{
  reg1.write(0u);
  reg2.write(0u);
}


/* Shifts the bits to the left, replacing the low bit by high bit.
 * In other words, rotates the bits to the left.
 * For example, 11110000 becomes 11100001.
 */
void rotateLeft(uint8_t &bits)
{
  bits = (bits << 1) | (bits & 0x80 ? 1 : 0);
}


void rotateRight(uint8_t &bits)
{
  bits = (bits >> 1) | (bits & 1 ? 0x80 : 0);
}


void loop()
{
  static uint8_t nomad1 = 1, nomad2 = 0x80;
  
  reg1.write(nomad1);
  rotateLeft(nomad1);
  
  reg2.write(nomad2);
  rotateRight(nomad2);
  
  /* Full rotate in one second */
  delay(1000 / reg1.bandwidth() / 8);
}
