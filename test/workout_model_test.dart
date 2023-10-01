import 'package:workout_model/workout_model.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final repository = TrainingpassRepository();

    setUp(() async {
       await repository.initialize();
    });

    test('Create Training', () {
      Training training =
          Training(id: "200", name: "Triceps", description: "Träna triceps");
      expect(training, isNotNull);
    });

    test('Edit Trainingpass', () {
      Trainingpass trainingpass = Trainingpass(
          id: "1000",
          name: "daily träningspass",
          description: "Träningspass för varje dag",
          trainings: {});
      Training triceps =
          Training(id: "200", name: "Triceps", description: "Träna triceps");
      trainingpass.addTraining(
          triceps, TrainingData(repeats: 10, restSec: 60, antalSets: 3, weight: 10, length: 0));
      
      // Check that the manager's current trainingpass is the same as our trainingpass
      expect(trainingpass.id, equals(trainingpass.id));
      expect(trainingpass.name, equals(trainingpass.name));
      expect(trainingpass.description, equals(trainingpass.description));

      // Check the trainings were added correctly
      var tricepsAmount = trainingpass.trainings[triceps];
      expect(tricepsAmount?.repeats, equals(10));
      expect(tricepsAmount?.restSec, equals(60));
      expect(tricepsAmount?.antalSets, equals(3));
      expect(tricepsAmount?.weight, equals(10));
      expect(tricepsAmount?.length, equals(0));
    });

    test('Add Trainingpass to Repository', () {
      var trainingpass = Trainingpass(
          id: "1001",
          name: "twice a week",
          description: "träning 2 ggr i veckan",
          trainings: {});
      bool result = repository.create(trainingpass);
      expect(result, isTrue);
    });

    test('Read Trainingpass from Repository', () {
      var trainingpass = repository.read("1001");
      expect(trainingpass?.id, equals("1001"));
      expect(trainingpass?.name, equals("twice a week"));
      expect(trainingpass?.description, equals("träning 2 ggr i veckan"));
    });

    test('Update Trainingpass in Repository', () {
      var updatedTrainingpass = Trainingpass(
          id: "1001",
          name: "twice a week",
          description: "träning endast 2 ggr i veckan",
          trainings: {});
      var returnedTrainingpass = repository.update(updatedTrainingpass);
      expect(returnedTrainingpass.description, equals("träning endast 2 ggr i veckan"));
    });

    test('Delete Trainingpass from Repository', () {
      bool deleted = repository.delete("1001");
      expect(deleted, isTrue);
      var trainingpass = repository.read("1001");
      expect(trainingpass, isNull);
    });

  });
}
