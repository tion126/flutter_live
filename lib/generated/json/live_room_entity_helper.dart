import 'package:flutter_live/pages/live/live_room_entity.dart';

liveRoomEntityFromJson(LiveRoomEntity data, Map<String, dynamic> json) {
	if (json['rid'] != null) {
		data.rid = json['rid'] is String
				? int.tryParse(json['rid'])
				: json['rid'].toInt();
	}
	if (json['vipId'] != null) {
		data.vipId = json['vipId'] is String
				? int.tryParse(json['vipId'])
				: json['vipId'].toInt();
	}
	if (json['roomName'] != null) {
		data.roomName = json['roomName'].toString();
	}
	if (json['nickname'] != null) {
		data.nickname = json['nickname'].toString();
	}
	if (json['ownerId'] != null) {
		data.ownerId = json['ownerId'] is String
				? int.tryParse(json['ownerId'])
				: json['ownerId'].toInt();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar'].toString();
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
	if (json['cate2Name'] != null) {
		data.cate2Name = json['cate2Name'].toString();
	}
	if (json['roomSrc'] != null) {
		data.roomSrc = json['roomSrc'].toString();
	}
	if (json['roomSrcSixteen'] != null) {
		data.roomSrcSixteen = json['roomSrcSixteen'].toString();
	}
	if (json['roomSrcBaidu'] != null) {
		data.roomSrcBaidu = json['roomSrcBaidu'].toString();
	}
	if (json['isVertical'] != null) {
		data.isVertical = json['isVertical'] is String
				? int.tryParse(json['isVertical'])
				: json['isVertical'].toInt();
	}
	if (json['isLive'] != null) {
		data.isLive = json['isLive'] is String
				? int.tryParse(json['isLive'])
				: json['isLive'].toInt();
	}
	if (json['showTime'] != null) {
		data.showTime = json['showTime'] is String
				? int.tryParse(json['showTime'])
				: json['showTime'].toInt();
	}
	if (json['notice'] != null) {
		data.notice = json['notice'].toString();
	}
	if (json['hn'] != null) {
		data.hn = json['hn'].toString();
	}
	if (json['liveCity'] != null) {
		data.liveCity = json['liveCity'].toString();
	}
	if (json['isAudio'] != null) {
		data.isAudio = json['isAudio'] is String
				? int.tryParse(json['isAudio'])
				: json['isAudio'].toInt();
	}
	if (json['isTicket'] != null) {
		data.isTicket = json['isTicket'] is String
				? int.tryParse(json['isTicket'])
				: json['isTicket'].toInt();
	}
	return data;
}

Map<String, dynamic> liveRoomEntityToJson(LiveRoomEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['rid'] = entity.rid;
	data['vipId'] = entity.vipId;
	data['roomName'] = entity.roomName;
	data['nickname'] = entity.nickname;
	data['ownerId'] = entity.ownerId;
	data['avatar'] = entity.avatar;
	data['cate1Id'] = entity.cate1Id;
	data['cate2Id'] = entity.cate2Id;
	data['cate2Name'] = entity.cate2Name;
	data['roomSrc'] = entity.roomSrc;
	data['roomSrcSixteen'] = entity.roomSrcSixteen;
	data['roomSrcBaidu'] = entity.roomSrcBaidu;
	data['isVertical'] = entity.isVertical;
	data['isLive'] = entity.isLive;
	data['showTime'] = entity.showTime;
	data['notice'] = entity.notice;
	data['hn'] = entity.hn;
	data['liveCity'] = entity.liveCity;
	data['isAudio'] = entity.isAudio;
	data['isTicket'] = entity.isTicket;
	return data;
}