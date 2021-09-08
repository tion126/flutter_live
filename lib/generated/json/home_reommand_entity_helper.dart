import 'package:flutter_live/pages/home/home_reommand_entity.dart';

homeRecommandEntityFromJson(HomeRecommandEntity data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => HomeRecList().fromJson(v)).toList();
	}
	if (json['cate2Info'] != null) {
		data.cate2Info = (json['cate2Info'] as List).map((v) => HomeReommandCate2Info().fromJson(v)).toList();
	}
	if (json['tabName'] != null) {
		data.tabName = json['tabName'].toString();
	}
	if (json['shortName'] != null) {
		data.shortName = json['shortName'].toString();
	}
	if (json['count'] != null) {
		data.count = json['count'] is String
				? double.tryParse(json['count'])
				: json['count'].toDouble();
	}
	if (json['icon'] != null) {
		data.icon = json['icon'].toString();
	}
	if (json['more'] != null) {
		data.more = json['more'].toString();
	}
	return data;
}

Map<String, dynamic> homeRecommandEntityToJson(HomeRecommandEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	data['cate2Info'] =  entity.cate2Info?.map((v) => v.toJson())?.toList();
	data['tabName'] = entity.tabName;
	data['shortName'] = entity.shortName;
	data['count'] = entity.count;
	data['icon'] = entity.icon;
	data['more'] = entity.more;
	return data;
}

homeRecListFromJson(HomeRecList data, Map<String, dynamic> json) {
	if (json['rid'] != null) {
		data.rid = json['rid'].toString();
	}
	if (json['vipId'] != null) {
		data.vipId = json['vipId'] is String
				? double.tryParse(json['vipId'])
				: json['vipId'].toDouble();
	}
	if (json['roomName'] != null) {
		data.roomName = json['roomName'].toString();
	}
	if (json['roomSrc'] != null) {
		data.roomSrc = json['roomSrc'].toString();
	}
	if (json['cate2Id'] != null) {
		data.cate2Id = json['cate2Id'] is String
				? double.tryParse(json['cate2Id'])
				: json['cate2Id'].toDouble();
	}
	if (json['nickname'] != null) {
		data.nickname = json['nickname'].toString();
	}
	if (json['cate2Name'] != null) {
		data.cate2Name = json['cate2Name'].toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar'].toString();
	}
	if (json['hn'] != null) {
		data.hn = json['hn'].toString();
	}
	return data;
}

Map<String, dynamic> homeRecListToJson(HomeRecList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['rid'] = entity.rid;
	data['vipId'] = entity.vipId;
	data['roomName'] = entity.roomName;
	data['roomSrc'] = entity.roomSrc;
	data['cate2Id'] = entity.cate2Id;
	data['nickname'] = entity.nickname;
	data['cate2Name'] = entity.cate2Name;
	data['avatar'] = entity.avatar;
	data['hn'] = entity.hn;
	return data;
}

homeReommandCate2InfoFromJson(HomeReommandCate2Info data, Map<String, dynamic> json) {
	if (json['cate2Id'] != null) {
		data.cate2Id = json['cate2Id'] is String
				? double.tryParse(json['cate2Id'])
				: json['cate2Id'].toDouble();
	}
	if (json['cate2Name'] != null) {
		data.cate2Name = json['cate2Name'].toString();
	}
	if (json['shortName'] != null) {
		data.shortName = json['shortName'].toString();
	}
	return data;
}

Map<String, dynamic> homeReommandCate2InfoToJson(HomeReommandCate2Info entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['cate2Id'] = entity.cate2Id;
	data['cate2Name'] = entity.cate2Name;
	data['shortName'] = entity.shortName;
	return data;
}