import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:el_moul/layouts/home_cubit/home_cubit.dart';
import 'package:el_moul/layouts/home_cubit/home_states.dart';
import 'package:el_moul/applocal.dart';
import 'package:el_moul/main.dart';
import 'package:el_moul/shared/network/dio_helper.dart';
import 'package:el_moul/shared/resources/color_manager.dart';
import 'package:el_moul/shared/resources/components.dart';
import 'package:el_moul/shared/resources/constants.dart';
import 'package:el_moul/shared/resources/routes_manager.dart';
import 'package:el_moul/shared/resources/strings_manager.dart';
import 'package:el_moul/shared/resources/styles_manager.dart';
import 'package:el_moul/shared/resources/theme_manager.dart';
import 'package:el_moul/shared/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  Widget build(BuildContext context) {
    Locale locale = AppLocale.of(context).locale;

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is GetCategoriesDataLoading) {}
        if (state is GetCategoriesDataSuccess ||
            state is GetCategoriesDataError) {}
      },
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);
        return DefaultTabController(
          length: cubit.parentCategoriesModel.categoriesElemnetsList.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '${AppLocale.of(context).getTranslated('title')}',
              ),
              actions: [
                IconButton(
                  onPressed: () {


                    cubit.changeLanguage(context,locale);

                  },
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
              ],
              // bottom: TabBar(
              //   padding: EdgeInsets.symmetric(
              //     vertical: 1.0,
              //   ),
              //   tabs: List<Widget>.generate(
              //     cubit.parentCategoriesModel.categoriesElemnetsList.length,
              //     (index) => Container(
              //       padding: EdgeInsets.symmetric(vertical: 3.0),
              //       child: Text(
              //         locale.toString() == "en_US"
              //             ? cubit
              //                 .parentCategoriesModel
              //                 .categoriesElemnetsList[index]
              //                 .englishStringlist[0]
              //                 .text
              //             : cubit
              //                 .parentCategoriesModel
              //                 .categoriesElemnetsList[index]
              //                 .arabicStringlist[0]
              //                 .text,
              //         maxLines: 1,
              //         style: Theme.of(context).textTheme.bodyText1,
              //       ),
              //     ),
              //   ),
              //   isScrollable: true,
              // ),
            ),
            body: cubit.getBodyList()[cubit.bottomNavIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.bottomNavIndex,
              onTap: (index) {
                cubit.changeBottomNav(index);
              },
              items: cubit.getBottomNavList(),
            ),
            drawer: Drawer(
              backgroundColor: ColorManager.backgroundColor,
              child: SingleChildScrollView(
                child: Column(
                  // Important: Remove any padding from the ListView.
                  // padding: EdgeInsets.zero,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100.0,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Text(
                          getLang(context, 'title'),
                        ),
                      ),
                    ),
                    Center(
                      child:
                          IconButton(onPressed: () {
                            // cubit.changeLanguage(context);

                            // setState((){
                            //   cubit.changeLanguage(context);
                            // });

                          }, icon: Icon(Icons.flag)),
                    ),
                    Container(
                      height: 1.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                    //sections part
                    Column(
                      children: List.generate(
                        cubit.parentCategoriesModel.categoriesElemnetsList
                            .length,
                        (index) => ExpansionTile(
                          textColor: ColorManager.regitserButtonColor,
                          collapsedTextColor: ColorManager.selectedItemBar,
                          title: Text(
                              '${cubit.categoriesModel.categoriesElemnetsList[index].englishStringlist[0].text}'),
                          children: List.generate(
                            cubit.categoriesModel.categoriesElemnetsList[index]
                                .subSections.length,
                            (indexx) => ListTile(
                              onTap: (){
                                print(cubit.categoriesModel.categoriesElemnetsList[index].englishsubSections[indexx]['text']);
                                cubit.sectionID= cubit.categoriesModel.categoriesElemnetsList[index].id;
                                cubit.changeBottomNav(1);
                                Navigator.pop(context);
                              },
                              textColor: ColorManager.white,
                              title: locale=='en-us'?Text(
                                  '${cubit.categoriesModel.categoriesElemnetsList[index].englishsubSections[indexx]['text']}'):Text(
                                  '${cubit.categoriesModel.categoriesElemnetsList[index].englishsubSections[indexx]['text']}'),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 1.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                    HomeCubit.isLogedIn ? MaterialButton(
                      onPressed: ()async {
                        await FacebookAuth.instance.logOut().then((value) {
                          print('facebook logout success');
                          cubit.logout();
                        }).catchError((error){print('facebook log out faliulre $error');});
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "LogOut",
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ):MaterialButton(
                      onPressed: () {
                        cubit.gotoLoginScreen(2);
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Login",
                            style:
                            TextStyle(fontSize: 14.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    MaterialButton(onPressed: ()async{
                      cubit.getWishList();
                      Navigator.pushNamed(context, Routes.wishListScreen);
                    },child: Row(children: [Icon(Icons.favorite,color: Colors.red,),SizedBox(width: 10.0,),Text('WishList',style: TextStyle(color: Colors.white),)],),),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.settingsScreen);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Settings",
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
