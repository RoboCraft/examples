/* We have to include a bunch of libraries, because Arduino IDE
 * doesn't allow to one library to include the other.
 */
#include <LineDriver.h>
#include <SPI.h>
#include <SPI_Bus.h>
#include <LiquidCrystalExt.h>
#include <LiquidCrystalRus.h>

/* Yo, dawg! I heard you like SPI, so I put an LCD on your shift register,
 * so you can print() while you're shifting bits.
 */
SPI_Bus shift_register(_8bit, 8); // our 8 bit shift register's latch is on pin 8
/* Yeah, it's that simple - just pass a pointer to the register, and LCD will work
 * through it. That's a huge advantage of properly designed abrstractions.
 */
LiquidCrystalRus lcd(0, 1, 2, 3, 4, 5, &shift_register);


void setup()
{
  lcd.begin(16, 2);
  lcd.print("Hello, World!");
}


void loop()
{
}
