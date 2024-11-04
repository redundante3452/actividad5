import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../repositories/posts_repository.dart';

final postsRepositoryProvider = Provider((ref) => PostsRepository());

final postsProvider = FutureProvider<List<Post>>((ref) async {
  final repository = ref.read(postsRepositoryProvider);
  return repository.fetchPosts();
});
