
import 'package:battalion_chai/admin/admin_home_screen.dart';
import 'package:battalion_chai/login_screen.dart';
import 'package:battalion_chai/users/about_screen.dart';
import 'package:battalion_chai/users/branch_screen.dart';
import 'package:battalion_chai/users/contact_screen.dart';
import 'package:battalion_chai/users/menu_screen.dart';
import 'package:battalion_chai/users/user_home_screen.dart';
import 'package:get/get.dart';

import 'admin/add_branch_screen.dart';
import 'admin/add_category_screen.dart';
import 'admin/add_menu_screen.dart';



class AppRoutes {
  static const userHomeScreen = '/';
  static const adminLogin = '/admin/login';
  static const aboutScreen = '/users/about';
  static const menuScreen = '/users/menu';
  static const contactScreen = '/users/contact';
  static const branchScreen = '/users/branch';
  static const adminHomeScreen = '/admin/dashboard';


  //adminn
  static const String adminHome = '/admin/admin_home_screen';
  static const String addCategory = '/admin/add_category_screen';
  static const String addMenu = '/admin/add_menu_screen';
  static const String addBranch = '/admin/add_branch_screen';
  // static const String manageMenu = '/admin/manage-menu';
  // static const String manageBranches = '/admin/manage-branches';
  // static const String adminSettings = '/admin/settings';

  static final pages = <GetPage>[
    GetPage(name: userHomeScreen, page: () => const UserHomeScreen()),
    GetPage(name: adminLogin, page: () => const LoginScreen()),
    GetPage(name: aboutScreen, page: () => const AboutScreen()),
    GetPage(name: contactScreen, page: () => const ContactScreen()),
    GetPage(name: branchScreen, page: () => const BranchScreen()),
    GetPage(name: menuScreen, page: () => const MenuScreen()),
    GetPage(
      name: adminHomeScreen,
      page: () => const AdminHomeScreen(),
    ),

    //admin
    GetPage(
      name: addCategory,
      page: () => const AddCategoryScreen(),
    ),
    GetPage(
      name: addMenu,
      page: () => const AddMenuScreen(),
    ),
    GetPage(
      name: addBranch,
      page: () => const AddBranchScreen(),
    ),
  ];
}
