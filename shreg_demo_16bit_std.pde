#include <SPI.h>

enum { REG = 8 };


/* Now we need to transfer 16 bits */
void writeShiftRegister16(int ss_pin, uint16_t value)
{
  digitalWrite(ss_pin, LOW);
  /* Here's the trick: first, transfer high byte */
  SPI.transfer(highByte(value));
  /* Second, transfer the low byte */
  SPI.transfer(lowByte(value));
  digitalWrite(ss_pin, HIGH);
}


void setup()
{
  SPI.begin();
  
  pinMode(REG, OUTPUT);
  writeShiftRegister16(REG, 0);
}


/* Slightly changed this function to work with 16-bit values */
void rotateLeft(uint16_t &bits)
{
  bits = (bits << 1) | (bits & 0x8000 ? 1 : 0);
}


void loop()
{
  static uint16_t nomad = 1;
  
  writeShiftRegister16(REG, nomad);
  rotateLeft(nomad);
  
  delay(1000 / 8);
}
