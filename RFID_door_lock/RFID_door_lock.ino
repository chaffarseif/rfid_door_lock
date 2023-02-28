
//https://www.youtube.com/arafamicrosystems
//www.fb.com/arafa.microsys
#include <SPI.h>
#include <MFRC522.h>



/// wifi 

// Insert your network credentials
#define WIFI_SSID "abdou"
#define WIFI_PASSWORD "abdouSuper"
//firebase 
#include <Firebase_ESP_Client.h>

//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert Firebase project API Key
#define API_KEY "AIzaSyAT4ZcS0N1QmeJvIwgr7E0hDGJWAArfcJw"

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://door-lock-a6658-default-rtdb.firebaseio.com" 

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

 
bool signupOK = false;
/// end firebase  ************************************************************

#define SS_PIN 21
#define RST_PIN 22
#define Buzzer 4
MFRC522 rfid(SS_PIN, RST_PIN); // Instance of the class
MFRC522::MIFARE_Key key;
byte nuidPICC[4];
bool flag=false;
bool flag1=false;
 bool statut=false;



 void initWiFi() {
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi ..");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print('.');
    delay(1000);
  }
  Serial.println(WiFi.localIP());
  Serial.println();
}
void setup() 
{
  Serial.begin(115200);
  initWiFi();
  // firebase ////////////////////////////////////
  
  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", "")){
    Serial.println("ok");
    signupOK = true;
  }
  else{
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
/// end firebase *****************************
  
  SPI.begin();      // Initiate  SPI bus
  
  
  rfid.PCD_Init(); // Init MFRC522 
  pinMode(Buzzer,OUTPUT);
    for (byte i = 0; i < 6; i++) {
    key.keyByte[i] = 0xFF;
  }

  Serial.println(F("This code scan the MIFARE Classsic NUID."));
  Serial.print(F("Using the following key:"));
  printHex(key.keyByte, MFRC522::MF_KEY_SIZE);
  Serial.println("Approximate your Card to the Reader....");
}


void readStatusFromFirebase(){
   if (Firebase.RTDB.getBool(&fbdo, "/statut/value")) {
       bool b = fbdo.to<bool>();
       Serial.println("tnekna");
         Serial.println(b);
    }
    else {
      Serial.println(fbdo.errorReason());
    }
}

void insertIntoFirebase(){

  if (Firebase.ready() && signupOK ){
    
    // Write an Int number on the database path test/int
    if (Firebase.RTDB.setBool(&fbdo, "statut/value", true)){
      Serial.println("PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
      readStatusFromFirebase(); 
      }
    else {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
  }
}




/**
 * Helper routine to dump a byte array as hex values to Serial. 
 */
void printHex(byte *buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}

/**
 * Helper routine to dump a byte array as dec values to Serial.
 */
void printDec(byte *buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], DEC);
  }
}


void loop() 
{

 if (Serial.available()) { // if there is data comming
    String command = Serial.readStringUntil('\n'); // read string until newline character

    if (command == "insert") {
        insertIntoFirebase(); 
    } else if (command == "read") {
    readStatusFromFirebase();
     }
  }
 /*
  delay(500);
if(statut==false){
  rfid1();
  insertIntoFirebase();
}else{
  readcard();
}

  */
} 




void rfid1()
{
  if (rfid.PICC_IsNewCardPresent() && rfid.PICC_ReadCardSerial()) {
  String UID="";
  for (byte i=0;i<rfid.uid.size;i++) 
  {
     Serial.print(rfid.uid.uidByte[i] < 0x10 ? " 0" : " ");// E8 07 C7 D2
     Serial.print(rfid.uid.uidByte[i], HEX);
     UID.concat(String(rfid.uid.uidByte[i] < 0x10 ? " 0" : " ")); // 0E c2 12 
     UID.concat(String(rfid.uid.uidByte[i], HEX));
  }
  Serial.println();
  Serial.print("Message : ");
  UID.toUpperCase();
  // E8 07 C7 D2
  if (UID.substring(1) == "43 61 9B 19") //change here the UID of the card/cards that you want to give access
  {
    Serial.println("Si seif");
    Serial.println("Authorized access");
    flag=true;
  }else if(UID.substring(1) == "6C 0D 04 39")
  {
    Serial.println("aziz");
    Serial.println("Authorized access");
    flag=true;
  }else
  {
    Serial.println(" Access denied");
    digitalWrite(Buzzer,HIGH);
    delay(500);
    digitalWrite(Buzzer,LOW);
    delay(800);
    flag=false;
  }
    if(flag)
  {
    digitalWrite(Buzzer,HIGH);
    delay(50);
    digitalWrite(Buzzer,LOW);
    delay(50);
    digitalWrite(Buzzer,HIGH);
    delay(50);
    digitalWrite(Buzzer,LOW);
    delay(1000);
    flag=false;
  }
  
  rfid.PICC_HaltA();
  // Stop encryption on PCD
  rfid.PCD_StopCrypto1();
  
}
}
 void readcard(){

delay(500);
  // Reset the loop if no new card present on the sensor/reader. This saves the entire process when idle.
  if ( ! rfid.PICC_IsNewCardPresent())
    return;

  // Verify if the NUID has been readed
  if ( ! rfid.PICC_ReadCardSerial())
    return;

  Serial.print(F("PICC type: "));
  MFRC522::PICC_Type piccType = rfid.PICC_GetType(rfid.uid.sak);
  Serial.println(rfid.PICC_GetTypeName(piccType));

  // Check is the PICC of Classic MIFARE type
  if (piccType != MFRC522::PICC_TYPE_MIFARE_MINI &&  
    piccType != MFRC522::PICC_TYPE_MIFARE_1K &&
    piccType != MFRC522::PICC_TYPE_MIFARE_4K) {
    Serial.println(F("Your tag is not of type MIFARE Classic."));
    return;
  }

  if (rfid.uid.uidByte[0] != nuidPICC[0] || 
    rfid.uid.uidByte[1] != nuidPICC[1] || 
    rfid.uid.uidByte[2] != nuidPICC[2] || 
    rfid.uid.uidByte[3] != nuidPICC[3] ) {
    Serial.println(F("A new card has been detected."));

    // Store NUID into nuidPICC array
    for (byte i = 0; i < 4; i++) {
      nuidPICC[i] = rfid.uid.uidByte[i];
    }
   
    Serial.println(F("The NUID tag is:"));
    Serial.print(F("In hex: "));
    printHex(rfid.uid.uidByte, rfid.uid.size);
    Serial.println();
    Serial.print(F("In dec: "));
    printDec(rfid.uid.uidByte, rfid.uid.size);
    Serial.println();
  }
  else Serial.println(F("Card read previously."));

  // Halt PICC
  rfid.PICC_HaltA();

  // Stop encryption on PCD
  rfid.PCD_StopCrypto1();
}
