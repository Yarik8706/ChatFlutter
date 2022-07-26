import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(String email, String password, String username, String imageData, bool isLogin, BuildContext context) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  String _confirmUserPassword = '';
  String _imageData = '';

  @override
  void initState() {
    // TODO: implement initState

  }

  void _saveImageData(String base64data){
    _imageData = base64data;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(_imageData == '' && !_isLogin){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Пожалуйста выбирите фотографию.'),
          backgroundColor: Theme.of(context).errorColor,
        )
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
          _userEmail.trim(),
          _userPassword.trim(),
          _userName.trim(),
          _imageData,
          _isLogin,
         context
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLogin ? const Text('Ввойдите в аккаунт',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold)
                  ) : UserImagePicker(_saveImageData),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      return (value == null || value == '' || !value.contains('@')) ? 'Укажите правильную электронную почту' : null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Электронная почта',
                    ),
                  ),
                  _isLogin ? Container() : TextFormField(
                    key: ValueKey('username'),
                    validator: (String? value) {
                      return (value == null || value.length < 4) ? 'Никней должен быть больше 4 символов' : null;
                    },
                    onSaved: (value) {
                      _userName = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Никнейм',
                    ),
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (String? value) {
                      return (value == null || value.length < 7) ? 'Пароль должен быть больше 7 символов' : null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                    onChanged: (value) {
                      _confirmUserPassword = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Пароль',
                    ),
                    obscureText: true,
                  ),
                  _isLogin ? Container() : TextFormField(
                    validator: (String? value) {
                      if(_confirmUserPassword == '') return 'Придумайте и потвердите пароль';
                      return (value != _confirmUserPassword) ? 'Пароли не совпадают' : null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Повторите пароль',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  widget.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _trySubmit,
                    child: Text(_isLogin ? 'Авторизоваться' : 'Зарегестрироваться'),
                  ),
                  widget.isLoading ? Container() : OutlinedButton(
                    child: Text(_isLogin ? 'Создать новый аккаунт' : 'У меня уже есть аккаунт'),
                    onPressed: () => {
                      setState(() {
                        _isLogin = !_isLogin;
                      })
                    }
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
