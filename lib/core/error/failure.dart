import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class GpsPermissionFailure extends Failure {
  const GpsPermissionFailure()
    : super(
        'Location permission required. Please grant permission in settings.',
      );
}

final class GpsAccuracyFailure extends Failure {
  const GpsAccuracyFailure()
    : super('GPS signal is weak. Please move to open area and wait.');
}

final class GpsLostFailure extends Failure {
  const GpsLostFailure()
    : super('GPS signal lost. Measurement paused. Waiting for signal...');
}

final class StorageFailure extends Failure {
  const StorageFailure([
    super.message = 'Could not save field. Please try again.',
  ]);
}

final class MinimumPointsFailure extends Failure {
  const MinimumPointsFailure()
    : super('Add at least 3 corners to measure a field.');
}

final class NoFieldsFailure extends Failure {
  const NoFieldsFailure()
    : super('No saved fields found. Measure your first field!');
}

final class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
