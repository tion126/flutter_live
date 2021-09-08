// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:flutter_live/pages/home/home_live_entity.dart';
import 'package:flutter_live/generated/json/home_live_entity_helper.dart';
import 'package:flutter_live/pages/live/live_room_entity.dart';
import 'package:flutter_live/generated/json/live_room_entity_helper.dart';
import 'package:flutter_live/pages/home/home_reommand_entity.dart';
import 'package:flutter_live/generated/json/home_reommand_entity_helper.dart';
import 'package:flutter_live/pages/home/home_category_entity.dart';
import 'package:flutter_live/generated/json/home_category_entity_helper.dart';

class JsonConvert<T> {
	T fromJson(Map<String, dynamic> json) {
		return _getFromJson<T>(runtimeType, this, json);
	}

  Map<String, dynamic> toJson() {
		return _getToJson<T>(runtimeType, this);
  }

  static _getFromJson<T>(Type type, data, json) {
		switch (type) {
			case HomeLiveEntity:
				return homeLiveEntityFromJson(data as HomeLiveEntity, json) as T;
			case HomeLiveCategoryList:
				return homeLiveCategoryListFromJson(data as HomeLiveCategoryList, json) as T;
			case LiveRoomEntity:
				return liveRoomEntityFromJson(data as LiveRoomEntity, json) as T;
			case HomeRecommandEntity:
				return homeRecommandEntityFromJson(data as HomeRecommandEntity, json) as T;
			case HomeRecList:
				return homeRecListFromJson(data as HomeRecList, json) as T;
			case HomeReommandCate2Info:
				return homeReommandCate2InfoFromJson(data as HomeReommandCate2Info, json) as T;
			case HomeCategoryEntity:
				return homeCategoryEntityFromJson(data as HomeCategoryEntity, json) as T;    }
		return data as T;
	}

  static _getToJson<T>(Type type, data) {
		switch (type) {
			case HomeLiveEntity:
				return homeLiveEntityToJson(data as HomeLiveEntity);
			case HomeLiveCategoryList:
				return homeLiveCategoryListToJson(data as HomeLiveCategoryList);
			case LiveRoomEntity:
				return liveRoomEntityToJson(data as LiveRoomEntity);
			case HomeRecommandEntity:
				return homeRecommandEntityToJson(data as HomeRecommandEntity);
			case HomeRecList:
				return homeRecListToJson(data as HomeRecList);
			case HomeReommandCate2Info:
				return homeReommandCate2InfoToJson(data as HomeReommandCate2Info);
			case HomeCategoryEntity:
				return homeCategoryEntityToJson(data as HomeCategoryEntity);
			}
			return data as T;
		}
  //Go back to a single instance by type
	static _fromJsonSingle<M>( json) {
		String type = M.toString();
		if(type == (HomeLiveEntity).toString()){
			return HomeLiveEntity().fromJson(json);
		}
		if(type == (HomeLiveCategoryList).toString()){
			return HomeLiveCategoryList().fromJson(json);
		}
		if(type == (LiveRoomEntity).toString()){
			return LiveRoomEntity().fromJson(json);
		}
		if(type == (HomeRecommandEntity).toString()){
			return HomeRecommandEntity().fromJson(json);
		}
		if(type == (HomeRecList).toString()){
			return HomeRecList().fromJson(json);
		}
		if(type == (HomeReommandCate2Info).toString()){
			return HomeReommandCate2Info().fromJson(json);
		}
		if(type == (HomeCategoryEntity).toString()){
			return HomeCategoryEntity().fromJson(json);
		}

		return null;
	}

  //list is returned by type
	static M _getListChildType<M>(List data) {
		if(<HomeLiveEntity>[] is M){
			return data.map<HomeLiveEntity>((e) => HomeLiveEntity().fromJson(e)).toList() as M;
		}
		if(<HomeLiveCategoryList>[] is M){
			return data.map<HomeLiveCategoryList>((e) => HomeLiveCategoryList().fromJson(e)).toList() as M;
		}
		if(<LiveRoomEntity>[] is M){
			return data.map<LiveRoomEntity>((e) => LiveRoomEntity().fromJson(e)).toList() as M;
		}
		if(<HomeRecommandEntity>[] is M){
			return data.map<HomeRecommandEntity>((e) => HomeRecommandEntity().fromJson(e)).toList() as M;
		}
		if(<HomeRecList>[] is M){
			return data.map<HomeRecList>((e) => HomeRecList().fromJson(e)).toList() as M;
		}
		if(<HomeReommandCate2Info>[] is M){
			return data.map<HomeReommandCate2Info>((e) => HomeReommandCate2Info().fromJson(e)).toList() as M;
		}
		if(<HomeCategoryEntity>[] is M){
			return data.map<HomeCategoryEntity>((e) => HomeCategoryEntity().fromJson(e)).toList() as M;
		}

		throw Exception("not found");
	}

  static M fromJsonAsT<M>(json) {
		if (json is List) {
			return _getListChildType<M>(json);
		} else {
			return _fromJsonSingle<M>(json) as M;
		}
	}
}