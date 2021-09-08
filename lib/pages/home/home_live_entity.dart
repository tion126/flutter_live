import 'package:flutter_live/generated/json/base/json_convert_content.dart';
import 'package:flutter_live/generated/json/base/json_field.dart';

class HomeLiveEntity with JsonConvert<HomeLiveEntity> {
	@JSONField(name: "list")
	List<HomeLiveCategoryList>? xList;
	int? pageCount;
	int? nowPage;
	int? cate2Id;
}

class HomeLiveCategoryList with JsonConvert<HomeLiveCategoryList> {
	String? rid;
	int? vipId;
	String? roomName;
	int? cate1Id;
	int? cate2Id;
	String? roomSrc;
	String? verticalSrc;
	String? avatar;
	String? nickname;
	int? isVertical;
	String? liveCity;
	int? isLive;
	String? hn;
}
