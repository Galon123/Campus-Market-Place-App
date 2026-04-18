import 'package:dio/dio.dart';
import 'package:e_commerce_refactor/models/Product.dart';
import 'package:e_commerce_refactor/services/ApiClient.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProvider extends ChangeNotifier{

  String _username = "Guest";
  String _email = "";
  String _phoneNo = "";
  double _rating = 0.0;
  String _profilePicPath = '';


  bool _isLoading = false;
  bool _isUserLoading = false;
  bool _isProductLoading = false;
  bool _isBidsLoading = false;

  bool _isLoggedIn = false;

  List<Product> _products = [];
  bool _hasMoreProducts = true;
  int _productSkip = 0;
  final int _productLimit = 10;

  List<dynamic> _myProducts = [];
  bool _hasMoreListings = true;
  int _listingSkip = 0;
  final int _listingLimit = 10;

  List<dynamic> _bids = [];
  bool _hasMoreBids = true;
  int _bidsSkip = 0;
  final int _bidsLimit = 10;

  //Getters
  String get username => _username;
  String get email => _email;
  String get phoneNo => _phoneNo;
  double get rating => _rating;
  String get profilePicPath => _profilePicPath;

  bool get isLoading => _isLoading;
  bool get isUserLoading => _isUserLoading;
  bool get isProductLoading => _isProductLoading;
  bool get isBidsLoading => _isBidsLoading;  

  bool get isLoggedIn => _isLoggedIn;
  
  List<Product> get products => List.unmodifiable(_products);
  bool get hasMoreProducts => _hasMoreProducts;

  List<Product> get myProducts => List.unmodifiable(_myProducts);

  List<dynamic> get bids => List.unmodifiable(_bids);
  bool get hasMoreBids => _hasMoreBids;

  UserProvider({bool initialLoginState = false}){
    if(initialLoginState){
      _isLoggedIn = true;
      refreshUsername();
    }
  }


  Future<bool> register(String user, String email, String phoneNo, String password) async{
    _isLoading = true;
    notifyListeners();
    try{
      final regResponse = await Apiclient.dio.post('/register', 
      data: {
        'username':user,
        'email': email,
        'phone_no': phoneNo,
        'password': password 
      }
    );

    if(regResponse.statusCode == 200){
      return true;
    }
    return false;
    } catch(e) {
      debugPrint("Error in Registering");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String user, String pass) async{
    _isLoading = true;
    notifyListeners();
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
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUsername() async{
    _isUserLoading = true;
    notifyListeners();

    try{
      final response = await Apiclient.dio.get('/profile/');

      if(response.statusCode == 200){
        _username = response.data['username'];
        _email = response.data['email'];
        _phoneNo = response.data['phone_no'];
        _rating = response.data['rating'];
        _profilePicPath = response.data['image_path'] ?? '';
        notifyListeners();
      }
    } catch(e){
      debugPrint("Error Refreshing Username : $e");
    } finally{
      _isUserLoading = false;
      notifyListeners();
    }

  }

  Future<void> logout() async {
    try {
      await Apiclient.dio.post('/logout');
    } catch(e) {
      debugPrint("Error in logout...Logging Out Anyway....");
    } finally {
      _isLoggedIn = false;
      _username = "Guest";
      _email = "";
      _phoneNo = "";
      _rating = 0.0;

      _products = [];
      _productSkip =0;

      _bids = [];
      _bidsSkip = 0;
            
      Apiclient.cookieJar.deleteAll();
      notifyListeners();
    }
  }

  Future<void> fetchProducts() async{

    if(_isProductLoading || !hasMoreProducts) return;

    _isProductLoading = true;
    notifyListeners();

    try{
      final response = await Apiclient.dio.get('/items/feed?skip=$_productSkip&limit=$_productLimit');

      if(response.statusCode == 200){
        final List<dynamic> data = response.data ;
        
        if (data.isEmpty) {
          _hasMoreProducts = false;
        } else {
          final List<Product> newItems = data.map((json) => Product.fromJson(json)).toList();
          _products.addAll(newItems);
          _productSkip += _productLimit;
          if(data.length < _productLimit){
            _hasMoreProducts = false;
          }

          _myProducts = products.where((product) => product.seller.username == username).toList();
        }
      }
    } catch (e) {
      debugPrint("Error Fetching data : $e");
      _hasMoreProducts = false;
    } finally{
      _isProductLoading = false;
      notifyListeners();
    }

  }

  Future<void> refreshFeed() async{

    _isProductLoading = false;

    _products = [];
    _productSkip = 0;
    _hasMoreProducts = true;

    notifyListeners();

    await fetchProducts();
  }

  Future<void> fetchBids() async{

    if(_isBidsLoading || !hasMoreBids) return;

    _isBidsLoading = true;
    notifyListeners();

    try{
      final response = await Apiclient.dio.get('/items/bided_items?skip=$_bidsSkip&limit=$_bidsLimit');

      if(response.statusCode == 200){
        final List<dynamic> data = response.data;
        
        if (data.isEmpty) {
          _hasMoreBids = false;
        } else {
          final List<dynamic> newBids = data.map((json) => Product.fromJson(json)).toList();
          _bids.addAll(newBids);
          _bidsSkip += _bidsLimit;
          if(data.length < _bidsLimit){
            _hasMoreBids = false;
          }
        }
      }
    } catch (e) {
      debugPrint("Error Fetching data : $e");
      _hasMoreBids = false;
    } finally{
      _isBidsLoading = false;
      notifyListeners();
    }

  }

  Future<void> uploadImage(int item_id, XFile? image) async{

    try{

      FormData formData = FormData.fromMap({
        "image" : await MultipartFile.fromFile(
          image!.path,
          filename: image.name
        )
      });

      final response = await Apiclient.dio.post(
        '/images/$item_id', 
        data: formData,
        options: Options(
          contentType: 'multipart/form-data'
        )
      );

      if(response.statusCode == 200){
        debugPrint("Image Uploaded Successfully");
      }
    } catch(e) {
      debugPrint("Error uploading image");
    }
  }

  Future<void> uploadProfilPic(XFile image) async{

    try{

      FormData formdata = FormData.fromMap({
        "image" : await MultipartFile.fromFile(
          image.path,
          filename: image.name
        )
      });

      final response = await Apiclient.dio.post(
        '/profile/image', 
        data: formdata,
        options: Options(
          contentType: 'multipart/form-data'
        )
      );

      Future.delayed(const Duration(seconds: 2), () => refreshUsername());

    } catch (e) {
      debugPrint("Error uploading Profile Picture....");
    }
  }

  Future<bool> createItem(XFile? image, String title, double price, int quantity, String condition, String desc, List<String> categories) async{

    _isLoading = true;
    notifyListeners();

    try{
      final response = await Apiclient.dio.post('/items/create', data: {
        "title" : title,
        "description" : desc,
        "min_price" : price,
        "quantity" : quantity,
        "condition" : condition,
        "categories" : categories
      });

      if(response.statusCode == 200){

        final itemId = response.data["id"];
        uploadImage(itemId, image);
        return true;
      }
      return false;
    } catch(e) {
      debugPrint("Error in Item Creation");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}