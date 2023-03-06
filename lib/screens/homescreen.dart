import 'package:appdid_test/screens/login_screen.dart';
import 'package:appdid_test/screens/meal_details_screen.dart';
import 'package:appdid_test/screens/meals_screen.dart';
import 'package:appdid_test/screens/search_screen.dart';
import 'package:appdid_test/utils/api_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  var apiServices = ApiServices();

  bool isLoading = false;
  List categoriesList = [];

  @override
  void initState() {
    super.initState();
    getCategoriesData();
  }

  getCategoriesData() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = await apiServices.getRequestApi(
        'https://www.themealdb.com/api/json/v1/1/categories.php');
    if (data.isNotEmpty) {
      categoriesList = data['categories'];
    }
    print('categories data  $categoriesList');

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homescreen'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MealsDetailsScreen(getRandom: true)));
              },
              icon: const Icon(Icons.shuffle_on_outlined)),
          IconButton(
              onPressed: () async {
                SharedPreferences data = await SharedPreferences.getInstance();
                data.clear();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              itemCount: categoriesList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MealsScreen()));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Image.network(
                            '${categoriesList[index]['strCategoryThumb']}',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Category: ${categoriesList[index]['strCategory']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Desciption: ${categoriesList[index]['strCategoryDescription']}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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
