import 'dart:developer';
import 'package:country_display_application/Helper/api_helper.dart';
import 'package:country_display_application/Models/git_model.dart';
import 'package:country_display_application/Models/repo_model.dart';
import 'package:country_display_application/Models/user_model.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:country_display_application/Controllers/github_controller.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({
    super.key,
    required this.allData,
    this.user,
  });

  final GitModel? allData;
  final UserModel? user;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late GitModel? allData;
  String query = "";

  @override
  void initState() {
    super.initState();
    allData = widget.allData;

    if (allData == null) {
      query = widget.user!.login;
    } else {
      query = allData!.login;
    }

    Apihelper.apihelper.fetchRepoData(query);
    log("Query initialized: $query");
  }

  @override
  Widget build(BuildContext context) {
    log("Building DetailsPage...");
    log("Query Value : $query");

    final githubController = Provider.of<GitHubController>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Flexify.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "$query's Repositories",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: FutureBuilder<List<RepoModel>?>(
          future: Apihelper.apihelper.fetchRepoData(query),
          builder: (context, snapshot) {
            log("Snapshot connectionState: ${snapshot.connectionState}");
            log("Snapshot hasData: ${snapshot.hasData}");
            log("Snapshot data: ${snapshot.data}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueGrey,
                ),
              );
            } else if (snapshot.hasError) {
              log("Error: ${snapshot.error}");
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              log("Snapshot data is not null.");
              List<RepoModel> repos = List<RepoModel>.from(snapshot.data!);
              if (repos.isEmpty) {
                return const Center(
                  child: Text(
                    "No Repositories Found",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Repositories:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Total Repo Found: ${repos.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: repos.length,
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.grey[700]);
                      },
                      itemBuilder: (context, index) {
                        final repoName = repos[index].fullName;

                        return Card(
                          color: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.0.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        repoName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        repos[index].description ??
                                            "No description available.",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (githubController.starredList
                                        .contains(repoName)) {
                                      githubController
                                          .removeFromStarred(repoName);
                                    } else {
                                      githubController.addToStarred(repoName);
                                    }
                                  },
                                  icon: Icon(
                                    githubController.starredList
                                            .contains(repoName)
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 24.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              log("Snapshot data is null.");
              return const Center(
                child: Text(
                  "No Data Found",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
