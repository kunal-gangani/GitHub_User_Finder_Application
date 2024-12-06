class StarredListModel {
  List<String> starredList;

  StarredListModel({required this.starredList});

  factory StarredListModel.fromJson(Map<String, dynamic> json) {
    return StarredListModel(
      starredList: List<String>.from(json['starredList'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'starredList': starredList,
    };
  }
}
