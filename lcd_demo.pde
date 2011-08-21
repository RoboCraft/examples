#include <LiquidCrystal.h>

enum { SYMBOL_HEIGHT = 8 };

byte arnie[SYMBOL_HEIGHT] =
{
  B10101,
  B11111,
  B10111,
  B11111,
  B11111,
  B00111,
  B11110,
  B00000,
};

byte skull_and_bones[SYMBOL_HEIGHT] =
{
  B01110,
  B10101,
  B11011,
  B01110,
  B00000,
  B10001,
  B01110,
  B10001,
};

byte lightning[SYMBOL_HEIGHT] =
{
  B00010,
  B00100,
  B01000,
  B11111,
  B00010,
  B00100,
  B01000,
  B00000,
};

/* Screen size */
enum { LCD_WIDTH = 16, LCD_HEIGHT = 2 };

/* Define our LCD */
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);


void setup()
{
  /* Create our custom symbols */
  lcd.createChar(0, arnie);
  lcd.createChar(1, skull_and_bones);
  lcd.createChar(2, lightning);
  /* Enable the display */
  lcd.begin(LCD_WIDTH, LCD_HEIGHT);
}


typedef void (*LCD_demo)();

/* List of demo functions. Fell free to add your own to extend this demo.
 * You'd better not to do such macros in serious, production-quality code.
 */
LCD_demo const demos[] =
{
  showArnie,
  showWarning,
  showScrolling,
  showAutoscroll,
  showRTL
};

/* Some syntactic sugar. I hate to write similar for-loops ten times. */
#define dotimes(n, code) for (int i = 0; i < (n); ++i) code;


void loop()
{
  dotimes(sizeof(demos) / sizeof(demos[0]),
  {
    demos[i](); // launch next demo
    
    delay(2000);
    lcd.clear();
    delay(1000);
  });
}


void showArnie()
{
  lcd.cursor(); // show cursor
  lcd.blink(); // make it blink
  delay(1000);
  
  lcd.write(0); // enter the Arnie
  lcd.write(' ');
  delay(1000);
  
  lcd.print("I'll be back");
  delay(1000);
  
  lcd.noBlink(); // enough blinking
  lcd.noCursor(); // hide cursor
}


void showWarning()
{
  /* Since custom symbol codes are 0-7, we can use octal
   * character code notation to print our custom symbols.
   * NOTE: code 0 (zero) in strings in C and C++ is threated as
   * the end of the string, so use lcd.write(0) to print such symbol.
   */
  lcd.print("Smoke kills \1");
  delay(2000);
  
  lcd.setCursor(0, 1); // go to the next line
  lcd.print("\2 AC/DC \2  rocks"); // we can place symbols everywhere
}


void showScrolling()
{
  lcd.print("I'm scrolling");
  delay(1000);
  
  /* Scroll text to the right */
  dotimes(16,
  {
    lcd.scrollDisplayRight();
    delay(150);
  });
  
  /* And scroll it back */
  dotimes(16,
  {
    lcd.scrollDisplayLeft();
    delay(150);
  });
}

void showAutoscroll()
{
  lcd.setCursor(LCD_WIDTH - 2, 0);
  lcd.autoscroll(); // enable auto-scrolling
  
  const char *text = "autoscroll";
  
  /* Print the text letter by letter */
  dotimes(strlen(text),
  {
    lcd.write(text[i]);
    delay(200);
  });
  
  lcd.noAutoscroll(); // disable auto-scrolling
}


void showRTL()
{
  lcd.setCursor(LCD_WIDTH - 1, 0);
  lcd.rightToLeft(); // set RTL direction
  
  const char *text = "tfel-ot-thgir"; // guess what is this (:
  
  /* Print the text letter by letter */
  dotimes(strlen(text),
  {
    lcd.write(text[i]);
    delay(200);
  });
  
  lcd.leftToRight(); // set LTR direction (default)
}
