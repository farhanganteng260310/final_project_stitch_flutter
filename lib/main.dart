import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

const _primary = Color(0xFF006B5F);
const _primaryContainer = Color(0xFF00A896);
const _surface = Color(0xFFFAF8FF);
const _surfaceLow = Color(0xFFF2F3FF);
const _ink = Color(0xFF131B2E);
const _muted = Color(0xFF3C4946);

void main() => runApp(const NusanetApp());

class NusanetApp extends StatefulWidget {
  const NusanetApp({super.key});

  @override
  State<NusanetApp> createState() => _NusanetAppState();
}

class _NusanetAppState extends State<NusanetApp> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nusanet',
      debugShowCheckedModeBanner: false,
      themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Plus Jakarta Sans',
        scaffoldBackgroundColor: _surface,
        colorScheme: ColorScheme.fromSeed(seedColor: _primary).copyWith(
          primary: _primary,
          secondary: const Color(0xFF006876),
          surface: _surface,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Plus Jakarta Sans',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryContainer,
          brightness: Brightness.dark,
        ),
      ),
      home: LoginPage(onToggleTheme: () => setState(() => _dark = !_dark)),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onToggleTheme});
  final VoidCallback onToggleTheme;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  final _password = TextEditingController();
  bool _usePassword = false;
  bool _remember = true;
  bool _showPassword = false;
  bool _busy = false;
  int _otpSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _phone.dispose();
    _otp.dispose();
    _password.dispose();
    super.dispose();
  }

  void _toast(String message, {IconData icon = Icons.check_circle}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF283044),
          content: Row(
            children: [
              Icon(icon, color: const Color(0xFF79F7E3)),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }

  void _sendOtp() {
    if (_phone.text.trim().isEmpty) {
      _toast('Masukkan nomor HP terlebih dahulu', icon: Icons.error_outline);
      return;
    }
    setState(() => _otpSeconds = 59);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpSeconds <= 1) {
        timer.cancel();
        setState(() => _otpSeconds = 0);
      } else {
        setState(() => _otpSeconds--);
      }
    });
    _toast('Kode OTP terkirim ke WhatsApp / SMS!', icon: Icons.sms_outlined);
  }

  Future<void> _login() async {
    if (_phone.text.trim().isEmpty) {
      _toast('Mohon masukkan nomor handphone Anda', icon: Icons.error_outline);
      return;
    }
    if (_usePassword && _password.text.isEmpty) {
      _toast('Masukkan password akun Anda', icon: Icons.error_outline);
      return;
    }
    if (!_usePassword && _otp.text.isEmpty) {
      _toast('Masukkan kode OTP terlebih dahulu', icon: Icons.error_outline);
      return;
    }
    setState(() => _busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _busy = false);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => HomePage(onToggleTheme: widget.onToggleTheme),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? const Color(0xFF20283A) : Colors.white;
    final field = isDark ? const Color(0xFF293246) : _surfaceLow;
    final ink = isDark ? Colors.white : _ink;
    final muted = isDark ? Colors.white70 : _muted;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: _primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cell_tower,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Nusanet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ink,
                      ),
                    ),
                    const Spacer(),
                    IconButton.filledTonal(
                      onPressed: widget.onToggleTheme,
                      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                      tooltip: 'Toggle dark mode',
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              colors: [
                                _primaryContainer,
                                _primary,
                                Color(0xFF006876),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _primaryContainer.withValues(alpha: .22),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.cell_tower,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Masuk ke Nusanet',
                          style: TextStyle(
                            fontSize: 24,
                            height: 1.3,
                            fontWeight: FontWeight.w700,
                            color: ink,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Masuk untuk kelola kuotamu',
                          style: TextStyle(fontSize: 14, color: muted),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .04),
                                blurRadius: 18,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: field,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    _tab(
                                      'Nomor HP & OTP',
                                      Icons.sms_outlined,
                                      !_usePassword,
                                      () =>
                                          setState(() => _usePassword = false),
                                    ),
                                    _tab(
                                      'Password',
                                      Icons.key_outlined,
                                      _usePassword,
                                      () => setState(() => _usePassword = true),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              _label('Nomor Handphone', ink),
                              const SizedBox(height: 7),
                              _inputBox(
                                field,
                                children: [
                                  const Text(
                                    'ID',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '+62',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ink,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 1,
                                    height: 22,
                                    color: muted.withValues(alpha: .25),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: _phone,
                                      keyboardType: TextInputType.phone,
                                      style: TextStyle(
                                        color: ink,
                                        fontSize: 16,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '812-3456-7890',
                                        hintStyle: TextStyle(
                                          color: muted.withValues(alpha: .45),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                  if (_phone.text.isNotEmpty)
                                    IconButton(
                                      onPressed: () => setState(_phone.clear),
                                      icon: const Icon(Icons.close, size: 18),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              if (!_usePassword) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _label('Kode OTP', ink),
                                    TextButton(
                                      onPressed: _otpSeconds == 0
                                          ? _sendOtp
                                          : null,
                                      child: Text(
                                        _otpSeconds == 0
                                            ? 'Kirim OTP'
                                            : 'Kirim Ulang',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                _inputBox(
                                  field,
                                  children: [
                                    Icon(
                                      Icons.lock_open,
                                      color: muted,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextField(
                                        controller: _otp,
                                        keyboardType: TextInputType.number,
                                        maxLength: 6,
                                        style: TextStyle(
                                          color: ink,
                                          letterSpacing: 3,
                                        ),
                                        decoration: InputDecoration(
                                          counterText: '',
                                          border: InputBorder.none,
                                          hintText: '6 digit kode verifikasi',
                                          hintStyle: TextStyle(
                                            color: muted.withValues(alpha: .45),
                                            letterSpacing: 0,
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                    if (_otpSeconds > 0)
                                      _pill('${_otpSeconds}s'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.verified_user,
                                      color: _primary,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Kode OTP akan dikirim via SMS atau WhatsApp',
                                        style: TextStyle(
                                          color: muted.withValues(alpha: .8),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _label('Password', ink),
                                    TextButton(
                                      onPressed: () => _toast(
                                        'Instruksi pemulihan kata sandi telah disiapkan!',
                                        icon: Icons.info_outline,
                                      ),
                                      child: const Text(
                                        'Lupa Password?',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                _inputBox(
                                  field,
                                  children: [
                                    Icon(
                                      Icons.lock_outline,
                                      color: muted,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextField(
                                        controller: _password,
                                        obscureText: !_showPassword,
                                        style: TextStyle(color: ink),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Masukkan password akun',
                                          hintStyle: TextStyle(
                                            color: muted.withValues(alpha: .45),
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => setState(
                                        () => _showPassword = !_showPassword,
                                      ),
                                      icon: Icon(
                                        _showPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 20,
                                      ),
                                      color: muted,
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: Checkbox(
                                      value: _remember,
                                      activeColor: _primaryContainer,
                                      onChanged: (value) => setState(
                                        () => _remember = value ?? false,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Ingat Saya',
                                    style: TextStyle(color: ink, fontSize: 14),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Privasi Aman',
                                    style: TextStyle(
                                      color: muted.withValues(alpha: .65),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                height: 48,
                                child: FilledButton(
                                  onPressed: _busy ? null : _login,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: _primaryContainer,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: _busy
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Masuk',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(Icons.arrow_forward, size: 20),
                                          ],
                                        ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: muted.withValues(alpha: .18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'ATAU MASUK DENGAN',
                                      style: TextStyle(
                                        color: muted.withValues(alpha: .7),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: muted.withValues(alpha: .18),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _socialButton(
                                      'Google',
                                      const Icon(
                                        Icons.g_mobiledata,
                                        size: 24,
                                        color: Color(0xFF4285F4),
                                      ),
                                      () => _quickAuth('Google'),
                                      field,
                                      ink,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _socialButton(
                                      'Biometrik',
                                      const Icon(
                                        Icons.fingerprint,
                                        size: 21,
                                        color: _primary,
                                      ),
                                      () => _quickAuth('Biometrik'),
                                      field,
                                      ink,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              'Belum punya akun? ',
                              style: TextStyle(color: muted, fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => RegisterPage(
                                    onToggleTheme: widget.onToggleTheme,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Daftar di sini',
                                style: TextStyle(
                                  color: _primaryContainer,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String title, IconData icon, bool selected, VoidCallback onTap) =>
      Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: selected ? _primaryContainer : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              boxShadow: selected
                  ? [
                      const BoxShadow(
                        color: Color(0x18000000),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: selected ? Colors.white : _muted),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : _muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _label(String text, Color color) => Text(
    text,
    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
  );

  Widget _inputBox(Color color, {required List<Widget> children}) => Container(
    height: 52,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(children: children),
  );

  Widget _pill(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: _primary.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: _primary,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  Widget _socialButton(
    String label,
    Widget icon,
    VoidCallback onTap,
    Color background,
    Color foreground,
  ) => SizedBox(
    height: 48,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: background,
        side: BorderSide.none,
        foregroundColor: foreground,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );

  void _quickAuth(String provider) {
    _toast('Menghubungkan ke otentikasi $provider...', icon: Icons.sync);
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (mounted)
        _toast('Verifikasi $provider berhasil!', icon: Icons.verified);
    });
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _showPassword = false;
  bool _acceptedTerms = false;
  bool _loading = false;
  bool _showBonus = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  int get _strength {
    final value = _password.text;
    if (value.isEmpty) return 0;
    if (value.length < 6) return 1;
    if (value.length < 8) return 2;
    if (value.length < 10) return 3;
    return 4;
  }

  String get _strengthLabel => switch (_strength) {
    0 => 'Min. 8 karakter',
    1 => 'Terlalu Lemah',
    2 => 'Cukup',
    3 => 'Kuat',
    _ => 'Sangat Kuat',
  };

  Color get _strengthColor => switch (_strength) {
    1 => const Color(0xFFBA1A1A),
    2 => const Color(0xFFD08446),
    _ => _primaryContainer,
  };

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Setujui syarat dan ketentuan untuk melanjutkan.'),
        ),
      );
      return;
    }
    setState(() => _loading = true);
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted)
        setState(() {
          _loading = false;
          _showBonus = true;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? Colors.white : _ink;
    final muted = dark ? Colors.white70 : _muted;
    final field = dark ? const Color(0xFF293246) : Colors.white;
    final soft = dark ? const Color(0xFF293246) : _surfaceLow;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: _primary,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: soft,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .035),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 21,
                                        height: 21,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: _primaryContainer,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Text(
                                          '5G',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      const Text(
                                        'AKTIVASI INSTAN',
                                        style: TextStyle(
                                          color: _primary,
                                          fontSize: 10,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Buat akun baru untuk nikmati jaringan 5G tercepat dan bonus kuota',
                                    style: TextStyle(
                                      color: muted,
                                      fontSize: 12,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: _primary.withValues(alpha: .1),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.card_giftcard,
                                    color: _primary,
                                    size: 25,
                                  ),
                                  Text(
                                    '+1 GB',
                                    style: TextStyle(
                                      color: _primary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _registerLabel('Nama Lengkap', ink),
                            const SizedBox(height: 7),
                            _registerField(
                              controller: _name,
                              hint: 'Farhan Pratama',
                              icon: Icons.person_outline,
                              background: field,
                              color: ink,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Nama lengkap wajib diisi'
                                  : null,
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _registerLabel('Nomor Handphone', ink),
                                Text(
                                  'Verifikasi SMS',
                                  style: TextStyle(
                                    color: muted,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: field,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: .035),
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 52,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: soft,
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                            left: Radius.circular(30),
                                          ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text('ID'),
                                        const SizedBox(width: 7),
                                        Text(
                                          '+62',
                                          style: TextStyle(
                                            color: muted,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 24,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    color: Colors.black12,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _phone,
                                      keyboardType: TextInputType.phone,
                                      style: TextStyle(
                                        color: ink,
                                        fontSize: 14,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '812-3456-7890',
                                        hintStyle: TextStyle(
                                          color: muted.withValues(alpha: .55),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                        isDense: true,
                                      ),
                                      validator: (v) =>
                                          v == null || v.trim().length < 8
                                          ? 'Masukkan nomor handphone yang valid'
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, top: 6),
                              child: Text(
                                'Pastikan nomor aktif untuk verifikasi',
                                style: TextStyle(color: muted, fontSize: 10),
                              ),
                            ),
                            const SizedBox(height: 14),
                            _registerLabel('Email', ink),
                            const SizedBox(height: 7),
                            _registerField(
                              controller: _email,
                              hint: 'farhan@email.com',
                              icon: Icons.mail_outline,
                              background: field,
                              color: ink,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) =>
                                  v == null ||
                                      !RegExp(
                                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                      ).hasMatch(v.trim())
                                  ? 'Masukkan alamat email yang valid'
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _registerLabel('Kata Sandi', ink),
                                Text(
                                  _strengthLabel,
                                  style: TextStyle(
                                    color: _strengthColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            _registerField(
                              controller: _password,
                              hint: 'Masukkan kata sandi',
                              icon: Icons.lock_outline,
                              background: field,
                              color: ink,
                              obscure: !_showPassword,
                              validator: (v) => v == null || v.length < 8
                                  ? 'Kata sandi minimal 8 karakter'
                                  : null,
                              suffix: IconButton(
                                onPressed: () => setState(
                                  () => _showPassword = !_showPassword,
                                ),
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 20,
                                  color: muted,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                              child: Row(
                                children: List.generate(
                                  4,
                                  (i) => Expanded(
                                    child: Container(
                                      height: 4,
                                      margin: EdgeInsets.only(
                                        right: i == 3 ? 0 : 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: i < _strength
                                            ? _strengthColor
                                            : (dark
                                                  ? Colors.white12
                                                  : const Color(0xFFDAE2FD)),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 17),
                            InkWell(
                              onTap: () => setState(
                                () => _acceptedTerms = !_acceptedTerms,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 22,
                                    child: Checkbox(
                                      value: _acceptedTerms,
                                      onChanged: (v) => setState(
                                        () => _acceptedTerms = v ?? false,
                                      ),
                                      activeColor: _primary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(
                                          color: muted,
                                          fontSize: 12,
                                          height: 1.45,
                                        ),
                                        children: const [
                                          TextSpan(text: 'Saya menyetujui '),
                                          TextSpan(
                                            text: 'Syarat & Ketentuan',
                                            style: TextStyle(
                                              color: _primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(text: ' serta '),
                                          TextSpan(
                                            text: 'Kebijakan Privasi',
                                            style: TextStyle(
                                              color: _primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(text: ' Nusanet.'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 48,
                              child: FilledButton(
                                onPressed: _loading ? null : _submit,
                                style: FilledButton.styleFrom(
                                  backgroundColor: _primaryContainer,
                                  foregroundColor: Colors.white,
                                ),
                                child: _loading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Daftar Sekarang',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(Icons.arrow_forward, size: 20),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              'Sudah punya akun? ',
                              style: TextStyle(color: muted, fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.maybePop(context),
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                  color: _primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_showBonus) _bonusDialog(),
          ],
        ),
      ),
    );
  }

  Widget _bonusDialog() {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? Colors.white : _ink;
    final muted = dark ? Colors.white70 : _muted;
    return Positioned.fill(
      child: Material(
        color: const Color(0x80283044),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: dark ? const Color(0xFF20283A) : Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 30),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFF79F7E3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.card_membership,
                      color: Color(0xFF00201C),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SELAMAT DATANG DI NUSANET',
                    style: TextStyle(
                      color: _primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Akun Berhasil Dibuat!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bonus +1 GB Kuota Selamat Datang telah ditambahkan ke nomor aktif Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 12, height: 1.5),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: dark ? const Color(0xFF293246) : _surfaceLow,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: _primaryContainer,
                          child: Icon(Icons.bolt, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '5G Starter Quota',
                                style: TextStyle(
                                  color: ink,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Masa aktif 30 hari',
                                style: TextStyle(color: muted, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          '1 GB',
                          style: TextStyle(
                            color: _primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) =>
                                HomePage(onToggleTheme: widget.onToggleTheme),
                          ),
                          (route) => route.isFirst,
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: _primaryContainer,
                        foregroundColor: Colors.white,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Masuk ke Beranda',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.home, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerLabel(String text, Color color) => Text(
    text,
    style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
  );

  Widget _registerField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color background,
    required Color color,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool obscure = false,
    Widget? suffix,
  }) => Container(
    height: 52,
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: .035), blurRadius: 7),
      ],
    ),
    child: TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      obscureText: obscure,
      onChanged: (_) {
        if (controller == _password) setState(() {});
      },
      style: TextStyle(color: color, fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF6C7A76)),
        prefixIconConstraints: const BoxConstraints(minWidth: 46),
        suffixIcon: suffix,
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9AA6A2), fontSize: 14),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        errorStyle: const TextStyle(height: 0, fontSize: 0),
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onToggleTheme});

  final VoidCallback? onToggleTheme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _dark = false;
  bool _claimed = false;
  int _selectedTab = 0;
  int _pulseBalance = 25000;
  double _quotaBalance = 18.5;
  double _quotaTotal = 30;
  String _fullName = 'Farhan Aimar';
  String _email = 'farhan.aimar@gmail.com';
  String _emergencyPhone = '813-9876-5432';
  int _avatarIndex = 0;
  String? _profileImagePath;
  final _voucher = TextEditingController();

  String _rupiah(int value) =>
      'Rp ${value.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.')}';

  void _completePurchase(_DataPackage package, bool usePulse) {
    setState(() {
      if (usePulse) _pulseBalance -= package.priceValue;
      _quotaBalance += package.quotaGb;
      _quotaTotal += package.quotaGb;
      _selectedTab = 0;
    });
  }

  @override
  void dispose() {
    _voucher.dispose();
    super.dispose();
  }

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
  );

  Future<void> _pickProfilePhoto() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null || !mounted) return;
    setState(() => _profileImagePath = image.path);
  }

  @override
  Widget build(BuildContext context) {
    final bg = _dark ? const Color(0xFF121212) : _surface;
    final card = _dark ? const Color(0xFF1E1E1E) : Colors.white;
    final soft = _dark ? const Color(0xFF282828) : _surfaceLow;
    final ink = _dark ? const Color(0xFFF4F4F4) : _ink;
    final muted = _dark ? Colors.white60 : _muted;
    return Theme(
      data: _dark
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 16,
          title: Row(
            children: [
              const Icon(Icons.cell_tower, color: _primary, size: 26),
              const SizedBox(width: 7),
              Text(
                'Nusanet',
                style: TextStyle(
                  color: ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: _notifications,
              icon: Icon(Icons.notifications_none, color: muted),
              tooltip: 'Notifikasi',
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: _primary,
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
        body: SafeArea(
          bottom: false,
          child: _selectedTab == 0
              ? _homeContent(bg, card, soft, ink, muted)
              : _selectedTab == 1
              ? PackagesPage(
                  dark: _dark,
                  pulseBalance: _pulseBalance,
                  onPurchase: _completePurchase,
                )
              : _selectedTab == 2
              ? PromoPage(dark: _dark)
              : ProfilePage(
                  dark: _dark,
                  fullName: _fullName,
                  email: _email,
                  emergencyPhone: _emergencyPhone,
                  avatarIndex: _avatarIndex,
                  profileImagePath: _profileImagePath,
                  onPickPhoto: _pickProfilePhoto,
                  onToggleTheme: () => setState(() => _dark = !_dark),
                  onSaveProfile: (name, email, emergency, avatar) =>
                      setState(() {
                        _fullName = name;
                        _email = email;
                        _emergencyPhone = emergency;
                        _avatarIndex = avatar;
                      }),
                  onLogout: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => LoginPage(
                        onToggleTheme: widget.onToggleTheme ?? () {},
                      ),
                    ),
                    (route) => false,
                  ),
                ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedTab,
          backgroundColor: card,
          indicatorColor: _primaryContainer.withValues(alpha: .14),
          onDestinationSelected: (index) =>
              setState(() => _selectedTab = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              label: 'Packages',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_offer_outlined),
              label: 'Promo',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeContent(
    Color bg,
    Color card,
    Color soft,
    Color ink,
    Color muted,
  ) => ListView(
    padding: const EdgeInsets.only(bottom: 24),
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, Farhan',
                    style: TextStyle(
                      color: ink,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _dark
                          ? const Color(0xFF262626)
                          : const Color(0xFFE2E7FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.signal_cellular_alt,
                          size: 14,
                          color: _primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '0812-3456-7890',
                          style: TextStyle(
                            color: ink,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: () => setState(() => _dark = !_dark),
              icon: Icon(_dark ? Icons.light_mode : Icons.dark_mode, size: 19),
            ),
            const SizedBox(width: 6),
            _notificationIcon(),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _primaryContainer.withValues(alpha: .10),
                blurRadius: 22,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          color: _primary,
                          size: 17,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'PULSA',
                          style: TextStyle(
                            color: muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _rupiah(_pulseBalance),
                      style: TextStyle(
                        color: ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Active till 28 Feb 2025',
                      style: TextStyle(color: muted, fontSize: 10),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 38,
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TopUpPage(
                              dark: _dark,
                              currentBalance: _pulseBalance,
                              onTopUpSuccess: (amount) =>
                                  setState(() => _pulseBalance += amount),
                            ),
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: _primary,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 17),
                            SizedBox(width: 3),
                            Text(
                              'Top Up',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 13),
                color: _dark ? Colors.white12 : const Color(0xFFEAEDFF),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.wifi_tethering,
                          color: Color(0xFF006876),
                          size: 17,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'INTERNET',
                            style: TextStyle(
                              color: muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Text(
                          '${(_quotaBalance / _quotaTotal * 100).round()}%',
                          style: const TextStyle(
                            color: _primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        children: [
                          TextSpan(
                            text: '${_quotaBalance.toStringAsFixed(1)} ',
                          ),
                          TextSpan(
                            text: '/ ${_quotaTotal.toStringAsFixed(0)} GB',
                            style: TextStyle(
                              color: muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (_quotaBalance / _quotaTotal).clamp(0, 1),
                        minHeight: 8,
                        backgroundColor: const Color(0xFFDAE2FD),
                        color: _primary,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 38,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QuotaDetailsPage(
                              dark: _dark,
                              remaining: _quotaBalance,
                              total: _quotaTotal,
                              addedQuota: _quotaTotal - 30,
                              onViewPackages: () {
                                Navigator.of(context).pop();
                                setState(() => _selectedTab = 1);
                              },
                            ),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: soft,
                          side: BorderSide.none,
                          foregroundColor: _primary,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Details',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(Icons.chevron_right, size: 17),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: _quickAction(
                card,
                ink,
                muted,
                Icons.bolt,
                'Buy Quota',
                'Extra Fast',
                _primary,
                () => _message('Pilih paket kuota yang kamu mau'),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _quickAction(
                card,
                ink,
                muted,
                Icons.event_available,
                _claimed ? 'Claimed' : 'Check-in',
                _claimed ? 'Come tomorrow' : 'Claim Gift',
                const Color(0xFFD08446),
                _checkin,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _quickAction(
                card,
                ink,
                muted,
                Icons.confirmation_number,
                'Redeem',
                'Voucher/Code',
                const Color(0xFF006876),
                _redeem,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _primary.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'INDONESIAN COVERAGE',
                        style: TextStyle(
                          color: _primary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: .8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Signal 5G Kuat dari Sabang ke Merauke',
                      style: TextStyle(
                        color: ink,
                        fontSize: 16,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Nikmati koneksi tanpa jeda untuk streaming & video call kapan saja.',
                      style: TextStyle(color: muted, fontSize: 11, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 72,
                height: 78,
                decoration: BoxDecoration(
                  color: _primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.phone_android,
                  size: 40,
                  color: _primary,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 22),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommended Packages',
                    style: TextStyle(
                      color: ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Tailored to your usage pattern',
                    style: TextStyle(color: muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _selectedTab = 1),
              child: const Row(
                children: [
                  Text(
                    'See All',
                    style: TextStyle(
                      color: _primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Icon(Icons.arrow_forward, size: 16, color: _primary),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      _packageCard(
        card,
        ink,
        muted,
        'Flash Sale',
        Icons.local_fire_department,
        'Flash Sale 15 GB',
        '10 GB Main Quota + 5 GB Night Streaming',
        'Rp 35.000',
        'Rp 50.000',
        '30 Days - All Network 24h',
        const Color(0xFFBA1A1A),
      ),
      const SizedBox(height: 12),
      _packageCard(
        card,
        ink,
        muted,
        'Best Seller',
        Icons.verified,
        'Unlimited Social 7 Days',
        'No FUP for Instagram, TikTok, WhatsApp & YouTube',
        'Rp 20.000',
        null,
        '7 Days - Apps & Streaming',
        const Color(0xFF006876),
      ),
      const SizedBox(height: 10),
    ],
  );

  Widget _notificationIcon() => Stack(
    children: [
      IconButton.filledTonal(
        onPressed: _notifications,
        icon: const Icon(Icons.notifications_none, size: 19),
      ),
      Positioned(
        right: 9,
        top: 8,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFBA1A1A),
            shape: BoxShape.circle,
            border: Border.all(
              color: _dark ? const Color(0xFF121212) : _surface,
              width: 1.5,
            ),
          ),
        ),
      ),
    ],
  );

  Widget _quickAction(
    Color card,
    Color ink,
    Color muted,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback action,
  ) => InkWell(
    onTap: action,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.fromLTRB(7, 13, 7, 11),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .035), blurRadius: 9),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: ink,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(color: muted, fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );

  Widget _packageCard(
    Color card,
    Color ink,
    Color muted,
    String badge,
    IconData badgeIcon,
    String title,
    String description,
    String price,
    String? oldPrice,
    String duration,
    Color badgeColor,
  ) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .035), blurRadius: 9),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(badgeIcon, color: badgeColor, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      badge,
                      style: TextStyle(
                        color: badgeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Expanded(
                child: Text(
                  duration,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: muted, fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: ink,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: TextStyle(color: muted, fontSize: 11, height: 1.3),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            color: _primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (oldPrice != null) ...[
                          const SizedBox(width: 7),
                          Text(
                            oldPrice,
                            style: TextStyle(
                              color: muted,
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => _buyRecommendedPackage(title),
                style: FilledButton.styleFrom(
                  backgroundColor: _primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: const Text(
                  'Beli',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  void _buyRecommendedPackage(String title) {
    final package = switch (title) {
      'Flash Sale 15 GB' => const _DataPackage(
        title: 'Flash Sale 15 GB',
        subtitle: '10 GB Kuota Utama + 5 GB Streaming Malam',
        price: 'Rp 35.000',
        priceValue: 35000,
        quotaGb: 15,
        duration: '30 Hari - Semua Jaringan 24 Jam',
        tags: ['Internet'],
        badge: 'Flash Sale',
        badgeIcon: Icons.local_fire_department,
      ),
      'Unlimited Social 7 Days' => const _DataPackage(
        title: 'Unlimited Social 7 Days',
        subtitle: 'Unlimited Instagram, TikTok, WhatsApp & YouTube',
        price: 'Rp 20.000',
        priceValue: 20000,
        quotaGb: 0,
        duration: '7 Hari - Aplikasi & Streaming',
        tags: ['Internet'],
        badge: 'Best Seller',
        badgeIcon: Icons.verified,
      ),
      _ => null,
    };

    if (package == null) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _CheckoutPage(
          dark: _dark,
          title: package.title,
          description: package.subtitle,
          subtotal: package.priceValue,
          phone: '0812-3456-7890',
          onPaid: () => _completePurchase(package, false),
        ),
      ),
    );
  }

  void _notifications() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        decoration: BoxDecoration(
          color: _dark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0x1A006B5F),
                  child: Icon(Icons.notifications, color: _primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifikasi',
                        style: TextStyle(
                          color: _dark ? Colors.white : _ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Info & aktivitas terkini',
                        style: TextStyle(
                          color: _dark ? Colors.white70 : _muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: _dark ? Colors.white70 : _ink),
                ),
              ],
            ),
            const Divider(),
            _notificationRow(
              Icons.warning_amber,
              const Color(0xFFBA1A1A),
              'Sisa Kuota Utama < 3 GB',
              'Segera isi ulang kuota internetmu agar tetap lancar browsing dan streaming.',
              '10 menit yang lalu',
            ),
            _notificationRow(
              Icons.verified,
              _primary,
              'Cashback 20% Berhasil Diklaim',
              'Bonus saldo pulsa Rp 5.000 dari transaksi kemarin telah masuk ke akunmu.',
              '2 jam yang lalu',
            ),
            _notificationRow(
              Icons.schedule,
              const Color(0xFF8E4E14),
              'Masa Aktif Paket Berakhir 28 Feb',
              'Paket internet bulananmu akan segera berakhir dalam 3 hari ke depan.',
              '1 hari yang lalu',
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(backgroundColor: _primary),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationRow(
    IconData icon,
    Color color,
    String title,
    String body,
    String time,
  ) => Container(
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: _dark ? const Color(0xFF262626) : _surfaceLow,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: _dark ? Colors.white : _ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                body,
                style: TextStyle(
                  color: _dark ? Colors.white70 : _ink,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: _dark ? Colors.white60 : _muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  void _checkin() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.celebration, color: Color(0xFFD08446), size: 44),
      title: const Text('Check-in Berhasil!'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Kamu mendapatkan bonus +500MB kuota streaming hari ini.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 14),
          Text(
            'Streak Hari Ini - 4 Hari Berturut-turut',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () {
            setState(() => _claimed = true);
            Navigator.pop(context);
            _message('Bonus +500MB berhasil diambil!');
          },
          style: FilledButton.styleFrom(
            backgroundColor: _primaryContainer,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
          child: const Text('Ambil Bonus'),
        ),
      ],
    ),
  );

  void _redeem() => showDialog<void>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialog) => AlertDialog(
        title: const Text('Tukar Voucher'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Klaim kode promosi'),
            const SizedBox(height: 16),
            const Text(
              'Kode Voucher / Promo',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _voucher,
              textCapitalization: TextCapitalization.characters,
              cursorColor: _primaryContainer,
              style: TextStyle(
                color: _dark ? Colors.white : _ink,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Contoh: NUSANET50',
                hintStyle: TextStyle(
                  color: _dark ? Colors.white54 : _muted.withValues(alpha: .7),
                ),
                filled: true,
                fillColor: _dark ? const Color(0xFF262626) : _surfaceLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: TextButton(
                  onPressed: () {
                    _voucher.text = 'NUSANET50';
                    setDialog(() {});
                  },
                  child: const Text('Contoh'),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (_voucher.text.trim().isEmpty) {
                _message('Silakan masukkan kode voucher terlebih dahulu.');
                return;
              }
              Navigator.pop(context);
              _voucher.clear();
              _message('Voucher berhasil ditukarkan! +10GB telah aktif.');
            },
            style: FilledButton.styleFrom(
              backgroundColor: _primaryContainer,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
            child: const Text('Tukarkan'),
          ),
        ],
      ),
    ),
  );
}

class _DataPackage {
  const _DataPackage({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.priceValue,
    required this.quotaGb,
    required this.duration,
    required this.tags,
    required this.badge,
    required this.badgeIcon,
    this.oldPrice,
    this.chips = const [],
    this.highlight = false,
  });
  final String title;
  final String subtitle;
  final String price;
  final int priceValue;
  final double quotaGb;
  final String duration;
  final List<String> tags;
  final String badge;
  final IconData badgeIcon;
  final String? oldPrice;
  final List<String> chips;
  final bool highlight;
}

class PackagesPage extends StatefulWidget {
  const PackagesPage({
    super.key,
    required this.dark,
    required this.pulseBalance,
    required this.onPurchase,
  });
  final bool dark;
  final int pulseBalance;
  final void Function(_DataPackage package, bool usePulse) onPurchase;

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  final _search = TextEditingController();
  String _category = 'Semua';
  static const _categories = ['Semua', 'Internet', 'Combo', 'Gaming'];
  static const _packages = [
    _DataPackage(
      title: 'Daily 3 GB',
      subtitle: '3 GB Kuota Utama tanpa batas aplikasi',
      price: 'Rp 10.000',
      priceValue: 10000,
      quotaGb: 3,
      duration: '1 Hari - 24 Jam Semua Jaringan',
      tags: ['Internet'],
      badge: '1 HARI',
      badgeIcon: Icons.schedule,
    ),
    _DataPackage(
      title: 'Monthly Freedom 25 GB',
      subtitle: '20 GB Utama + 5 GB Chat & Medsos',
      price: 'Rp 55.000',
      priceValue: 55000,
      quotaGb: 25,
      oldPrice: 'Rp 70.000',
      duration: '30 Hari - 24 Jam',
      tags: ['Internet', 'Combo'],
      badge: 'Terpopuler',
      badgeIcon: Icons.star,
      chips: ['20 GB Utama', '5 GB Chat & Medsos'],
      highlight: true,
    ),
    _DataPackage(
      title: 'Super Max 60 GB',
      subtitle: '50 GB Utama + 10 GB Video Streaming & YouTube',
      price: 'Rp 100.000',
      priceValue: 100000,
      quotaGb: 60,
      duration: '30 Hari - 5G Ultra Speed',
      tags: ['Internet', 'Gaming'],
      badge: 'Ultra Kuota',
      badgeIcon: Icons.speed,
      chips: ['50 GB Utama', '10 GB Video & Streaming'],
    ),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.dark;
    final ink = dark ? Colors.white : _ink;
    final muted = dark ? Colors.white60 : _muted;
    final card = dark ? const Color(0xFF1E1E1E) : Colors.white;
    final soft = dark ? const Color(0xFF283044) : const Color(0xFFEAEDFF);
    final query = _search.text.trim().toLowerCase();
    final shown = _packages.where((item) {
      final categoryMatch =
          _category == 'Semua' || item.tags.contains(_category);
      final searchable =
          '${item.title} ${item.subtitle} ${item.duration} ${item.tags.join(' ')} ${item.badge}'
              .toLowerCase();
      return categoryMatch && (query.isEmpty || searchable.contains(query));
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 26),
      children: [
        Text(
          'Beli Paket Internet',
          style: TextStyle(
            color: ink,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pilih paket data terbaik sesuai kebutuhanmu',
          style: TextStyle(color: muted, fontSize: 14),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _search,
          onChanged: (_) => setState(() {}),
          style: TextStyle(color: ink, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: muted),
            hintText: 'Cari paket (cth. Unlimited, 30 hari)...',
            hintStyle: TextStyle(
              color: muted.withValues(alpha: .65),
              fontSize: 12,
            ),
            filled: true,
            fillColor: card,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: _primaryContainer,
                width: 1.5,
              ),
            ),
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _search.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.close, size: 18),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final active = _category == category;
              return ChoiceChip(
                label: Text(
                  category,
                  style: TextStyle(
                    color: active ? Colors.white : muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: active,
                onSelected: (_) => setState(() => _category = category),
                showCheckmark: false,
                backgroundColor: soft,
                selectedColor: _primaryContainer,
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                shape: const StadiumBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        if (shown.isEmpty)
          _emptyResults(ink, muted, soft)
        else
          ...shown.map(
            (item) => _packageItem(item, card, ink, muted, soft, dark),
          ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF1E1E1E) : _surfaceLow,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.verified, color: _primaryContainer, size: 20),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Semua paket kuota otomatis aktif setelah pembayaran berhasil. Nikmati koneksi lancar di jaringan tercepat Nusanet.',
                  style: TextStyle(color: muted, fontSize: 12, height: 1.45),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _packageItem(
    _DataPackage item,
    Color card,
    Color ink,
    Color muted,
    Color soft,
    bool dark,
  ) {
    final badgeColor = item.highlight
        ? const Color(0xFF8E4E14)
        : item.badge == 'Ultra Kuota'
        ? _primary
        : const Color(0xFF006876);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(27),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: item.highlight ? .07 : .035),
            blurRadius: item.highlight ? 20 : 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: item.highlight
            ? Border.all(color: const Color(0xFFD08446).withValues(alpha: .22))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(item.badgeIcon, size: 14, color: badgeColor),
                    const SizedBox(width: 5),
                    Text(
                      item.badge,
                      style: TextStyle(
                        color: badgeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Expanded(
                child: Text(
                  item.duration,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: muted, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            item.title,
            style: TextStyle(
              color: ink,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            item.subtitle,
            style: TextStyle(color: muted, fontSize: 13, height: 1.35),
          ),
          if (item.chips.isEmpty) ...[
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 1,
                minHeight: 7,
                backgroundColor: soft,
                color: _primaryContainer,
              ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: item.chips
                  .map(
                    (label) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: soft,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(color: muted, fontSize: 10),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 19),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.oldPrice != null)
                      Text(
                        item.oldPrice!,
                        style: TextStyle(
                          color: muted,
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      item.price,
                      style: TextStyle(
                        color: item.highlight ? _primaryContainer : ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 46,
                child: FilledButton(
                  onPressed: () => _selectPackage(item),
                  style: FilledButton.styleFrom(
                    backgroundColor: _primaryContainer,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                  ),
                  child: const Text(
                    'Beli Sekarang',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyResults(Color ink, Color muted, Color soft) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 34),
    child: Column(
      children: [
        CircleAvatar(
          radius: 29,
          backgroundColor: soft,
          child: Icon(Icons.search_off, color: muted, size: 29),
        ),
        const SizedBox(height: 12),
        Text(
          'Paket Tidak Ditemukan',
          style: TextStyle(
            color: ink,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            'Coba cari dengan kata kunci lain atau pilih tab Semua.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 13),
          ),
        ),
      ],
    ),
  );

  void _selectPackage(_DataPackage item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _CheckoutPage(
          dark: widget.dark,
          title: item.title,
          description:
              '${item.quotaGb.toStringAsFixed(0)} GB - ${item.duration}',
          subtotal: item.priceValue,
          phone: '0812-3456-7890',
          onPaid: () => widget.onPurchase(item, false),
        ),
      ),
    );
  }
}

class _CheckoutPage extends StatefulWidget {
  const _CheckoutPage({
    required this.dark,
    required this.title,
    required this.description,
    required this.subtotal,
    required this.phone,
    required this.onPaid,
  });

  final bool dark;
  final String title;
  final String description;
  final int subtotal;
  final String phone;
  final VoidCallback onPaid;

  @override
  State<_CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<_CheckoutPage> {
  static const _methods = <(String, String, String, IconData)>[
    (
      'qris',
      'QRIS Nasional',
      'BCA, GoPay, OVO, ShopeePay, DANA & M-Banking',
      Icons.qr_code_2,
    ),
    (
      'gopay',
      'GoPay',
      'Nomor GoPay',
      Icons.account_balance_wallet,
    ),
    ('dana', 'DANA', 'Bayar cepat satu sentuhan', Icons.payments),
    ('shopeepay', 'ShopeePay', 'Gunakan Koin Shopee', Icons.shopping_bag),
    (
      'va-bca',
      'BCA Virtual Account',
      'Verifikasi otomatis 24 jam',
      Icons.account_balance,
    ),
    (
      'va-mandiri',
      'Mandiri Virtual Account',
      'Tanpa biaya admin tambahan',
      Icons.account_balance,
    ),
    ('va-bri', 'BRIVA', 'Bayar via BRImo atau ATM', Icons.account_balance),
  ];

  late final int _discount;
  late final Timer _timer;
  int _secondsLeft = 14 * 60 + 59;
  String _selected = 'qris';
  bool _hasVoucher = false;
  bool _processing = false;

  Color get _ink => widget.dark ? Colors.white : const Color(0xFF131B2E);
  Color get _muted => widget.dark ? Colors.white60 : const Color(0xFF3C4946);
  Color get _card => widget.dark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _soft =>
      widget.dark ? const Color(0xFF283044) : const Color(0xFFF2F3FF);
  int get _total => widget.subtotal - (_hasVoucher ? _discount : 0);

  String _rupiah(int amount) =>
      'Rp ${amount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.')}';

  @override
  void initState() {
    super.initState();
    _discount = widget.subtotal == 55000 ? 5000 : 0;
    _hasVoucher = _discount > 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft <= 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return Scaffold(
      backgroundColor: widget.dark
          ? const Color(0xFF121212)
          : const Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: widget.dark
            ? const Color(0xFF121212)
            : const Color(0xFFFAF8FF),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: Icon(Icons.arrow_back, color: _ink),
        ),
        title: Text(
          'Checkout And Payment',
          style: TextStyle(
            color: _ink,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showHelp,
            icon: Icon(Icons.help_outline, color: _muted),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 9, color: _primaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: _muted, fontSize: 12),
                      children: [
                        const TextSpan(text: 'Selesaikan dalam '),
                        TextSpan(
                          text: '$minutes:$seconds',
                          style: const TextStyle(
                            color: _primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Text(
                  'Instan Aktif',
                  style: TextStyle(
                    color: _primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _orderCard(),
          const SizedBox(height: 12),
          _priceCard(),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pilih Pembayaran',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'Otomatis Terverifikasi',
                style: TextStyle(color: _muted, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _methodSection('Metode Paling Populer', Icons.qr_code_scanner, [
            _methods[0],
          ]),
          const SizedBox(height: 13),
          _methodSection(
            'Dompet Digital (E-Wallet)',
            Icons.account_balance_wallet,
            _methods.sublist(1, 4),
          ),
          const SizedBox(height: 13),
          _methodSection(
            'Transfer Virtual Account',
            Icons.account_balance,
            _methods.sublist(4),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user, color: _primary, size: 19),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Transaksi Aman & Terenkripsi 256-bit SSL Nusanet Guard',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 92),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: _card,
            border: Border(top: BorderSide(color: _soft)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .06),
                blurRadius: 15,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Bayar:',
                      style: TextStyle(color: _muted, fontSize: 10),
                    ),
                    Text(
                      _rupiah(_total),
                      style: const TextStyle(
                        color: _primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: _processing || _secondsLeft == 0 ? null : _pay,
                  style: FilledButton.styleFrom(
                    backgroundColor: _primaryContainer,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                  ),
                  icon: _processing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.lock, size: 18),
                  label: Text(
                    _processing ? 'Memproses' : 'Bayar Sekarang',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderCard() => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 16),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _soft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${widget.phone} (Farhan)',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: _ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.description,
                    style: TextStyle(color: _muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const CircleAvatar(
              backgroundColor: Color(0x339EEFFF),
              child: Icon(Icons.wifi_tethering, color: Color(0xFF006876)),
            ),
          ],
        ),
        if (_discount > 0) ...[
          const SizedBox(height: 14),
          Divider(color: _soft),
          Row(
            children: [
              const Icon(
                Icons.local_activity,
                color: Color(0xFF8E4E14),
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _hasVoucher
                      ? 'NUSACASH20 Terpasang'
                      : 'Voucher promo dilepas',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _hasVoucher = !_hasVoucher),
                child: Text(
                  _hasVoucher ? 'Hapus' : 'Pakai',
                  style: const TextStyle(
                    color: _primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );

  Widget _priceCard() => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 16),
      ],
    ),
    child: Column(
      children: [
        _priceLine('Harga Paket (Subtotal)', _rupiah(widget.subtotal)),
        const SizedBox(height: 10),
        _priceLine(
          'Diskon Promo',
          _hasVoucher ? '-${_rupiah(_discount)}' : _rupiah(0),
          valueColor: _hasVoucher ? const Color(0xFF8E4E14) : _muted,
        ),
        const SizedBox(height: 10),
        _priceLine('Biaya Layanan', 'Gratis', valueColor: _primary),
        const SizedBox(height: 13),
        Divider(color: _soft),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL TAGIHAN',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .8,
                    ),
                  ),
                  Text(
                    _rupiah(_total),
                    style: TextStyle(
                      color: _ink,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            if (_hasVoucher)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: _primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Hemat ${((_discount / widget.subtotal) * 100).round()}%',
                  style: const TextStyle(
                    color: _primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ],
    ),
  );

  Widget _priceLine(
    String label,
    String value, {
    Color valueColor = const Color(0xFF131B2E),
  }) => Row(
    children: [
      Expanded(
        child: Text(label, style: TextStyle(color: _muted, fontSize: 12)),
      ),
      Text(
        value,
        style: TextStyle(
          color: valueColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );

  Widget _methodSection(
    String title,
    IconData icon,
    List<(String, String, String, IconData)> methods,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, color: _primary, size: 17),
          const SizedBox(width: 6),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: _ink,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: .6,
            ),
          ),
        ],
      ),
      const SizedBox(height: 7),
      ...methods.map((method) {
        final selected = _selected == method.$1;
        return InkWell(
          onTap: () => setState(() => _selected = method.$1),
          borderRadius: BorderRadius.circular(17),
          child: Container(
            margin: const EdgeInsets.only(bottom: 7),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: selected ? _soft : _card,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: selected ? _primaryContainer : _soft,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _soft,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(method.$4, color: _primary, size: 21),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.$2,
                        style: TextStyle(
                          color: _ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        method.$3,
                        style: TextStyle(color: _muted, fontSize: 9),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: selected
                      ? _primaryContainer
                      : _muted.withValues(alpha: .4),
                  size: 21,
                ),
              ],
            ),
          ),
        );
      }),
    ],
  );

  Future<void> _pay() async {
    setState(() => _processing = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _processing = false);
    final methodName = _methods
        .firstWhere((method) => method.$1 == _selected)
        .$2;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const CircleAvatar(
          backgroundColor: Color(0xFF79F7E3),
          child: Icon(Icons.check, color: _primary),
        ),
        title: const Text('Pembayaran Berhasil!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Transaksi Anda telah diverifikasi oleh Nusanet Guard.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            _priceLine('Total Pembayaran', _rupiah(_total)),
            const SizedBox(height: 7),
            _priceLine('Paket', widget.title),
            const SizedBox(height: 7),
            _priceLine('Metode Pembayaran', methodName),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              widget.onPaid();
              Navigator.pop(this.context);
            },
            style: FilledButton.styleFrom(backgroundColor: _primary),
            child: const Text('Kembali ke Beranda'),
          ),
        ],
      ),
    );
  }

  void _showHelp() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Bantuan Pembayaran'),
      content: const Text(
        'Pilih metode pembayaran yang tersedia, lalu tekan Bayar Sekarang. Transaksi demo akan dikonfirmasi secara otomatis.',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(backgroundColor: _primary),
          child: const Text('Mengerti'),
        ),
      ],
    ),
  );
}

class _PromoItem {
  const _PromoItem({
    required this.category,
    required this.label,
    required this.title,
    required this.description,
    required this.period,
    required this.icon,
    required this.code,
    required this.action,
    required this.themeColor,
  });
  final String category;
  final String label;
  final String title;
  final String description;
  final String period;
  final IconData icon;
  final String? code;
  final String action;
  final Color themeColor;
}

class PromoPage extends StatefulWidget {
  const PromoPage({super.key, required this.dark});
  final bool dark;

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  String _filter = 'Semua Promo';
  final Set<String> _claimed = {};
  static const _filters = ['Semua Promo', 'Cashback', 'Kupon Kuota'];
  static const _items = [
    _PromoItem(
      category: 'Cashback',
      label: 'Spesial Dompet Digital',
      title: 'Cashback 20% Pembelian Pulsa & Paket',
      description:
          'Dapatkan cashback koin hingga Rp 15.000 untuk transaksi pertama via GoPay, OVO, atau ShopeePay.',
      period: 'Berlaku s/d 31 Maret 2025',
      icon: Icons.account_balance_wallet,
      code: 'NUSACASH20',
      action: 'Klaim Sekarang',
      themeColor: Color(0xFF8E4E14),
    ),
    _PromoItem(
      category: 'Kupon Kuota',
      label: 'Bonus Mingguan',
      title: 'Weekend Data Bonus +5 GB',
      description:
          'Tambahan kuota 5 GB gratis untuk setiap pembelian paket bulanan di hari Sabtu & Minggu.',
      period: 'Hanya Sabtu & Minggu',
      icon: Icons.bolt,
      code: null,
      action: 'Klaim Bonus',
      themeColor: Color(0xFF006876),
    ),
    _PromoItem(
      category: 'Kupon Kuota',
      label: 'Program Referral',
      title: 'Ajak Teman, Dapat Kuota 3 GB Gratis',
      description:
          'Bagikan kode referral ke temanmu. Dapatkan kuota 3 GB gratis untuk kalian berdua ketika mereka mendaftar.',
      period: 'Berlaku Selamanya',
      icon: Icons.group_add,
      code: 'NUSAFARHAN',
      action: 'Ajak Teman',
      themeColor: Color(0xFF8E4E14),
    ),
  ];

  List<_PromoItem> get _visibleItems => _filter == 'Semua Promo'
      ? _items
      : _items.where((item) => item.category == _filter).toList();

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<void> _copyCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (mounted) _toast('Kode $code berhasil disalin!');
  }

  void _claim(_PromoItem item) {
    if (_claimed.contains(item.title)) return;
    setState(() => _claimed.add(item.title));
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: CircleAvatar(
          backgroundColor: _primary.withValues(alpha: .12),
          child: const Icon(Icons.check_circle, color: _primary),
        ),
        title: const Text('Promo Berhasil Diklaim!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Benefit promo kamu sekarang sudah aktif dan siap digunakan.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.dark ? const Color(0xFF283044) : _surfaceLow,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified, color: _primary, size: 18),
                  SizedBox(width: 7),
                  Text(
                    'PROMO AKTIF',
                    style: TextStyle(
                      color: _primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(backgroundColor: _primary),
            child: const Text('Tutup & Gunakan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.dark;
    final ink = dark ? Colors.white : _ink;
    final muted = dark ? Colors.white60 : _muted;
    final card = dark ? const Color(0xFF1E1E1E) : Colors.white;
    final soft = dark ? const Color(0xFF283044) : const Color(0xFFE2E7FF);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF92EDFF).withValues(alpha: .55),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.stars, size: 15, color: Color(0xFF006D7B)),
              SizedBox(width: 5),
              Text(
                'PESTA KUOTA HEMAT',
                style: TextStyle(
                  color: Color(0xFF006D7B),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Promo & Penawaran Spesial',
          style: TextStyle(
            color: ink,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Klaim diskon dan bonus kuota menarik khusus untukmu!',
          style: TextStyle(color: muted, fontSize: 14),
        ),
        const SizedBox(height: 17),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final selected = _filter == filter;
              return ChoiceChip(
                label: Text(
                  filter,
                  style: TextStyle(
                    color: selected ? Colors.white : muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: selected,
                onSelected: (_) => setState(() => _filter = filter),
                showCheckmark: false,
                selectedColor: _primary,
                backgroundColor: soft,
                shape: const StadiumBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        ..._visibleItems.map(
          (item) => _promoCard(item, card, ink, muted, dark),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: soft,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: _primary,
                    child: Icon(Icons.card_giftcard, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kode Referral Pribadi',
                          style: TextStyle(
                            color: ink,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Teman daftar, langsung panen pulsa & kuota bersama!',
                          style: TextStyle(color: muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.only(
                  left: 14,
                  right: 5,
                  top: 5,
                  bottom: 5,
                ),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    Text(
                      'KODE:',
                      style: TextStyle(
                        color: muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'NUSAFARHAN',
                        style: TextStyle(
                          color: ink,
                          fontFamily: 'monospace',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => _copyCode('NUSAFARHAN'),
                      style: FilledButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: const Icon(Icons.copy, size: 15),
                      label: const Text('Salin'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _promoCard(
    _PromoItem item,
    Color card,
    Color ink,
    Color muted,
    bool dark,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 15),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(26),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 144,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                item.themeColor.withValues(alpha: .88),
                const Color(0xFF006876),
                const Color(0xFF131B2E),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -12,
                top: 2,
                child: Icon(
                  item.icon,
                  size: 140,
                  color: Colors.white.withValues(alpha: .08),
                ),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: dark
                        ? const Color(0xFF20283A)
                        : const Color(0xFFFFDCC4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.icon, color: item.themeColor, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: item.themeColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xAA283044),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule, size: 13, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        item.period,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Icon(
                  item.icon,
                  color: Colors.white.withValues(alpha: .9),
                  size: 54,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        Text(
          item.title,
          style: TextStyle(
            color: ink,
            fontSize: 17,
            height: 1.3,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          item.description,
          style: TextStyle(color: muted, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 14),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (item.code != null)
              Container(
                padding: const EdgeInsets.fromLTRB(11, 7, 5, 7),
                decoration: BoxDecoration(
                  color: dark
                      ? const Color(0xFF283044)
                      : const Color(0xFFEAEDFF),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.category == 'Cashback'
                          ? Icons.confirmation_number
                          : Icons.diversity_3,
                      size: 16,
                      color: _primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.code!,
                      style: TextStyle(
                        color: muted,
                        fontFamily: 'monospace',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .8,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _copyCode(item.code!),
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.copy, color: _primary, size: 15),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 15,
                      color: Color(0xFF8E4E14),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Otomatis aktif setelah isi ulang',
                      style: TextStyle(color: muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
            FilledButton.icon(
              onPressed: _claimed.contains(item.title)
                  ? null
                  : () =>
                        item.category == 'Kupon Kuota' &&
                            item.code == 'NUSAFARHAN'
                        ? _copyCode(item.code!)
                        : _claim(item),
              style: FilledButton.styleFrom(
                backgroundColor: _primaryContainer,
                foregroundColor: Colors.white,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
              ),
              icon: Icon(
                _claimed.contains(item.title)
                    ? Icons.check
                    : item.code == 'NUSAFARHAN'
                    ? Icons.share
                    : Icons.arrow_forward,
                size: 15,
              ),
              label: Text(
                _claimed.contains(item.title) ? 'Terklaim' : item.action,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.dark,
    required this.fullName,
    required this.email,
    required this.emergencyPhone,
    required this.avatarIndex,
    required this.profileImagePath,
    required this.onPickPhoto,
    required this.onToggleTheme,
    required this.onSaveProfile,
    required this.onLogout,
  });
  final bool dark;
  final String fullName;
  final String email;
  final String emergencyPhone;
  final int avatarIndex;
  final String? profileImagePath;
  final VoidCallback onPickPhoto;
  final VoidCallback onToggleTheme;
  final void Function(
    String name,
    String email,
    String emergencyPhone,
    int avatarIndex,
  )
  onSaveProfile;
  final VoidCallback onLogout;

  Color get _ink => dark ? Colors.white : _inkLight;
  static const _inkLight = Color(0xFF131B2E);
  Color get _muted => dark ? Colors.white60 : const Color(0xFF3C4946);
  Color get _card => dark ? const Color(0xFF283044) : Colors.white;
  Color get _soft => dark ? const Color(0xFF354057) : const Color(0xFFEAEDFF);

  void _showInfo(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(backgroundColor: _primary),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
    children: [
      _profileHeader(),
      const SizedBox(height: 14),
      Row(
        children: [
          _stat(
            Icons.wifi_tethering,
            'Status SIM',
            '5G Aktif',
            const Color(0xFF006876),
          ),
          const SizedBox(width: 9),
          _stat(Icons.event_available, 'Masa Aktif', '28 Feb 2025', _primary),
          const SizedBox(width: 9),
          _stat(
            Icons.monetization_on,
            'Nusanet Poin',
            '1.450 Pts',
            const Color(0xFF8E4E14),
          ),
        ],
      ),
      const SizedBox(height: 14),
      _loyaltyBanner(),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .035),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
              child: Text(
                'PENGATURAN AKUN',
                style: TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            _menuRow(
              Icons.manage_accounts,
              'Ubah Profil',
              'Identitas, email, & nomor darurat',
              () => _editProfile(context),
            ),
            _menuRow(
              Icons.receipt_long,
              'Riwayat Transaksi',
              'Paket data, pulsa, & tagihan',
              () => _transactions(context),
            ),
            _themeRow(),
            _menuRow(
              Icons.support_agent,
              'Pusat Bantuan & CS',
              'FAQ, kendala jaringan, & agen',
              () => _showInfo(
                context,
                'Pusat Bantuan & CS',
                'Tim bantuan Nusanet siap membantu melalui chat, telepon, atau FAQ. Layanan tersedia 24/7.',
              ),
              badge: '24/7 Live',
            ),
            _menuRow(
              Icons.info_outline,
              'Tentang Aplikasi & Ketentuan',
              'Kebijakan privasi & lisensi',
              () => _showInfo(
                context,
                'Tentang Nusanet',
                'Nusanet Mobile v2.4.0\nPT Nusanet Telekomunikasi Nusantara - 2025\n\nKebijakan privasi dan ketentuan penggunaan.',
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 48,
        child: FilledButton.icon(
          onPressed: () => _logoutDialog(context),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFFDAD6),
            foregroundColor: const Color(0xFF93000A),
          ),
          icon: const Icon(Icons.logout, size: 20),
          label: const Text(
            'Keluar dari Akun',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      const SizedBox(height: 14),
      Text(
        'Nusanet Mobile v2.4.0 - Jaringan Terluas Indonesia',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _muted,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        'PT Nusanet Telekomunikasi Nusantara - 2025',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted.withValues(alpha: .7), fontSize: 9),
      ),
    ],
  );

  Widget _profileHeader() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: .035), blurRadius: 12),
      ],
    ),
    child: Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: _soft,
              backgroundImage: profileImagePath == null
                  ? null
                  : FileImage(File(profileImagePath!)),
              child: profileImagePath == null
                  ? Icon(
                      [
                        Icons.person,
                        Icons.face,
                        Icons.account_circle,
                        Icons.tag_faces,
                      ][avatarIndex % 4],
                      size: 43,
                      color: _muted,
                    )
                  : null,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Material(
                color: _primary,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onPickPhoto,
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(Icons.edit, color: Colors.white, size: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: TextStyle(
                  color: _ink,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(
                    '0812-3456-7890',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.verified, color: _primary, size: 17),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                email,
                style: TextStyle(color: _muted, fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _badge(Icons.stars, 'Silver Member', const Color(0xFF8E4E14)),
                  _badge(Icons.monetization_on, '1.450 Poin', _primary),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _badge(IconData icon, String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  Widget _stat(IconData icon, String label, String value, Color color) =>
      Expanded(
        child: Container(
          height: 104,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .03),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 17),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: _muted, fontSize: 9),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _loyaltyBanner() => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFF00A896).withValues(alpha: .16),
          _soft,
          const Color(0xFF92EDFF).withValues(alpha: .2),
        ],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: _primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.military_tech, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gold Tier Target',
                style: TextStyle(
                  color: _ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '550 Poin lagi menuju Gold Level',
                style: TextStyle(color: _muted, fontSize: 10),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const LinearProgressIndicator(
                  value: .72,
                  minHeight: 5,
                  backgroundColor: Color(0xFFDAE2FD),
                  color: _primaryContainer,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          '72%',
          style: TextStyle(
            color: _primary,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );

  Widget _menuRow(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    String? badge,
  }) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 9, vertical: 1),
    leading: Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(color: _soft, shape: BoxShape.circle),
      child: Icon(icon, color: _primary, size: 20),
    ),
    title: Row(
      children: [
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              color: _ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF92EDFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: Color(0xFF006D7B),
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    ),
    subtitle: Text(subtitle, style: TextStyle(color: _muted, fontSize: 10)),
    trailing: Icon(Icons.chevron_right, color: _muted, size: 20),
    onTap: onTap,
  );

  Widget _themeRow() => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 9, vertical: 1),
    leading: Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(color: _soft, shape: BoxShape.circle),
      child: Icon(
        dark ? Icons.light_mode : Icons.dark_mode,
        color: _primary,
        size: 20,
      ),
    ),
    title: Text(
      'Tema Gelap (Dark Mode)',
      style: TextStyle(color: _ink, fontSize: 13, fontWeight: FontWeight.w600),
    ),
    subtitle: Text(
      dark ? 'Mode gelap aktif' : 'Tampilan redup nyaman mata',
      style: TextStyle(color: _muted, fontSize: 10),
    ),
    trailing: Switch(
      value: dark,
      onChanged: (_) => onToggleTheme(),
      activeColor: _primaryContainer,
    ),
    onTap: onToggleTheme,
  );

  void _editProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EditProfilePage(
          dark: dark,
          fullName: fullName,
          email: email,
          emergencyPhone: emergencyPhone,
          avatarIndex: avatarIndex,
          onSave: onSaveProfile,
        ),
      ),
    );
  }

  void _transactions(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TransactionHistoryPage(dark: dark),
      ),
    );
  }

  void _logoutDialog(BuildContext context) => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.logout, color: Color(0xFFBA1A1A), size: 34),
      title: const Text('Keluar dari Akun?'),
      content: const Text(
        'Kamu perlu login kembali untuk mengakses paket data dan informasi akun Nusanet kamu.',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            onLogout();
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFBA1A1A),
          ),
          child: const Text('Ya, Keluar'),
        ),
      ],
    ),
  );
}

class _HistoryTransaction {
  const _HistoryTransaction({
    required this.category,
    required this.title,
    required this.date,
    required this.id,
    required this.payment,
    required this.amount,
    required this.detail,
    required this.icon,
  });

  final String category;
  final String title;
  final String date;
  final String id;
  final String payment;
  final String amount;
  final String detail;
  final IconData icon;
}

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key, required this.dark});
  final bool dark;

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  static const _transactions = <_HistoryTransaction>[
    _HistoryTransaction(
      category: 'data',
      title: 'Monthly Freedom 25 GB',
      date: '12 Feb 2025, 14:20 WIB',
      id: '#NSN-892104',
      payment: 'QRIS - GoPay',
      amount: 'Rp 55.000',
      detail: 'Aktivasi Otomatis',
      icon: Icons.wifi_tethering,
    ),
    _HistoryTransaction(
      category: 'pulsa',
      title: 'Top Up Pulsa Rp 25.000',
      date: '28 Jan 2025, 09:15 WIB',
      id: '#NSN-874219',
      payment: 'BCA Virtual Account',
      amount: 'Rp 25.500',
      detail: 'Masuk ke 0812-3490-8812',
      icon: Icons.payments,
    ),
    _HistoryTransaction(
      category: 'data',
      title: 'Daily 3 GB',
      date: '15 Jan 2025, 18:40 WIB',
      id: '#NSN-851092',
      payment: 'DANA',
      amount: 'Rp 10.000',
      detail: 'Masa Aktif 1 Hari',
      icon: Icons.bolt,
    ),
    _HistoryTransaction(
      category: 'data',
      title: 'Paket Unlimited Social 7 Days',
      date: '02 Jan 2025, 11:05 WIB',
      id: '#NSN-820481',
      payment: 'ShopeePay',
      amount: 'Rp 20.000',
      detail: 'FUP Bebas Akses',
      icon: Icons.public,
    ),
  ];

  static const _filters = [
    ('all', 'Semua Transaksi'),
    ('data', 'Paket Data'),
    ('pulsa', 'Pulsa'),
    ('tagihan', 'Tagihan'),
  ];

  String _filter = 'all';
  Color get _ink => widget.dark ? Colors.white : const Color(0xFF131B2E);
  Color get _muted => widget.dark ? Colors.white60 : const Color(0xFF3C4946);
  Color get _card => widget.dark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _soft =>
      widget.dark ? const Color(0xFF283044) : const Color(0xFFEAEDFF);
  List<_HistoryTransaction> get _visible => _filter == 'all'
      ? _transactions
      : _transactions.where((item) => item.category == _filter).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: widget.dark
        ? const Color(0xFF121212)
        : const Color(0xFFFAF8FF),
    appBar: AppBar(
      backgroundColor: widget.dark
          ? const Color(0xFF121212)
          : const Color(0xFFFAF8FF),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: Icon(Icons.arrow_back, color: _ink),
      ),
      title: Text(
        'Transaction History',
        style: TextStyle(
          color: _ink,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showHelp,
          icon: Icon(Icons.help_outline, color: _muted),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.only(bottom: 28),
      children: [
        SizedBox(
          height: 49,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final selected = filter.$1 == _filter;
              return ChoiceChip(
                label: Text(
                  filter.$2,
                  style: TextStyle(
                    color: selected ? Colors.white : _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: selected,
                onSelected: (_) => setState(() => _filter = filter.$1),
                showCheckmark: false,
                selectedColor: _primary,
                backgroundColor: _soft,
                shape: const StadiumBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .035),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0x2600A896),
                  child: Icon(Icons.receipt_long, color: _primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Pembelian (Q1)',
                        style: TextStyle(color: _muted, fontSize: 10),
                      ),
                      Text(
                        'Rp 110.500',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF79F7E3).withValues(alpha: .3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, color: _primary, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '4 Berhasil',
                        style: TextStyle(
                          color: _primary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_visible.isEmpty)
          _emptyState()
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: _visible.map(_transactionCard).toList()),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Column(
            children: [
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: _soft,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Menampilkan riwayat 90 hari terakhir',
                style: TextStyle(color: _muted, fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _transactionCard(_HistoryTransaction item) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: .035), blurRadius: 10),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _primary.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon, color: _primary, size: 21),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.date} • ${item.id}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: _muted, fontSize: 9),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF79F7E3).withValues(alpha: .3),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: _primary, size: 13),
                  SizedBox(width: 3),
                  Text(
                    'Berhasil',
                    style: TextStyle(
                      color: _primary,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Divider(height: 1, color: _soft),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Metode Pembayaran',
                    style: TextStyle(color: _muted, fontSize: 9),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet,
                        color: Color(0xFF006876),
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          item.payment,
                          style: TextStyle(
                            color: _ink,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Nominal', style: TextStyle(color: _muted, fontSize: 9)),
                const SizedBox(height: 3),
                Text(
                  item.amount,
                  style: const TextStyle(
                    color: _primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    item.category == 'pulsa' ? Icons.bolt : Icons.timer,
                    color: _muted,
                    size: 14,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      item.detail,
                      style: TextStyle(color: _muted, fontSize: 9),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () => _showReceipt(item),
              style: TextButton.styleFrom(
                backgroundColor: _soft,
                foregroundColor: _primary,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              icon: const Icon(Icons.receipt_long, size: 15),
              label: const Text(
                'Lihat Bukti',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _emptyState() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 55, 24, 65),
    child: Column(
      children: [
        CircleAvatar(
          radius: 33,
          backgroundColor: _soft,
          child: Icon(Icons.history_toggle_off, color: _muted, size: 34),
        ),
        const SizedBox(height: 12),
        Text(
          'Belum Ada Transaksi',
          style: TextStyle(
            color: _ink,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Tidak ditemukan riwayat pembayaran untuk kategori ini.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 12),
        ),
      ],
    ),
  );

  void _showReceipt(_HistoryTransaction item) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 5,
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 17),
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0x2679F7E3),
                  child: Icon(Icons.verified, color: _primary),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bukti Transaksi',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        item.id,
                        style: TextStyle(color: _muted, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: _muted),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Text(
                    'Total Terbayar',
                    style: TextStyle(color: _muted, fontSize: 10),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.amount,
                    style: const TextStyle(
                      color: _primary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _primary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'PEMBAYARAN LUNAS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Divider(color: _card),
                  _receiptLine('Produk', item.title),
                  _receiptLine('Waktu Pembelian', item.date),
                  _receiptLine('Metode Bayar', item.payment),
                  _receiptLine('Nomor Pelanggan', '0812-3456-7890'),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _message('Bukti transaksi siap disimpan.');
                    },
                    style: FilledButton.styleFrom(backgroundColor: _primary),
                    icon: const Icon(Icons.download, size: 17),
                    label: const Text(
                      'Simpan PDF',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                IconButton.filledTonal(
                  onPressed: () {
                    Navigator.pop(context);
                    _message('Bukti transaksi siap dibagikan.');
                  },
                  icon: const Icon(Icons.share),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Widget _receiptLine(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(color: _muted, fontSize: 10)),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _ink,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
  );

  void _showHelp() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Riwayat Transaksi'),
      content: const Text(
        'Riwayat transaksi menampilkan pembelian dan isi ulang dalam 90 hari terakhir. Pilih Lihat Bukti untuk membuka detail transaksi.',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(backgroundColor: _primary),
          child: const Text('Mengerti'),
        ),
      ],
    ),
  );
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.dark,
    required this.fullName,
    required this.email,
    required this.emergencyPhone,
    required this.avatarIndex,
    required this.onSave,
  });

  final bool dark;
  final String fullName;
  final String email;
  final String emergencyPhone;
  final int avatarIndex;
  final void Function(String, String, String, int) onSave;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const _avatarIcons = [
    Icons.person,
    Icons.face,
    Icons.account_circle,
    Icons.tag_faces,
  ];
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _emergency;
  late int _avatarIndex;
  bool _saving = false;

  Color get _ink => widget.dark ? Colors.white : const Color(0xFF131B2E);
  Color get _muted => widget.dark ? Colors.white60 : const Color(0xFF3C4946);
  Color get _card => widget.dark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _soft =>
      widget.dark ? const Color(0xFF283044) : const Color(0xFFF2F3FF);

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.fullName);
    _email = TextEditingController(text: widget.email);
    _emergency = TextEditingController(text: widget.emergencyPhone);
    _avatarIndex = widget.avatarIndex % _avatarIcons.length;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _emergency.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: widget.dark
        ? const Color(0xFF121212)
        : const Color(0xFFFAF8FF),
    appBar: AppBar(
      backgroundColor: widget.dark
          ? const Color(0xFF121212)
          : const Color(0xFFFAF8FF),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: Icon(Icons.arrow_back, color: _ink),
      ),
      title: Text(
        'Edit Profile',
        style: TextStyle(
          color: _ink,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showHelp,
          icon: Icon(Icons.help_outline, color: _muted),
        ),
      ],
    ),
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 112,
                      height: 112,
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [_primary, Color(0xFF92EDFF)],
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: _soft,
                        child: Icon(
                          _avatarIcons[_avatarIndex],
                          size: 54,
                          color: _primary,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: IconButton.filled(
                        onPressed: _chooseAvatar,
                        style: IconButton.styleFrom(
                          backgroundColor: _primaryContainer,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.photo_camera, size: 18),
                        tooltip: 'Ubah foto profil',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  'Ubah Profil',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Perbarui rincian akun dan info kontak Anda',
                  style: TextStyle(color: _muted, fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.shield, color: _primary, size: 20),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'Pastikan email dan nomor kontak aktif untuk menerima bukti transaksi dan notifikasi kuota Nusanet.',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _fieldLabel('Nama Lengkap', 'Sesuai KTP'),
            const SizedBox(height: 7),
            _textField(
              controller: _name,
              icon: Icons.person_outline,
              hint: 'Masukkan nama lengkap',
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Nama lengkap wajib diisi'
                  : null,
              suffix: IconButton(
                onPressed: _name.clear,
                icon: Icon(Icons.close, color: _muted, size: 18),
              ),
            ),
            const SizedBox(height: 17),
            Row(
              children: [
                Expanded(child: _fieldLabel('Alamat Email', null)),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _soft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, color: _primary, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Email Terverifikasi',
                        style: TextStyle(
                          color: _primary,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            _textField(
              controller: _email,
              icon: Icons.mail_outline,
              hint: 'nama@email.com',
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  value == null ||
                      !RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(value.trim())
                  ? 'Masukkan alamat email yang valid'
                  : null,
            ),
            const SizedBox(height: 17),
            Row(
              children: [
                Expanded(child: _fieldLabel('Nomor Handphone', null)),
                const Icon(Icons.lock, color: Colors.grey, size: 13),
                const SizedBox(width: 4),
                Text(
                  'Terkunci',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  Text(
                    '+62',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 1,
                    height: 22,
                    color: _muted.withValues(alpha: .2),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '812-3456-7890',
                      style: TextStyle(color: _muted, fontSize: 13),
                    ),
                  ),
                  Icon(Icons.lock_person, color: _muted, size: 18),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 6),
              child: Text(
                'Nomor utama Nusanet tidak dapat diubah',
                style: TextStyle(color: _muted, fontSize: 10),
              ),
            ),
            const SizedBox(height: 17),
            Row(
              children: [
                Expanded(child: _fieldLabel('Nomor Kontak Darurat', null)),
                const Text(
                  'Opsional',
                  style: TextStyle(color: Color(0xFF8E4E14), fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 7),
            _textField(
              controller: _emergency,
              icon: Icons.phone_outlined,
              hint: '8xx-xxxx-xxxx',
              keyboardType: TextInputType.phone,
              validator: (value) {
                final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
                return digits.isNotEmpty && digits.length < 8
                    ? 'Nomor kontak darurat belum valid'
                    : null;
              },
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF92EDFF),
                    child: Icon(Icons.two_wheeler, color: Color(0xFF006D7B)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kontak Pulih Darurat',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Untuk verifikasi dua langkah jika SIM gagal',
                          style: TextStyle(color: _muted, fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check, color: _primary, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 49,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: _primaryContainer,
                ),
                icon: _saving
                    ? const SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.done, size: 18),
                label: Text(
                  _saving ? 'Menyimpan...' : 'Simpan Perubahan',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              child: TextButton(
                onPressed: () => Navigator.maybePop(context),
                child: const Text(
                  'Batal',
                  style: TextStyle(
                    color: _primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _fieldLabel(String title, String? helper) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: TextStyle(
            color: _muted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      if (helper != null)
        Text(helper, style: TextStyle(color: _muted, fontSize: 9)),
    ],
  );

  Widget _textField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    Widget? suffix,
  }) => Container(
    height: 52,
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: .035), blurRadius: 8),
      ],
    ),
    child: TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(color: _ink, fontSize: 13),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: _muted, size: 19),
        suffixIcon: suffix,
        hintText: hint,
        hintStyle: TextStyle(color: _muted.withValues(alpha: .5), fontSize: 12),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        errorStyle: const TextStyle(fontSize: 0, height: 0),
      ),
    ),
  );

  void _chooseAvatar() => showModalBottomSheet<void>(
    context: context,
    backgroundColor: _card,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pilih Avatar',
              style: TextStyle(
                color: _ink,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 14,
              children: List.generate(
                _avatarIcons.length,
                (index) => InkWell(
                  onTap: () {
                    setState(() => _avatarIndex = index);
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: 27,
                    backgroundColor: _avatarIndex == index
                        ? _primaryContainer
                        : _soft,
                    child: Icon(
                      _avatarIcons[index],
                      color: _avatarIndex == index ? Colors.white : _primary,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    widget.onSave(
      _name.text.trim(),
      _email.text.trim(),
      _emergency.text.trim(),
      _avatarIndex,
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil Anda berhasil diperbarui!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showHelp() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Bantuan Profil'),
      content: const Text(
        'Perbarui nama, email, atau nomor darurat. Nomor utama Nusanet dikunci untuk melindungi akun.',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(backgroundColor: _primary),
          child: const Text('Mengerti'),
        ),
      ],
    ),
  );
}

class QuotaDetailsPage extends StatefulWidget {
  const QuotaDetailsPage({
    super.key,
    required this.dark,
    required this.remaining,
    required this.total,
    required this.addedQuota,
    required this.onViewPackages,
  });
  final bool dark;
  final double remaining;
  final double total;
  final double addedQuota;
  final VoidCallback onViewPackages;

  @override
  State<QuotaDetailsPage> createState() => _QuotaDetailsPageState();
}

class _TopUpOption {
  const _TopUpOption(
    this.nominal,
    this.price,
    this.admin,
    this.validity, {
    this.badge,
  });
  final int nominal;
  final int price;
  final int admin;
  final int validity;
  final String? badge;
}

class TopUpPage extends StatefulWidget {
  const TopUpPage({
    super.key,
    required this.dark,
    required this.currentBalance,
    required this.onTopUpSuccess,
  });
  final bool dark;
  final int currentBalance;
  final ValueChanged<int> onTopUpSuccess;

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  static const _options = [
    _TopUpOption(10000, 10500, 500, 7),
    _TopUpOption(25000, 25500, 500, 15),
    _TopUpOption(50000, 50000, 0, 30, badge: 'Populer'),
    _TopUpOption(100000, 99000, 0, 60, badge: 'Hemat Rp 1rb'),
  ];
  int _selected = 1;
  String _phone = '0812-3456-7890';
  bool _processing = false;
  Color get _ink => widget.dark ? Colors.white : _inkLight;
  static const _inkLight = Color(0xFF131B2E);
  Color get _muted => widget.dark ? Colors.white60 : const Color(0xFF3C4946);
  Color get _card => widget.dark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _soft =>
      widget.dark ? const Color(0xFF283044) : const Color(0xFFF2F3FF);
  _TopUpOption get _choice => _options[_selected];

  String _rupiah(int value) =>
      'Rp ${value.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.')}';
  String _short(int value) => value >= 100000 ? '100rb' : '${value ~/ 1000}rb';

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: widget.dark
        ? const Color(0xFF121212)
        : const Color(0xFFFAF8FF),
    appBar: AppBar(
      backgroundColor: widget.dark
          ? const Color(0xFF121212)
          : const Color(0xFFFAF8FF),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: Icon(Icons.arrow_back, color: _ink),
      ),
      title: Text(
        'Top Up Pulsa',
        style: TextStyle(
          color: _ink,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _help,
          icon: Icon(Icons.help_outline, color: _muted),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 14),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: _primary,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
        ),
      ],
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0x1A00A896),
                        child: Icon(Icons.contact_phone, color: _primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NOMOR TUJUAN',
                              style: TextStyle(
                                color: _muted,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: .8,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '$_phone  (Farhan)',
                              style: TextStyle(
                                color: _ink,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _changePhone,
                        style: TextButton.styleFrom(
                          backgroundColor: _card,
                          foregroundColor: _primary,
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(Icons.edit, size: 14),
                        label: const Text(
                          'Ganti',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _card.withValues(alpha: .8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          size: 16,
                          color: _primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Pulsa Saat Ini',
                            style: TextStyle(color: _muted, fontSize: 11),
                          ),
                        ),
                        Text(
                          _rupiah(widget.currentBalance),
                          style: const TextStyle(
                            color: _primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Pilih Nominal Pulsa',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _primary.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text(
                        'Instan 24 Jam',
                        style: TextStyle(
                          color: _primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'Pilih nominal pulsa resmi Nusanet langsung masuk tanpa jeda.',
                  style: TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _options.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 11,
                crossAxisSpacing: 11,
                // Keep enough vertical room for the 50rb admin-free label
                // and the price row, including on narrow phone screens.
                childAspectRatio: .9,
              ),
              itemBuilder: (context, index) => _nominalCard(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  Container(
                    width: 39,
                    height: 39,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDCC4),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.verified_user,
                      color: Color(0xFF6F3800),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Garansi Pengisian Pulsa Aman',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Pulsa gagal masuk? Pengembalian dana otomatis 100%.',
                          style: TextStyle(color: _muted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .035),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Ringkasan Pembayaran',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _primary.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'Masa Aktif +${_choice.validity} Hari',
                          style: const TextStyle(
                            color: _primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _summaryLine('Nominal Pulsa', _rupiah(_choice.nominal)),
                  const SizedBox(height: 9),
                  _summaryLine(
                    'Biaya Transaksi / Admin',
                    _choice.admin == 0
                        ? 'Gratis (Promo)'
                        : _rupiah(_choice.admin),
                  ),
                  const SizedBox(height: 13),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _soft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Pembayaran',
                                style: TextStyle(
                                  color: _muted,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Termasuk PPN',
                                style: TextStyle(color: _muted, fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _rupiah(_choice.price),
                          style: const TextStyle(
                            color: _primary,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 49,
                  child: FilledButton(
                    onPressed: _processing ? null : _checkout,
                    style: FilledButton.styleFrom(
                      backgroundColor: _primaryContainer,
                    ),
                    child: _processing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Lanjut ke Pembayaran',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 19),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Dengan melanjutkan, Anda menyetujui Syarat & Ketentuan Nusanet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _nominalCard(int index) {
    final option = _options[index];
    final selected = _selected == index;
    return InkWell(
      onTap: () => setState(() => _selected = index),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: selected ? _primary.withValues(alpha: .06) : _card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _primary : Colors.transparent,
            width: selected ? 2 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .035),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '+${option.validity} Hari',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (option.badge != null)
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: option.badge == 'Populer'
                            ? const Color(0xFFD08446)
                            : _primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        option.badge!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 5),
                Icon(
                  selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: selected ? _primary : _muted.withValues(alpha: .35),
                  size: 19,
                ),
              ],
            ),
            const Spacer(),
            Text(
              _short(option.nominal),
              style: TextStyle(
                color: _ink,
                fontSize: 29,
                height: 1.05,
                fontWeight: FontWeight.w800,
                letterSpacing: -.8,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              option.nominal == 100000 ? 'Diskon Spesial' : 'Pulsa Reguler',
              style: TextStyle(color: _muted, fontSize: 9),
            ),
            if (option.nominal == 50000)
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                  'Bebas Biaya Admin',
                  style: TextStyle(
                    color: _primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(
                children: [
                  Text('Harga', style: TextStyle(color: _muted, fontSize: 9)),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      _rupiah(option.price),
                      style: TextStyle(
                        color: _ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryLine(String label, String value) => Row(
    children: [
      Expanded(
        child: Text(label, style: TextStyle(color: _muted, fontSize: 11)),
      ),
      Text(
        value,
        style: TextStyle(
          color: _ink,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );

  void _changePhone() {
    final controller = TextEditingController(text: _phone);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ganti Nomor Tujuan'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Nomor handphone',
            prefixText: '+62 ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.replaceAll(RegExp(r'\D'), '').length < 8) return;
              setState(() => _phone = value);
              Navigator.pop(dialogContext);
            },
            style: FilledButton.styleFrom(backgroundColor: _primary),
            child: const Text('Simpan'),
          ),
        ],
      ),
    ).whenComplete(controller.dispose);
  }

  Future<void> _checkout() async {
    var method = 'ewallet';
    final success = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          title: const Text('Konfirmasi Top Up'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_rupiah(_choice.nominal)} pulsa ke $_phone',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 5),
              Text(
                'Total ${_rupiah(_choice.price)}',
                style: const TextStyle(
                  color: _primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Pilih metode pembayaran',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                dense: true,
                activeColor: _primaryContainer,
                value: 'ewallet',
                groupValue: method,
                onChanged: (value) => setDialog(() => method = value!),
                title: const Text('E-Wallet', style: TextStyle(fontSize: 13)),
              ),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                dense: true,
                activeColor: _primaryContainer,
                value: 'va',
                groupValue: method,
                onChanged: (value) => setDialog(() => method = value!),
                title: const Text(
                  'Virtual Account',
                  style: TextStyle(fontSize: 13),
                ),
              ),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                dense: true,
                activeColor: _primaryContainer,
                value: 'retail',
                groupValue: method,
                onChanged: (value) => setDialog(() => method = value!),
                title: const Text(
                  'Gerai Retail',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: _primaryContainer,
                foregroundColor: Colors.white,
                minimumSize: const Size(88, 44),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
              child: const Text('Bayar'),
            ),
          ],
        ),
      ),
    );
    if (success != true || !mounted) return;
    setState(() => _processing = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    widget.onTopUpSuccess(_choice.nominal);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Top up ${_rupiah(_choice.nominal)} berhasil!'),
      ),
    );
  }

  void _help() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Bantuan Top Up'),
      content: const Text(
        'Pilih nominal pulsa, periksa nomor tujuan dan total pembayaran, lalu pilih metode pembayaran untuk menyelesaikan transaksi.',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(backgroundColor: _primary),
          child: const Text('Mengerti'),
        ),
      ],
    ),
  );
}

class _QuotaDetailsPageState extends State<QuotaDetailsPage> {
  bool _refreshing = false;
  Color get _ink => widget.dark ? Colors.white : _inkLight;
  static const _inkLight = Color(0xFF131B2E);
  Color get _muted => widget.dark ? Colors.white60 : const Color(0xFF3C4946);
  Color get _card => widget.dark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _surface =>
      widget.dark ? const Color(0xFF283044) : const Color(0xFFEAEDFF);

  String _amount(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final mainRemaining = 12 + widget.addedQuota;
    final mainTotal = 20 + widget.addedQuota;
    final percent = (widget.remaining / widget.total).clamp(0.0, 1.0);
    return Scaffold(
      backgroundColor: widget.dark ? const Color(0xFF121212) : _surfaceLight,
      appBar: AppBar(
        backgroundColor: widget.dark ? const Color(0xFF121212) : _surfaceLight,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Quota Details',
          style: TextStyle(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _help(context),
            icon: Icon(Icons.help_outline, color: _muted),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: _primary,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: _primaryContainer,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Farhan',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '0812-3456-7890',
                          style: TextStyle(color: _muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.bolt, color: _primary, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4G LTE AKTIF',
                          style: TextStyle(
                            color: _primary,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: .6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withValues(alpha: .08),
                      blurRadius: 22,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL KUOTA TERSISA',
                                style: TextStyle(
                                  color: _muted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: .9,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    _amount(widget.remaining),
                                    style: const TextStyle(
                                      color: _primary,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '/ ${_amount(widget.total)} GB',
                                    style: TextStyle(
                                      color: _muted,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 68,
                          height: 68,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox.expand(
                                child: CircularProgressIndicator(
                                  value: percent,
                                  strokeWidth: 5,
                                  backgroundColor: _surface,
                                  color: _primaryContainer,
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                              Text(
                                '${(percent * 100).round()}%',
                                style: const TextStyle(
                                  color: _primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: percent,
                        minHeight: 9,
                        backgroundColor: _surface,
                        color: _primaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 15, color: _muted),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'Masa aktif hingga 28 Feb 2025',
                            style: TextStyle(color: _muted, fontSize: 10),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF00A896,
                            ).withValues(alpha: .13),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text(
                            'Aman',
                            style: TextStyle(
                              color: _primary,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _surface.withValues(alpha: .6),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _microStat(
                              Icons.calendar_today,
                              'Sisa Masa Aktif',
                              '14 Hari Lagi',
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 36,
                            color: _muted.withValues(alpha: .2),
                          ),
                          Expanded(
                            child: _microStat(
                              Icons.speed,
                              'Rata-rata/Hari',
                              '${_amount(widget.remaining / 14)} GB',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Rincian Paket',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            '3 Aktif',
                            style: TextStyle(
                              color: _muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _refresh,
                    icon: AnimatedRotation(
                      turns: _refreshing ? .5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(Icons.sync, color: _muted, size: 20),
                    ),
                    tooltip: 'Refresh kuota',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _quotaCard(
                    title: 'Kuota Utama',
                    badge: 'Reguler',
                    subtitle: '24 Jam di Semua Jaringan',
                    remaining: mainRemaining,
                    total: mainTotal,
                    expiry: 'Berlaku s/d: 28 Feb 2025, 23:59 WIB',
                    icon: Icons.public,
                    color: _primary,
                    chipIcon: Icons.event_available,
                  ),
                  const SizedBox(height: 12),
                  _quotaCard(
                    title: 'Kuota Aplikasi',
                    badge: null,
                    subtitle: 'WhatsApp, YouTube, Instagram',
                    remaining: 4.5,
                    total: 7,
                    expiry: 'Berlaku s/d: 28 Feb 2025, 23:59 WIB',
                    icon: Icons.apps,
                    color: const Color(0xFF006876),
                    chipIcon: Icons.event_available,
                  ),
                  const SizedBox(height: 12),
                  _quotaCard(
                    title: 'Kuota Bonus',
                    badge: 'Reward',
                    subtitle: 'Bonus Loyalitas / Weekend',
                    remaining: 2,
                    total: 3,
                    expiry: 'Kedaluwarsa: 21 Feb 2025, 23:59 WIB',
                    icon: Icons.redeem,
                    color: const Color(0xFFD08446),
                    chipIcon: Icons.alarm,
                    expiryBadge: '7 Hari Lagi',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.dark
                      ? const Color(0xFF263246)
                      : const Color(0xFFE2E7FF),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: _primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.trending_up,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kebutuhan kuota makin menipis?',
                                style: TextStyle(
                                  color: _ink,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Dapatkan paket booster add-on mulai dari Rp10.000 tanpa memotong masa aktif utamamu.',
                                style: TextStyle(
                                  color: _muted,
                                  fontSize: 11,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: FilledButton.icon(
                        onPressed: widget.onViewPackages,
                        style: FilledButton.styleFrom(
                          backgroundColor: _card,
                          foregroundColor: _primary,
                        ),
                        icon: const Icon(Icons.add_circle, size: 18),
                        label: const Text(
                          'Beli Kuota Tambahan',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.maybePop(context),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _surface,
                          foregroundColor: _ink,
                          side: BorderSide.none,
                        ),
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text(
                          'Kembali ke Beranda',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: FilledButton.icon(
                        onPressed: widget.onViewPackages,
                        style: FilledButton.styleFrom(
                          backgroundColor: _primaryContainer,
                        ),
                        icon: const Icon(Icons.shopping_bag, size: 18),
                        label: const Text(
                          'Lihat Paket Lain',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _surfaceLight = Color(0xFFFAF8FF);

  Widget _microStat(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Row(
      children: [
        Container(
          width: 31,
          height: 31,
          decoration: BoxDecoration(color: _surface, shape: BoxShape.circle),
          child: Icon(icon, color: _primary, size: 16),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: _muted, fontSize: 9)),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: _ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _quotaCard({
    required String title,
    required String? badge,
    required String subtitle,
    required double remaining,
    required double total,
    required String expiry,
    required IconData icon,
    required Color color,
    required IconData chipIcon,
    String? expiryBadge,
  }) {
    final fraction = (remaining / total).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .13),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 21),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: _ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: .12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                color: color,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        subtitle,
                        style: TextStyle(color: _muted, fontSize: 9),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _amount(remaining),
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '/ ${_amount(total)} GB',
                    style: TextStyle(color: _muted, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 7,
              backgroundColor: _surface,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(chipIcon, color: color, size: 14),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  expiry,
                  style: TextStyle(
                    color: expiryBadge == null ? _muted : color,
                    fontSize: 9,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (expiryBadge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    expiryBadge,
                    style: TextStyle(
                      color: color,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                Text(
                  '${(fraction * 100).round()}% Tersisa',
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _refresh() {
    setState(() => _refreshing = true);
    Future<void>.delayed(const Duration(milliseconds: 450), () {
      if (mounted) {
        setState(() => _refreshing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informasi kuota sudah diperbarui.')),
        );
      }
    });
  }

  void _help(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Tentang Rincian Kuota'),
      content: const Text(
        'Kuota menunjukkan sisa data yang dapat digunakan. Kuota bonus bisa memiliki masa berlaku yang berbeda dari kuota utama.',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(backgroundColor: _primary),
          child: const Text('Mengerti'),
        ),
      ],
    ),
  );
}
