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

import 'ModelProvider.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Receipt type in your schema. */
@immutable
class Receipt extends Model {
  static const classType = const _ReceiptModelType();
  final String id;
  final String? _customer;
  final List<Sale>? _sales;
  final TemporalDateTime? _time;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get customer {
    return _customer;
  }
  
  List<Sale>? get sales {
    return _sales;
  }
  
  TemporalDateTime? get time {
    return _time;
  }
  
  const Receipt._internal({required this.id, customer, sales, time}): _customer = customer, _sales = sales, _time = time;
  
  factory Receipt({String? id, String? customer, List<Sale>? sales, TemporalDateTime? time}) {
    return Receipt._internal(
      id: id == null ? UUID.getUUID() : id,
      customer: customer,
      sales: sales != null ? List<Sale>.unmodifiable(sales) : sales,
      time: time);
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
      DeepCollectionEquality().equals(_sales, other._sales) &&
      _time == other._time;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Receipt {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("customer=" + "$_customer" + ", ");
    buffer.write("time=" + (_time != null ? _time!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Receipt copyWith({String? id, String? customer, List<Sale>? sales, TemporalDateTime? time}) {
    return Receipt(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      sales: sales ?? this.sales,
      time: time ?? this.time);
  }
  
  Receipt.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _customer = json['customer'],
      _sales = json['sales'] is List
        ? (json['sales'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Sale.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _time = json['time'] != null ? TemporalDateTime.fromString(json['time']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'customer': _customer, 'sales': _sales?.map((Sale? e) => e?.toJson()).toList(), 'time': _time?.format()
  };

  static final QueryField ID = QueryField(fieldName: "receipt.id");
  static final QueryField CUSTOMER = QueryField(fieldName: "customer");
  static final QueryField SALES = QueryField(
    fieldName: "sales",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Sale).toString()));
  static final QueryField TIME = QueryField(fieldName: "time");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Receipt";
    modelSchemaDefinition.pluralName = "Receipts";
    
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
      key: Receipt.CUSTOMER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: Receipt.SALES,
      isRequired: false,
      ofModelName: (Sale).toString(),
      associatedKey: Sale.RECEIPTID
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Receipt.TIME,
      isRequired: false,
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