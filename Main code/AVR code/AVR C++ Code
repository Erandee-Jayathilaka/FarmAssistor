/*
 * GccApplication4.cpp
 *
 * Created: 8/21/2024 1:59:02 PM
 * Author : ERANDEE
 */ 

#ifndef F_CPU
#define F_CPU 16000000UL  // 16 MHz clock speed
#endif

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/wdt.h>
#include <util/delay.h>
#include <stdlib.h>

#define DHT11_PIN PINC1  // A1 corresponds to PINC1
#define sensorPin 0      // ADC0 corresponds to channel 0

uint8_t I_RH, D_RH, I_Temp, D_Temp, CheckSum;

void ADC_init() {
    ADMUX |= (1 << REFS0);  // Set reference voltage to AVcc
    ADCSRA |= (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);  // Set ADC prescaler to 128
    ADCSRA |= (1 << ADEN);  // Enable ADC
}

uint16_t ADC_read(uint8_t channel) {
    ADMUX = (ADMUX & 0xF8) | (channel & 0x07);  // Select channel
    ADCSRA |= (1 << ADSC);  // Start conversion
    while (ADCSRA & (1 << ADSC));  // Wait for conversion
    return ADC;
}

void UART_init(uint16_t ubrr) {
    UBRR0H = (ubrr >> 8);
    UBRR0L = ubrr;
    UCSR0B = (1 << TXEN0) | (1 << RXEN0);
    UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);
}

void UART_transmit(uint8_t data) {
    while (!(UCSR0A & (1 << UDRE0)));
    UDR0 = data;
}

void UART_print(const char *str) {
    while (*str) {
        UART_transmit(*str++);
    }
}

void UART_println() {
    UART_transmit('\r');
    UART_transmit('\n');
}

void UART_print_value(const char *label, uint16_t value) {
    UART_print(label);
    char numBuffer[10];
    itoa(value, numBuffer, 10);
    UART_print(numBuffer);
    UART_println();
}

int mapValue(int inputValue) {
    // Coefficients derived from the linear equation
    float slope = -0.5833;
    float intercept = 282.5;

    // Calculate the mapped value
    int mappedValue = (int)(slope * inputValue + intercept);

    // Return the mapped value
    return mappedValue;
}

void Request() {
    DDRC |= (1 << DHT11_PIN);    // Set pin as output
    PORTC &= ~(1 << DHT11_PIN);  // Send low signal
    _delay_ms(20);               // Wait for 20ms
    PORTC |= (1 << DHT11_PIN);   // Set pin high
}

void Response() {
    DDRC &= ~(1 << DHT11_PIN);   // Set pin as input
    while (PINC & (1 << DHT11_PIN)); // Wait for pin to go low
    while ((PINC & (1 << DHT11_PIN)) == 0); // Wait for pin to go high
    while (PINC & (1 << DHT11_PIN)); // Wait for pin to go low again
}

uint8_t Receive_data() {
    uint8_t data = 0;
    for (int q = 0; q < 8; q++) {
        while ((PINC & (1 << DHT11_PIN)) == 0); // Wait for pin to go high
        _delay_us(30); // Wait for 30us
        if (PINC & (1 << DHT11_PIN)) // Check if pin is still high
            data = (data << 1) | (0x01); // It's a high bit
        else
            data = (data << 1); // It's a low bit
        while (PINC & (1 << DHT11_PIN)); // Wait for pin to go low
    }
    return data;
}

void enter_sleep_mode() {
    set_sleep_mode(SLEEP_MODE_PWR_DOWN);
    sleep_enable();
    sei();  // Enable global interrupts
    sleep_cpu();  // Go to sleep
    sleep_disable();
}

void watchdog_setup_8s() {
    MCUSR &= ~(1 << WDRF);
    WDTCSR |= (1 << WDCE) | (1 << WDE);
    WDTCSR = (1 << WDP3) | (1 << WDE) | (1 << WDIE);  // Set WDT to interrupt and reset mode, 8s timeout
}

void watchdog_setup_2s() {
    MCUSR &= ~(1 << WDRF);
    WDTCSR |= (1 << WDCE) | (1 << WDE);
    WDTCSR = (1 << WDP2) | (1 << WDP1) | (1 << WDE) | (1 << WDIE);  // Set WDT to interrupt and reset mode, 2s timeout
}

ISR(WDT_vect) {
    // Watchdog interrupt routine - wakes up MCU
}

int main(void) {
    UART_init(8);  // Initialize UART with baud rate of 115200 (assuming 16 MHz clock)
    ADC_init();  // Initialize ADC

    while (1) {
        watchdog_setup_8s();  // Setup watchdog for 8 seconds
        enter_sleep_mode();  // Enter sleep mode (8s)

        watchdog_setup_2s();  // Setup watchdog for 2 seconds
        enter_sleep_mode();  // Enter sleep mode (2s)

        // Wake up and print the data
        uint16_t val1 = ADC_read(sensorPin);
        if (val1 > 440) {
        val1 = 440;
        } else if (val1 < 330) {
        val1 = 330;
        }
        uint16_t value = mapValue(val1);
        UART_print_value("Soil moisture: ", value);

        // DHT11 sensor reading
        Request();        // Send start pulse
        Response();       // Receive response
        I_RH = Receive_data();  // Store first eight bits in I_RH
        D_RH = Receive_data();  // Store next eight bits in D_RH
        I_Temp = Receive_data(); // Store next eight bits in I_Temp
        D_Temp = Receive_data(); // Store next eight bits in D_Temp
        CheckSum = Receive_data(); // Store next eight bits in CheckSum
        
        if ((I_RH + D_RH + I_Temp + D_Temp) != CheckSum) {
            UART_print("Error");
            UART_println();
        } else {
            UART_print_value("Humidity: ", I_RH);
            UART_print_value("Temperature: ", I_Temp);
        }
        
        _delay_ms(200);  // Delay before the next reading
    }
}
