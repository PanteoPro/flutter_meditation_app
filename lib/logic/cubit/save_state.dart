part of 'save_cubit.dart';

abstract class SaveState extends Equatable {
  const SaveState();

  @override
  List<Object> get props => [];
}

class SaveInitial extends SaveState {
  const SaveInitial();
}
