import 'package:flutter/material.dart';
class CustomTextFormField extends StatelessWidget {
  final String title;
  final bool isRequired;
  final String hint;
  final IconData? hinticon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  const CustomTextFormField({
    super.key,
    required this.title,
    this.isRequired = false,
    required this.hint,
    this.hinticon,
    required this.controller,
    this.validator,
    this.obscureText = false,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              if (isRequired)
                const Icon(Icons.star, color: Colors.red, size: 10),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            keyboardType: keyboardType,

            decoration: InputDecoration(
              hint: Row(
                
                children: [
                   Icon(hinticon, color: Colors.grey, size: 12),
                   SizedBox(width: 8),
                  Text(hint, style: const TextStyle(color: Colors.grey)),
                 
                 
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
