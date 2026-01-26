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


/** This is an auto generated class representing the Expense type in your schema. */
@immutable
class Expense extends Model {
  static const classType = const _ExpenseModelType();
  final String id;
  final String? _description;
  final double? _amount;
  final TemporalDateTime? _time;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get description {
    try {
      return _description!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  double get amount {
    try {
      return _amount!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  TemporalDateTime get time {
    try {
      return _time!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  const Expense._internal({required this.id, required description, required amount, required time}): _description = description, _amount = amount, _time = time;
  
  factory Expense({String? id, required String description, required double amount, required TemporalDateTime time}) {
    return Expense._internal(
      id: id == null ? UUID.getUUID() : id,
      description: description,
      amount: amount,
      time: time);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Expense &&
      id == other.id &&
      _description == other._description &&
      _amount == other._amount &&
      _time == other._time;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Expense {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("amount=" + (_amount != null ? _amount!.toString() : "null") + ", ");
    buffer.write("time=" + (_time != null ? _time!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Expense copyWith({String? id, String? description, double? amount, TemporalDateTime? time}) {
    return Expense(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      time: time ?? this.time);
  }
  
  Expense.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _description = json['description'],
      _amount = (json['amount'] as num?)?.toDouble(),
      _time = json['time'] != null ? TemporalDateTime.fromString(json['time']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'description': _description, 'amount': _amount, 'time': _time?.format()
  };

  static final QueryField ID = QueryField(fieldName: "expense.id");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField AMOUNT = QueryField(fieldName: "amount");
  static final QueryField TIME = QueryField(fieldName: "time");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Expense";
    modelSchemaDefinition.pluralName = "Expenses";
    
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
      key: Expense.DESCRIPTION,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Expense.AMOUNT,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Expense.TIME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _ExpenseModelType extends ModelType<Expense> {
  const _ExpenseModelType();
  
  @override
  Expense fromJson(Map<String, dynamic> jsonData) {
    return Expense.fromJson(jsonData);
  }
}