import 'package:sixam_mart_store/data/model/response/item_model.dart';

class CartModel {
  double? price;
  double? discountedPrice;
  List<Variation>? variation;
  double? discountAmount;
  int? quantity;
  List<AddOn>? addOnIds;
  List<AddOns>? addOns;
  bool? isCampaign;
  Item? item;

  CartModel({this.price, this.discountedPrice, this.variation, this.discountAmount, this.quantity,
    this.addOnIds, this.addOns, this.isCampaign, this.item});

  CartModel.fromJson(Map<String, dynamic> json) {
    price = json['price'].toDouble();
    discountedPrice = json['discounted_price'].toDouble();
    if (json['variation'] != null) {
      variation = [];
      json['variation'].forEach((v) {
        variation!.add(Variation.fromJson(v));
      });
    }
    discountAmount = json['discount_amount'].toDouble();
    quantity = json['quantity'];
    if (json['add_on_ids'] != null) {
      addOnIds = [];
      json['add_on_ids'].forEach((v) {
        addOnIds!.add(AddOn.fromJson(v));
      });
    }
    if (json['add_ons'] != null) {
      addOns = [];
      json['add_ons'].forEach((v) {
        addOns!.add(AddOns.fromJson(v));
      });
    }
    isCampaign = json['is_campaign'];
    if (json['item'] != null) {
      item = Item.fromJson(json['item']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['discounted_price'] = discountedPrice;
    if (variation != null) {
      data['variation'] = variation!.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = discountAmount;
    data['quantity'] = quantity;
    if (addOnIds != null) {
      data['add_on_ids'] = addOnIds!.map((v) => v.toJson()).toList();
    }
    if (addOns != null) {
      data['add_ons'] = addOns!.map((v) => v.toJson()).toList();
    }
    data['is_campaign'] = isCampaign;
    data['item'] = item!.toJson();
    return data;
  }
}

class AddOn {
  int? id;
  int? quantity;

  AddOn({this.id, this.quantity});

  AddOn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    return data;
  }
}
