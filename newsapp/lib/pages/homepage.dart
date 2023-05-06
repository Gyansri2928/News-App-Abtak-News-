import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/helper/Categorydata.dart';
import 'package:newsapp/helper/newsdata.dart';
import 'package:newsapp/model/newsmodel.dart';
import 'package:newsapp/pages/categories.dart';

//import 'package:shimmer/shimmer.dart';

import '../model/categorymodel.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //getting the categories list
  List<CategoryModel> categories=<CategoryModel>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories=getCategories();
    getNews();
  }
  List<Newsmodel> content=<Newsmodel>[];
  bool loading=true;
  getNews() async{
    News newsdata=News();
     await newsdata.getNews();
    content
    =newsdata.datatobesavedin;
    setState(() {
      loading=false;
    });
  }
  /*final _shimmer = Shimmer(
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.grey[900]!,
          Colors.grey[900]!,
          Colors.grey[800]!,
          Colors.grey[900]!,
          Colors.grey[900]!
        ],
        stops: const <double>[
          0.0,
          0.35,
          0.5,
          0.65,
          1.0
        ]),
    child: ListView(
      scrollDirection: Axis.vertical,
      children: List.generate(
          6,
              (index) => Container(
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.red,
            ),
            margin:
            const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          )),
    ),
  );*/
  Future<void> _refresh() async {
    setState(() {
      loading = true; // Show the loading indicator
    });

    // Fetch new data from the API
    News newsdata = News();
    await newsdata.getNews();

    setState(() {
      content = newsdata.datatobesavedin; // Update the content with the new data
      loading = false; // Hide the loading indicator
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black87,
        appBar: AppBar(
          elevation:0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
               Text("Abtak ",
                style:
                TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
               ),
               Text("News",
                style:
                TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
               ),
            ],
          ),
          backgroundColor: Colors.black,

        ),
      body: loading ?
        Center(child: CircularProgressIndicator(color: Colors.red,))
      : RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 70,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          return CategoryTile(
                              Categoryname: categories[index].categoryName,
                              imageurl: categories[index].imageUrl);
                        },
                    ),
                ),
                const SizedBox(height: 10,),
                Container(
                  child: ListView.builder(
                    itemCount: content.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return contenttile(
                        urltoimage: content[index].urlToImage,
                        title: content[index].title,
                        description: content[index].description,
                      );
                    },
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
class CategoryTile extends StatelessWidget {
  final String Categoryname,imageurl;
  const CategoryTile({Key? key, required this.Categoryname, required this.imageurl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Categoryfragment(
          category: Categoryname.toLowerCase(),
        )));
              },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(imageUrl:imageurl ,width: 170,height: 120,fit: BoxFit.cover,)),
            Container(
              alignment: Alignment.center,
                width: 170,height: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  color: Colors.black54
              ),
                child: Text(Categoryname,style: TextStyle(color: Colors.white60,fontSize: 16,fontWeight: FontWeight.w700),),
              ),

          ],
        ),
      ),
    );
  }
}
class contenttile extends StatelessWidget {
  String title,description,url,urltoimage;
  contenttile({Key? key,this.title='',this.description='',this.url='',this.urltoimage=''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            CachedNetworkImage(imageUrl: urltoimage,height: 200,width: 400,fit: BoxFit.cover,),
            const SizedBox(height: 8),

            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white60),),
            const SizedBox(height: 8),

            Text(description, style: TextStyle( fontSize: 15.0, color: Colors.grey.shade400,fontWeight: FontWeight.w600),),
            const SizedBox(height: 10),

          ],
        ),
    );
  }
}

