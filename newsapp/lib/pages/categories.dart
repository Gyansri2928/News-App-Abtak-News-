import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/helper/Categorydata.dart';
import 'package:newsapp/helper/newsdata.dart';
import 'package:newsapp/model/newsmodel.dart';
class Categoryfragment extends StatefulWidget {
  String category;
  Categoryfragment({Key? key,this.category=''}) : super(key: key);

  @override
  State<Categoryfragment> createState() => _CategoryfragmentState();
}

class _CategoryfragmentState extends State<Categoryfragment> {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews();
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
          : SingleChildScrollView(
        child: Container(
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
