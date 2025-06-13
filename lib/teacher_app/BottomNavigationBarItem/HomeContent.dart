import 'package:flutter/material.dart';
import '../../Refactoration/Colors.dart';
import '../../Refactoration/common_widgets.dart';
import '../settings/NotificationsScreen.dart';
import '../StudentsListScreen.dart';
import '../DashboardItems/timetable/timetable_data.dart';
import '../../Refactoration/utils.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool showAllCards = false;


  void toggleShowAllCards() {
    setState(() {
      showAllCards = !showAllCards;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentDay = getCurrentDay();
    final currentDayData = timetableData[currentDay] ?? [];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: AppColors.textColor_2,
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text(
          "Welcome!\nTeacher Name",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                  const AssetImage('assets/images/profile.jpg'),
                  onBackgroundImageError: (exception, stackTrace) {
                    print('Error loading image: $exception');
                  },
                  child: const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.formFieldColor,
                      width: 1.0,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_active,
                      color: AppColors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
                .animate(animation),
            child: child,
          ),
        ),
        child: CustomDrawer(onLogoutTap: () { print('Logout'); }),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: AppColors.formFieldColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                        child: const Icon(
                          Icons.school_outlined,
                          color: AppColors.white,
                          size: 50,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "120",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Total Student",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textColor_2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentsListScreen(),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "View Students",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(width: 20),
                          Icon(
                            Icons.arrow_forward,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Timetable Section
          const Text(
            "Today's Timetable",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
      Expanded(
        child: timetableData[currentDay]!.isEmpty
            ? Center(
          child: Text(
            (currentDay == "Fri" || currentDay == "Sat")
                ? "Holiday"
                : "No classes for this day",
            style: const TextStyle(fontSize: 16, color: AppColors.textColor_2),
          ),
        )
              : Column(
            children: [
              ...List.generate(
                showAllCards
                    ? currentDayData.length
                    : (currentDayData.length > 2 ? 2 : currentDayData.length),
                    (index) => TimetableCard(
                  startTime: currentDayData[index].startTime,
                  endTime: currentDayData[index].endTime,
                  subject: currentDayData[index].subject,
                  className: currentDayData[index].className,
                ),
              ),
              const SizedBox(height: 10),

              if (currentDayData.length > 2)
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: toggleShowAllCards,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          showAllCards ? "View Less" : "View More",
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          showAllCards
                              ? Icons.arrow_drop_up_rounded
                              : Icons.arrow_drop_down,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
         ),
        ],
      ),
    );
  }
}