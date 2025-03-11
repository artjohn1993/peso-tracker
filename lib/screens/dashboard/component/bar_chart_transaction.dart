// ignore_for_file: must_be_immutable

import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:peso_tracker/model/weekly_model.dart';

class BarChartTransaction extends StatefulWidget {
  const BarChartTransaction({super.key, required this.weeklyTransaction});
  final Color leftBarColor = Colors.red;
  final Color rightBarColor = Colors.green;
  final Color avgColor = Colors.purple;
  final List<WeeklyModel> weeklyTransaction;
  @override
  State<StatefulWidget> createState() => BarChartTransactionState();
}

class BarChartTransactionState extends State<BarChartTransaction> {
  final double width = 7;
  double totalMax = 10000;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.weeklyTransaction.isEmpty) return Container();

    // var filteredIncome = widget.weeklyTransaction.reduce((current, next) => current.income > next.income ? current : next);
    // var filteredExpenses = widget.weeklyTransaction.reduce((current, next) => current.expenses > next.expenses ? current : next);
    // var maxIncome = filteredIncome.income == 0 ? 1 : filteredIncome.income;
    // var maxExpenses = filteredExpenses.expenses == 0 ? 1 : filteredExpenses.expenses;
    // var totalMax = maxIncome > maxExpenses ? maxIncome : maxExpenses;

    final barGroup1 = makeGroupData(
        0,
        calculatePoint(widget.weeklyTransaction[0].expenses),
        calculatePoint(widget.weeklyTransaction[0].income));
    final barGroup2 = makeGroupData(
        1,
        calculatePoint(widget.weeklyTransaction[1].expenses),
        calculatePoint(widget.weeklyTransaction[1].income));
    final barGroup3 = makeGroupData(
        2,
        calculatePoint(widget.weeklyTransaction[2].expenses),
        calculatePoint(widget.weeklyTransaction[2].income));
    final barGroup4 = makeGroupData(
        3,
        calculatePoint(widget.weeklyTransaction[3].expenses),
        calculatePoint(widget.weeklyTransaction[3].income));
    final barGroup5 = makeGroupData(
        4,
        calculatePoint(widget.weeklyTransaction[4].expenses),
        calculatePoint(widget.weeklyTransaction[4].income));
    final barGroup6 = makeGroupData(
        5,
        calculatePoint(widget.weeklyTransaction[5].expenses),
        calculatePoint(widget.weeklyTransaction[5].income));
    final barGroup7 = makeGroupData(
        6,
        calculatePoint(widget.weeklyTransaction[6].expenses),
        calculatePoint(widget.weeklyTransaction[6].income));

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;

    return Card(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'Weekly Transaction Overview',
                        maxLines: 1,
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: 20,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: ((group) {
                          return Colors.grey;
                        }),
                        getTooltipItem: (a, b, c, d) => null,
                      ),
                      touchCallback: (FlTouchEvent event, response) {
                        if (response == null || response.spot == null) {
                          setState(() {
                            touchedGroupIndex = -1;
                            showingBarGroups = List.of(rawBarGroups);
                          });
                          return;
                        }

                        touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                        setState(() {
                          if (!event.isInterestedForInteractions) {
                            touchedGroupIndex = -1;
                            showingBarGroups = List.of(rawBarGroups);
                            return;
                          }
                          showingBarGroups = List.of(rawBarGroups);
                          if (touchedGroupIndex != -1) {
                            var sum = 0.0;
                            for (final rod
                                in showingBarGroups[touchedGroupIndex]
                                    .barRods) {
                              sum += rod.toY;
                            }
                            final avg = sum /
                                showingBarGroups[touchedGroupIndex]
                                    .barRods
                                    .length;

                            showingBarGroups[touchedGroupIndex] =
                                showingBarGroups[touchedGroupIndex].copyWith(
                              barRods: showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .map((rod) {
                                return rod.copyWith(
                                    toY: avg, color: widget.avgColor);
                              }).toList(),
                            );
                          }
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                          reservedSize: 42,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 1,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: showingBarGroups,
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculatePoint(double transaction) {
    var total = (transaction / totalMax) * 20;
    return total > 20 ? 20 : total;
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1K';
    } else if (value == 10) {
      text = '5K';
    } else if (value == 19) {
      text = '10K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      meta: meta,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      meta: meta,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }
}
