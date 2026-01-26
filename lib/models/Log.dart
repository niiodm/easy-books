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


/** This is an auto generated class representing the Log type in your schema. */
@immutable
class Log extends Model {
  static const classType = const _LogModelType();
  final String id;
  final TemporalDateTime? _time;
  final String? _log;
  final String? _user;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  TemporalDateTime get time {
    try {
      return _time!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  String get log {
    try {
      return _log!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  String get user {
    try {
      return _user!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  const Log._internal({required this.id, required time, required log, required user}): _time = time, _log = log, _user = user;
  
  factory Log({String? id, required TemporalDateTime time, required String log, required String user}) {
    return Log._internal(
      id: id == null ? UUID.getUUID() : id,
      time: time,
      log: log,
      user: user);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Log &&
      id == other.id &&
      _time == other._time &&
      _log == other._log &&
      _user == other._user;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Log {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("time=" + (_time != null ? _time!.format() : "null") + ", ");
    buffer.write("log=" + "$_log" + ", ");
    buffer.write("user=" + "$_user");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Log copyWith({String? id, TemporalDateTime? time, String? log, String? user}) {
    return Log(
      id: id ?? this.id,
      time: time ?? this.time,
      log: log ?? this.log,
      user: user ?? this.user);
  }
  
  Log.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _time = json['time'] != null ? TemporalDateTime.fromString(json['time']) : null,
      _log = json['log'],
      _user = json['user'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'time': _time?.format(), 'log': _log, 'user': _user
  };

  static final QueryField ID = QueryField(fieldName: "log.id");
  static final QueryField TIME = QueryField(fieldName: "time");
  static final QueryField LOG = QueryField(fieldName: "log");
  static final QueryField USER = QueryField(fieldName: "user");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Log";
    modelSchemaDefinition.pluralName = "Logs";
    
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
      key: Log.TIME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Log.LOG,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Log.USER,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _LogModelType extends ModelType<Log> {
  const _LogModelType();
  
  @override
  Log fromJson(Map<String, dynamic> jsonData) {
    return Log.fromJson(jsonData);
  }
}