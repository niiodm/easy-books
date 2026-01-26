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
import 'Category.dart';
import 'Expense.dart';
import 'Log.dart';
import 'Product.dart';
import 'Receipt.dart';
import 'Refund.dart';
import 'Sale.dart';
import 'Stock.dart';
import 'User.dart';
import 'Version.dart';

export 'Category.dart';
export 'Expense.dart';
export 'Log.dart';
export 'Product.dart';
export 'Receipt.dart';
export 'Refund.dart';
export 'Sale.dart';
export 'Stock.dart';
export 'User.dart';
export 'Version.dart';

class ModelProvider implements ModelProviderInterface {
  @override
  String version = "28d086ad4fe705aefe4bab18be39ca45";
  @override
  List<ModelSchema> modelSchemas = [Category.schema, Expense.schema, Log.schema, Product.schema, Receipt.schema, Refund.schema, Sale.schema, Stock.schema, User.schema, Version.schema];
  static final ModelProvider _instance = ModelProvider();

  static ModelProvider get instance => _instance;
  
  ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
    case "Category": {
    return Category.classType;
    }
    break;
    case "Expense": {
    return Expense.classType;
    }
    break;
    case "Log": {
    return Log.classType;
    }
    break;
    case "Product": {
    return Product.classType;
    }
    break;
    case "Receipt": {
    return Receipt.classType;
    }
    break;
    case "Refund": {
    return Refund.classType;
    }
    break;
    case "Sale": {
    return Sale.classType;
    }
    break;
    case "Stock": {
    return Stock.classType;
    }
    break;
    case "User": {
    return User.classType;
    }
    break;
    case "Version": {
    return Version.classType;
    }
    break;
    default: {
    throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
    }
  }
}