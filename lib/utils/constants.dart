class AssetConstants {
  static const base_path = "assets/images/";
  static const wabmart_icon = base_path + "wabmart_icon.svg";
  static const top_nav_icon = base_path + "top_nav_icon.png";
  static const wabmart_icon_2 = base_path + "wabmart_icon_2.png";
  static const limited_time_offer = base_path + "limited-time-offer.png";
}

class NetworkConstants {
  static const BASE_URL = "http://192.168.68.115:8000/api/v1/";
  // static const BASE_URL_IMAGE = "";

  //header parameters
  static const ACCEPT = "Accept";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";

  //End Urls
  static const SHOP_CATEGORIES = "shop-categories";
  static const HOME = "home?limit=24&brand_limit=24";
  static const ALL_SHOPS = "shops";
  static const PRODUCTS = "products";
  static const SEARCH_SHOPS = "filter-shops";
  static const SIGNUP = "signup";
  static const LOGIN = "login";
  static const SOCIAL_LOGIN = "social-login";
  static const VERIFY_CODE = "verify-code";
  static const ALL_SHOP_SUB_CATEGORIES = "shop-sub-categories";
  static const SHOP_DETAILS = "shops";
  static const PRODUCT_DETAILS = "products";
  static const SHOPS_PRODUCT_CATEGORIES = "product-categories";
  static const PROFILE = "profile";
  static const ADDRESSES = "addresses";
  static const SAVE_ADDRESS = "save-delivery-address";
  static const UPDATE_ADDRESS = "update-address";
  static const UPDATE_PROFILE = "update-profile";
  static const CARTS = "checkout/cart";
  static const PAYMENT_METHODS = "payment-methods";
  static const FORGOT_PASSWORD = "forgot-password";
  static const RESET_PASSWORD = "reset-password";
  static const CUSTOMER_ACCOUNT = "user/";
  static const CUSTOMER_ORDERS = "base-orders/";
  static const CUSTOMER_ORDER_CANCEL = "order-cancel/";
  static const ORDERS_DETAILS = "orders/";
  static const CUSTOMER_ORDER_TRACK = "order-track/";

  static const G_DISTANCE_API =
      "https://maps.googleapis.com/maps/api/distancematrix/json?origins=";

//{{base-api-url}}/shops/sweet-sour/products

//Todo
//{{base-api-url}}/shop-categories/restaurant/shops?lat=22.8131254&lng=89.5603476&page=1
//{{base-api-url}}/shop-categories/restaurant/subs
//{{base-api-url}}/filter-shops?lat=22.8131254&lng=89.5603476&page=1
//{{base-api-url}}/shops/sweet-sour
//{{base-api-url}}/shops/sweet-sour/product-categories
// {{base-api-url}}/product-categories/cake-2/products
}

class PreferenceKey {
  static const darkMode = "darkMode";
  static const languageBengali = "languageBengali";
}

class DefaultValue {
  static const bool kDefaultBoolean = false;
  static const int kDefaultInt = 0;
  static const double kDefaultDouble = 0.0;
  static const String kDefaultString = '';
}

class KeyConstants {
  static const TOKEN_KEY = "token";
  static const EMAIL_VERIFIED_KEY = "email_verified";
  static const DEVICE_VERIFIED_KEY = "device_verified";
  static const DEVICE_COOKIE = "device_cookie";
  static const CURRENCY_KEY = "currency";
  static const LANGUAGE_KEY = "language";
  static const MESSAGE_KEY = "message";
}

class DemoConstants {
  static const randomImage =
      "https://images.unsplash.com/photo-1619441174172-26e021833857?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80";
}

// Regular Expression
const String kRegExpEmail =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
const String kRegExpPhone = "(\\+[0-9]+[\\- \\.]*)?(\\([0-9]+\\)[\\- \\.]*)?" +
    "([0-9][0-9\\- \\.]+[0-9])";

const String patternMail =
    r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$";

// Keys
const String kKeyStatus = 'status';
const String kKeyJsonObject = 'json_object';
const String kKeyJsonArray = 'json_array';
const String kKeyStringData = 'string_data';
const String kKeyMessage = 'message';
const String kKeyData = 'data';
const String kKeyCode = 'code';
const String kKeyIsLoggedIn = 'is_logged_in';
const String kKeyAccessToken = 'access_token';
const String kPhone = 'phone_number';
const String kKeySelectedLocation = 'selected_location';
const String kKeyCurrency = 'currency';
const String kKeyLanguage = 'language';
const String kKeyLanguageCode = 'language_code';
const String kKeyName = 'name';
const String kKeyToken = 'token';
const String kKeyTokenType = 'token_type';
const String kKeyDeviceToken = 'device_token';
const String kKeyUser = 'user';
const String kKeyEmailVerifiedAt = 'email_verified_at';
const String kKeyPhoneVerifiedAt = 'phone_verified_at';
const String kKeyFaqText = 'faq_text';
const String kKeyTermsAndConditionsText = 'toc_text';
const String kKeyAverageRating = 'average_rating';
const String kKeyViews = 'views';
const String kKeyProvider = 'provider';
const String kFacebook = 'facebook';
const String kGoogle = 'google';
