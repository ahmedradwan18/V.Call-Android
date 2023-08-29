import 'package:equatable/equatable.dart';

import '../../enums/search/search_term_type.dart';

class SearchTerm extends Equatable {
  //*================================ Properties ================================
  final String term;
  final SearchTermType termType;
  //*================================ Constructor ===============================
  const SearchTerm({
    required this.term,
    required this.termType,
  });

  @override
  List<Object?> get props => [term, termType];
  //*============================================================================
}
