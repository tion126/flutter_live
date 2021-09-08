import 'package:flutter_live/generated/json/base/json_convert_content.dart';

class LiveRoomEntity with JsonConvert<LiveRoomEntity> {
	int? rid;
	int? vipId;
	String? roomName;
	String? nickname;
	int? ownerId;
	String? avatar;
	int? cate1Id;
	int? cate2Id;
	String? cate2Name;
	String? roomSrc;
	String? roomSrcSixteen;
	String? roomSrcBaidu;
	int? isVertical;
	int? isLive;
	int? showTime;
	String? notice;
	String? hn;
	String? liveCity;
	int? isAudio;
	int? isTicket;
}
