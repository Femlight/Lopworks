import 'package:equatable/equatable.dart';

abstract class MailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMailsEvent extends MailEvent {
  final bool loadMore;
  
  FetchMailsEvent({this.loadMore = false});
  
  @override
  List<Object?> get props => [loadMore];
}

class SearchMailsEvent extends MailEvent {
  final String searchQuery;

  SearchMailsEvent(this.searchQuery);

  @override
  List<Object?> get props => [searchQuery];
}
