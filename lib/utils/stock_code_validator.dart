/// 日本証券取引所の証券コード形式を検証するためのバリデーター
///
/// 対応形式：
/// - 従来形式：数字4桁（1300-9999）
/// - 新形式（2024年1月以降）：
///   - 4桁目のみ英文字：130A, 987A等
///   - 2桁目のみ英文字：1A00, 9A76等
///   - 2桁目と4桁目両方：9A7A等
///
/// 使用可能英文字：A, C, D, F, G, H, J, K, L, M, N, P, R, S, T, U, W, X, Y
/// 除外文字：B, E, I, O, Q, V, Z
class StockCodeValidator {
  // 使用可能な英文字（B, E, I, O, Q, V, Zを除く）
  static const String _allowedLetters = "ACDFGHJKLMNPRSTUWXY";

  // 従来形式：数字4桁（1-9で始まる）
  static final RegExp _traditionalPattern = RegExp(r"^[1-9]\d{3}$");

  // 4桁目のみ英文字
  static final RegExp _fourthLetterPattern =
      RegExp(r"^[1-9]\d{2}[ACDFGHJKLMNPRSTUWXY]$");

  // 2桁目のみ英文字
  static final RegExp _secondLetterPattern =
      RegExp(r"^[1-9][ACDFGHJKLMNPRSTUWXY]\d{2}$");

  // 2桁目と4桁目両方英文字
  static final RegExp _bothLettersPattern =
      RegExp(r"^[1-9][ACDFGHJKLMNPRSTUWXY]\d[ACDFGHJKLMNPRSTUWXY]$");

  // 全形式対応の統合正規表現
  static final RegExp _allPattern = RegExp(
      r"^(?:[1-9]\d{3}|[1-9][ACDFGHJKLMNPRSTUWXY]\d{2}|[1-9]\d{2}[ACDFGHJKLMNPRSTUWXY]|[1-9][ACDFGHJKLMNPRSTUWXY]\d[ACDFGHJKLMNPRSTUWXY])$");

  /// 証券コードが有効かどうかを検証する
  ///
  /// [code] 検証する証券コード
  /// 戻り値：有効な場合true、無効な場合false
  static bool isValid(String code) {
    if (code.isEmpty || code.length != 4) {
      return false;
    }

    return _allPattern.hasMatch(code.toUpperCase());
  }

  /// 証券コードが従来形式（数字4桁）かどうかを判定
  static bool isTraditionalFormat(String code) {
    return _traditionalPattern.hasMatch(code);
  }

  /// 証券コードが新形式（英文字含む）かどうかを判定
  static bool isNewFormat(String code) {
    if (code.isEmpty || code.length != 4) {
      return false;
    }

    String upperCode = code.toUpperCase();
    return _fourthLetterPattern.hasMatch(upperCode) ||
        _secondLetterPattern.hasMatch(upperCode) ||
        _bothLettersPattern.hasMatch(upperCode);
  }

  /// 証券コードの形式タイプを取得
  static SecurityCodeType getCodeType(String code) {
    if (!isValid(code)) {
      return SecurityCodeType.invalid;
    }

    String upperCode = code.toUpperCase();

    if (_traditionalPattern.hasMatch(upperCode)) {
      return SecurityCodeType.traditional;
    } else if (_fourthLetterPattern.hasMatch(upperCode)) {
      return SecurityCodeType.fourthLetter;
    } else if (_secondLetterPattern.hasMatch(upperCode)) {
      return SecurityCodeType.secondLetter;
    } else if (_bothLettersPattern.hasMatch(upperCode)) {
      return SecurityCodeType.bothLetters;
    }

    return SecurityCodeType.invalid;
  }

  /// 使用可能な英文字一覧を取得
  static List<String> getAllowedLetters() {
    return _allowedLetters.split("");
  }

  /// 除外される英文字一覧を取得
  static List<String> getExcludedLetters() {
    return ["B", "E", "I", "O", "Q", "V", "Z"];
  }

  /// 証券コードの例を生成
  static List<String> generateExamples() {
    return [
      "8697", // 従来形式
      "130A", // 4桁目英文字
      "1A00", // 2桁目英文字
      "9A7A", // 両方英文字
    ];
  }
}

/// 証券コードの形式タイプ
enum SecurityCodeType {
  invalid, // 無効
  traditional, // 従来形式（数字4桁）
  fourthLetter, // 4桁目のみ英文字
  secondLetter, // 2桁目のみ英文字
  bothLetters, // 2桁目と4桁目両方英文字
}
