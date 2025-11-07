import 'package:countries/core/error/failure.dart';
import 'package:countries/domain/entities/country.dart';
import 'package:countries/domain/usecases/get_countries_usecase.dart';
import 'package:countries/domain/usecases/get_local_countries_usecase.dart';
import 'package:countries/features/initializer/view_model/initializer_view_model.dart';
import 'package:countries/core/utils/logging_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'initializer_view_model_test.mocks.dart';

// This annotation generates a mock class for GetCountriesUseCase
@GenerateMocks([GetCountriesUseCase, GetLocalCountriesUseCase, LoggingService])
void main() {
  // Initialize the Flutter test binding.
  TestWidgetsFlutterBinding.ensureInitialized();

  // We use late because they will be initialized in the setUp method
  late InitializerViewModel viewModel;
  late MockGetCountriesUseCase mockGetCountriesUseCase;
  late MockGetLocalCountriesUseCase mockGetLocalCountriesUseCase;
  late MockLoggingService mockLoggingService;

  // Create a fallback value for Either<Failure, List<Country>>
  final tEitherFallback = Left<Failure, List<Country>>(
    ApiFailure('fallback error'),
  );

  setUp(() {
    // Register the fallback value before each test
    provideDummy<Either<Failure, List<Country>>>(tEitherFallback);

    // Create a fresh instance of our mock and view model for each test
    mockGetCountriesUseCase = MockGetCountriesUseCase();
    mockGetLocalCountriesUseCase = MockGetLocalCountriesUseCase();
    mockLoggingService = MockLoggingService();

    viewModel = InitializerViewModel(
      getCountriesUseCase: mockGetCountriesUseCase,
      log: mockLoggingService,
      getLocalCountriesUseCase: mockGetLocalCountriesUseCase,
    );

    // Mock the Get.offAllNamed method to prevent errors in tests
    // We create a mock navigator
    Get.testMode = true;
  });

  // A dummy list of countries for successful test cases
  final tCountries = [
    Country(
      name: Name(common: 'Test Country', official: 'Official Test Country'),
      flags: Flags(png: 'test.png', svg: 'test.svg'),
      idd: Idd(),
      cca2: 'TC',
      population: 100,
      region: 'Test Region',
      timezones: ['UTC+0'],
    ),
  ];

  test('should set errorMessage when getting initial data fails', () async {
    // Arrange: Configure the mock to return a failure
    when(
      mockGetLocalCountriesUseCase(),
    ).thenAnswer((_) async => Left(CacheFailure('No local data')));
    when(
      mockGetCountriesUseCase(),
    ).thenAnswer((_) async => Left(ApiFailure('API Error')));

    // Act: Call the method we want to test
    await viewModel.fetchInitialData();
    // handle timing issue when testing reactive state management with GetX.
    await Future.delayed(Duration.zero);

    // Assert: Verify the outcomes
    expect(viewModel.errorMessage.value, 'API Error');
    verify(mockGetLocalCountriesUseCase()).called(1);
    verify(mockGetCountriesUseCase()).called(1);
    verifyNoMoreInteractions(mockGetCountriesUseCase);
    verifyNoMoreInteractions(mockGetLocalCountriesUseCase);
  });

  test(
    'should navigate to home page when getting initial data is successful',
    () async {
      // Arrange: Configure the mock to return success
      when(
        mockGetLocalCountriesUseCase(),
      ).thenAnswer((_) async => Left(CacheFailure('No local data')));
      when(
        mockGetCountriesUseCase(),
      ).thenAnswer((_) async => Right(tCountries));

      // Act
      await viewModel.fetchInitialData();

      // Assert
      expect(viewModel.errorMessage.value, '');
      // We can't easily test the Get.offAllNamed navigation in a simple unit test,
      // but we can verify the use case was called.
      verify(mockGetLocalCountriesUseCase()).called(1);
      verify(mockGetCountriesUseCase()).called(1);
    },
  );

  test(
    'should navigate to home page when getting initial data from local is successful',
    () async {
      // Arrange: Configure the mock to return success from local
      when(
        mockGetLocalCountriesUseCase(),
      ).thenAnswer((_) async => Right(tCountries));

      // Act
      await viewModel.fetchInitialData();

      // Assert
      expect(viewModel.errorMessage.value, '');
      verify(mockGetLocalCountriesUseCase()).called(1);
      // Remote use case should not be called
      verifyNever(mockGetCountriesUseCase());
    },
  );

  test(
    'should fetch from remote when local data is empty and navigate on success',
    () async {
      // Arrange
      when(
        mockGetLocalCountriesUseCase(),
      ).thenAnswer((_) async => const Right([]));
      when(
        mockGetCountriesUseCase(),
      ).thenAnswer((_) async => Right(tCountries));

      // Act
      await viewModel.fetchInitialData();

      // Assert
      verify(mockGetLocalCountriesUseCase()).called(1);
      verify(mockGetCountriesUseCase()).called(1);
    },
  );
}
