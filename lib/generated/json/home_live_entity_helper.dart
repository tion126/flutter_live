import 'package:flutter_live/pages/home/home_live_entity.dart';

homeLiveEntityFromJson(HomeLiveEntity data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => HomeLiveCategoryList().fromJson(v)).toList();
	}
	if (json['pageCount'] != null) {
		data.pageCount = json['pageCount'] is String
				? int.tryParse(json['pageCount'])
				: json['pageCount'].toInt();
	}
	if (json['nowPage'] != null) {
		data.nowPage = json['nowPage'] is String
				? int.tryParse(json['nowPage'])
				: json['nowPage'].toInt();
	}
	if (json['cate2Id'] != null) {
		data.cate2Id = json['cate2Id'] is String
				? int.tryParse(json['cate2Id'])
				: json['cate2Id'].toInt();
	}
	return data;
}

Map<String, dynamic> homeLiveEntityToJson(HomeLiveEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	data['pageCount'] = entity.pageCount;
	data['nowPage'] = entity.nowPage;
	data['cate2Id'] = entity.cate2Id;
	return data;
}

homeLiveCategoryListFromJson(HomeLiveCategoryList data, Map<String, dynamic> json) {
	if (json['rid'] != null) {
		data.rid = json['rid'].toString();
	}
	if (json['vipId'] != null) {
		data.vipId = json['vipId'] is String
				? int.tryParse(json['vipId'])
				: json['vipId'].toInt();
	}
	if (json['roomName'] != null) {
		data.roomName = json['roomName'].toString();
	}
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
	if (json['roomSrc'] != null) {
		data.roomSrc = json['roomSrc'].toString();
	}
	if (json['verticalSrc'] != null) {
		data.verticalSrc = json['verticalSrc'].toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar'].toString();
	}
	if (json['nickname'] != null) {
		data.nickname = json['nickname'].toString();
	}
	if (json['isVertical'] != null) {
		data.isVertical = json['isVertical'] is String
				? int.tryParse(json['isVertical'])
				: json['isVertical'].toInt();
	}
	if (json['liveCity'] != null) {
		data.liveCity = json['liveCity'].toString();
	}
	if (json['isLive'] != null) {
		data.isLive = json['isLive'] is String
				? int.tryParse(json['isLive'])
				: json['isLive'].toInt();
	}
	if (json['hn'] != null) {
		data.hn = json['hn'].toString();
	}
	return data;
}

Map<String, dynamic> homeLiveCategoryListToJson(HomeLiveCategoryList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['rid'] = entity.rid;
	data['vipId'] = entity.vipId;
	data['roomName'] = entity.roomName;
	data['cate1Id'] = entity.cate1Id;
	data['cate2Id'] = entity.cate2Id;
	data['roomSrc'] = entity.roomSrc;
	data['verticalSrc'] = entity.verticalSrc;
	data['avatar'] = entity.avatar;
	data['nickname'] = entity.nickname;
	data['isVertical'] = entity.isVertical;
	data['liveCity'] = entity.liveCity;
	data['isLive'] = entity.isLive;
	data['hn'] = entity.hn;
	return data;
}