import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/utils/localization_helper.dart';
import 'package:ecommerce/utils/auth_localizations.dart';
import 'package:ecommerce/utils/app_colors.dart';
import 'package:ecommerce/services/auth_service.dart';
import 'auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  int _currentBackgroundIndex = 0;

  // Background colors for animated gradient - will be generated from theme
  List<List<Color>> _backgroundColors = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startBackgroundAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateThemeBasedColors();
  }

  void _generateThemeBasedColors() {
    final primaryColor = AppColors.primary(context);
    final secondaryColor = AppColors.secondary(context);
    final accentColor = AppColors.accent(context);
    
    // Create gradient variations based on theme colors
    _backgroundColors = [
      [primaryColor, secondaryColor],
      [primaryColor.withOpacity(0.8), accentColor],
      [secondaryColor, primaryColor.withOpacity(0.9)],
      [accentColor.withOpacity(0.7), primaryColor],
    ];
  }

  // Helper method to get theme-based primary color
  Color get _themeColor => AppColors.primary(context);

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _animationController.forward();
  }

  void _startBackgroundAnimation() {
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _currentBackgroundIndex =
              (_currentBackgroundIndex + 1) % _backgroundColors.length;
        });
        _startBackgroundAnimation();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Get form data
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Attempt login using AuthProvider (includes automatic URL testing and fallback)
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(email, password);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Navigate to home page on success
      Navigator.pushReplacementNamed(context, '/');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AuthLocalizations.loginSuccessful(context)),
          backgroundColor: AppColors.success(context),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // Determine error type and show appropriate message
      String errorMessage;
      Color backgroundColor;
      
      final error = authProvider.error ?? '';
      
      // Check for specific error types
      if (error.toLowerCase().contains('unauthorized') || 
          error.toLowerCase().contains('invalid credentials') ||
          error.toLowerCase().contains('wrong password') ||
          error.toLowerCase().contains('incorrect') ||
          error.contains('401')) {
        errorMessage = '❌ Incorrect credentials: Please check your email and password';
        backgroundColor = AppColors.warning(context);
      } else if (error.toLowerCase().contains('connection') ||
                 error.toLowerCase().contains('network') ||
                 error.toLowerCase().contains('timeout') ||
                 error.toLowerCase().contains('server') ||
                 error.toLowerCase().contains('unreachable') ||
                 error.contains('500') ||
                 error.contains('502') ||
                 error.contains('503')) {
        errorMessage = '🌐 Connection error: Cannot reach server. Please check your internet connection';
        backgroundColor = AppColors.error(context);
      } else if (error.isEmpty) {
        errorMessage = '⚠️ Login failed: Unknown error occurred';
        backgroundColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
      } else {
        errorMessage = '⚠️ Error: $error';
        backgroundColor = AppColors.error(context);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
      
      // Also log the error for debugging
      print('LOGIN ERROR: $error');
      print('LOGIN ERROR TYPE: ${error.toLowerCase().contains('unauthorized') ? 'CREDENTIALS' : 'CONNECTION'}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen metrics
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final availableHeight = screenHeight - MediaQuery.of(context).padding.top;

    return Scaffold(
      // Use resizeToAvoidBottomInset to prevent the keyboard from causing overflow
      resizeToAvoidBottomInset: false,
      body: AnimatedContainer(
        duration: const Duration(seconds: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _backgroundColors[_currentBackgroundIndex],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            // This physics provides a smoother scroll experience
            physics: const BouncingScrollPhysics(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  // Setting the height based on available space and keyboard state
                  constraints: BoxConstraints(
                    minHeight: keyboardHeight > 0
                        ? availableHeight + keyboardHeight
                        : availableHeight,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top decorative section - reduce space when keyboard is visible
                      keyboardHeight > 0
                          ? SizedBox(
                              height: availableHeight * 0.15,
                              child: _buildTopSection(),
                            )
                          : _buildTopSection(),

                      // Login form section
                      _buildLoginForm(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    final isRTL = LocalizationHelper.isRTL(context);
    // Check if keyboard is visible to adapt UI
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated logo - smaller when keyboard is visible
            if (!keyboardVisible)
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: keyboardVisible ? 80 : 120,
                  height: keyboardVisible ? 80 : 120,
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
                      height: keyboardVisible ? 40 : 60,
                      width: keyboardVisible ? 40 : 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            if (!keyboardVisible) const SizedBox(height: 30),

            // App title with animation - hide when keyboard is visible
            if (!keyboardVisible)
              SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    Text(
                      AuthLocalizations.brandName(context),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AuthLocalizations.brandTagline(context),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: keyboardVisible ? 10 : 20),

            // Welcome message - condensed when keyboard is visible
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                AuthLocalizations.welcomeBack(context),
                style: TextStyle(
                  fontSize: keyboardVisible ? 20 : 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
              ),
            ),

            const SizedBox(height: 10),

            // Hide this text when keyboard is visible to save space
            if (!keyboardVisible)
              Text(
                AuthLocalizations.signInToContinue(context),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    final isRTL = LocalizationHelper.isRTL(context);

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: isRTL
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Form header
                Center(
                  child: Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Email field
                _buildEmailField(),

                const SizedBox(height: 20),

                // Password field
                _buildPasswordField(),

                const SizedBox(height: 15),

                // Remember me and forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: isRTL
                      ? [
                          TextButton(
                            onPressed: () {
                              // Handle forgot password
                            },
                            child: Text(
                              AuthLocalizations.forgotPassword(context),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                AuthLocalizations.rememberMe(context),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Transform.scale(
                                scale: 0.8,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                  activeColor: _themeColor,
                                ),
                              ),
                            ],
                          ),
                        ]
                      : [
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                  activeColor: _themeColor,
                                ),
                              ),
                              Text(
                                AuthLocalizations.rememberMe(context),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle forgot password
                            },
                            child: Text(
                              AuthLocalizations.forgotPassword(context),
                              style: TextStyle(
                                fontSize: 14,
                                color: _themeColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                ),

                const SizedBox(height: 25),

                // Login button
                _buildLoginButton(),

                const SizedBox(height: 15),

                // Connection test button (debug only)
                _buildConnectionTestButton(),

                const SizedBox(height: 25),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AuthLocalizations.orContinueWith(context),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 25),

                // Social login buttons
                _buildSocialButtons(),

                const SizedBox(height: 30),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AuthLocalizations.noAccount(context),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to sign up
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: Text(
                        AuthLocalizations.signUp(context),
                        style: TextStyle(
                          color: _themeColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    final isRTL = LocalizationHelper.isRTL(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          prefixIcon: isRTL
              ? null
              : Icon(
                  Icons.email_outlined,
                  color: _themeColor,
                ),
          suffixIcon: isRTL
              ? Icon(
                  Icons.email_outlined,
                  color: _themeColor,
                )
              : null,
          hintText: AuthLocalizations.email(context),
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
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
    );
  }

  Widget _buildPasswordField() {
    final isRTL = LocalizationHelper.isRTL(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          prefixIcon: isRTL
              ? null
              : Icon(
                  Icons.lock_outline,
                  color: _themeColor,
                ),
          prefixIconConstraints: const BoxConstraints(minWidth: 40),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
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
              if (isRTL)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Icon(
                    Icons.lock_outline,
                    color: _themeColor,
                  ),
                ),
            ],
          ),
          hintText: AuthLocalizations.password(context),
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
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
    );
  }

  Widget _buildLoginButton() {
    // No directionality needed for this widget

    return Container(
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _themeColor,
            _themeColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _themeColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(
                AuthLocalizations.loginButton(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildConnectionTestButton() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextButton(
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('🔍 Testing connection to server...'),
              backgroundColor: AppColors.info(context),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
          
          // Run the connection debug
          await AuthService.debugConnection();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✅ Connection test complete - check console for details'),
              backgroundColor: AppColors.success(context),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_find, color: Colors.grey.shade600, size: 16),
            const SizedBox(width: 6),
            Text(
              'Test Connection',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            icon: Icons.g_mobiledata,
            label: AuthLocalizations.google(context),
            onPressed: () {
              // Handle Google login
            },
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildSocialButton(
            icon: Icons.apple,
            label: AuthLocalizations.apple(context),
            onPressed: () {
              // Handle Apple login
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    // This is used for RTL-aware layout below
    final isRTL = LocalizationHelper.isRTL(context);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: isRTL
              ? [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(icon, color: Colors.grey.shade700, size: 24),
                ]
              : [
                  Icon(icon, color: Colors.grey.shade700, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
