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


/** This is an auto generated class representing the Product type in your schema. */
@immutable
class Product extends Model {
  static const classType = const _ProductModelType();
  final String id;
  final String? _name;
  final double? _price;
  final String? _categoryID;
  final double? _quantity;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  double get price {
    try {
      return _price!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  String? get categoryID {
    return _categoryID;
  }
  
  double get quantity {
    try {
      return _quantity!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  const Product._internal({required this.id, required name, required price, categoryID, required quantity}): _name = name, _price = price, _categoryID = categoryID, _quantity = quantity;
  
  factory Product({String? id, required String name, required double price, String? categoryID, required double quantity}) {
    return Product._internal(
      id: id == null ? UUID.getUUID() : id,
      name: name,
      price: price,
      categoryID: categoryID,
      quantity: quantity);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Product &&
      id == other.id &&
      _name == other._name &&
      _price == other._price &&
      _categoryID == other._categoryID &&
      _quantity == other._quantity;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Product {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("price=" + (_price != null ? _price!.toString() : "null") + ", ");
    buffer.write("categoryID=" + "$_categoryID" + ", ");
    buffer.write("quantity=" + (_quantity != null ? _quantity!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Product copyWith({String? id, String? name, double? price, String? categoryID, double? quantity}) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      categoryID: categoryID ?? this.categoryID,
      quantity: quantity ?? this.quantity);
  }
  
  Product.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _price = (json['price'] as num?)?.toDouble(),
      _categoryID = json['categoryID'],
      _quantity = (json['quantity'] as num?)?.toDouble();
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'price': _price, 'categoryID': _categoryID, 'quantity': _quantity
  };

  static final QueryField ID = QueryField(fieldName: "product.id");
  static final QueryField NAME = QueryField(fieldName: "name");
  static final QueryField PRICE = QueryField(fieldName: "price");
  static final QueryField CATEGORYID = QueryField(fieldName: "categoryID");
  static final QueryField QUANTITY = QueryField(fieldName: "quantity");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Product";
    modelSchemaDefinition.pluralName = "Products";
    
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
      key: Product.NAME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Product.PRICE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Product.CATEGORYID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Product.QUANTITY,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
  });
}

class _ProductModelType extends ModelType<Product> {
  const _ProductModelType();
  
  @override
  Product fromJson(Map<String, dynamic> jsonData) {
    return Product.fromJson(jsonData);
  }
}