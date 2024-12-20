part of 'comment_list_bloc.dart';

class CommentListState extends Equatable {
  const CommentListState({
    required this.referenceId,
    required this.referenceType,
    required this.comments,
    this.isFetching = false,
    this.hasNextPage = true,
    required this.expandedId,
  });

  final String referenceId;
  final AmityCommentReferenceType referenceType;
  final List<AmityComment> comments;
  final bool isFetching;
  final bool hasNextPage;
  final List<String> expandedId;

  @override
  List<Object?> get props => [
        referenceId,
        referenceType,
        comments,
        isFetching,
        hasNextPage,
        expandedId,
      ];

  CommentListState copyWith({
    String? referenceId,
    AmityCommentReferenceType? referenceType,
    List<AmityComment>? comments,
    bool? isFetching,
    bool? hasNextPage,
    List<String>? expandedId,
  }) {
    return CommentListState(
      referenceId: referenceId ?? this.referenceId,
      referenceType: referenceType ?? this.referenceType,
      comments: comments ?? this.comments,
      isFetching: isFetching ?? this.isFetching,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      expandedId: expandedId ?? this.expandedId,
    );
  }
}

class CommentListStateInitial extends CommentListState {
  const CommentListStateInitial({
    required super.referenceId,
    required super.referenceType,
  }) : super(
          comments: const [],
          isFetching: false,
          hasNextPage: true,
          expandedId: const [],
        );
}

class CommentListStateChanged extends CommentListState {
  const CommentListStateChanged({
    required super.referenceId,
    required super.referenceType,
    required super.comments,
    required super.isFetching,
    required super.hasNextPage,
    required super.expandedId,
  });
}
