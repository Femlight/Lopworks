import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'mail_event.dart';
import 'mail_state.dart';

class MailBloc extends Bloc<MailEvent, MailState> {
  List<dynamic> emails = [];
  int currentPage = 1;
  final int totalPages = 3;
  String searchQuery = "";

  MailBloc() : super(MailLoadingState()) {
    on<FetchMailsEvent>(_onFetchMails);
    on<SearchMailsEvent>(_onSearchMails);
  }

  Future<void> _onFetchMails(FetchMailsEvent event, Emitter<MailState> emit) async {
    if (event.loadMore && currentPage > totalPages) return;

    final url = 'https://dummyjson.com/c/05f6-6d59-4b72-880c?page=$currentPage';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final newEmails = json.decode(response.body);
        if (event.loadMore) {
          emails.addAll(newEmails);
          currentPage++;
        } else {
          emails = newEmails;
        }
        final unreadCount = emails.where((mail) => !mail['read']).length;
        emit(MailLoadedState(emails: emails, hasMore: currentPage <= totalPages, unreadCount: unreadCount));
      } else {
        emit(MailErrorState('Failed to load emails'));
      }
    } catch (e) {
      emit(MailErrorState('Error fetching emails'));
    }
  }

  Future<void> _onSearchMails(SearchMailsEvent event, Emitter<MailState> emit) async {
    searchQuery = event.searchQuery.toLowerCase();
    final filteredEmails = emails.where((email) {
      return email['firstName'].toLowerCase().contains(searchQuery) ||
          email['lastName'].toLowerCase().contains(searchQuery) ||
          email['email'].toLowerCase().contains(searchQuery);
    }).toList();
    final unreadCount = filteredEmails.where((mail) => !mail['read']).length;
    emit(MailLoadedState(emails: filteredEmails, hasMore: currentPage <= totalPages, unreadCount: unreadCount));
  }
}
