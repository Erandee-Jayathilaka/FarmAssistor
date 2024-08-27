/**
 * Created by K. Suwatchai (Mobizt)
 *
 * Email: k_suwatchai@hotmail.com
 *
 * Github: https://github.com/mobizt/Firebase-ESP-Client
 *
 * Copyright (c) 2023 mobizt
 *
 */

#include <Arduino.h>
#if defined(ESP32) || defined(ARDUINO_RASPBERRY_PI_PICO_W)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#elif __has_include(<WiFiNINA.h>)
#include <WiFiNINA.h>
#elif __has_include(<WiFi101.h>)
#include <WiFi101.h>
#elif __has_include(<WiFiS3.h>)
#include <WiFiS3.h>
#endif

#include <Firebase_ESP_Client.h>

// Provide the token generation process info.
#include <addons/TokenHelper.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "Dasuni"
#define WIFI_PASSWORD "12345678"

/* 2. Define the API Key */
#define API_KEY "AIzaSyAsPQAeCBmiiM4u9D6WYyrRERhVqb9dc8c"

/* 3. Define the project ID */
#define FIREBASE_PROJECT_ID "farmassistor"

/* 4. Define the user Email and password that already registered or added in your project */
#define USER_EMAIL "1234@gmail.com"
#define USER_PASSWORD "123456"

// Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long dataMillis = 0;
bool taskcomplete = false;

#if defined(ARDUINO_RASPBERRY_PI_PICO_W)
WiFiMulti multi;
#endif

void setup()
{
    Serial.begin(115200);

#if defined(ARDUINO_RASPBERRY_PI_PICO_W)
    multi.addAP(WIFI_SSID, WIFI_PASSWORD);
    multi.run();
#else
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
#endif

    Serial.print("Connecting to Wi-Fi");
    unsigned long ms = millis();
    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        delay(300);
#if defined(ARDUINO_RASPBERRY_PI_PICO_W)
        if (millis() - ms > 10000)
            break;
#endif
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();

    Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

    /* Assign the api key (required) */
    config.api_key = API_KEY;

    /* Assign the user sign-in credentials */
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;

#if defined(ARDUINO_RASPBERRY_PI_PICO_W)
    config.wifi.clearAP();
    config.wifi.addAP(WIFI_SSID, WIFI_PASSWORD);
#endif

    /* Assign the callback function for the long-running token generation task */
    config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

    Firebase.reconnectNetwork(true);

    fbdo.setBSSLBufferSize(4096 /* Rx buffer size in bytes from 512 - 16384 */, 1024 /* Tx buffer size in bytes from 512 - 16384 */);

    fbdo.setResponseSize(2048);

    Firebase.begin(&config, &auth);
}

void loop()
{
    // Firebase.ready() should be called repeatedly to handle authentication tasks.

    if (Firebase.ready() && (millis() - dataMillis > 60000 || dataMillis == 0))
    {
        dataMillis = millis();

        FirebaseJson content;

        // Collection and Document path
        String documentPath = "users/q6SO6NnUaid61754nyYalC5OXCC3/devices/XpVNf77T7Q9PN9YdFCPi";

        // Generate random values for airTemperatureChecked, humidityChecked, and soilMoistureChecked
        int airTemperatureChecked = random(15, 35);   // Random temperature between 15 and 35
        int humidityChecked = random(40, 80);         // Random humidity between 40% and 80%
        int soilMoistureChecked = random(300, 800);   // Random soil moisture between 300 and 800

        // Create the initial document if not created yet
        if (!taskcomplete)
        {
            taskcomplete = true;

            content.clear();
            content.set("fields/airTemperatureChecked/integerValue", String(airTemperatureChecked).c_str());
            content.set("fields/humidityChecked/integerValue", String(humidityChecked).c_str());
            content.set("fields/soilMoistureChecked/integerValue", String(soilMoistureChecked).c_str());

            Serial.print("Create a document... ");

            if (Firebase.Firestore.createDocument(&fbdo, FIREBASE_PROJECT_ID, "" /* databaseId can be (default) or empty */, documentPath.c_str(), content.raw()))
                Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
            else
                Serial.println(fbdo.errorReason());
        }

        // Update the document with new random values
        content.clear();
        content.set("fields/airTemperatureChecked/integerValue", String(airTemperatureChecked).c_str());
        content.set("fields/humidityChecked/integerValue", String(humidityChecked).c_str());
        content.set("fields/soilMoistureChecked/integerValue", String(soilMoistureChecked).c_str());

        Serial.print("Update a document... ");

        if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "" /* databaseId can be (default) or empty */, documentPath.c_str(), content.raw(), "airTemperatureChecked,humidityChecked,soilMoistureChecked" /* updateMask */))
            Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
        else
            Serial.println(fbdo.errorReason());
    }
}
