import 'package:country_display_application/Controllers/github_controller.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class StarredRepoPage extends StatelessWidget {
  const StarredRepoPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          "Your Favourite Repositories",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: githubController.starredList.isNotEmpty
            ? ListView.builder(
                itemCount: githubController.starredList.length,
                itemBuilder: (context, index) {
                  final repoName = githubController.starredList[index];
                  return Card(
                    color: Colors.grey[850],
                    child: ListTile(
                      title: Text(
                        repoName,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          githubController.removeFromStarred(repoName);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "$repoName removed from Starred",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  "No Starred Repositories Added",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
      ),
    );
  }
}
