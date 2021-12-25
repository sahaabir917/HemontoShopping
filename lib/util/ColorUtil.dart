import 'dart:ui';

class ColorUtil {
  int hexColor(String color) {
    String newColor = '0xff' + color;
    newColor = newColor.replaceAll("#", '');
    int finalColor = int.parse(newColor);
    return finalColor;
  }

  dynamic getColorByPosition(int index) {
    var returnedColor = index % 4;
    int finalColor;
    if (returnedColor == 0) {
      var finalColor = Color(hexColor("#689F38"));
      return finalColor;
    } else if (returnedColor == 1) {
      var finalColor = Color(hexColor("#6A1B9A"));
      return finalColor;
    }
    else if(returnedColor == 2){
      var finalColor = Color(hexColor("#00695C"));
      return finalColor;
    }
    else if(returnedColor == 3){
      var finalColor = Color(hexColor("#00ACC1"));
      return finalColor;
    }
  }



  dynamic getColorofDeals(int index) {
    var returnedColor = index % 3;
    int finalColor;
    if (returnedColor == 0) {
      var finalColor = Color(hexColor("#d24141"));
      return finalColor;
    } else if (returnedColor == 1) {
      var finalColor = Color(hexColor("#00a99d"));
      return finalColor;
    }
    else if(returnedColor == 2){
      var finalColor = Color(hexColor("#44bac4"));
      return finalColor;
    }
  }

}
