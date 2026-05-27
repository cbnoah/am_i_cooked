import 'package:flutter/material.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _oldEmailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _confirmEmailController =
  TextEditingController();

  @override
  void dispose() {
    _oldEmailController.dispose();
    _newEmailController.dispose();
    _confirmEmailController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_oldEmailController.text.isEmpty ||
        _newEmailController.text.isEmpty ||
        _confirmEmailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
        ),
      );
      return;
    }

    if (_newEmailController.text != _confirmEmailController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Les nouveaux emails ne correspondent pas'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Modification bientôt disponible'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHigh,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Email',
          style: TextStyle(
            fontFamily: 'bbh_sans_hegarty',
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label(context, 'ANCIEN EMAIL'),
              const SizedBox(height: 10),
              _input(
                context,
                controller: _oldEmailController,
                hint: 'ancien@email.com',
                icon: Icons.alternate_email_rounded,
              ),

              const SizedBox(height: 24),

              _label(context, 'NOUVEL EMAIL'),
              const SizedBox(height: 10),
              _input(
                context,
                controller: _newEmailController,
                hint: 'nouveau@email.com',
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 24),

              _label(context, 'CONFIRMER LE NOUVEL EMAIL'),
              const SizedBox(height: 10),
              _input(
                context,
                controller: _confirmEmailController,
                hint: 'nouveau@email.com',
                icon: Icons.check_circle_outline,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    'Enregistrer',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

  Widget _label(BuildContext context, String text) {
    final cs = Theme.of(context).colorScheme;

    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: cs.onSurfaceVariant,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _input(
      BuildContext context, {
        required TextEditingController controller,
        required String hint,
        required IconData icon,
      }) {
    final cs = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        fontFamily: 'Nunito',
        color: cs.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}