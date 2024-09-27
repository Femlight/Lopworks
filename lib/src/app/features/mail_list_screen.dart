import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mail_list/bloc/mail_bloc.dart';
import 'package:mail_list/bloc/mail_event.dart';
import 'package:mail_list/bloc/mail_state.dart';

class MailListScreen extends StatefulWidget {
  const MailListScreen({super.key});

  @override
  _MailListScreenState createState() => _MailListScreenState();
}

class _MailListScreenState extends State<MailListScreen> {
  final searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Track checked status of emails
  final Map<int, bool> checkedEmails = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 300) {
      BlocProvider.of<MailBloc>(context).add(FetchMailsEvent(loadMore: true));
    }
  }

  // Helper function to get the first sentence of the description
  String getFirstSentence(String description) {
    if (description.isEmpty) return description;
    var sentences = description.split('.');
    return sentences.isNotEmpty ? sentences.first + '.' : description;
  }

  bool isSearching = false; // Track if search mode is active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        elevation: 1,
        title: isSearching
            ? TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name or email',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  // Add search functionality
                  BlocProvider.of<MailBloc>(context)
                      .add(SearchMailsEvent(value));
                },
              )
            : const Text('Mail',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        actions: [
          // Menu Icon
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Add menu functionality
            },
          ),
          // Search Icon
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear();
                  // Clear search when closing
                  BlocProvider.of<MailBloc>(context).add(SearchMailsEvent(''));
                }
                isSearching = !isSearching; // Toggle search mode
              });
            },
          ),
          // SizedBox for spacing
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // BlocBuilder listens to state changes and updates the unread count dynamically
          BlocBuilder<MailBloc, MailState>(
            builder: (context, state) {
              Widget messageWidget;

              if (state is MailLoadedState) {
                messageWidget = Row(
                  children: [
                    const Text(
                      'Inbox ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${state.unreadCount} Unread Mails',
                      style: const TextStyle(
                          color: Color(0xFF2463EB), fontSize: 16),
                    ),
                  ],
                );
              } else if (state is MailLoadingState) {
                messageWidget = const Text(
                  'Loading unread messages...',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                );
              } else if (state is MailErrorState) {
                messageWidget = const Text(
                  'Error loading unread messages',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                );
              } else {
                return Container(); // In case of other states, return an empty container
              }

              return Container(
                alignment:
                    Alignment.centerLeft, // Align the content to the left
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: messageWidget,
              );
            },
          ),
          Expanded(
            child: BlocBuilder<MailBloc, MailState>(
              builder: (context, state) {
                if (state is MailLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MailLoadedState) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<MailBloc>(context).add(FetchMailsEvent());
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: state.emails.length + (state.hasMore ? 1 : 0),
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, color: Colors.grey),
                      itemBuilder: (context, index) {
                        if (index == state.emails.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final email = state.emails[index];
                        bool isChecked = checkedEmails[email['id']] ?? false;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 20.0), // Padding added here
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        email['imageUrl'] != null &&
                                                email['imageUrl'] != ""
                                            ? NetworkImage(email['imageUrl'])
                                            : null,
                                    child: email['imageUrl'] == null ||
                                            email['imageUrl'].isEmpty
                                        ? Text(
                                            '${email['firstName'][0]}${email['lastName'][0]}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(height: 10),
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        checkedEmails[email['id']] =
                                            value ?? false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                  width: 16), // Space between avatar and text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${email['firstName']} ${email['lastName']}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      email['subject'],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      getFirstSentence(email['description']),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '1:20 PM', // Static for now, make dynamic if time data exists
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is MailErrorState) {
                  return Center(child: Text(state.error));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add compose email functionality
        },
        icon: const Icon(Icons.add,
            color: Colors.white), // Set icon color to white
        label: const Text(
          'Compose',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor:
            const Color(0xFF2463EB), // Set the background color to blue
        foregroundColor:
            Colors.white, // This ensures the icon and text are white
      ),
    );
  }
}
