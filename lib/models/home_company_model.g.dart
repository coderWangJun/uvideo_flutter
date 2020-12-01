// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeCompanyModel _$HomeCompanyModelFromJson(Map<String, dynamic> json) {
  return HomeCompanyModel()
    ..createdBy = json['createdBy'] as String
    ..createdTime = json['createdTime'] as String
    ..updatedBy = json['updatedBy'] as String
    ..updatedTime = json['updatedTime'] as String
    ..id = json['id'] as int
    ..logoUrl = json['logoUrl'] as String
    ..userid = json['userid'] as String
    ..headPortraitUrl = json['headPortraitUrl'] as String
    ..ossName = json['ossName'] as String
    ..worksName = json['worksName'] as String
    ..worksUrl = json['worksUrl'] as String
    ..ossCoverName = json['ossCoverName'] as String
    ..coverName = json['coverName'] as String
    ..coverUrl = json['coverUrl'] as String
    ..title = json['title'] as String
    ..companyName = json['companyName'] as String
    ..needPeople = json['needPeople'] as int
    ..minSalary = json['minSalary'] as int
    ..maxSalary = json['maxSalary'] as int
    ..salaryTreatmentString = json['salaryTreatmentString'] as String
    ..eduId = json['eduId'] as int
    ..diploma = json['diploma'] as String
    ..yearsOfExp = json['yearsOfExp'] as int
    ..yearsOfExpString = json['yearsOfExpString'] as String
    ..locked = json['locked'] as int
    ..positionNo = json['positionNo'] as int
    ..positionName = json['positionName'] as String
    ..cityNo = json['cityNo'] as int
    ..cityName = json['cityName'] as String
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..status = json['status'] as int
    ..distanceDouble = (json['distanceDouble'] as num)?.toDouble()
    ..distanceString = json['distanceString'] as String
    ..isLiked = json['isLiked'] as int
    ..likes = json['likes'] as int
    ..numberOfComments = json['numberOfComments'] as int
    ..numberOfForwarding = json['numberOfForwarding'] as int
    ..jobDetails = json['jobDetails'] as String
    ..keywordsTags = json['keywordsTags'] as String;
}

Map<String, dynamic> _$HomeCompanyModelToJson(HomeCompanyModel instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'updatedBy': instance.updatedBy,
      'updatedTime': instance.updatedTime,
      'id': instance.id,
      'logoUrl': instance.logoUrl,
      'userid': instance.userid,
      'headPortraitUrl': instance.headPortraitUrl,
      'ossName': instance.ossName,
      'worksName': instance.worksName,
      'worksUrl': instance.worksUrl,
      'ossCoverName': instance.ossCoverName,
      'coverName': instance.coverName,
      'coverUrl': instance.coverUrl,
      'title': instance.title,
      'companyName': instance.companyName,
      'needPeople': instance.needPeople,
      'minSalary': instance.minSalary,
      'maxSalary': instance.maxSalary,
      'salaryTreatmentString': instance.salaryTreatmentString,
      'eduId': instance.eduId,
      'diploma': instance.diploma,
      'yearsOfExp': instance.yearsOfExp,
      'yearsOfExpString': instance.yearsOfExpString,
      'locked': instance.locked,
      'positionNo': instance.positionNo,
      'positionName': instance.positionName,
      'cityNo': instance.cityNo,
      'cityName': instance.cityName,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'status': instance.status,
      'distanceDouble': instance.distanceDouble,
      'distanceString': instance.distanceString,
      'isLiked': instance.isLiked,
      'likes': instance.likes,
      'numberOfComments': instance.numberOfComments,
      'numberOfForwarding': instance.numberOfForwarding,
      'jobDetails': instance.jobDetails,
      'keywordsTags': instance.keywordsTags,
    };
