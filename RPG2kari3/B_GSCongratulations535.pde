// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Richard Bourneさん
// 【作品名】Calendar
// https://openprocessing.org/sketch/1828029
//

import java.util.Date;

class GameSceneCongratulations535 extends GameSceneCongratulationsBase {
  String[] monthNames = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
  int[]    monthDays  = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31        };

  String[] weekDays = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};

  ArrayList<MonthDay> holidays;

  int currentMonth;
  int currentYear;

  float plannerWidth = 0;

  PGraphics pg;
  int orgW = 888;
  int orgH = 666;

  float margin = 50;
  float topLabelMargin = 100;
  float calendarWidth = orgW - plannerWidth - (margin * 2);
  float calendarHeight = orgH - (margin * 2) - topLabelMargin;
  float spacing = 5;

  @Override void setup() {
    pg = createGraphics(orgW, orgH);
    pg.beginDraw();

    //textFont(createFont("ArialMT-48", 12));
    pg.textAlign(CENTER, CENTER);

    holidays = new ArrayList<MonthDay>();
    holidays.add(new Holiday("00:00\nStudio", 4, 28));
    holidays.add(new Holiday("New Year's Day", 1, 1));
    holidays.add(new Holiday("Independence\nDay", 7, 4));
    holidays.add(new Holiday("Halloween", 10, 31));
    holidays.add(new Holiday("Veterans' Day", 11, 11));
    holidays.add(new Holiday("Christmas", 12, 25));
    holidays.add(new MonthDay() {
      public String getName() {
        return "Martin Luther\nKing Jr. Day";
      }
      public int getMonth() {
        return 1;
      }
      public int getDay() {
        return getDayInMonth(currentYear, currentMonth, 2, 3);
      }
    }
    );
    holidays.add(new MonthDay() {
      public String getName() {
        return "Presidents' Day";
      }
      public int getMonth() {
        return 2;
      }
      public int getDay() {
        return getDayInMonth(currentYear, currentMonth, 2, 3);
      }
    }
    );
    holidays.add(new MonthDay() {
      public String getName() {
        return "Mothers' Day";
      }
      public int getMonth() {
        return 5;
      }
      public int getDay() {
        return getDayInMonth(currentYear, currentMonth, 1, 2);
      }
    }
    );
    holidays.add(new MonthDay() {
      public String getName() {
        return "Fathers' Day";
      }
      public int getMonth() {
        return 6;
      }
      public int getDay() {
        return getDayInMonth(currentYear, currentMonth, 1, 3);
      }
    }
    );
    holidays.add(new MonthDay() {
      public String getName() {
        return "Memorial Day";
      }
      public int getMonth() {
        return 5;
      }
      public int getDay() {
        return lastDayInMonth(currentYear, currentMonth, 2);
      }
    }
    );
    holidays.add(new MonthDay() {
      public String getName() {
        return "Labor Day";
      }
      public int getMonth() {
        return 9;
      }
      public int getDay() {
        return getDayInMonth(currentYear, currentMonth, 2, 1);
      }
    }
    );
    holidays.add(new MonthDay() {
      public String getName() {
        return "Columbus Day";
      }
      public int getMonth() {
        return 10;
      }
      public int getDay() {
        return getDayInMonth(currentYear, currentMonth, 2, 2);
      }
    }
    );
    holidays.add(new MonthDay() {
      public String getName() {
        return "Thanksgiving";
      }
      public int getMonth() {
        return 11;
      }
      public int getDay() {
        return getDayInMonth(currentYear, currentMonth, 5, 4);
      }
    }
    );

    currentMonth = month() - 1;
    currentYear = year();
    pg.endDraw();
  }
  @Override void draw() {
    push();
    pg.beginDraw();
    //Date Metrics
    String monthName = monthNames[currentMonth];
    int daysInMonth = int(monthDays[currentMonth]);
    if (currentMonth == 1 && isLeapYear(currentYear)) daysInMonth ++;
    int dayOfMonth = -1;

    if (currentMonth == month() - 1 && currentYear == year()) {
      dayOfMonth = day();
    }

    var date = new Date();
    date.setYear(currentYear);
    date.setMonth(currentMonth);
    date.setDate(1);

    int startingDayOfMonth = date.getDay(); //int(7 - (dayOfMonth % 7)); //NOT WORKING!

    //Calendar Metrics
    int numRows = ceil((startingDayOfMonth + daysInMonth) / 7.0f);
    margin = 50;
    topLabelMargin = 100;
    calendarWidth = orgW - plannerWidth - (margin * 2);
    calendarHeight = orgH - (margin * 2) - topLabelMargin;
    spacing = 5;
    float boxWidth = (calendarWidth - (6 * spacing)) / 7.0f;
    float boxHeight = (calendarHeight - ((numRows - 1) * spacing)) / (float)numRows;

    pg.background(102, 102, 140);

    if (mouseInArrowRange()) {
      pg.noStroke();

      if (mouseOverArrow(-1) || mouseOverArrow(-2)) pg.fill(255);
      else pg.fill(204);
      pg.triangle((orgW - plannerWidth) / 2.0f - (orgW - plannerWidth) / 10.0f * 3.5, margin + topLabelMargin / 10.0f * 3, (orgW - plannerWidth) / 2.0f - (orgW - plannerWidth) / 10.0f * 3, margin + topLabelMargin / 10.0f * 2, (orgW - plannerWidth) / 2.0f - (orgW - plannerWidth) / 10.0f * 3, margin + topLabelMargin / 10.0f * 4);

      if (mouseOverArrow(1) || mouseOverArrow(2)) pg.fill(255);
      else pg.fill(204);
      pg.triangle((orgW - plannerWidth) / 2.0f + (orgW - plannerWidth) / 10.0f * 3.5, margin + topLabelMargin / 10.0f * 3, (orgW - plannerWidth) / 2.0f + (orgW - plannerWidth) / 10.0f * 3, margin + topLabelMargin / 10.0f * 2, (orgW - plannerWidth) / 2.0f + (orgW - plannerWidth) / 10.0f * 3, margin + topLabelMargin / 10.0f * 4);

      if (mouseOverArrow(-2)) pg.fill(255);
      else pg.fill(204);
      pg.triangle((orgW - plannerWidth) / 2.0f - (orgW - plannerWidth) / 10.0f * 4.1, margin + topLabelMargin / 10.0f * 3, (orgW - plannerWidth) / 2.0f - (orgW - plannerWidth) / 10.0f * 3.6, margin + topLabelMargin / 10.0f * 2, (orgW - plannerWidth) / 2.0f - (orgW - plannerWidth) / 10.0f * 3.6, margin + topLabelMargin / 10.0f * 4);

      if (mouseOverArrow(2)) pg.fill(255);
      else pg.fill(204);
      pg.triangle((orgW - plannerWidth) / 2.0f + (orgW - plannerWidth) / 10.0f * 4.1, margin + topLabelMargin / 10.0f * 3, (orgW - plannerWidth) / 2.0f + (orgW - plannerWidth) / 10.0f * 3.6, margin + topLabelMargin / 10.0f * 2, (orgW - plannerWidth) / 2.0f + (orgW - plannerWidth) / 10.0f * 3.6, margin + topLabelMargin / 10.0f * 4);
    }

    pg.fill(255);
    pg.stroke(204);
    pg.textSize(42);

    pg.text(monthName + " " + currentYear, (orgW - plannerWidth) / 2, margin + topLabelMargin / 10 * 3);

    pg.fill(204);
    pg.textSize(16);

    for (int i = 0; i < weekDays.length; i ++)
      pg.text(weekDays[i], margin + (spacing * i) + (boxWidth * i) + boxWidth / 2.0f, margin + topLabelMargin / 10.0f * 7);

    pg.line(margin, margin + topLabelMargin / 10.0f * 8.5, orgW - plannerWidth - margin, margin + topLabelMargin / 10.0f * 8.5);

    pg.stroke(0);

    float xoff = startingDayOfMonth;
    float yoff = 0;
    for (int i = 0; i < daysInMonth; i ++) {
      float x = margin + (spacing * xoff) + (boxWidth * xoff);
      float y = margin + topLabelMargin + (spacing * yoff) + (boxHeight * yoff);

      pg.noStroke();
      pg.fill(51);

      pg.rect(x + 3, y + 3, boxWidth, boxHeight);

      pg.stroke(0);
      if ((i + 1) == dayOfMonth) pg.fill(255);
      else pg.fill(204);

      pg.rect(x, y, boxWidth, boxHeight);

      pg.fill(0);
      pg.textSize(24);

      pg.text(i + 1, x + boxWidth / 2.0f, y + boxHeight / 2.0f);

      pg.textSize(9);

      float yH = 0;
      for (MonthDay holiday : holidays) {
        if (currentMonth + 1 == holiday.getMonth() && i + 1 == holiday.getDay()) {
          pg.text(holiday.getName(), x + boxWidth / 2.0f, y + boxHeight / 20.0f * 17 - (pg.textAscent() + pg.textAscent()) * yH);
          yH ++;
        }
      }

      xoff = (xoff + 1) % 7;
      if (xoff == 0) yoff ++;
    }

    if (!isToday()) {
      if (overTodayButton(pg)) pg.fill(255);
      else pg.fill(204);
      pg.textSize(12);

      pg.text("Today", (orgW - plannerWidth) / 2.0f, orgH - margin / 2.0f);

      if (mousePressed && overTodayButton(pg)) goToToday();
    }

    pg.noStroke();

    if (plannerWidth > 50) {
      pg.fill(51);

      pg.rect(orgW - plannerWidth + 3, margin + topLabelMargin + 3, plannerWidth - margin, orgH - margin * 2 - topLabelMargin);

      pg.stroke(0);
      pg.fill(204);

      pg.rect(orgW - plannerWidth, margin + topLabelMargin, plannerWidth - margin, orgH - margin * 2 - topLabelMargin);
    }
    pg.endDraw();
    image(pg, 0, 0, width, height);
    pop();

    logoRightLower(#ff0000);
  }

  boolean mouseOverArrow(int arrow) {
    int mX = (int)map(mouseX, 0, width, 0, orgW);
    switch(arrow) {
    case -2:
      return (mouseInArrowRange() && mX > ((orgW - plannerWidth) / 2.0f - (orgW - plannerWidth) / 10.0f * 4.1) && (mX < (orgW - plannerWidth) / 2.0f - (orgW - plannerWidth) / 10.0f * 3.6));
    case -1:
      return (mouseInArrowRange() && mX > ((orgW - plannerWidth) / 2.0f - (orgW - plannerWidth) / 10.0f * 3.5) && (mX < (orgW - plannerWidth) / 2.0f - (orgW - plannerWidth) / 10.0f * 3));
    case 1:
      return (mouseInArrowRange() && mX < ((orgW - plannerWidth) / 2.0f + (orgW - plannerWidth) / 10.0f * 3.5) && (mX > (orgW - plannerWidth) / 2.0f + (orgW - plannerWidth) / 10.0f * 3));
    case 2:
      return (mouseInArrowRange() && mX < ((orgW - plannerWidth) / 2.0f + (orgW - plannerWidth) / 10.0f * 4.1) && (mX > (orgW - plannerWidth) / 2.0f + (orgW - plannerWidth) / 10.0f * 3.6));
    }

    return false;
  }

  boolean mouseInArrowRange() {
    int mY = (int)map(mouseY, 0, height, 0, orgH);
    return (mY > (margin + topLabelMargin / 10.0f * 2) && mY < (margin + topLabelMargin / 10.0f * 4));
  }

  boolean isLeapYear(int year) {
    if (year % 400 == 0) return true;
    else if (year % 100 == 0) return false;
    else if (year % 4 == 0) return true;
    else return false;
  }

  int getDayInMonth(int year, int month, int dayOfWeek, int num) {
    var date = new Date();
    date.setYear(year);
    date.setMonth(month);
    date.setDate(1);

    int startingDayOfMonth = date.getDay();

    return 7 * (dayOfWeek > startingDayOfMonth ? num - 1 : num) + (dayOfWeek) - startingDayOfMonth;
  }

  int lastDayInMonth(int year, int month, int dayOfWeek) {
    int daysInMonth = int(monthDays[month]);
    if (month == 1 && isLeapYear(year)) daysInMonth ++;

    var date = new Date();
    date.setYear(year);
    date.setMonth(month);
    date.setDate(daysInMonth);

    int lastDayOfMonth = date.getDay();

    return daysInMonth - (lastDayOfMonth - dayOfWeek) - (dayOfWeek - 1 > lastDayOfMonth ? 7 : 0) - 1;
  }

  void goToToday() {
    currentYear = year();
    currentMonth = month() - 1;
  }

  boolean isToday() {
    return (currentYear == year() && currentMonth == month() - 1);
  }

  boolean overTodayButton(PGraphics pg) {
    pg.textSize(12);
    float textWidth = 60;
    float textHeight = pg.textAscent() + pg.textDescent() + 20;

    int mX = (int)map(mouseX, 0, width, 0, orgW);
    int mY = (int)map(mouseY, 0, height, 0, orgH);
    return (mX > (orgW - plannerWidth) / 2.0f - textWidth / 2.0f && mX < (orgW - plannerWidth) / 2.0f + textWidth / 2.0f && mY > orgH - margin / 2.0f - textHeight / 2.0f && mY < orgH - margin / 2.0f + textHeight / 2.0f);
  }

  boolean overPlannerScroller() {
    int mX = (int)map(mouseX, 0, width, 0, orgW);
    int mY = (int)map(mouseY, 0, height, 0, orgH);
    return (mY > margin + topLabelMargin && mY < margin + topLabelMargin + calendarHeight && mX > orgW - plannerWidth - 15 && mX < orgW - plannerWidth + 5);
  }

  class Holiday extends MonthDay {
    int month;
    int day;

    Holiday(String n, int m, int d) {
      name = n;
      month = m;
      day = d;
    }

    int getMonth() {
      return month;
    }

    int getDay() {
      return day;
    }
  }

  abstract class MonthDay {
    String name;

    MonthDay() {
    }

    public String getName() {
      return name;
    }

    abstract int getMonth();
    abstract int getDay();
  }

  @Override void mousePressed() {
    if (mouseInArrowRange()) {
      if (mouseOverArrow(-2)) currentYear --;
      if (mouseOverArrow(-1)) {
        currentMonth --;
        if (currentMonth < 0) {
          currentYear --;
          currentMonth = 11;
        }
      }
      if (mouseOverArrow(1)) {
        currentMonth ++;
        if (currentMonth > 11) {
          currentYear ++;
          currentMonth = 0;
        }
      }
      if (mouseOverArrow(2)) currentYear ++;
    }
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
