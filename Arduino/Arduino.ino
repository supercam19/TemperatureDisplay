#include <dht11.h>
#define DHT11PIN 2

dht11 DHT11;

void setup() {
  Serial.begin(9600);

}

void loop() {
  DHT11.read(DHT11PIN);
  // Comment out printCelsius() and uncomment printFahrenheit() if you want fahrenheit
  printCelsius();
  //printFahrenheit();
  Serial.print(",");
  Serial.println(DHT11.humidity);
  delay(1000);
}

void printCelsius() {
  Serial.print(DHT11.temperature);
}

void printFahrenheit() {
  Serial.print(int(DHT11.temperature * 1.8 + 32));
}
