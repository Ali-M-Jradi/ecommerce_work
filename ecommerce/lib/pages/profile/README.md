# 👤 Profile Page

The ProfilePage module manages all user profile, account, and settings flows for the DERMOCOSMETIQUE ecommerce application.

## 📋 **Overview**

ProfilePage provides:
- User info display and editing
- Address book management
- Change password and security
- App and notification settings
- Multi-language support (Arabic/English, RTL)
- Provider-based state management
- Integration with orders and notifications modules

## 🏗️ **File Structure**

```
profile/
├── profile_page.dart               # Main user profile page
├── edit_profile_page.dart          # Edit user information
├── address_book_page.dart          # Manage addresses
├── change_password_page.dart       # Update password
├── settings_page.dart              # App and notification settings
├── profile_provider.dart           # State management
└── README.md                       # This documentation
```

## 🎯 **Key Components**

### **ProfilePage (profile_page.dart)**
```dart
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
}
```
**Features:**
- Display user info (name, email, phone, avatar)
- Edit profile shortcut
- Order history shortcut
- Address book shortcut
- Settings shortcut
- Logout button

### **EditProfilePage (edit_profile_page.dart)**
**Features:**
- Update name, email, phone, avatar
- Save changes with validation

### **AddressBookPage (address_book_page.dart)**
**Features:**
- List/add/edit/delete addresses
- Set default address

### **ChangePasswordPage (change_password_page.dart)**
**Features:**
- Change password with validation
- Email confirmation for changes

### **SettingsPage (settings_page.dart)**
**Features:**
- Language selection
- Notification preferences
- Theme selection
- Privacy and security options

### **ProfileProvider (profile_provider.dart)**
```dart
class ProfileProvider with ChangeNotifier {
  User? user;
  // ...methods for update, logout, etc.
}
```
**Features:**
- State management for user profile
- Update user info
- Manage addresses and settings

## 🏗️ **Architecture & State Management**

### **Provider Integration**
```dart
Provider.of<ProfileProvider>(context)
```

### **User Data Model**
```dart
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  // ...other fields
}
```

## 🎨 **UI/UX Features**

- Profile page with avatar and info
- Editable fields
- Address list and management
- Settings and preferences
- Multi-language and RTL support

## 🔒 **Security & Privacy**

- Password change and reset
- Email/phone verification
- Notification opt-in/out
- Account deletion and data export

## 🌍 **Multi-Language & RTL Support**

- All profile content localized
- RTL layout for Arabic

## 🚀 **Profile Flow**

```
ProfilePage → EditProfilePage / AddressBookPage / SettingsPage
```

## 🧪 **Testing & Quality Assurance**

- Unit tests for ProfileProvider logic
- Widget tests for profile and settings
- Integration tests for profile updates and address management

## 🔮 **Future Enhancements**

- [ ] Social login integration
- [ ] Profile analytics
- [ ] Biometric security
- [ ] User preferences sync

---

For implementation details, see the respective Dart files in this directory.
