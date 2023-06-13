class PlaceOrderBody {
  List<Cart>? cart;
  String? orderNote;
  int? storeId;
  double? discount;
  String? discountType;
  double? tax;
  double? paidAmount;
  String? paymentMethod;

  PlaceOrderBody(
      {this.cart,
        this.orderNote,
        this.storeId,
        this.discount,
        this.discountType,
        this.tax,
        this.paidAmount,
        this.paymentMethod});

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      cart = [];
      json['cart'].forEach((v) {
        cart!.add(Cart.fromJson(v));
      });
    }
    orderNote = json['order_note'];
    storeId = json['store_id'];
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    tax = json['tax'].toDouble();
    paidAmount = json['paid_amount'].toDouble();
    paymentMethod = json['payment_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cart != null) {
      data['cart'] = cart!.map((v) => v.toJson()).toList();
    }
    data['order_note'] = orderNote;
    data['store_id'] = storeId;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['tax'] = tax;
    data['paid_amount'] = paidAmount;
    data['payment_method'] = paymentMethod;
    return data;
  }
}

class Cart {
  int? itemId;
  int? itemCampaignId;
  double? price;
  List<String>? variant;
  List<Variation>? variation;
  double? discountAmount;
  int? quantity;
  double? taxAmount;
  List<int>? addOnIds;
  List<int>? addOnQtys;

  Cart(
      {this.itemId,
        this.itemCampaignId,
        this.price,
        this.variant,
        this.variation,
        this.discountAmount,
        this.quantity,
        this.taxAmount,
        this.addOnIds,
        this.addOnQtys});

  Cart.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemCampaignId = json['item_campaign_id'];
    price = json['price'].toDouble();
    variant = json['variant'].cast<String>();
    if (json['variation'] != null) {
      variation = [];
      json['variation'].forEach((v) {
        variation!.add(Variation.fromJson(v));
      });
    }
    discountAmount = json['discount_amount'].toDouble();
    quantity = json['quantity'];
    taxAmount = json['tax_amount'].toDouble();
    addOnIds = json['add_on_ids'].cast<int>();
    addOnQtys = json['add_on_qtys'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['item_campaign_id'] = itemCampaignId;
    data['price'] = price;
    data['variant'] = variant;
    if (variation != null) {
      data['variation'] = variation!.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = discountAmount;
    data['quantity'] = quantity;
    data['tax_amount'] = taxAmount;
    data['add_on_ids'] = addOnIds;
    data['add_on_qtys'] = addOnQtys;
    return data;
  }
}

class Variation {
  String? type;
  double? price;

  Variation({this.type, this.price});

  Variation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['price'] = price;
    return data;
  }
}
