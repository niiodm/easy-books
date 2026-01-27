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


/** This is an auto generated class representing the Receipt type in your schema. */
@immutable
class Receipt extends Model {
  static const classType = const _ReceiptModelType();
  final String id;
  final String? _customer;
  final TemporalDateTime? _time;
  final List<Sale>? _sales;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get customer {
    return _customer;
  }
  
  TemporalDateTime get time {
    try {
      return _time!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<Sale>? get sales {
    return _sales;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Receipt._internal({required this.id, customer, required time, sales, createdAt, updatedAt}): _customer = customer, _time = time, _sales = sales, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Receipt({String? id, String? customer, required TemporalDateTime time, List<Sale>? sales}) {
    return Receipt._internal(
      id: id == null ? UUID.getUUID() : id,
      customer: customer,
      time: time,
      sales: sales != null ? List<Sale>.unmodifiable(sales) : sales);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Receipt &&
      id == other.id &&
      _customer == other._customer &&
      _time == other._time &&
      DeepCollectionEquality().equals(_sales, other._sales);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Receipt {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("customer=" + "$_customer" + ", ");
    buffer.write("time=" + (_time != null ? _time!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Receipt copyWith({String? id, String? customer, TemporalDateTime? time, List<Sale>? sales}) {
    return Receipt._internal(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      time: time ?? this.time,
      sales: sales ?? this.sales);
  }
  
  Receipt.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _customer = json['customer'],
      _time = json['time'] != null ? TemporalDateTime.fromString(json['time']) : null,
      _sales = json['sales'] is List
        ? (json['sales'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Sale.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'customer': _customer, 'time': _time?.format(), 'sales': _sales?.map((Sale? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "receipt.id");
  static final QueryField CUSTOMER = QueryField(fieldName: "customer");
  static final QueryField TIME = QueryField(fieldName: "time");
  static final QueryField SALES = QueryField(
    fieldName: "sales",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Sale).toString()));
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Receipt";
    modelSchemaDefinition.pluralName = "Receipts";
    
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
        authStrategy: AuthStrategy.PRIVATE,
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
      key: Receipt.CUSTOMER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Receipt.TIME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: Receipt.SALES,
      isRequired: false,
      ofModelName: (Sale).toString(),
      associatedKey: Sale.RECEIPTID
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
  });
}

class _ReceiptModelType extends ModelType<Receipt> {
  const _ReceiptModelType();
  
  @override
  Receipt fromJson(Map<String, dynamic> jsonData) {
    return Receipt.fromJson(jsonData);
  }
}