abstract class HomeStates{}
class InitialHomeState extends HomeStates{}

//Login Section /////////////////////////////////////////////////////////////////////////
class LoginchangePasswordVisibilty extends HomeStates{}
class LoginLoading extends HomeStates{}
class LoginSuccess extends HomeStates{}
class LoginError extends HomeStates{}

class GoToLoginScreen extends HomeStates{}




//SignUp Section /////////////////////////////////////////////////////////////////////////
class SignUpchangePasswordVisibilty extends HomeStates{}
class SignUpDropDwonVal extends HomeStates{}

class SignUpLoading extends HomeStates{}
class SignUpSuccess extends HomeStates{}
class SignUpError extends HomeStates{}

//drawerState Scetion ///////////////////////////////////////////////////////////////////
class ChangeDrawerState extends HomeStates{}
class ArabicLanguageSelected extends HomeStates{}
class EnglishLanguageSelected extends HomeStates{}

//Settings Screen //////////////////////////////////////////////////////////////////////////
class ProfileShowPasswordChange extends HomeStates{}
class ProfileShowMobileChange extends HomeStates{}

//home screen section ////////////////////////////////////////////////////////////////////
class SliderIndecatorChangeState extends HomeStates{}

class HomeSliderLoading extends HomeStates{}
class HomeSliderSuccess extends HomeStates{}
class HomeSliderError extends HomeStates{}

//Categories Section
class GetCategoriesDataLoading extends HomeStates{}
class GetCategoriesDataSuccess extends HomeStates{}
class GetCategoriesDataError extends HomeStates{}

class GetParentCategoriesDataLoading extends HomeStates{}
class GetParentCategoriesDataSuccess extends HomeStates{}
class GetParentCategoriesDataError extends HomeStates{}

//Recently Added
class RecentlyAddedLoading extends HomeStates{}
class RecentlyAddedSuccess extends HomeStates{}
class RecentlyAddedError extends HomeStates{}

class allRecentlyAddedLoading extends HomeStates{}
class allRecentlyAddedSuccess extends HomeStates{}
class allRecentlyAddedError extends HomeStates{}

class getAllRecentlyData extends HomeStates{}


//bottomNavigation Section
class changeBottomNavState extends HomeStates{}
class LoadingState extends HomeStates{}
class successStat extends HomeStates{}

//SearchScreen ///////////////////////////////////////////////////////////////////////////////////////////
class SearchShowFilter extends HomeStates{}

class GetSearchLoading extends HomeStates{}
class GetSearchSuccess extends HomeStates{}
class GetSearchError extends HomeStates{}

class SearchChangingSection extends HomeStates{}
class SearchChangingFromPrice extends HomeStates{}
class SearchChangingToPrice extends HomeStates{}
class SearchChangingRecently extends HomeStates{}


// Product Item View Screen ////////////////////////////////////////////////////////////////////////////
class ProductItemIndecatorState extends HomeStates{}

class ChangeProductQuantityState extends HomeStates{}

class ChangeProductSizeState extends HomeStates{}
class ResetProductSizeState extends HomeStates{}

class GetPorductByIDDataLoading extends HomeStates{}
class GetPorductByIDDataSuccess extends HomeStates{}
class GetPorductByIDDataError extends HomeStates{}

class getSimilarProductsLoading extends HomeStates{}
class getSimilarProductsSuccess extends HomeStates{}
class getSimilarProductsError extends HomeStates{}

//ResetPassword //////////////////////////////////////////////////////////////////////////////
class ResetPasswordState extends HomeStates{}
class FaceBookLoginSuccess extends HomeStates{}
// wishList Screen ////////////////////////////////////////////////////////////////////////
class WishListLoadingState extends HomeStates{}
class WishListSuccessState extends HomeStates{}
class WishListErrorState extends HomeStates{}

class AddWishListLoadingState extends HomeStates{}
class AddWishListSuccessState extends HomeStates{}
class AddWishListErrorState extends HomeStates{}

class SelectWishListState extends HomeStates{}
class ChoosenWishListIdState extends HomeStates{}
class ChoosenWishListNameState extends HomeStates{}


