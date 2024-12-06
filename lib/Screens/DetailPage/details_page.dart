import 'dart:developer';
import 'package:country_display_application/Helper/api_helper.dart';
import 'package:country_display_application/Models/repo_model.dart';
import 'package:country_display_application/Models/user_model.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({
    super.key,
    required this.allData,
    this.user,
  });

  final List allData;
  final UserModel? user;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late List allData;
  String query = "";

  @override
  void initState() {
    super.initState();
    allData = widget.allData;
    query = widget.user?.login ?? "";
    log("Query initialized: $query");
  }

  @override
  Widget build(BuildContext context) {
    log("Building DetailsPage...");
    log("Query Value : $query");
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
        title: const Text(
          "Repositories",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: (allData.isNotEmpty)
            ? FutureBuilder<List<RepoModel>?>(
                future: Apihelper.apihelper.fetchRepoData(query),
                builder: (context, snapshot) {
                  log("Snapshot connectionState: ${snapshot.connectionState}");
                  log("Snapshot hasData: ${snapshot.hasData}");
                  log("Snapshot data: ${snapshot.data}");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
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
                    List<RepoModel> repos =
                        List<RepoModel>.from(snapshot.data!);
                    return Column(
                      children: [
                        const Text(
                          'Repositories:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: repos.length,
                            separatorBuilder: (context, index) {
                              return const Divider(color: Colors.white);
                            },
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.grey[850],
                                child: ListTile(
                                  title: Text(repos[index].fullName),
                                  subtitle: Text(
                                    repos[index].description ??
                                        "No description",
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
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                })
            : const Center(
                child: Text(
                  "No User",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
