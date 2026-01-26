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


/** This is an auto generated class representing the Category type in your schema. */
@immutable
class Category extends Model {
  static const classType = const _CategoryModelType();
  final String id;
  final String? _name;
  final List<Product>? _products;

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
  
  List<Product>? get products {
    return _products;
  }
  
  const Category._internal({required this.id, required name, products}): _name = name, _products = products;
  
  factory Category({String? id, required String name, List<Product>? products}) {
    return Category._internal(
      id: id == null ? UUID.getUUID() : id,
      name: name,
      products: products != null ? List<Product>.unmodifiable(products) : products);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Category &&
      id == other.id &&
      _name == other._name &&
      DeepCollectionEquality().equals(_products, other._products);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Category {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Category copyWith({String? id, String? name, List<Product>? products}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      products: products ?? this.products);
  }
  
  Category.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _products = json['products'] is List
        ? (json['products'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Product.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'products': _products?.map((Product? e) => e?.toJson()).toList()
  };

  static final QueryField ID = QueryField(fieldName: "category.id");
  static final QueryField NAME = QueryField(fieldName: "name");
  static final QueryField PRODUCTS = QueryField(
    fieldName: "products",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Product).toString()));
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Category";
    modelSchemaDefinition.pluralName = "Categories";
    
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
      key: Category.NAME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: Category.PRODUCTS,
      isRequired: false,
      ofModelName: (Product).toString(),
      associatedKey: Product.CATEGORYID
    ));
  });
}

class _CategoryModelType extends ModelType<Category> {
  const _CategoryModelType();
  
  @override
  Category fromJson(Map<String, dynamic> jsonData) {
    return Category.fromJson(jsonData);
  }
}