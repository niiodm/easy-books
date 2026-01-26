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


/** This is an auto generated class representing the Refund type in your schema. */
@immutable
class Refund extends Model {
  static const classType = const _RefundModelType();
  final String id;
  final TemporalDateTime? _time;
  final double? _quantity;
  final double? _price;
  final Product? _product;

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
  
  double? get price {
    return _price;
  }
  
  Product? get product {
    return _product;
  }
  
  const Refund._internal({required this.id, required time, required quantity, price, product}): _time = time, _quantity = quantity, _price = price, _product = product;
  
  factory Refund({String? id, required TemporalDateTime time, required double quantity, double? price, Product? product}) {
    return Refund._internal(
      id: id == null ? UUID.getUUID() : id,
      time: time,
      quantity: quantity,
      price: price,
      product: product);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Refund &&
      id == other.id &&
      _time == other._time &&
      _quantity == other._quantity &&
      _price == other._price &&
      _product == other._product;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Refund {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("time=" + (_time != null ? _time!.format() : "null") + ", ");
    buffer.write("quantity=" + (_quantity != null ? _quantity!.toString() : "null") + ", ");
    buffer.write("price=" + (_price != null ? _price!.toString() : "null") + ", ");
    buffer.write("product=" + (_product != null ? _product!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Refund copyWith({String? id, TemporalDateTime? time, double? quantity, double? price, Product? product}) {
    return Refund(
      id: id ?? this.id,
      time: time ?? this.time,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      product: product ?? this.product);
  }
  
  Refund.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _time = json['time'] != null ? TemporalDateTime.fromString(json['time']) : null,
      _quantity = (json['quantity'] as num?)?.toDouble(),
      _price = (json['price'] as num?)?.toDouble(),
      _product = json['product']?['serializedData'] != null
        ? Product.fromJson(new Map<String, dynamic>.from(json['product']['serializedData']))
        : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'time': _time?.format(), 'quantity': _quantity, 'price': _price, 'product': _product?.toJson()
  };

  static final QueryField ID = QueryField(fieldName: "refund.id");
  static final QueryField TIME = QueryField(fieldName: "time");
  static final QueryField QUANTITY = QueryField(fieldName: "quantity");
  static final QueryField PRICE = QueryField(fieldName: "price");
  static final QueryField PRODUCT = QueryField(
    fieldName: "product",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Product).toString()));
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Refund";
    modelSchemaDefinition.pluralName = "Refunds";
    
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
      key: Refund.TIME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Refund.QUANTITY,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Refund.PRICE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.belongsTo(
      key: Refund.PRODUCT,
      isRequired: false,
      targetName: "refundProductId",
      ofModelName: (Product).toString()
    ));
  });
}

class _RefundModelType extends ModelType<Refund> {
  const _RefundModelType();
  
  @override
  Refund fromJson(Map<String, dynamic> jsonData) {
    return Refund.fromJson(jsonData);
  }
}