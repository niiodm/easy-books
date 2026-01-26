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
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Sale type in your schema. */
@immutable
class Sale extends Model {
  static const classType = const _SaleModelType();
  final String id;
  final TemporalDateTime? _time;
  final double? _quantity;
  final Product? _product;
  final String? _receiptID;
  final double? _price;

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
  
  double get quantity {
    try {
      return _quantity!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  Product get product {
    try {
      return _product!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  String? get receiptID {
    return _receiptID;
  }
  
  double get price {
    try {
      return _price!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  const Sale._internal({required this.id, required time, required quantity, required product, receiptID, required price}): _time = time, _quantity = quantity, _product = product, _receiptID = receiptID, _price = price;
  
  factory Sale({String? id, required TemporalDateTime time, required double quantity, required Product product, String? receiptID, required double price}) {
    return Sale._internal(
      id: id == null ? UUID.getUUID() : id,
      time: time,
      quantity: quantity,
      product: product,
      receiptID: receiptID,
      price: price);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Sale &&
      id == other.id &&
      _time == other._time &&
      _quantity == other._quantity &&
      _product == other._product &&
      _receiptID == other._receiptID &&
      _price == other._price;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Sale {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("time=" + (_time != null ? _time!.format() : "null") + ", ");
    buffer.write("quantity=" + (_quantity != null ? _quantity!.toString() : "null") + ", ");
    buffer.write("product=" + (_product != null ? _product!.toString() : "null") + ", ");
    buffer.write("receiptID=" + "$_receiptID" + ", ");
    buffer.write("price=" + (_price != null ? _price!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Sale copyWith({String? id, TemporalDateTime? time, double? quantity, Product? product, String? receiptID, double? price}) {
    return Sale(
      id: id ?? this.id,
      time: time ?? this.time,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
      receiptID: receiptID ?? this.receiptID,
      price: price ?? this.price);
  }
  
  Sale.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _time = json['time'] != null ? TemporalDateTime.fromString(json['time']) : null,
      _quantity = (json['quantity'] as num?)?.toDouble(),
      _product = json['product']?['serializedData'] != null
        ? Product.fromJson(new Map<String, dynamic>.from(json['product']['serializedData']))
        : null,
      _receiptID = json['receiptID'],
      _price = (json['price'] as num?)?.toDouble();
  
  Map<String, dynamic> toJson() => {
    'id': id, 'time': _time?.format(), 'quantity': _quantity, 'product': _product?.toJson(), 'receiptID': _receiptID, 'price': _price
  };

  static final QueryField ID = QueryField(fieldName: "sale.id");
  static final QueryField TIME = QueryField(fieldName: "time");
  static final QueryField QUANTITY = QueryField(fieldName: "quantity");
  static final QueryField PRODUCT = QueryField(
    fieldName: "product",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Product).toString()));
  static final QueryField RECEIPTID = QueryField(fieldName: "receiptID");
  static final QueryField PRICE = QueryField(fieldName: "price");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Sale";
    modelSchemaDefinition.pluralName = "Sales";
    
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
      key: Sale.TIME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sale.QUANTITY,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.belongsTo(
      key: Sale.PRODUCT,
      isRequired: true,
      targetName: "saleProductId",
      ofModelName: (Product).toString()
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sale.RECEIPTID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sale.PRICE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
  });
}

class _SaleModelType extends ModelType<Sale> {
  const _SaleModelType();
  
  @override
  Sale fromJson(Map<String, dynamic> jsonData) {
    return Sale.fromJson(jsonData);
  }
}