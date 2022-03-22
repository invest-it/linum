import 'package:flutter_test/flutter_test.dart';
import 'package:linum/frontend_functions/country_flag_generator.dart';

void main() {
  group("country_flag_generator", () {
    test("gives correct german flag", () {
      // Arrange (Initialization)
      String exprectedFlag = "🇩🇪";

      // Act (Execution)
      String flag = countryFlag("de");

      // Assert (Observation)
      expect(flag, exprectedFlag);
    });

    test("gives correct great britain flag", () {
      // Arrange (Initialization)
      String exprectedFlag = "🇬🇧";

      // Act (Execution)
      String flag = countryFlag("gb");

      // Assert (Observation)
      expect(flag, exprectedFlag);
    });

    test("gives correct flag of the Netherlands", () {
      // Arrange (Initialization)
      String exprectedFlag = "🇳🇱";

      // Act (Execution)
      String flag = countryFlag("nl");

      // Assert (Observation)
      expect(flag, exprectedFlag);
    });

    test("gives correct spain flag", () {
      // Arrange (Initialization)
      String exprectedFlag = "🇪🇸";

      // Act (Execution)
      String flag = countryFlag("es");

      // Assert (Observation)
      expect(flag, exprectedFlag);
    });

    test("gives correct french flag", () {
      // Arrange (Initialization)
      String exprectedFlag = "🇫🇷";

      // Act (Execution)
      String flag = countryFlag("fr");

      // Assert (Observation)
      expect(flag, exprectedFlag);
    });
  });
}
