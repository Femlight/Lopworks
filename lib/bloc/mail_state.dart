import 'package:equatable/equatable.dart';

class MailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MailLoadingState extends MailState {}

class MailLoadedState extends MailState {
  final List<dynamic> emails;
  final bool hasMore;
  final int unreadCount;

  MailLoadedState({required this.emails, required this.hasMore, required this.unreadCount});
  
  @override
  List<Object?> get props => [emails, hasMore, unreadCount];
}

class MailErrorState extends MailState {
  final String error;

  MailErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
