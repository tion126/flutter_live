import 'package:flutter_live/generated/json/base/json_convert_content.dart';
import 'package:flutter_live/generated/json/base/json_field.dart';

class HomeRecommandEntity with JsonConvert<HomeRecommandEntity> {
	@JSONField(name: "list")
	List<HomeRecList>? xList;
	List<HomeReommandCate2Info>? cate2Info;
	String? tabName;
	String? shortName;
	double? count;
	String? icon;
	String? more;
}

class HomeRecList with JsonConvert<HomeRecList> {
	String? rid;
	double? vipId;
	String? roomName;
	String? roomSrc;
	double? cate2Id;
	String? nickname;
	String? cate2Name;
	String? avatar;
	String? hn;
}

class HomeReommandCate2Info with JsonConvert<HomeReommandCate2Info> {
	double? cate2Id;
	String? cate2Name;
	String? shortName;
}
