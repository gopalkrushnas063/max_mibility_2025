import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:max_mobility_assignment/controller/my_homepage_controller.dart';
import 'package:max_mobility_assignment/screen/AddUser.dart';
import 'package:max_mobility_assignment/screen/EditUser.dart';
import 'package:max_mobility_assignment/screen/ViewUsers.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Max Mobility UMS",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        
      ),
      body: GetX<MyHomePageController>(
        init: MyHomePageController(),
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final userCount = controller.userList.length;

          // Example statistics - count users with names starting with A-M vs N-Z
          int amCount =
              controller.userList.where((user) {
                if (user.name == null || user.name!.isEmpty) return false;
                return user.name!.toLowerCase().codeUnitAt(0) <=
                    'm'.codeUnitAt(0);
              }).length;

          int nzCount = userCount - amCount;

          return Column(
            children: [
              // Statistics Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'User Statistics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem('Total', userCount, Colors.lightGreen),
                            _StatItem('A-M Names', amCount, Colors.blue),
                            _StatItem('N-Z Names', nzCount, Colors.purple),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: userCount.toDouble(),
                              barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          ['Total', 'A-M', 'N-Z'][value
                                              .toInt()],
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      toY: userCount.toDouble(),
                                      color: Colors.lightGreen,
                                      width: 30,
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      toY: amCount.toDouble(),
                                      color: Colors.blue,
                                      width: 30,
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 2,
                                  barRods: [
                                    BarChartRodData(
                                      toY: nzCount.toDouble(),
                                      color: Colors.purple,
                                      width: 30,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Users List Section (same as before)
              Expanded(
                child:
                    controller.userList.isEmpty
                        ? const Center(
                          child: Text(
                            'No Users Available',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        )
                        : ListView.builder(
                          itemCount: controller.userList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 10,
                              ),
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    Get.to(
                                      () => ViewUser(
                                        user: controller.userList[index],
                                      ),
                                    );
                                  },
                                  leading: Image.file(
                                    File(controller.userList[index].imagePath!),
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(
                                    controller.userList[index].name ?? '',
                                  ),
                                  subtitle: Text(
                                    controller.userList[index].contact ?? '',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Get.to(
                                            () => EditUser(
                                              user: controller.userList[index],
                                            ),
                                          )!.then((data) {
                                            if (data != null) {
                                              controller.getAllUserDetails();
                                              Get.snackbar(
                                                'Success',
                                                'User Detail Updated Successfully',
                                              );
                                            }
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.confirm,
                                            title: 'Delete User',
                                            text:
                                                'Are you sure you want to delete this user?',
                                            confirmBtnText: 'Yes',
                                            cancelBtnText: 'No',
                                            confirmBtnColor: Colors.red,
                                            onConfirmBtnTap: () {
                                              Navigator.pop(
                                                context,
                                              ); // Close the dialog
                                              controller.deleteUser(
                                                controller.userList[index].id ??
                                                    0,
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen[100],
        onPressed: () {
          Get.to(() => AddUser())!.then((data) {
            if (data != null) {
              Get.find<MyHomePageController>().getAllUserDetails();
              Get.snackbar('Success', 'User Detail Added Successfully');
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatItem(this.label, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
