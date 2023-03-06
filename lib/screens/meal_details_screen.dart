import 'package:appdid_test/utils/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class MealsDetailsScreen extends StatefulWidget {
  String? mealId;
  bool getRandom;
  MealsDetailsScreen({Key? key, this.mealId, required this.getRandom})
      : super(key: key);

  @override
  _MealsDetailsScreenState createState() => _MealsDetailsScreenState();
}

class _MealsDetailsScreenState extends State<MealsDetailsScreen> {
  var apiServices = ApiServices();

  bool isLoading = false;
  List mealsDetails = [];

  @override
  void initState() {
    super.initState();
    widget.getRandom
        ? getRandomMealDetails()
        : getMealDetails(mealID: widget.mealId);
  }

  getMealDetails({mealID}) async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = await apiServices.getRequestApi(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealID');
    if (data.isNotEmpty) {
      mealsDetails = data['meals'];
    }
    print('meal data  $mealsDetails');

    setState(() {
      isLoading = false;
    });
  }

  getRandomMealDetails() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = await apiServices
        .getRequestApi('https://www.themealdb.com/api/json/v1/1/random.php');
    if (data.isNotEmpty) {
      mealsDetails = data['meals'];
    }
    print('meal data  $mealsDetails');

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          IconButton(
              onPressed: () async {
                await FlutterShare.share(
                  title: '${mealsDetails[0]['strCategory']}',
                  text: '${mealsDetails[0]['strInstructions']}',
                  linkUrl: '${mealsDetails[0]['strYoutube']}',
                );
              },
              icon: const Icon(Icons.share))
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: double.infinity,
                    child: Image.network(
                      '${mealsDetails[0]['strMealThumb']}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                        ),
                        child: Text(
                          'Category: ${mealsDetails[0]['strCategory']}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          right: 16,
                        ),
                        child: Text(
                          'From: ${mealsDetails[0]['strArea']}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16),
                    child: Text(
                      'Tags: ${mealsDetails[0]['strTags']}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Instructions:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '${mealsDetails[0]['strInstructions']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
