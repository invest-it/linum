
extension IntListExtensions on List<int> {
  List<int> insertSorted(int value) {
    if (value > last) {
      add(value);
      return this;
    }
    var index = 0;
    for (final entry in this) {
      if (entry < value) {
        index ++;
        continue;
      }
      break;
    }
    final split1 = sublist(0, index);
    final split2 = sublist(index, length-1);
    split1.add(value);
    split1.addAll(split2);
    return split1;
  }

  int lastSmallerIndex(int value) {
    if (value > last) {
      return length-1;
    }
    var index = 0;
    for (final entry in this) {
      if (entry < value) {
        index ++;
        continue;
      }
      return index-1;
    }
    return -2;
  }
}
