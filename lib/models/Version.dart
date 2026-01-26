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

// ignore_for_file: public_member_api_docs

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Version type in your schema. */
@immutable
class Version extends Model {
  static const classType = const _VersionModelType();
  final String id;
  final String? _version;
  final String? _link;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get version {
    try {
      return _version!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  String get link {
    try {
      return _link!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  const Version._internal({required this.id, required version, required link}): _version = version, _link = link;
  
  factory Version({String? id, required String version, required String link}) {
    return Version._internal(
      id: id == null ? UUID.getUUID() : id,
      version: version,
      link: link);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Version &&
      id == other.id &&
      _version == other._version &&
      _link == other._link;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Version {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("version=" + "$_version" + ", ");
    buffer.write("link=" + "$_link");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Version copyWith({String? id, String? version, String? link}) {
    return Version(
      id: id ?? this.id,
      version: version ?? this.version,
      link: link ?? this.link);
  }
  
  Version.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _version = json['version'],
      _link = json['link'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'version': _version, 'link': _link
  };

  static final QueryField ID = QueryField(fieldName: "version.id");
  static final QueryField VERSION = QueryField(fieldName: "version");
  static final QueryField LINK = QueryField(fieldName: "link");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Version";
    modelSchemaDefinition.pluralName = "Versions";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Version.VERSION,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Version.LINK,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _VersionModelType extends ModelType<Version> {
  const _VersionModelType();
  
  @override
  Version fromJson(Map<String, dynamic> jsonData) {
    return Version.fromJson(jsonData);
  }
}