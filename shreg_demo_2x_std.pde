#include <SPI.h>

enum { REG1 = 8, REG2 = 7 };


/* Copy-paste is not the way of jedi */
void writeShiftRegister(int ss_pin, uint8_t value)
{
  digitalWrite(ss_pin, LOW);
  SPI.transfer(value);
  digitalWrite(ss_pin, HIGH);
}


void setup()
{
  SPI.begin();
  
  pinMode(REG1, OUTPUT);
  pinMode(REG2, OUTPUT);
  
  writeShiftRegister(REG1, 0);
  writeShiftRegister(REG2, 0);
}


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
  
  writeShiftRegister(REG1, nomad1);
  rotateLeft(nomad1);
  
  writeShiftRegister(REG2, nomad2);
  rotateRight(nomad2);
  
  delay(1000 / 8);
}
