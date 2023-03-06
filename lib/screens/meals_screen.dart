import 'package:appdid_test/screens/meal_details_screen.dart';
import 'package:appdid_test/utils/api_services.dart';
import 'package:flutter/material.dart';

class MealsScreen extends StatefulWidget {
  MealsScreen({Key? key}) : super(key: key);

  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  var apiServices = ApiServices();

  bool isLoading = false;
  List mealsList = [];

  @override
  void initState() {
    super.initState();
    getMealsData();
  }

  getMealsData() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = await apiServices.getRequestApi(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood');
    if (data.isNotEmpty) {
      mealsList = data['meals'];
    }
    print('categories data  $mealsList');

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              itemCount: mealsList.length,
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MealsDetailsScreen(
                                  mealId: '${mealsList[index]['idMeal']}',
                                  getRandom: false,
                                )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.amber[50]),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Image.network(
                              '${mealsList[index]['strMealThumb']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            '${mealsList[index]['strMeal']}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
