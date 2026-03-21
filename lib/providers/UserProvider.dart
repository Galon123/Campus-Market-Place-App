import 'package:dio/dio.dart';
import 'package:e_commerce_refactor/services/ApiClient.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{

  String _username = "Guest";
  String _email = "";
  String _phoneNo = "";
  double _rating = 0.0;

  bool _isLoading = false;
  bool _isUserLoading = false;

  bool _isLoggedIn = false;

  List<dynamic> _products = [];

  //Getters
  String get username => _username;
  String get email => _email;
  String get phoneNo => _phoneNo;
  double get rating => _rating;

  bool get isLoading => _isLoading;
  bool get isUserLoading => _isUserLoading;

  bool get isLoggedIn => _isLoggedIn;
  
  List<dynamic> get products => _products;

  UserProvider({bool initialLoginState = false}){
    if(initialLoginState){
      _isLoggedIn = true;
      refreshUsername();
    }
  }


  Future<bool> login(String user, String pass) async{
    _setLoading(true);
    try{
      final response = await Apiclient.dio.post('/login',data:FormData.fromMap({
        "username" : user,
        "password" : pass
      }));

      if(response.statusCode == 200){
        _isLoggedIn = true;
        notifyListeners();
        await refreshUsername();
        return true;
      }
      return false;
    }
    catch (e){
      debugPrint("Error Logging in : $e");
      return false;
    }
    finally{
      _setLoading(false);
    }
  }

  Future<void> refreshUsername() async{
    _setUserLoading(true);

    try{
      final response = await Apiclient.dio.get('/me');

      if(response.statusCode == 200){
        _username = response.data['username'];
        _email = response.data['email'];
        _phoneNo = response.data['phone_no'];
        _rating = response.data['rating'];
        notifyListeners();
      }
    } catch(e){
      debugPrint("Error Refreshing Username : $e");
    } finally{
      _setUserLoading(false);
    }

  }

  Future<void> logout() async {
    try {
      await Apiclient.dio.post('/logout');
    } catch(e) {
      debugPrint("Error in logout...");
    } finally {
      _isLoggedIn = false;
      _username = "Guest";
      _products = [];
      Apiclient.cookieJar.deleteAll();
      notifyListeners();
    }
  }

  void _setLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  void _setUserLoading(bool value){
    _isUserLoading = value;
    notifyListeners();
  }

}