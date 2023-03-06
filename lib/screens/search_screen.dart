import 'package:appdid_test/screens/meal_details_screen.dart';
import 'package:appdid_test/utils/api_services.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  var apiServices = ApiServices();

  bool isLoading = false;
  List searchList = [];

  getSearchData({search}) async {
    setState(() {
      isLoading = true;
    });
    print(
        'link ${'https://www.themealdb.com/api/json/v1/1/search.php?s=$search'} ');
    Map<String, dynamic> data = await apiServices.getRequestApi(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=$search');

    if (data.isNotEmpty) {
      searchList = data['meals'];
    }
    print('search data  $searchList');

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: searchController,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            if (value.isNotEmpty) {
              getSearchData(search: value);
            }
          },
          onFieldSubmitted: (value) {
            if (value.isNotEmpty) {
              getSearchData(search: value);
            }
          },
          decoration: const InputDecoration(
              hintText: 'Search', hintStyle: TextStyle(color: Colors.white)),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : searchList.isEmpty
              ? const Center(
                  child: Text(
                    'Search Meals',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  itemCount: searchList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MealsDetailsScreen(
                                      getRandom: false,
                                      mealId: '${searchList[index]['idMeal']}',
                                    )));
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
                                '${searchList[index]['strMealThumb']}',
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
                                    'Category: ${searchList[index]['strCategory']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Desciption: ${searchList[index]['strMeal']}',
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
