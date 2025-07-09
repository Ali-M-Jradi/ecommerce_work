import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/utils/localization_helper.dart';
import 'package:ecommerce/utils/auth_localizations.dart';
import 'package:ecommerce/providers/user_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;
  int _currentBackgroundIndex = 0;
  
  // Background colors for animated gradient - similar to login page
  final List<List<Color>> _backgroundColors = [
    [Color(0xFF667eea), Color(0xFF764ba2)],
    [Color(0xFF6B73FF), Color(0xFF000DFF)],
    [Color(0xFF9D50BB), Color(0xFF6E48AA)],
    [Color(0xFF4776E6), Color(0xFF8E54E9)],
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startBackgroundAnimation();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _animationController.forward();
  }
  
  // Background color animation function - longer duration (6 seconds instead of 4)
  void _startBackgroundAnimation() {
    Future.delayed(Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _currentBackgroundIndex = (_currentBackgroundIndex + 1) % _backgroundColors.length;
        });
        _startBackgroundAnimation();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    // No need to dispose of _currentBackgroundIndex as it's just an int
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AuthLocalizations.agreeToTermsRequired(context)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    HapticFeedback.lightImpact();
    
    // Simulate signup delay
    await Future.delayed(Duration(seconds: 2));
    
    // Get user information from controllers
    final email = _emailController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    
    // Update user provider with the new user
    Provider.of<UserProvider>(context, listen: false).login(
      email,
      firstName: firstName,
      lastName: lastName,
    );
    
    setState(() {
      _isLoading = false;
    });
    
    // Show success and navigate to home page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AuthLocalizations.accountCreatedSuccessfully(context)),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate to home page
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    // Get screen metrics for responsive layout
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final keyboardVisible = keyboardHeight > 0;
    
    return Scaffold(
      // Change to true to ensure content adjusts with keyboard
      resizeToAvoidBottomInset: true,
      body: AnimatedContainer(
        duration: Duration(seconds: 5), // Slower transition (5 seconds)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _backgroundColors[_currentBackgroundIndex],
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            // Add gesture detector to dismiss keyboard when tapping outside
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              // Better physics for scrolling with keyboard
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header section - hide most of it when keyboard is visible
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: keyboardVisible ? 80 : null,
                    child: keyboardVisible
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Expanded(
                                child: Text(
                                  AuthLocalizations.signUp(context),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(width: 40),
                            ],
                          ),
                        )
                      : _buildHeader(),
                  ),
                  
                  // Sign up form
                  _buildSignUpForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Spacer(),
                Text(
                  AuthLocalizations.signUp(context),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                SizedBox(width: 40), // Balance the back button
              ],
            ),
            
            SizedBox(height: 30),
            
            // Logo
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/three_leaves.png',
                  height: 40,
                  width: 40,
                  color: Colors.white,
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            Text(
              AuthLocalizations.createYourAccount(context),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            
            SizedBox(height: 8),
            
            Text(
              AuthLocalizations.joinBeautyCommunity(context),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    // Check if keyboard is visible to adapt UI
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          // Reduced padding when keyboard is visible
          padding: EdgeInsets.all(keyboardVisible ? 15 : 25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress indicator
                _buildProgressIndicator(),
                
                // Reduced spacing when keyboard is visible
                SizedBox(height: keyboardVisible ? 15 : 25),
                
                // Form fields - no Expanded widgets to avoid layout issues
                _buildFormFields(),
                
                // Terms and conditions
                _buildTermsCheckbox(),
                
                SizedBox(height: keyboardVisible ? 15 : 20),
                
                // Sign up button
                _buildSignUpButton(),
                
                // Only show login link when keyboard is hidden to save space
                if (!keyboardVisible) ...[
                  SizedBox(height: 20),
                  _buildLoginLink(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: 0.7, // Simulate progress
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.shade700,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    final isRTL = LocalizationHelper.isRTL(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name fields
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _firstNameController,
                hintText: AuthLocalizations.firstName(context),
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AuthLocalizations.fieldRequired(context);
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: _buildTextField(
                controller: _lastNameController,
                hintText: AuthLocalizations.lastName(context),
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AuthLocalizations.fieldRequired(context);
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
          
        SizedBox(height: 20),
          
        // Email field
        _buildTextField(
          controller: _emailController,
          hintText: AuthLocalizations.emailAddress(context),
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AuthLocalizations.emailRequired(context);
            }
            if (!value.contains('@')) {
              return AuthLocalizations.emailInvalid(context);
            }
            return null;
          },
        ),
          
        SizedBox(height: 20),
          
        // Password field
        _buildTextField(
          controller: _passwordController,
          hintText: AuthLocalizations.password(context),
          icon: Icons.lock_outline,
          obscureText: !_isPasswordVisible,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey.shade500,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AuthLocalizations.passwordRequired(context);
            }
            if (value.length < 6) {
              return AuthLocalizations.passwordTooShort(context);
            }
            return null;
          },
        ),
          
        SizedBox(height: 20),
          
        // Confirm password field
        _buildTextField(
          controller: _confirmPasswordController,
          hintText: AuthLocalizations.confirmPassword(context),
          icon: Icons.lock_outline,
          obscureText: !_isConfirmPasswordVisible,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey.shade500,
            ),
            onPressed: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AuthLocalizations.confirmPasswordRequired(context);
            }
            if (value != _passwordController.text) {
              return AuthLocalizations.passwordsDoNotMatch(context);
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextDirection? textDirection,
    TextAlign? textAlign,
  }) {
    // Check keyboard visibility for more compact UI
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textDirection: textDirection,
        textAlign: textAlign ?? TextAlign.start,
        style: TextStyle(
          fontSize: keyboardVisible ? 14 : 16, // Smaller font when keyboard is visible
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon, 
            color: Colors.deepPurpleAccent.shade700,
            size: keyboardVisible ? 18 : 20, // Smaller icon when keyboard is visible
          ),
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: keyboardVisible ? 14 : 16, // Smaller hint when keyboard is visible
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(keyboardVisible ? 12 : 16), // Smaller padding when keyboard is visible
          // Added error style to prevent overflow
          errorStyle: TextStyle(
            color: Colors.red.shade700,
            fontSize: 12, // Smaller error text
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    final isRTL = LocalizationHelper.isRTL(context);
    // Check keyboard visibility for more compact UI
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: keyboardVisible ? 5 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns checkbox with the first line of text
        children: [
          Transform.scale(
            scale: 0.8,
            child: Checkbox(
              value: _agreeToTerms,
              onChanged: (value) {
                setState(() {
                  _agreeToTerms = value ?? false;
                });
              },
              activeColor: Colors.deepPurpleAccent.shade700,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // More compact
            ),
          ),
          Expanded(
            child: RichText(
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              text: TextSpan(
                style: TextStyle(
                  fontSize: keyboardVisible ? 12 : 14, // Smaller text when keyboard is visible
                  color: Colors.grey.shade600,
                  height: 1.3, // Better line spacing
                ),
                children: [
                  TextSpan(text: AuthLocalizations.agreeToTerms(context)),
                  TextSpan(
                    text: AuthLocalizations.termsOfService(context),
                    style: TextStyle(
                      color: Colors.deepPurpleAccent.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: AuthLocalizations.and(context)),
                  TextSpan(
                    text: AuthLocalizations.privacyPolicy(context),
                    style: TextStyle(
                      color: Colors.deepPurpleAccent.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurpleAccent.shade700,
            Colors.deepPurpleAccent.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.shade700.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(
                AuthLocalizations.createAccount(context),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    // We'll use isRTL for directionality if needed in the future
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AuthLocalizations.haveAccount(context),
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            AuthLocalizations.signIn(context),
            style: TextStyle(
              color: Colors.deepPurpleAccent.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
