

enum SocialType { EMPTY, KAKAO, GOOGLE, APPLE, TEST }

extension SocialTypeName on SocialType {
  String get name {
    switch (this) {
      case SocialType.KAKAO:
        return 'KAKAO';
      case SocialType.GOOGLE:
        return 'GOOGLE';
      case SocialType.APPLE:
        return 'APPLE';
      case SocialType.TEST:
        return 'TEST';
      case SocialType.EMPTY:
        return 'EMPTY';
    }
  }

  String get accessToken {
    switch (this) {
      case SocialType.EMPTY:
      case SocialType.KAKAO:
      case SocialType.GOOGLE:
      case SocialType.APPLE:
        return '';
      case SocialType.TEST:
        return 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJleGl0MTE5MEBlenRlY2hmaW4uY28ua3IiLCJhdXRoIjoiUk9MRV9VU0VSIiwiZXhwIjoxNjU3MjY5MDc1LCJ1c2VySWQiOiI5In0.Ns-r8LGKQ3_JtdaYoy_9U4e0gCsj-Ogtr-LGlLBKhqOiRJFozgaIWXq05OmwpdsGwz5tD-cJrL1MyIlbD4bxOA';
    }
  }

  String get refreshToken {
    switch (this) {
      case SocialType.EMPTY:
      case SocialType.KAKAO:
      case SocialType.GOOGLE:
      case SocialType.APPLE:
        return '';
      case SocialType.TEST:
        return 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJleGl0MTE5MEBlenRlY2hmaW4uY28ua3IiLCJhdXRoIjoiUk9MRV9VU0VSIiwiZXhwIjoxNjU5Nzc0Njc1LCJ1c2VySWQiOiI5In0.eDRog8hQEpDROTf2MHWDjx_xgwxaQRUCgRcbQZk-tuYhvarU0vGgegfv2KnW34rI2wI9TJwXNrg2-2sPXxR77Q';
    }
  }
}

enum SignInStep { init, board, terms, email, emailConfirm, password, finish, complete }



enum PrefKey {
  fcmToken,
  accessToken,
  refreshToken,
  signInStep,
  socialType,
  nickname,
  profileImage,
  uaaId,
  email,
  provider,
  certified,
  currency,
  permissionCamera
}

extension PrefKeyName on PrefKey {
  String get name {
    switch (this) {
      case PrefKey.fcmToken:
        return 'FCM_TOKEN';
      case PrefKey.accessToken:
        return 'ACCESS_TOKEN';
      case PrefKey.refreshToken:
        return 'REFRESH_TOKEN';
      case PrefKey.signInStep:
        return "SIGN_IN_STEP";
      case PrefKey.socialType:
        return "SOCIAL_TYPE";
      case PrefKey.uaaId:
        return "UAA_ID";
      case PrefKey.nickname:
        return "NICKNAME";
      case PrefKey.profileImage:
        return "PROFILE_IMAGE";
      case PrefKey.email:
        return 'EMAIL';
      case PrefKey.provider:
        return 'PROVIDER';
      case PrefKey.certified:
        return 'CERTIFIED';
      case PrefKey.currency:
        return 'CURRENCY';
      case PrefKey.permissionCamera:
        return 'PERMISSION_CAMERA';
    }
  }
}

enum HiveKey { password, publicKey, secretKey, uuid }

extension HiveKeyName on HiveKey {
  String get name {
    switch (this) {
      case HiveKey.password:
        return "password";
      case HiveKey.publicKey:
        return "publicKey";
      case HiveKey.secretKey:
        return "secretKey";
      case HiveKey.uuid:
        return "uuid";
    }
  }
}
enum NetWorkState { Idle, Loading, Completion, Error }

enum LoginStatus { created, success, successButFakeEmail,successButNotWallet, failed, terminationRequested, terminationCompleted, alreadyConnectedDevice }

enum FeeState { available, notExist, notAvailable, unknown }

enum ErrorViewType { normal, confirm }

enum TokenType { sol, ezt, stik }

enum Currency { krw, usd }

enum TransactionType { IN,Ining, OUT,outing, FEE, UNKNOWN,error }

enum WhereFromSelectMemberType { none, memberSearch, recent, favorite, address }

enum Nationality { local, foreigner, none }

enum Gender { male, female, none }

enum MobileCompany { sk, kt, lg, sk_cheap, kt_cheap, lg_cheap }

extension TransactionName on TransactionType {
  String get text {
    switch (this) {
      case TransactionType.IN:
        return "받기";
      case TransactionType.OUT:
        return "보내기";
      case TransactionType.FEE:
        return "수수료 지불";
      case TransactionType.UNKNOWN:
        return "UNKNOWN";
      case TransactionType.Ining:
        return "진행중";
      case TransactionType.outing:
        return "진행중";
      case TransactionType.error:
        return '실패';
    }
  }

  String get imagePath {
    switch (this) {
      case TransactionType.IN:
      case TransactionType.Ining:
        return "assets/images/wallet_detail_list_recive.png";
      case TransactionType.OUT:
      case TransactionType.outing:
        return "assets/images/wallet_detail_list_send.png";
      case TransactionType.FEE:
        return "assets/images/ic_commission.png";
      case TransactionType.UNKNOWN:
      case TransactionType.error:
        return "assets/images/ic_commission.png";
    }
  }
}

extension TokenName on TokenType {
  String get tokenName {
    switch (this) {
      case TokenType.sol:
        return "SOL";
      case TokenType.ezt:
        return "EZT";
      case TokenType.stik:
        return "STIK";
    }
  }
}

extension FeeStateName on FeeState {
  String get stateName {
    switch (this) {
      case FeeState.available:
        return "AVAILABLE";
      case FeeState.notExist:
        return "NOT_EXIST";
      case FeeState.notAvailable:
        return "NOT_AVAILABLE";
      case FeeState.unknown:
        return "UNKNOWN";
    }
  }
  String get description {
    switch (this) {
      case FeeState.available:
        return "유효한 계정";
      case FeeState.notExist:
        return "받는 분께서 토큰 계정을 가지고 있지 않아 계정 생성 비용이 발생하며, 이를 이해하고 진행을 원합니다.";
      case FeeState.notAvailable:
        return "받는 분 주소에 오류가 있어 진행할 수 없습니다.";
      case FeeState.unknown:
        return "UNKNOWN";
    }
  }
}

extension GenderName on Gender {
  String get genderValue {
    switch(this){
      case Gender.male:
        return 'MALE';
      case Gender.female:
        return 'FEMALE';
      case Gender.none:
        return '';
    }
  }
}

extension NationalityName on Nationality {
  bool get isForeigner {
    switch(this){
      case Nationality.local:
      case Nationality.none:
        return false;
      case Nationality.foreigner:
        return true;
    }
  }
}

extension MobileCompanyName on MobileCompany{
  String get mobileCompanyName {
    switch(this){
      case MobileCompany.sk:
        return 'SKT';
      case MobileCompany.kt:
        return 'KT';
      case MobileCompany.lg:
        return 'LG U+';
      case MobileCompany.sk_cheap:
        return 'SKT 알뜰폰';
      case MobileCompany.kt_cheap:
        return 'KT 알뜰폰';
      case MobileCompany.lg_cheap:
        return 'LG U+ 알뜰폰';
    }
  }
}