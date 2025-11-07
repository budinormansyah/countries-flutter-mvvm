import 'package:countries/core/error/failure.dart';
import 'package:countries/domain/entities/country.dart';
import 'package:countries/domain/usecases/get_countries_usecase.dart';
import 'package:countries/domain/usecases/get_local_countries_usecase.dart';
import 'package:countries/features/home/view_model/home_view_model.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_view_model_test.mocks.dart';

@GenerateMocks([GetLocalCountriesUseCase, GetCountriesUseCase])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  // Create a fallback value for Either<Failure, List<Country>>
  // This is required by Mockito for types it cannot generate a dummy value for.
  final tEitherFallback = Left<Failure, List<Country>>(
    ApiFailure('fallback error'),
  );
  // Register the fallback value before tests run.
  provideDummy<Either<Failure, List<Country>>>(tEitherFallback);

  late HomeViewModel viewModel;
  late MockGetLocalCountriesUseCase mockGetLocalCountriesUseCase;
  late MockGetCountriesUseCase mockGetCountriesUseCase;

  final tCountries = [
    Country(
      name: Name(common: 'Brazil', official: 'Federative Republic of Brazil'),

      capital: ['Brasília'],
      cca2: 'BR',
      flags: Flags(png: 'br.png', svg: 'br.svg'),
      idd: Idd(),
      population: 212559409,
      region: 'Americas',
      timezones: ['UTC-05:00', 'UTC-04:00', 'UTC-03:00', 'UTC-02:00'],
    ),
    Country(
      name: Name(common: 'Canada', official: 'Canada'),
      capital: ['Ottawa'],
      cca2: 'CA',
      flags: Flags(png: 'ca.png', svg: 'ca.svg'),
      idd: Idd(),
      population: 38005238,
      region: 'Americas',
      timezones: [
        'UTC-08:00',
        'UTC-07:00',
        'UTC-06:00',
        'UTC-05:00',
        'UTC-04:00',
        'UTC-03:30',
      ],
    ),
  ];

  setUp(() {
    mockGetLocalCountriesUseCase = MockGetLocalCountriesUseCase();
    mockGetCountriesUseCase = MockGetCountriesUseCase();

    // Stub the use case to return a successful result with our test countries
    when(
      mockGetLocalCountriesUseCase(),
    ).thenAnswer((_) async => Right(tCountries));

    // Add a default stub for the remote use case to prevent MissingStubError on init
    when(mockGetCountriesUseCase()).thenAnswer((_) async => Right(tCountries));

    Get.put(
      HomeViewModel(
        getLocalCountriesUseCase: mockGetLocalCountriesUseCase, //
        getCountriesUseCase: mockGetCountriesUseCase,
      ),
    );
    viewModel = Get.find<HomeViewModel>();
  });

  tearDown(() {
    Get.reset();
  });

  group('loadCountries', () {
    test(
      'should get countries from the use case and update the state on successful load',
      () async {
        // Arrange - Reset mock from the onInit() call in setUp
        clearInteractions(mockGetLocalCountriesUseCase);
        when(
          mockGetLocalCountriesUseCase(),
        ).thenAnswer((_) async => Right(tCountries));

        // Act
        await viewModel.loadCountries();

        // Assert
        expect(viewModel.isLoading.value, false);
        expect(viewModel.errorMessage.value, null);
        expect(viewModel.countries, tCountries);
        expect(viewModel.filteredCountries, tCountries);
        verify(mockGetLocalCountriesUseCase()).called(1);
      },
    );

    test('should update errorMessage and stop loading on failure', () async {
      // Arrange
      clearInteractions(mockGetLocalCountriesUseCase);
      reset(mockGetLocalCountriesUseCase); // Clear previous 'when' from setUp
      when(
        mockGetLocalCountriesUseCase(),
      ).thenAnswer((_) async => Left(ApiFailure('Network Error')));

      // Act
      await viewModel.loadCountries();

      // Assert
      expect(viewModel.isLoading.value, false);
      expect(viewModel.errorMessage.value, 'Network Error');
      expect(viewModel.countries.isEmpty, isTrue);
      verify(mockGetLocalCountriesUseCase()).called(1);
    });
  });

  group('search and filter', () {
    // No longer need a separate setUp here.
    // The main setUp already initializes the viewModel, which loads data in onInit.
    // We will handle timing inside each test.
    // setUp(() async {
    //   // Pre-load data for search tests
    //   await viewModel.loadCountries();
    // });

    test('should filter countries by name when searchCountries is called', () {
      FakeAsync().run((async) {
        // Arrange
        const query = 'Brazil';

        // Act
        // Elapse the initial debounce from onInit
        async.elapse(const Duration(milliseconds: 500));

        viewModel.searchCountries(query);
        async.elapse(const Duration(milliseconds: 500)); // Wait for debounce

        // Assert
        expect(viewModel.filteredCountries.length, 1);
        expect(viewModel.filteredCountries.first.name.common, query);
        expect(viewModel.searchQuery.value, query);
      });
    });

    test('should return an empty list if search query matches no country', () {
      FakeAsync().run((async) {
        // Arrange
        const query = 'NonExistentCountry';

        // Act
        // Elapse the initial debounce from onInit
        async.elapse(const Duration(milliseconds: 500));

        viewModel.searchCountries(query);
        async.elapse(const Duration(milliseconds: 500)); // Wait for debounce

        // Assert
        expect(viewModel.filteredCountries.isEmpty, isTrue);
        expect(viewModel.searchQuery.value, query);
      });
    });

    test('should reset to the full list when clearSearch is called', () {
      FakeAsync().run((async) {
        // Arrange: first, perform a search to filter the list
        // Elapse the initial debounce from onInit
        async.elapse(const Duration(milliseconds: 500));

        viewModel.searchCountries('Canada');
        async.elapse(const Duration(milliseconds: 500)); // Wait for debounce
        expect(
          viewModel.filteredCountries.length,
          isNot(tCountries.length),
          reason: 'Pre-condition: list should be filtered',
        );

        // Act: clear the search
        viewModel.clearSearch();
        async.elapse(
          const Duration(milliseconds: 500),
        ); // Wait for debounce on empty string

        // Assert
        expect(viewModel.filteredCountries.length, tCountries.length);
        expect(viewModel.filteredCountries, tCountries);
        expect(viewModel.searchQuery.value, '');
        expect(viewModel.searchController.text, '');
      });
    });

    test('should filter countries by capital city (case-insensitive)', () {
      FakeAsync().run((async) {
        // Arrange
        const query = 'ottawa';

        // Act
        // Elapse the initial debounce from onInit
        async.elapse(const Duration(milliseconds: 500));

        viewModel.searchCountries(query);
        async.elapse(const Duration(milliseconds: 500)); // Wait for debounce

        // Assert
        expect(viewModel.filteredCountries.length, 1);
        expect(viewModel.filteredCountries.first.name.common, 'Canada');
      });
    });
  });
}
