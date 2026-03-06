void main() {
  List<int> oldList = [9, 7, 6, 5, 9, 3, 4, 4, 2];
  List<int> uniqueList = [];
  int uniqueIndex = 0;

  for (int i = 0; i < oldList.length; i++) {
    bool isDuplicate = false;
    for (int j = 0; j < uniqueIndex; j++) {
      if (oldList[i] == uniqueList[j]) {
        isDuplicate = true;
        break;
      }
    }
    if (isDuplicate == false) {
      uniqueList[uniqueIndex] = oldList[i];
      uniqueIndex++;
    }
  }

  print(uniqueList);

  for (int i = 0; i < uniqueList.length; i++) {
    for (int j = i + 1; j < uniqueList.length; j++) {
      if (uniqueList[i] > uniqueList[j]) {
        int temp = uniqueList[i];
        uniqueList[i] = uniqueList[j];
        uniqueList[j] = temp;
      }
    }
  }

  for (int i = 0; i < uniqueList.length; i++) {
    print(uniqueList[i]);
  }
}
