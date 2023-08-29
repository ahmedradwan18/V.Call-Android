// decides how the user searches
import 'package:flutter/material.dart';

enum SearchType {
  name,
  email,
}

extension SearchTypeIcon on SearchType {
  IconData get icon {
    switch (this) {
      case SearchType.name:
        return Icons.text_fields;
      case SearchType.email:
        return Icons.email;
      default:
        return Icons.text_fields;
    }
  }
}
