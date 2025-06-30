import "package:flutter_test/flutter_test.dart";
import "package:jpstockminimemo/utils/stock_code_validator.dart";

void main() {
  group("StockCodeValidator", () {
    group("isValid メソッドのテスト", () {
      test("従来形式（数字4桁）の有効な証券コード", () {
        // 有効な従来形式の証券コード
        final validTraditionalCodes = [
          "1300",
          "1301",
          "2000",
          "3000",
          "4000",
          "5000",
          "6000",
          "7000",
          "8000",
          "9000",
          "9999",
          "8697",
        ];

        for (String code in validTraditionalCodes) {
          expect(StockCodeValidator.isValid(code), true,
              reason: "Code $code should be valid");
        }
      });

      test("新形式（4桁目のみ英文字）の有効な証券コード", () {
        // 4桁目のみ英文字の有効なコード
        final validFourthLetterCodes = [
          "130A",
          "130C",
          "130D",
          "130F",
          "130G",
          "130H",
          "130J",
          "130K",
          "130L",
          "130M",
          "130N",
          "130P",
          "130R",
          "130S",
          "130T",
          "130U",
          "130W",
          "130X",
          "130Y",
          "987A",
          "999Y",
        ];

        for (String code in validFourthLetterCodes) {
          expect(StockCodeValidator.isValid(code), true,
              reason: "Code $code should be valid");
        }
      });

      test("新形式（2桁目のみ英文字）の有効な証券コード", () {
        // 2桁目のみ英文字の有効なコード
        final validSecondLetterCodes = [
          "1A00",
          "1C00",
          "1D00",
          "1F00",
          "1G00",
          "1H00",
          "1J00",
          "1K00",
          "1L00",
          "1M00",
          "1N00",
          "1P00",
          "1R00",
          "1S00",
          "1T00",
          "1U00",
          "1W00",
          "1X00",
          "1Y00",
          "9A76",
          "9Y99",
        ];

        for (String code in validSecondLetterCodes) {
          expect(StockCodeValidator.isValid(code), true,
              reason: "Code $code should be valid");
        }
      });

      test("新形式（2桁目と4桁目両方英文字）の有効な証券コード", () {
        // 2桁目と4桁目両方英文字の有効なコード
        final validBothLettersCodes = [
          "1A0A",
          "1C0C",
          "1D0D",
          "1F0F",
          "1G0G",
          "1H0H",
          "1J0J",
          "1K0K",
          "1L0L",
          "1M0M",
          "1N0N",
          "1P0P",
          "1R0R",
          "1S0S",
          "1T0T",
          "1U0U",
          "1W0W",
          "1X0X",
          "1Y0Y",
          "9A7A",
          "9Y9Y",
        ];

        for (String code in validBothLettersCodes) {
          expect(StockCodeValidator.isValid(code), true,
              reason: "Code $code should be valid");
        }
      });

      test("無効な証券コード - 先頭が0", () {
        final invalidZeroStartCodes = [
          "0123",
          "0000",
          "0999",
          "0A00",
          "012A",
        ];

        for (String code in invalidZeroStartCodes) {
          expect(StockCodeValidator.isValid(code), false,
              reason: "Code $code should be invalid (starts with 0)");
        }
      });

      test("無効な証券コード - 除外文字を含む", () {
        final invalidExcludedLetterCodes = [
          "1B00",
          "1E00",
          "1I00",
          "1O00",
          "1Q00",
          "1V00",
          "1Z00",
          "123B",
          "123E",
          "123I",
          "123O",
          "123Q",
          "123V",
          "123Z",
          "1B0B",
          "1E0E",
          "1I0I",
          "1O0O",
          "1Q0Q",
          "1V0V",
          "1Z0Z",
        ];

        for (String code in invalidExcludedLetterCodes) {
          expect(StockCodeValidator.isValid(code), false,
              reason:
                  "Code $code should be invalid (contains excluded letter)");
        }
      });

      test("無効な証券コード - 長さが4以外", () {
        final invalidLengthCodes = [
          "",
          "1",
          "12",
          "123",
          "12345",
          "123456",
        ];

        for (String code in invalidLengthCodes) {
          expect(StockCodeValidator.isValid(code), false,
              reason: "Code $code should be invalid (wrong length)");
        }
      });

      test("無効な証券コード - 不正な位置の英文字", () {
        final invalidPositionCodes = [
          "A123", // 1桁目に英文字
          "12A3", // 3桁目に英文字
        ];

        for (String code in invalidPositionCodes) {
          expect(StockCodeValidator.isValid(code), false,
              reason:
                  "Code $code should be invalid (letter in wrong position)");
        }
      });

      test("大文字小文字の変換テスト", () {
        final mixedCaseCodes = [
          "130a", "130A", // 同じコードの大文字小文字
          "1a00", "1A00",
          "9a7a", "9A7A",
        ];

        for (String code in mixedCaseCodes) {
          expect(StockCodeValidator.isValid(code), true,
              reason: "Code $code should be valid (case insensitive)");
        }
      });
    });

    group("isTraditionalFormat メソッドのテスト", () {
      test("従来形式の判定", () {
        final traditionalCodes = ["1300", "8697", "9999"];
        for (String code in traditionalCodes) {
          expect(StockCodeValidator.isTraditionalFormat(code), true,
              reason: "Code $code should be traditional format");
        }
      });

      test("新形式は従来形式ではない", () {
        final newFormatCodes = ["130A", "1A00", "9A7A"];
        for (String code in newFormatCodes) {
          expect(StockCodeValidator.isTraditionalFormat(code), false,
              reason: "Code $code should not be traditional format");
        }
      });
    });

    group("isNewFormat メソッドのテスト", () {
      test("新形式の判定", () {
        final newFormatCodes = ["130A", "1A00", "9A7A"];
        for (String code in newFormatCodes) {
          expect(StockCodeValidator.isNewFormat(code), true,
              reason: "Code $code should be new format");
        }
      });

      test("従来形式は新形式ではない", () {
        final traditionalCodes = ["1300", "8697", "9999"];
        for (String code in traditionalCodes) {
          expect(StockCodeValidator.isNewFormat(code), false,
              reason: "Code $code should not be new format");
        }
      });
    });

    group("getCodeType メソッドのテスト", () {
      test("従来形式のタイプ判定", () {
        expect(StockCodeValidator.getCodeType("1300"),
            SecurityCodeType.traditional);
        expect(StockCodeValidator.getCodeType("8697"),
            SecurityCodeType.traditional);
      });

      test("4桁目英文字形式のタイプ判定", () {
        expect(StockCodeValidator.getCodeType("130A"),
            SecurityCodeType.fourthLetter);
        expect(StockCodeValidator.getCodeType("987Y"),
            SecurityCodeType.fourthLetter);
      });

      test("2桁目英文字形式のタイプ判定", () {
        expect(StockCodeValidator.getCodeType("1A00"),
            SecurityCodeType.secondLetter);
        expect(StockCodeValidator.getCodeType("9Y76"),
            SecurityCodeType.secondLetter);
      });

      test("2桁目と4桁目両方英文字形式のタイプ判定", () {
        expect(StockCodeValidator.getCodeType("9A7A"),
            SecurityCodeType.bothLetters);
        expect(StockCodeValidator.getCodeType("1Y9Y"),
            SecurityCodeType.bothLetters);
      });

      test("無効なコードのタイプ判定", () {
        expect(
            StockCodeValidator.getCodeType("0123"), SecurityCodeType.invalid);
        expect(
            StockCodeValidator.getCodeType("12B3"), SecurityCodeType.invalid);
        expect(StockCodeValidator.getCodeType(""), SecurityCodeType.invalid);
      });
    });

    group("ヘルパーメソッドのテスト", () {
      test("getAllowedLetters メソッド", () {
        final allowedLetters = StockCodeValidator.getAllowedLetters();
        expect(allowedLetters.length, 19);
        expect(allowedLetters.contains("A"), true);
        expect(allowedLetters.contains("B"), false); // 除外文字
        expect(allowedLetters.contains("Z"), false); // 除外文字
      });

      test("getExcludedLetters メソッド", () {
        final excludedLetters = StockCodeValidator.getExcludedLetters();
        expect(excludedLetters.length, 7);
        expect(excludedLetters, ["B", "E", "I", "O", "Q", "V", "Z"]);
      });

      test("generateExamples メソッド", () {
        final examples = StockCodeValidator.generateExamples();
        expect(examples.length, 4);

        // 各例が有効な証券コードであることを確認
        for (String example in examples) {
          expect(StockCodeValidator.isValid(example), true,
              reason: "Example $example should be valid");
        }
      });
    });

    group("実際の証券コード例でのテスト", () {
      test("実在する証券コード（従来形式）", () {
        final realCodes = [
          "8697", // 日本取引所グループ
          "9984", // ソフトバンクグループ
          "7203", // トヨタ自動車
          "6758", // ソニーグループ
          "9434", // ソフトバンク
        ];

        for (String code in realCodes) {
          expect(StockCodeValidator.isValid(code), true,
              reason: "Real code $code should be valid");
          expect(StockCodeValidator.getCodeType(code),
              SecurityCodeType.traditional);
        }
      });

      test("新形式の証券コード例", () {
        final newFormatExamples = [
          "130A", // 最初の新形式コード
          "373A", // リップス
          "372A", // レント
          "383A", // MAXIS S&P500均等ウェイト上場投信
        ];

        for (String code in newFormatExamples) {
          expect(StockCodeValidator.isValid(code), true,
              reason: "New format code $code should be valid");
          expect(StockCodeValidator.getCodeType(code),
              SecurityCodeType.fourthLetter);
        }
      });
    });

    group("境界値テスト", () {
      test("最小値と最大値のテスト", () {
        // 従来形式の境界値
        expect(StockCodeValidator.isValid("1000"), true);
        expect(StockCodeValidator.isValid("9999"), true);

        // 新形式の境界値
        expect(StockCodeValidator.isValid("130A"), true); // 最初の新形式
        expect(StockCodeValidator.isValid("999Y"), true); // 4桁目英文字の最大
        expect(StockCodeValidator.isValid("1A00"), true); // 2桁目英文字の最小
        expect(StockCodeValidator.isValid("9Y99"), true); // 2桁目英文字の最大
      });

      test("無効な境界値", () {
        expect(StockCodeValidator.isValid("0999"), false); // 先頭0
        expect(StockCodeValidator.isValid("0123"), false); // 先頭0
      });
    });
  });
}
