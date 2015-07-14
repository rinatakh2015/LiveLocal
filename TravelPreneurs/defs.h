
// Maximum number of bytes that a text message may have. The payload data of
// a push notification is limited to 256 bytes and that includes the JSON 
// overhead and the name of the sender.
#define _DEBUGMOD



/********************Backend Server*******************/
//#define BASE_URL @"http://corporatepreneurs.com/travel_preneurs" //ip 162.144.67.16
#define BASE_URL @"http://corporatepreneurs.com/live_local"
//#define BASE_URL @"http://localhost/travel_preneurs"
#define SIGNUP_URL @"register.php"
#define LOGIN_URL @"login.php"
#define LOGOUT_URL @"logout.php"
#define UPDATE_PROFILE_URL @"update_profile.php"
#define GET_NEARBY_USERS_URL @"get_nearby_users.php"
#define GET_USER_REVIEWS_URL @"get_user_reviews.php"
#define WRITE_USER_REVIEW_URL @"write_user_review.php"
#define GET_FAVOURITE_USERS_URL @"get_favourite_users.php"
#define FAVOURITE_USER_URL @"favourite_user.php"
#define DISFAVOURITE_USER_URL @"disfavourite_user.php"
#define GET_USER_UPLOADED_PHOTOS_URL @"get_user_uploaded_photos.php"
#define DELETE_USER_UPLOADED_PHOTOS_URL @"delete_user_uploaded_photos.php"
#define UPLOAD_USER_PHOTO_URL @"upload_user_photo.php"
#define GET_GREETING_WORDS_URL @"get_greeting_words.php"
#define WRITE_GREETING_WORDS_URL @"write_greeting_words.php"
#define UPDATE_LOCATION_URL @"update_location.php"
#define REPORT_VIOLATION_URL @"report_violation.php"
#define CHANGE_PASSWORD_URL @"send_email.php"
#define VERIFICATION_URL @"account/get-verify-code"
#define RESET_PASSWORD_URL @"account/reset-password"
#define UPLOAD_PHOTO_URL @"uploader.php"
#define CHECKCARD_URL @"check_card.php"
/**************XMPP Server********************************/
#define PKL_XMPP_SERVER_NAME @"corporatepreneurs.com" //162.144.67.16
#define PKL_XMPP_PORT 5222

#define PKL_XMPP_DOMAIN_NAME @"server.corporatepreneurs.com"

#define PKL_XMPP_REGISTER_USER_URL @"http://corporatepreneurs.com:9090/plugins/userService" //http://162.144.67.16:9090/plugins/userService
#define PKL_XMPP_ADMIN_SECRET_KEY @"G9p4XS7q"
#define PKL_XMPP_USER_DEFAULT_PASSWORD @"Great2015"

#define PKL_MESSAGE_TYPE_TEXT @"1"
#define PKL_MESSAGE_TYPE_PHOTO @"2"

/*********Define Error Domain****************/
#define SERVER_ERROR @"SERVER ERROR"
#define INVALID_ACCESS @"INVALID ACCESS"
#define NETWORK_ERROR @"NETWORK ERROR"
#define JSON_ERROR @"JSON_ERROR"
#define RESULT_FAILED @"RESULT FAILED"
#define INVALID_DATA @"INVALID DATA"
/****************** Define Photo ***************************/
#define PHOTO_WIDTH 200
#define PHOTO_HEIGHT 200
#define PHOTO_FILE_NAME_PREFIX @"userphoto"
#define PHOTO_FILE_NAME @"userphoto.png"

/************************************************/
#define SUB_CATEGORY_PANEL_HEIGHT 210
#define LABEL_FONTSIZE 14

#define MAIN_AVATAR_BORDER_WIDTH 4
#define MAIN_AVATAR_BORDER_COLOR [UIColor whiteColor]

#define COUNTS_PER_PAGE 100
 
/*********************** User Key Defintion ********************************/
static NSString* const kUserId = @"user_id";
static NSString* const kUserName = @"user_name";
static NSString* const kPhone = @"phone";
static NSString* const kPassword = @"password";
static NSString* const kAccessToken = @"access_token";
static NSString* const kFullname = @"fullname";
static NSString* const kEmail = @"email";
static NSString* const kTimeCreated = @"time_created";
static NSString* const kOfflineAvatar = @"offline_avatar";
static NSString* const kCountry = @"country";
static NSString* const kNativeLanguage = @"native_language";
static NSString* const kSpokenLanguages = @"spoken_languages";
static NSString* const kAccountType = @"account_type";
static NSString* const kMainCategory = @"main_category";
static NSString* const kSubCategories = @"sub_categories";
static NSString* const kBusinessName = @"business_name";
static NSString* const kManagerName = @"manager_name";
static NSString* const kAddress1 = @"address1";
static NSString* const kAddress2 = @"address2";
static NSString* const kCity = @"city";
static NSString* const kState = @"state";
static NSString* const kPostalCode = @"postal_code";
static NSString* const kFacebook = @"facebook";
static NSString* const kLinkedin = @"linkedin";
static NSString* const kWebsite = @"website";
static NSString* const kAvatarImageURL = @"avatar_image_url";
static NSString* const kBackgroundImageURL = @"background_image_url";
static NSString* const kLatitude = @"latitude";
static NSString* const kLongitude = @"longitude";
static NSString* const kVerified = @"verified";
static NSString* const kBlocked = @"blocked";
static NSString* const kRegisteredCard = @"registered_card";
static NSString* const kCreditCard = @"card";
/******************** Other Keyword **********************/
static NSString* const kDeviceToken = @"device_token";
static NSString* const kClientPlatform = @"client_platform";
static NSString* const kClientVersion = @"client_version";
static NSString* const kRadius = @"radius";
static NSString* const kPageCount = @"page_count";
static NSString* const kCurrentPage = @"current_page";
static NSString* const kSearchUserID = @"search_user_id";
static NSString* const kRating = @"rating";
static NSString* const kText = @"text";
static NSString* const kPhotoID = @"photo_id";
static NSString* const kPhotoIDs = @"photo_ids";
static NSString* const kPhotoURL = @"photo";
static NSString* const kSelected = @"selected";
static NSString* const kTotalReviews = @"total_reviews";
static NSString* const kCountsOfFiveStars = @"counts_of_five_stars";
static NSString* const kCountsOfFourStars = @"counts_of_four_stars";
static NSString* const kCountsOfThreeStars = @"counts_of_three_stars";
static NSString* const kCountsOfTwoStars = @"counts_of_two_stars";
static NSString* const kCountsOfOneStar = @"counts_of_one_star";
static NSString* const kData = @"data";
static NSString* const kReviewId = @"review_id";
static NSString* const kFavouriteIds = @"favourite_ids";
static NSString* const kType = @"type";
static NSString* const kCardNumber = @"card_number";
static NSString* const kExpiryMonth = @"expiry_month";
static NSString* const kExpiryYear = @"expiry_year";
static NSString* const kCvv = @"cvv";
static NSString* const kTitle = @"title";
static NSString* const kEnable = @"enable";
static NSString* const kUploadTypeAvatar = @"avatar_image";
static NSString* const kUploadTypeUserImage = @"user_image";
static NSString* const kUploadTypeBackground = @"background_image";
static NSString* const kFileName = @"filename";
static NSString* const kThumbnail = @"thumb";
/******************Color*************************/
#define BLUE_BACKGROUND_COLOR [UIColor colorWithRed:10/255.0 green:65/255.0 blue:127/255.0 alpha:0.7]