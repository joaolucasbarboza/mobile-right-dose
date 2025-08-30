// todo: implementar a busca de todas as doenças do usuário
// todo: implementar a adicição de N doenças ao usuário
//  dependendo do quantas doenças, tem que ser proporcional POST no backend. Fazer um for talvez?

import 'package:flutter/material.dart';
import 'package:tcc/data/services/user_service.dart';

import '../../../models/user.dart';

class GetUserViewModel extends ChangeNotifier {
  final UserService _userService;

  GetUserViewModel(
    this._userService,
  );

  bool isLoading = false;
  User _user = User(userId: '', name: '', email: '', role: '');

  User get user => _user;

  Future<void> fetchUser() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _userService.getDetailsUser();
      _user = User.fromJson(response);
    } catch (e) {
      debugPrint("Erro ao buscar o usuário: $e\n");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
