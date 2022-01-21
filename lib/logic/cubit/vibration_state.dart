part of 'vibration_cubit.dart';

abstract class VibrationState extends Equatable {
  const VibrationState();

  @override
  List<Object> get props => [];
}

class VibrationChecking extends VibrationState {}

class VibrationHave extends VibrationState {}

class VibrationError extends VibrationState {}
