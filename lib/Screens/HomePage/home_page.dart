import 'dart:developer';
import 'package:country_display_application/Helper/api_helper.dart';
import 'package:country_display_application/Models/user_model.dart';
import 'package:country_display_application/Screens/DetailPage/details_page.dart';
import 'package:country_display_application/Screens/StarredRepoPage/starred_repo_page.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String query = "";

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Apihelper.apihelper.fetchData();
    log(
      "Data Fetched",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Apihelper.apihelper.fetchData();
          });
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(
          Icons.restart_alt,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Flexify.go(
                const StarredRepoPage(),
                animation: FlexifyRouteAnimations.blur,
                animationDuration: Durations.medium1,
              );
            },
            icon: const Icon(
              Icons.star,
              size: 30,
              color: Colors.yellow,
            ),
          )
        ],
        title: const Text(
          "GitHub User Finder",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    onSubmitted: (val) {},
                    decoration: InputDecoration(
                      hintText: 'Search Users',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      query = searchController.text
                          .trim(); // Set the value to query
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Search",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: (query.isNotEmpty)
                ? FutureBuilder(
                    future: Apihelper.apihelper.fetchUserData(query),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        UserModel? user = snapshot.data;
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            if (user!.login.toLowerCase().contains(
                                  query.toLowerCase(),
                                )) {
                              return GestureDetector(
                                onTap: () {
                                  Flexify.go(
                                    DetailsPage(
                                      allData: null,
                                      user: user,
                                    ),
                                    animation: FlexifyRouteAnimations.blur,
                                    animationDuration: Durations.medium1,
                                  );
                                },
                                child: Card(
                                  color: Colors.grey[800],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            user.avatarUrl,
                                          ),
                                          radius: 30,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          user.login,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          'GitHub User',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      }
                      return const Center(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  )
                : FutureBuilder(
                    future: Apihelper.apihelper.fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var users = snapshot.data!;
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            var user = users[index];
                            if (user.login
                                .toLowerCase()
                                .contains(query.toLowerCase())) {
                              return GestureDetector(
                                onTap: () {
                                  Flexify.go(
                                    DetailsPage(allData: users[index]),
                                    animation: FlexifyRouteAnimations.blur,
                                    animationDuration: Durations.medium1,
                                  );
                                },
                                child: Card(
                                  color: Colors.grey[800],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            user.avatarUrl,
                                          ),
                                          radius: 30,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          user.login,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          'GitHub User',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueGrey,
                          ),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
