import 'package:flutter/material.dart';

import '../models/hostel_models.dart';
import '../services/hostel_repository.dart';
import 'admin_shell.dart';
import 'student_shell.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'student@hms.com');
  final _passwordController = TextEditingController(text: 'pass123');
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController();
  final _semesterController = TextEditingController(text: '4');
  final _studentIdController = TextEditingController();

  bool _obscurePassword = true;
  bool _registerMode = false;
  bool _busy = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _semesterController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() {
      _busy = true;
      _errorMessage = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 500));

    final user = HostelRepository.instance.authenticate(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    if (user == null) {
      setState(() {
        _busy = false;
        _errorMessage = 'Invalid email or password. Try student@hms.com or admin@hms.com.';
      });
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => user.role == UserRole.admin ? const AdminShell() : StudentShell(user: user),
      ),
    );
  }

  Future<void> _submitRegister() async {
    if (!(_registerFormKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _busy = true;
      _errorMessage = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 600));

    final user = HostelRepository.instance.registerStudent(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      phone: _phoneController.text,
      department: _departmentController.text,
      semester: int.tryParse(_semesterController.text) ?? 1,
      studentId: _studentIdController.text,
    );

    if (!mounted) return;
    if (user == null) {
      setState(() {
        _busy = false;
        _errorMessage = 'This email is already registered.';
      });
      return;
    }

    setState(() {
      _busy = false;
      _registerMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful. Please sign in.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: const Color(0xFF0E3A4D),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Icon(Icons.house_rounded, size: 46, color: Colors.white),
              ),
              const SizedBox(height: 18),
              const Text(
                'Blue Crest Hostel',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF10364A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Smart hostel management for students and staff',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Color(0xFF58707F)),
              ),
              const SizedBox(height: 28),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(value: false, label: Text('Login')),
                          ButtonSegment(value: true, label: Text('Register')),
                        ],
                        selected: {_registerMode},
                        onSelectionChanged: (value) {
                          setState(() {
                            _registerMode = value.first;
                            _errorMessage = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_errorMessage != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFEDB5B5)),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Color(0xFFB22121)),
                          ),
                        ),
                      const SizedBox(height: 12),
                      if (!_registerMode) _buildLoginForm() else _buildRegisterForm(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Demo access: student@hms.com / pass123 or admin@hms.com / admin123',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7B87)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => (value == null || value.isEmpty) ? 'Enter your email' : null,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: (value) => (value == null || value.isEmpty) ? 'Enter your password' : null,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: _busy ? null : _submitLogin,
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.login_rounded),
              label: Text(_busy ? 'Signing in...' : 'Sign in'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            validator: (value) => (value == null || value.isEmpty) ? 'Enter full name' : null,
            decoration: const InputDecoration(
              labelText: 'Full name',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _studentIdController,
            validator: (value) => (value == null || value.isEmpty) ? 'Enter student ID' : null,
            decoration: const InputDecoration(
              labelText: 'Student ID',
              prefixIcon: Icon(Icons.badge_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _departmentController,
            validator: (value) => (value == null || value.isEmpty) ? 'Enter department' : null,
            decoration: const InputDecoration(
              labelText: 'Department',
              prefixIcon: Icon(Icons.school_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _semesterController,
            keyboardType: TextInputType.number,
            validator: (value) => (value == null || value.isEmpty) ? 'Enter semester' : null,
            decoration: const InputDecoration(
              labelText: 'Semester',
              prefixIcon: Icon(Icons.numbers_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) => (value == null || value.isEmpty) ? 'Enter phone number' : null,
            decoration: const InputDecoration(
              labelText: 'Phone number',
              prefixIcon: Icon(Icons.phone_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => (value == null || value.isEmpty) ? 'Enter email' : null,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: (value) => (value == null || value.length < 6) ? 'Use at least 6 characters' : null,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: _busy ? null : _submitRegister,
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: Text(_busy ? 'Creating account...' : 'Create account'),
            ),
          ),
        ],
      ),
    );
  }
}
