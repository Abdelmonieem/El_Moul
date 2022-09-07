import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:el_moul/applocal.dart';
import 'package:el_moul/layouts/home_cubit/home_states.dart';
import 'package:el_moul/main.dart';
import 'package:el_moul/models/categories_model/categories_model.dart';
import 'package:el_moul/models/categories_model/parent_categories_model.dart';
import 'package:el_moul/models/get_productby_id/poductById_model.dart';
import 'package:el_moul/models/recentlyadded_model/recentlyAdded_model.dart';
import 'package:el_moul/models/search_model/search_data_model.dart';
import 'package:el_moul/models/search_model/search_model.dart';
import 'package:el_moul/models/similarProduct_model/similarPrduct_model.dart';
import 'package:el_moul/models/wishList_model/wishList_model.dart';
import 'package:el_moul/modules/cart_screen/cart_screen.dart';
import 'package:el_moul/modules/deliver_screen/delivery_screen.dart';
import 'package:el_moul/modules/login_screen/login_screen.dart';
import 'package:el_moul/modules/main_screen/main_screen.dart';
import 'package:el_moul/modules/search_screen/search_screen.dart';
import 'package:el_moul/modules/wishlist_screen/wishlist_screen.dart';
import 'package:el_moul/shared/local/shared_preference.dart';
import 'package:el_moul/shared/network/api_constants.dart';
import 'package:el_moul/shared/network/dio_helper.dart';
import 'package:el_moul/shared/resources/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitialHomeState());

  static HomeCubit get(context) => BlocProvider.of(context);

  //drawer////////////////////////////////////////////////////////////////////
  int drawerindex = -1;

  changeDrawer(int index) {
    drawerindex = index;
    emit(ChangeDrawerState());
  }

  changeLanguage(BuildContext context, Locale locale) async {
    if (locale.languageCode == 'ar') {
      MyApp.setLocale(context, Locale('en', ''));
      await SharedPref.putData('lang', 'en');
      emit(EnglishLanguageSelected());
    } else {
      MyApp.setLocale(context, Locale('ar', ''));
      await SharedPref.putData('lang', 'ar');
      emit(ArabicLanguageSelected());
    }
    print('languageCode is ${locale.languageCode}');
    Phoenix.rebirth(context);
  }

  //settings Screen //////////////////////////////////////////////////////////////////////////////
  TextEditingController profileFullNameController = TextEditingController();
  TextEditingController profileUserNameController = TextEditingController();
  TextEditingController profilePasswordController = TextEditingController();
  TextEditingController profileConfirmPasswordController =
      TextEditingController();
  TextEditingController profileEmailController = TextEditingController();
  TextEditingController profileMobileController = TextEditingController();
  TextEditingController profileAddressController = TextEditingController();
  TextEditingController profileBuildingNumberController =
      TextEditingController();
  bool profileShowChangePassword = false;
  bool profileShowChangeMobile = false;
  String profileSelectCity = 'mansoura';

  profileShowPasswordChange() {
    profileShowChangePassword = !profileShowChangePassword;
    emit(ProfileShowPasswordChange());
  }

  profileShowMobileChange() {
    profileShowChangeMobile = !profileShowChangeMobile;
    emit(ProfileShowMobileChange());
  }

  //LoginScreen scetion/////////////////////////////////////////////////////////////////////////
  final loginkey = GlobalKey<FormState>();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController LoginPasswordController = TextEditingController();
  bool loginObsecurePassword = true;

  gotoLoginScreen(int index) {
    bottomNavIndex = index;
    emit(GoToLoginScreen());
  }

  login() {
    isLogedIn = true;
    bottomNavIndex = 0;
    emit(LoginSuccess());
  }

  logout() {
    isLogedIn = false;
    bottomNavIndex = 0;
    emit(LoginSuccess());
  }

  loginChangePasswordVisibilty() {
    loginObsecurePassword = !loginObsecurePassword;
    emit(LoginchangePasswordVisibilty());
  }

  //SignUpScreen scetion/////////////////////////////////////////////////////////////////////////
  final signupkey = GlobalKey<FormState>();
  String downbuttonval = 'mansoura';
  FocusNode singUpUserNameFocusNode = FocusNode();
  FocusNode singUpPasswordFocusNode = FocusNode();
  FocusNode singUpPasswordConfirmFocusNode = FocusNode();
  FocusNode singUpUserEmailNode = FocusNode();
  FocusNode singUpMobilFocusNode = FocusNode();
  FocusNode singUpSelectCityFocusNode = FocusNode();
  FocusNode singUpBuildingNumberFocusNode = FocusNode();
  TextEditingController signUppasswordController = TextEditingController();
  TextEditingController signUpFullNameController = TextEditingController();
  TextEditingController signUpUserNameController = TextEditingController();
  TextEditingController signUppasswordConfirmController =
      TextEditingController();
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpMobileController = TextEditingController();
  TextEditingController signUpSelectCityController = TextEditingController();
  TextEditingController signUpBuildingNumberController =
      TextEditingController();
  bool signUpObsecurePassword = true;

  signUpChangePasswordVisibilty() {
    signUpObsecurePassword = !signUpObsecurePassword;
    emit(LoginchangePasswordVisibilty());
  }

  signUpsetDropDownval(String value) {
    downbuttonval = value;
    emit(SignUpDropDwonVal());
  }

  // home page///////////////////////////////////////////////////////////////////////////////////
  String homeData = '';
  List<CachedNetworkImage> sliderImagesList = [];
  static late bool isLogedIn;

  getLogedInState() async {
    isLogedIn = await SharedPref.getData('isLogedIn');
    Lang = await SharedPref.getData('lang');
  }

  //CoursalSlider section
  int indicatorIndex = 0;
  bool categorisDataLoading = false;

  getHomeSliderData() async {
    emit(HomeSliderLoading());
    await DioHelper.getData(
      url: ApiConstants.getHomeSliderImages,
      query: {
        'AdvType': 'HomePageSlides',
        'LanguageCode': 'en-us',
      },
    ).then((value) {
      if (value == null) print('value is null');
      value.data.forEach((element) {
        // print('element : $element');
        // print('www.elmoul.com/' + element['url']);
        sliderImagesList.add(CachedNetworkImage(
          imageUrl: 'https://elmoul.com/${element['url']}',
          // placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ));
        // sliderImagesList.add(Image(
        //   image: NetworkImage('https://elmoul.com/${element['url']}'),
        //   fit: BoxFit.cover,
        // ));
      });

      emit(HomeSliderSuccess());
    }).catchError((error) {
      emit(HomeSliderError());
      print('error at gettingHome slider $error');
    });
  }

  changeLoading() {
    categorisDataLoading = !categorisDataLoading;
    emit(LoadingState());
  }

  changeIndicator(index) {
    this.indicatorIndex = index;
    emit(SliderIndecatorChangeState());
  }

  changestate() {
    emit(successStat());
  }

  //parent Categories Section
  ParentCategoriesModel parentCategoriesModel = ParentCategoriesModel();

  getParentCategories() async {
    emit(GetParentCategoriesDataLoading());
    await DioHelper.getData(
      url: ApiConstants.ParentCategories,
    ).then((value) {
      parentCategoriesModel = ParentCategoriesModel.fromJson(value.data);
      emit(GetParentCategoriesDataSuccess());
    }).catchError((error) {
      loadingCateg = false;
      emit(GetParentCategoriesDataError());
      print('error at getting GetParentCategoriesData data $error');
    });
  }

  // categories Section
  List<dynamic> data = [];
  bool loadingCateg = true;
  CategoriesModel categoriesModel = CategoriesModel();

  getCategories() async {
    emit(GetCategoriesDataLoading());
    await DioHelper.getData(
      url: ApiConstants.ActiveCategories,
    ).then((value) {
      data = value.data;
      loadingCateg = false;
      emit(GetCategoriesDataSuccess());
      categoriesModel = CategoriesModel.fromJson(value.data);
    }).catchError((error) {
      loadingCateg = false;
      emit(GetCategoriesDataError());
      print('error at getting categoris data $error');
    });
  }

  //get home Recently Added data
  RecentlyAddedModel recentlyAddedModel = RecentlyAddedModel();

  getRecentlyAddedProducts() async {
    emit(RecentlyAddedLoading());
    await DioHelper.getData(
      url: ApiConstants.getRecentlyAdded,
      query: {
        'LanguageCode': 'en-us',
      },
    ).then((value) {
      if (value == null) print('value is null');
      recentlyAddedModel = RecentlyAddedModel.fromJson(value.data);
      emit(RecentlyAddedSuccess());
    }).catchError((error) {
      emit(RecentlyAddedError());
      print('error at getting RecentlyAddProduct data $error');
    });
  }

  // bottomNavigation items
  List<Widget> bodyList = [
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    DeliveryScreen(),
  ];
  List<Widget> bodyListNotLogedIn = [
    HomeScreen(),
    SearchScreen(),
    LoginScreen()
  ];

  List<Widget> getBodyList() {
    return isLogedIn
        ? [
            HomeScreen(),
            SearchScreen(),
            CartScreen(),
            DeliveryScreen(),
          ]
        : [
            HomeScreen(),
            SearchScreen(),
            LoginScreen(),
          ];
  }

  int bottomNavIndex = 0;
  List<BottomNavigationBarItem> bottomNavList = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'search',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_shopping_cart),
      label: 'cart',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.delivery_dining),
      label: 'deliver',
    ),
  ];

  List<BottomNavigationBarItem> getBottomNavList() {
    return isLogedIn
        ? [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              label: 'cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delivery_dining),
              label: 'deliver',
            ),
          ]
        : [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: 'Login',
            ),
          ];
  }

  changeBottomNav(int index) {
    bottomNavIndex = index;
    emit(changeBottomNavState());
  }

  //SearchScreen //////////////////////////////////////////////////////////////////////////////
  bool showFilter = false;

  showFilters() {
    showFilter = !showFilter;
    emit(SearchShowFilter());
  }

  TextEditingController searchProductName = TextEditingController();
  TextEditingController searchPriceFrom = TextEditingController();
  TextEditingController searchPriceTo = TextEditingController();
  late String sectionID = '';
  late String sectionName = '';
  late int priceFrom = 0;
  late String priceFromText = '0';
  late int priceTo = 5000;
  late String priceToText = '5000';
  late int MinimumRate = 0;
  int searchRecentlyAddDays = 360;
  late int countPerPage;
  late int pageNumber = 1;
  SearchModel searchModel = SearchModel();

  searchChangingSection(String name) {
    sectionName = name;
    emit(SearchChangingSection());
  }

  searchChangingFromPrice(String name) {
    if (name.isNotEmpty) {
      if (int.parse(name) < priceTo && int.parse(name) >= 0) {
        searchPriceFrom.text = name;
        priceFromText = name;
        priceFrom = int.parse(name);
        emit(SearchChangingFromPrice());
      }
    }
  }

  searchChangingToPrice(String name) {
    if (name.isNotEmpty) {
      if (int.parse(name) > priceFrom && int.parse(name) > 0) {
        searchPriceTo.text = name;
        priceToText = name;
        priceTo = int.parse(name);
        emit(SearchChangingToPrice());
      }
    }
  }

  searchChangingRecently(int days) {
    searchRecentlyAddDays = days;
    emit(SearchChangingRecently());
  }

  bool loadingSearch = false;

  getData() {
    SearchData searchData = SearchData(
      countPerPage: 10,
      minimumRate: MinimumRate,
      priceFrom: priceFrom,
      priceTo: priceTo,
      pageNumber: 1,
      recentDays: searchRecentlyAddDays,
      searchText: searchProductName.text,
      sectionId: sectionID,
    );
    // print(searchData.toMap());
    searchData.priceFrom = priceFrom;
    searchData.priceTo = priceTo;
    searchData.sectionId = sectionID;
    searchData.pageNumber = pageNumber;
    searchData.searchText = searchProductName.text;
    searchData.recentDays = searchRecentlyAddDays;
    searchData.minimumRate = MinimumRate;
    getSearch(searchData);
  }

  getSearch(SearchData searchData) async {
    emit(GetSearchLoading());
    await DioHelper.dio
        .post(ApiConstants.search, data: searchData.toMap())
        .then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(GetSearchSuccess());
    }).catchError((error) {
      print('error at search ${error}');
      emit(GetSearchError());
    });
  }

  // Product Item View ////////////////////////////////////////////////////////////////////////////
  int productItemIndecator = 0;
  TextEditingController reviewController = TextEditingController();
  int productQuantity = 0;
  List<bool> chooseSize = [];

  List<bool> chooseColor = [];

  bool loadingProductItemView = true;

  resetProductSize() {
    productByIdModel.productOptionsList!.forEach((element) {
      for (int i = 0; i < element.selectedItemlist.length; i++) {
        element.selectedItemlist[i] = false;
      }
    });
    emit(ResetProductSizeState());
  }

  changeProductSize(int index, int index3) {
    print(chooseSize.length);
    for (int i = 0;
        i <
            productByIdModel
                .productOptionsList![index3].selectedItemlist.length;
        i++) {
      productByIdModel.productOptionsList![index3].selectedItemlist[i] = false;
    }
    productByIdModel.productOptionsList![index3].selectedItemlist[index] = true;
    emit(ChangeProductSizeState());
  }

  addProductQuantity() {
    productQuantity++;
    emit(ChangeProductQuantityState());
  }

  removeProductQuantity() {
    if (productQuantity > 0) {
      productQuantity--;
      emit(ChangeProductQuantityState());
    }
  }

  changeProductItemIndicator(index) {
    productItemIndecator = index;
    emit(ProductItemIndecatorState());
  }

  String value = 'fb07c895-976d-45e7-aefd-f892ddd89ee8';
  ProductByIdModel productByIdModel = ProductByIdModel();
  static String Lang = '';

  getItemProductById() async {
    print('language is $Lang');

    loadingProductItemView = true;
    emit(GetPorductByIDDataLoading());
    await DioHelper.getData(
      url: ApiConstants.getProductByID + value,
      query: {
        'LanguageCode': Lang.isNotEmpty
            ? Lang == 'en'
                ? 'en-us'
                : 'ar-eg'
            : 'en_us',
      },
    ).then((value) async {
      if (value == null) print('value is null');
      productByIdModel = ProductByIdModel.fromJson(value.data);
      // loadingProductItemView = false;
      await getSimilarProducts();
      emit(GetPorductByIDDataSuccess());
      // chooseProductSize();
    }).catchError((error) {
      // loadingProductItemView = false;
      emit(GetPorductByIDDataError());
      print('error at getting product data $error');
    });
  }

  //post Reviews
  late int rating;

  postReview(String id, String text) async {
    await DioHelper.dio.post(
        'https://www.elmoul.com/api/Products/AddNewReview?LanguageCode=en-us',
        data: {
          "id": "00000000-0000-0000-0000-000000000000",
          "text": text,
          "starsCount": rating,
          "productId": "$id",
        }).then((value) async {
      await getItemProductById();
    }).catchError((error) {
      print('error at postig reive' + error.toString());
    });
  }

  //similar products
  SimilarItemModel similarProducts = SimilarItemModel();

  bool notSimilarData = true;

  getSimilarProducts() async {
    emit(getSimilarProductsLoading());
    await DioHelper.getData(
      url: ApiConstants.getSimilarProducts,
      query: {
        'ProductId': productByIdModel.id,
        'Count': 6,
      },
    ).then((value) {
      if (value == null) print('value is null');
      print('success similar Data');
      if (value.data.length == 0) {
        notSimilarData = true;
      } else {
        similarProducts = SimilarItemModel.fromJson(value.data);
        notSimilarData = false;
      }
      // if(value.data.isNotEmpty()){
      //   print('data is not empty');
      // }
      // print(similarProducts.similarItemList[0].arabicName);
      emit(getSimilarProductsSuccess());
    }).catchError((error) {
      emit(getSimilarProductsError());
      print('error at getting Similar product data $error');
    });
  }

  //Show all RecentlyAdded products //////////////////////////////////////////////////////////////////////////

  bool isloading = false;
  bool isMoreData = true;
  late int oldlegnth = 0;
  late int newlegnth;
  bool recentlydataloaded = false;
  int recentlypage = 0;
  RecentlyAddedModel showAllRecentlyProducts = RecentlyAddedModel();
  RecentlyAddedModel allRecentlyProducts = RecentlyAddedModel();

  getallRecentlydata() {
    allRecentlyProducts.recentlyAddedList
        .addAll(showAllRecentlyProducts.recentlyAddedList);
    newlegnth = allRecentlyProducts.recentlyAddedList.length;
    if (oldlegnth == newlegnth) {
      isMoreData = false;
    } else {
      oldlegnth = newlegnth;
    }
    isloading = false;
    emit(getAllRecentlyData());
  }

  showallRecentlyProducts() async {
    isloading = true;
    emit(allRecentlyAddedLoading());
    await DioHelper.getData(
      url: 'Api/Products/GetProductsByArea/RecentlyAdded/8/$recentlypage',
      query: {
        'LanguageCode': 'en-us',
      },
    ).then((value) async {
      if (value == null) print('value is null');
      print('show all recentyl success');
      if (value.data.length > 2) {
        print(value.data.length.toString());
        showAllRecentlyProducts = await RecentlyAddedModel.fromJson(value.data);
        recentlydataloaded = true;
        recentlypage++;
        getallRecentlydata();
      }

      emit(allRecentlyAddedSuccess());
    }).catchError((error) {
      recentlydataloaded = true;
      emit(allRecentlyAddedError());
      print('error at show all recently  data $error');
    });
  }

  //WishList Screen ////////////////////////////////////////////////////////////////////////////////////
  WishListModel wishListModel = WishListModel();
  late int wishListLength;
  final wishListFormKey = GlobalKey<FormState>();

  String choosenWishListName = 'myFavorites';
  String choosenWishListId = '';
  String seletWishList = 'seletWishList';
  bool wishListLoading = false;
  TextEditingController wishListController = TextEditingController();

  changechoosenWishListName(String value) {
    choosenWishListName = value;
    emit(ChoosenWishListNameState());
  }

  changechoosenWishListId(String value) {
    choosenWishListId = value;
    emit(ChoosenWishListIdState());
  }

  changeseletWishList(String value) {
    seletWishList = value;
    emit(SelectWishListState());
  }

  // List<Item> wishListData=[];
  getWishList() async {
    print('Loading getting Favorists');
    wishListLoading = false;
    emit(WishListLoadingState());
    await DioHelper.getData(
            url: '${ApiConstants.getWishList}', token: ApiConstants.tempToken)
        .then((value) {
      print('success getting Favorists');
      wishListLoading = true;
      wishListModel = WishListModel.fromJson(value.data);
      // getWishListlength();
      print('${wishListModel.wishList.length}');
      print(wishListModel.wishList[0].productsList[0].product.name);

      emit(WishListSuccessState());
    }).catchError((error) {
      print('error getting Favorites $error');
      wishListLoading = true;
      emit(WishListErrorState());
    });
  }

  addToWishList2() async {
    emit(AddWishListLoadingState());

    DioHelper.dio
        .post(
      '${ApiConstants.addToWishList}',
      queryParameters: {
        'Id': '$choosenWishListId',
        'ProductId': '${productByIdModel.id}',
        'Name': '$choosenWishListName',
      },
      options: Options(
        headers: {
          'Accept': 'text/plain',
          'Authorization':
              'Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJpc0N1c3RvbWVyIjoiVHJ1ZSIsImlzVGVuYW50IjoiRmFsc2UiLCJ1SWQiOiIwYzcyMzM1My1mOWRhLTRhYmQtYTFmNi1iNjg5OTk0MmYxNzkiLCJjb21wYW55Q29kZSI6IkRlZmF1bHQiLCJleHAiOjE2NjEzOTM0NTAsImlzcyI6IkVtb3VsSldUVG9rZW5QYXNzd29yZCIsImF1ZCI6IkVtb3VsSldUVG9rZW5QYXNzd29yZCJ9.R4Dw6p5JylG3QUcl0pk5CytXB4977MS6IZ3GNSUOess',
        },
      ),
    )
        .then((value) {
      print('adding to wishList Success');
      print(value.data);
      emit(AddWishListSuccessState());
    }).catchError(
      (error) {
        print('error adding to WishList $error');
        emit(AddWishListErrorState());
      },
    );
  }

  // Basket Screen Cart Scree ///////////////////////////////////////////////////////////////////////////
  addToBasket() {
    DioHelper.dio
        .post('${ApiConstants.addToCart}',
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'text/plain',
                'Authorization': 'Bearer ${ApiConstants.tempToken}',
              },
            ),
            data: {
              "productId": "3caaf2d5-49dd-4b2e-a637-f3343b88d0fd",
              "quantity": 2,
              "optionsMixId": "36b5cea4-1c8e-4d2b-ba24-d2c863cbe64b"
            })
        .then((value) {
          print('AddToBasket $value');
    })
        .catchError((error) {
          print('error adding to basket $error');
        });
  }

  getBasket() {
    DioHelper.dio
        .get(
      "api/Basket/GetMyBasket",
      queryParameters: {'languageCode':'en-us'},
      options:Options(headers: {
        'Accept':'text/plain',
        'Authorization':'Bearer ${ApiConstants.tempToken}',
        'Content-Type':'application/json',
      }),
    )
        .then((value) {
          print('GetBasket $value');

    })
        .catchError((error) {
      print('error at getting Basket $error');
    });
  }

  //ForgetPassword Screen //////////////////////////////////////////////////////////////////////////////////////////////////
  String groubValue = 'email';
  String resetLable = 'email';
  TextEditingController resetPasswordController = TextEditingController();
  TextInputType resetType = TextInputType.emailAddress;

  changeForgetRadioButton(String? value) {
    groubValue = value!;
    if (value == 'email') {
      resetType = TextInputType.emailAddress;
      resetLable = 'email';
    } else {
      resetType = TextInputType.phone;
      resetLable = 'phoneNumber';
    }
    emit(ResetPasswordState());
  }

//facebook Login ///////////////////////////////////////////////////////////////
  Map? userData;
  late String accessToken;

  facebookLogin(context) async {
    // var result = await FacebookAuth.i.login(
    //   permissions: ["public_profile","email"],
    // );
    // var result2 = await FacebookAuth.instance.login(
    await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']).then((value) async {
      print('facebook login success ${value.status}');
      // accessToken = value.accessToken;
      print(value.accessToken);
      userData = await FacebookAuth.instance.getUserData();
      print(userData);
      Navigator.pushNamed(context, Routes.completeRegister);
      print('navigator done');
    }).catchError((error) {
      print('facebook error $error');
    });

// if(result2.status == LoginStatus.success){
//   print('facebook success login');
//   userData = await FacebookAuth.i.getUserData(
//     fields: "email,name,picture",
//   );
//   emit(FaceBookLoginSuccess());
// }else{
//   print('facebook error${result2.status}');
// }
  }

  getFacebookAccessToken() async {
    AccessToken? accessToken = await FacebookAuth.instance.accessToken;
    return await accessToken!.token;
  }

//complet Register screen
  TextEditingController comMobileController = TextEditingController();
  TextEditingController comBuldingNoController = TextEditingController();
  TextEditingController comAddressController = TextEditingController();
  final completFormKey = GlobalKey<FormState>();
  String comDownbuttonval = 'mansoura';
  FocusNode comMobilFocusNode = FocusNode();
  FocusNode comBuildingNoFocusNode = FocusNode();
  FocusNode comAddressFocusNode = FocusNode();
}
