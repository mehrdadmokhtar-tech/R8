import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:r8fitness/utils/utils.dart';
import 'package:r8fitness/services/api_service.dart';
import 'package:r8fitness/services/cache_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:r8fitness/general/dynamic_boxes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  bool isLoading = false;
  String userId = '';
  String userFName = '';
  String userLName = '';
  int trainCredit = 0;
  int buffetCredit = 0;
  List<String> groupnamelist = [''];
  List<String> expiredayslist = ['0'];
  List<String> expiredatelist = ['0'];
  List<String> classremlist = ['0'];
  int selectedBoxIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData(false);
  }

  Future<void> _loadData(bool checkToken) async {
    try {
      await CacheService.instance.load();

      final accessToken = await storage.read(key: 'access_token');

      if (checkToken==true){
        bool swExpired = isAccessTokenExpired(accesstoken: accessToken.toString());
        //appLog(swExpired.toString());
        if (swExpired==true) {
          if (!mounted) return;
          showAnimateTopSnackBar(context, 2, 4, "Token expired.\n please close and reopen the app.");
          return;
        }
      }

      userId = CacheService.instance.userId.toString();
      userFName = CacheService.instance.userFirstName.toString();
      userLName = CacheService.instance.userLastName.toString();

      if (userId == '' && accessToken == null) return;

      final datas1 = await apiMemberCredits(
        token: accessToken.toString(),
        userid: userId.toString(),
      );
      if (!mounted) return;

      final datas2 = await apiMemeberPackages(
        token: accessToken.toString(),
        userid: userId.toString(),
      );
      if (!mounted) return;

      setState(() {
        for (var data in datas1) {
          buffetCredit = data['buffet'];
          trainCredit = data['train'];
        }
        groupnamelist = [];
        expiredayslist = [];
        expiredatelist = [];
        classremlist = [];
        for (var data in datas2) {
          groupnamelist.add(data['groupName'].toString());
          expiredayslist.add(data['expireDaysRem'].toString());
          expiredatelist.add(data['expireDateFormat'].toString());
          classremlist.add(data['classCountRem'].toString());
        }
        if (groupnamelist.isEmpty) groupnamelist = ['X'];
        if (expiredayslist.isEmpty) expiredayslist = ['0'];
        if (expiredatelist.isEmpty) expiredatelist = ['0'];
        if (classremlist.isEmpty) classremlist = ['0'];

        isLoading = false;
      });

      //appLog('user id ${CacheService.instance.userId.toString()}');
      //appLog('user firstname ${CacheService.instance.userFirstName.toString()}');
      //appLog(buffetCredit.toString());
      //appLog(trainCredit.toString());
      //appLog(groupnamelist.toString());
    } catch (e) {
      String errText = errorTracking(e.toString());
      showAnimateTopSnackBar(context, 2, 3, errText);
      appLog('error : $errText');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                left: 15,
                right: 15,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Hello, ',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w300,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              TextSpan(
                                text: userFName,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Member ID : ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              TextSpan(
                                text: userId,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),

                  // IconButton(
                  //   onPressed: () {
                  //     debugPrint('کلیک شد');
                  //   },
                  //   icon: CircleAvatar(
                  //     backgroundColor: Color.fromARGB(255, 13, 105, 196),
                  //     radius: 15,
                  //     child: Text(
                  //       userFName.isNotEmpty
                  //           ? userFName[0].toUpperCase()
                  //           : '',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.normal,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  IconButton(
                    onPressed: () async {
                      await _loadData(true);
                    },
                    icon: const Icon(Icons.refresh),
                    color: theme.colorScheme.primary,
                    iconSize: 30,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Wallets",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  Text(
                    "Check your credit and notice the icon colors",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/icons/dumbbell.svg",
                            width: 40,
                            colorFilter: ColorFilter.mode(
                              trainCredit < 0
                                  ? Colors.red
                                  : trainCredit > 0
                                  ? Colors.green
                                  : Colors.grey,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Training",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: addComma(trainCredit),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                                TextSpan(
                                  text: " Rls.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: theme.textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      height: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/icons/burger.svg",
                            width: 40,
                            colorFilter: ColorFilter.mode(
                              buffetCredit < 0
                                  ? Colors.red
                                  : buffetCredit > 0
                                  ? Colors.green
                                  : Colors.grey,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Buffet",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: addComma(buffetCredit),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                                TextSpan(
                                  text: " Rls.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: theme.textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Active Packages",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  Text(
                    "Check your package status by tap on header",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: DynamicBoxes(
                items: groupnamelist,
                onSelected: (value) {
                  setState(() {
                    selectedBoxIndex = value;
                  });
                },
              ),
            ),

            SizedBox(height: 14),

            Align(
              alignment: Alignment.center,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.92,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Expires in ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          TextSpan(
                            text: expiredayslist[selectedBoxIndex].toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          TextSpan(
                            text: " days (as of ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          TextSpan(
                            text: expiredatelist[selectedBoxIndex].toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          TextSpan(
                            text: ") and also ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          TextSpan(
                            text: classremlist[selectedBoxIndex].toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          TextSpan(
                            text: " seasson remain.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
