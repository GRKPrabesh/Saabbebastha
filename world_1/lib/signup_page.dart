import 'package:flutter/material.dart';
import 'login_page.dart';
import 'services/api_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String _selectedCountryCode = '+1'; // Default to US

  // Country codes list - sorted alphabetically A to Z
  final List<Map<String, String>> _countryCodes = [
    {'code': '+93', 'name': 'Afghanistan', 'flag': '🇦🇫'},
    {'code': '+355', 'name': 'Albania', 'flag': '🇦🇱'},
    {'code': '+213', 'name': 'Algeria', 'flag': '🇩🇿'},
    {'code': '+376', 'name': 'Andorra', 'flag': '🇦🇩'},
    {'code': '+244', 'name': 'Angola', 'flag': '🇦🇴'},
    {'code': '+1', 'name': 'Antigua and Barbuda', 'flag': '🇦🇬'},
    {'code': '+54', 'name': 'Argentina', 'flag': '🇦🇷'},
    {'code': '+374', 'name': 'Armenia', 'flag': '🇦🇲'},
    {'code': '+61', 'name': 'Australia', 'flag': '🇦🇺'},
    {'code': '+43', 'name': 'Austria', 'flag': '🇦🇹'},
    {'code': '+994', 'name': 'Azerbaijan', 'flag': '🇦🇿'},
    {'code': '+1', 'name': 'Bahamas', 'flag': '🇧🇸'},
    {'code': '+973', 'name': 'Bahrain', 'flag': '🇧🇭'},
    {'code': '+880', 'name': 'Bangladesh', 'flag': '🇧🇩'},
    {'code': '+1', 'name': 'Barbados', 'flag': '🇧🇧'},
    {'code': '+375', 'name': 'Belarus', 'flag': '🇧🇾'},
    {'code': '+32', 'name': 'Belgium', 'flag': '🇧🇪'},
    {'code': '+501', 'name': 'Belize', 'flag': '🇧🇿'},
    {'code': '+229', 'name': 'Benin', 'flag': '🇧🇯'},
    {'code': '+975', 'name': 'Bhutan', 'flag': '🇧🇹'},
    {'code': '+591', 'name': 'Bolivia', 'flag': '🇧🇴'},
    {'code': '+387', 'name': 'Bosnia and Herzegovina', 'flag': '🇧🇦'},
    {'code': '+267', 'name': 'Botswana', 'flag': '🇧🇼'},
    {'code': '+55', 'name': 'Brazil', 'flag': '🇧🇷'},
    {'code': '+673', 'name': 'Brunei', 'flag': '🇧🇳'},
    {'code': '+359', 'name': 'Bulgaria', 'flag': '🇧🇬'},
    {'code': '+226', 'name': 'Burkina Faso', 'flag': '🇧🇫'},
    {'code': '+257', 'name': 'Burundi', 'flag': '🇧🇮'},
    {'code': '+855', 'name': 'Cambodia', 'flag': '🇰🇭'},
    {'code': '+237', 'name': 'Cameroon', 'flag': '🇨🇲'},
    {'code': '+1', 'name': 'Canada', 'flag': '🇨🇦'},
    {'code': '+238', 'name': 'Cape Verde', 'flag': '🇨🇻'},
    {'code': '+236', 'name': 'Central African Republic', 'flag': '🇨🇫'},
    {'code': '+235', 'name': 'Chad', 'flag': '🇹🇩'},
    {'code': '+56', 'name': 'Chile', 'flag': '🇨🇱'},
    {'code': '+86', 'name': 'China', 'flag': '🇨🇳'},
    {'code': '+57', 'name': 'Colombia', 'flag': '🇨🇴'},
    {'code': '+269', 'name': 'Comoros', 'flag': '🇰🇲'},
    {'code': '+242', 'name': 'Congo', 'flag': '🇨🇬'},
    {'code': '+506', 'name': 'Costa Rica', 'flag': '🇨🇷'},
    {'code': '+385', 'name': 'Croatia', 'flag': '🇭🇷'},
    {'code': '+53', 'name': 'Cuba', 'flag': '🇨🇺'},
    {'code': '+357', 'name': 'Cyprus', 'flag': '🇨🇾'},
    {'code': '+420', 'name': 'Czech Republic', 'flag': '🇨🇿'},
    {'code': '+45', 'name': 'Denmark', 'flag': '🇩🇰'},
    {'code': '+253', 'name': 'Djibouti', 'flag': '🇩🇯'},
    {'code': '+1', 'name': 'Dominica', 'flag': '🇩🇲'},
    {'code': '+1', 'name': 'Dominican Republic', 'flag': '🇩🇴'},
    {'code': '+593', 'name': 'Ecuador', 'flag': '🇪🇨'},
    {'code': '+20', 'name': 'Egypt', 'flag': '🇪🇬'},
    {'code': '+503', 'name': 'El Salvador', 'flag': '🇸🇻'},
    {'code': '+240', 'name': 'Equatorial Guinea', 'flag': '🇬🇶'},
    {'code': '+291', 'name': 'Eritrea', 'flag': '🇪🇷'},
    {'code': '+372', 'name': 'Estonia', 'flag': '🇪🇪'},
    {'code': '+251', 'name': 'Ethiopia', 'flag': '🇪🇹'},
    {'code': '+679', 'name': 'Fiji', 'flag': '🇫🇯'},
    {'code': '+358', 'name': 'Finland', 'flag': '🇫🇮'},
    {'code': '+33', 'name': 'France', 'flag': '🇫🇷'},
    {'code': '+241', 'name': 'Gabon', 'flag': '🇬🇦'},
    {'code': '+220', 'name': 'Gambia', 'flag': '🇬🇲'},
    {'code': '+995', 'name': 'Georgia', 'flag': '🇬🇪'},
    {'code': '+49', 'name': 'Germany', 'flag': '🇩🇪'},
    {'code': '+233', 'name': 'Ghana', 'flag': '🇬🇭'},
    {'code': '+30', 'name': 'Greece', 'flag': '🇬🇷'},
    {'code': '+1', 'name': 'Grenada', 'flag': '🇬🇩'},
    {'code': '+502', 'name': 'Guatemala', 'flag': '🇬🇹'},
    {'code': '+224', 'name': 'Guinea', 'flag': '🇬🇳'},
    {'code': '+245', 'name': 'Guinea-Bissau', 'flag': '🇬🇼'},
    {'code': '+592', 'name': 'Guyana', 'flag': '🇬🇾'},
    {'code': '+509', 'name': 'Haiti', 'flag': '🇭🇹'},
    {'code': '+504', 'name': 'Honduras', 'flag': '🇭🇳'},
    {'code': '+852', 'name': 'Hong Kong', 'flag': '🇭🇰'},
    {'code': '+36', 'name': 'Hungary', 'flag': '🇭🇺'},
    {'code': '+354', 'name': 'Iceland', 'flag': '🇮🇸'},
    {'code': '+91', 'name': 'India', 'flag': '🇮🇳'},
    {'code': '+62', 'name': 'Indonesia', 'flag': '🇮🇩'},
    {'code': '+98', 'name': 'Iran', 'flag': '🇮🇷'},
    {'code': '+964', 'name': 'Iraq', 'flag': '🇮🇶'},
    {'code': '+353', 'name': 'Ireland', 'flag': '🇮🇪'},
    {'code': '+972', 'name': 'Israel', 'flag': '🇮🇱'},
    {'code': '+39', 'name': 'Italy', 'flag': '🇮🇹'},
    {'code': '+1', 'name': 'Jamaica', 'flag': '🇯🇲'},
    {'code': '+81', 'name': 'Japan', 'flag': '🇯🇵'},
    {'code': '+962', 'name': 'Jordan', 'flag': '🇯🇴'},
    {'code': '+7', 'name': 'Kazakhstan', 'flag': '🇰🇿'},
    {'code': '+254', 'name': 'Kenya', 'flag': '🇰🇪'},
    {'code': '+686', 'name': 'Kiribati', 'flag': '🇰🇮'},
    {'code': '+965', 'name': 'Kuwait', 'flag': '🇰🇼'},
    {'code': '+996', 'name': 'Kyrgyzstan', 'flag': '🇰🇬'},
    {'code': '+856', 'name': 'Laos', 'flag': '🇱🇦'},
    {'code': '+371', 'name': 'Latvia', 'flag': '🇱🇻'},
    {'code': '+961', 'name': 'Lebanon', 'flag': '🇱🇧'},
    {'code': '+266', 'name': 'Lesotho', 'flag': '🇱🇸'},
    {'code': '+231', 'name': 'Liberia', 'flag': '🇱🇷'},
    {'code': '+218', 'name': 'Libya', 'flag': '🇱🇾'},
    {'code': '+423', 'name': 'Liechtenstein', 'flag': '🇱🇮'},
    {'code': '+370', 'name': 'Lithuania', 'flag': '🇱🇹'},
    {'code': '+352', 'name': 'Luxembourg', 'flag': '🇱🇺'},
    {'code': '+853', 'name': 'Macau', 'flag': '🇲🇴'},
    {'code': '+389', 'name': 'North Macedonia', 'flag': '🇲🇰'},
    {'code': '+261', 'name': 'Madagascar', 'flag': '🇲🇬'},
    {'code': '+265', 'name': 'Malawi', 'flag': '🇲🇼'},
    {'code': '+60', 'name': 'Malaysia', 'flag': '🇲🇾'},
    {'code': '+960', 'name': 'Maldives', 'flag': '🇲🇻'},
    {'code': '+223', 'name': 'Mali', 'flag': '🇲🇱'},
    {'code': '+356', 'name': 'Malta', 'flag': '🇲🇹'},
    {'code': '+692', 'name': 'Marshall Islands', 'flag': '🇲🇭'},
    {'code': '+222', 'name': 'Mauritania', 'flag': '🇲🇷'},
    {'code': '+230', 'name': 'Mauritius', 'flag': '🇲🇺'},
    {'code': '+52', 'name': 'Mexico', 'flag': '🇲🇽'},
    {'code': '+691', 'name': 'Micronesia', 'flag': '🇫🇲'},
    {'code': '+373', 'name': 'Moldova', 'flag': '🇲🇩'},
    {'code': '+377', 'name': 'Monaco', 'flag': '🇲🇨'},
    {'code': '+976', 'name': 'Mongolia', 'flag': '🇲🇳'},
    {'code': '+382', 'name': 'Montenegro', 'flag': '🇲🇪'},
    {'code': '+212', 'name': 'Morocco', 'flag': '🇲🇦'},
    {'code': '+258', 'name': 'Mozambique', 'flag': '🇲🇿'},
    {'code': '+95', 'name': 'Myanmar', 'flag': '🇲🇲'},
    {'code': '+264', 'name': 'Namibia', 'flag': '🇳🇦'},
    {'code': '+674', 'name': 'Nauru', 'flag': '🇳🇷'},
    {'code': '+977', 'name': 'Nepal', 'flag': '🇳🇵'},
    {'code': '+31', 'name': 'Netherlands', 'flag': '🇳🇱'},
    {'code': '+64', 'name': 'New Zealand', 'flag': '🇳🇿'},
    {'code': '+505', 'name': 'Nicaragua', 'flag': '🇳🇮'},
    {'code': '+227', 'name': 'Niger', 'flag': '🇳🇪'},
    {'code': '+234', 'name': 'Nigeria', 'flag': '🇳🇬'},
    {'code': '+850', 'name': 'North Korea', 'flag': '🇰🇵'},
    {'code': '+47', 'name': 'Norway', 'flag': '🇳🇴'},
    {'code': '+968', 'name': 'Oman', 'flag': '🇴🇲'},
    {'code': '+92', 'name': 'Pakistan', 'flag': '🇵🇰'},
    {'code': '+680', 'name': 'Palau', 'flag': '🇵🇼'},
    {'code': '+970', 'name': 'Palestine', 'flag': '🇵🇸'},
    {'code': '+507', 'name': 'Panama', 'flag': '🇵🇦'},
    {'code': '+675', 'name': 'Papua New Guinea', 'flag': '🇵🇬'},
    {'code': '+595', 'name': 'Paraguay', 'flag': '🇵🇾'},
    {'code': '+51', 'name': 'Peru', 'flag': '🇵🇪'},
    {'code': '+63', 'name': 'Philippines', 'flag': '🇵🇭'},
    {'code': '+48', 'name': 'Poland', 'flag': '🇵🇱'},
    {'code': '+351', 'name': 'Portugal', 'flag': '🇵🇹'},
    {'code': '+974', 'name': 'Qatar', 'flag': '🇶🇦'},
    {'code': '+40', 'name': 'Romania', 'flag': '🇷🇴'},
    {'code': '+7', 'name': 'Russia', 'flag': '🇷🇺'},
    {'code': '+250', 'name': 'Rwanda', 'flag': '🇷🇼'},
    {'code': '+1', 'name': 'Saint Kitts and Nevis', 'flag': '🇰🇳'},
    {'code': '+1', 'name': 'Saint Lucia', 'flag': '🇱🇨'},
    {'code': '+1', 'name': 'Saint Vincent', 'flag': '🇻🇨'},
    {'code': '+685', 'name': 'Samoa', 'flag': '🇼🇸'},
    {'code': '+378', 'name': 'San Marino', 'flag': '🇸🇲'},
    {'code': '+239', 'name': 'Sao Tome and Principe', 'flag': '🇸🇹'},
    {'code': '+966', 'name': 'Saudi Arabia', 'flag': '🇸🇦'},
    {'code': '+221', 'name': 'Senegal', 'flag': '🇸🇳'},
    {'code': '+381', 'name': 'Serbia', 'flag': '🇷🇸'},
    {'code': '+248', 'name': 'Seychelles', 'flag': '🇸🇨'},
    {'code': '+232', 'name': 'Sierra Leone', 'flag': '🇸🇱'},
    {'code': '+65', 'name': 'Singapore', 'flag': '🇸🇬'},
    {'code': '+421', 'name': 'Slovakia', 'flag': '🇸🇰'},
    {'code': '+386', 'name': 'Slovenia', 'flag': '🇸🇮'},
    {'code': '+677', 'name': 'Solomon Islands', 'flag': '🇸🇧'},
    {'code': '+252', 'name': 'Somalia', 'flag': '🇸🇴'},
    {'code': '+27', 'name': 'South Africa', 'flag': '🇿🇦'},
    {'code': '+82', 'name': 'South Korea', 'flag': '🇰🇷'},
    {'code': '+211', 'name': 'South Sudan', 'flag': '🇸🇸'},
    {'code': '+34', 'name': 'Spain', 'flag': '🇪🇸'},
    {'code': '+94', 'name': 'Sri Lanka', 'flag': '🇱🇰'},
    {'code': '+249', 'name': 'Sudan', 'flag': '🇸🇩'},
    {'code': '+597', 'name': 'Suriname', 'flag': '🇸🇷'},
    {'code': '+268', 'name': 'Swaziland', 'flag': '🇸🇿'},
    {'code': '+46', 'name': 'Sweden', 'flag': '🇸🇪'},
    {'code': '+41', 'name': 'Switzerland', 'flag': '🇨🇭'},
    {'code': '+963', 'name': 'Syria', 'flag': '🇸🇾'},
    {'code': '+886', 'name': 'Taiwan', 'flag': '🇹🇼'},
    {'code': '+992', 'name': 'Tajikistan', 'flag': '🇹🇯'},
    {'code': '+255', 'name': 'Tanzania', 'flag': '🇹🇿'},
    {'code': '+66', 'name': 'Thailand', 'flag': '🇹🇭'},
    {'code': '+228', 'name': 'Togo', 'flag': '🇹🇬'},
    {'code': '+676', 'name': 'Tonga', 'flag': '🇹🇴'},
    {'code': '+1', 'name': 'Trinidad and Tobago', 'flag': '🇹🇹'},
    {'code': '+216', 'name': 'Tunisia', 'flag': '🇹🇳'},
    {'code': '+90', 'name': 'Turkey', 'flag': '🇹🇷'},
    {'code': '+993', 'name': 'Turkmenistan', 'flag': '🇹🇲'},
    {'code': '+1', 'name': 'Tuvalu', 'flag': '🇹🇻'},
    {'code': '+256', 'name': 'Uganda', 'flag': '🇺🇬'},
    {'code': '+380', 'name': 'Ukraine', 'flag': '🇺🇦'},
    {'code': '+971', 'name': 'United Arab Emirates', 'flag': '🇦🇪'},
    {'code': '+44', 'name': 'United Kingdom', 'flag': '🇬🇧'},
    {'code': '+1', 'name': 'United States', 'flag': '🇺🇸'},
    {'code': '+598', 'name': 'Uruguay', 'flag': '🇺🇾'},
    {'code': '+998', 'name': 'Uzbekistan', 'flag': '🇺🇿'},
    {'code': '+678', 'name': 'Vanuatu', 'flag': '🇻🇺'},
    {'code': '+379', 'name': 'Vatican City', 'flag': '🇻🇦'},
    {'code': '+58', 'name': 'Venezuela', 'flag': '🇻🇪'},
    {'code': '+84', 'name': 'Vietnam', 'flag': '🇻🇳'},
    {'code': '+967', 'name': 'Yemen', 'flag': '🇾🇪'},
    {'code': '+260', 'name': 'Zambia', 'flag': '🇿🇲'},
    {'code': '+263', 'name': 'Zimbabwe', 'flag': '🇿🇼'},
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5), // Light grey background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                const Text(
                  'Let\'s Get Started!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Subtitle
                const Text(
                  'Create an account to get all features',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),

                // First Name input field
                _buildInputField(
                  controller: _firstNameController,
                  hintText: 'First Name',
                  icon: Icons.person_outline,
                  obscureText: false,
                ),
                const SizedBox(height: 16),

                // Last Name input field
                _buildInputField(
                  controller: _lastNameController,
                  hintText: 'Last Name',
                  icon: Icons.person_outline,
                  obscureText: false,
                ),
                const SizedBox(height: 16),

                // User Name input field
                _buildInputField(
                  controller: _userNameController,
                  hintText: 'User Name',
                  icon: Icons.person_outline,
                  obscureText: false,
                ),
                const SizedBox(height: 16),

                // Email input field
                _buildInputField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                  obscureText: false,
                ),
                const SizedBox(height: 16),

                // Phone number input field with country code
                _buildPhoneInputField(),
                const SizedBox(height: 16),

                // Password input field
                _buildInputField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm Password input field
                _buildInputField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  icon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30),

                // CREATE Button
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF4A90E2), // Lighter blue
                        Color(0xFF357ABD), // Darker blue
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isLoading ? null : _handleSignup,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'CREATE',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Footer - Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login here',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Light grey background
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.black,
            size: 20,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInputField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Light grey background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Country code dropdown
          GestureDetector(
            onTap: () => _showCountryCodePicker(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _countryCodes.firstWhere(
                      (country) => country['code'] == _selectedCountryCode,
                      orElse: () => _countryCodes[0],
                    )['flag']!,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _selectedCountryCode,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          // Phone number input
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Phone Number',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: Colors.black,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCountryCodePicker() {
    final TextEditingController searchController = TextEditingController();
    List<Map<String, String>> filteredCountries = List.from(_countryCodes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  const Text(
                    'Select Country Code',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Search field
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search country...',
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          if (value.isEmpty) {
                            filteredCountries = List.from(_countryCodes);
                          } else {
                            filteredCountries = _countryCodes
                                .where((country) =>
                                    country['name']!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    country['code']!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                .toList();
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Country list
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = filteredCountries[index];
                        final isSelected = country['code'] == _selectedCountryCode;
                        return ListTile(
                          leading: Text(
                            country['flag']!,
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(
                            country['name']!,
                            style: TextStyle(
                              fontWeight:
                                  isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            country['code']!,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: Color(0xFF4A90E2))
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedCountryCode = country['code']!;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool _validateFields() {
    if (_firstNameController.text.isEmpty) {
      _showError('Please enter your first name');
      return false;
    }
    if (_lastNameController.text.isEmpty) {
      _showError('Please enter your last name');
      return false;
    }
    if (_userNameController.text.isEmpty) {
      _showError('Please enter a username');
      return false;
    }
    if (_emailController.text.isEmpty) {
      _showError('Please enter your email');
      return false;
    }
    if (!_isValidEmail(_emailController.text)) {
      _showError('Please enter a valid email address');
      return false;
    }
    if (_phoneController.text.isEmpty) {
      _showError('Please enter your phone number');
      return false;
    }
    if (!_isValidPhoneNumber(_phoneController.text)) {
      _showError('Please enter a valid phone number');
      return false;
    }
    if (_passwordController.text.isEmpty) {
      _showError('Please enter a password');
      return false;
    }
    if (_passwordController.text.length < 6) {
      _showError('Password must be at least 6 characters');
      return false;
    }
    if (_confirmPasswordController.text.isEmpty) {
      _showError('Please confirm your password');
      return false;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match');
      return false;
    }
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhoneNumber(String phone) {
    // Remove any non-digit characters for validation
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');
    // Check if phone number has at least 7 digits (minimum valid phone number length)
    return digitsOnly.length >= 7 && digitsOnly.length <= 15;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleSignup() async {
    if (!_validateFields()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.register(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        userName: _userNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        countryCode: _selectedCountryCode,
        password: _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        // Navigate back to login page after successful signup
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        });
      } else {
        _showError(result['message'] ?? 'Signup failed');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Error: ${e.toString()}');
    }
  }
}

