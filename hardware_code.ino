#include <WiFi.h>
#include <HTTPClient.h>
#include <time.h>

// WiFi credentials
const char* ssid = "wifi ssid";
const char* password = "pass";

// Firebase project info
const String FIREBASE_PROJECT_ID = "your project id";
const String API_KEY = "your api key";
const String USER_UID = "firebased uid"; // your Firebase UID

#define UV_SENSOR_PIN 36
unsigned long lastSendTime = 0;
const unsigned long sendInterval = 5 * 60 * 1000; // 10 seconds

void setup() {
  Serial.begin(115200);
  analogReadResolution(12);

  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println(" Connected!");

  // Sync time for ISO timestamp
  configTime(0, 0, "pool.ntp.org", "time.nist.gov");
}

void loop() {
  int rawValue = analogRead(UV_SENSOR_PIN);
  float voltage = rawValue * (3.3 / 4095.0);
  float uvIndex = (voltage - 1.0) * 8.33;
  if (uvIndex < 0) uvIndex = 0;

  String riskLevel;
  if (uvIndex <= 2.0) riskLevel = "Low";
  else if (uvIndex <= 5.0) riskLevel = "Moderate";
  else if (uvIndex <= 7.0) riskLevel = "High";
  else if (uvIndex <= 10.0) riskLevel = "Very High";
  else riskLevel = "Extreme";

  Serial.print("Raw: ");
  Serial.print(rawValue);
  Serial.print(" | Voltage: ");
  Serial.print(voltage, 2);
  Serial.print(" V | UV Index: ");
  Serial.print(uvIndex, 2);
  Serial.print(" | Risk: ");
  Serial.println(riskLevel);

  if (millis() - lastSendTime >= sendInterval) {
    sendUVToFirebase(uvIndex);
    lastSendTime = millis();
  }

  delay(1000);
}

void sendUVToFirebase(float uvIndex) {
  if (WiFi.status() != WL_CONNECTED) return;

  HTTPClient http;

  // Get current UTC timestamp in ISO 8601 format
  time_t now;
  time(&now);
  char timestamp[30];
  strftime(timestamp, sizeof(timestamp), "%Y-%m-%dT%H:%M:%SZ", gmtime(&now));

  // Firestore URLs
  String documentPath = "users/" + USER_UID;
  String exposureLogPath = "users/" + USER_UID + "/exposureLogs";

  // ----------- Update currentUVIndex in user document -----------
  String updateUrl = "https://firestore.googleapis.com/v1/projects/" + FIREBASE_PROJECT_ID +
                     "/databases/(default)/documents/" + documentPath + "?updateMask.fieldPaths=currentUVIndex";

  String updatePayload = "{\"fields\": {\"currentUVIndex\": {\"doubleValue\": " + String(uvIndex, 2) + "}}}";

  http.begin(updateUrl);
  http.addHeader("Content-Type", "application/json");
  int updateCode = http.PATCH(updatePayload);
  Serial.printf("Update Status Code: %d\n", updateCode);
  http.end();

  // ----------- Add new exposure log entry -----------
  String logUrl = "https://firestore.googleapis.com/v1/projects/" + FIREBASE_PROJECT_ID +
                  "/databases/(default)/documents/" + exposureLogPath;

  String logPayload = "{\"fields\": {\"uvIndex\": {\"doubleValue\": " + String(uvIndex, 2) +
                      "}, \"timestamp\": {\"timestampValue\": \"" + String(timestamp) + "\"}}}";

  http.begin(logUrl);
  http.addHeader("Content-Type", "application/json");
  int logCode = http.POST(logPayload);
  Serial.printf("Log Status Code: %d\n", logCode);
  http.end();
}