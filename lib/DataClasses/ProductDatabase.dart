import 'package:parse_server_sdk/parse_server_sdk.dart';

class ProductDatabase extends ParseObject implements ParseCloneable{
  String className;
  String objectId;
  String sgst;
  String productSku;
  String taxCode;
  String categoryName;
  String productPurchasePrice;
  String roCode;
  String taxName;
  String cgst;
  String productName;
  String productQuantity;
  String productSalePrice;

  ProductDatabase(
      {this.className,
        this.objectId,
        this.sgst,
        this.productSku,
        this.taxCode,
        this.categoryName,
        this.productPurchasePrice,
        this.roCode,
        this.taxName,
        this.cgst,
        this.productName,
        this.productQuantity,
        this.productSalePrice});

  ProductDatabase.fromJson(Map<String, dynamic> json) {
    className = json['className'];
    objectId = json['objectId'];
    sgst = json['sgst'];
    productSku = json['product_sku'];
    taxCode = json['tax_code'];
    categoryName = json['category_name'];
    productPurchasePrice = json['product_purchase_price'];
    roCode = json['ro_code'];
    taxName = json['tax_name'];
    cgst = json['cgst'];
    productName = json['product_name'];
    productQuantity = json['product_quantity'];
    productSalePrice = json['product_sale_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['className'] = this.className;
    data['objectId'] = this.objectId;
    data['sgst'] = this.sgst;
    data['product_sku'] = this.productSku;
    data['tax_code'] = this.taxCode;
    data['category_name'] = this.categoryName;
    data['product_purchase_price'] = this.productPurchasePrice;
    data['ro_code'] = this.roCode;
    data['tax_name'] = this.taxName;
    data['cgst'] = this.cgst;
    data['product_name'] = this.productName;
    data['product_quantity'] = this.productQuantity;
    data['product_sale_price'] = this.productSalePrice;
    return data;
  }



}