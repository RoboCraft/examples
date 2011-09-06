#include <SPI.h>

enum { REG_SELECT = 8 }; // the latch controller pin

void setup()
{
  /* Initialize SPI bus. If you're using software SPI, then you need
   * to configure the SPI pins appropriately yourself.
   */
  SPI.begin();
  
  pinMode(REG_SELECT, OUTPUT);
  digitalWrite(REG_SELECT, LOW); // select then SPI slave (our shift register)
  SPI.transfer(0); // clear shift register
  /* Deselect the shift register, pushing the bits written to the Q0-Q7 pins */
  digitalWrite(REG_SELECT, HIGH);
}


/* Shifts the bits to the left, replacing the low bit by high bit.
 * In other words, rotates the bits to the left.
 * For example, 11110000 becomes 11100001.
 */
void rotateLeft(uint8_t &bits)
{
  bits = (bits << 1) | (bits & 0x80 ? 1 : 0);
}


void loop()
{
  static uint8_t nomad = 1;
  
  /* Write the bits */
  digitalWrite(REG_SELECT, LOW);
  SPI.transfer(nomad);
  digitalWrite(REG_SELECT, HIGH);
  /* Rotate them */
  rotateLeft(nomad);
  
  delay(1000 / 8); // full rotate in one second
}
