# innerix

Machine Task - Innerix Technologies,Pattambi

## 📱 Overview

This is a Flutter-based eCommerce app submission built as part of the Developer Assessment Task (1–2 years experience). It demonstrates login (via password or OTP) and a home screen with product/category data, following clean architecture,BLoC State Mangment and best practices.

---------------------------------------------------

## UI FLOW

OnBoarding Screen => LoginScreen(email & password) => MainScreen(hometab)
OnBoarding Screen => LoginScreen(email) => OtpScreen (OTP Verification)=> MainScreen(hometab)

## ✅ Features Implemented

### 🔐 Login Screen
- **Password Login**  
  - Endpoint: `POST /api/login`  
  - Inputs: email, password  
  - Success: Navigates to Home screen

- **OTP Login (2-Step)**  
  - Step 1: `POST /api/request-otp` (sends OTP to email)
    NB:OTP is not recieving to the registered mail.(seeked POSTMAN help)  
  - Step 2: `POST /api/verify-email-otp` (validates OTP)  
  - Success: Navigates to Home screen

  ### 🏠 Home Screen
- Fetches product categories, products, and offers.
- API: `GET /api/v1/home`, 
- Uses placeholder images where needed.(Used Lottie File for empty images)

**Flutter**: 3.32.2
- **Architecture**: MVVM with BLoC and a clean architecture 
- **State Management**: BLoC
- **API Integration**: via http
- **Dependency Injection**: Manual constructor injection







