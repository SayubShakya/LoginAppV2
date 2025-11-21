import 'package:flutter/material.dart';

// --- Dummy Model for UI Demonstration ---
// We need these models locally since the API-related imports were removed.
class Articles {
  final String? title;
  final String? author;
  final String? publishedAt;
  final String? urlToImage;
  final String? description;

  Articles({this.title, this.author, this.publishedAt, this.urlToImage, this.description});
}

class StaticValue {
  // Placeholder article for the header section
  static Articles? clickedarticle = Articles(
    title: "The Future of Grid Layouts in Mobile UI/UX Design",
    author: "Jane Doe Tech",
    publishedAt: "2025-11-19T00:00:00Z",
    urlToImage: "https://picsum.photos/800/400?random=100", // Placeholder header image
    description: "This is a detailed description of the main article. It explains how modern applications are moving towards adaptive and responsive grid systems to provide a consistent experience across various screen sizes. The design emphasizes visual hierarchy and content-first layout strategies.",
  );
}

// Dummy list for the grid view
final List<Articles> _dummyArticles = [
  Articles(
    title: "Grid Item 1: Short Title for Vertical Card",
    author: "Dev A",
    publishedAt: "2025-11-19",
    urlToImage: "https://picsum.photos/200/100?random=1",
  ),
  Articles(
    title: "Grid Item 2: Another Interesting Piece of Content",
    author: "Writer B",
    publishedAt: "2025-11-18",
    urlToImage: "https://picsum.photos/200/100?random=2",
  ),
  Articles(
    title: "Grid Item 3: Empty Author Example",
    author: "",
    publishedAt: "2025-11-17",
    urlToImage: "https://picsum.photos/200/100?random=3",
  ),
  Articles(
    title: "Grid Item 4: Long Heading That Will Wrap or Truncate Here",
    author: "Long Name Author C",
    publishedAt: "2025-11-16",
    urlToImage: "https://picsum.photos/200/100?random=4",
  ),
  Articles(
    title: "Grid Item 5: Content Placeholder",
    author: "User D",
    publishedAt: "2025-11-15",
    urlToImage: "https://picsum.photos/200/100?random=5",
  ),
  Articles(
    title: "Grid Item 6: Final Item in Grid",
    author: "User E",
    publishedAt: "2025-11-14",
    urlToImage: "https://picsum.photos/200/100?random=6",
  ),
];
// ----------------------------------------


class detailpagegrid extends StatefulWidget {
  const detailpagegrid({super.key});

  @override
  State<detailpagegrid> createState() => _detailpagegridState();
}

class _detailpagegridState extends State<detailpagegrid> {

  // Removed apicall() and _futurenewsapicall

  Widget verticalcard(size, String heading, author, date, String url,
      Articles? article) {
    return GestureDetector(
      onTap: () {
        // NOTE: This navigation is recursive (navigating to itself),
        // which is often incorrect in a real app but is maintained
        // from the original code for structure preservation.
        StaticValue.clickedarticle = article;
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => const detailpagegrid(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 10),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                    height: 60,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                      ),
                    )),
                Container(
                  height: 60,
                  width: 150,
                  decoration: BoxDecoration(
                    // color: Colors.green,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width / 2, // This width might be too large for a typical grid item
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    heading,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    author == ""
                        ? Container()
                        : Container(
                      width: 100,
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      child: Text(
                        author,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                        width: 80,
                        child: Text(
                          date,
                          style: const TextStyle(color: Colors.black),
                          maxLines: 1,
                        ))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Removed apicall();
  }

  Widget headerelement(size) {
    // Check if clickedarticle is null (though it's initialized with dummy data)
    if (StaticValue.clickedarticle == null) {
      return const SizedBox.shrink();
    }

    // Split the date string to remove the time component, similar to the original logic
    final articleDate = StaticValue.clickedarticle!.publishedAt.toString().split("T")[0];
    // Split the author name to just get the first word, similar to the original logic
    final articleAuthor = StaticValue.clickedarticle!.author.toString().split(" ")[0];

    return Column(
      children: [
        //header element
        Stack(
          children: [
            Container(
                height: size.height / 3.5,
                width: size.width,
                child: Image.network(
                  StaticValue.clickedarticle!.urlToImage!,
                  fit: BoxFit.cover,
                )),
            Container(
              height: size.height / 3.5,
              width: size.width,
              color: Colors.transparent,
              child: const Center(
                child: Icon(
                  Icons.play_circle,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            Positioned(
                left: 15,
                top: 15,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ))),
            const Positioned(
                right: 15,
                top: 15,
                child: Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 30,
                ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            StaticValue.clickedarticle!.title!.toUpperCase(),
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        Container(
          width: size.width,
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(articleAuthor),
              Text(articleDate)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            StaticValue.clickedarticle!.description!,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.normal),
            overflow: TextOverflow.visible,
            maxLines: 7,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<Articles> articles = _dummyArticles;

    return Scaffold(
      body: Container(
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 45,
              ),
              headerelement(size),
              // --- Vertical GridView (Replaced FutureBuilder) ---
              // The original logic used FutureBuilder to fetch and then display the grid.
              // We now display the dummy list directly.
              Container(
                // Note: The original height of size.height/1.4 might cause issues if
                // headerelement is large, as SingleChildScrollView height is typically unbounded.
                // We'll use a specific height for demonstration, but using Expanded or a
                // more flexible height might be better practice.
                height: size.height / 2,
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: articles.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Changed from 4 to 2 for better visibility in a typical phone layout
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    return verticalcard(
                      size,
                      articles[index].title!,
                      articles[index].author,
                      articles[index].publishedAt,
                      articles[index].urlToImage!,
                      articles[index],
                    );
                  },
                ),
              ),
              // ----------------------------------------------------
            ],
          ),
        ),
      ),
    );
  }
}