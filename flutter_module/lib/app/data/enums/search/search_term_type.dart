/// whether the searchTerm to show to the user when he enters a [searchQuery]
/// is a [Suggestion] - meaning that the user has never entered that before -
/// or a [History] - the user has searched for that before.
enum SearchTermType {
  suggestion,
  history,
}
