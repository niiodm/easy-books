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


/** This is an auto generated class representing the Stock type in your schema. */
@immutable
class Stock extends Model {
  static const classType = const _StockModelType();
  final String id;
  final double? _quantity;
  final String? _productName;
  final TemporalDate? _date;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  double get quantity {
    try {
      return _quantity!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  String? get productName {
    return _productName;
  }
  
  TemporalDate get date {
    try {
      return _date!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  const Stock._internal({required this.id, required quantity, productName, required date}): _quantity = quantity, _productName = productName, _date = date;
  
  factory Stock({String? id, required double quantity, String? productName, required TemporalDate date}) {
    return Stock._internal(
      id: id == null ? UUID.getUUID() : id,
      quantity: quantity,
      productName: productName,
      date: date);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Stock &&
      id == other.id &&
      _quantity == other._quantity &&
      _productName == other._productName &&
      _date == other._date;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Stock {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("quantity=" + (_quantity != null ? _quantity!.toString() : "null") + ", ");
    buffer.write("productName=" + "$_productName" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Stock copyWith({String? id, double? quantity, String? productName, TemporalDate? date}) {
    return Stock(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      productName: productName ?? this.productName,
      date: date ?? this.date);
  }
  
  Stock.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _quantity = (json['quantity'] as num?)?.toDouble(),
      _productName = json['productName'],
      _date = json['date'] != null ? TemporalDate.fromString(json['date']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'quantity': _quantity, 'productName': _productName, 'date': _date?.format()
  };

  static final QueryField ID = QueryField(fieldName: "stock.id");
  static final QueryField QUANTITY = QueryField(fieldName: "quantity");
  static final QueryField PRODUCTNAME = QueryField(fieldName: "productName");
  static final QueryField DATE = QueryField(fieldName: "date");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Stock";
    modelSchemaDefinition.pluralName = "Stocks";
    
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
      key: Stock.QUANTITY,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Stock.PRODUCTNAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Stock.DATE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.date)
    ));
  });
}

class _StockModelType extends ModelType<Stock> {
  const _StockModelType();
  
  @override
  Stock fromJson(Map<String, dynamic> jsonData) {
    return Stock.fromJson(jsonData);
  }
}