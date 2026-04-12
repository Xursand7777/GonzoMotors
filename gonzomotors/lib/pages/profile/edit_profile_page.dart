import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gonzo_motors/features/profile/bloc/profile_bloc.dart';
import 'package:gonzo_motors/features/profile/data/models/user_model.dart';
import 'package:gonzo_motors/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';

import '../../core/route/route_names.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _dateController;
  late TextEditingController _emailController;
  String _gender = 'Мужчина';

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileBloc>().state;
    _nameController = TextEditingController(text: state.user?.firstName ?? '');
    _surnameController = TextEditingController(text: state.user?.lastName ?? '');
    _dateController = TextEditingController(text: state.user?.birthDate ?? '');
    _emailController = TextEditingController(text: state.user?.email ?? '');
    _gender = state.user?.gender ?? 'Мужчина';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _dateController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Мои данные',
          style: TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black).copyWith(
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status.isSuccess()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Данные успешно сохранены")),
            );
            context.pop();
          } else if (state.status.isError()) {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Произошла ошибка")),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        _buildTextField(
                          label: 'Имя',
                          controller: _nameController,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Фамилия',
                          controller: _surnameController,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Дата рождения',
                          controller: _dateController,
                          icon: 'calendar',
                        ),
                        const SizedBox(height: 16),
                        _buildPhoneField(state.user?.phone),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownField(
                          label: 'Пол',
                          value: _gender,
                          items: ['Мужчина', 'Женщина'],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _gender = val;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final updatedUser = {
                            "first_name": _nameController.text.trim(),
                            "last_name": _surnameController.text.trim(),
                            "birth_date": _dateController.text.trim(),
                            "email": _emailController.text.trim(),
                            "gender": _gender,
                            "phone": state.user?.phone,
                          };

                          // Assuming there's an UpdateUserProfileEvent in Bloc
                          context.read<ProfileBloc>().add(
                                UpdateUserProfileEvent(updatedUser),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Save changes',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white).copyWith(
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xff797979)),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffD2D9E3)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black).copyWith(letterSpacing: -0.3),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              isDense: true,
              suffixIcon: icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Assets.icons.calendar.image(width: 24, height: 24)
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField(String? phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Номер телефона',
          style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xff797979)),
        ),
        const SizedBox(height: 8),
        Container(
           decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffD2D9E3)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: const BoxDecoration(
                    border: Border(right: BorderSide(color: Color(0xffD2D9E3))),
                  ),
                  child: Text(
                    '+998',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black).copyWith(letterSpacing: -0.3),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                  child: Text(
                     phone != null && phone.startsWith('+998') ? phone.substring(4) : (phone ?? '( _ _ ) _ _ _  _ _  _ _'),
                     style: phone != null ? TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black) : TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xff797979)).copyWith(letterSpacing: -0.3),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xff797979)),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffD2D9E3)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
              style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black).copyWith(letterSpacing: -0.3),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(item),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
