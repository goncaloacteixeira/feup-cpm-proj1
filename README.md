# Acme Shop
User Application & Terminal Application & API

## Context

This project was developed on the Mobile Computation Course - Masters in Informatics and Computing Engineering at FEUP (Faculdade de Engenharia da Universidade do Porto)

The project is a set of apps to simulate a physical store: the user registers on a consumer end mobile application, and walks through the store scanning products' barcodes with their Android smartphone, then when they are done they can pay with the mobile device and the server generates a token which they can use to validade the purchase and collect the bought goods. This validation is performed by exhanging the token with a terminal (running an Android application) either by NFC or QR-Code. 
The whole communication process between the consumer application and the server is secure and encrypted.

## API

The API is built on NodeJS (javascript) with ExpressJS as the engine for the HTTP requests. There is also a frontend application built on ReactJS and MaterialUI components.

Instructions on how to run the API server and frontend application can be found [here](./api/README.md).

## Consumer & Terminal Applications

These applications are built on Kotlin with Android SKD 24.

To run each application we suggest using the Android Studio.

---

More information available on the report.