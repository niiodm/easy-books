/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Permissions type in your schema. */
@immutable
class Permissions extends Model {
  static const classType = const _PermissionsModelType();
  final String id;
  final List<StaffPermissions>? _permissions;
  final User? _user;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;
  final String? _permissionsUserId;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  List<StaffPermissions>? get permissions {
    return _permissions;
  }
  
  User get user {
    try {
      return _user!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  String get permissionsUserId {
    try {
      return _permissionsUserId!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const Permissions._internal({required this.id, permissions, required user, createdAt, updatedAt, required permissionsUserId}): _permissions = permissions, _user = user, _createdAt = createdAt, _updatedAt = updatedAt, _permissionsUserId = permissionsUserId;
  
  factory Permissions({String? id, List<StaffPermissions>? permissions, required User user, required String permissionsUserId}) {
    return Permissions._internal(
      id: id == null ? UUID.getUUID() : id,
      permissions: permissions != null ? List<StaffPermissions>.unmodifiable(permissions) : permissions,
      user: user,
      permissionsUserId: permissionsUserId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Permissions &&
      id == other.id &&
      DeepCollectionEquality().equals(_permissions, other._permissions) &&
      _user == other._user &&
      _permissionsUserId == other._permissionsUserId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Permissions {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("permissions=" + (_permissions != null ? _permissions!.map((e) => enumToString(e)).toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null") + ", ");
    buffer.write("permissionsUserId=" + "$_permissionsUserId");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Permissions copyWith({String? id, List<StaffPermissions>? permissions, User? user, String? permissionsUserId}) {
    return Permissions._internal(
      id: id ?? this.id,
      permissions: permissions ?? this.permissions,
      user: user ?? this.user,
      permissionsUserId: permissionsUserId ?? this.permissionsUserId);
  }
  
  Permissions.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _permissions = json['permissions'] is List
        ? (json['permissions'] as List)
          .map((e) => enumFromString<StaffPermissions>(e, StaffPermissions.values)!)
          .toList()
        : null,
      _user = json['user']?['serializedData'] != null
        ? User.fromJson(new Map<String, dynamic>.from(json['user']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null,
      _permissionsUserId = json['permissionsUserId'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'permissions': _permissions?.map((e) => enumToString(e)).toList(), 'user': _user?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'permissionsUserId': _permissionsUserId
  };

  static final QueryField ID = QueryField(fieldName: "permissions.id");
  static final QueryField PERMISSIONS = QueryField(fieldName: "permissions");
  static final QueryField USER = QueryField(
    fieldName: "user",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (User).toString()));
  static final QueryField PERMISSIONSUSERID = QueryField(fieldName: "permissionsUserId");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Permissions";
    modelSchemaDefinition.pluralName = "Permissions";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: AuthRuleProvider.USERPOOLS,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ]),
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        provider: AuthRuleProvider.IAM,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Permissions.PERMISSIONS,
      isRequired: false,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.enumeration))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasOne(
      key: Permissions.USER,
      isRequired: true,
      ofModelName: (User).toString(),
      associatedKey: User.ID
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Permissions.PERMISSIONSUSERID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _PermissionsModelType extends ModelType<Permissions> {
  const _PermissionsModelType();
  
  @override
  Permissions fromJson(Map<String, dynamic> jsonData) {
    return Permissions.fromJson(jsonData);
  }
}