// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_company_detailed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeCompanyDetailedModel _$HomeCompanyDetailedModelFromJson(
    Map<String, dynamic> json) {
  return HomeCompanyDetailedModel()
    ..createdTime = json['createdTime'] as String
    ..updatedTime = json['updatedTime'] as String
    ..id = json['id'] as int
    ..userid = json['userid'] as String
    ..logoUrl = json['logoUrl'] as String
    ..ossName = json['ossName'] as String
    ..worksName = json['worksName'] as String
    ..worksUrl = json['worksUrl'] as String
    ..ossCoverName = json['ossCoverName'] as String
    ..coverName = json['coverName'] as String
    ..coverUrl = json['coverUrl'] as String
    ..title = json['title'] as String
    ..needPeople = json['needPeople'] as int
    ..companyName = json['companyName'] as String
    ..minSalary = json['minSalary'] as int
    ..maxSalary = json['maxSalary'] as int
    ..skillTags = json['skillTags'] as String
    ..salaryTreatmentString = json['salaryTreatmentString'] as String
    ..eduId = json['eduId'] as int
    ..diploma = json['diploma'] as String
    ..yearsOfExp = json['yearsOfExp'] as int
    ..yearsOfExpString = json['yearsOfExpString'] as String
    ..industryNo = json['industryNo'] as int
    ..industryName = json['industryName'] as String
    ..positionNo = json['positionNo'] as int
    ..positionName = json['positionName'] as String
    ..cityNo = json['cityNo'] as int
    ..cityName = json['cityName'] as String
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..status = json['status'] as int
    ..distanceDouble = (json['distanceDouble'] as num)?.toDouble()
    ..distanceString = json['distanceString'] as String
    ..isLiked = json['isLiked'] as String
    ..likes = json['likes'] as int
    ..numberOfComments = json['numberOfComments'] as int
    ..numberOfForwarding = json['numberOfForwarding'] as int
    ..jobDetails = json['jobDetails'] as String
    ..companyInDetailsSubRVO = json['companyInDetailsSubRVO'] == null
        ? null
        : CompanyInDetailsSubRVO.fromJson(
            json['companyInDetailsSubRVO'] as Map<String, dynamic>)
    ..companyStaffEntity = json['companyStaffEntity'] == null
        ? null
        : CompanyStaffEntity.fromJson(
            json['companyStaffEntity'] as Map<String, dynamic>);
}

Map<String, dynamic> _$HomeCompanyDetailedModelToJson(
        HomeCompanyDetailedModel instance) =>
    <String, dynamic>{
      'createdTime': instance.createdTime,
      'updatedTime': instance.updatedTime,
      'id': instance.id,
      'userid': instance.userid,
      'logoUrl': instance.logoUrl,
      'ossName': instance.ossName,
      'worksName': instance.worksName,
      'worksUrl': instance.worksUrl,
      'ossCoverName': instance.ossCoverName,
      'coverName': instance.coverName,
      'coverUrl': instance.coverUrl,
      'title': instance.title,
      'needPeople': instance.needPeople,
      'companyName': instance.companyName,
      'minSalary': instance.minSalary,
      'maxSalary': instance.maxSalary,
      'skillTags': instance.skillTags,
      'salaryTreatmentString': instance.salaryTreatmentString,
      'eduId': instance.eduId,
      'diploma': instance.diploma,
      'yearsOfExp': instance.yearsOfExp,
      'yearsOfExpString': instance.yearsOfExpString,
      'industryNo': instance.industryNo,
      'industryName': instance.industryName,
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
      'companyInDetailsSubRVO': instance.companyInDetailsSubRVO,
      'companyStaffEntity': instance.companyStaffEntity,
    };
