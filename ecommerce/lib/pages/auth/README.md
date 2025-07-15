# 🔐 Auth Page

The AuthPage module manages all authentication and user access flows for the DERMOCOSMETIQUE ecommerce application.

## 📋 **Overview**

AuthPage provides:
- Animated login and registration pages
- Email/password authentication
- Password reset and recovery
- Social login (future-ready)
- Multi-language support (Arabic/English, RTL)
- Secure form validation
- Provider-based state management
- Error handling and feedback

## 🏗️ **File Structure**

```
auth/
- login_page.dart            # Login UI and logic
- register_page.dart         # Registration UI and logic
- forgot_password_page.dart  # Password reset
- auth_provider.dart         # State management
- auth_localizations.dart    # Multi-language support
- README.md                  # This documentation
```
> **Note:** The login (`login_page.dart`), registration (`register_page.dart`), and password reset (`forgot_password_page.dart`) pages, along with their provider (`auth_provider.dart`), are present in this directory. However, registration and password reset features are not fully implemented yet and may be incomplete or subject to change.

## 🎯 **Key Components**

### **LoginPage (login_page.dart)**
```dart
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
}
```
**Features:**
- Animated login form
- Email and password fields
- Password visibility toggle
- Login button with loading state
- Error messages and validation
- Navigation to registration and password reset

### **RegisterPage (register_page.dart)**
```dart
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
}
```
**Features:**
- Animated registration form
- Name, email, password, confirm password fields
- Password strength validation
- Registration button with loading state
- Error messages and validation
- Navigation to login

### **ForgotPasswordPage (forgot_password_page.dart)**
```dart
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
}
```
**Features:**
- Email input for password reset
- Reset button with loading state
- Success and error feedback
- Navigation to login

## 🏗️ **Architecture & State Management**

### **Provider Integration**
```dart
// Auth state management
Provider.of<AuthProvider>(context)
```

### **AuthProvider (auth_provider.dart)**
```dart
class AuthProvider with ChangeNotifier {
  bool isLoading = false;
  String? error;
  User? user;

  Future<void> login(String email, String password) async { ... }
  Future<void> register(String name, String email, String password) async { ... }
  Future<void> resetPassword(String email) async { ... }
  void logout() { ... }
}
```

### **Localization (auth_localizations.dart)**
- All UI strings are localized for English and Arabic
- RTL layout support for Arabic

## 🎨 **UI/UX Features**

- Animated transitions between login/register/forgot password
- Responsive design for mobile and tablet
- Accessible form fields
- Clear error and success feedback
- Theming consistent with app design

## 🔒 **Security Features**

- Password obscuring and toggle
- Input validation (email format, password strength)
- Secure error handling (no sensitive info leaked)
- Future: Two-factor authentication, social login

## 🌍 **Multi-Language & RTL Support**

- All forms and messages available in English and Arabic
- RTL layout for Arabic users
- Language switcher integrated with app settings

## 🚀 **Navigation Flow**

```
AuthPage Navigation:
├── Login → RegisterPage ("Create Account")
├── Login → ForgotPasswordPage ("Forgot Password?")
├── Register → LoginPage ("Already have an account?")
├── ForgotPassword → LoginPage ("Back to Login")
```

## 📱 **State Management**

### **Auth State**
```dart
bool isLoading = false;
String? error;
User? user;
```

### **Methods**
- `login(email, password)`: Handles user login
- `register(name, email, password)`: Handles registration
- `resetPassword(email)`: Handles password reset
- `logout()`: Logs out the user

## 🔧 **Key Features**

### **Form Validation**
- Email format validation
- Password strength and match validation
- Real-time error feedback

### **Animated Transitions**
- Smooth page transitions between auth flows
- Animated form fields and buttons

### **Error Handling**
- User-friendly error messages
- Loading indicators during async operations
- Secure error reporting

## 🎛️ **Customization**

### **Adding Social Login**
```dart
// Add social login button
ElevatedButton.icon(
  icon: Icon(Icons.g_mobiledata),
  label: Text('Sign in with Google'),
  onPressed: () => authProvider.signInWithGoogle(),
)
```

### **Modifying Validation Rules**
- Update validation logic in form fields
- Customize error messages in localization files

## 🐛 **Troubleshooting**

### **Common Issues**
1. **Login not working**: Check API endpoint and credentials
2. **Form validation errors**: Ensure all fields are filled and valid
3. **RTL layout issues**: Verify text direction and localization

### **Debug Tips**
- Use Flutter DevTools for widget and state inspection
- Check console for authentication errors
- Verify Provider context availability

## 📈 **Performance**

- **Efficient rebuilds**: Only form and error widgets update on state change
- **Minimal async calls**: Debounced validation and throttled requests

## 🧪 **Testing & Quality Assurance**

- Unit tests for AuthProvider logic
- Widget tests for form validation and error states
- Integration tests for login/register/reset flows

## 🔮 **Future Enhancements**

- [ ] Social login (Google, Facebook, Apple)
- [ ] Two-factor authentication (SMS/email)
- [ ] Account verification (email/phone)
- [ ] Biometric login (Face ID, fingerprint)
- [ ] Passwordless login (magic link)
- [ ] Enhanced error analytics

---

For implementation details, see the respective Dart files in this directory.
