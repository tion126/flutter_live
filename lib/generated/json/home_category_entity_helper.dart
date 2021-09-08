import 'package:flutter_live/pages/home/home_category_entity.dart';

homeCategoryEntityFromJson(HomeCategoryEntity data, Map<String, dynamic> json) {
	if (json['cate1Id'] != null) {
		data.cate1Id = json['cate1Id'] is String
				? int.tryParse(json['cate1Id'])
				: json['cate1Id'].toInt();
	}
	if (json['cate2Id'] != null) {
		data.cate2Id = json['cate2Id'] is String
				? int.tryParse(json['cate2Id'])
				: json['cate2Id'].toInt();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['shortName'] != null) {
		data.shortName = json['shortName'].toString();
	}
	return data;
}

Map<String, dynamic> homeCategoryEntityToJson(HomeCategoryEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['cate1Id'] = entity.cate1Id;
	data['cate2Id'] = entity.cate2Id;
	data['name'] = entity.name;
	data['shortName'] = entity.shortName;
	return data;
}