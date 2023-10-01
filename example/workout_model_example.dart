import 'package:workout_model/workout_model.dart';

void main() async {
  // Initialize a TrainingpassRepository
  TrainingpassRepository repository = TrainingpassRepository();

  await repository.initialize();

  // Create a few trainings
  Training walkingTraining =
      Training(id: "101", name: "walking", description: "vanliga gång");
  Training sprintTraining =
      Training(id: "102", name: "sprint", description: "sprint träning");
  Training pullWeightTraining =
      Training(id: "103", name: "pullweight", description: "dra vikt");

  // Print out the trainings's name
  print(walkingTraining.name);

  // Create a Trainingpass
  Trainingpass dailyTrainingpass = Trainingpass(
      id: "1000",
      name: "daily träningspass",
      description: "Träningspass för varje dag",
      trainings: {});

  // Print out the trainingpass's name
  print(dailyTrainingpass.name);

  // Use the TrainingpassEditingManager to start editing the trainingpass

  // Add trainings and their amounts to the trainingpass
  dailyTrainingpass.addTraining(walkingTraining,
      TrainingData(repeats: 1, restSec: 0, antalSets: 3, weight: 0, length: 1000));
  dailyTrainingpass.addTraining(sprintTraining, 
      TrainingData(repeats: 3, restSec: 120, antalSets: 0, weight: 0, length: 50));
  dailyTrainingpass.addTraining(pullWeightTraining, 
      TrainingData(repeats: 10, restSec: 120, antalSets: 3, weight: 10, length: 0));

  
  // Finish editing

  // Use the TrainingpassRepository to store the trainingpass
  bool isCreated = repository.create(dailyTrainingpass);
  print('Trainingpass added to repository: $isCreated');

  // Read it back
  Trainingpass? readTrainingpass = repository.read("1000");
  print('Read training description: ${readTrainingpass?.description}');

  // Update it
  Trainingpass updatedTrainingpass = Trainingpass(
      id: "1000",
      name: "Updated daily trainingpass",
      description: "Träningspass för varje dag",
      trainings: {});
  Trainingpass updatedVersion = repository.update(updatedTrainingpass);
  print('Updated training description: ${updatedVersion.description}');

  // List all the trainingpasss in the repository
  List<Trainingpass> allTrainingpasss = repository.list();
  print('Number of trainingpasses in repository: ${allTrainingpasss.length}');

  bool isDeleted = repository.delete(dailyTrainingpass.id);
  print('Trainingpass deleted from repository: $isDeleted');

}